Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:62115 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932126AbaGTOeq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 10:34:46 -0400
Received: by mail-wg0-f48.google.com with SMTP id x13so5411505wgg.7
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 07:34:45 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 16/25] staging: vt6656: struct vnt_private remove dead code ldBmThreshold
Date: Sun, 20 Jul 2014 15:33:26 +0100
Message-Id: <1405866815-2687-16-git-send-email-tvboxspy@gmail.com> (sfid-20140720_165108_502437_F305112C)
In-Reply-To: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
References: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ldBmThreshold was used in old function s_vCheckSensitivity which
had been disabled in orginal vendors code.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 20 ++++----------------
 drivers/staging/vt6656/device.h   |  1 -
 2 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 11c098c..dd449a3 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -410,10 +410,7 @@ int vnt_vt3184_init(struct vnt_private *priv)
 		priv->bb_vga[1] = 0x10;
 		priv->bb_vga[2] = 0x0;
 		priv->bb_vga[3] = 0x0;
-		priv->ldBmThreshold[0] = -70;
-		priv->ldBmThreshold[1] = -48;
-		priv->ldBmThreshold[2] = 0;
-		priv->ldBmThreshold[3] = 0;
+
 	} else if (priv->rf_type == RF_AIROHA7230) {
 		priv->bb_rx_conf = vnt_vt3184_al2230[10];
 		length = sizeof(vnt_vt3184_al2230);
@@ -427,10 +424,7 @@ int vnt_vt3184_init(struct vnt_private *priv)
 		priv->bb_vga[1] = 0x10;
 		priv->bb_vga[2] = 0x0;
 		priv->bb_vga[3] = 0x0;
-		priv->ldBmThreshold[0] = -70;
-		priv->ldBmThreshold[1] = -48;
-		priv->ldBmThreshold[2] = 0;
-		priv->ldBmThreshold[3] = 0;
+
 	} else if ((priv->rf_type == RF_VT3226) ||
 			(priv->rf_type == RF_VT3226D0)) {
 		priv->bb_rx_conf = vnt_vt3184_vt3226d0[10];
@@ -443,10 +437,7 @@ int vnt_vt3184_init(struct vnt_private *priv)
 		priv->bb_vga[1] = 0x10;
 		priv->bb_vga[2] = 0x0;
 		priv->bb_vga[3] = 0x0;
-		priv->ldBmThreshold[0] = -70;
-		priv->ldBmThreshold[1] = -48;
-		priv->ldBmThreshold[2] = 0;
-		priv->ldBmThreshold[3] = 0;
+
 		/* Fix VT3226 DFC system timing issue */
 		vnt_mac_reg_bits_on(priv, MAC_REG_SOFTPWRCTL2,
 				    SOFTPWRCTL_RFLEOPT);
@@ -461,10 +452,7 @@ int vnt_vt3184_init(struct vnt_private *priv)
 		priv->bb_vga[1] = 0x10;
 		priv->bb_vga[2] = 0x0;
 		priv->bb_vga[3] = 0x0;
-		priv->ldBmThreshold[0] = -70;
-		priv->ldBmThreshold[1] = -48;
-		priv->ldBmThreshold[2] = 0;
-		priv->ldBmThreshold[3] = 0;
+
 		/* Fix VT3226 DFC system timing issue */
 		vnt_mac_reg_bits_on(priv, MAC_REG_SOFTPWRCTL2,
 				    SOFTPWRCTL_RFLEOPT);
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index e3c2509..24ebbd0 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -384,7 +384,6 @@ struct vnt_private {
 
 	/* For Update BaseBand VGA Gain Offset */
 	u8 bb_vga[BB_VGA_LEVEL];
-	signed long ldBmThreshold[BB_VGA_LEVEL];
 
 	u8 byBBPreEDRSSI;
 	u8 byBBPreEDIndex;
-- 
2.0.1

