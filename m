Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:33116 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbaEXNiE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 May 2014 09:38:04 -0400
Received: by mail-wg0-f41.google.com with SMTP id z12so6012306wgg.12
        for <linux-wireless@vger.kernel.org>; Sat, 24 May 2014 06:38:03 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 02/14] staging: vt6656: camel case clean up CARDbIsOFDMinBasicRate
Date: Sat, 24 May 2014 14:36:58 +0100
Message-Id: <1400938630-2850-2-git-send-email-tvboxspy@gmail.com> (sfid-20140524_153812_548821_5BC870B4)
In-Reply-To: <1400938630-2850-1-git-send-email-tvboxspy@gmail.com>
References: <1400938630-2850-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

camel case change
pDevice -> priv

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 439e536..5a357c5 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -522,15 +522,16 @@ void CARDbAddBasicRate(struct vnt_private *priv, u16 rate_idx)
 	CARDvUpdateBasicTopRate(priv);
 }
 
-int CARDbIsOFDMinBasicRate(struct vnt_private *pDevice)
+int CARDbIsOFDMinBasicRate(struct vnt_private *priv)
 {
 	int ii;
 
-    for (ii = RATE_54M; ii >= RATE_6M; ii --) {
-        if ((pDevice->wBasicRate) & ((u16)(1<<ii)))
-            return true;
-    }
-    return false;
+	for (ii = RATE_54M; ii >= RATE_6M; ii--) {
+		if ((priv->wBasicRate) & ((u16)(1 << ii)))
+			return true;
+	}
+
+	return false;
 }
 
 u8 CARDbyGetPktType(struct vnt_private *pDevice)
-- 
1.9.1

