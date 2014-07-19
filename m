Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:61168 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560AbaGSLbF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2014 07:31:05 -0400
Received: by mail-wg0-f43.google.com with SMTP id l18so4540088wgh.14
        for <linux-wireless@vger.kernel.org>; Sat, 19 Jul 2014 04:31:04 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 06/16] staging: vt6656: struct vnt_private rename byBBRxConf to bb_rx_conf
Date: Sat, 19 Jul 2014 12:30:08 +0100
Message-Id: <1405769418-2815-6-git-send-email-tvboxspy@gmail.com> (sfid-20140719_133121_996049_9C52E20E)
In-Reply-To: <1405769418-2815-1-git-send-email-tvboxspy@gmail.com>
References: <1405769418-2815-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove camel case

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 28 ++++++++++++++--------------
 drivers/staging/vt6656/device.h   |  2 +-
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index b08d1ea..71226c7 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -352,11 +352,11 @@ void vnt_set_antenna_mode(struct vnt_private *priv, u8 antenna_mode)
 	case ANT_TXB:
 		break;
 	case ANT_RXA:
-		priv->byBBRxConf &= 0xFC;
+		priv->bb_rx_conf &= 0xFC;
 		break;
 	case ANT_RXB:
-		priv->byBBRxConf &= 0xFE;
-		priv->byBBRxConf |= 0x02;
+		priv->bb_rx_conf &= 0xFE;
+		priv->bb_rx_conf |= 0x02;
 		break;
 	}
 
@@ -404,7 +404,7 @@ int vnt_vt3184_init(struct vnt_private *priv)
 
 	if ((priv->rf_type == RF_AL2230) ||
 				(priv->rf_type == RF_AL2230S)) {
-		priv->byBBRxConf = vnt_vt3184_al2230[10];
+		priv->bb_rx_conf = vnt_vt3184_al2230[10];
 		length = sizeof(vnt_vt3184_al2230);
 		addr = vnt_vt3184_al2230;
 		agc = vnt_vt3184_agc;
@@ -419,7 +419,7 @@ int vnt_vt3184_init(struct vnt_private *priv)
 		priv->ldBmThreshold[2] = 0;
 		priv->ldBmThreshold[3] = 0;
 	} else if (priv->rf_type == RF_AIROHA7230) {
-		priv->byBBRxConf = vnt_vt3184_al2230[10];
+		priv->bb_rx_conf = vnt_vt3184_al2230[10];
 		length = sizeof(vnt_vt3184_al2230);
 		addr = vnt_vt3184_al2230;
 		agc = vnt_vt3184_agc;
@@ -437,7 +437,7 @@ int vnt_vt3184_init(struct vnt_private *priv)
 		priv->ldBmThreshold[3] = 0;
 	} else if ((priv->rf_type == RF_VT3226) ||
 			(priv->rf_type == RF_VT3226D0)) {
-		priv->byBBRxConf = vnt_vt3184_vt3226d0[10];
+		priv->bb_rx_conf = vnt_vt3184_vt3226d0[10];
 		length = sizeof(vnt_vt3184_vt3226d0);
 		addr = vnt_vt3184_vt3226d0;
 		agc = vnt_vt3184_agc;
@@ -455,7 +455,7 @@ int vnt_vt3184_init(struct vnt_private *priv)
 		vnt_mac_reg_bits_on(priv, MAC_REG_SOFTPWRCTL2,
 				    SOFTPWRCTL_RFLEOPT);
 	} else if (priv->rf_type == RF_VT3342A0) {
-		priv->byBBRxConf = vnt_vt3184_vt3226d0[10];
+		priv->bb_rx_conf = vnt_vt3184_vt3226d0[10];
 		length = sizeof(vnt_vt3184_vt3226d0);
 		addr = vnt_vt3184_vt3226d0;
 		agc = vnt_vt3184_agc;
@@ -531,16 +531,16 @@ void vnt_set_short_slot_time(struct vnt_private *priv)
 	u8 bb_vga = 0;
 
 	if (priv->bShortSlotTime)
-		priv->byBBRxConf &= 0xdf;
+		priv->bb_rx_conf &= 0xdf;
 	else
-		priv->byBBRxConf |= 0x20;
+		priv->bb_rx_conf |= 0x20;
 
 	vnt_control_in_u8(priv, MESSAGE_REQUEST_BBREG, 0xe7, &bb_vga);
 
 	if (bb_vga == priv->abyBBVGA[0])
-		priv->byBBRxConf |= 0x20;
+		priv->bb_rx_conf |= 0x20;
 
-	vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG, 0x0a, priv->byBBRxConf);
+	vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG, 0x0a, priv->bb_rx_conf);
 }
 
 void vnt_set_vga_gain_offset(struct vnt_private *priv, u8 data)
@@ -550,11 +550,11 @@ void vnt_set_vga_gain_offset(struct vnt_private *priv, u8 data)
 
 	/* patch for 3253B0 Baseband with Cardbus module */
 	if (priv->bShortSlotTime)
-		priv->byBBRxConf &= 0xdf; /* 1101 1111 */
+		priv->bb_rx_conf &= 0xdf; /* 1101 1111 */
 	else
-		priv->byBBRxConf |= 0x20; /* 0010 0000 */
+		priv->bb_rx_conf |= 0x20; /* 0010 0000 */
 
-	vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG, 0x0a, priv->byBBRxConf);
+	vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG, 0x0a, priv->bb_rx_conf);
 }
 
 /*
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 8b5793b..3152f93 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -302,7 +302,7 @@ struct vnt_private {
 	u16 firmware_version;
 	u8 local_id;
 	u8 rf_type;
-	u8 byBBRxConf;
+	u8 bb_rx_conf;
 
 	u8 byZoneType;
 
-- 
2.0.1

