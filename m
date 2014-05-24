Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:55663 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbaEXNiF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 May 2014 09:38:05 -0400
Received: by mail-wi0-f173.google.com with SMTP id bs8so2116265wib.12
        for <linux-wireless@vger.kernel.org>; Sat, 24 May 2014 06:38:04 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 03/14] staging: vt6656: camel case and cleanup CARDbyGetPktType
Date: Sat, 24 May 2014 14:36:59 +0100
Message-Id: <1400938630-2850-3-git-send-email-tvboxspy@gmail.com> (sfid-20140524_153814_253057_1D0EE64A)
In-Reply-To: <1400938630-2850-1-git-send-email-tvboxspy@gmail.com>
References: <1400938630-2850-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

camel case changes
pDevice -> priv

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 5a357c5..e39bdd5 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -534,18 +534,15 @@ int CARDbIsOFDMinBasicRate(struct vnt_private *priv)
 	return false;
 }
 
-u8 CARDbyGetPktType(struct vnt_private *pDevice)
+u8 CARDbyGetPktType(struct vnt_private *priv)
 {
 
-    if (pDevice->byBBType == BB_TYPE_11A || pDevice->byBBType == BB_TYPE_11B) {
-        return (u8)pDevice->byBBType;
-    }
-    else if (CARDbIsOFDMinBasicRate(pDevice)) {
-        return PK_TYPE_11GA;
-    }
-    else {
-        return PK_TYPE_11GB;
-    }
+	if (priv->byBBType == BB_TYPE_11A || priv->byBBType == BB_TYPE_11B)
+		return (u8)priv->byBBType;
+	else if (CARDbIsOFDMinBasicRate(priv))
+		return PK_TYPE_11GA;
+	else
+		return PK_TYPE_11GB;
 }
 
 /*
-- 
1.9.1

