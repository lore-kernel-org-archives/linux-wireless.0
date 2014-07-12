Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:50653 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbaGLKan (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jul 2014 06:30:43 -0400
Received: by mail-we0-f174.google.com with SMTP id x48so355139wes.33
        for <linux-wireless@vger.kernel.org>; Sat, 12 Jul 2014 03:30:41 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3/4] staging: vt6656: vnt_rf_write_embedded add reg length and IFREGCTL_REGW
Date: Sat, 12 Jul 2014 11:30:02 +0100
Message-Id: <1405161003-2914-3-git-send-email-tvboxspy@gmail.com> (sfid-20140712_123056_154376_F3931881)
In-Reply-To: <1405161003-2914-1-git-send-email-tvboxspy@gmail.com>
References: <1405161003-2914-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rf register always have  *_REG_LEN and IFREGCTL_REGW macros added.

*_REG_LEN is always 23(0x17) replace them with VNT_RF_REG_LEN.

Remove *_REG_LEN and IFREGCTL_REGW from tables and vnt_rf_set_txpower and
apply VNT_RF_REG_LEN and IFREGCTL_REGW in vnt_rf_write_embedded

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rf.c | 219 ++++++++++++++++++++------------------------
 drivers/staging/vt6656/rf.h |   1 +
 2 files changed, 99 insertions(+), 121 deletions(-)

diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index 1661f8ee..1c3b3fa 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -40,22 +40,18 @@
 #include "baseband.h"
 #include "usbpipe.h"
 
-#define BY_AL2230_REG_LEN     23 //24bit
 #define CB_AL2230_INIT_SEQ    15
 #define AL2230_PWR_IDX_LEN    64
 
-#define BY_AL7230_REG_LEN     23 //24bit
 #define CB_AL7230_INIT_SEQ    16
 #define AL7230_PWR_IDX_LEN    64
 
 //{{RobertYu:20051111
-#define BY_VT3226_REG_LEN     23
 #define CB_VT3226_INIT_SEQ    11
 #define VT3226_PWR_IDX_LEN    64
 //}}
 
 //{{RobertYu:20060609
-#define BY_VT3342_REG_LEN     23
 #define CB_VT3342_INIT_SEQ    13
 #define VT3342_PWR_IDX_LEN    64
 //}}
