Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:65458 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933550AbaE3P2j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2014 11:28:39 -0400
Received: by mail-wi0-f175.google.com with SMTP id f8so1289426wiw.14
        for <linux-wireless@vger.kernel.org>; Fri, 30 May 2014 08:28:35 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 06/12] staging: vt6656: rename CARDvUpdateBasicTopRate to vnt_update_top_rates
Date: Fri, 30 May 2014 16:27:45 +0100
Message-Id: <1401463671-4705-6-git-send-email-tvboxspy@gmail.com> (sfid-20140530_172919_153549_BDD60D22)
In-Reply-To: <1401463671-4705-1-git-send-email-tvboxspy@gmail.com>
References: <1401463671-4705-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drop card basic. The function updates the top rates vnt_update_top_rates

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c | 6 +++---
 drivers/staging/vt6656/card.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index b2192c1..7542b0d 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -22,7 +22,7 @@
  *      s_vSafeResetTx - Rest Tx
  *      CARDvSetRSPINF - Set RSPINF
  *      vnt_update_ifs - Update slotTime,SIFS,DIFS, and EIFS
- *      CARDvUpdateBasicTopRate - Update BasicTopRate
+ *      vnt_update_top_rates - Update BasicTopRate
  *      CARDbAddBasicRate - Add to BasicRateSet
  *      CARDbSetBasicRate - Set Basic Tx Rate
  *      CARDbIsOFDMinBasicRate - Check if any OFDM rate is in BasicRateSet
@@ -465,7 +465,7 @@ void vnt_update_ifs(struct vnt_private *priv)
 		MESSAGE_REQUEST_MACREG, 1, &max_min);
 }
 
-void CARDvUpdateBasicTopRate(struct vnt_private *priv)
+void vnt_update_top_rates(struct vnt_private *priv)
 {
 	u8 top_ofdm = RATE_24M, top_cck = RATE_1M;
 	u8 i;
@@ -511,7 +511,7 @@ void CARDbAddBasicRate(struct vnt_private *priv, u16 rate_idx)
 	priv->wBasicRate |= (1 << rate_idx);
 
 	/*Determines the highest basic rate.*/
-	CARDvUpdateBasicTopRate(priv);
+	vnt_update_top_rates(priv);
 }
 
 int CARDbIsOFDMinBasicRate(struct vnt_private *priv)
diff --git a/drivers/staging/vt6656/card.h b/drivers/staging/vt6656/card.h
index 0b5c11c..f2afda4 100644
--- a/drivers/staging/vt6656/card.h
+++ b/drivers/staging/vt6656/card.h
@@ -48,7 +48,7 @@ struct vnt_private;
 void vnt_set_channel(struct vnt_private *, u32);
 void CARDvSetRSPINF(struct vnt_private *, u8);
 void vnt_update_ifs(struct vnt_private *);
-void CARDvUpdateBasicTopRate(struct vnt_private *);
+void vnt_update_top_rates(struct vnt_private *);
 void CARDbAddBasicRate(struct vnt_private *, u16);
 int CARDbIsOFDMinBasicRate(struct vnt_private *pDevice);
 void CARDvAdjustTSF(struct vnt_private *pDevice, u8 byRxRate,
-- 
1.9.1

