Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:41108 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaKFUCk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 15:02:40 -0500
Received: by mail-wi0-f177.google.com with SMTP id ex7so2605470wid.10
        for <linux-wireless@vger.kernel.org>; Thu, 06 Nov 2014 12:02:38 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 5/6] staging: vt6655: BBbReadEmbedded replace __iomem with vnt_private
Date: Thu,  6 Nov 2014 20:02:04 +0000
Message-Id: <1415304125-5165-5-git-send-email-tvboxspy@gmail.com> (sfid-20141106_210252_302422_9EE8D2E0)
In-Reply-To: <1415304125-5165-1-git-send-email-tvboxspy@gmail.com>
References: <1415304125-5165-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changing callers to point to private

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/baseband.c | 22 ++++++++++------------
 drivers/staging/vt6655/baseband.h |  2 +-
 drivers/staging/vt6655/card.c     | 12 ++++++------
 3 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/vt6655/baseband.c b/drivers/staging/vt6655/baseband.c
index f1f1075..86c72ba 100644
--- a/drivers/staging/vt6655/baseband.c
+++ b/drivers/staging/vt6655/baseband.c
@@ -1961,8 +1961,10 @@ void vnt_get_phy_field(struct vnt_private *priv, u32 frame_length,
  * Return Value: true if succeeded; false if failed.
  *
  */
-bool BBbReadEmbedded(void __iomem *dwIoBase, unsigned char byBBAddr, unsigned char *pbyData)
+bool BBbReadEmbedded(struct vnt_private *priv,
+		     unsigned char byBBAddr, unsigned char *pbyData)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
 	unsigned short ww;
 	unsigned char byValue;
 
@@ -2222,7 +2224,7 @@ BBvSetShortSlotTime(struct vnt_private *priv)
 	unsigned char byBBRxConf = 0;
 	unsigned char byBBVGA = 0;
 
-	BBbReadEmbedded(priv->PortOffset, 0x0A, &byBBRxConf); /* CR10 */
+	BBbReadEmbedded(priv, 0x0A, &byBBRxConf); /* CR10 */
 
 	if (priv->bShortSlotTime)
 		byBBRxConf &= 0xDF; /* 1101 1111 */
@@ -2230,7 +2232,7 @@ BBvSetShortSlotTime(struct vnt_private *priv)
 		byBBRxConf |= 0x20; /* 0010 0000 */
 
 	/* patch for 3253B0 Baseband with Cardbus module */
-	BBbReadEmbedded(priv->PortOffset, 0xE7, &byBBVGA);
+	BBbReadEmbedded(priv, 0xE7, &byBBVGA);
 	if (byBBVGA == priv->abyBBVGA[0])
 		byBBRxConf |= 0x20; /* 0010 0000 */
 
@@ -2243,7 +2245,7 @@ void BBvSetVGAGainOffset(struct vnt_private *priv, unsigned char byData)
 
 	BBbWriteEmbedded(priv, 0xE7, byData);
 
-	BBbReadEmbedded(priv->PortOffset, 0x0A, &byBBRxConf); /* CR10 */
+	BBbReadEmbedded(priv, 0x0A, &byBBRxConf); /* CR10 */
 	/* patch for 3253B0 Baseband with Cardbus module */
 	if (byData == priv->abyBBVGA[0])
 		byBBRxConf |= 0x20; /* 0010 0000 */
@@ -2291,10 +2293,9 @@ BBvSoftwareReset(struct vnt_private *priv)
 void
 BBvPowerSaveModeON(struct vnt_private *priv)
 {
-	void __iomem *dwIoBase = priv->PortOffset;
 	unsigned char byOrgData;
 
-	BBbReadEmbedded(dwIoBase, 0x0D, &byOrgData);
+	BBbReadEmbedded(priv, 0x0D, &byOrgData);
 	byOrgData |= BIT(0);
 	BBbWriteEmbedded(priv, 0x0D, byOrgData);
 }
@@ -2314,10 +2315,9 @@ BBvPowerSaveModeON(struct vnt_private *priv)
 void
 BBvPowerSaveModeOFF(struct vnt_private *priv)
 {
-	void __iomem *dwIoBase = priv->PortOffset;
 	unsigned char byOrgData;
 
-	BBbReadEmbedded(dwIoBase, 0x0D, &byOrgData);
+	BBbReadEmbedded(priv, 0x0D, &byOrgData);
 	byOrgData &= ~(BIT(0));
 	BBbWriteEmbedded(priv, 0x0D, byOrgData);
 }
@@ -2339,10 +2339,9 @@ BBvPowerSaveModeOFF(struct vnt_private *priv)
 void
 BBvSetTxAntennaMode(struct vnt_private *priv, unsigned char byAntennaMode)
 {
-	void __iomem *dwIoBase = priv->PortOffset;
 	unsigned char byBBTxConf;
 
-	BBbReadEmbedded(dwIoBase, 0x09, &byBBTxConf); /* CR09 */
+	BBbReadEmbedded(priv, 0x09, &byBBTxConf); /* CR09 */
 	if (byAntennaMode == ANT_DIVERSITY) {
 		/* bit 1 is diversity */
 		byBBTxConf |= 0x02;
@@ -2373,10 +2372,9 @@ BBvSetTxAntennaMode(struct vnt_private *priv, unsigned char byAntennaMode)
 void
 BBvSetRxAntennaMode(struct vnt_private *priv, unsigned char byAntennaMode)
 {
-	void __iomem *dwIoBase = priv->PortOffset;
 	unsigned char byBBRxConf;
 
-	BBbReadEmbedded(dwIoBase, 0x0A, &byBBRxConf); /* CR10 */
+	BBbReadEmbedded(priv, 0x0A, &byBBRxConf); /* CR10 */
 	if (byAntennaMode == ANT_DIVERSITY) {
 		byBBRxConf |= 0x01;
 
diff --git a/drivers/staging/vt6655/baseband.h b/drivers/staging/vt6655/baseband.h
index 743ec4f..d9f6d63 100644
--- a/drivers/staging/vt6655/baseband.h
+++ b/drivers/staging/vt6655/baseband.h
@@ -77,7 +77,7 @@ BBuGetFrameTime(
 void vnt_get_phy_field(struct vnt_private *, u32 frame_length,
 		       u16 tx_rate, u8 pkt_type, struct vnt_phy_field *);
 
-bool BBbReadEmbedded(void __iomem *dwIoBase, unsigned char byBBAddr, unsigned char *pbyData);
+bool BBbReadEmbedded(struct vnt_private *, unsigned char byBBAddr, unsigned char *pbyData);
 bool BBbWriteEmbedded(struct vnt_private *, unsigned char byBBAddr, unsigned char byData);
 
 void BBvSetShortSlotTime(struct vnt_private *);
diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index 6f1cea0..1869557 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -223,14 +223,14 @@ bool CARDbSetPhyParameter(struct vnt_private *pDevice, CARD_PHY_TYPE ePHYType,
 			pDevice->abyBBVGA[0] = 0x20;
 			pDevice->abyBBVGA[2] = 0x10;
 			pDevice->abyBBVGA[3] = 0x10;
-			BBbReadEmbedded(pDevice->PortOffset, 0xE7, &byData);
+			BBbReadEmbedded(pDevice, 0xE7, &byData);
 			if (byData == 0x1C)
 				BBbWriteEmbedded(pDevice, 0xE7, pDevice->abyBBVGA[0]);
 
 		} else if (pDevice->byRFType == RF_UW2452) {
 			MACvSetBBType(pDevice->PortOffset, BB_TYPE_11A);
 			pDevice->abyBBVGA[0] = 0x18;
-			BBbReadEmbedded(pDevice->PortOffset, 0xE7, &byData);
+			BBbReadEmbedded(pDevice, 0xE7, &byData);
 			if (byData == 0x14) {
 				BBbWriteEmbedded(pDevice, 0xE7, pDevice->abyBBVGA[0]);
 				BBbWriteEmbedded(pDevice, 0xE1, 0x57);
@@ -249,13 +249,13 @@ bool CARDbSetPhyParameter(struct vnt_private *pDevice, CARD_PHY_TYPE ePHYType,
 			pDevice->abyBBVGA[0] = 0x1C;
 			pDevice->abyBBVGA[2] = 0x00;
 			pDevice->abyBBVGA[3] = 0x00;
-			BBbReadEmbedded(pDevice->PortOffset, 0xE7, &byData);
+			BBbReadEmbedded(pDevice, 0xE7, &byData);
 			if (byData == 0x20)
 				BBbWriteEmbedded(pDevice, 0xE7, pDevice->abyBBVGA[0]);
 
 		} else if (pDevice->byRFType == RF_UW2452) {
 			pDevice->abyBBVGA[0] = 0x14;
-			BBbReadEmbedded(pDevice->PortOffset, 0xE7, &byData);
+			BBbReadEmbedded(pDevice, 0xE7, &byData);
 			if (byData == 0x18) {
 				BBbWriteEmbedded(pDevice, 0xE7, pDevice->abyBBVGA[0]);
 				BBbWriteEmbedded(pDevice, 0xE1, 0xD3);
@@ -272,13 +272,13 @@ bool CARDbSetPhyParameter(struct vnt_private *pDevice, CARD_PHY_TYPE ePHYType,
 			pDevice->abyBBVGA[0] = 0x1C;
 			pDevice->abyBBVGA[2] = 0x00;
 			pDevice->abyBBVGA[3] = 0x00;
-			BBbReadEmbedded(pDevice->PortOffset, 0xE7, &byData);
+			BBbReadEmbedded(pDevice, 0xE7, &byData);
 			if (byData == 0x20)
 				BBbWriteEmbedded(pDevice, 0xE7, pDevice->abyBBVGA[0]);
 
 		} else if (pDevice->byRFType == RF_UW2452) {
 			pDevice->abyBBVGA[0] = 0x14;
-			BBbReadEmbedded(pDevice->PortOffset, 0xE7, &byData);
+			BBbReadEmbedded(pDevice, 0xE7, &byData);
 			if (byData == 0x18) {
 				BBbWriteEmbedded(pDevice, 0xE7, pDevice->abyBBVGA[0]);
 				BBbWriteEmbedded(pDevice, 0xE1, 0xD3);
-- 
2.1.0

