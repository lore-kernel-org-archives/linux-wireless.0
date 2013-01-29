Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46098 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396Ab3A2Lh3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 06:37:29 -0500
Message-ID: <1359459469.8108.11.camel@jlt4.sipsolutions.net> (sfid-20130129_123738_342263_F9870CA4)
Subject: Re: [PATCHv3 2/2] mac80211: in AD-HOC mode wait for the AUTH
 response
From: Johannes Berg <johannes@sipsolutions.net>
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
Cc: Antonio Quartulli <antonio@open-mesh.com>,
	linux-wireless@vger.kernel.org,
	Will Hawkins <hawkinsw@opentechinstitute.org>
Date: Tue, 29 Jan 2013 12:37:49 +0100
In-Reply-To: <5103C774.4080403@lri.fr>
References: <1355146824-25012-1-git-send-email-antonio@open-mesh.com>
	  <1355146824-25012-2-git-send-email-antonio@open-mesh.com>
	  <1356706268.9922.23.camel@jlt4.sipsolutions.net>
	  <20130102063255.GA27676@open-mesh.com> <50E400A7.5060100@lri.fr>
	  <20130107114048.GH27589@ritirata.org> <50EACA95.8040004@lri.fr>
	 <1359151524.4655.37.camel@jlt4.sipsolutions.net> <5103C774.4080403@lri.fr>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-01-26 at 13:09 +0100, Nicolas Cavallari wrote:

> Yes, this is what wpasupplicant assumes: When a station is added, it is
> already authenticated. So wpasupplicant does not wait before sending
> handshakes.
> 
> This causes problem with the current kernel's behavior to send auth
> frames, because it can race: wpasupplicant sometimes send it's first 1/4
> handshake before the kernel's auth frame. If the peer runs Linux with
> the reboot detection, it is utterly confused : the peer's wpasupplicant
> receives the 1/4 frame, answers it with 2/4, then the peer's kernel
> receives the auth frames, and resets the station, discarding the state
> of wpasupplicant, which no longer knows that it has started a handshake.
> 
> Meanwhile, on the other host, wpasupplicant happily receives the 2/4
> response, and proceed with sending 3/4 frame. Then there is utter
> confusion, because the other host does not know what to do with
> handshake 3/4 and drops it.
> 
> This is what the current patch tries to fix : by making wpasupplicant
> waits for the kernel to tell it that it has completed an open system
> authentication. This requires patch to both.

Ok I guess that explains it a little better.

> (and my take on this, is that we should just handle open system
> authentication and reboot detection in userspace (i have code for that),
> and revert the kernel to the old state where it would just answers an
> open system authentication request if userspace is not handling it)

I think that would make sense. However, to really implement that it
seems that wpa_s should be able to control the in-kernel station
"authenticated" state, not just "authorized" state?

What's the status we have today in the kernel, without the patches, and
what would that "revert" mean?

> This patch (under the case when userspace is not handling auth frames)
> defers authentication until an open system authentication is done or has
> timed out, and uses a new event (IBSS_STA) to indicate that a station is
> authenticated.
> 
> But if you use the patched kernel with the current (unpatched)
> wpasupplicant, wpasupplicant will still send handshakes right after a
> station is added, even if the station is not authenticated. With enough
> bad luck, the open system authentication request or response can be
> lost, and wpa_supplicant might complete a handshake before the kernel's
> open system authentication timeout, therefore, wpasupplicant would ask
> the kernel to authorize a station which is even not authenticated.
> 
> (and if you use a patched wpasupplicant with an unpatched kernel, it
> will just wait for an event which will never happen)

Yeah, both of these cases are really bad, in particular since there's no
way for wpa_s to detect this, and it breaks backward compatibility. I
guess I just made up my mind that I'm not going to apply this.

What changes could we make today to solve this in a way that's
compatible with today's wpa_supplicant (and maybe Will's SAE
implementation, though maybe he wouldn't mind small changes too much)?

johannes

