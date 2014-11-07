Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:61903 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbaKGTGk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2014 14:06:40 -0500
Received: by mail-wi0-f173.google.com with SMTP id n3so5536103wiv.0
        for <linux-wireless@vger.kernel.org>; Fri, 07 Nov 2014 11:06:39 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 03/10] staging: vt6655: CARDbSetPhyParameter change CARD_PHY_TYPE to bb_type
Date: Fri,  7 Nov 2014 19:06:02 +0000
Message-Id: <1415387169-3843-3-git-send-email-tvboxspy@gmail.com> (sfid-20141107_200644_842447_A1F7EBF3)
In-Reply-To: <1415387169-3843-1-git-send-email-tvboxspy@gmail.com>
References: <1415387169-3843-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

using u8 for bb_type

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/card.c | 8 ++++----
 drivers/staging/vt6655/card.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index 7b25969..6a1efd1 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -204,7 +204,7 @@ s_vCalculateOFDMRParameter(
  *
  * Return Value: None.
  */
-bool CARDbSetPhyParameter(struct vnt_private *pDevice, CARD_PHY_TYPE ePHYType,
+bool CARDbSetPhyParameter(struct vnt_private *pDevice, u8 bb_type,
 			  unsigned short wCapInfo, unsigned char byERPField,
 			  void *pvSupportRateIEs, void *pvExtSupportRateIEs)
 {
@@ -216,7 +216,7 @@ bool CARDbSetPhyParameter(struct vnt_private *pDevice, CARD_PHY_TYPE ePHYType,
 	int i;
 
 	/* Set SIFS, DIFS, EIFS, SlotTime, CwMin */
-	if (ePHYType == PHY_TYPE_11A) {
+	if (bb_type == BB_TYPE_11A) {
 		if (pDevice->byRFType == RF_AIROHA7230) {
 			/* AL7230 use single PAPE and connect to PAPE_2.4G */
 			MACvSetBBType(pDevice->PortOffset, BB_TYPE_11G);
@@ -243,7 +243,7 @@ bool CARDbSetPhyParameter(struct vnt_private *pDevice, CARD_PHY_TYPE ePHYType,
 		bySIFS = C_SIFS_A;
 		byDIFS = C_SIFS_A + 2*C_SLOT_SHORT;
 		byCWMaxMin = 0xA4;
-	} else if (ePHYType == PHY_TYPE_11B) {
+	} else if (bb_type == BB_TYPE_11B) {
 		MACvSetBBType(pDevice->PortOffset, BB_TYPE_11B);
 		if (pDevice->byRFType == RF_AIROHA7230) {
 			pDevice->abyBBVGA[0] = 0x1C;
@@ -344,7 +344,7 @@ bool CARDbSetPhyParameter(struct vnt_private *pDevice, CARD_PHY_TYPE ePHYType,
 
 	pDevice->byPacketType = CARDbyGetPktType(pDevice);
 
-	CARDvSetRSPINF(pDevice, ePHYType);
+	CARDvSetRSPINF(pDevice, bb_type);
 
 	return true;
 }
diff --git a/drivers/staging/vt6655/card.h b/drivers/staging/vt6655/card.h
index 2449f3c..9d19f97 100644
--- a/drivers/staging/vt6655/card.h
+++ b/drivers/staging/vt6655/card.h
@@ -89,7 +89,7 @@ void CARDvSafeResetTx(struct vnt_private *);
 void CARDvSafeResetRx(struct vnt_private *);
 bool CARDbRadioPowerOff(struct vnt_private *);
 bool CARDbRadioPowerOn(struct vnt_private *);
-bool CARDbSetPhyParameter(struct vnt_private *, CARD_PHY_TYPE ePHYType,
+bool CARDbSetPhyParameter(struct vnt_private *, u8,
 			  unsigned short wCapInfo, unsigned char byERPField,
 			  void *pvSupportRateIEs, void *pvExtSupportRateIEs);
 bool CARDbUpdateTSF(struct vnt_private *, unsigned char byRxRate,
-- 
2.1.0

