Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:54945 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561AbaKLVME (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2014 16:12:04 -0500
Received: by mail-wi0-f182.google.com with SMTP id d1so6231565wiv.9
        for <linux-wireless@vger.kernel.org>; Wed, 12 Nov 2014 13:12:03 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 8/8] staging: vt6655: rf.c clean up function comments
Date: Wed, 12 Nov 2014 21:11:15 +0000
Message-Id: <1415826675-8446-8-git-send-email-tvboxspy@gmail.com> (sfid-20141112_221211_812392_CC73AFE5)
In-Reply-To: <1415826675-8446-1-git-send-email-tvboxspy@gmail.com>
References: <1415826675-8446-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/rf.c | 59 ++++++++++++++++++++++++---------------------
 1 file changed, 31 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/vt6655/rf.c b/drivers/staging/vt6655/rf.c
index 0b16ebf..32ef993 100644
--- a/drivers/staging/vt6655/rf.c
+++ b/drivers/staging/vt6655/rf.c
@@ -424,7 +424,7 @@ static bool s_bAL7230Init(struct vnt_private *priv)
 
 	bResult = true;
 
-	//3-wire control for normal mode
+	/* 3-wire control for normal mode */
 	VNSvOutPortB(dwIoBase + MAC_REG_SOFTPWRCTL, 0);
 
 	MACvWordRegBitsOn(dwIoBase, MAC_REG_SOFTPWRCTL, (SOFTPWRCTL_SWPECTI  |
@@ -434,10 +434,10 @@ static bool s_bAL7230Init(struct vnt_private *priv)
 	for (ii = 0; ii < CB_AL7230_INIT_SEQ; ii++)
 		bResult &= IFRFbWriteEmbedded(priv, dwAL7230InitTable[ii]);
 
-	// PLL On
+	/* PLL On */
 	MACvWordRegBitsOn(dwIoBase, MAC_REG_SOFTPWRCTL, SOFTPWRCTL_SWPE3);
 
-	//Calibration
+	/* Calibration */
 	MACvTimer0MicroSDelay(dwIoBase, 150);//150us
 	/* TXDCOC:active, RCK:disable */
 	bResult &= IFRFbWriteEmbedded(priv, (0x9ABA8F00+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW));
@@ -455,14 +455,15 @@ static bool s_bAL7230Init(struct vnt_private *priv)
 
 	BBvPowerSaveModeON(priv); /* RobertYu:20050106 */
 
-	// PE1: TX_ON, PE2: RX_ON, PE3: PLLON
-	//3-wire control for power saving mode
+	/* PE1: TX_ON, PE2: RX_ON, PE3: PLLON */
+	/* 3-wire control for power saving mode */
 	VNSvOutPortB(dwIoBase + MAC_REG_PSPWRSIG, (PSSIG_WPE3 | PSSIG_WPE2)); //1100 0000
 
 	return bResult;
 }
 
-// Need to Pull PLLON low when writing channel registers through 3-wire interface
+/* Need to Pull PLLON low when writing channel registers through
+ * 3-wire interface */
 static bool s_bAL7230SelectChannel(struct vnt_private *priv, unsigned char byChannel)
 {
 	void __iomem *dwIoBase = priv->PortOffset;
@@ -470,20 +471,20 @@ static bool s_bAL7230SelectChannel(struct vnt_private *priv, unsigned char byCha
 
 	bResult = true;
 
-	// PLLON Off
+	/* PLLON Off */
 	MACvWordRegBitsOff(dwIoBase, MAC_REG_SOFTPWRCTL, SOFTPWRCTL_SWPE3);
 
 	bResult &= IFRFbWriteEmbedded(priv, dwAL7230ChannelTable0[byChannel - 1]);
 	bResult &= IFRFbWriteEmbedded(priv, dwAL7230ChannelTable1[byChannel - 1]);
 	bResult &= IFRFbWriteEmbedded(priv, dwAL7230ChannelTable2[byChannel - 1]);
 
-	// PLLOn On
+	/* PLLOn On */
 	MACvWordRegBitsOn(dwIoBase, MAC_REG_SOFTPWRCTL, SOFTPWRCTL_SWPE3);
 
-	// Set Channel[7] = 0 to tell H/W channel is changing now.
+	/* Set Channel[7] = 0 to tell H/W channel is changing now. */
 	VNSvOutPortB(dwIoBase + MAC_REG_CHANNEL, (byChannel & 0x7F));
 	MACvTimer0MicroSDelay(dwIoBase, SWITCH_CHANNEL_DELAY_AL7230);
-	// Set Channel[7] = 1 to tell H/W channel change is done.
+	/* Set Channel[7] = 1 to tell H/W channel change is done. */
 	VNSvOutPortB(dwIoBase + MAC_REG_CHANNEL, (byChannel | 0x80));
 
 	return bResult;
@@ -510,7 +511,7 @@ bool IFRFbWriteEmbedded(struct vnt_private *priv, unsigned long dwData)
 
 	VNSvOutPortD(dwIoBase + MAC_REG_IFREGCTL, dwData);
 
-	// W_MAX_TIMEOUT is the timeout period
+	/* W_MAX_TIMEOUT is the timeout period */
 	for (ww = 0; ww < W_MAX_TIMEOUT; ww++) {
 		VNSvInPortD(dwIoBase + MAC_REG_IFREGCTL, &dwValue);
 		if (dwValue & IFREGCTL_DONE)
@@ -543,23 +544,22 @@ static bool RFbAL2230Init(struct vnt_private *priv)
 
 	bResult = true;
 
-	//3-wire control for normal mode
+	/* 3-wire control for normal mode */
 	VNSvOutPortB(dwIoBase + MAC_REG_SOFTPWRCTL, 0);
 
 	MACvWordRegBitsOn(dwIoBase, MAC_REG_SOFTPWRCTL, (SOFTPWRCTL_SWPECTI  |
 							 SOFTPWRCTL_TXPEINV));
-	// PLL  Off
-
+	/* PLL  Off */
 	MACvWordRegBitsOff(dwIoBase, MAC_REG_SOFTPWRCTL, SOFTPWRCTL_SWPE3);
 
-	//patch abnormal AL2230 frequency output
+	/* patch abnormal AL2230 frequency output */
 	IFRFbWriteEmbedded(priv, (0x07168700+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW));
 
 	for (ii = 0; ii < CB_AL2230_INIT_SEQ; ii++)
 		bResult &= IFRFbWriteEmbedded(priv, dwAL2230InitTable[ii]);
 	MACvTimer0MicroSDelay(dwIoBase, 30); //delay 30 us
 
-	// PLL On
+	/* PLL On */
 	MACvWordRegBitsOn(dwIoBase, MAC_REG_SOFTPWRCTL, SOFTPWRCTL_SWPE3);
 
 	MACvTimer0MicroSDelay(dwIoBase, 150);//150us
@@ -574,7 +574,7 @@ static bool RFbAL2230Init(struct vnt_private *priv)
 							 SOFTPWRCTL_SWPECTI  |
 							 SOFTPWRCTL_TXPEINV));
 
-	//3-wire control for power saving mode
+	/* 3-wire control for power saving mode */
 	VNSvOutPortB(dwIoBase + MAC_REG_PSPWRSIG, (PSSIG_WPE3 | PSSIG_WPE2)); //1100 0000
 
 	return bResult;
@@ -590,10 +590,10 @@ static bool RFbAL2230SelectChannel(struct vnt_private *priv, unsigned char byCha
 	bResult &= IFRFbWriteEmbedded(priv, dwAL2230ChannelTable0[byChannel - 1]);
 	bResult &= IFRFbWriteEmbedded(priv, dwAL2230ChannelTable1[byChannel - 1]);
 
-	// Set Channel[7] = 0 to tell H/W channel is changing now.
+	/* Set Channel[7] = 0 to tell H/W channel is changing now. */
 	VNSvOutPortB(dwIoBase + MAC_REG_CHANNEL, (byChannel & 0x7F));
 	MACvTimer0MicroSDelay(dwIoBase, SWITCH_CHANNEL_DELAY_AL2230);
-	// Set Channel[7] = 1 to tell H/W channel change is done.
+	/* Set Channel[7] = 1 to tell H/W channel change is done. */
 	VNSvOutPortB(dwIoBase + MAC_REG_CHANNEL, (byChannel | 0x80));
 
 	return bResult;
@@ -702,7 +702,8 @@ bool RFvWriteWakeProgSyn(struct vnt_private *priv, unsigned char byRFType, unsig
 		if (uChannel > CB_MAX_CHANNEL_24G)
 			return false;
 
-		byInitCount = CB_AL2230_INIT_SEQ + 2; // Init Reg + Channel Reg (2)
+		 /* Init Reg + Channel Reg (2) */
+		byInitCount = CB_AL2230_INIT_SEQ + 2;
 		bySleepCount = 0;
 		if (byInitCount > (MISCFIFO_SYNDATASIZE - bySleepCount))
 			return false;
@@ -715,9 +716,10 @@ bool RFvWriteWakeProgSyn(struct vnt_private *priv, unsigned char byRFType, unsig
 		MACvSetMISCFifo(dwIoBase, (unsigned short)(MISCFIFO_SYNDATA_IDX + ii), dwAL2230ChannelTable1[uChannel-1]);
 		break;
 
-		// Need to check, PLLON need to be low for channel setting
+		/* Need to check, PLLON need to be low for channel setting */
 	case RF_AIROHA7230:
-		byInitCount = CB_AL7230_INIT_SEQ + 3; // Init Reg + Channel Reg (3)
+		 /* Init Reg + Channel Reg (3) */
+		byInitCount = CB_AL7230_INIT_SEQ + 3;
 		bySleepCount = 0;
 		if (byInitCount > (MISCFIFO_SYNDATASIZE - bySleepCount))
 			return false;
@@ -878,7 +880,8 @@ bool RFbRawSetPower(
 		break;
 
 	case RF_AIROHA7230:
-		//  0x080F1B00 for 3 wire control TxGain(D10) and 0x31 as TX Gain value
+		/* 0x080F1B00 for 3 wire control TxGain(D10)
+		 * and 0x31 as TX Gain value */
 		dwMax7230Pwr = 0x080C0B00 | ((byPwr) << 12) |
 			(BY_AL7230_REG_LEN << 3)  | IFREGCTL_REGW;
 
@@ -931,8 +934,8 @@ RFvRSSITodBm(
 	*pldBm = -1 * (a + b * 2);
 }
 
-// Post processing for the 11b/g and 11a.
-// for save time on changing Reg2,3,5,7,10,12,15
+/* Post processing for the 11b/g and 11a.
+ * for save time on changing Reg2,3,5,7,10,12,15 */
 bool RFbAL7230SelectChannelPostProcess(struct vnt_private *priv,
 				       unsigned char byOldChannel,
 				       unsigned char byNewChannel)
@@ -941,9 +944,9 @@ bool RFbAL7230SelectChannelPostProcess(struct vnt_private *priv,
 
 	bResult = true;
 
-	// if change between 11 b/g and 11a need to update the following register
-	// Channel Index 1~14
-
+	/* if change between 11 b/g and 11a need to update the following
+	 * register
+	 * Channel Index 1~14 */
 	if ((byOldChannel <= CB_MAX_CHANNEL_24G) && (byNewChannel > CB_MAX_CHANNEL_24G)) {
 		/* Change from 2.4G to 5G [Reg] */
 		bResult &= IFRFbWriteEmbedded(priv, dwAL7230InitTableAMode[2]);
-- 
2.1.0

