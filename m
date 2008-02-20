Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60425 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbYBTSc3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2008 13:32:29 -0500
Subject: [PATCH] zd1211rw: fix sparse warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 12:09:25 +0100
Message-Id: <1203505765.17534.31.camel@johannes.berg> (sfid-20080220_183232_963470_DA03D33C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This silences sparse when run on zd1211rw.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/zd1211rw/zd_mac.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- everything.orig/drivers/net/wireless/zd1211rw/zd_mac.c	2008-02-20 11:58:51.000000000 +0100
+++ everything/drivers/net/wireless/zd1211rw/zd_mac.c	2008-02-20 11:59:36.000000000 +0100
@@ -345,11 +345,14 @@ void zd_mac_tx_failed(struct ieee80211_h
 {
 	struct sk_buff_head *q = &zd_hw_mac(hw)->ack_wait_queue;
 	struct sk_buff *skb;
-	struct ieee80211_tx_status status = {{0}};
+	struct ieee80211_tx_status status;
 
 	skb = skb_dequeue(q);
 	if (skb == NULL)
 		return;
+
+	memset(&status, 0, sizeof(status));
+
 	tx_status(hw, skb, &status, 0);
 }
 
@@ -374,7 +377,8 @@ void zd_mac_tx_to_dev(struct sk_buff *sk
 		if (unlikely(error ||
 		    (cb->control->flags & IEEE80211_TXCTL_NO_ACK)))
 		{
-			struct ieee80211_tx_status status = {{0}};
+			struct ieee80211_tx_status status;
+			memset(&status, 0, sizeof(status));
 			tx_status(hw, skb, &status, !error);
 		} else {
 			struct sk_buff_head *q =
@@ -590,7 +594,9 @@ static int filter_ack(struct ieee80211_h
 		tx_hdr = (struct ieee80211_hdr *)skb->data;
 		if (likely(!compare_ether_addr(tx_hdr->addr2, rx_hdr->addr1)))
 		{
-			struct ieee80211_tx_status status = {{0}};
+			struct ieee80211_tx_status status;
+
+			memset(&status, 0, sizeof(status));
 			status.flags = IEEE80211_TX_STATUS_ACK;
 			status.ack_signal = stats->ssi;
 			__skb_unlink(skb, q);


