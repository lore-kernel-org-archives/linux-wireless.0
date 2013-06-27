Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:59448 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854Ab3F0Q7T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jun 2013 12:59:19 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv5 17/18] ath5k: set 5/10 MHz supported channels and fix duration
Date: Thu, 27 Jun 2013 18:58:59 +0200
Message-Id: <1372352340-20663-19-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130627_185929_798261_0FF85898)
In-Reply-To: <1372352340-20663-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1372352340-20663-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 drivers/net/wireless/ath/ath5k/base.c |   24 ++++++++++++++++--------
 drivers/net/wireless/ath/ath5k/pcu.c  |    2 ++
 drivers/net/wireless/ath/ath5k/qcu.c  |   25 ++++++++++++++++++++++++-
 3 files changed, 42 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 260a6fc..7c298af 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -165,28 +165,36 @@ static const struct ieee80211_rate ath5k_rates[] = {
 	  .flags = IEEE80211_RATE_SHORT_PREAMBLE },
 	{ .bitrate = 60,
 	  .hw_value = ATH5K_RATE_CODE_6M,
-	  .flags = 0 },
+	  .flags = IEEE80211_RATE_SUPPORTS_5MHZ |
+		   IEEE80211_RATE_SUPPORTS_10MHZ },
 	{ .bitrate = 90,
 	  .hw_value = ATH5K_RATE_CODE_9M,
-	  .flags = 0 },
+	  .flags = IEEE80211_RATE_SUPPORTS_5MHZ |
+		   IEEE80211_RATE_SUPPORTS_10MHZ },
 	{ .bitrate = 120,
 	  .hw_value = ATH5K_RATE_CODE_12M,
-	  .flags = 0 },
+	  .flags = IEEE80211_RATE_SUPPORTS_5MHZ |
+		   IEEE80211_RATE_SUPPORTS_10MHZ },
 	{ .bitrate = 180,
 	  .hw_value = ATH5K_RATE_CODE_18M,
-	  .flags = 0 },
+	  .flags = IEEE80211_RATE_SUPPORTS_5MHZ |
+		   IEEE80211_RATE_SUPPORTS_10MHZ },
 	{ .bitrate = 240,
 	  .hw_value = ATH5K_RATE_CODE_24M,
-	  .flags = 0 },
+	  .flags = IEEE80211_RATE_SUPPORTS_5MHZ |
+		   IEEE80211_RATE_SUPPORTS_10MHZ },
 	{ .bitrate = 360,
 	  .hw_value = ATH5K_RATE_CODE_36M,
-	  .flags = 0 },
+	  .flags = IEEE80211_RATE_SUPPORTS_5MHZ |
+		   IEEE80211_RATE_SUPPORTS_10MHZ },
 	{ .bitrate = 480,
 	  .hw_value = ATH5K_RATE_CODE_48M,
-	  .flags = 0 },
+	  .flags = IEEE80211_RATE_SUPPORTS_5MHZ |
+		   IEEE80211_RATE_SUPPORTS_10MHZ },
 	{ .bitrate = 540,
 	  .hw_value = ATH5K_RATE_CODE_54M,
-	  .flags = 0 },
+	  .flags = IEEE80211_RATE_SUPPORTS_5MHZ |
+		   IEEE80211_RATE_SUPPORTS_10MHZ },
 };
 
 static inline u64 ath5k_extend_tsf(struct ath5k_hw *ah, u32 rstamp)
diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index 1f16b42..c60d36a 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -144,11 +144,13 @@ ath5k_hw_get_frame_duration(struct ath5k_hw *ah, enum ieee80211_band band,
 		sifs = AR5K_INIT_SIFS_HALF_RATE;
 		preamble *= 2;
 		sym_time *= 2;
+		bitrate = DIV_ROUND_UP(bitrate, 2);
 		break;
 	case AR5K_BWMODE_5MHZ:
 		sifs = AR5K_INIT_SIFS_QUARTER_RATE;
 		preamble *= 4;
 		sym_time *= 4;
+		bitrate = DIV_ROUND_UP(bitrate, 4);
 		break;
 	default:
 		sifs = AR5K_INIT_SIFS_DEFAULT_BG;
diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index 65fe929..0583c69 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -566,9 +566,11 @@ int ath5k_hw_set_ifs_intervals(struct ath5k_hw *ah, unsigned int slot_time)
 {
 	struct ieee80211_channel *channel = ah->ah_current_channel;
 	enum ieee80211_band band;
+	struct ieee80211_supported_band *sband;
 	struct ieee80211_rate *rate;
 	u32 ack_tx_time, eifs, eifs_clock, sifs, sifs_clock;
 	u32 slot_time_clock = ath5k_hw_htoclock(ah, slot_time);
+	u32 rate_flags, i;
 
 	if (slot_time < 6 || slot_time_clock > AR5K_SLOT_TIME_MAX)
 		return -EINVAL;
@@ -605,7 +607,28 @@ int ath5k_hw_set_ifs_intervals(struct ath5k_hw *ah, unsigned int slot_time)
 	else
 		band = IEEE80211_BAND_2GHZ;
 
-	rate = &ah->sbands[band].bitrates[0];
+	switch (ah->ah_bwmode) {
+	case AR5K_BWMODE_5MHZ:
+		rate_flags = IEEE80211_RATE_SUPPORTS_5MHZ;
+		break;
+	case AR5K_BWMODE_10MHZ:
+		rate_flags = IEEE80211_RATE_SUPPORTS_10MHZ;
+		break;
+	default:
+		rate_flags = 0;
+		break;
+	}
+	sband = &ah->sbands[band];
+	rate = NULL;
+	for (i = 0; i < sband->n_bitrates; i++) {
+		if ((rate_flags & sband->bitrates[i].flags) != rate_flags)
+			continue;
+		rate = &sband->bitrates[i];
+		break;
+	}
+	if (WARN_ON(!rate))
+		return -EINVAL;
+
 	ack_tx_time = ath5k_hw_get_frame_duration(ah, band, 10, rate, false);
 
 	/* ack_tx_time includes an SIFS already */
-- 
1.7.10.4

