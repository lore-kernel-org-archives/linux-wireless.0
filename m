Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:45387 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933614AbaE3P2l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2014 11:28:41 -0400
Received: by mail-wi0-f172.google.com with SMTP id hi2so1309905wib.17
        for <linux-wireless@vger.kernel.org>; Fri, 30 May 2014 08:28:38 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 09/12] staging: vt6656: rename CARDbIsOFDMinBasicRate to vnt_ofdm_min_rate
Date: Fri, 30 May 2014 16:27:48 +0100
Message-Id: <1401463671-4705-9-git-send-email-tvboxspy@gmail.com> (sfid-20140530_172853_863083_3EB3CF87)
In-Reply-To: <1401463671-4705-1-git-send-email-tvboxspy@gmail.com>
References: <1401463671-4705-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drop card and basic rename to vnt_ofdm_min_rate

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c     | 8 ++++----
 drivers/staging/vt6656/card.h     | 2 +-
 drivers/staging/vt6656/datarate.c | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index a905076..8e6158b 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -25,7 +25,7 @@
  *      vnt_update_top_rates - Update BasicTopRate
  *      vnt_add_basic_rate - Add to BasicRateSet
  *      CARDbSetBasicRate - Set Basic Tx Rate
- *      CARDbIsOFDMinBasicRate - Check if any OFDM rate is in BasicRateSet
+ *      vnt_ofdm_min_rate - Check if any OFDM rate is in BasicRateSet
  *      CARDvSetLoopbackMode - Set Loopback mode
  *      CARDbSoftwareReset - Sortware reset NIC
  *      CARDqGetTSFOffset - Calculate TSFOffset
@@ -161,7 +161,7 @@ static u16 vnt_get_ofdm_rate(struct vnt_private *priv, u16 rate_idx)
 	dev_dbg(&priv->usb->dev, "%s basic rate: %d\n",
 					__func__,  priv->wBasicRate);
 
-	if (!CARDbIsOFDMinBasicRate(priv)) {
+	if (!vnt_ofdm_min_rate(priv)) {
 		dev_dbg(&priv->usb->dev, "%s (NO OFDM) %d\n",
 						__func__, rate_idx);
 		if (rate_idx > RATE_24M)
@@ -514,7 +514,7 @@ void vnt_add_basic_rate(struct vnt_private *priv, u16 rate_idx)
 	vnt_update_top_rates(priv);
 }
 
-int CARDbIsOFDMinBasicRate(struct vnt_private *priv)
+int vnt_ofdm_min_rate(struct vnt_private *priv)
 {
 	int ii;
 
@@ -531,7 +531,7 @@ u8 CARDbyGetPktType(struct vnt_private *priv)
 
 	if (priv->byBBType == BB_TYPE_11A || priv->byBBType == BB_TYPE_11B)
 		return (u8)priv->byBBType;
-	else if (CARDbIsOFDMinBasicRate(priv))
+	else if (vnt_ofdm_min_rate(priv))
 		return PK_TYPE_11GA;
 	else
 		return PK_TYPE_11GB;
diff --git a/drivers/staging/vt6656/card.h b/drivers/staging/vt6656/card.h
index ef5a671..41871e9 100644
--- a/drivers/staging/vt6656/card.h
+++ b/drivers/staging/vt6656/card.h
@@ -50,7 +50,7 @@ void vnt_set_rspinf(struct vnt_private *, u8);
 void vnt_update_ifs(struct vnt_private *);
 void vnt_update_top_rates(struct vnt_private *);
 void vnt_add_basic_rate(struct vnt_private *, u16);
-int CARDbIsOFDMinBasicRate(struct vnt_private *pDevice);
+int vnt_ofdm_min_rate(struct vnt_private *);
 void CARDvAdjustTSF(struct vnt_private *pDevice, u8 byRxRate,
 		u64 qwBSSTimestamp, u64 qwLocalTSF);
 bool CARDbGetCurrentTSF(struct vnt_private *pDevice, u64 *pqwCurrTSF);
diff --git a/drivers/staging/vt6656/datarate.c b/drivers/staging/vt6656/datarate.c
index 517fbf7..c44d3a0 100644
--- a/drivers/staging/vt6656/datarate.c
+++ b/drivers/staging/vt6656/datarate.c
@@ -210,7 +210,7 @@ void RATEvParseMaxRate(struct vnt_private *pDevice,
 	}
 
 	if ((pDevice->byPacketType == PK_TYPE_11GB)
-			&& CARDbIsOFDMinBasicRate((void *)pDevice)) {
+			&& vnt_ofdm_min_rate(pDevice)) {
 		pDevice->byPacketType = PK_TYPE_11GA;
 	}
 
-- 
1.9.1

