Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:46082 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbaGTOe3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 10:34:29 -0400
Received: by mail-wi0-f174.google.com with SMTP id d1so2907744wiv.1
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 07:34:27 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 06/25] staging: vt6656: struct vnt_private replace abyEEPROM with eeprom
Date: Sun, 20 Jul 2014 15:33:16 +0100
Message-Id: <1405866815-2687-6-git-send-email-tvboxspy@gmail.com> (sfid-20140720_163435_057089_2AED2C0D)
In-Reply-To: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
References: <1405866815-2687-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing type prefix and camel case.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c |  4 ++--
 drivers/staging/vt6656/device.h   |  2 +-
 drivers/staging/vt6656/main_usb.c | 24 ++++++++++++------------
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 6af9fcb..9598c19 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -390,11 +390,11 @@ int vnt_vt3184_init(struct vnt_private *priv)
 
 	status = vnt_control_in(priv, MESSAGE_TYPE_READ, 0,
 		MESSAGE_REQUEST_EEPROM, EEP_MAX_CONTEXT_SIZE,
-						priv->abyEEPROM);
+						priv->eeprom);
 	if (status != STATUS_SUCCESS)
 		return false;
 
-	priv->rf_type = priv->abyEEPROM[EEP_OFS_RFTYPE];
+	priv->rf_type = priv->eeprom[EEP_OFS_RFTYPE];
 
 	dev_dbg(&priv->usb->dev, "RF Type %d\n", priv->rf_type);
 
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index dcb57dc..07e9d03 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -336,7 +336,7 @@ struct vnt_private {
 	u8 top_ofdm_basic_rate;
 	u8 top_cck_basic_rate;
 
-	u8 abyEEPROM[EEP_MAX_CONTEXT_SIZE];  /*u32 alignment */
+	u8 eeprom[EEP_MAX_CONTEXT_SIZE];  /*u32 alignment */
 
 	u8 byPreambleType;
 
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index f5227ee..4054e36 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -201,17 +201,17 @@ static int device_init_registers(struct vnt_private *priv)
 	/* target to IF pin while programming to RF chip */
 	priv->byCurPwr = 0xFF;
 
-	priv->byCCKPwr = priv->abyEEPROM[EEP_OFS_PWR_CCK];
-	priv->byOFDMPwrG = priv->abyEEPROM[EEP_OFS_PWR_OFDMG];
+	priv->byCCKPwr = priv->eeprom[EEP_OFS_PWR_CCK];
+	priv->byOFDMPwrG = priv->eeprom[EEP_OFS_PWR_OFDMG];
 	/* load power table */
 	for (ii = 0; ii < 14; ii++) {
 		priv->abyCCKPwrTbl[ii] =
-			priv->abyEEPROM[ii + EEP_OFS_CCK_PWR_TBL];
+			priv->eeprom[ii + EEP_OFS_CCK_PWR_TBL];
 
 		if (priv->abyCCKPwrTbl[ii] == 0)
 			priv->abyCCKPwrTbl[ii] = priv->byCCKPwr;
 		priv->abyOFDMPwrTbl[ii] =
-				priv->abyEEPROM[ii + EEP_OFS_OFDM_PWR_TBL];
+				priv->eeprom[ii + EEP_OFS_OFDM_PWR_TBL];
 		if (priv->abyOFDMPwrTbl[ii] == 0)
 			priv->abyOFDMPwrTbl[ii] = priv->byOFDMPwrG;
 	}
@@ -230,13 +230,13 @@ static int device_init_registers(struct vnt_private *priv)
 	/* load OFDM A power table */
 	for (ii = 0; ii < CB_MAX_CHANNEL_5G; ii++) {
 		priv->abyOFDMAPwrTbl[ii] =
-			priv->abyEEPROM[ii + EEP_OFS_OFDMA_PWR_TBL];
+			priv->eeprom[ii + EEP_OFS_OFDMA_PWR_TBL];
 
 		if (priv->abyOFDMAPwrTbl[ii] == 0)
 			priv->abyOFDMAPwrTbl[ii] = priv->byOFDMPwrA;
 	}
 
-	antenna = priv->abyEEPROM[EEP_OFS_ANTENNA];
+	antenna = priv->eeprom[EEP_OFS_ANTENNA];
 
 	if (antenna & EEP_ANTINV)
 		priv->tx_rx_ant_inv = true;
@@ -290,12 +290,12 @@ static int device_init_registers(struct vnt_private *priv)
 
 	/* load vt3266 calibration parameters in EEPROM */
 	if (priv->rf_type == RF_VT3226D0) {
-		if ((priv->abyEEPROM[EEP_OFS_MAJOR_VER] == 0x1) &&
-		    (priv->abyEEPROM[EEP_OFS_MINOR_VER] >= 0x4)) {
+		if ((priv->eeprom[EEP_OFS_MAJOR_VER] == 0x1) &&
+		    (priv->eeprom[EEP_OFS_MINOR_VER] >= 0x4)) {
 
-			calib_tx_iq = priv->abyEEPROM[EEP_OFS_CALIB_TX_IQ];
-			calib_tx_dc = priv->abyEEPROM[EEP_OFS_CALIB_TX_DC];
-			calib_rx_iq = priv->abyEEPROM[EEP_OFS_CALIB_RX_IQ];
+			calib_tx_iq = priv->eeprom[EEP_OFS_CALIB_TX_IQ];
+			calib_tx_dc = priv->eeprom[EEP_OFS_CALIB_TX_DC];
+			calib_rx_iq = priv->eeprom[EEP_OFS_CALIB_RX_IQ];
 			if (calib_tx_iq || calib_tx_dc || calib_rx_iq) {
 				/* CR255, enable TX/RX IQ and
 				   DC compensation mode */
@@ -348,7 +348,7 @@ static int device_init_registers(struct vnt_private *priv)
 
 	vnt_set_short_slot_time(priv);
 
-	priv->radio_ctl = priv->abyEEPROM[EEP_OFS_RADIOCTL];
+	priv->radio_ctl = priv->eeprom[EEP_OFS_RADIOCTL];
 
 	if ((priv->radio_ctl & EEP_RADIOCTL_ENABLE) != 0) {
 		status = vnt_control_in(priv, MESSAGE_TYPE_READ,
-- 
2.0.1

