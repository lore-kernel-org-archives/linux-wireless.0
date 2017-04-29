Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:33020 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1426015AbdD2MEE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 29 Apr 2017 08:04:04 -0400
Received: by mail-wr0-f193.google.com with SMTP id w50so9519306wrc.0
        for <linux-wireless@vger.kernel.org>; Sat, 29 Apr 2017 05:04:04 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/4] staging: vt6656: vnt_update_ifs set max_min based on short slot time.
Date: Sat, 29 Apr 2017 13:03:42 +0100
Message-Id: <20170429120345.3782-1-tvboxspy@gmail.com> (sfid-20170429_140415_688488_C1C5B5C1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Short slot time is controlled by mac80211 so there is no need to find
odfm rates.

Merge PK_TYPE_11B and PK_TYPE_11GA & PK_TYPE_11GB into one else and
switch on short slot time.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c | 29 ++++++-----------------------
 1 file changed, 6 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 0e5a99375099..c61422ea8846 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -359,35 +359,18 @@ void vnt_update_ifs(struct vnt_private *priv)
 		priv->sifs = C_SIFS_A;
 		priv->difs = C_SIFS_A + 2 * C_SLOT_SHORT;
 		max_min = 4;
-	} else if (priv->packet_type == PK_TYPE_11B) {
-		priv->slot = C_SLOT_LONG;
-		priv->sifs = C_SIFS_BG;
-		priv->difs = C_SIFS_BG + 2 * C_SLOT_LONG;
-		max_min = 5;
-	} else {/* PK_TYPE_11GA & PK_TYPE_11GB */
-		bool ofdm_rate = false;
-		unsigned int ii = 0;
-
+	} else {
 		priv->sifs = C_SIFS_BG;
 
-		if (priv->short_slot_time)
+		if (priv->short_slot_time) {
 			priv->slot = C_SLOT_SHORT;
-		else
+			max_min = 4;
+		} else {
 			priv->slot = C_SLOT_LONG;
-
-		priv->difs = C_SIFS_BG + 2 * priv->slot;
-
-		for (ii = RATE_54M; ii >= RATE_6M; ii--) {
-			if (priv->basic_rates & ((u32)(0x1 << ii))) {
-				ofdm_rate = true;
-				break;
-			}
+			max_min = 5;
 		}
 
-		if (ofdm_rate)
-			max_min = 4;
-		else
-			max_min = 5;
+		priv->difs = C_SIFS_BG + 2 * priv->slot;
 	}
 
 	priv->eifs = C_EIFS;
-- 
2.11.0
