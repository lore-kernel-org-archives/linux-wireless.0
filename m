Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.u-psud.fr ([129.175.33.41]:50197 "EHLO smtp1.u-psud.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464Ab3AZMJt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2013 07:09:49 -0500
Message-ID: <5103C774.4080403@lri.fr> (sfid-20130126_130952_589085_002012D2)
Date: Sat, 26 Jan 2013 13:09:24 +0100
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>,
	Antonio Quartulli <antonio@open-mesh.com>,
	linux-wireless@vger.kernel.org,
	Will Hawkins <hawkinsw@opentechinstitute.org>
Subject: Re: [PATCHv3 2/2] mac80211: in AD-HOC mode wait for the AUTH response
References: <1355146824-25012-1-git-send-email-antonio@open-mesh.com>  <1355146824-25012-2-git-send-email-antonio@open-mesh.com>  <1356706268.9922.23.camel@jlt4.sipsolutions.net>  <20130102063255.GA27676@open-mesh.com> <50E400A7.5060100@lri.fr>  <20130107114048.GH27589@ritirata.org> <50EACA95.8040004@lri.fr> <1359151524.4655.37.camel@jlt4.sipsolutions.net>
In-Reply-To: <1359151524.4655.37.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=windows-1251
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25/01/2013 23:05, Johannes Berg wrote:
> On Mon, 2013-01-07 at 14:16 +0100, Nicolas Cavallari wrote:
> 
>>> if the userspace did not register for auth frames, then authentication will be
>>> handled in the kernel (as I'm doing/changing now), while if the userspace
>>> registered for such frames, then the kernel will assume that the authentication
>>> will be handled by the userspace somehow and will not deal with it (but again,
>>> in this way we need a command to let userspace set the AUTHenticated flag on a
>>> station).
>>
>> That means two implementations, not one.
>>
>> And even with this current patch, old wpasupplicant starts 4 way handshake as soon as the
>> NEW_STA event is received, even if the station is not authenticated by the kernel. I
>> expect that some EAPOL frames will be dropped as a result.
> 
> That's all very confusing to me.
> 
> Today, we have basically two ways of operating, userspace-authorization
> or open network. Neither of them requires AUTH frames, except SAE which
> uses them in userspace.
> 
> In either case, there are a few ways a station can be added:
> 1) when mac80211 receives a data frame from a station matching the BSSID
> 2) when mac80211 receives a proper open network authentication frame
>    from the station (except this is bypassed in SAE, since then
>    userspace gets all authentication frames instead of mac80211)
> 3) when mac80211 receives a beacon or probe response from a station
> 
> In all of these cases, the station is marked as authenticated (and
> associated for internal purposes, as this doesn't really exist in IBSS.)
> Authorization can be deferred to userspace, or done inline, depending on
> the "control port" setting.

Yes, this is what wpasupplicant assumes: When a station is added, it is
already authenticated. So wpasupplicant does not wait before sending
handshakes.

This causes problem with the current kernel's behavior to send auth
frames, because it can race: wpasupplicant sometimes send it's first 1/4
handshake before the kernel's auth frame. If the peer runs Linux with
the reboot detection, it is utterly confused : the peer's wpasupplicant
receives the 1/4 frame, answers it with 2/4, then the peer's kernel
receives the auth frames, and resets the station, discarding the state
of wpasupplicant, which no longer knows that it has started a handshake.

Meanwhile, on the other host, wpasupplicant happily receives the 2/4
response, and proceed with sending 3/4 frame. Then there is utter
confusion, because the other host does not know what to do with
handshake 3/4 and drops it.

This is what the current patch tries to fix : by making wpasupplicant
waits for the kernel to tell it that it has completed an open system
authentication. This requires patch to both.

(and my take on this, is that we should just handle open system
authentication and reboot detection in userspace (i have code for that),
and revert the kernel to the old state where it would just answers an
open system authentication request if userspace is not handling it)

> I think part of the reason this particular patch is so confusing is that
> it changes the semantics of when we add another station, based on our
> own authenticating with it? That's pretty confusing.

This patch (under the case when userspace is not handling auth frames)
defers authentication until an open system authentication is done or has
timed out, and uses a new event (IBSS_STA) to indicate that a station is
authenticated.

But if you use the patched kernel with the current (unpatched)
wpasupplicant, wpasupplicant will still send handshakes right after a
station is added, even if the station is not authenticated. With enough
bad luck, the open system authentication request or response can be
lost, and wpa_supplicant might complete a handshake before the kernel's
open system authentication timeout, therefore, wpasupplicant would ask
the kernel to authorize a station which is even not authenticated.

(and if you use a patched wpasupplicant with an unpatched kernel, it
will just wait for an event which will never happen)

> The point, I thought, was to detect when a peer "silently rebooted" and
> thus lost all state. But in that case wouldn't we receive an unencrypted
> RSN handshake frame from the station, and be able to recover based on
> that?

wpa_supplicant does not know if an received EAPOL frame was encrypted or
not, so will merely assume that this is just a key renewal, and will
send encrypted responses and keep the old keys until completed.

(and if i remember correctly, Jouni disagreed with this solution a long
time ago, but i can't find the message saying it)
