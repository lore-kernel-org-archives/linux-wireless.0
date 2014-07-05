Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:58782 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964792AbaGESYx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jul 2014 14:24:53 -0400
Received: by mail-we0-f172.google.com with SMTP id u57so2683194wes.3
        for <linux-wireless@vger.kernel.org>; Sat, 05 Jul 2014 11:24:52 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/8] staging: vt6656: vnt_rf_set_txpower use power for priv->byCurPwr
Date: Sat,  5 Jul 2014 19:24:21 +0100
Message-Id: <1404584667-3582-2-git-send-email-tvboxspy@gmail.com> (sfid-20140705_202457_019871_D95A371E)
In-Reply-To: <1404584667-3582-1-git-send-email-tvboxspy@gmail.com>
References: <1404584667-3582-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The byCurPwr value can change state while in another thread,.

Change to local variable power which is the last set value.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rf.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index 8c2c2bd..971f844 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -821,11 +821,10 @@ int vnt_rf_set_txpower(struct vnt_private *priv, u8 power, u32 rate)
 
 	switch (priv->byRFType) {
 	case RF_AL2230:
-		if (priv->byCurPwr >= AL2230_PWR_IDX_LEN)
+		if (power >= AL2230_PWR_IDX_LEN)
 			return false;
 
-		ret &= vnt_rf_write_embedded(priv,
-			al2230_power_table[priv->byCurPwr]);
+		ret &= vnt_rf_write_embedded(priv, al2230_power_table[power]);
 
 		if (rate <= RATE_11M)
 			ret &= vnt_rf_write_embedded(priv, 0x0001b400 +
@@ -835,11 +834,10 @@ int vnt_rf_set_txpower(struct vnt_private *priv, u8 power, u32 rate)
 				(BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW);
 		break;
 	case RF_AL2230S:
-		if (priv->byCurPwr >= AL2230_PWR_IDX_LEN)
+		if (power >= AL2230_PWR_IDX_LEN)
 			return false;
 
-		ret &= vnt_rf_write_embedded(priv,
-			al2230_power_table[priv->byCurPwr]);
+		ret &= vnt_rf_write_embedded(priv, al2230_power_table[power]);
 
 		if (rate <= RATE_11M) {
 			ret &= vnt_rf_write_embedded(priv, 0x040c1400 +
@@ -862,14 +860,14 @@ int vnt_rf_set_txpower(struct vnt_private *priv, u8 power, u32 rate)
 			ret &= vnt_rf_write_embedded(priv, 0x221bb900 +
 				(BY_AL7230_REG_LEN << 3)+IFREGCTL_REGW);
 
-		if (priv->byCurPwr > AL7230_PWR_IDX_LEN)
+		if (power >= AL7230_PWR_IDX_LEN)
 			return false;
 
 		/*
 		* 0x080F1B00 for 3 wire control TxGain(D10)
 		* and 0x31 as TX Gain value
 		*/
-		power_setting = 0x080c0b00 | ((priv->byCurPwr) << 12) |
+		power_setting = 0x080c0b00 | (power << 12) |
 				(BY_AL7230_REG_LEN << 3) | IFREGCTL_REGW;
 
 		ret &= vnt_rf_write_embedded(priv, power_setting);
@@ -877,22 +875,22 @@ int vnt_rf_set_txpower(struct vnt_private *priv, u8 power, u32 rate)
 		break;
 
 	case RF_VT3226:
-		if (priv->byCurPwr >= VT3226_PWR_IDX_LEN)
+		if (power >= VT3226_PWR_IDX_LEN)
 			return false;
-		power_setting = ((0x3f - priv->byCurPwr) << 20) | (0x17 << 8) |
+		power_setting = ((0x3f - power) << 20) | (0x17 << 8) |
 				(BY_VT3226_REG_LEN << 3) | IFREGCTL_REGW;
 
 		ret &= vnt_rf_write_embedded(priv, power_setting);
 
 		break;
 	case RF_VT3226D0:
-		if (priv->byCurPwr >= VT3226_PWR_IDX_LEN)
+		if (power >= VT3226_PWR_IDX_LEN)
 			return false;
 
 		if (rate <= RATE_11M) {
 			u16 hw_value = priv->hw->conf.chandef.chan->hw_value;
 
-			power_setting = ((0x3f-priv->byCurPwr) << 20) |
+			power_setting = ((0x3f - power) << 20) |
 				(0xe07 << 8) | (BY_VT3226_REG_LEN << 3) |
 						IFREGCTL_REGW;
 
@@ -915,7 +913,7 @@ int vnt_rf_set_txpower(struct vnt_private *priv, u8 power, u32 rate)
 			dev_dbg(&priv->usb->dev,
 					"@@@@ vnt_rf_set_txpower> 11G mode\n");
 
-			power_setting = ((0x3f-priv->byCurPwr) << 20) |
+			power_setting = ((0x3f - power) << 20) |
 				(0x7 << 8) | (BY_VT3226_REG_LEN << 3) |
 					IFREGCTL_REGW;
 
@@ -930,10 +928,10 @@ int vnt_rf_set_txpower(struct vnt_private *priv, u8 power, u32 rate)
 		break;
 
 	case RF_VT3342A0:
-		if (priv->byCurPwr >= VT3342_PWR_IDX_LEN)
+		if (power >= VT3342_PWR_IDX_LEN)
 			return false;
 
-		power_setting =  ((0x3F-priv->byCurPwr) << 20) |
+		power_setting =  ((0x3f - power) << 20) |
 			(0x27 << 8) | (BY_VT3342_REG_LEN << 3) |
 					IFREGCTL_REGW;
 
-- 
1.9.1

