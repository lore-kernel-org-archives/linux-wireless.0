Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:46996 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564AbaFYUP1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 16:15:27 -0400
Received: by mail-we0-f182.google.com with SMTP id q59so2616387wes.27
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jun 2014 13:15:26 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 07/17] staging: vt6656: mac80211 conversion: vnt_update_ifs change basic rates
Date: Wed, 25 Jun 2014 21:14:28 +0100
Message-Id: <1403727278-6666-8-git-send-email-tvboxspy@gmail.com> (sfid-20140625_221549_558855_5185D357)
In-Reply-To: <1403727278-6666-1-git-send-email-tvboxspy@gmail.com>
References: <1403727278-6666-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use wBasicRate to find ofdm_rate.

wBasicRate is changed to u32 to match struct ieee80211_bss_conf -> basic_rates

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c   | 22 ++--------------------
 drivers/staging/vt6656/device.h |  2 +-
 2 files changed, 3 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 8be3a89..1b3e0af 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -402,10 +402,8 @@ void vnt_update_ifs(struct vnt_private *priv)
 		priv->uCwMin = C_CWMIN_B;
 		max_min = 5;
 	} else {/* PK_TYPE_11GA & PK_TYPE_11GB */
-		u8 rate = 0;
 		bool ofdm_rate = false;
 		unsigned int ii = 0;
-		PWLAN_IE_SUPP_RATES item_rates = NULL;
 
 		priv->uSIFS = C_SIFS_BG;
 
@@ -416,29 +414,13 @@ void vnt_update_ifs(struct vnt_private *priv)
 
 		priv->uDIFS = C_SIFS_BG + 2 * priv->uSlot;
 
-		item_rates =
-			(PWLAN_IE_SUPP_RATES)priv->vnt_mgmt.abyCurrSuppRates;
-
-		for (ii = 0; ii < item_rates->len; ii++) {
-			rate = (u8)(item_rates->abyRates[ii] & 0x7f);
-			if (RATEwGetRateIdx(rate) > RATE_11M) {
+		for (ii = RATE_54M; ii >= RATE_6M; ii--) {
+			if (priv->wBasicRate & ((u32)(0x1 << ii))) {
 				ofdm_rate = true;
 				break;
 			}
 		}
 
-		if (ofdm_rate == false) {
-			item_rates = (PWLAN_IE_SUPP_RATES)priv->vnt_mgmt
-				.abyCurrExtSuppRates;
-			for (ii = 0; ii < item_rates->len; ii++) {
-				rate = (u8)(item_rates->abyRates[ii] & 0x7f);
-				if (RATEwGetRateIdx(rate) > RATE_11M) {
-					ofdm_rate = true;
-					break;
-				}
-			}
-		}
-
 		if (ofdm_rate == true) {
 			priv->uCwMin = C_CWMIN_A;
 			max_min = 4;
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 46584c7..2bd9830 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -522,7 +522,7 @@ struct vnt_private {
 	/* Rate */
 	u8 byBBType; /* 0: 11A, 1:11B, 2:11G */
 	u8 byPacketType; /* 0:11a 1:11b 2:11gb 3:11ga */
-	u16 wBasicRate;
+	u32 wBasicRate;
 	u8 byTopOFDMBasicRate;
 	u8 byTopCCKBasicRate;
 
-- 
1.9.1

