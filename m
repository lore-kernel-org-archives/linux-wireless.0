Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55891 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbYBRNUy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2008 08:20:54 -0500
Subject: [PATCH] rtl818x: fix RTS/CTS-less transmit
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	David G Hamblen <dhamblen@roadrunner.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 18 Feb 2008 14:20:30 +0100
Message-Id: <1203340830.12783.42.camel@johannes.berg> (sfid-20080218_132058_778590_1AE55D5E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes packet transmission of packets without RTS/CTS.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
This patch is similar to the one you already tested and also fixes
rtl8180.

 drivers/net/wireless/rtl8180_dev.c |   14 ++++++++++----
 drivers/net/wireless/rtl8187_dev.c |   12 +++++++++---
 2 files changed, 19 insertions(+), 7 deletions(-)

--- everything.orig/drivers/net/wireless/rtl8187_dev.c	2008-02-18 12:19:40.070030491 +0100
+++ everything/drivers/net/wireless/rtl8187_dev.c	2008-02-18 12:52:19.960028104 +0100
@@ -176,17 +176,23 @@ static int rtl8187_tx(struct ieee80211_h
 
 	flags = skb->len;
 	flags |= RTL8187_TX_FLAG_NO_ENCRYPT;
-	flags |= control->rts_cts_rate->hw_value << 19;
+
+	BUG_ON(!control->tx_rate);
+
 	flags |= control->tx_rate->hw_value << 24;
 	if (ieee80211_get_morefrag((struct ieee80211_hdr *)skb->data))
 		flags |= RTL8187_TX_FLAG_MORE_FRAG;
 	if (control->flags & IEEE80211_TXCTL_USE_RTS_CTS) {
+		BUG_ON(!control->rts_cts_rate);
 		flags |= RTL8187_TX_FLAG_RTS;
+		flags |= control->rts_cts_rate->hw_value << 19;
 		rts_dur = ieee80211_rts_duration(dev, priv->vif,
 						 skb->len, control);
-	}
-	if (control->flags & IEEE80211_TXCTL_USE_CTS_PROTECT)
+	} else if (control->flags & IEEE80211_TXCTL_USE_CTS_PROTECT) {
+		BUG_ON(!control->rts_cts_rate);
 		flags |= RTL8187_TX_FLAG_CTS;
+		flags |= control->rts_cts_rate->hw_value << 19;
+	}
 
 	hdr = (struct rtl8187_tx_hdr *)skb_push(skb, sizeof(*hdr));
 	hdr->flags = cpu_to_le32(flags);
--- everything.orig/drivers/net/wireless/rtl8180_dev.c	2008-02-18 12:50:51.580030491 +0100
+++ everything/drivers/net/wireless/rtl8180_dev.c	2008-02-18 12:52:48.240028429 +0100
@@ -255,19 +255,25 @@ static int rtl8180_tx(struct ieee80211_h
 	mapping = pci_map_single(priv->pdev, skb->data,
 				 skb->len, PCI_DMA_TODEVICE);
 
+	BUG_ON(!control->tx_rate);
+
 	tx_flags = RTL8180_TX_DESC_FLAG_OWN | RTL8180_TX_DESC_FLAG_FS |
 		   RTL8180_TX_DESC_FLAG_LS |
-		   (control->tx_rate->hw_value << 24) |
-		   (control->rts_cts_rate->hw_value << 19) | skb->len;
+		   (control->tx_rate->hw_value << 24) | skb->len;
 
 	if (priv->r8185)
 		tx_flags |= RTL8180_TX_DESC_FLAG_DMA |
 			    RTL8180_TX_DESC_FLAG_NO_ENC;
 
-	if (control->flags & IEEE80211_TXCTL_USE_RTS_CTS)
+	if (control->flags & IEEE80211_TXCTL_USE_RTS_CTS) {
+		BUG_ON(!control->rts_cts_rate);
 		tx_flags |= RTL8180_TX_DESC_FLAG_RTS;
-	else if (control->flags & IEEE80211_TXCTL_USE_CTS_PROTECT)
+		tx_flags |= control->rts_cts_rate->hw_value << 19;
+	} else if (control->flags & IEEE80211_TXCTL_USE_CTS_PROTECT) {
+		BUG_ON(!control->rts_cts_rate);
 		tx_flags |= RTL8180_TX_DESC_FLAG_CTS;
+		tx_flags |= control->rts_cts_rate->hw_value << 19;
+	}
 
 	*((struct ieee80211_tx_control **) skb->cb) =
 		kmemdup(control, sizeof(*control), GFP_ATOMIC);


