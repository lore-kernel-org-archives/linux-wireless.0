Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:55331
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757600AbXGBUgb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2007 16:36:31 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Jiri Benc <jbenc@suse.cz>
Subject: [PATCH RFC] mac80211: Make stop_queues() usable
Date: Mon, 2 Jul 2007 22:35:38 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200707022235.38791.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

stop_queues() is currently not usable, as it races with
the TX path and generates hard to debug system freezes.

In the driver we must be able to stop and flush (!) the
TX queues before we shutdown the device.
Otherwise the TX handlers race against the device shutdown.
But stop_queues lacks some locking against the TX handlers.

stop_queues is only safe to call inside of the TX handler,
but there's it's useless to call.

I have no idea what's needed to get this working properly,
so here's an untested patch for RFC.


Index: mac80211/net/mac80211/ieee80211.c
===================================================================
--- mac80211.orig/net/mac80211/ieee80211.c	2007-06-25 17:32:32.000000000 +0200
+++ mac80211/net/mac80211/ieee80211.c	2007-07-02 22:29:03.000000000 +0200
@@ -5063,10 +5063,14 @@ EXPORT_SYMBOL(ieee80211_start_queues);
 
 void ieee80211_stop_queues(struct ieee80211_hw *hw)
 {
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct net_device *mdev = local->mdev;
 	int i;
 
+	netif_tx_lock_bh(mdev);
 	for (i = 0; i < hw->queues; i++)
 		ieee80211_stop_queue(hw, i);
+	netif_tx_unlock_bh(mdev);
 }
 EXPORT_SYMBOL(ieee80211_stop_queues);
 

-- 
Greetings Michael.
