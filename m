Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49658 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab2KLV7C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 16:59:02 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so3644080eek.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2012 13:59:02 -0800 (PST)
From: Maxim Mikityanskiy <maxtram95@gmail.com>
To: greg@kroah.com, linux-wireless@vger.kernel.org
Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [PATCH 08/17] Removed dead code
Date: Mon, 12 Nov 2012 23:58:22 +0200
Message-Id: <1352757511-26957-9-git-send-email-maxtram95@gmail.com> (sfid-20121112_225909_102345_EED600CF)
In-Reply-To: <1352757511-26957-1-git-send-email-maxtram95@gmail.com>
References: <1352757511-26957-1-git-send-email-maxtram95@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
---
 r8180_core.c |   82 ----------------------------------------------------------
 1 file changed, 82 deletions(-)

diff --git a/r8180_core.c b/r8180_core.c
index 203e546..ded5cd0 100644
--- a/r8180_core.c
+++ b/r8180_core.c
@@ -606,66 +606,6 @@ void fix_rx_fifo(struct net_device *dev)
 	set_nic_rxring(dev);
 }
 
-unsigned char QUALITY_MAP[] = {
-	0x64, 0x64, 0x64, 0x63, 0x63, 0x62, 0x62, 0x61,
-	0x61, 0x60, 0x60, 0x5f, 0x5f, 0x5e, 0x5d, 0x5c,
-	0x5b, 0x5a, 0x59, 0x57, 0x56, 0x54, 0x52, 0x4f,
-	0x4c, 0x49, 0x45, 0x41, 0x3c, 0x37, 0x31, 0x29,
-	0x24, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22,
-	0x22, 0x22, 0x21, 0x21, 0x21, 0x21, 0x21, 0x20,
-	0x20, 0x20, 0x20, 0x1f, 0x1f, 0x1e, 0x1e, 0x1e,
-	0x1d, 0x1d, 0x1c, 0x1c, 0x1b, 0x1a, 0x19, 0x19,
-	0x18, 0x17, 0x16, 0x15, 0x14, 0x12, 0x11, 0x0f,
-	0x0e, 0x0c, 0x0a, 0x08, 0x06, 0x04, 0x01, 0x00
-};
-
-unsigned char STRENGTH_MAP[] = {
-	0x64, 0x64, 0x63, 0x62, 0x61, 0x60, 0x5f, 0x5e,
-	0x5d, 0x5c, 0x5b, 0x5a, 0x57, 0x54, 0x52, 0x50,
-	0x4e, 0x4c, 0x4a, 0x48, 0x46, 0x44, 0x41, 0x3f,
-	0x3c, 0x3a, 0x37, 0x36, 0x36, 0x1c, 0x1c, 0x1b,
-	0x1b, 0x1a, 0x1a, 0x19, 0x19, 0x18, 0x18, 0x17,
-	0x17, 0x16, 0x16, 0x15, 0x15, 0x14, 0x14, 0x13,
-	0x13, 0x12, 0x12, 0x11, 0x11, 0x10, 0x10, 0x0f,
-	0x0f, 0x0e, 0x0e, 0x0d, 0x0d, 0x0c, 0x0c, 0x0b,
-	0x0b, 0x0a, 0x0a, 0x09, 0x09, 0x08, 0x08, 0x07,
-	0x07, 0x06, 0x06, 0x05, 0x04, 0x03, 0x02, 0x00
-};
-
-void rtl8180_RSSI_calc(struct net_device *dev, u8 *rssi, u8 *qual)
-{
-	u32 temp;
-	u32 temp2;
-	u32 q;
-	u32 orig_qual;
-	u8  _rssi;
-
-	q = *qual;
-	orig_qual = *qual;
-	_rssi = 0; /* avoid gcc complains.. */
-
-	if (q <= 0x4e) {
-		temp = QUALITY_MAP[q];
-	} else {
-		if (q & 0x80)
-			temp = 0x32;
-		else
-			temp = 1;
-	}
-
-	*qual = temp;
-	temp2 = *rssi;
-
-	if (_rssi < 0x64) {
-		if (_rssi == 0)
-			*rssi = 1;
-	} else {
-		*rssi = 0x64;
-	}
-
-	return;
-}
-
 void rtl8180_irq_disable(struct net_device *dev)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
@@ -746,26 +686,6 @@ void set_nic_txring(struct net_device *dev)
 	write_nic_dword(dev, TX_BEACON_RING_ADDR, priv->txbeaconringdma);
 }
 
-void rtl8180_conttx_enable(struct net_device *dev)
-{
-	u32 txconf;
-
-	txconf = read_nic_dword(dev, TX_CONF);
-	txconf = txconf & ~TX_LOOPBACK_MASK;
-	txconf = txconf | (TX_LOOPBACK_CONTINUE<<TX_LOOPBACK_SHIFT);
-	write_nic_dword(dev, TX_CONF, txconf);
-}
-
-void rtl8180_conttx_disable(struct net_device *dev)
-{
-	u32 txconf;
-
-	txconf = read_nic_dword(dev, TX_CONF);
-	txconf = txconf & ~TX_LOOPBACK_MASK;
-	txconf = txconf | (TX_LOOPBACK_NONE<<TX_LOOPBACK_SHIFT);
-	write_nic_dword(dev, TX_CONF, txconf);
-}
-
 void rtl8180_beacon_tx_enable(struct net_device *dev)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
@@ -2136,8 +2056,6 @@ short rtl8180_is_tx_queue_empty(struct net_device *dev)
 				return 0;
 	return 1;
 }
-/* FIXME FIXME 5msecs is random */
-#define HW_WAKE_DELAY 5
 
 void rtl8180_hw_wakeup(struct net_device *dev)
 {
-- 
1.7.10.4

