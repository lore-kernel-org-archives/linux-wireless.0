Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:33347 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbbKVJII (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Nov 2015 04:08:08 -0500
Received: by wmec201 with SMTP id c201so123234325wme.0
        for <linux-wireless@vger.kernel.org>; Sun, 22 Nov 2015 01:08:07 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/8] staging: vt6655: channel.c replace pDevice with priv
Date: Sun, 22 Nov 2015 09:07:15 +0000
Message-Id: <1448183242-3397-1-git-send-email-tvboxspy@gmail.com> (sfid-20151122_100818_321163_1EF0A92F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing camel case.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/channel.c | 58 ++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/vt6655/channel.c b/drivers/staging/vt6655/channel.c
index 7a71782..6edccb42 100644
--- a/drivers/staging/vt6655/channel.c
+++ b/drivers/staging/vt6655/channel.c
@@ -176,62 +176,62 @@ void vnt_init_bands(struct vnt_private *priv)
  */
 bool set_channel(void *pDeviceHandler, struct ieee80211_channel *ch)
 {
-	struct vnt_private *pDevice = pDeviceHandler;
+	struct vnt_private *priv = pDeviceHandler;
 	bool bResult = true;
 
-	if (pDevice->byCurrentCh == ch->hw_value)
+	if (priv->byCurrentCh == ch->hw_value)
 		return bResult;
 
 	/* Set VGA to max sensitivity */
-	if (pDevice->bUpdateBBVGA &&
-	    pDevice->byBBVGACurrent != pDevice->abyBBVGA[0]) {
-		pDevice->byBBVGACurrent = pDevice->abyBBVGA[0];
+	if (priv->bUpdateBBVGA &&
+	    priv->byBBVGACurrent != priv->abyBBVGA[0]) {
+		priv->byBBVGACurrent = priv->abyBBVGA[0];
 
-		BBvSetVGAGainOffset(pDevice, pDevice->byBBVGACurrent);
+		BBvSetVGAGainOffset(priv, priv->byBBVGACurrent);
 	}
 
 	/* clear NAV */
-	MACvRegBitsOn(pDevice->PortOffset, MAC_REG_MACCR, MACCR_CLRNAV);
+	MACvRegBitsOn(priv->PortOffset, MAC_REG_MACCR, MACCR_CLRNAV);
 
 	/* TX_PE will reserve 3 us for MAX2829 A mode only,
 	   it is for better TX throughput */
 
-	if (pDevice->byRFType == RF_AIROHA7230)
-		RFbAL7230SelectChannelPostProcess(pDevice, pDevice->byCurrentCh,
+	if (priv->byRFType == RF_AIROHA7230)
+		RFbAL7230SelectChannelPostProcess(priv, priv->byCurrentCh,
 						  ch->hw_value);
 
-	pDevice->byCurrentCh = ch->hw_value;
-	bResult &= RFbSelectChannel(pDevice, pDevice->byRFType,
+	priv->byCurrentCh = ch->hw_value;
+	bResult &= RFbSelectChannel(priv, priv->byRFType,
 				    ch->hw_value);
 
 	/* Init Synthesizer Table */
-	if (pDevice->bEnablePSMode)
-		RFvWriteWakeProgSyn(pDevice, pDevice->byRFType, ch->hw_value);
+	if (priv->bEnablePSMode)
+		RFvWriteWakeProgSyn(priv, priv->byRFType, ch->hw_value);
 
-	BBvSoftwareReset(pDevice);
+	BBvSoftwareReset(priv);
 
-	if (pDevice->byLocalID > REV_ID_VT3253_B1) {
+	if (priv->byLocalID > REV_ID_VT3253_B1) {
 		unsigned long flags;
 
-		spin_lock_irqsave(&pDevice->lock, flags);
+		spin_lock_irqsave(&priv->lock, flags);
 
 		/* set HW default power register */
-		MACvSelectPage1(pDevice->PortOffset);
-		RFbSetPower(pDevice, RATE_1M, pDevice->byCurrentCh);
-		VNSvOutPortB(pDevice->PortOffset + MAC_REG_PWRCCK,
-			     pDevice->byCurPwr);
-		RFbSetPower(pDevice, RATE_6M, pDevice->byCurrentCh);
-		VNSvOutPortB(pDevice->PortOffset + MAC_REG_PWROFDM,
-			     pDevice->byCurPwr);
-		MACvSelectPage0(pDevice->PortOffset);
-
-		spin_unlock_irqrestore(&pDevice->lock, flags);
+		MACvSelectPage1(priv->PortOffset);
+		RFbSetPower(priv, RATE_1M, priv->byCurrentCh);
+		VNSvOutPortB(priv->PortOffset + MAC_REG_PWRCCK,
+			     priv->byCurPwr);
+		RFbSetPower(priv, RATE_6M, priv->byCurrentCh);
+		VNSvOutPortB(priv->PortOffset + MAC_REG_PWROFDM,
+			     priv->byCurPwr);
+		MACvSelectPage0(priv->PortOffset);
+
+		spin_unlock_irqrestore(&priv->lock, flags);
 	}
 
-	if (pDevice->byBBType == BB_TYPE_11B)
-		RFbSetPower(pDevice, RATE_1M, pDevice->byCurrentCh);
+	if (priv->byBBType == BB_TYPE_11B)
+		RFbSetPower(priv, RATE_1M, priv->byCurrentCh);
 	else
-		RFbSetPower(pDevice, RATE_6M, pDevice->byCurrentCh);
+		RFbSetPower(priv, RATE_6M, priv->byCurrentCh);
 
 	return bResult;
 }
-- 
2.6.2

