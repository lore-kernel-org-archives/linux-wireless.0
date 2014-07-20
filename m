Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:53207 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050AbaGTOem (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 10:34:42 -0400
Received: by mail-wg0-f50.google.com with SMTP id n12so5346445wgh.33
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 07:34:41 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 14/25] staging: vt6656: struct vnt_private replace byAutoFBCtrl with auto_fb_ctrl
Date: Sun, 20 Jul 2014 15:33:24 +0100
Message-Id: <1405866815-2687-14-git-send-email-tvboxspy@gmail.com> (sfid-20140720_165109_370917_FF293C35)
In-Reply-To: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
References: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing type prefix and camel case.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   | 2 +-
 drivers/staging/vt6656/main_usb.c | 4 ++--
 drivers/staging/vt6656/rxtx.c     | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 6647b2b..ef9b505 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -380,7 +380,7 @@ struct vnt_private {
 
 	unsigned long key_entry_inuse;
 
-	u8 byAutoFBCtrl;
+	u8 auto_fb_ctrl;
 
 	/* For Update BaseBand VGA Gain Offset */
 	u8 abyBBVGA[BB_VGA_LEVEL];
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index f7f4dcc..fac13b1 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -123,7 +123,7 @@ static void device_set_options(struct vnt_private *priv)
 	priv->op_mode = NL80211_IFTYPE_UNSPECIFIED;
 	priv->bb_type = BBP_TYPE_DEF;
 	priv->packet_type = priv->bb_type;
-	priv->byAutoFBCtrl = AUTO_FB_0;
+	priv->auto_fb_ctrl = AUTO_FB_0;
 	priv->preamble_type = 0;
 	priv->exist_sw_net_addr = false;
 }
@@ -280,7 +280,7 @@ static int device_init_registers(struct vnt_private *priv)
 	vnt_set_antenna_mode(priv, priv->rx_antenna_mode);
 
 	/* get Auto Fall Back type */
-	priv->byAutoFBCtrl = AUTO_FB_0;
+	priv->auto_fb_ctrl = AUTO_FB_0;
 
 	/* default Auto Mode */
 	priv->bb_type = BB_TYPE_11G;
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 8d745af..0febd03 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -866,7 +866,7 @@ int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 
 	/* legacy rates TODO use ieee80211_tx_rate */
 	if (current_rate >= RATE_18M && ieee80211_is_data(hdr->frame_control)) {
-		if (priv->byAutoFBCtrl == AUTO_FB_0) {
+		if (priv->auto_fb_ctrl == AUTO_FB_0) {
 			tx_buffer_head->wFIFOCtl |= FIFOCTL_AUTO_FB_0;
 
 			priv->tx_rate_fb0 =
@@ -875,7 +875,7 @@ int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 				vnt_fb_opt0[FB_RATE1][current_rate - RATE_18M];
 
 			fb_option = AUTO_FB_0;
-		} else if (priv->byAutoFBCtrl == AUTO_FB_1) {
+		} else if (priv->auto_fb_ctrl == AUTO_FB_1) {
 			tx_buffer_head->wFIFOCtl |= FIFOCTL_AUTO_FB_1;
 
 			priv->tx_rate_fb0 =
-- 
2.0.1

