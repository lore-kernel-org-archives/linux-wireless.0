Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:10973 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753900Ab0EQGbD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 May 2010 02:31:03 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 16 May 2010 23:31:03 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19440.58039.731965.709469@gargle.gargle.HOWL>
Date: Mon, 17 May 2010 12:01:19 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 4/5] ath9k_htc: Enable SGI in HT20 for AR9271
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    3 +++
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    7 +++++--
 drivers/net/wireless/ath/ath9k/hw.c           |    2 +-
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 7ec2c2e..8b202e0 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -404,6 +404,9 @@ static void setup_ht_cap(struct ath9k_htc_priv *priv,
 		       IEEE80211_HT_CAP_SGI_40 |
 		       IEEE80211_HT_CAP_DSSSCCK40;
 
+	if (priv->ah->caps.hw_caps & ATH9K_HW_CAP_SGI_20)
+		ht_info->cap |= IEEE80211_HT_CAP_SGI_20;
+
 	ht_info->ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K;
 	ht_info->ampdu_density = IEEE80211_HT_MPDU_DENSITY_8;
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 80feeb3..6d46423 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -367,9 +367,12 @@ static void ath9k_htc_setup_rate(struct ath9k_htc_priv *priv,
 		caps = WLAN_RC_HT_FLAG;
 		if (sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
 			caps |= WLAN_RC_40_FLAG;
-		if (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40)
+		if (conf_is_ht40(&priv->hw->conf) &&
+		    (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40))
+			caps |= WLAN_RC_SGI_FLAG;
+		else if (conf_is_ht20(&priv->hw->conf) &&
+			 (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20))
 			caps |= WLAN_RC_SGI_FLAG;
-
 	}
 
 	trate->sta_index = ista->index;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 1985d19..45a9c84 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2232,7 +2232,7 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	if (AR_SREV_9300_20_OR_LATER(ah))
 		pCap->hw_caps |= ATH9K_HW_CAP_RAC_SUPPORTED;
 
-	if (AR_SREV_9287_10_OR_LATER(ah))
+	if (AR_SREV_9287_10_OR_LATER(ah) || AR_SREV_9271(ah))
 		pCap->hw_caps |= ATH9K_HW_CAP_SGI_20;
 
 	return 0;
-- 
1.7.1

