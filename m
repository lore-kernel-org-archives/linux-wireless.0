Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:45819 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556AbaJ2RpO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:45:14 -0400
Received: by mail-wi0-f176.google.com with SMTP id h11so2394186wiw.3
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:45:13 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 16/34] staging: vt6655: mac80211 conversion: changes to CARDbSetPhyParameter
Date: Wed, 29 Oct 2014 17:43:51 +0000
Message-Id: <1414604649-9105-17-git-send-email-tvboxspy@gmail.com> (sfid-20141029_185354_357679_24D47DE6)
In-Reply-To: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
References: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CARDbSetPhyParameter appears to use two different strutures to find supported
rates.

Remove PWLAN_IE_SUPP_RATES and use basic_rates to find rates supported.

mac80211 now sets bShortSlotTime, bBarkerPreambleMd and byPreambleType remove
these.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/card.c | 61 ++++++++-----------------------------------
 1 file changed, 11 insertions(+), 50 deletions(-)

diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index eae6789..090c286 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -74,15 +74,6 @@
 
 #define WAIT_BEACON_TX_DOWN_TMO         3    /* Times */
 
-/* 1M,   2M,   5M,  11M,  18M,  24M,  36M,  54M */
-static unsigned char abyDefaultSuppRatesG[] = {WLAN_EID_SUPP_RATES, 8, 0x02, 0x04, 0x0B, 0x16, 0x24, 0x30, 0x48, 0x6C};
-/* 6M,  9M,  12M,  48M */
-static unsigned char abyDefaultExtSuppRatesG[] = {WLAN_EID_EXTSUPP_RATES, 4, 0x0C, 0x12, 0x18, 0x60};
-/* 6M,  9M,  12M,  18M,  24M,  36M,  48M,  54M */
-static unsigned char abyDefaultSuppRatesA[] = {WLAN_EID_SUPP_RATES, 8, 0x0C, 0x12, 0x18, 0x24, 0x30, 0x48, 0x60, 0x6C};
-/* 1M,   2M,   5M,  11M, */
-static unsigned char abyDefaultSuppRatesB[] = {WLAN_EID_SUPP_RATES, 4, 0x02, 0x04, 0x0B, 0x16};
-
 /*---------------------  Static Variables  --------------------------*/
 
 static const unsigned short cwRXBCNTSFOff[MAX_RATE] =
