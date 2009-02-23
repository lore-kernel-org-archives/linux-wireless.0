Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:45750 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbZBWNPk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 08:15:40 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Kalle Valo <kalle.valo@iki.fi>
Subject: Re: ieee80211_scan_completed() calling config() and possible deadlock
Date: Mon, 23 Feb 2009 14:13:49 +0100
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
References: <87vdr1717z.fsf@litku.valot.fi>
In-Reply-To: <87vdr1717z.fsf@litku.valot.fi>
MIME-Version: 1.0
Message-Id: <200902231413.49289.mb@bu3sch.de> (sfid-20090223_141544_910431_57AAC0E0)
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 23 February 2009 14:05:20 Kalle Valo wrote:
> Hello,
> 
> I'm currently wondering how to implement the locking
> ieee80211_scan_completed() and I would like hear comments from people.
> 
> In wl12xx and at76c50x-usb the locking was originally implemented such
> that drivers' config() function acquired a mutex. Also elsewhere the
> drivers called ieee80211_scan_completed() under the same mutex. As we
> know, ieee80211_scan_completed() calls ieee80211_hw_config() which
> again calls driver's config() function. So this ended up to a
> deadlock. The problem was easy to fix, just release the mutex in the
> driver before calling the completed() function.
> 
> Now I need to add a similar function, currently named
> ieee80211_beacon_loss(), for the beacon filtering patches I'm working
> on. The function will disassociate whenever driver calls it. While
> experimenting with stlc45xx I noticed that I have a similar problem as
> with ieee80211_scan_completed(), ieee80211_beacon_loss() calls
> driver's config() function eventually and I had a deadlock in stlc45xx.
> 
> I'm just wondering what's the right way(tm) to handle this. I see two
> options:
> 
> 1. Consider the (possible) deadlock as a feature, document it and let
>    the drivers handle it. This is relatively easy.
> 
> 2. Handle this in mac80211 (eg. schedule a workqueue) and drivers
>    don't need to care. This might complicate mac80211 implementation a
>    bit, but easier for the drivers.
> 
> I myself cannot decide which one is better. What do people think? 
> 

I think drivers should not be able to call ieee80211_scan_completed() directly.
Instead they should call a function which schedules ieee80211_scan_completed()
on a workqueue.
In general I consider it broken behavior, if a function called by
the driver can recurse into the driver.
We had that behavior in ieee80211-softmac and it was one of the main
reasons it sucked so much.

The wq schedule code is trivial to implement in mac80211 and it's also OK
to do so. The function is not required to execute synchronously.

-- 
Greetings, Michael.