@@ -390,20 +386,20 @@ static u8 vt3226_channel_table1[CB_MAX_CHANNEL_24G][3] = {
 };
 
 static const u32 vt3226d0_lo_current_table[CB_MAX_CHANNEL_24G] = {
-	0x0135c600 + (BY_VT3226_REG_LEN << 3) + IFREGCTL_REGW,
-	0x0135c600 + (BY_VT3226_REG_LEN << 3) + IFREGCTL_REGW,
-	0x0235c600 + (BY_VT3226_REG_LEN << 3) + IFREGCTL_REGW,
-	0x0235c600 + (BY_VT3226_REG_LEN << 3) + IFREGCTL_REGW,
-	0x0235c600 + (BY_VT3226_REG_LEN << 3) + IFREGCTL_REGW,
-	0x0335c600 + (BY_VT3226_REG_LEN << 3) + IFREGCTL_REGW,
-	0x0335c600 + (BY_VT3226_REG_LEN << 3) + IFREGCTL_REGW,
-	0x0335c600 + (BY_VT3226_REG_LEN << 3) + IFREGCTL_REGW,
-	0x0335c600 + (BY_VT3226_REG_LEN << 3) + IFREGCTL_REGW,
-	0x0335c600 + (BY_VT3226_REG_LEN << 3) + IFREGCTL_REGW,
-	0x0335c600 + (BY_VT3226_REG_LEN << 3) + IFREGCTL_REGW,
-	0x0335c600 + (BY_VT3226_REG_LEN << 3) + IFREGCTL_REGW,
-	0x0335c600 + (BY_VT3226_REG_LEN << 3) + IFREGCTL_REGW,
-	0x0135c600 + (BY_VT3226_REG_LEN << 3) + IFREGCTL_REGW
+	0x0135c600,
+	0x0135c600,
+	0x0235c600,
+	0x0235c600,
+	0x0235c600,
+	0x0335c600,
+	0x0335c600,
+	0x0335c600,
+	0x0335c600,
+	0x0335c600,
+	0x0335c600,
+	0x0335c600,
+	0x0335c600,
+	0x0135c600
 };
 
 static u8 vt3342a0_init_table[CB_VT3342_INIT_SEQ][3] = { /* 11b/g mode */
@@ -547,70 +543,70 @@ static u8 vt3342_channel_table1[CB_MAX_CHANNEL][3] = {
 -*/
 
 static const u32 al2230_power_table[AL2230_PWR_IDX_LEN] = {
-	0x04040900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x04041900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x04042900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x04043900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x04044900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x04045900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x04046900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x04047900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x04048900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x04049900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x0404a900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x0404b900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x0404c900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x0404d900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x0404e900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x0404f900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x04050900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x04051900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x04052900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x04053900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x04054900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x04055900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x04056900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x04057900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x04058900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x04059900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x0405a900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x0405b900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x0405c900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x0405d900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x0405e900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x0405f900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x04060900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x04061900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x04062900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x04063900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x04064900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x04065900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x04066900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x04067900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x04068900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x04069900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x0406a900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x0406b900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x0406c900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x0406d900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x0406e900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x0406f900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x04070900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x04071900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x04072900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x04073900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x04074900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x04075900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x04076900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x04077900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x04078900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x04079900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x0407a900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x0407b900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x0407c900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x0407d900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x0407e900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW,
-	0x0407f900 + (BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW
+	0x04040900,
+	0x04041900,
+	0x04042900,
+	0x04043900,
+	0x04044900,
+	0x04045900,
+	0x04046900,
+	0x04047900,
+	0x04048900,
+	0x04049900,
+	0x0404a900,
+	0x0404b900,
+	0x0404c900,
+	0x0404d900,
+	0x0404e900,
+	0x0404f900,
+	0x04050900,
+	0x04051900,
+	0x04052900,
+	0x04053900,
+	0x04054900,
+	0x04055900,
+	0x04056900,
+	0x04057900,
+	0x04058900,
+	0x04059900,
+	0x0405a900,
+	0x0405b900,
+	0x0405c900,
+	0x0405d900,
+	0x0405e900,
+	0x0405f900,
+	0x04060900,
+	0x04061900,
+	0x04062900,
+	0x04063900,
+	0x04064900,
+	0x04065900,
+	0x04066900,
+	0x04067900,
+	0x04068900,
+	0x04069900,
+	0x0406a900,
+	0x0406b900,
+	0x0406c900,
+	0x0406d900,
+	0x0406e900,
+	0x0406f900,
+	0x04070900,
+	0x04071900,
+	0x04072900,
+	0x04073900,
+	0x04074900,
+	0x04075900,
+	0x04076900,
+	0x04077900,
+	0x04078900,
+	0x04079900,
+	0x0407a900,
+	0x0407b900,
+	0x0407c900,
+	0x0407d900,
+	0x0407e900,
+	0x0407f900
 };
 
 /*
@@ -629,6 +625,8 @@ int vnt_rf_write_embedded(struct vnt_private *priv, u32 data)
 {
 	u8 reg_data[4];
 
+	data |= (VNT_RF_REG_LEN << 3) | IFREGCTL_REGW;
+
 	reg_data[0] = (u8)data;
 	reg_data[1] = (u8)(data >> 8);
 	reg_data[2] = (u8)(data >> 16);
@@ -752,11 +750,9 @@ int vnt_rf_set_txpower(struct vnt_private *priv, u8 power, u32 rate)
 		ret &= vnt_rf_write_embedded(priv, al2230_power_table[power]);
 
 		if (rate <= RATE_11M)
-			ret &= vnt_rf_write_embedded(priv, 0x0001b400 +
-				(BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW);
+			ret &= vnt_rf_write_embedded(priv, 0x0001b400);
 		else
-			ret &= vnt_rf_write_embedded(priv, 0x0005a400 +
-				(BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW);
+			ret &= vnt_rf_write_embedded(priv, 0x0005a400);
 		break;
 	case RF_AL2230S:
 		if (power >= AL2230_PWR_IDX_LEN)
@@ -765,25 +761,19 @@ int vnt_rf_set_txpower(struct vnt_private *priv, u8 power, u32 rate)
 		ret &= vnt_rf_write_embedded(priv, al2230_power_table[power]);
 
 		if (rate <= RATE_11M) {
-			ret &= vnt_rf_write_embedded(priv, 0x040c1400 +
-				(BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW);
-			ret &= vnt_rf_write_embedded(priv, 0x00299b00 +
-				(BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW);
+			ret &= vnt_rf_write_embedded(priv, 0x040c1400);
+			ret &= vnt_rf_write_embedded(priv, 0x00299b00);
 		} else {
-			ret &= vnt_rf_write_embedded(priv, 0x0005a400 +
-				(BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW);
-			ret &= vnt_rf_write_embedded(priv, 0x00099b00 +
-				(BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW);
+			ret &= vnt_rf_write_embedded(priv, 0x0005a400);
+			ret &= vnt_rf_write_embedded(priv, 0x00099b00);
 		}
 		break;
 
 	case RF_AIROHA7230:
 		if (rate <= RATE_11M)
-			ret &= vnt_rf_write_embedded(priv, 0x111bb900 +
-				(BY_AL7230_REG_LEN << 3)+IFREGCTL_REGW);
+			ret &= vnt_rf_write_embedded(priv, 0x111bb900);
 		else
-			ret &= vnt_rf_write_embedded(priv, 0x221bb900 +
-				(BY_AL7230_REG_LEN << 3)+IFREGCTL_REGW);
+			ret &= vnt_rf_write_embedded(priv, 0x221bb900);
 
 		if (power >= AL7230_PWR_IDX_LEN)
 			return false;
@@ -792,8 +782,7 @@ int vnt_rf_set_txpower(struct vnt_private *priv, u8 power, u32 rate)
 		* 0x080F1B00 for 3 wire control TxGain(D10)
 		* and 0x31 as TX Gain value
 		*/
-		power_setting = 0x080c0b00 | (power << 12) |
-				(BY_AL7230_REG_LEN << 3) | IFREGCTL_REGW;
+		power_setting = 0x080c0b00 | (power << 12);
 
 		ret &= vnt_rf_write_embedded(priv, power_setting);
 
@@ -802,8 +791,7 @@ int vnt_rf_set_txpower(struct vnt_private *priv, u8 power, u32 rate)
 	case RF_VT3226:
 		if (power >= VT3226_PWR_IDX_LEN)
 			return false;
-		power_setting = ((0x3f - power) << 20) | (0x17 << 8) |
-				(BY_VT3226_REG_LEN << 3) | IFREGCTL_REGW;
+		power_setting = ((0x3f - power) << 20) | (0x17 << 8);
 
 		ret &= vnt_rf_write_embedded(priv, power_setting);
 
@@ -815,13 +803,10 @@ int vnt_rf_set_txpower(struct vnt_private *priv, u8 power, u32 rate)
 		if (rate <= RATE_11M) {
 			u16 hw_value = priv->hw->conf.chandef.chan->hw_value;
 
-			power_setting = ((0x3f - power) << 20) |
-				(0xe07 << 8) | (BY_VT3226_REG_LEN << 3) |
-						IFREGCTL_REGW;
+			power_setting = ((0x3f - power) << 20) | (0xe07 << 8);
 
 			ret &= vnt_rf_write_embedded(priv, power_setting);
-			ret &= vnt_rf_write_embedded(priv, 0x03c6a200 +
-					(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW);
+			ret &= vnt_rf_write_embedded(priv, 0x03c6a200);
 
 			dev_dbg(&priv->usb->dev,
 				"%s 11b channel [%d]\n", __func__, hw_value);
@@ -832,23 +817,17 @@ int vnt_rf_set_txpower(struct vnt_private *priv, u8 power, u32 rate)
 				ret &= vnt_rf_write_embedded(priv,
 					vt3226d0_lo_current_table[hw_value]);
 
-			ret &= vnt_rf_write_embedded(priv, 0x015C0800 +
-				(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW);
+			ret &= vnt_rf_write_embedded(priv, 0x015C0800);
 		} else {
 			dev_dbg(&priv->usb->dev,
 					"@@@@ vnt_rf_set_txpower> 11G mode\n");
 
-			power_setting = ((0x3f - power) << 20) |
-				(0x7 << 8) | (BY_VT3226_REG_LEN << 3) |
-					IFREGCTL_REGW;
+			power_setting = ((0x3f - power) << 20) | (0x7 << 8);
 
 			ret &= vnt_rf_write_embedded(priv, power_setting);
-			ret &= vnt_rf_write_embedded(priv, 0x00C6A200 +
-				(BY_VT3226_REG_LEN << 3) + IFREGCTL_REGW);
-			ret &= vnt_rf_write_embedded(priv, 0x016BC600 +
-					(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW);
-			ret &= vnt_rf_write_embedded(priv, 0x00900800 +
-					(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW);
+			ret &= vnt_rf_write_embedded(priv, 0x00C6A200);
+			ret &= vnt_rf_write_embedded(priv, 0x016BC600);
+			ret &= vnt_rf_write_embedded(priv, 0x00900800);
 		}
 		break;
 
@@ -856,9 +835,7 @@ int vnt_rf_set_txpower(struct vnt_private *priv, u8 power, u32 rate)
 		if (power >= VT3342_PWR_IDX_LEN)
 			return false;
 
-		power_setting =  ((0x3f - power) << 20) |
-			(0x27 << 8) | (BY_VT3342_REG_LEN << 3) |
-					IFREGCTL_REGW;
+		power_setting =  ((0x3f - power) << 20) | (0x27 << 8);
 
 		ret &= vnt_rf_write_embedded(priv, power_setting);
 
diff --git a/drivers/staging/vt6656/rf.h b/drivers/staging/vt6656/rf.h
index d2347b4..8cebb6a 100644
--- a/drivers/staging/vt6656/rf.h
+++ b/drivers/staging/vt6656/rf.h
@@ -54,6 +54,7 @@
 #define RF_MASK             0x7F
 
 #define VNT_RF_MAX_POWER    0x3f
+#define	VNT_RF_REG_LEN      0x17 /* 24 bit length */
 
 int vnt_rf_write_embedded(struct vnt_private *, u32);
 int vnt_rf_setpower(struct vnt_private *, u32, u32);
-- 
1.9.1

