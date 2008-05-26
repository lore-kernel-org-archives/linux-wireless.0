Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55470 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325AbYEZOqP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2008 10:46:15 -0400
Subject: [PATCH] p54: fix skb->cb tx info conversion
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Chr <chunkeey@web.de>
Content-Type: text/plain
Date: Mon, 26 May 2008 16:44:59 +0200
Message-Id: <1211813099.4843.12.camel@johannes.berg> (sfid-20080526_164617_554554_82F5FACA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When I moved the TX info into skb->cb apparently I forgot to change a
few places to put the p54-internal data into info->driver_data rather
than skb->cb. This should fix it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/p54/p54common.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- everything.orig/drivers/net/wireless/p54/p54common.c	2008-05-26 09:42:49.000000000 +0200
+++ everything/drivers/net/wireless/p54/p54common.c	2008-05-26 09:44:40.000000000 +0200
@@ -392,16 +392,20 @@ static void p54_rx_frame_sent(struct iee
 	u32 last_addr = priv->rx_start;
 
 	while (entry != (struct sk_buff *)&priv->tx_queue) {
-		range = (struct memrecord *)&entry->cb;
+		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(entry);
+		range = (void *)info->driver_data;
 		if (range->start_addr == addr) {
-			struct ieee80211_tx_info *info = IEEE80211_SKB_CB(entry);
 			struct p54_control_hdr *entry_hdr;
 			struct p54_tx_control_allocdata *entry_data;
 			int pad = 0;
 
-			if (entry->next != (struct sk_buff *)&priv->tx_queue)
-				freed = ((struct memrecord *)&entry->next->cb)->start_addr - last_addr;
-			else
+			if (entry->next != (struct sk_buff *)&priv->tx_queue) {
+				struct ieee80211_tx_info *ni;
+
+				ni = IEEE80211_SKB_CB(entry->next);
+				freed = ((void *)ni->driver_data)->start_addr
+						- last_addr;
+			} else
 				freed = priv->rx_end - last_addr;
 
 			last_addr = range->end_addr;


