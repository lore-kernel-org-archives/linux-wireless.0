Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:54570 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755036AbZEERgB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2009 13:36:01 -0400
Message-Id: <20090505173554.426684779@atheros.com>
References: <20090505173512.349795688@atheros.com>
Date: Tue, 05 May 2009 20:35:15 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 3/3] mac80211: Comment the order of HT RX reorder handler vs. RX handlers
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We are currently processing block ack reordering as a separate task
before all other RX handlers. In theory, this is wrong since this step
should be done only after duplicate removal (see Figure 6-1 in IEEE
802.11n). However, moving this needs some work and the current
situation is not too bad. Add a comment here so that this small detail
does not get forgotten and who knows, maybe someone has some extra
time to take a look at cleaning this up.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 net/mac80211/rx.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- wireless-testing.orig/net/mac80211/rx.c	2009-05-05 20:21:33.000000000 +0300
+++ wireless-testing/net/mac80211/rx.c	2009-05-05 20:21:39.000000000 +0300
@@ -2551,6 +2551,18 @@ void __ieee80211_rx(struct ieee80211_hw 
 		return;
 	}
 
+	/*
+	 * In theory, the block ack reordering should happen after duplicate
+	 * removal (ieee80211_rx_h_check(), which is an RX handler). As such,
+	 * the call to ieee80211_rx_reorder_ampdu() should really be moved to
+	 * happen as a new RX handler between ieee80211_rx_h_check and
+	 * ieee80211_rx_h_decrypt. This cleanup may eventually happen, but for
+	 * the time being, the call can be here since RX reorder buf processing
+	 * will implicitly skip duplicates. We could, in theory at least,
+	 * process frames that ieee80211_rx_h_passive_scan would drop (e.g.,
+	 * frames from other than operational channel), but that should not
+	 * happen in normal networks.
+	 */
 	if (!ieee80211_rx_reorder_ampdu(local, skb, status))
 		__ieee80211_rx_handle_packet(hw, skb, status, rate);
 

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