@@ -384,14 +375,10 @@ bool CARDbSetPhyParameter(struct vnt_private *pDevice, CARD_PHY_TYPE ePHYType,
 	unsigned char bySIFS = 0;
 	unsigned char byDIFS = 0;
 	unsigned char byData;
-	PWLAN_IE_SUPP_RATES pSupportRates = (PWLAN_IE_SUPP_RATES) pvSupportRateIEs;
-	PWLAN_IE_SUPP_RATES pExtSupportRates = (PWLAN_IE_SUPP_RATES) pvExtSupportRateIEs;
+	int i;
 
 	/* Set SIFS, DIFS, EIFS, SlotTime, CwMin */
 	if (ePHYType == PHY_TYPE_11A) {
-		if (pSupportRates == NULL)
-			pSupportRates = (PWLAN_IE_SUPP_RATES) abyDefaultSuppRatesA;
-
 		if (pDevice->byRFType == RF_AIROHA7230) {
 			/* AL7230 use single PAPE and connect to PAPE_2.4G */
 			MACvSetBBType(pDevice->PortOffset, BB_TYPE_11G);
@@ -419,9 +406,6 @@ bool CARDbSetPhyParameter(struct vnt_private *pDevice, CARD_PHY_TYPE ePHYType,
 		byDIFS = C_SIFS_A + 2*C_SLOT_SHORT;
 		byCWMaxMin = 0xA4;
 	} else if (ePHYType == PHY_TYPE_11B) {
-		if (pSupportRates == NULL)
-			pSupportRates = (PWLAN_IE_SUPP_RATES) abyDefaultSuppRatesB;
-
 		MACvSetBBType(pDevice->PortOffset, BB_TYPE_11B);
 		if (pDevice->byRFType == RF_AIROHA7230) {
 			pDevice->abyBBVGA[0] = 0x1C;
@@ -445,10 +429,6 @@ bool CARDbSetPhyParameter(struct vnt_private *pDevice, CARD_PHY_TYPE ePHYType,
 		byDIFS = C_SIFS_BG + 2*C_SLOT_LONG;
 		byCWMaxMin = 0xA5;
 	} else { /* PK_TYPE_11GA & PK_TYPE_11GB */
-		if (pSupportRates == NULL) {
-			pSupportRates = (PWLAN_IE_SUPP_RATES) abyDefaultSuppRatesG;
-			pExtSupportRates = (PWLAN_IE_SUPP_RATES) abyDefaultExtSuppRatesG;
-		}
 		MACvSetBBType(pDevice->PortOffset, BB_TYPE_11G);
 		if (pDevice->byRFType == RF_AIROHA7230) {
 			pDevice->abyBBVGA[0] = 0x1C;
@@ -468,32 +448,22 @@ bool CARDbSetPhyParameter(struct vnt_private *pDevice, CARD_PHY_TYPE ePHYType,
 		}
 		BBbWriteEmbedded(pDevice->PortOffset, 0x88, 0x08);
 		bySIFS = C_SIFS_BG;
-		if (VNTWIFIbIsShortSlotTime(wCapInfo)) {
+
+		if (pDevice->bShortSlotTime) {
 			bySlot = C_SLOT_SHORT;
 			byDIFS = C_SIFS_BG + 2*C_SLOT_SHORT;
 		} else {
 			bySlot = C_SLOT_LONG;
 			byDIFS = C_SIFS_BG + 2*C_SLOT_LONG;
 		}
-		if (VNTWIFIbyGetMaxSupportRate(pSupportRates, pExtSupportRates) > RATE_11M)
-			byCWMaxMin = 0xA4;
-		else
-			byCWMaxMin = 0xA5;
 
-		if (pDevice->bProtectMode != VNTWIFIbIsProtectMode(byERPField)) {
-			pDevice->bProtectMode = VNTWIFIbIsProtectMode(byERPField);
-			if (pDevice->bProtectMode)
-				MACvEnableProtectMD(pDevice->PortOffset);
-			else
-				MACvDisableProtectMD(pDevice->PortOffset);
+		byCWMaxMin = 0xa4;
 
-		}
-		if (pDevice->bBarkerPreambleMd != VNTWIFIbIsBarkerMode(byERPField)) {
-			pDevice->bBarkerPreambleMd = VNTWIFIbIsBarkerMode(byERPField);
-			if (pDevice->bBarkerPreambleMd)
-				MACvEnableBarkerPreambleMd(pDevice->PortOffset);
-			else
-				MACvDisableBarkerPreambleMd(pDevice->PortOffset);
+		for (i = RATE_54M; i >= RATE_6M; i--) {
+			if (pDevice->basic_rates & ((u32)(0x1 << i))) {
+				byCWMaxMin |= 0x1;
+				break;
+			}
 		}
 	}
 
@@ -526,10 +496,6 @@ bool CARDbSetPhyParameter(struct vnt_private *pDevice, CARD_PHY_TYPE ePHYType,
 	if (pDevice->bySlot != bySlot) {
 		pDevice->bySlot = bySlot;
 		VNSvOutPortB(pDevice->PortOffset + MAC_REG_SLOT, pDevice->bySlot);
-		if (pDevice->bySlot == C_SLOT_SHORT)
-			pDevice->bShortSlotTime = true;
-		else
-			pDevice->bShortSlotTime = false;
 
 		BBvSetShortSlotTime(pDevice);
 	}
@@ -537,14 +503,9 @@ bool CARDbSetPhyParameter(struct vnt_private *pDevice, CARD_PHY_TYPE ePHYType,
 		pDevice->byCWMaxMin = byCWMaxMin;
 		VNSvOutPortB(pDevice->PortOffset + MAC_REG_CWMAXMIN0, pDevice->byCWMaxMin);
 	}
-	if (VNTWIFIbIsShortPreamble(wCapInfo))
-		pDevice->byPreambleType = pDevice->byShortPreamble;
-	else
-		pDevice->byPreambleType = 0;
 
-	s_vSetRSPINF(pDevice, ePHYType, pSupportRates, pExtSupportRates);
-	pDevice->eCurrentPHYType = ePHYType;
-	/* set for NDIS OID_802_11SUPPORTED_RATES */
+	s_vSetRSPINF(pDevice, ePHYType, NULL, NULL);
+
 	return true;
 }
 
-- 
2.1.0

