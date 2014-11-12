Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:36269 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309AbaKLVLw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2014 16:11:52 -0500
Received: by mail-wg0-f49.google.com with SMTP id x13so15241240wgg.36
        for <linux-wireless@vger.kernel.org>; Wed, 12 Nov 2014 13:11:51 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/8] staging: vt6655: card Remove function vUpdateIFS
Date: Wed, 12 Nov 2014 21:11:08 +0000
Message-Id: <1415826675-8446-1-git-send-email-tvboxspy@gmail.com> (sfid-20141112_221155_959075_A3685DD9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

vUpdateIFS does the same operations of CARDbSetPhyParameter there
is not need to call this function.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/card.c        | 65 ------------------------------------
 drivers/staging/vt6655/card.h        |  1 -
 drivers/staging/vt6655/device_main.c |  1 -
 3 files changed, 67 deletions(-)

diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index 532c3c8..a93ca16 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -21,7 +21,6 @@
  * Functions:
  *      s_vSafeResetTx - Rest Tx
  *      CARDvSetRSPINF - Set RSPINF
- *      vUpdateIFS - Update slotTime,SIFS,DIFS, and EIFS
  *      CARDvUpdateBasicTopRate - Update BasicTopRate
  *      CARDbAddBasicRate - Add to BasicRateSet
  *      CARDbIsOFDMinBasicRate - Check if any OFDM rate is in BasicRateSet
@@ -770,70 +769,6 @@ void CARDvSetRSPINF(struct vnt_private *pDevice, u8 bb_type)
 	MACvSelectPage0(pDevice->PortOffset);
 }
 
-/*
- * Description: Update IFS
- *
- * Parameters:
- *  In:
- *      pDevice             - The adapter to be set
- *  Out:
- *      none
- *
- * Return Value: None.
- */
-void vUpdateIFS(struct vnt_private *pDevice)
-{
-	/* Set SIFS, DIFS, EIFS, SlotTime, CwMin */
-
-	unsigned char byMaxMin = 0;
-
-	if (pDevice->byPacketType == PK_TYPE_11A) { /*0000 0000 0000 0000,11a*/
-		pDevice->uSlot = C_SLOT_SHORT;
-		pDevice->uSIFS = C_SIFS_A;
-		pDevice->uDIFS = C_SIFS_A + 2*C_SLOT_SHORT;
-		pDevice->uCwMin = C_CWMIN_A;
-		byMaxMin = 4;
-	} else if (pDevice->byPacketType == PK_TYPE_11B) {
-					/* 0000 0001 0000 0000,11b */
-		pDevice->uSlot = C_SLOT_LONG;
-		pDevice->uSIFS = C_SIFS_BG;
-		pDevice->uDIFS = C_SIFS_BG + 2*C_SLOT_LONG;
-		pDevice->uCwMin = C_CWMIN_B;
-		byMaxMin = 5;
-	} else { /* PK_TYPE_11GA & PK_TYPE_11GB */
-		pDevice->uSIFS = C_SIFS_BG;
-		if (pDevice->bShortSlotTime)
-			pDevice->uSlot = C_SLOT_SHORT;
-		else
-			pDevice->uSlot = C_SLOT_LONG;
-
-		pDevice->uDIFS = C_SIFS_BG + 2*pDevice->uSlot;
-		if (pDevice->wBasicRate & 0x0150) {
-			/* 0000 0001 0101 0000,24M,12M,6M */
-			pDevice->uCwMin = C_CWMIN_A;
-			byMaxMin = 4;
-		} else {
-			pDevice->uCwMin = C_CWMIN_B;
-			byMaxMin = 5;
-		}
-	}
-
-	pDevice->uCwMax = C_CWMAX;
-	pDevice->uEIFS = C_EIFS;
-	if (pDevice->byRFType == RF_RFMD2959) {
-		/* bcs TX_PE will reserve 3 us */
-		VNSvOutPortB(pDevice->PortOffset + MAC_REG_SIFS, (unsigned char)(pDevice->uSIFS - 3));
-		VNSvOutPortB(pDevice->PortOffset + MAC_REG_DIFS, (unsigned char)(pDevice->uDIFS - 3));
-	} else {
-		VNSvOutPortB(pDevice->PortOffset + MAC_REG_SIFS, (unsigned char)pDevice->uSIFS);
-		VNSvOutPortB(pDevice->PortOffset + MAC_REG_DIFS, (unsigned char)pDevice->uDIFS);
-	}
-	VNSvOutPortB(pDevice->PortOffset + MAC_REG_EIFS, (unsigned char)pDevice->uEIFS);
-	VNSvOutPortB(pDevice->PortOffset + MAC_REG_SLOT, (unsigned char)pDevice->uSlot);
-	byMaxMin |= 0xA0; /* 1010 1111,C_CWMAX = 1023 */
-	VNSvOutPortB(pDevice->PortOffset + MAC_REG_CWMAXMIN0, (unsigned char)byMaxMin);
-}
-
 void CARDvUpdateBasicTopRate(struct vnt_private *pDevice)
 {
 	unsigned char byTopOFDM = RATE_24M, byTopCCK = RATE_1M;
diff --git a/drivers/staging/vt6655/card.h b/drivers/staging/vt6655/card.h
index 605d8a8..2e56710 100644
--- a/drivers/staging/vt6655/card.h
+++ b/drivers/staging/vt6655/card.h
@@ -67,7 +67,6 @@ typedef enum _CARD_STATUS_TYPE {
 struct vnt_private;
 
 void CARDvSetRSPINF(struct vnt_private *, u8);
-void vUpdateIFS(struct vnt_private *);
 void CARDvUpdateBasicTopRate(struct vnt_private *);
 bool CARDbIsOFDMinBasicRate(struct vnt_private *);
 void CARDvSetLoopbackMode(void __iomem *dwIoBase, unsigned short wLoopbackMode);
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 2e31784..1392332 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1485,7 +1485,6 @@ static void vnt_bss_info_changed(struct ieee80211_hw *hw,
 		else
 			priv->bShortSlotTime = false;
 
-		vUpdateIFS(priv);
 		CARDbSetPhyParameter(priv, priv->byBBType);
 		BBvSetVGAGainOffset(priv, priv->abyBBVGA[0]);
 	}
-- 
2.1.0

