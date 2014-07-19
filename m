Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:60309 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760710AbaGSLbY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2014 07:31:24 -0400
Received: by mail-wi0-f169.google.com with SMTP id n3so2223674wiv.4
        for <linux-wireless@vger.kernel.org>; Sat, 19 Jul 2014 04:31:23 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 15/16] staging: vt6656: struct vnt_private remove uCwMin/uCwMax
Date: Sat, 19 Jul 2014 12:30:17 +0100
Message-Id: <1405769418-2815-15-git-send-email-tvboxspy@gmail.com> (sfid-20140719_133136_930991_631673CC)
In-Reply-To: <1405769418-2815-1-git-send-email-tvboxspy@gmail.com>
References: <1405769418-2815-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Although set these variables are not used.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c   | 10 ++--------
 drivers/staging/vt6656/device.h |  2 --
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 8820871..f3fd7d6 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -369,13 +369,11 @@ void vnt_update_ifs(struct vnt_private *priv)
 		priv->uSlot = C_SLOT_SHORT;
 		priv->uSIFS = C_SIFS_A;
 		priv->uDIFS = C_SIFS_A + 2 * C_SLOT_SHORT;
-		priv->uCwMin = C_CWMIN_A;
 		max_min = 4;
 	} else if (priv->byPacketType == PK_TYPE_11B) {
 		priv->uSlot = C_SLOT_LONG;
 		priv->uSIFS = C_SIFS_BG;
 		priv->uDIFS = C_SIFS_BG + 2 * C_SLOT_LONG;
-		priv->uCwMin = C_CWMIN_B;
 		max_min = 5;
 	} else {/* PK_TYPE_11GA & PK_TYPE_11GB */
 		bool ofdm_rate = false;
@@ -397,16 +395,12 @@ void vnt_update_ifs(struct vnt_private *priv)
 			}
 		}
 
-		if (ofdm_rate == true) {
-			priv->uCwMin = C_CWMIN_A;
+		if (ofdm_rate == true)
 			max_min = 4;
-		} else {
-			priv->uCwMin = C_CWMIN_B;
+		else
 			max_min = 5;
-			}
 	}
 
-	priv->uCwMax = C_CWMAX;
 	priv->uEIFS = C_EIFS;
 
 	switch (priv->rf_type) {
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index c4e83b5..f67173b 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -328,8 +328,6 @@ struct vnt_private {
 	u32 uDIFS;  /* Current DIFS */
 	u32 uEIFS;  /* Current EIFS */
 	u32 uSlot;  /* Current SlotTime */
-	u32 uCwMin; /* Current CwMin */
-	u32 uCwMax; /* CwMax is fixed on 1023 */
 
 	/* Rate */
 	u8 byBBType; /* 0: 11A, 1:11B, 2:11G */
-- 
2.0.1

