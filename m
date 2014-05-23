Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:60319 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506AbaEWRBb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 13:01:31 -0400
Received: by mail-we0-f178.google.com with SMTP id u56so5081121wes.37
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 10:01:30 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 17/20] staging: vt6656: camel case cleanup CARDvSetRSPINF
Date: Fri, 23 May 2014 18:00:16 +0100
Message-Id: <1400864419-8327-17-git-send-email-tvboxspy@gmail.com> (sfid-20140523_192149_269054_99126E66)
In-Reply-To: <1400864419-8327-1-git-send-email-tvboxspy@gmail.com>
References: <1400864419-8327-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

camel case changes
pDevice -> priv
byBBType -> bb_type

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c | 179 +++++++++++++++++++-----------------------
 drivers/staging/vt6656/card.h |   2 +-
 2 files changed, 80 insertions(+), 101 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 1674a6f..43554e0 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -293,112 +293,91 @@ void CARDvCalculateOFDMRParameter(u16 rate, u8 bb_type,
  * Return Value: None.
  *
  */
-void CARDvSetRSPINF(struct vnt_private *pDevice, u8 byBBType)
+
+void CARDvSetRSPINF(struct vnt_private *priv, u8 bb_type)
 {
 	struct vnt_phy_field phy[4];
-	u8 abyTxRate[9] = {0, 0, 0, 0, 0, 0, 0, 0, 0}; /* For OFDM */
-	u8 abyRsvTime[9] = {0, 0, 0, 0, 0, 0, 0, 0, 0};
-	u8 abyData[34];
+	u8 tx_rate[9] = {0, 0, 0, 0, 0, 0, 0, 0, 0}; /* For OFDM */
+	u8 rsv_time[9] = {0, 0, 0, 0, 0, 0, 0, 0, 0};
+	u8 data[34];
 	int i;
 
-    //RSPINF_b_1
-	BBvCalculateParameter(pDevice, 14,
-		swGetCCKControlRate(pDevice, RATE_1M), PK_TYPE_11B, &phy[0]);
-
-    ///RSPINF_b_2
-	BBvCalculateParameter(pDevice, 14,
-		swGetCCKControlRate(pDevice, RATE_2M), PK_TYPE_11B, &phy[1]);
-
-    //RSPINF_b_5
-	BBvCalculateParameter(pDevice, 14,
-		swGetCCKControlRate(pDevice, RATE_5M), PK_TYPE_11B, &phy[2]);
-
-    //RSPINF_b_11
-	BBvCalculateParameter(pDevice, 14,
-		swGetCCKControlRate(pDevice, RATE_11M), PK_TYPE_11B, &phy[3]);
-
-    //RSPINF_a_6
-    CARDvCalculateOFDMRParameter (RATE_6M,
-                                 byBBType,
-                                 &abyTxRate[0],
-                                 &abyRsvTime[0]);
-
-    //RSPINF_a_9
-    CARDvCalculateOFDMRParameter (RATE_9M,
-                                 byBBType,
-                                 &abyTxRate[1],
-                                 &abyRsvTime[1]);
-
-    //RSPINF_a_12
-    CARDvCalculateOFDMRParameter (RATE_12M,
-                                 byBBType,
-                                 &abyTxRate[2],
-                                 &abyRsvTime[2]);
-
-    //RSPINF_a_18
-    CARDvCalculateOFDMRParameter (RATE_18M,
-                                 byBBType,
-                                 &abyTxRate[3],
-                                 &abyRsvTime[3]);
-
-    //RSPINF_a_24
-    CARDvCalculateOFDMRParameter (RATE_24M,
-                                 byBBType,
-                                 &abyTxRate[4],
-                                 &abyRsvTime[4]);
-
-    //RSPINF_a_36
-    CARDvCalculateOFDMRParameter (swGetOFDMControlRate(pDevice, RATE_36M),
-                                 byBBType,
-                                 &abyTxRate[5],
-                                 &abyRsvTime[5]);
-
-    //RSPINF_a_48
-    CARDvCalculateOFDMRParameter (swGetOFDMControlRate(pDevice, RATE_48M),
-                                 byBBType,
-                                 &abyTxRate[6],
-                                 &abyRsvTime[6]);
-
-    //RSPINF_a_54
-    CARDvCalculateOFDMRParameter (swGetOFDMControlRate(pDevice, RATE_54M),
-                                 byBBType,
-                                 &abyTxRate[7],
-                                 &abyRsvTime[7]);
-
-    //RSPINF_a_72
-    CARDvCalculateOFDMRParameter (swGetOFDMControlRate(pDevice, RATE_54M),
-                                 byBBType,
-                                 &abyTxRate[8],
-                                 &abyRsvTime[8]);
-
-	put_unaligned(phy[0].len, (u16 *)&abyData[0]);
-	abyData[2] = phy[0].signal;
-	abyData[3] = phy[0].service;
-
-	put_unaligned(phy[1].len, (u16 *)&abyData[4]);
-	abyData[6] = phy[1].signal;
-	abyData[7] = phy[1].service;
-
-	put_unaligned(phy[2].len, (u16 *)&abyData[8]);
-	abyData[10] = phy[2].signal;
-	abyData[11] = phy[2].service;
-
-	put_unaligned(phy[3].len, (u16 *)&abyData[12]);
-	abyData[14] = phy[3].signal;
-	abyData[15] = phy[3].service;
-
-    for (i = 0; i < 9; i++) {
-	abyData[16+i*2] = abyTxRate[i];
-	abyData[16+i*2+1] = abyRsvTime[i];
-    }
+	/*RSPINF_b_1*/
+	BBvCalculateParameter(priv, 14,
+		swGetCCKControlRate(priv, RATE_1M), PK_TYPE_11B, &phy[0]);
 
-    CONTROLnsRequestOut(pDevice,
-                        MESSAGE_TYPE_WRITE,
-                        MAC_REG_RSPINF_B_1,
-                        MESSAGE_REQUEST_MACREG,
-                        34,
-                        &abyData[0]);
+	/*RSPINF_b_2*/
+	BBvCalculateParameter(priv, 14,
+		swGetCCKControlRate(priv, RATE_2M), PK_TYPE_11B, &phy[1]);
+
+	/*RSPINF_b_5*/
+	BBvCalculateParameter(priv, 14,
+		swGetCCKControlRate(priv, RATE_5M), PK_TYPE_11B, &phy[2]);
+
+	/*RSPINF_b_11*/
+	BBvCalculateParameter(priv, 14,
+		swGetCCKControlRate(priv, RATE_11M), PK_TYPE_11B, &phy[3]);
+
+
+	/*RSPINF_a_6*/
+	CARDvCalculateOFDMRParameter(RATE_6M, bb_type,
+						&tx_rate[0], &rsv_time[0]);
+
+	/*RSPINF_a_9*/
+	CARDvCalculateOFDMRParameter(RATE_9M, bb_type,
+						&tx_rate[1], &rsv_time[1]);
+
+	/*RSPINF_a_12*/
+	CARDvCalculateOFDMRParameter(RATE_12M, bb_type,
+						&tx_rate[2], &rsv_time[2]);
+
+	/*RSPINF_a_18*/
+	CARDvCalculateOFDMRParameter(RATE_18M, bb_type,
+						&tx_rate[3], &rsv_time[3]);
+
+	/*RSPINF_a_24*/
+	CARDvCalculateOFDMRParameter(RATE_24M, bb_type,
+						&tx_rate[4], &rsv_time[4]);
+
+	/*RSPINF_a_36*/
+	CARDvCalculateOFDMRParameter(swGetOFDMControlRate(priv, RATE_36M),
+					bb_type, &tx_rate[5], &rsv_time[5]);
+
+	/*RSPINF_a_48*/
+	CARDvCalculateOFDMRParameter(swGetOFDMControlRate(priv, RATE_48M),
+					bb_type, &tx_rate[6], &rsv_time[6]);
+
+	/*RSPINF_a_54*/
+	CARDvCalculateOFDMRParameter(swGetOFDMControlRate(priv, RATE_54M),
+					bb_type, &tx_rate[7], &rsv_time[7]);
+
+	/*RSPINF_a_72*/
+	CARDvCalculateOFDMRParameter(swGetOFDMControlRate(priv, RATE_54M),
+					bb_type, &tx_rate[8], &rsv_time[8]);
+
+	put_unaligned(phy[0].len, (u16 *)&data[0]);
+	data[2] = phy[0].signal;
+	data[3] = phy[0].service;
+
+	put_unaligned(phy[1].len, (u16 *)&data[4]);
+	data[6] = phy[1].signal;
+	data[7] = phy[1].service;
+
+	put_unaligned(phy[2].len, (u16 *)&data[8]);
+	data[10] = phy[2].signal;
+	data[11] = phy[2].service;
+
+	put_unaligned(phy[3].len, (u16 *)&data[12]);
+	data[14] = phy[3].signal;
+	data[15] = phy[3].service;
+
+	for (i = 0; i < 9; i++) {
+		data[16 + i * 2] = tx_rate[i];
+		data[16 + i * 2 + 1] = rsv_time[i];
+	}
 
+	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE,
+		MAC_REG_RSPINF_B_1, MESSAGE_REQUEST_MACREG, 34, &data[0]);
 }
 
 /*
diff --git a/drivers/staging/vt6656/card.h b/drivers/staging/vt6656/card.h
index f843e50..6123c13 100644
--- a/drivers/staging/vt6656/card.h
+++ b/drivers/staging/vt6656/card.h
@@ -46,7 +46,7 @@ typedef enum _CARD_PHY_TYPE {
 struct vnt_private;
 
 void CARDbSetMediaChannel(struct vnt_private *pDevice, u32 uConnectionChannel);
-void CARDvSetRSPINF(struct vnt_private *pDevice, u8 byBBType);
+void CARDvSetRSPINF(struct vnt_private *, u8);
 void vUpdateIFS(struct vnt_private *pDevice);
 void CARDvUpdateBasicTopRate(struct vnt_private *pDevice);
 void CARDbAddBasicRate(struct vnt_private *pDevice, u16 wRateIdx);
-- 
1.9.1

