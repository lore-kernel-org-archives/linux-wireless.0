Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:42000 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbaEWRBg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 13:01:36 -0400
Received: by mail-we0-f174.google.com with SMTP id k48so5264296wev.33
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 10:01:35 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 20/20] staging: vt6656: camel case cleanup CARDbAddBasicRate
Date: Fri, 23 May 2014 18:00:19 +0100
Message-Id: <1400864419-8327-20-git-send-email-tvboxspy@gmail.com> (sfid-20140523_192148_773579_D23D77DB)
In-Reply-To: <1400864419-8327-1-git-send-email-tvboxspy@gmail.com>
References: <1400864419-8327-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

camel case changes
pDevice -> priv
wRateIdx -> rate_idx

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c | 9 ++++-----
 drivers/staging/vt6656/card.h | 2 +-
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index c52b983..439e536 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -513,14 +513,13 @@ void CARDvUpdateBasicTopRate(struct vnt_private *priv)
  * Return Value: true if succeeded; false if failed.
  *
  */
-void CARDbAddBasicRate(struct vnt_private *pDevice, u16 wRateIdx)
+void CARDbAddBasicRate(struct vnt_private *priv, u16 rate_idx)
 {
-	u16 wRate = (1 << wRateIdx);
 
-    pDevice->wBasicRate |= wRate;
+	priv->wBasicRate |= (1 << rate_idx);
 
-    //Determines the highest basic rate.
-    CARDvUpdateBasicTopRate(pDevice);
+	/*Determines the highest basic rate.*/
+	CARDvUpdateBasicTopRate(priv);
 }
 
 int CARDbIsOFDMinBasicRate(struct vnt_private *pDevice)
diff --git a/drivers/staging/vt6656/card.h b/drivers/staging/vt6656/card.h
index 78bd96f..ac73471 100644
--- a/drivers/staging/vt6656/card.h
+++ b/drivers/staging/vt6656/card.h
@@ -49,7 +49,7 @@ void CARDbSetMediaChannel(struct vnt_private *pDevice, u32 uConnectionChannel);
 void CARDvSetRSPINF(struct vnt_private *, u8);
 void vUpdateIFS(struct vnt_private *);
 void CARDvUpdateBasicTopRate(struct vnt_private *);
-void CARDbAddBasicRate(struct vnt_private *pDevice, u16 wRateIdx);
+void CARDbAddBasicRate(struct vnt_private *, u16);
 int CARDbIsOFDMinBasicRate(struct vnt_private *pDevice);
 void CARDvAdjustTSF(struct vnt_private *pDevice, u8 byRxRate,
 		u64 qwBSSTimestamp, u64 qwLocalTSF);
-- 
1.9.1

