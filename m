Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:46108 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983AbaDMTUO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:20:14 -0400
Received: by mail-we0-f170.google.com with SMTP id w61so7355901wes.29
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:20:13 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/47] iwlwifi: mvm: fix the number of channels in family 8000
Date: Sun, 13 Apr 2014 22:19:17 +0300
Message-Id: <1397416802-32403-2-git-send-email-egrumbach@gmail.com> (sfid-20140413_212020_903011_7A3CB80D)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

Number of channels changed from 40 to 50

Signed-off-by: Eran Harary <eran.harary@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c   | 25 ++++++++++++++-----------
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h |  8 ++++++--
 2 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
index 6be30c6..4049c0d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/iwlwifi/iwl-nvm-parse.c
@@ -134,12 +134,13 @@ static const u8 iwl_nvm_channels_family_8000[] = {
 	149, 153, 157, 161, 165, 169, 173, 177, 181
 };
 
-#define IWL_NUM_CHANNELS	ARRAY_SIZE(iwl_nvm_channels)
+#define IWL_NUM_CHANNELS		ARRAY_SIZE(iwl_nvm_channels)
 #define IWL_NUM_CHANNELS_FAMILY_8000	ARRAY_SIZE(iwl_nvm_channels_family_8000)
-#define NUM_2GHZ_CHANNELS	14
-#define FIRST_2GHZ_HT_MINUS	5
-#define LAST_2GHZ_HT_PLUS	9
-#define LAST_5GHZ_HT		161
+#define NUM_2GHZ_CHANNELS		14
+#define NUM_2GHZ_CHANNELS_FAMILY_8000	13
+#define FIRST_2GHZ_HT_MINUS		5
+#define LAST_2GHZ_HT_PLUS		9
+#define LAST_5GHZ_HT			161
 
 #define DEFAULT_MAX_TX_POWER 16
 
@@ -202,21 +203,23 @@ static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
 	struct ieee80211_channel *channel;
 	u16 ch_flags;
 	bool is_5ghz;
-	int num_of_ch;
+	int num_of_ch, num_2ghz_channels;
 	const u8 *nvm_chan;
 
 	if (cfg->device_family != IWL_DEVICE_FAMILY_8000) {
 		num_of_ch = IWL_NUM_CHANNELS;
 		nvm_chan = &iwl_nvm_channels[0];
+		num_2ghz_channels = NUM_2GHZ_CHANNELS;
 	} else {
 		num_of_ch = IWL_NUM_CHANNELS_FAMILY_8000;
 		nvm_chan = &iwl_nvm_channels_family_8000[0];
+		num_2ghz_channels = NUM_2GHZ_CHANNELS_FAMILY_8000;
 	}
 
 	for (ch_idx = 0; ch_idx < num_of_ch; ch_idx++) {
 		ch_flags = __le16_to_cpup(nvm_ch_flags + ch_idx);
 
-		if (ch_idx >= NUM_2GHZ_CHANNELS &&
+		if (ch_idx >= num_2ghz_channels &&
 		    !data->sku_cap_band_52GHz_enable)
 			ch_flags &= ~NVM_CHANNEL_VALID;
 
@@ -225,7 +228,7 @@ static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
 					 "Ch. %d Flags %x [%sGHz] - No traffic\n",
 					 nvm_chan[ch_idx],
 					 ch_flags,
-					 (ch_idx >= NUM_2GHZ_CHANNELS) ?
+					 (ch_idx >= num_2ghz_channels) ?
 					 "5.2" : "2.4");
 			continue;
 		}
@@ -234,7 +237,7 @@ static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
 		n_channels++;
 
 		channel->hw_value = nvm_chan[ch_idx];
-		channel->band = (ch_idx < NUM_2GHZ_CHANNELS) ?
+		channel->band = (ch_idx < num_2ghz_channels) ?
 				IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
 		channel->center_freq =
 			ieee80211_channel_to_frequency(
@@ -242,7 +245,7 @@ static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
 
 		/* TODO: Need to be dependent to the NVM */
 		channel->flags = IEEE80211_CHAN_NO_HT40;
-		if (ch_idx < NUM_2GHZ_CHANNELS &&
+		if (ch_idx < num_2ghz_channels &&
 		    (ch_flags & NVM_CHANNEL_40MHZ)) {
 			if (nvm_chan[ch_idx] <= LAST_2GHZ_HT_PLUS)
 				channel->flags &= ~IEEE80211_CHAN_NO_HT40PLUS;
@@ -250,7 +253,7 @@ static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
 				channel->flags &= ~IEEE80211_CHAN_NO_HT40MINUS;
 		} else if (nvm_chan[ch_idx] <= LAST_5GHZ_HT &&
 			   (ch_flags & NVM_CHANNEL_40MHZ)) {
-			if ((ch_idx - NUM_2GHZ_CHANNELS) % 2 == 0)
+			if ((ch_idx - num_2ghz_channels) % 2 == 0)
 				channel->flags &= ~IEEE80211_CHAN_NO_HT40PLUS;
 			else
 				channel->flags &= ~IEEE80211_CHAN_NO_HT40MINUS;
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
index 9426905..02856e0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
@@ -169,8 +169,12 @@ enum iwl_scan_type {
 	SCAN_TYPE_DISCOVERY_FORCED	= 6,
 }; /* SCAN_ACTIVITY_TYPE_E_VER_1 */
 
-/* Maximal number of channels to scan */
-#define MAX_NUM_SCAN_CHANNELS 0x24
+/**
+ * Maximal number of channels to scan
+ * it should be equal to:
+ * max(IWL_NUM_CHANNELS, IWL_NUM_CHANNELS_FAMILY_8000)
+ */
+#define MAX_NUM_SCAN_CHANNELS 50
 
 /**
  * struct iwl_scan_cmd - scan request command
-- 
1.8.3.2

