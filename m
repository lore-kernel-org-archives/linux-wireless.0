Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:36571 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761022AbaGSLbW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2014 07:31:22 -0400
Received: by mail-we0-f178.google.com with SMTP id w61so5643275wes.9
        for <linux-wireless@vger.kernel.org>; Sat, 19 Jul 2014 04:31:21 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 14/16] staging: vt6656: struct vnt_private remove camel case antenna variables
Date: Sat, 19 Jul 2014 12:30:16 +0100
Message-Id: <1405769418-2815-14-git-send-email-tvboxspy@gmail.com> (sfid-20140719_135109_165357_E14F3D93)
In-Reply-To: <1405769418-2815-1-git-send-email-tvboxspy@gmail.com>
References: <1405769418-2815-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Camel case changes
bTxRxAntInv -> tx_rx_ant_inv
dwRxAntennaSel -> rx_antenna_sel
byRxAntennaMode -> rx_antenna_mode
byTxAntennaMode -> tx_antenna_mode
byRadioCtl -> radio_ctl

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   | 10 +++++-----
 drivers/staging/vt6656/main_usb.c | 38 +++++++++++++++++++-------------------
 drivers/staging/vt6656/wcmd.c     | 12 ++++++------
 3 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index ecf8da0..c4e83b5 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -317,11 +317,11 @@ struct vnt_private {
 	u32 current_rssi;
 
 	/* Antenna Diversity */
-	int bTxRxAntInv;
-	u32 dwRxAntennaSel;
-	u8 byRxAntennaMode;
-	u8 byTxAntennaMode;
-	u8 byRadioCtl;
+	int tx_rx_ant_inv;
+	u32 rx_antenna_sel;
+	u8 rx_antenna_mode;
+	u8 tx_antenna_mode;
+	u8 radio_ctl;
 
 	/* IFS & Cw */
 	u32 uSIFS;  /* Current SIFS */
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 4ca6639..1137a19 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -239,9 +239,9 @@ static int device_init_registers(struct vnt_private *priv)
 	antenna = priv->abyEEPROM[EEP_OFS_ANTENNA];
 
 	if (antenna & EEP_ANTINV)
-		priv->bTxRxAntInv = true;
+		priv->tx_rx_ant_inv = true;
 	else
-		priv->bTxRxAntInv = false;
+		priv->tx_rx_ant_inv = false;
 
 	antenna &= (EEP_ANTENNA_AUX | EEP_ANTENNA_MAIN);
 
@@ -249,35 +249,35 @@ static int device_init_registers(struct vnt_private *priv)
 		antenna = (EEP_ANTENNA_AUX | EEP_ANTENNA_MAIN);
 
 	if (antenna == (EEP_ANTENNA_AUX | EEP_ANTENNA_MAIN)) {
-		priv->byTxAntennaMode = ANT_B;
-		priv->dwRxAntennaSel = 1;
+		priv->tx_antenna_mode = ANT_B;
+		priv->rx_antenna_sel = 1;
 
-		if (priv->bTxRxAntInv == true)
-			priv->byRxAntennaMode = ANT_A;
+		if (priv->tx_rx_ant_inv == true)
+			priv->rx_antenna_mode = ANT_A;
 		else
-			priv->byRxAntennaMode = ANT_B;
+			priv->rx_antenna_mode = ANT_B;
 	} else  {
-		priv->dwRxAntennaSel = 0;
+		priv->rx_antenna_sel = 0;
 
 		if (antenna & EEP_ANTENNA_AUX) {
-			priv->byTxAntennaMode = ANT_A;
+			priv->tx_antenna_mode = ANT_A;
 
-			if (priv->bTxRxAntInv == true)
-				priv->byRxAntennaMode = ANT_B;
+			if (priv->tx_rx_ant_inv == true)
+				priv->rx_antenna_mode = ANT_B;
 			else
-				priv->byRxAntennaMode = ANT_A;
+				priv->rx_antenna_mode = ANT_A;
 		} else {
-			priv->byTxAntennaMode = ANT_B;
+			priv->tx_antenna_mode = ANT_B;
 
-		if (priv->bTxRxAntInv == true)
-			priv->byRxAntennaMode = ANT_A;
+		if (priv->tx_rx_ant_inv == true)
+			priv->rx_antenna_mode = ANT_A;
 		else
-			priv->byRxAntennaMode = ANT_B;
+			priv->rx_antenna_mode = ANT_B;
 		}
 	}
 
 	/* Set initial antenna mode */
-	vnt_set_antenna_mode(priv, priv->byRxAntennaMode);
+	vnt_set_antenna_mode(priv, priv->rx_antenna_mode);
 
 	/* get Auto Fall Back type */
 	priv->byAutoFBCtrl = AUTO_FB_0;
@@ -348,9 +348,9 @@ static int device_init_registers(struct vnt_private *priv)
 
 	vnt_set_short_slot_time(priv);
 
-	priv->byRadioCtl = priv->abyEEPROM[EEP_OFS_RADIOCTL];
+	priv->radio_ctl = priv->abyEEPROM[EEP_OFS_RADIOCTL];
 
-	if ((priv->byRadioCtl & EEP_RADIOCTL_ENABLE) != 0) {
+	if ((priv->radio_ctl & EEP_RADIOCTL_ENABLE) != 0) {
 		status = vnt_control_in(priv, MESSAGE_TYPE_READ,
 			MAC_REG_GPIOCTL1, MESSAGE_REQUEST_MACREG, 1, &tmp);
 
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index c56b7b3..304f6d6 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -146,17 +146,17 @@ void vnt_run_command(struct work_struct *work)
 
 	case WLAN_CMD_CHANGE_ANTENNA_START:
 		dev_dbg(&priv->usb->dev, "Change from Antenna%d to",
-							priv->dwRxAntennaSel);
+							priv->rx_antenna_sel);
 
-		if (priv->dwRxAntennaSel == 0) {
-			priv->dwRxAntennaSel = 1;
-			if (priv->bTxRxAntInv == true)
+		if (priv->rx_antenna_sel == 0) {
+			priv->rx_antenna_sel = 1;
+			if (priv->tx_rx_ant_inv == true)
 				vnt_set_antenna_mode(priv, ANT_RXA);
 			else
 				vnt_set_antenna_mode(priv, ANT_RXB);
 		} else {
-			priv->dwRxAntennaSel = 0;
-			if (priv->bTxRxAntInv == true)
+			priv->rx_antenna_sel = 0;
+			if (priv->tx_rx_ant_inv == true)
 				vnt_set_antenna_mode(priv, ANT_RXB);
 			else
 				vnt_set_antenna_mode(priv, ANT_RXA);
-- 
2.0.1

