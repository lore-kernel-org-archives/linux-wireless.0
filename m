Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:60957 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756668AbaJ2Rxh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:53:37 -0400
Received: by mail-wi0-f172.google.com with SMTP id bs8so2424064wib.17
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:53:36 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 18/34] staging: vt6655: CARDbSetPhyParameter replace s_vSetRSPINF with CARDvSetRSPINF
Date: Wed, 29 Oct 2014 17:43:53 +0000
Message-Id: <1414604649-9105-19-git-send-email-tvboxspy@gmail.com> (sfid-20141029_185342_691567_E1339962)
In-Reply-To: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
References: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing s_vSetRSPINF

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/card.c | 120 +-----------------------------------------
 1 file changed, 1 insertion(+), 119 deletions(-)

diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index a1330bc..72896c1 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -198,124 +198,6 @@ s_vCalculateOFDMRParameter(
 	}
 }
 
-/*
- * Description: Set RSPINF
- *
- * Parameters:
- *  In:
- *      pDevice             - The adapter to be set
- *  Out:
- *      none
- *
- * Return Value: None.
- */
-static
-void
-s_vSetRSPINF(struct vnt_private *pDevice, CARD_PHY_TYPE ePHYType,
-	     void *pvSupportRateIEs, void *pvExtSupportRateIEs)
-{
-	union vnt_phy_field_swap phy;
-	unsigned char byTxRate = 0, byRsvTime = 0;    /* For OFDM */
-
-	/* Set to Page1 */
-	MACvSelectPage1(pDevice->PortOffset);
-
-	/* RSPINF_b_1 */
-	vnt_get_phy_field(pDevice,
-			  14,
-			  VNTWIFIbyGetACKTxRate(RATE_1M, pvSupportRateIEs, pvExtSupportRateIEs),
-			  PK_TYPE_11B,
-			  &phy.field_read);
-
-	 /* swap over to get correct write order */
-	swap(phy.swap[0], phy.swap[1]);
-
-	VNSvOutPortD(pDevice->PortOffset + MAC_REG_RSPINF_B_1, phy.field_write);
-
-	/* RSPINF_b_2 */
-	vnt_get_phy_field(pDevice, 14,
-			  VNTWIFIbyGetACKTxRate(RATE_2M, pvSupportRateIEs, pvExtSupportRateIEs),
-			  PK_TYPE_11B, &phy.field_read);
-
-	swap(phy.swap[0], phy.swap[1]);
-
-	VNSvOutPortD(pDevice->PortOffset + MAC_REG_RSPINF_B_2, phy.field_write);
-
-	/* RSPINF_b_5 */
-	vnt_get_phy_field(pDevice, 14,
-			  VNTWIFIbyGetACKTxRate(RATE_5M, pvSupportRateIEs, pvExtSupportRateIEs),
-			  PK_TYPE_11B, &phy.field_read);
-
-	swap(phy.swap[0], phy.swap[1]);
-
-	VNSvOutPortD(pDevice->PortOffset + MAC_REG_RSPINF_B_5, phy.field_write);
-
-	/* RSPINF_b_11 */
-	vnt_get_phy_field(pDevice, 14,
-			  VNTWIFIbyGetACKTxRate(RATE_11M, pvSupportRateIEs, pvExtSupportRateIEs),
-			  PK_TYPE_11B, &phy.field_read);
-
-	swap(phy.swap[0], phy.swap[1]);
-
-	VNSvOutPortD(pDevice->PortOffset + MAC_REG_RSPINF_B_11, phy.field_write);
-
-	/* RSPINF_a_6 */
-	s_vCalculateOFDMRParameter(RATE_6M,
-				   ePHYType,
-				   &byTxRate,
-				   &byRsvTime);
-	VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_6, MAKEWORD(byTxRate, byRsvTime));
-	/* RSPINF_a_9 */
-	s_vCalculateOFDMRParameter(RATE_9M,
-				   ePHYType,
-				   &byTxRate,
-				   &byRsvTime);
-	VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_9, MAKEWORD(byTxRate, byRsvTime));
-	/* RSPINF_a_12 */
-	s_vCalculateOFDMRParameter(RATE_12M,
-				   ePHYType,
-				   &byTxRate,
-				   &byRsvTime);
-	VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_12, MAKEWORD(byTxRate, byRsvTime));
-	/* RSPINF_a_18 */
-	s_vCalculateOFDMRParameter(RATE_18M,
-				   ePHYType,
-				   &byTxRate,
-				   &byRsvTime);
-	VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_18, MAKEWORD(byTxRate, byRsvTime));
-	/* RSPINF_a_24 */
-	s_vCalculateOFDMRParameter(RATE_24M,
-				   ePHYType,
-				   &byTxRate,
-				   &byRsvTime);
-	VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_24, MAKEWORD(byTxRate, byRsvTime));
-	/* RSPINF_a_36 */
-	s_vCalculateOFDMRParameter(
-		VNTWIFIbyGetACKTxRate(RATE_36M, pvSupportRateIEs, pvExtSupportRateIEs),
-		ePHYType,
-		&byTxRate,
-		&byRsvTime);
-	VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_36, MAKEWORD(byTxRate, byRsvTime));
-	/* RSPINF_a_48 */
-	s_vCalculateOFDMRParameter(
-		VNTWIFIbyGetACKTxRate(RATE_48M, pvSupportRateIEs, pvExtSupportRateIEs),
-		ePHYType,
-		&byTxRate,
-		&byRsvTime);
-	VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_48, MAKEWORD(byTxRate, byRsvTime));
-	/* RSPINF_a_54 */
-	s_vCalculateOFDMRParameter(
-		VNTWIFIbyGetACKTxRate(RATE_54M, pvSupportRateIEs, pvExtSupportRateIEs),
-		ePHYType,
-		&byTxRate,
-		&byRsvTime);
-	VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_54, MAKEWORD(byTxRate, byRsvTime));
-	/* RSPINF_a_72 */
-	VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_72, MAKEWORD(byTxRate, byRsvTime));
-	/* Set to Page0 */
-	MACvSelectPage0(pDevice->PortOffset);
-}
-
 /*---------------------  Export Functions  --------------------------*/
 
 /*
@@ -504,7 +386,7 @@ bool CARDbSetPhyParameter(struct vnt_private *pDevice, CARD_PHY_TYPE ePHYType,
 		VNSvOutPortB(pDevice->PortOffset + MAC_REG_CWMAXMIN0, pDevice->byCWMaxMin);
 	}
 
-	s_vSetRSPINF(pDevice, ePHYType, NULL, NULL);
+	CARDvSetRSPINF(pDevice, ePHYType);
 
 	return true;
 }
-- 
2.1.0

