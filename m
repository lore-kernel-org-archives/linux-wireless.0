Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:33221 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaEYUiS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 May 2014 16:38:18 -0400
Received: by mail-wg0-f41.google.com with SMTP id z12so7121449wgg.12
        for <linux-wireless@vger.kernel.org>; Sun, 25 May 2014 13:38:17 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/8] staging: vt6656: swGetOFDMControlRate remove camel case
Date: Sun, 25 May 2014 21:36:22 +0100
Message-Id: <1401050189-3249-1-git-send-email-tvboxspy@gmail.com> (sfid-20140525_223822_812714_0D05E375)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

camel case changes
pDevice -> priv
wRateIdx -> rate_idx

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index ce069c9..f025010 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -149,31 +149,31 @@ static u16 swGetCCKControlRate(struct vnt_private *pDevice, u16 wRateIdx)
  *
  * Parameters:
  *  In:
- *      pDevice             - The adapter to be set
- *      wRateIdx            - Receiving data rate
+ *      priv		- The adapter to be set
+ *      rate_idx	- Receiving data rate
  *  Out:
  *      none
  *
  * Return Value: response Control frame rate
  *
  */
-static u16 swGetOFDMControlRate(struct vnt_private *pDevice, u16 wRateIdx)
+static u16 swGetOFDMControlRate(struct vnt_private *priv, u16 rate_idx)
 {
-	u16 ui = wRateIdx;
+	u16 ui = rate_idx;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"BASIC RATE: %X\n",
-		pDevice->wBasicRate);
+		priv->wBasicRate);
 
-	if (!CARDbIsOFDMinBasicRate(pDevice)) {
+	if (!CARDbIsOFDMinBasicRate(priv)) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-			"swGetOFDMControlRate:(NO OFDM) %d\n", wRateIdx);
-		if (wRateIdx > RATE_24M)
-			wRateIdx = RATE_24M;
-		return wRateIdx;
+			"swGetOFDMControlRate:(NO OFDM) %d\n", rate_idx);
+		if (rate_idx > RATE_24M)
+			rate_idx = RATE_24M;
+		return rate_idx;
 	}
 
 	while (ui > RATE_11M) {
-		if (pDevice->wBasicRate & (1 << ui)) {
+		if (priv->wBasicRate & (1 << ui)) {
 			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 				"swGetOFDMControlRate: %d\n", ui);
 			return ui;
-- 
1.9.1

