Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:37916 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbaJYTRS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 15:17:18 -0400
Received: by mail-wg0-f43.google.com with SMTP id n12so3072111wgh.2
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2014 12:17:16 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 18/31] staging: vt6655: CARDbSetPhyParameter replace s_vSetRSPINF with CARDvSetRSPINF
Date: Sat, 25 Oct 2014 09:20:28 +0100
Message-Id: <1414225241-5480-19-git-send-email-tvboxspy@gmail.com> (sfid-20141025_211725_090108_F8C81504)
In-Reply-To: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
References: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing s_vSetRSPINF

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/card.c | 121 +-----------------------------------------
 1 file changed, 1 insertion(+), 120 deletions(-)

diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index cf87b49..0574db9 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -199,125 +199,6 @@ s_vCalculateOFDMRParameter(
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
- *
- */
-static
-void
-s_vSetRSPINF(struct vnt_private *pDevice, CARD_PHY_TYPE ePHYType,
-	     void *pvSupportRateIEs, void *pvExtSupportRateIEs)
-{
-	union vnt_phy_field_swap phy;
-	unsigned char byTxRate = 0, byRsvTime = 0;    // For OFDM
-
-	//Set to Page1
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
-	//RSPINF_a_6
-	s_vCalculateOFDMRParameter(RATE_6M,
-				   ePHYType,
-				   &byTxRate,
-				   &byRsvTime);
-	VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_6, MAKEWORD(byTxRate, byRsvTime));
-	//RSPINF_a_9
-	s_vCalculateOFDMRParameter(RATE_9M,
-				   ePHYType,
-				   &byTxRate,
-				   &byRsvTime);
-	VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_9, MAKEWORD(byTxRate, byRsvTime));
-	//RSPINF_a_12
-	s_vCalculateOFDMRParameter(RATE_12M,
-				   ePHYType,
-				   &byTxRate,
-				   &byRsvTime);
-	VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_12, MAKEWORD(byTxRate, byRsvTime));
-	//RSPINF_a_18
-	s_vCalculateOFDMRParameter(RATE_18M,
-				   ePHYType,
-				   &byTxRate,
-				   &byRsvTime);
-	VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_18, MAKEWORD(byTxRate, byRsvTime));
-	//RSPINF_a_24
-	s_vCalculateOFDMRParameter(RATE_24M,
-				   ePHYType,
-				   &byTxRate,
-				   &byRsvTime);
-	VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_24, MAKEWORD(byTxRate, byRsvTime));
-	//RSPINF_a_36
-	s_vCalculateOFDMRParameter(
-		VNTWIFIbyGetACKTxRate(RATE_36M, pvSupportRateIEs, pvExtSupportRateIEs),
-		ePHYType,
-		&byTxRate,
-		&byRsvTime);
-	VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_36, MAKEWORD(byTxRate, byRsvTime));
-	//RSPINF_a_48
-	s_vCalculateOFDMRParameter(
-		VNTWIFIbyGetACKTxRate(RATE_48M, pvSupportRateIEs, pvExtSupportRateIEs),
-		ePHYType,
-		&byTxRate,
-		&byRsvTime);
-	VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_48, MAKEWORD(byTxRate, byRsvTime));
-	//RSPINF_a_54
-	s_vCalculateOFDMRParameter(
-		VNTWIFIbyGetACKTxRate(RATE_54M, pvSupportRateIEs, pvExtSupportRateIEs),
-		ePHYType,
-		&byTxRate,
-		&byRsvTime);
-	VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_54, MAKEWORD(byTxRate, byRsvTime));
-	//RSPINF_a_72
-	VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_72, MAKEWORD(byTxRate, byRsvTime));
-	//Set to Page0
-	MACvSelectPage0(pDevice->PortOffset);
-}
-
 /*---------------------  Export Functions  --------------------------*/
 
 /*
@@ -505,7 +386,7 @@ bool CARDbSetPhyParameter(struct vnt_private *pDevice, CARD_PHY_TYPE ePHYType,
 		VNSvOutPortB(pDevice->PortOffset + MAC_REG_CWMAXMIN0, pDevice->byCWMaxMin);
 	}
 
-	s_vSetRSPINF(pDevice, ePHYType, NULL, NULL);
+	CARDvSetRSPINF(pDevice, ePHYType);
 
 	return true;
 }
-- 
1.9.1

