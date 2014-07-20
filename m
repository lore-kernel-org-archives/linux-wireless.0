Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:48718 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717AbaGTOec (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 10:34:32 -0400
Received: by mail-we0-f182.google.com with SMTP id k48so5262090wev.13
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 07:34:31 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 08/25] staging: vt6656: struct vnt_private rf power table remove camel case
Date: Sun, 20 Jul 2014 15:33:18 +0100
Message-Id: <1405866815-2687-8-git-send-email-tvboxspy@gmail.com> (sfid-20140720_163441_688889_20E44B95)
In-Reply-To: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
References: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Camel case changes
byCCKPwr -> cck_pwr
byOFDMPwrG -> ofdm_pwr_g
byOFDMPwrA -> ofdm_pwr_a
byCurPwr -> power
abyCCKPwrTbl -> cck_pwr_tbl
abyOFDMPwrTbl -> ofdm_pwr_tbl
abyOFDMAPwrTbl -> ofdm_a_pwr_tbl

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   | 14 +++++++-------
 drivers/staging/vt6656/main_usb.c | 30 +++++++++++++++---------------
 drivers/staging/vt6656/rf.c       | 14 +++++++-------
 3 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 466a984..4424d75 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -341,13 +341,13 @@ struct vnt_private {
 	u8 preamble_type;
 
 	/* For RF Power table */
-	u8 byCCKPwr;
-	u8 byOFDMPwrG;
-	u8 byOFDMPwrA;
-	u8 byCurPwr;
-	u8 abyCCKPwrTbl[14];
-	u8 abyOFDMPwrTbl[14];
-	u8 abyOFDMAPwrTbl[42];
+	u8 cck_pwr;
+	u8 ofdm_pwr_g;
+	u8 ofdm_pwr_a;
+	u8 power;
+	u8 cck_pwr_tbl[14];
+	u8 ofdm_pwr_tbl[14];
+	u8 ofdm_a_pwr_tbl[42];
 
 	u16 wCurrentRate;
 	u16 tx_rate_fb0;
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 325daae..8fb602a 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -199,21 +199,21 @@ static int device_init_registers(struct vnt_private *priv)
 	priv->top_cck_basic_rate = RATE_1M;
 
 	/* target to IF pin while programming to RF chip */
-	priv->byCurPwr = 0xFF;
+	priv->power = 0xFF;
 
-	priv->byCCKPwr = priv->eeprom[EEP_OFS_PWR_CCK];
-	priv->byOFDMPwrG = priv->eeprom[EEP_OFS_PWR_OFDMG];
+	priv->cck_pwr = priv->eeprom[EEP_OFS_PWR_CCK];
+	priv->ofdm_pwr_g = priv->eeprom[EEP_OFS_PWR_OFDMG];
 	/* load power table */
 	for (ii = 0; ii < 14; ii++) {
-		priv->abyCCKPwrTbl[ii] =
+		priv->cck_pwr_tbl[ii] =
 			priv->eeprom[ii + EEP_OFS_CCK_PWR_TBL];
+		if (priv->cck_pwr_tbl[ii] == 0)
+			priv->cck_pwr_tbl[ii] = priv->cck_pwr;
 
-		if (priv->abyCCKPwrTbl[ii] == 0)
-			priv->abyCCKPwrTbl[ii] = priv->byCCKPwr;
-		priv->abyOFDMPwrTbl[ii] =
+		priv->ofdm_pwr_tbl[ii] =
 				priv->eeprom[ii + EEP_OFS_OFDM_PWR_TBL];
-		if (priv->abyOFDMPwrTbl[ii] == 0)
-			priv->abyOFDMPwrTbl[ii] = priv->byOFDMPwrG;
+		if (priv->ofdm_pwr_tbl[ii] == 0)
+			priv->ofdm_pwr_tbl[ii] = priv->ofdm_pwr_g;
 	}
 
 	/*
@@ -221,19 +221,19 @@ static int device_init_registers(struct vnt_private *priv)
 	 * then need to recover 12, 13, 14 channels with 11 channel
 	 */
 	for (ii = 11; ii < 14; ii++) {
-		priv->abyCCKPwrTbl[ii] = priv->abyCCKPwrTbl[10];
-		priv->abyOFDMPwrTbl[ii] = priv->abyOFDMPwrTbl[10];
+		priv->cck_pwr_tbl[ii] = priv->cck_pwr_tbl[10];
+		priv->ofdm_pwr_tbl[ii] = priv->ofdm_pwr_tbl[10];
 	}
 
-	priv->byOFDMPwrA = 0x34; /* same as RFbMA2829SelectChannel */
+	priv->ofdm_pwr_a = 0x34; /* same as RFbMA2829SelectChannel */
 
 	/* load OFDM A power table */
 	for (ii = 0; ii < CB_MAX_CHANNEL_5G; ii++) {
-		priv->abyOFDMAPwrTbl[ii] =
+		priv->ofdm_a_pwr_tbl[ii] =
 			priv->eeprom[ii + EEP_OFS_OFDMA_PWR_TBL];
 
-		if (priv->abyOFDMAPwrTbl[ii] == 0)
-			priv->abyOFDMAPwrTbl[ii] = priv->byOFDMPwrA;
+		if (priv->ofdm_a_pwr_tbl[ii] == 0)
+			priv->ofdm_a_pwr_tbl[ii] = priv->ofdm_pwr_a;
 	}
 
 	antenna = priv->eeprom[EEP_OFS_ANTENNA];
diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index 3815db9..c0edcae 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -624,7 +624,7 @@ int vnt_rf_write_embedded(struct vnt_private *priv, u32 data)
 int vnt_rf_setpower(struct vnt_private *priv, u32 rate, u32 channel)
 {
 	int ret = true;
-	u8 power = priv->byCCKPwr;
+	u8 power = priv->cck_pwr;
 
 	if (channel == 0)
 		return -EINVAL;
@@ -636,8 +636,8 @@ int vnt_rf_setpower(struct vnt_private *priv, u32 rate, u32 channel)
 	case RATE_11M:
 		channel--;
 
-		if (channel < sizeof(priv->abyCCKPwrTbl))
-			power = priv->abyCCKPwrTbl[channel];
+		if (channel < sizeof(priv->cck_pwr_tbl))
+			power = priv->cck_pwr_tbl[channel];
 		break;
 	case RATE_6M:
 	case RATE_9M:
@@ -647,9 +647,9 @@ int vnt_rf_setpower(struct vnt_private *priv, u32 rate, u32 channel)
 	case RATE_48M:
 	case RATE_54M:
 		if (channel > CB_MAX_CHANNEL_24G)
-			power = priv->abyOFDMAPwrTbl[channel-15];
+			power = priv->ofdm_a_pwr_tbl[channel-15];
 		else
-			power = priv->abyOFDMPwrTbl[channel-1];
+			power = priv->ofdm_pwr_tbl[channel-1];
 		break;
 	}
 
@@ -694,10 +694,10 @@ int vnt_rf_set_txpower(struct vnt_private *priv, u8 power, u32 rate)
 	if (power > VNT_RF_MAX_POWER)
 		power = VNT_RF_MAX_POWER;
 
-	if (priv->byCurPwr == power)
+	if (priv->power == power)
 		return true;
 
-	priv->byCurPwr = power;
+	priv->power = power;
 
 	switch (priv->rf_type) {
 	case RF_AL2230:
-- 
2.0.1

