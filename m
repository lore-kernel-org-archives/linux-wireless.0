Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:47086 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbcELWlI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2016 18:41:08 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath9k:  Support 4.9Ghz channels on AR9580 adapter.
Date: Thu, 12 May 2016 15:40:57 -0700
Message-Id: <1463092857-18503-1-git-send-email-greearb@candelatech.com> (sfid-20160513_004113_359698_FB2B2E4C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

NOTE:  These channels must not be used in most regulatory
domains unless you have a license from the FCC or similar!

A proper regulatory database is also required to actually use
these channels.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h       |  2 +-
 drivers/net/wireless/ath/ath9k/common-init.c | 42 ++++++++++++++++++++++------
 drivers/net/wireless/ath/ath9k/hw.h          |  4 +--
 3 files changed, 37 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index d78bb10..0429bd5 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -958,7 +958,7 @@ struct ath_softc {
 	struct device *dev;
 
 	struct survey_info *cur_survey;
-	struct survey_info survey[ATH9K_NUM_CHANNELS];
+	struct survey_info survey[ATH9K_MAX_NUM_CHANNELS];
 
 	struct tasklet_struct intr_tq;
 	struct tasklet_struct bcon_tasklet;
diff --git a/drivers/net/wireless/ath/ath9k/common-init.c b/drivers/net/wireless/ath/ath9k/common-init.c
index a006c14..2bff831 100644
--- a/drivers/net/wireless/ath/ath9k/common-init.c
+++ b/drivers/net/wireless/ath/ath9k/common-init.c
@@ -86,6 +86,20 @@ static const struct ieee80211_channel ath9k_5ghz_chantable[] = {
 	CHAN5G(5785, 35), /* Channel 157 */
 	CHAN5G(5805, 36), /* Channel 161 */
 	CHAN5G(5825, 37), /* Channel 165 */
+
+	/* 4.9Ghz channels, public safety channels, license is required in US
+	 * and most other regulatory domains!
+	 */
+	CHAN5G(4915, 38), /* Channel 183 */
+	CHAN5G(4920, 39), /* Channel 184 */
+	CHAN5G(4925, 40), /* Channel 185 */
+	CHAN5G(4935, 41), /* Channel 187 */
+	CHAN5G(4940, 42), /* Channel 188 */
+	CHAN5G(4945, 43), /* Channel 189 */
+	CHAN5G(4960, 44), /* Channel 192 */
+	CHAN5G(4970, 45), /* Channel 194 */
+	CHAN5G(4980, 46), /* Channel 196 */
+#define ATH9K_NUM_49GHZ_CHANNELS 9
 };
 
 /* Atheros hardware rate code addition for short premble */
@@ -122,14 +136,28 @@ static struct ieee80211_rate ath9k_legacy_rates[] = {
 			 IEEE80211_RATE_SUPPORTS_10MHZ)),
 };
 
+static bool ath9k_49ghz_capable(struct ath_hw* ah)
+{
+	/* Seems AR9580 supports 4.9ghz, at least. */
+	switch (ah->hw_version.devid) {
+	case AR9300_DEVID_AR9580:
+		return true;
+	}
+	return false;
+}
+
+
 int ath9k_cmn_init_channels_rates(struct ath_common *common)
 {
 	struct ath_hw *ah = (struct ath_hw *)common->ah;
 	void *channels;
+	int num_5ghz_chan = ARRAY_SIZE(ath9k_5ghz_chantable);
+	if (!ath9k_49ghz_capable(ah))
+		num_5ghz_chan -= ATH9K_NUM_49GHZ_CHANNELS;
 
 	BUILD_BUG_ON(ARRAY_SIZE(ath9k_2ghz_chantable) +
-		     ARRAY_SIZE(ath9k_5ghz_chantable) !=
-		     ATH9K_NUM_CHANNELS);
+		     ARRAY_SIZE(ath9k_5ghz_chantable) >
+		     ATH9K_MAX_NUM_CHANNELS);
 
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_2GHZ) {
 		channels = devm_kzalloc(ah->dev,
@@ -149,17 +177,15 @@ int ath9k_cmn_init_channels_rates(struct ath_common *common)
 	}
 
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_5GHZ) {
-		channels = devm_kzalloc(ah->dev,
-			sizeof(ath9k_5ghz_chantable), GFP_KERNEL);
+		int ch_sz = num_5ghz_chan * sizeof(ath9k_5ghz_chantable[0]);
+		channels = devm_kzalloc(ah->dev, ch_sz, GFP_KERNEL);
 		if (!channels)
 			return -ENOMEM;
 
-		memcpy(channels, ath9k_5ghz_chantable,
-		       sizeof(ath9k_5ghz_chantable));
+		memcpy(channels, ath9k_5ghz_chantable, ch_sz);
 		common->sbands[IEEE80211_BAND_5GHZ].channels = channels;
 		common->sbands[IEEE80211_BAND_5GHZ].band = IEEE80211_BAND_5GHZ;
-		common->sbands[IEEE80211_BAND_5GHZ].n_channels =
-			ARRAY_SIZE(ath9k_5ghz_chantable);
+		common->sbands[IEEE80211_BAND_5GHZ].n_channels = num_5ghz_chan;
 		common->sbands[IEEE80211_BAND_5GHZ].bitrates =
 			ath9k_legacy_rates + 4;
 		common->sbands[IEEE80211_BAND_5GHZ].n_bitrates =
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 831a544..eaf8d2d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -73,7 +73,7 @@
 
 #define ATH9K_RSSI_BAD			-128
 
-#define ATH9K_NUM_CHANNELS	38
+#define ATH9K_MAX_NUM_CHANNELS	47
 
 /* Register read/write primitives */
 #define REG_WRITE(_ah, _reg, _val) \
@@ -776,7 +776,7 @@ struct ath_hw {
 	struct ath9k_hw_version hw_version;
 	struct ath9k_ops_config config;
 	struct ath9k_hw_capabilities caps;
-	struct ath9k_channel channels[ATH9K_NUM_CHANNELS];
+	struct ath9k_channel channels[ATH9K_MAX_NUM_CHANNELS];
 	struct ath9k_channel *curchan;
 
 	union {
-- 
1.9.3

