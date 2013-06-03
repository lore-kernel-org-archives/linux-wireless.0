Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:60539 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757697Ab3FCV4i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 17:56:38 -0400
Received: by mail-we0-f173.google.com with SMTP id x55so2206044wes.4
        for <linux-wireless@vger.kernel.org>; Mon, 03 Jun 2013 14:56:37 -0700 (PDT)
Message-ID: <1370296591.9091.36.camel@canaries64> (sfid-20130603_235641_584505_4FF5986A)
Subject: [PATCH 8/8] staging: vt6656: rf.c: replace where priv->byCurPwr ==
 power.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 03 Jun 2013 22:56:31 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

priv->byCurPwr always equals power in vnt_rf_set_txpower
at switch (priv->byRFType)

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rf.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index 2152b44..2e8a964 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -798,11 +798,11 @@ int vnt_rf_set_txpower(struct vnt_private *priv, u8 power, u32 rate)
 
 	switch (priv->byRFType) {
 	case RF_AL2230:
-		if (priv->byCurPwr >= AL2230_PWR_IDX_LEN)
+		if (power >= AL2230_PWR_IDX_LEN)
 			return false;
 
 		ret &= vnt_rf_write_embedded(priv,
-			al2230_power_table[priv->byCurPwr]);
+			al2230_power_table[power]);
 
 		if (rate <= RATE_11M)
 			ret &= vnt_rf_write_embedded(priv, 0x0001b400 +
@@ -812,11 +812,11 @@ int vnt_rf_set_txpower(struct vnt_private *priv, u8 power, u32 rate)
 				(BY_AL2230_REG_LEN << 3) + IFREGCTL_REGW);
 		break;
 	case RF_AL2230S:
-		if (priv->byCurPwr >= AL2230_PWR_IDX_LEN)
+		if (power >= AL2230_PWR_IDX_LEN)
 			return false;
 
 		ret &= vnt_rf_write_embedded(priv,
-			al2230_power_table[priv->byCurPwr]);
+			al2230_power_table[power]);
 
 		if (rate <= RATE_11M) {
 			ret &= vnt_rf_write_embedded(priv, 0x040c1400 +
@@ -839,14 +839,14 @@ int vnt_rf_set_txpower(struct vnt_private *priv, u8 power, u32 rate)
 			ret &= vnt_rf_write_embedded(priv, 0x221bb900 +
 				(BY_AL7230_REG_LEN << 3)+IFREGCTL_REGW);
 
-		if (priv->byCurPwr > AL7230_PWR_IDX_LEN)
+		if (power > AL7230_PWR_IDX_LEN)
 			return false;
 
 		/*
 		* 0x080F1B00 for 3 wire control TxGain(D10)
 		* and 0x31 as TX Gain value
 		*/
-		power_setting = 0x080c0b00 | ((priv->byCurPwr) << 12) |
+		power_setting = 0x080c0b00 | ((power) << 12) |
 				(BY_AL7230_REG_LEN << 3) | IFREGCTL_REGW;
 
 		ret &= vnt_rf_write_embedded(priv, power_setting);
@@ -854,20 +854,20 @@ int vnt_rf_set_txpower(struct vnt_private *priv, u8 power, u32 rate)
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
-			power_setting = ((0x3f-priv->byCurPwr) << 20) |
+			power_setting = ((0x3f-power) << 20) |
 				(0xe07 << 8) | (BY_VT3226_REG_LEN << 3) |
 						IFREGCTL_REGW;
 
@@ -897,7 +897,7 @@ int vnt_rf_set_txpower(struct vnt_private *priv, u8 power, u32 rate)
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 					"@@@@ vnt_rf_set_txpower> 11G mode\n");
 
-			power_setting = ((0x3f-priv->byCurPwr) << 20) |
+			power_setting = ((0x3f-power) << 20) |
 				(0x7 << 8) | (BY_VT3226_REG_LEN << 3) |
 					IFREGCTL_REGW;
 
@@ -912,10 +912,10 @@ int vnt_rf_set_txpower(struct vnt_private *priv, u8 power, u32 rate)
 		break;
 
 	case RF_VT3342A0:
-		if (priv->byCurPwr >= VT3342_PWR_IDX_LEN)
+		if (power >= VT3342_PWR_IDX_LEN)
 			return false;
 
-		power_setting =  ((0x3F-priv->byCurPwr) << 20) |
+		power_setting =  ((0x3F-power) << 20) |
 			(0x27 << 8) | (BY_VT3342_REG_LEN << 3) |
 					IFREGCTL_REGW;
 
-- 
1.8.1.2

