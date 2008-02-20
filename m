Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60393 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbYBTSbs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2008 13:31:48 -0500
Subject: [PATCH] rtl818x: fix sparse warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Andrea Merello <andreamrl@tiscali.it>,
	Michael Wu <flamingice@sourmilk.net>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 12:05:59 +0100
Message-Id: <1203505559.17534.22.camel@johannes.berg> (sfid-20080220_183151_053516_3B40F5BE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This silences a few sparse warnings. There are two more where
I can't follow the code.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/rtl8180_dev.c |    8 +++++---
 drivers/net/wireless/rtl8187_dev.c |    4 +++-
 2 files changed, 8 insertions(+), 4 deletions(-)

--- everything.orig/drivers/net/wireless/rtl8180_dev.c	2008-02-20 11:48:07.000000000 +0100
+++ everything/drivers/net/wireless/rtl8180_dev.c	2008-02-20 11:49:47.000000000 +0100
@@ -170,13 +170,15 @@ static void rtl8180_handle_tx(struct iee
 	while (skb_queue_len(&ring->queue)) {
 		struct rtl8180_tx_desc *entry = &ring->desc[ring->idx];
 		struct sk_buff *skb;
-		struct ieee80211_tx_status status = { {0} };
+		struct ieee80211_tx_status status;
 		struct ieee80211_tx_control *control;
 		u32 flags = le32_to_cpu(entry->flags);
 
 		if (flags & RTL8180_TX_DESC_FLAG_OWN)
 			return;
 
+		memset(&status, 0, sizeof(status));
+
 		ring->idx = (ring->idx + 1) % ring->entries;
 		skb = __skb_dequeue(&ring->queue);
 		pci_unmap_single(priv->pdev, le32_to_cpu(entry->tx_buf),
--- everything.orig/drivers/net/wireless/rtl8187_dev.c	2008-02-20 11:50:04.000000000 +0100
+++ everything/drivers/net/wireless/rtl8187_dev.c	2008-02-20 11:50:19.000000000 +0100
@@ -145,10 +145,12 @@ void rtl8187_write_phy(struct ieee80211_
 
 static void rtl8187_tx_cb(struct urb *urb)
 {
-	struct ieee80211_tx_status status = { {0} };
+	struct ieee80211_tx_status status;
 	struct sk_buff *skb = (struct sk_buff *)urb->context;
 	struct rtl8187_tx_info *info = (struct rtl8187_tx_info *)skb->cb;
 
+	memset(&status, 0, sizeof(status));
+
 	usb_free_urb(info->urb);
 	if (info->control)
 		memcpy(&status.control, info->control, sizeof(status.control));


