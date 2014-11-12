Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:43253 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404AbaKLVMB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2014 16:12:01 -0500
Received: by mail-wg0-f46.google.com with SMTP id x13so15473875wgg.5
        for <linux-wireless@vger.kernel.org>; Wed, 12 Nov 2014 13:12:00 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 6/8] staging: vt6655: rf.c: Remove author comments
Date: Wed, 12 Nov 2014 21:11:13 +0000
Message-Id: <1415826675-8446-6-git-send-email-tvboxspy@gmail.com> (sfid-20141112_221206_656812_86B606FC)
In-Reply-To: <1415826675-8446-1-git-send-email-tvboxspy@gmail.com>
References: <1415826675-8446-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Moving names to file header comment

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/rf.c | 21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/vt6655/rf.c b/drivers/staging/vt6655/rf.c
index 798dfb7..87d97da 100644
--- a/drivers/staging/vt6655/rf.c
+++ b/drivers/staging/vt6655/rf.c
@@ -29,6 +29,8 @@
  *      IFRFbWriteEmbedded      - Embedded write RF register via MAC
  *
  * Revision History:
+ *	RobertYu 2005
+ *	chester 2008
  *
  */
 
@@ -172,7 +174,6 @@ static unsigned long dwAL2230PowerTable[AL2230_PWR_IDX_LEN] = {
 	0x0407F900+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW
 };
 
-//{{ RobertYu:20050104
 // 40MHz reference frequency
 // Need to Pull PLLON(PE3) low when writing channel registers through 3-wire.
 static const unsigned long dwAL7230InitTable[CB_AL7230_INIT_SEQ] = {
@@ -408,7 +409,6 @@ static const unsigned long dwAL7230ChannelTable2[CB_MAX_CHANNEL] = {
 	0x77D78400+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW, // channel = 161, Tf = 5805MHz (55)
 	0x77D78400+(BY_AL7230_REG_LEN<<3)+IFREGCTL_REGW  // channel = 165, Tf = 5825MHz (56)
 };
-//}} RobertYu
 
 /*---------------------  Static Functions  --------------------------*/
 
@@ -511,7 +511,6 @@ static bool s_bAL7230SelectChannel(struct vnt_private *priv, unsigned char byCha
  *
  */
 
-//{{ RobertYu: 20041210
 /*
  * Description: UW2452 IFRF chip init function
  *
@@ -525,9 +524,6 @@ static bool s_bAL7230SelectChannel(struct vnt_private *priv, unsigned char byCha
  *
  */
 
-//}} RobertYu
-////////////////////////////////////////////////////////////////////////////////
-
 /*
  * Description: VT3226 IFRF chip init function
  *
@@ -645,18 +641,15 @@ static bool RFbAL2230Init(struct vnt_private *priv)
 
 	MACvWordRegBitsOn(dwIoBase, MAC_REG_SOFTPWRCTL, (SOFTPWRCTL_SWPECTI  |
 							 SOFTPWRCTL_TXPEINV));
-//2008-8-21 chester <add>
 	// PLL  Off
 
 	MACvWordRegBitsOff(dwIoBase, MAC_REG_SOFTPWRCTL, SOFTPWRCTL_SWPE3);
 
 	//patch abnormal AL2230 frequency output
-//2008-8-21 chester <add>
 	IFRFbWriteEmbedded(priv, (0x07168700+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW));
 
 	for (ii = 0; ii < CB_AL2230_INIT_SEQ; ii++)
 		bResult &= IFRFbWriteEmbedded(priv, dwAL2230InitTable[ii]);
-//2008-8-21 chester <add>
 	MACvTimer0MicroSDelay(dwIoBase, 30); //delay 30 us
 
 	// PLL On
@@ -856,7 +849,6 @@ bool RFvWriteWakeProgSyn(struct vnt_private *priv, unsigned char byRFType, unsig
 		MACvSetMISCFifo(dwIoBase, (unsigned short)(MISCFIFO_SYNDATA_IDX + ii), dwAL2230ChannelTable1[uChannel-1]);
 		break;
 
-		//{{ RobertYu: 20050104
 		// Need to check, PLLON need to be low for channel setting
 	case RF_AIROHA7230:
 		byInitCount = CB_AL7230_INIT_SEQ + 3; // Init Reg + Channel Reg (3)
@@ -878,7 +870,6 @@ bool RFvWriteWakeProgSyn(struct vnt_private *priv, unsigned char byRFType, unsig
 		ii++;
 		MACvSetMISCFifo(dwIoBase, (unsigned short)(MISCFIFO_SYNDATA_IDX + ii), dwAL7230ChannelTable2[uChannel-1]);
 		break;
-		//}} RobertYu
 
 	case RF_NOTHING:
 		return true;
@@ -1064,7 +1055,7 @@ RFvRSSITodBm(
 	switch (priv->byRFType) {
 	case RF_AIROHA:
 	case RF_AL2230S:
-	case RF_AIROHA7230: //RobertYu: 20040104
+	case RF_AIROHA7230:
 		a = abyAIROHARF[byIdx];
 		break;
 	default:
@@ -1074,9 +1065,6 @@ RFvRSSITodBm(
 	*pldBm = -1 * (a + b * 2);
 }
 
-////////////////////////////////////////////////////////////////////////////////
-//{{ RobertYu: 20050104
-
 // Post processing for the 11b/g and 11a.
 // for save time on changing Reg2,3,5,7,10,12,15
 bool RFbAL7230SelectChannelPostProcess(struct vnt_private *priv,
@@ -1112,6 +1100,3 @@ bool RFbAL7230SelectChannelPostProcess(struct vnt_private *priv,
 
 	return bResult;
 }
-
-//}} RobertYu
-////////////////////////////////////////////////////////////////////////////////
-- 
2.1.0

