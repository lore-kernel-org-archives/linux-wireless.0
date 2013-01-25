Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60255 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145Ab3AYWFE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 17:05:04 -0500
Message-ID: <1359151524.4655.37.camel@jlt4.sipsolutions.net> (sfid-20130125_230507_957713_1C94E128)
Subject: Re: [PATCHv3 2/2] mac80211: in AD-HOC mode wait for the AUTH
 response
From: Johannes Berg <johannes@sipsolutions.net>
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
Cc: Antonio Quartulli <antonio@open-mesh.com>,
	linux-wireless@vger.kernel.org,
	Will Hawkins <hawkinsw@opentechinstitute.org>
Date: Fri, 25 Jan 2013 23:05:24 +0100
In-Reply-To: <50EACA95.8040004@lri.fr>
References: <1355146824-25012-1-git-send-email-antonio@open-mesh.com>
	 <1355146824-25012-2-git-send-email-antonio@open-mesh.com>
	 <1356706268.9922.23.camel@jlt4.sipsolutions.net>
	 <20130102063255.GA27676@open-mesh.com> <50E400A7.5060100@lri.fr>
	 <20130107114048.GH27589@ritirata.org> <50EACA95.8040004@lri.fr>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-01-07 at 14:16 +0100, Nicolas Cavallari wrote:

> > if the userspace did not register for auth frames, then authentication will be
> > handled in the kernel (as I'm doing/changing now), while if the userspace
> > registered for such frames, then the kernel will assume that the authentication
> > will be handled by the userspace somehow and will not deal with it (but again,
> > in this way we need a command to let userspace set the AUTHenticated flag on a
> > station).
> 
> That means two implementations, not one.
> 
> And even with this current patch, old wpasupplicant starts 4 way handshake as soon as the
> NEW_STA event is received, even if the station is not authenticated by the kernel. I
> expect that some EAPOL frames will be dropped as a result.

That's all very confusing to me.

Today, we have basically two ways of operating, userspace-authorization
or open network. Neither of them requires AUTH frames, except SAE which
uses them in userspace.

In either case, there are a few ways a station can be added:
1) when mac80211 receives a data frame from a station matching the BSSID
2) when mac80211 receives a proper open network authentication frame
   from the station (except this is bypassed in SAE, since then
   userspace gets all authentication frames instead of mac80211)
3) when mac80211 receives a beacon or probe response from a station

In all of these cases, the station is marked as authenticated (and
associated for internal purposes, as this doesn't really exist in IBSS.)
Authorization can be deferred to userspace, or done inline, depending on
the "control port" setting.


I think part of the reason this particular patch is so confusing is that
it changes the semantics of when we add another station, based on our
own authenticating with it? That's pretty confusing.

The point, I thought, was to detect when a peer "silently rebooted" and
thus lost all state. But in that case wouldn't we receive an unencrypted
RSN handshake frame from the station, and be able to recover based on
that?

johannes

