Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:41807 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540AbaKLVL7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2014 16:11:59 -0500
Received: by mail-wg0-f54.google.com with SMTP id n12so15222469wgh.13
        for <linux-wireless@vger.kernel.org>; Wed, 12 Nov 2014 13:11:58 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 5/8] staging: vt6655: rf.c camel calse vnt_private rename pDevice to priv
Date: Wed, 12 Nov 2014 21:11:12 +0000
Message-Id: <1415826675-8446-5-git-send-email-tvboxspy@gmail.com> (sfid-20141112_221204_550705_CA246042)
In-Reply-To: <1415826675-8446-1-git-send-email-tvboxspy@gmail.com>
References: <1415826675-8446-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/rf.c | 72 ++++++++++++++++++++++-----------------------
 1 file changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/vt6655/rf.c b/drivers/staging/vt6655/rf.c
index 3b7ad49..798dfb7 100644
--- a/drivers/staging/vt6655/rf.c
+++ b/drivers/staging/vt6655/rf.c
@@ -754,20 +754,20 @@ static bool RFbAL2230SelectChannel(struct vnt_private *priv, unsigned char byCha
  *
  */
 bool RFbInit(
-	struct vnt_private *pDevice
+	struct vnt_private *priv
 )
 {
 	bool bResult = true;
 
-	switch (pDevice->byRFType) {
+	switch (priv->byRFType) {
 	case RF_AIROHA:
 	case RF_AL2230S:
-		pDevice->byMaxPwrLevel = AL2230_PWR_IDX_LEN;
-		bResult = RFbAL2230Init(pDevice);
+		priv->byMaxPwrLevel = AL2230_PWR_IDX_LEN;
+		bResult = RFbAL2230Init(priv);
 		break;
 	case RF_AIROHA7230:
-		pDevice->byMaxPwrLevel = AL7230_PWR_IDX_LEN;
-		bResult = s_bAL7230Init(pDevice);
+		priv->byMaxPwrLevel = AL7230_PWR_IDX_LEN;
+		bResult = s_bAL7230Init(priv);
 		break;
 	case RF_NOTHING:
 		bResult = true;
@@ -906,7 +906,7 @@ bool RFvWriteWakeProgSyn(struct vnt_private *priv, unsigned char byRFType, unsig
  *
  */
 bool RFbSetPower(
-	struct vnt_private *pDevice,
+	struct vnt_private *priv,
 	unsigned int uRATE,
 	unsigned int uCH
 )
@@ -916,7 +916,7 @@ bool RFbSetPower(
 	unsigned char byDec = 0;
 	unsigned char byPwrdBm = 0;
 
-	if (pDevice->dwDiagRefCount != 0)
+	if (priv->dwDiagRefCount != 0)
 		return true;
 
 	if ((uCH < 1) || (uCH > CB_MAX_CHANNEL))
@@ -927,22 +927,22 @@ bool RFbSetPower(
 	case RATE_2M:
 	case RATE_5M:
 	case RATE_11M:
-		byPwr = pDevice->abyCCKPwrTbl[uCH];
-		byPwrdBm = pDevice->abyCCKDefaultPwr[uCH];
+		byPwr = priv->abyCCKPwrTbl[uCH];
+		byPwrdBm = priv->abyCCKDefaultPwr[uCH];
 		break;
 	case RATE_6M:
 	case RATE_9M:
 	case RATE_18M:
-		byPwr = pDevice->abyOFDMPwrTbl[uCH];
-		if (pDevice->byRFType == RF_UW2452)
+		byPwr = priv->abyOFDMPwrTbl[uCH];
+		if (priv->byRFType == RF_UW2452)
 			byDec = byPwr + 14;
 		else
 			byDec = byPwr + 10;
 
-		if (byDec >= pDevice->byMaxPwrLevel)
-			byDec = pDevice->byMaxPwrLevel-1;
+		if (byDec >= priv->byMaxPwrLevel)
+			byDec = priv->byMaxPwrLevel-1;
 
-		if (pDevice->byRFType == RF_UW2452) {
+		if (priv->byRFType == RF_UW2452) {
 			byPwrdBm = byDec - byPwr;
 			byPwrdBm /= 3;
 		} else {
@@ -950,24 +950,24 @@ bool RFbSetPower(
 			byPwrdBm >>= 1;
 		}
 
-		byPwrdBm += pDevice->abyOFDMDefaultPwr[uCH];
+		byPwrdBm += priv->abyOFDMDefaultPwr[uCH];
 		byPwr = byDec;
 		break;
 	case RATE_24M:
 	case RATE_36M:
 	case RATE_48M:
 	case RATE_54M:
-		byPwr = pDevice->abyOFDMPwrTbl[uCH];
-		byPwrdBm = pDevice->abyOFDMDefaultPwr[uCH];
+		byPwr = priv->abyOFDMPwrTbl[uCH];
+		byPwrdBm = priv->abyOFDMDefaultPwr[uCH];
 		break;
 	}
 
-	if (pDevice->byCurPwr == byPwr)
+	if (priv->byCurPwr == byPwr)
 		return true;
 
-	bResult = RFbRawSetPower(pDevice, byPwr, uRATE);
+	bResult = RFbRawSetPower(priv, byPwr, uRATE);
 	if (bResult)
-		pDevice->byCurPwr = byPwr;
+		priv->byCurPwr = byPwr;
 
 	return bResult;
 }
@@ -987,7 +987,7 @@ bool RFbSetPower(
  */
 
 bool RFbRawSetPower(
-	struct vnt_private *pDevice,
+	struct vnt_private *priv,
 	unsigned char byPwr,
 	unsigned int uRATE
 )
@@ -995,27 +995,27 @@ bool RFbRawSetPower(
 	bool bResult = true;
 	unsigned long dwMax7230Pwr = 0;
 
-	if (byPwr >=  pDevice->byMaxPwrLevel)
+	if (byPwr >=  priv->byMaxPwrLevel)
 		return false;
 
-	switch (pDevice->byRFType) {
+	switch (priv->byRFType) {
 	case RF_AIROHA:
-		bResult &= IFRFbWriteEmbedded(pDevice, dwAL2230PowerTable[byPwr]);
+		bResult &= IFRFbWriteEmbedded(priv, dwAL2230PowerTable[byPwr]);
 		if (uRATE <= RATE_11M)
-			bResult &= IFRFbWriteEmbedded(pDevice, 0x0001B400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
+			bResult &= IFRFbWriteEmbedded(priv, 0x0001B400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
 		else
-			bResult &= IFRFbWriteEmbedded(pDevice, 0x0005A400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
+			bResult &= IFRFbWriteEmbedded(priv, 0x0005A400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
 
 		break;
 
 	case RF_AL2230S:
-		bResult &= IFRFbWriteEmbedded(pDevice, dwAL2230PowerTable[byPwr]);
+		bResult &= IFRFbWriteEmbedded(priv, dwAL2230PowerTable[byPwr]);
 		if (uRATE <= RATE_11M) {
-			bResult &= IFRFbWriteEmbedded(pDevice, 0x040C1400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
-			bResult &= IFRFbWriteEmbedded(pDevice, 0x00299B00+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
+			bResult &= IFRFbWriteEmbedded(priv, 0x040C1400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
+			bResult &= IFRFbWriteEmbedded(priv, 0x00299B00+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
 		} else {
-			bResult &= IFRFbWriteEmbedded(pDevice, 0x0005A400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
-			bResult &= IFRFbWriteEmbedded(pDevice, 0x00099B00+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
+			bResult &= IFRFbWriteEmbedded(priv, 0x0005A400+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
+			bResult &= IFRFbWriteEmbedded(priv, 0x00099B00+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW);
 		}
 
 		break;
@@ -1025,7 +1025,7 @@ bool RFbRawSetPower(
 		dwMax7230Pwr = 0x080C0B00 | ((byPwr) << 12) |
 			(BY_AL7230_REG_LEN << 3)  | IFREGCTL_REGW;
 
-		bResult &= IFRFbWriteEmbedded(pDevice, dwMax7230Pwr);
+		bResult &= IFRFbWriteEmbedded(priv, dwMax7230Pwr);
 		break;
 
 	default:
@@ -1041,7 +1041,7 @@ bool RFbRawSetPower(
  *
  * Parameters:
  *  In:
- *      pDevice         - The adapter to be translated
+ *      priv         - The adapter to be translated
  *      byCurrRSSI      - RSSI to be translated
  *  Out:
  *      pdwdbm          - Translated dbm number
@@ -1051,7 +1051,7 @@ bool RFbRawSetPower(
  -*/
 void
 RFvRSSITodBm(
-	struct vnt_private *pDevice,
+	struct vnt_private *priv,
 	unsigned char byCurrRSSI,
 	long *pldBm
 	)
@@ -1061,7 +1061,7 @@ RFvRSSITodBm(
 	long a = 0;
 	unsigned char abyAIROHARF[4] = {0, 18, 0, 40};
 
-	switch (pDevice->byRFType) {
+	switch (priv->byRFType) {
 	case RF_AIROHA:
 	case RF_AL2230S:
 	case RF_AIROHA7230: //RobertYu: 20040104
-- 
2.1.0

