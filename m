Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:64183 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbaEWRBf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 13:01:35 -0400
Received: by mail-wi0-f181.google.com with SMTP id n15so1216448wiw.8
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 10:01:34 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 19/20] staging: vt6656: camel case clean up CARDvUpdateBasicTopRate
Date: Fri, 23 May 2014 18:00:18 +0100
Message-Id: <1400864419-8327-19-git-send-email-tvboxspy@gmail.com> (sfid-20140523_192148_516687_9315630E)
In-Reply-To: <1400864419-8327-1-git-send-email-tvboxspy@gmail.com>
References: <1400864419-8327-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Camel case changes
pDevice -> priv
byTopOFDM -> top_ofdm
byTopCCK -> top_cck

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c | 46 ++++++++++++++++++++++---------------------
 drivers/staging/vt6656/card.h |  2 +-
 2 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 58d31bc..c52b983 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -473,29 +473,31 @@ void vUpdateIFS(struct vnt_private *priv)
 		MESSAGE_REQUEST_MACREG, 1, &max_min);
 }
 
-void CARDvUpdateBasicTopRate(struct vnt_private *pDevice)
+void CARDvUpdateBasicTopRate(struct vnt_private *priv)
 {
-	u8 byTopOFDM = RATE_24M, byTopCCK = RATE_1M;
-	u8 ii;
-
-     //Determines the highest basic rate.
-     for (ii = RATE_54M; ii >= RATE_6M; ii --) {
-         if ( (pDevice->wBasicRate) & ((u16)(1<<ii)) ) {
-             byTopOFDM = ii;
-             break;
-         }
-     }
-     pDevice->byTopOFDMBasicRate = byTopOFDM;
-
-     for (ii = RATE_11M;; ii --) {
-         if ( (pDevice->wBasicRate) & ((u16)(1<<ii)) ) {
-             byTopCCK = ii;
-             break;
-         }
-         if (ii == RATE_1M)
-            break;
-     }
-     pDevice->byTopCCKBasicRate = byTopCCK;
+	u8 top_ofdm = RATE_24M, top_cck = RATE_1M;
+	u8 i;
+
+	/*Determines the highest basic rate.*/
+	for (i = RATE_54M; i >= RATE_6M; i--) {
+		if (priv->wBasicRate & (u16)(1 << i)) {
+			top_ofdm = i;
+			break;
+		}
+	}
+
+	priv->byTopOFDMBasicRate = top_ofdm;
+
+	for (i = RATE_11M;; i--) {
+		if (priv->wBasicRate & (u16)(1 << i)) {
+			top_cck = i;
+			break;
+		}
+		if (i == RATE_1M)
+			break;
+	}
+
+	priv->byTopCCKBasicRate = top_cck;
  }
 
 /*
diff --git a/drivers/staging/vt6656/card.h b/drivers/staging/vt6656/card.h
index 4986e2d..78bd96f 100644
--- a/drivers/staging/vt6656/card.h
+++ b/drivers/staging/vt6656/card.h
@@ -48,7 +48,7 @@ struct vnt_private;
 void CARDbSetMediaChannel(struct vnt_private *pDevice, u32 uConnectionChannel);
 void CARDvSetRSPINF(struct vnt_private *, u8);
 void vUpdateIFS(struct vnt_private *);
-void CARDvUpdateBasicTopRate(struct vnt_private *pDevice);
+void CARDvUpdateBasicTopRate(struct vnt_private *);
 void CARDbAddBasicRate(struct vnt_private *pDevice, u16 wRateIdx);
 int CARDbIsOFDMinBasicRate(struct vnt_private *pDevice);
 void CARDvAdjustTSF(struct vnt_private *pDevice, u8 byRxRate,
-- 
1.9.1

