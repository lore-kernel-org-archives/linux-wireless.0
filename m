Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41095 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127Ab0CQW2P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 18:28:15 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 04/20] ath9k_hw: rename getNoiseFloorThresh() to ath9k_hw_getnf_thres()
Date: Wed, 17 Mar 2010 18:27:57 -0400
Message-Id: <1268864893-11428-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1268864893-11428-1-git-send-email-lrodriguez@atheros.com>
References: <1268864893-11428-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/calib.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index d5026e4..e4627da 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -175,9 +175,9 @@ static void ath9k_hw_do_getnf(struct ath_hw *ah,
 	}
 }
 
-static bool getNoiseFloorThresh(struct ath_hw *ah,
-				enum ieee80211_band band,
-				int16_t *nft)
+static bool ath9k_hw_getnf_thres(struct ath_hw *ah,
+				 enum ieee80211_band band,
+				 int16_t *nft)
 {
 	switch (band) {
 	case IEEE80211_BAND_5GHZ:
@@ -698,7 +698,7 @@ int16_t ath9k_hw_getnf(struct ath_hw *ah,
 	} else {
 		ath9k_hw_do_getnf(ah, nfarray);
 		nf = nfarray[0];
-		if (getNoiseFloorThresh(ah, c->band, &nfThresh)
+		if (ath9k_hw_getnf_thres(ah, c->band, &nfThresh)
 		    && nf > nfThresh) {
 			ath_print(common, ATH_DBG_CALIBRATE,
 				  "noise floor failed detected; "
-- 
1.6.3.3

