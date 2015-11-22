Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:38690 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbbKVJIM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Nov 2015 04:08:12 -0500
Received: by wmec201 with SMTP id c201so69797872wme.1
        for <linux-wireless@vger.kernel.org>; Sun, 22 Nov 2015 01:08:10 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4/8] staging: vt6655: rf.c rename bResult ret.
Date: Sun, 22 Nov 2015 09:07:18 +0000
Message-Id: <1448183242-3397-4-git-send-email-tvboxspy@gmail.com> (sfid-20151122_100825_903174_C79164F4)
In-Reply-To: <1448183242-3397-1-git-send-email-tvboxspy@gmail.com>
References: <1448183242-3397-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing camel case and reflecting return value.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/rf.c | 138 ++++++++++++++++++++++----------------------
 1 file changed, 69 insertions(+), 69 deletions(-)

diff --git a/drivers/staging/vt6655/rf.c b/drivers/staging/vt6655/rf.c
index 4c22bb3..1c0691d 100644
--- a/drivers/staging/vt6655/rf.c
+++ b/drivers/staging/vt6655/rf.c
@@ -420,9 +420,9 @@ static bool s_bAL7230Init(struct vnt_private *priv)
 {
 	void __iomem *dwIoBase = priv->PortOffset;
 	int     ii;
-	bool bResult;
+	bool ret;
 
-	bResult = true;
+	ret = true;
 
 	/* 3-wire control for normal mode */
 	VNSvOutPortB(dwIoBase + MAC_REG_SOFTPWRCTL, 0);
@@ -432,7 +432,7 @@ static bool s_bAL7230Init(struct vnt_private *priv)
 	BBvPowerSaveModeOFF(priv); /* RobertYu:20050106, have DC value for Calibration */
 
 	for (ii = 0; ii < CB_AL7230_INIT_SEQ; ii++)
-		bResult &= IFRFbWriteEmbedded(priv, dwAL7230InitTable[ii]);
+		ret &= IFRFbWriteEmbedded(priv, dwAL7230InitTable[ii]);
 
 	/* PLL On */
 	MACvWordRegBitsOn(dwIoBase, MAC_REG_SOFTPWRCTL, SOFTPWRCTL_SWPE3);
@@ -440,13 +440,13 @@ static bool s_bAL7230Init(struct vnt_private *priv)
 	/* Calibration */
 	MACvTimer0MicroSDelay(dwIoBase, 150);/* 150us */
 	/* TXDCOC:active, RCK:disable */
-	bResult &= IFRFbWriteEmbedded(priv, (0x9ABA8F00+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW));
+	ret &= IFRFbWriteEmbedded(priv, (0x9ABA8F00+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW));
 	MACvTimer0MicroSDelay(dwIoBase, 30);/* 30us */
 	/* TXDCOC:disable, RCK:active */
-	bResult &= IFRFbWriteEmbedded(priv, (0x3ABA8F00+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW));
+	ret &= IFRFbWriteEmbedded(priv, (0x3ABA8F00+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW));
 	MACvTimer0MicroSDelay(dwIoBase, 30);/* 30us */
 	/* TXDCOC:disable, RCK:disable */
-	bResult &= IFRFbWriteEmbedded(priv, dwAL7230InitTable[CB_AL7230_INIT_SEQ-1]);
+	ret &= IFRFbWriteEmbedded(priv, dwAL7230InitTable[CB_AL7230_INIT_SEQ-1]);
 
 	MACvWordRegBitsOn(dwIoBase, MAC_REG_SOFTPWRCTL, (SOFTPWRCTL_SWPE3    |
 							 SOFTPWRCTL_SWPE2    |
@@ -459,7 +459,7 @@ static bool s_bAL7230Init(struct vnt_private *priv)
 	/* 3-wire control for power saving mode */
 	VNSvOutPortB(dwIoBase + MAC_REG_PSPWRSIG, (PSSIG_WPE3 | PSSIG_WPE2)); /* 1100 0000 */
 
-	return bResult;
+	return ret;
 }
 
 /* Need to Pull PLLON low when writing channel registers through
@@ -467,16 +467,16 @@ static bool s_bAL7230Init(struct vnt_private *priv)
 static bool s_bAL7230SelectChannel(struct vnt_private *priv, unsigned char byChannel)
 {
 	void __iomem *dwIoBase = priv->PortOffset;
-	bool bResult;
+	bool ret;
 
-	bResult = true;
+	ret = true;
 
 	/* PLLON Off */
 	MACvWordRegBitsOff(dwIoBase, MAC_REG_SOFTPWRCTL, SOFTPWRCTL_SWPE3);
 
-	bResult &= IFRFbWriteEmbedded(priv, dwAL7230ChannelTable0[byChannel - 1]);
-	bResult &= IFRFbWriteEmbedded(priv, dwAL7230ChannelTable1[byChannel - 1]);
-	bResult &= IFRFbWriteEmbedded(priv, dwAL7230ChannelTable2[byChannel - 1]);
+	ret &= IFRFbWriteEmbedded(priv, dwAL7230ChannelTable0[byChannel - 1]);
+	ret &= IFRFbWriteEmbedded(priv, dwAL7230ChannelTable1[byChannel - 1]);
+	ret &= IFRFbWriteEmbedded(priv, dwAL7230ChannelTable2[byChannel - 1]);
 
 	/* PLLOn On */
 	MACvWordRegBitsOn(dwIoBase, MAC_REG_SOFTPWRCTL, SOFTPWRCTL_SWPE3);
@@ -487,7 +487,7 @@ static bool s_bAL7230SelectChannel(struct vnt_private *priv, unsigned char byCha
 	/* Set Channel[7] = 1 to tell H/W channel change is done. */
 	VNSvOutPortB(dwIoBase + MAC_REG_CHANNEL, (byChannel | 0x80));
 
-	return bResult;
+	return ret;
 }
 
 /*
@@ -540,9 +540,9 @@ static bool RFbAL2230Init(struct vnt_private *priv)
 {
 	void __iomem *dwIoBase = priv->PortOffset;
 	int     ii;
-	bool bResult;
+	bool ret;
 
-	bResult = true;
+	ret = true;
 
 	/* 3-wire control for normal mode */
 	VNSvOutPortB(dwIoBase + MAC_REG_SOFTPWRCTL, 0);
@@ -556,18 +556,18 @@ static bool RFbAL2230Init(struct vnt_private *priv)
 	IFRFbWriteEmbedded(priv, (0x07168700+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW));
 
 	for (ii = 0; ii < CB_AL2230_INIT_SEQ; ii++)
-		bResult &= IFRFbWriteEmbedded(priv, dwAL2230InitTable[ii]);
+		ret &= IFRFbWriteEmbedded(priv, dwAL2230InitTable[ii]);
 	MACvTimer0MicroSDelay(dwIoBase, 30); /* delay 30 us */
 
 	/* PLL On */
 	MACvWordRegBitsOn(dwIoBase, MAC_REG_SOFTPWRCTL, SOFTPWRCTL_SWPE3);
 
 	MACvTimer0MicroSDelay(dwIoBase, 150);/* 150us */
-	bResult &= IFRFbWriteEmbedded(priv, (0x00d80f00+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW));
+	ret &= IFRFbWriteEmbedded(priv, (0x00d80f00+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW));
 	MACvTimer0MicroSDelay(dwIoBase, 30);/* 30us */
-	bResult &= IFRFbWriteEmbedded(priv, (0x00780f00+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW));
+	ret &= IFRFbWriteEmbedded(priv, (0x00780f00+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW));
 	MACvTimer0MicroSDelay(dwIoBase, 30);/* 30us */
-	bResult &= IFRFbWriteEmbedded(priv, dwAL2230InitTable[CB_AL2230_INIT_SEQ-1]);
+	ret &= IFRFbWriteEmbedded(priv, dwAL2230InitTable[CB_AL2230_INIT_SEQ-1]);
 
 	MACvWordRegBitsOn(dwIoBase, MAC_REG_SOFTPWRCTL, (SOFTPWRCTL_SWPE3    |
 							 SOFTPWRCTL_SWPE2    |
@@ -577,18 +577,18 @@ static bool RFbAL2230Init(struct vnt_private *priv)
 	/* 3-wire control for power saving mode */
 	VNSvOutPortB(dwIoBase + MAC_REG_PSPWRSIG, (PSSIG_WPE3 | PSSIG_WPE2)); /* 1100 0000 */
 
-	return bResult;
+	return ret;
 }
 
 static bool RFbAL2230SelectChannel(struct vnt_private *priv, unsigned char byChannel)
 {
 	void __iomem *dwIoBase = priv->PortOffset;
-	bool bResult;
+	bool ret;
 
-	bResult = true;
+	ret = true;
 
-	bResult &= IFRFbWriteEmbedded(priv, dwAL2230ChannelTable0[byChannel - 1]);
-	bResult &= IFRFbWriteEmbedded(priv, dwAL2230ChannelTable1[byChannel - 1]);
+	ret &= IFRFbWriteEmbedded(priv, dwAL2230ChannelTable0[byChannel - 1]);
+	ret &= IFRFbWriteEmbedded(priv, dwAL2230ChannelTable1[byChannel - 1]);
 
 	/* Set Channel[7] = 0 to tell H/W channel is changing now. */
 	VNSvOutPortB(dwIoBase + MAC_REG_CHANNEL, (byChannel & 0x7F));
@@ -596,7 +596,7 @@ static bool RFbAL2230SelectChannel(struct vnt_private *priv, unsigned char byCha
 	/* Set Channel[7] = 1 to tell H/W channel change is done. */
 	VNSvOutPortB(dwIoBase + MAC_REG_CHANNEL, (byChannel | 0x80));
 
-	return bResult;
+	return ret;
 }
 
 /*
@@ -616,26 +616,26 @@ bool RFbInit(
 	struct vnt_private *priv
 )
 {
-	bool bResult = true;
+	bool ret = true;
 
 	switch (priv->byRFType) {
 	case RF_AIROHA:
 	case RF_AL2230S:
 		priv->byMaxPwrLevel = AL2230_PWR_IDX_LEN;
-		bResult = RFbAL2230Init(priv);
+		ret = RFbAL2230Init(priv);
 		break;
 	case RF_AIROHA7230:
 		priv->byMaxPwrLevel = AL7230_PWR_IDX_LEN;
-		bResult = s_bAL7230Init(priv);
+		ret = s_bAL7230Init(priv);
 		break;
 	case RF_NOTHING:
-		bResult = true;
+		ret = true;
 		break;
 	default:
-		bResult = false;
+		ret = false;
 		break;
 	}
-	return bResult;
+	return ret;
 }
 
 /*
@@ -654,26 +654,26 @@ bool RFbInit(
 bool RFbSelectChannel(struct vnt_private *priv, unsigned char byRFType,
 		      u16 byChannel)
 {
-	bool bResult = true;
+	bool ret = true;
 
 	switch (byRFType) {
 	case RF_AIROHA:
 	case RF_AL2230S:
-		bResult = RFbAL2230SelectChannel(priv, byChannel);
+		ret = RFbAL2230SelectChannel(priv, byChannel);
 		break;
 		/*{{ RobertYu: 20050104 */
 	case RF_AIROHA7230:
-		bResult = s_bAL7230SelectChannel(priv, byChannel);
+		ret = s_bAL7230SelectChannel(priv, byChannel);
 		break;
 		/*}} RobertYu */
 	case RF_NOTHING:
-		bResult = true;
+		ret = true;
 		break;
 	default:
-		bResult = false;
+		ret = false;
 		break;
 	}
-	return bResult;
+	return ret;
 }
 
 /*
@@ -772,7 +772,7 @@ bool RFbSetPower(
 	u16 uCH
 )
 {
-	bool bResult = true;
+	bool ret = true;
 	unsigned char byPwr = 0;
 	unsigned char byDec = 0;
 
@@ -818,11 +818,11 @@ bool RFbSetPower(
 	if (priv->byCurPwr == byPwr)
 		return true;
 
-	bResult = RFbRawSetPower(priv, byPwr, rate);
-	if (bResult)
+	ret = RFbRawSetPower(priv, byPwr, rate);
+	if (ret)
 		priv->byCurPwr = byPwr;
 
-	return bResult;
+	return ret;
 }
 
 /*
@@ -845,7 +845,7 @@ bool RFbRawSetPower(
 	unsigned int rate
 )
 {
-	bool bResult = true;
+	bool ret = true;
 	unsigned long dwMax7230Pwr = 0;
 
 	if (byPwr >=  priv->byMaxPwrLevel)
@@ -853,22 +853,22 @@ bool RFbRawSetPower(
 
 	switch (priv->byRFType) {
 	case RF_AIROHA:
-		bResult &= IFRFbWriteEmbedded(priv, dwAL2230PowerTable[byPwr]);
+		ret &= IFRFbWriteEmbedded(priv, dwAL2230PowerTable[byPwr]);
 		if (rate <= RATE_11M)
-			bResult &= IFRFbWriteEmbedded(priv, 0x0001B400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
+			ret &= IFRFbWriteEmbedded(priv, 0x0001B400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
 		else
-			bResult &= IFRFbWriteEmbedded(priv, 0x0005A400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
+			ret &= IFRFbWriteEmbedded(priv, 0x0005A400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
 
 		break;
 
 	case RF_AL2230S:
-		bResult &= IFRFbWriteEmbedded(priv, dwAL2230PowerTable[byPwr]);
+		ret &= IFRFbWriteEmbedded(priv, dwAL2230PowerTable[byPwr]);
 		if (rate <= RATE_11M) {
-			bResult &= IFRFbWriteEmbedded(priv, 0x040C1400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
-			bResult &= IFRFbWriteEmbedded(priv, 0x00299B00+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
+			ret &= IFRFbWriteEmbedded(priv, 0x040C1400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
+			ret &= IFRFbWriteEmbedded(priv, 0x00299B00+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
 		} else {
-			bResult &= IFRFbWriteEmbedded(priv, 0x0005A400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
-			bResult &= IFRFbWriteEmbedded(priv, 0x00099B00+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
+			ret &= IFRFbWriteEmbedded(priv, 0x0005A400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
+			ret &= IFRFbWriteEmbedded(priv, 0x00099B00+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
 		}
 
 		break;
@@ -879,13 +879,13 @@ bool RFbRawSetPower(
 		dwMax7230Pwr = 0x080C0B00 | ((byPwr) << 12) |
 			(BY_AL7230_REG_LEN << 3)  | IFREGCTL_REGW;
 
-		bResult &= IFRFbWriteEmbedded(priv, dwMax7230Pwr);
+		ret &= IFRFbWriteEmbedded(priv, dwMax7230Pwr);
 		break;
 
 	default:
 		break;
 	}
-	return bResult;
+	return ret;
 }
 
 /*+
@@ -934,32 +934,32 @@ bool RFbAL7230SelectChannelPostProcess(struct vnt_private *priv,
 				       u16 byOldChannel,
 				       u16 byNewChannel)
 {
-	bool bResult;
+	bool ret;
 
-	bResult = true;
+	ret = true;
 
 	/* if change between 11 b/g and 11a need to update the following
 	 * register
 	 * Channel Index 1~14 */
 	if ((byOldChannel <= CB_MAX_CHANNEL_24G) && (byNewChannel > CB_MAX_CHANNEL_24G)) {
 		/* Change from 2.4G to 5G [Reg] */
-		bResult &= IFRFbWriteEmbedded(priv, dwAL7230InitTableAMode[2]);
-		bResult &= IFRFbWriteEmbedded(priv, dwAL7230InitTableAMode[3]);
-		bResult &= IFRFbWriteEmbedded(priv, dwAL7230InitTableAMode[5]);
-		bResult &= IFRFbWriteEmbedded(priv, dwAL7230InitTableAMode[7]);
-		bResult &= IFRFbWriteEmbedded(priv, dwAL7230InitTableAMode[10]);
-		bResult &= IFRFbWriteEmbedded(priv, dwAL7230InitTableAMode[12]);
-		bResult &= IFRFbWriteEmbedded(priv, dwAL7230InitTableAMode[15]);
+		ret &= IFRFbWriteEmbedded(priv, dwAL7230InitTableAMode[2]);
+		ret &= IFRFbWriteEmbedded(priv, dwAL7230InitTableAMode[3]);
+		ret &= IFRFbWriteEmbedded(priv, dwAL7230InitTableAMode[5]);
+		ret &= IFRFbWriteEmbedded(priv, dwAL7230InitTableAMode[7]);
+		ret &= IFRFbWriteEmbedded(priv, dwAL7230InitTableAMode[10]);
+		ret &= IFRFbWriteEmbedded(priv, dwAL7230InitTableAMode[12]);
+		ret &= IFRFbWriteEmbedded(priv, dwAL7230InitTableAMode[15]);
 	} else if ((byOldChannel > CB_MAX_CHANNEL_24G) && (byNewChannel <= CB_MAX_CHANNEL_24G)) {
 		/* Change from 5G to 2.4G [Reg] */
-		bResult &= IFRFbWriteEmbedded(priv, dwAL7230InitTable[2]);
-		bResult &= IFRFbWriteEmbedded(priv, dwAL7230InitTable[3]);
-		bResult &= IFRFbWriteEmbedded(priv, dwAL7230InitTable[5]);
-		bResult &= IFRFbWriteEmbedded(priv, dwAL7230InitTable[7]);
-		bResult &= IFRFbWriteEmbedded(priv, dwAL7230InitTable[10]);
-		bResult &= IFRFbWriteEmbedded(priv, dwAL7230InitTable[12]);
-		bResult &= IFRFbWriteEmbedded(priv, dwAL7230InitTable[15]);
+		ret &= IFRFbWriteEmbedded(priv, dwAL7230InitTable[2]);
+		ret &= IFRFbWriteEmbedded(priv, dwAL7230InitTable[3]);
+		ret &= IFRFbWriteEmbedded(priv, dwAL7230InitTable[5]);
+		ret &= IFRFbWriteEmbedded(priv, dwAL7230InitTable[7]);
+		ret &= IFRFbWriteEmbedded(priv, dwAL7230InitTable[10]);
+		ret &= IFRFbWriteEmbedded(priv, dwAL7230InitTable[12]);
+		ret &= IFRFbWriteEmbedded(priv, dwAL7230InitTable[15]);
 	}
 
-	return bResult;
+	return ret;
 }
-- 
2.6.2

