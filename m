Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:47531 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151AbaHTVcE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Aug 2014 17:32:04 -0400
Received: by mail-wi0-f182.google.com with SMTP id d1so7560455wiv.3
        for <linux-wireless@vger.kernel.org>; Wed, 20 Aug 2014 14:32:03 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 5/6] staging: vt6655: card.c change BBvCalculateParameter to vnt_get_phy_field
Date: Wed, 20 Aug 2014 22:30:30 +0100
Message-Id: <1408570231-10320-5-git-send-email-tvboxspy@gmail.com> (sfid-20140820_233208_894417_6C00281F)
In-Reply-To: <1408570231-10320-1-git-send-email-tvboxspy@gmail.com>
References: <1408570231-10320-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using vnt_get_phy_field means the values are not in the
correct write order the lower word and the upper word need
to be swapped over for an u32 write out.

Rather create another data variable to manipulate this structure.
Create a new union vnt_phy_field_swap with struct vnt_phy_field,
the u16 word swap and the u32 write out.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/card.c | 154 +++++++++++++++++++-----------------------
 drivers/staging/vt6655/desc.h |   6 ++
 2 files changed, 76 insertions(+), 84 deletions(-)

diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index 9807374..c4ed8d5 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -225,57 +225,51 @@ void
 s_vSetRSPINF(struct vnt_private *pDevice, CARD_PHY_TYPE ePHYType,
 	     void *pvSupportRateIEs, void *pvExtSupportRateIEs)
 {
-	unsigned char byServ = 0, bySignal = 0; // For CCK
-	unsigned short wLen = 0;
+	union vnt_phy_field_swap phy;
 	unsigned char byTxRate = 0, byRsvTime = 0;    // For OFDM
 
 	//Set to Page1
 	MACvSelectPage1(pDevice->PortOffset);
 
-	//RSPINF_b_1
-	BBvCalculateParameter(pDevice,
-			      14,
-			      VNTWIFIbyGetACKTxRate(RATE_1M, pvSupportRateIEs, pvExtSupportRateIEs),
-			      PK_TYPE_11B,
-			      &wLen,
-			      &byServ,
-			      &bySignal
-);
+	/* RSPINF_b_1 */
+	vnt_get_phy_field(pDevice,
+			  14,
+			  VNTWIFIbyGetACKTxRate(RATE_1M, pvSupportRateIEs, pvExtSupportRateIEs),
+			  PK_TYPE_11B,
+			  &phy.field_read);
 
-	VNSvOutPortD(pDevice->PortOffset + MAC_REG_RSPINF_B_1, MAKEDWORD(wLen, MAKEWORD(bySignal, byServ)));
-	///RSPINF_b_2
-	BBvCalculateParameter(pDevice,
-			      14,
-			      VNTWIFIbyGetACKTxRate(RATE_2M, pvSupportRateIEs, pvExtSupportRateIEs),
-			      PK_TYPE_11B,
-			      &wLen,
-			      &byServ,
-			      &bySignal
-);
+	 /* swap over to get correct write order */
+	swap(phy.swap[0], phy.swap[1]);
 
-	VNSvOutPortD(pDevice->PortOffset + MAC_REG_RSPINF_B_2, MAKEDWORD(wLen, MAKEWORD(bySignal, byServ)));
-	//RSPINF_b_5
-	BBvCalculateParameter(pDevice,
-			      14,
-			      VNTWIFIbyGetACKTxRate(RATE_5M, pvSupportRateIEs, pvExtSupportRateIEs),
-			      PK_TYPE_11B,
-			      &wLen,
-			      &byServ,
-			      &bySignal
-);
+	VNSvOutPortD(pDevice->PortOffset + MAC_REG_RSPINF_B_1, phy.field_write);
 
-	VNSvOutPortD(pDevice->PortOffset + MAC_REG_RSPINF_B_5, MAKEDWORD(wLen, MAKEWORD(bySignal, byServ)));
-	//RSPINF_b_11
-	BBvCalculateParameter(pDevice,
-			      14,
-			      VNTWIFIbyGetACKTxRate(RATE_11M, pvSupportRateIEs, pvExtSupportRateIEs),
-			      PK_TYPE_11B,
-			      &wLen,
-			      &byServ,
-			      &bySignal
-);
+	/* RSPINF_b_2 */
+	vnt_get_phy_field(pDevice, 14,
+			  VNTWIFIbyGetACKTxRate(RATE_2M, pvSupportRateIEs, pvExtSupportRateIEs),
+			  PK_TYPE_11B, &phy.field_read);
+
+	swap(phy.swap[0], phy.swap[1]);
+
+	VNSvOutPortD(pDevice->PortOffset + MAC_REG_RSPINF_B_2, phy.field_write);
+
+	/* RSPINF_b_5 */
+	vnt_get_phy_field(pDevice, 14,
+			  VNTWIFIbyGetACKTxRate(RATE_5M, pvSupportRateIEs, pvExtSupportRateIEs),
+			  PK_TYPE_11B, &phy.field_read);
+
+	swap(phy.swap[0], phy.swap[1]);
+
+	VNSvOutPortD(pDevice->PortOffset + MAC_REG_RSPINF_B_5, phy.field_write);
+
+	/* RSPINF_b_11 */
+	vnt_get_phy_field(pDevice, 14,
+			  VNTWIFIbyGetACKTxRate(RATE_11M, pvSupportRateIEs, pvExtSupportRateIEs),
+			  PK_TYPE_11B, &phy.field_read);
+
+	swap(phy.swap[0], phy.swap[1]);
+
+	VNSvOutPortD(pDevice->PortOffset + MAC_REG_RSPINF_B_11, phy.field_write);
 
-	VNSvOutPortD(pDevice->PortOffset + MAC_REG_RSPINF_B_11, MAKEDWORD(wLen, MAKEWORD(bySignal, byServ)));
 	//RSPINF_a_6
 	s_vCalculateOFDMRParameter(RATE_6M,
 				   ePHYType,
@@ -1592,57 +1586,49 @@ static unsigned short CARDwGetOFDMControlRate(struct vnt_private *pDevice,
  */
 void CARDvSetRSPINF(struct vnt_private *pDevice, CARD_PHY_TYPE ePHYType)
 {
-	unsigned char byServ = 0x00, bySignal = 0x00; //For CCK
-	unsigned short wLen = 0x0000;
+	union vnt_phy_field_swap phy;
 	unsigned char byTxRate, byRsvTime;             //For OFDM
 
 	//Set to Page1
 	MACvSelectPage1(pDevice->PortOffset);
 
-	//RSPINF_b_1
-	BBvCalculateParameter(pDevice,
-			      14,
-			      CARDwGetCCKControlRate((void *)pDevice, RATE_1M),
-			      PK_TYPE_11B,
-			      &wLen,
-			      &byServ,
-			      &bySignal
-);
+	/* RSPINF_b_1 */
+	vnt_get_phy_field(pDevice, 14,
+			  CARDwGetCCKControlRate(pDevice, RATE_1M),
+			  PK_TYPE_11B, &phy.field_read);
 
-	VNSvOutPortD(pDevice->PortOffset + MAC_REG_RSPINF_B_1, MAKEDWORD(wLen, MAKEWORD(bySignal, byServ)));
-	///RSPINF_b_2
-	BBvCalculateParameter(pDevice,
-			      14,
-			      CARDwGetCCKControlRate((void *)pDevice, RATE_2M),
-			      PK_TYPE_11B,
-			      &wLen,
-			      &byServ,
-			      &bySignal
-);
+	 /* swap over to get correct write order */
+	swap(phy.swap[0], phy.swap[1]);
 
-	VNSvOutPortD(pDevice->PortOffset + MAC_REG_RSPINF_B_2, MAKEDWORD(wLen, MAKEWORD(bySignal, byServ)));
-	//RSPINF_b_5
-	BBvCalculateParameter(pDevice,
-			      14,
-			      CARDwGetCCKControlRate((void *)pDevice, RATE_5M),
-			      PK_TYPE_11B,
-			      &wLen,
-			      &byServ,
-			      &bySignal
-);
+	VNSvOutPortD(pDevice->PortOffset + MAC_REG_RSPINF_B_1, phy.field_write);
 
-	VNSvOutPortD(pDevice->PortOffset + MAC_REG_RSPINF_B_5, MAKEDWORD(wLen, MAKEWORD(bySignal, byServ)));
-	//RSPINF_b_11
-	BBvCalculateParameter(pDevice,
-			      14,
-			      CARDwGetCCKControlRate((void *)pDevice, RATE_11M),
-			      PK_TYPE_11B,
-			      &wLen,
-			      &byServ,
-			      &bySignal
-);
+	/* RSPINF_b_2 */
+	vnt_get_phy_field(pDevice, 14,
+			  CARDwGetCCKControlRate(pDevice, RATE_2M),
+			  PK_TYPE_11B, &phy.field_read);
+
+	swap(phy.swap[0], phy.swap[1]);
+
+	VNSvOutPortD(pDevice->PortOffset + MAC_REG_RSPINF_B_2, phy.field_write);
+
+	/* RSPINF_b_5 */
+	vnt_get_phy_field(pDevice, 14,
+			  CARDwGetCCKControlRate(pDevice, RATE_5M),
+			  PK_TYPE_11B, &phy.field_read);
+
+	swap(phy.swap[0], phy.swap[1]);
+
+	VNSvOutPortD(pDevice->PortOffset + MAC_REG_RSPINF_B_5, phy.field_write);
+
+	/* RSPINF_b_11 */
+	vnt_get_phy_field(pDevice, 14,
+			  CARDwGetCCKControlRate(pDevice, RATE_11M),
+			  PK_TYPE_11B, &phy.field_read);
+
+	swap(phy.swap[0], phy.swap[1]);
+
+	VNSvOutPortD(pDevice->PortOffset + MAC_REG_RSPINF_B_11, phy.field_write);
 
-	VNSvOutPortD(pDevice->PortOffset + MAC_REG_RSPINF_B_11, MAKEDWORD(wLen, MAKEWORD(bySignal, byServ)));
 	//RSPINF_a_6
 	s_vCalculateOFDMRParameter(RATE_6M,
 				   ePHYType,
diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index 1dd38f7..1842723 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -384,6 +384,12 @@ struct vnt_phy_field {
 	__le16 len;
 } __packed;
 
+union vnt_phy_field_swap {
+	struct vnt_phy_field field_read;
+	u16 swap[2];
+	u32 field_write;
+};
+
 typedef struct tagSRTS_g {
 	struct vnt_phy_field b;
 	struct vnt_phy_field a;
-- 
1.9.1

