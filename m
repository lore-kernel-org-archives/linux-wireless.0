Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f167.google.com ([209.85.220.167]:56904 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbZBWNF3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 08:05:29 -0500
Received: by fxm11 with SMTP id 11so1712499fxm.13
        for <linux-wireless@vger.kernel.org>; Mon, 23 Feb 2009 05:05:27 -0800 (PST)
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: ieee80211_scan_completed() calling config() and possible deadlock
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 23 Feb 2009 15:05:20 +0200
Message-ID: <87vdr1717z.fsf@litku.valot.fi> (sfid-20090223_140535_039225_65473FC5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I'm currently wondering how to implement the locking
ieee80211_scan_completed() and I would like hear comments from people.

In wl12xx and at76c50x-usb the locking was originally implemented such
that drivers' config() function acquired a mutex. Also elsewhere the
drivers called ieee80211_scan_completed() under the same mutex. As we
know, ieee80211_scan_completed() calls ieee80211_hw_config() which
again calls driver's config() function. So this ended up to a
deadlock. The problem was easy to fix, just release the mutex in the
driver before calling the completed() function.

Now I need to add a similar function, currently named
ieee80211_beacon_loss(), for the beacon filtering patches I'm working
on. The function will disassociate whenever driver calls it. While
experimenting with stlc45xx I noticed that I have a similar problem as
with ieee80211_scan_completed(), ieee80211_beacon_loss() calls
driver's config() function eventually and I had a deadlock in stlc45xx.

I'm just wondering what's the right way(tm) to handle this. I see two
options:

1. Consider the (possible) deadlock as a feature, document it and let
   the drivers handle it. This is relatively easy.

2. Handle this in mac80211 (eg. schedule a workqueue) and drivers
   don't need to care. This might complicate mac80211 implementation a
   bit, but easier for the drivers.

I myself cannot decide which one is better. What do people think? 

-- 
Kalle Valo
