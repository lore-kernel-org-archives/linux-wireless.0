Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:40548 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbaKGTGm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2014 14:06:42 -0500
Received: by mail-wi0-f176.google.com with SMTP id h11so5532572wiw.3
        for <linux-wireless@vger.kernel.org>; Fri, 07 Nov 2014 11:06:41 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 04/10] staging: vt6655: CARDvSetRSPINF us bb_type for CARD_PHY_TYPE
Date: Fri,  7 Nov 2014 19:06:03 +0000
Message-Id: <1415387169-3843-4-git-send-email-tvboxspy@gmail.com> (sfid-20141107_200646_201268_680AE9B8)
In-Reply-To: <1415387169-3843-1-git-send-email-tvboxspy@gmail.com>
References: <1415387169-3843-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using u8 for bb_type

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/card.c | 20 ++++++++++----------
 drivers/staging/vt6655/card.h |  2 +-
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index 6a1efd1..24ba9d4 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -669,7 +669,7 @@ static unsigned short CARDwGetOFDMControlRate(struct vnt_private *pDevice,
  *
  * Return Value: None.
  */
-void CARDvSetRSPINF(struct vnt_private *pDevice, CARD_PHY_TYPE ePHYType)
+void CARDvSetRSPINF(struct vnt_private *pDevice, u8 bb_type)
 {
 	union vnt_phy_field_swap phy;
 	unsigned char byTxRate, byRsvTime;      /* For OFDM */
@@ -716,55 +716,55 @@ void CARDvSetRSPINF(struct vnt_private *pDevice, CARD_PHY_TYPE ePHYType)
 
 	/* RSPINF_a_6 */
 	s_vCalculateOFDMRParameter(RATE_6M,
-				   ePHYType,
+				   bb_type,
 				   &byTxRate,
 				   &byRsvTime);
 	VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_6, MAKEWORD(byTxRate, byRsvTime));
 	/* RSPINF_a_9 */
 	s_vCalculateOFDMRParameter(RATE_9M,
-				   ePHYType,
+				   bb_type,
 				   &byTxRate,
 				   &byRsvTime);
 	VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_9, MAKEWORD(byTxRate, byRsvTime));
 	/* RSPINF_a_12 */
 	s_vCalculateOFDMRParameter(RATE_12M,
-				   ePHYType,
+				   bb_type,
 				   &byTxRate,
 				   &byRsvTime);
 	VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_12, MAKEWORD(byTxRate, byRsvTime));
 	/* RSPINF_a_18 */
 	s_vCalculateOFDMRParameter(RATE_18M,
-				   ePHYType,
+				   bb_type,
 				   &byTxRate,
 				   &byRsvTime);
 	VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_18, MAKEWORD(byTxRate, byRsvTime));
 	/* RSPINF_a_24 */
 	s_vCalculateOFDMRParameter(RATE_24M,
-				   ePHYType,
+				   bb_type,
 				   &byTxRate,
 				   &byRsvTime);
 	VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_24, MAKEWORD(byTxRate, byRsvTime));
 	/* RSPINF_a_36 */
 	s_vCalculateOFDMRParameter(CARDwGetOFDMControlRate((void *)pDevice, RATE_36M),
-				   ePHYType,
+				   bb_type,
 				   &byTxRate,
 				   &byRsvTime);
 	VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_36, MAKEWORD(byTxRate, byRsvTime));
 	/* RSPINF_a_48 */
 	s_vCalculateOFDMRParameter(CARDwGetOFDMControlRate((void *)pDevice, RATE_48M),
-				   ePHYType,
+				   bb_type,
 				   &byTxRate,
 				   &byRsvTime);
 	VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_48, MAKEWORD(byTxRate, byRsvTime));
 	/* RSPINF_a_54 */
 	s_vCalculateOFDMRParameter(CARDwGetOFDMControlRate((void *)pDevice, RATE_54M),
-				   ePHYType,
+				   bb_type,
 				   &byTxRate,
 				   &byRsvTime);
 	VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_54, MAKEWORD(byTxRate, byRsvTime));
 	/* RSPINF_a_72 */
 	s_vCalculateOFDMRParameter(CARDwGetOFDMControlRate((void *)pDevice, RATE_54M),
-				   ePHYType,
+				   bb_type,
 				   &byTxRate,
 				   &byRsvTime);
 	VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_72, MAKEWORD(byTxRate, byRsvTime));
diff --git a/drivers/staging/vt6655/card.h b/drivers/staging/vt6655/card.h
index 9d19f97..306f7b7 100644
--- a/drivers/staging/vt6655/card.h
+++ b/drivers/staging/vt6655/card.h
@@ -73,7 +73,7 @@ typedef enum _CARD_STATUS_TYPE {
 
 struct vnt_private;
 
-void CARDvSetRSPINF(struct vnt_private *, CARD_PHY_TYPE ePHYType);
+void CARDvSetRSPINF(struct vnt_private *, u8);
 void vUpdateIFS(struct vnt_private *);
 void CARDvUpdateBasicTopRate(struct vnt_private *);
 bool CARDbIsOFDMinBasicRate(struct vnt_private *);
-- 
2.1.0

