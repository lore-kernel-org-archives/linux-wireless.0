Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46051 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757727Ab3CUMVo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Mar 2013 08:21:44 -0400
Message-ID: <1363868498.8181.0.camel@jlt4.sipsolutions.net> (sfid-20130321_132151_773678_DD8A8B4C)
Subject: Re: rcutree tree warning during P2P device support testing
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: hostap@lists.shmoo.com, linux-wireless@vger.kernel.org,
	David Spinadel <dvdspndl@gmail.com>
Date: Thu, 21 Mar 2013 13:21:38 +0100
In-Reply-To: <514AF761.7070607@broadcom.com>
References: <5149CD81.40301@broadcom.com>
	 <1363792139.8224.10.camel@jlt4.sipsolutions.net>
	 <514A274F.5030303@broadcom.com>
	 <1363814947.9284.10.camel@jlt4.sipsolutions.net>
	 <514A2E47.7080108@broadcom.com> <514AF761.7070607@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-03-21 at 13:04 +0100, Arend van Spriel wrote:

> >>> The p2p device is already removed upon stopping wpa_supplicant through
> >>> .del_virtual_intf() callback. Took a quick peek in
> >>> net/mac80211/iface.c:ieee80211_if_remove() and wonder whether I should
> >>> do cfg80211_unregister_wdev() in that code path as well. Guess so, right?
> >>
> >> I think so, yes. Does the warning go away if you do? :)
> > 
> > Not tested yet.
> 
> That did the trick. Apparently, wpa_s/driver_nl80211 does not do a
> stop_p2p_device. That is triggered by cfg80211_unregister_wdev(). Should
> wpa_s do the stop_p2p_device before deleting it or is the current
> behaviour fine.

It's fine, the kernel has to be able to handle it anyway, but there's a
small bug in this area that I'm trying to fix now.

johannes

