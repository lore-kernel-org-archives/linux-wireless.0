Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54854 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756901Ab0DODaz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 23:30:55 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 53/97] ath9k_hw: rename getNoiseFloorThresh() to ath9k_hw_loadnf()
Date: Wed, 14 Apr 2010 23:30:07 -0400
Message-Id: <1271302251-9075-54-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
References: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/calib.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 4018074..aa724c2 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -89,9 +89,9 @@ static void ath9k_hw_update_nfcal_hist_buffer(struct ath9k_nfcal_hist *h,
 	return;
 }
 
-static bool getNoiseFloorThresh(struct ath_hw *ah,
-				enum ieee80211_band band,
-				int16_t *nft)
+static bool ath9k_hw_get_nf_thresh(struct ath_hw *ah,
+				   enum ieee80211_band band,
+				   int16_t *nft)
 {
 	switch (band) {
 	case IEEE80211_BAND_5GHZ:
@@ -612,7 +612,7 @@ int16_t ath9k_hw_getnf(struct ath_hw *ah,
 	} else {
 		ath9k_hw_do_getnf(ah, nfarray);
 		nf = nfarray[0];
-		if (getNoiseFloorThresh(ah, c->band, &nfThresh)
+		if (ath9k_hw_get_nf_thresh(ah, c->band, &nfThresh)
 		    && nf > nfThresh) {
 			ath_print(common, ATH_DBG_CALIBRATE,
 				  "noise floor failed detected; "
-- 
1.6.3.3

