Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:41392 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979AbYJKAaz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 20:30:55 -0400
Date: Sat, 11 Oct 2008 03:29:55 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Fix scan RX processing oops
Message-ID: <20081011002955.GA15802@jm.kir.nu> (sfid-20081011_023059_186304_86C6664B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_bss_info_update() can return NULL. Verify that this is not the
case before calling ieee802111_rx_bss_put() which would trigger an oops
in interrupt context in atomic_dec_and_lock().

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>


Index: wireless-testing/net/mac80211/scan.c
===================================================================
--- wireless-testing.orig/net/mac80211/scan.c
+++ wireless-testing/net/mac80211/scan.c
@@ -388,7 +388,8 @@ ieee80211_scan_rx(struct ieee80211_sub_i
 	bss = ieee80211_bss_info_update(sdata->local, rx_status,
 					mgmt, skb->len, &elems,
 					freq, beacon);
-	ieee80211_rx_bss_put(sdata->local, bss);
+	if (bss)
+		ieee80211_rx_bss_put(sdata->local, bss);
 
 	dev_kfree_skb(skb);
 	return RX_QUEUED;

-- 
Jouni Malinen                                            PGP id EFC895FA
