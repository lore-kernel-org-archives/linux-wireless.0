Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:46290 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404AbaKLVL6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2014 16:11:58 -0500
Received: by mail-wi0-f175.google.com with SMTP id l15so2291543wiw.2
        for <linux-wireless@vger.kernel.org>; Wed, 12 Nov 2014 13:11:56 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4/8] staging: vt6655: IFRFbWriteEmbedded replace __iomem with vnt_private
Date: Wed, 12 Nov 2014 21:11:11 +0000
Message-Id: <1415826675-8446-4-git-send-email-tvboxspy@gmail.com> (sfid-20141112_221202_091287_BD263931)
In-Reply-To: <1415826675-8446-1-git-send-email-tvboxspy@gmail.com>
References: <1415826675-8446-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixing callers to vnt_private

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/rf.c | 85 +++++++++++++++++++++++----------------------
 drivers/staging/vt6655/rf.h |  2 +-
 2 files changed, 45 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/vt6655/rf.c b/drivers/staging/vt6655/rf.c
index da2c5e6..3b7ad49 100644
--- a/drivers/staging/vt6655/rf.c
+++ b/drivers/staging/vt6655/rf.c
@@ -440,18 +440,21 @@ static bool s_bAL7230Init(struct vnt_private *priv)
 	BBvPowerSaveModeOFF(priv); /* RobertYu:20050106, have DC value for Calibration */
 
 	for (ii = 0; ii < CB_AL7230_INIT_SEQ; ii++)
-		bResult &= IFRFbWriteEmbedded(dwIoBase, dwAL7230InitTable[ii]);
+		bResult &= IFRFbWriteEmbedded(priv, dwAL7230InitTable[ii]);
 
 	// PLL On
 	MACvWordRegBitsOn(dwIoBase, MAC_REG_SOFTPWRCTL, SOFTPWRCTL_SWPE3);
 
 	//Calibration
 	MACvTimer0MicroSDelay(dwIoBase, 150);//150us
-	bResult &= IFRFbWriteEmbedded(dwIoBase, (0x9ABA8F00+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW)); //TXDCOC:active, RCK:disable
+	/* TXDCOC:active, RCK:disable */
+	bResult &= IFRFbWriteEmbedded(priv, (0x9ABA8F00+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW));
 	MACvTimer0MicroSDelay(dwIoBase, 30);//30us
-	bResult &= IFRFbWriteEmbedded(dwIoBase, (0x3ABA8F00+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW)); //TXDCOC:disable, RCK:active
+	/* TXDCOC:disable, RCK:active */
+	bResult &= IFRFbWriteEmbedded(priv, (0x3ABA8F00+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW));
 	MACvTimer0MicroSDelay(dwIoBase, 30);//30us
-	bResult &= IFRFbWriteEmbedded(dwIoBase, dwAL7230InitTable[CB_AL7230_INIT_SEQ-1]); //TXDCOC:disable, RCK:disable
+	/* TXDCOC:disable, RCK:disable */
+	bResult &= IFRFbWriteEmbedded(priv, dwAL7230InitTable[CB_AL7230_INIT_SEQ-1]);
 
 	MACvWordRegBitsOn(dwIoBase, MAC_REG_SOFTPWRCTL, (SOFTPWRCTL_SWPE3    |
 							 SOFTPWRCTL_SWPE2    |
@@ -478,9 +481,9 @@ static bool s_bAL7230SelectChannel(struct vnt_private *priv, unsigned char byCha
 	// PLLON Off
 	MACvWordRegBitsOff(dwIoBase, MAC_REG_SOFTPWRCTL, SOFTPWRCTL_SWPE3);
 
-	bResult &= IFRFbWriteEmbedded(dwIoBase, dwAL7230ChannelTable0[byChannel - 1]); //Reg0
-	bResult &= IFRFbWriteEmbedded(dwIoBase, dwAL7230ChannelTable1[byChannel - 1]); //Reg1
-	bResult &= IFRFbWriteEmbedded(dwIoBase, dwAL7230ChannelTable2[byChannel - 1]); //Reg4
+	bResult &= IFRFbWriteEmbedded(priv, dwAL7230ChannelTable0[byChannel - 1]);
+	bResult &= IFRFbWriteEmbedded(priv, dwAL7230ChannelTable1[byChannel - 1]);
+	bResult &= IFRFbWriteEmbedded(priv, dwAL7230ChannelTable2[byChannel - 1]);
 
 	// PLLOn On
 	MACvWordRegBitsOn(dwIoBase, MAC_REG_SOFTPWRCTL, SOFTPWRCTL_SWPE3);
@@ -569,8 +572,9 @@ static bool s_bAL7230SelectChannel(struct vnt_private *priv, unsigned char byCha
  * Return Value: true if succeeded; false if failed.
  *
  */
-bool IFRFbWriteEmbedded(void __iomem *dwIoBase, unsigned long dwData)
+bool IFRFbWriteEmbedded(struct vnt_private *priv, unsigned long dwData)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
 	unsigned short ww;
 	unsigned long dwValue;
 
@@ -648,10 +652,10 @@ static bool RFbAL2230Init(struct vnt_private *priv)
 
 	//patch abnormal AL2230 frequency output
 //2008-8-21 chester <add>
-	IFRFbWriteEmbedded(dwIoBase, (0x07168700+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW));
+	IFRFbWriteEmbedded(priv, (0x07168700+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW));
 
 	for (ii = 0; ii < CB_AL2230_INIT_SEQ; ii++)
-		bResult &= IFRFbWriteEmbedded(dwIoBase, dwAL2230InitTable[ii]);
+		bResult &= IFRFbWriteEmbedded(priv, dwAL2230InitTable[ii]);
 //2008-8-21 chester <add>
 	MACvTimer0MicroSDelay(dwIoBase, 30); //delay 30 us
 
@@ -659,11 +663,11 @@ static bool RFbAL2230Init(struct vnt_private *priv)
 	MACvWordRegBitsOn(dwIoBase, MAC_REG_SOFTPWRCTL, SOFTPWRCTL_SWPE3);
 
 	MACvTimer0MicroSDelay(dwIoBase, 150);//150us
-	bResult &= IFRFbWriteEmbedded(dwIoBase, (0x00d80f00+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW));
+	bResult &= IFRFbWriteEmbedded(priv, (0x00d80f00+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW));
 	MACvTimer0MicroSDelay(dwIoBase, 30);//30us
-	bResult &= IFRFbWriteEmbedded(dwIoBase, (0x00780f00+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW));
+	bResult &= IFRFbWriteEmbedded(priv, (0x00780f00+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW));
 	MACvTimer0MicroSDelay(dwIoBase, 30);//30us
-	bResult &= IFRFbWriteEmbedded(dwIoBase, dwAL2230InitTable[CB_AL2230_INIT_SEQ-1]);
+	bResult &= IFRFbWriteEmbedded(priv, dwAL2230InitTable[CB_AL2230_INIT_SEQ-1]);
 
 	MACvWordRegBitsOn(dwIoBase, MAC_REG_SOFTPWRCTL, (SOFTPWRCTL_SWPE3    |
 							 SOFTPWRCTL_SWPE2    |
@@ -683,8 +687,8 @@ static bool RFbAL2230SelectChannel(struct vnt_private *priv, unsigned char byCha
 
 	bResult = true;
 
-	bResult &= IFRFbWriteEmbedded(dwIoBase, dwAL2230ChannelTable0[byChannel - 1]);
-	bResult &= IFRFbWriteEmbedded(dwIoBase, dwAL2230ChannelTable1[byChannel - 1]);
+	bResult &= IFRFbWriteEmbedded(priv, dwAL2230ChannelTable0[byChannel - 1]);
+	bResult &= IFRFbWriteEmbedded(priv, dwAL2230ChannelTable1[byChannel - 1]);
 
 	// Set Channel[7] = 0 to tell H/W channel is changing now.
 	VNSvOutPortB(dwIoBase + MAC_REG_CHANNEL, (byChannel & 0x7F));
@@ -996,22 +1000,22 @@ bool RFbRawSetPower(
 
 	switch (pDevice->byRFType) {
 	case RF_AIROHA:
-		bResult &= IFRFbWriteEmbedded(pDevice->PortOffset, dwAL2230PowerTable[byPwr]);
+		bResult &= IFRFbWriteEmbedded(pDevice, dwAL2230PowerTable[byPwr]);
 		if (uRATE <= RATE_11M)
-			bResult &= IFRFbWriteEmbedded(pDevice->PortOffset, 0x0001B400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
+			bResult &= IFRFbWriteEmbedded(pDevice, 0x0001B400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
 		else
-			bResult &= IFRFbWriteEmbedded(pDevice->PortOffset, 0x0005A400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
+			bResult &= IFRFbWriteEmbedded(pDevice, 0x0005A400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
 
 		break;
 
 	case RF_AL2230S:
-		bResult &= IFRFbWriteEmbedded(pDevice->PortOffset, dwAL2230PowerTable[byPwr]);
+		bResult &= IFRFbWriteEmbedded(pDevice, dwAL2230PowerTable[byPwr]);
 		if (uRATE <= RATE_11M) {
-			bResult &= IFRFbWriteEmbedded(pDevice->PortOffset, 0x040C1400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
-			bResult &= IFRFbWriteEmbedded(pDevice->PortOffset, 0x00299B00+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
+			bResult &= IFRFbWriteEmbedded(pDevice, 0x040C1400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
+			bResult &= IFRFbWriteEmbedded(pDevice, 0x00299B00+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
 		} else {
-			bResult &= IFRFbWriteEmbedded(pDevice->PortOffset, 0x0005A400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
-			bResult &= IFRFbWriteEmbedded(pDevice->PortOffset, 0x00099B00+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
+			bResult &= IFRFbWriteEmbedded(pDevice, 0x0005A400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
+			bResult &= IFRFbWriteEmbedded(pDevice, 0x00099B00+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
 		}
 
 		break;
@@ -1021,7 +1025,7 @@ bool RFbRawSetPower(
 		dwMax7230Pwr = 0x080C0B00 | ((byPwr) << 12) |
 			(BY_AL7230_REG_LEN << 3)  | IFREGCTL_REGW;
 
-		bResult &= IFRFbWriteEmbedded(pDevice->PortOffset, dwMax7230Pwr);
+		bResult &= IFRFbWriteEmbedded(pDevice, dwMax7230Pwr);
 		break;
 
 	default:
@@ -1079,7 +1083,6 @@ bool RFbAL7230SelectChannelPostProcess(struct vnt_private *priv,
 				       unsigned char byOldChannel,
 				       unsigned char byNewChannel)
 {
-	void __iomem *dwIoBase = priv->PortOffset;
 	bool bResult;
 
 	bResult = true;
@@ -1088,23 +1091,23 @@ bool RFbAL7230SelectChannelPostProcess(struct vnt_private *priv,
 	// Channel Index 1~14
 
 	if ((byOldChannel <= CB_MAX_CHANNEL_24G) && (byNewChannel > CB_MAX_CHANNEL_24G)) {
-		// Change from 2.4G to 5G
-		bResult &= IFRFbWriteEmbedded(dwIoBase, dwAL7230InitTableAMode[2]); //Reg2
-		bResult &= IFRFbWriteEmbedded(dwIoBase, dwAL7230InitTableAMode[3]); //Reg3
-		bResult &= IFRFbWriteEmbedded(dwIoBase, dwAL7230InitTableAMode[5]); //Reg5
-		bResult &= IFRFbWriteEmbedded(dwIoBase, dwAL7230InitTableAMode[7]); //Reg7
-		bResult &= IFRFbWriteEmbedded(dwIoBase, dwAL7230InitTableAMode[10]);//Reg10
-		bResult &= IFRFbWriteEmbedded(dwIoBase, dwAL7230InitTableAMode[12]);//Reg12
-		bResult &= IFRFbWriteEmbedded(dwIoBase, dwAL7230InitTableAMode[15]);//Reg15
+		/* Change from 2.4G to 5G [Reg] */
+		bResult &= IFRFbWriteEmbedded(priv, dwAL7230InitTableAMode[2]);
+		bResult &= IFRFbWriteEmbedded(priv, dwAL7230InitTableAMode[3]);
+		bResult &= IFRFbWriteEmbedded(priv, dwAL7230InitTableAMode[5]);
+		bResult &= IFRFbWriteEmbedded(priv, dwAL7230InitTableAMode[7]);
+		bResult &= IFRFbWriteEmbedded(priv, dwAL7230InitTableAMode[10]);
+		bResult &= IFRFbWriteEmbedded(priv, dwAL7230InitTableAMode[12]);
+		bResult &= IFRFbWriteEmbedded(priv, dwAL7230InitTableAMode[15]);
 	} else if ((byOldChannel > CB_MAX_CHANNEL_24G) && (byNewChannel <= CB_MAX_CHANNEL_24G)) {
-		// change from 5G to 2.4G
-		bResult &= IFRFbWriteEmbedded(dwIoBase, dwAL7230InitTable[2]); //Reg2
-		bResult &= IFRFbWriteEmbedded(dwIoBase, dwAL7230InitTable[3]); //Reg3
-		bResult &= IFRFbWriteEmbedded(dwIoBase, dwAL7230InitTable[5]); //Reg5
-		bResult &= IFRFbWriteEmbedded(dwIoBase, dwAL7230InitTable[7]); //Reg7
-		bResult &= IFRFbWriteEmbedded(dwIoBase, dwAL7230InitTable[10]);//Reg10
-		bResult &= IFRFbWriteEmbedded(dwIoBase, dwAL7230InitTable[12]);//Reg12
-		bResult &= IFRFbWriteEmbedded(dwIoBase, dwAL7230InitTable[15]);//Reg15
+		/* Change from 5G to 2.4G [Reg] */
+		bResult &= IFRFbWriteEmbedded(priv, dwAL7230InitTable[2]);
+		bResult &= IFRFbWriteEmbedded(priv, dwAL7230InitTable[3]);
+		bResult &= IFRFbWriteEmbedded(priv, dwAL7230InitTable[5]);
+		bResult &= IFRFbWriteEmbedded(priv, dwAL7230InitTable[7]);
+		bResult &= IFRFbWriteEmbedded(priv, dwAL7230InitTable[10]);
+		bResult &= IFRFbWriteEmbedded(priv, dwAL7230InitTable[12]);
+		bResult &= IFRFbWriteEmbedded(priv, dwAL7230InitTable[15]);
 	}
 
 	return bResult;
diff --git a/drivers/staging/vt6655/rf.h b/drivers/staging/vt6655/rf.h
index 98c2326..8a6e2cf 100644
--- a/drivers/staging/vt6655/rf.h
+++ b/drivers/staging/vt6655/rf.h
@@ -73,7 +73,7 @@
 
 /*---------------------  Export Functions  --------------------------*/
 
-bool IFRFbWriteEmbedded(void __iomem *dwIoBase, unsigned long dwData);
+bool IFRFbWriteEmbedded(struct vnt_private *, unsigned long dwData);
 bool RFbSelectChannel(struct vnt_private *, unsigned char byRFType, unsigned char byChannel);
 bool RFbInit(
 	struct vnt_private *
-- 
2.1.0

