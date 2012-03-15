Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21225 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161466Ab2COU2N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 16:28:13 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 23/26] iwlwifi: move iwl_get_single_channel_number and mark it static
Date: Thu, 15 Mar 2012 13:27:03 -0700
Message-Id: <1331843226-29860-24-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120315_212833_633961_BB43B584)
In-Reply-To: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331843226-29860-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

iwl_get_single_channel_number is used only in
iwl-scan.c, move it there and mark it static.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   40 -------------------------------
 drivers/net/wireless/iwlwifi/iwl-core.h |    2 -
 drivers/net/wireless/iwlwifi/iwl-scan.c |   40 +++++++++++++++++++++++++++++++
 3 files changed, 40 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index ec250b2..ed201e7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -162,46 +162,6 @@ void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_config *ht_conf)
 		_iwl_set_rxon_ht(priv, ht_conf, ctx);
 }
 
-/* Return valid, unused, channel for a passive scan to reset the RF */
-u8 iwl_get_single_channel_number(struct iwl_priv *priv,
-				 enum ieee80211_band band)
-{
-	const struct iwl_channel_info *ch_info;
-	int i;
-	u8 channel = 0;
-	u8 min, max;
-	struct iwl_rxon_context *ctx;
-
-	if (band == IEEE80211_BAND_5GHZ) {
-		min = 14;
-		max = priv->channel_count;
-	} else {
-		min = 0;
-		max = 14;
-	}
-
-	for (i = min; i < max; i++) {
-		bool busy = false;
-
-		for_each_context(priv, ctx) {
-			busy = priv->channel_info[i].channel ==
-				le16_to_cpu(ctx->staging.channel);
-			if (busy)
-				break;
-		}
-
-		if (busy)
-			continue;
-
-		channel = priv->channel_info[i].channel;
-		ch_info = iwl_get_channel_info(priv, band, channel);
-		if (is_channel_valid(ch_info))
-			break;
-	}
-
-	return channel;
-}
-
 /**
  * iwl_set_rxon_channel - Set the band and channel values in staging RXON
  * @ch: requested channel as a pointer to struct ieee80211_channel
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 2488fc1..7aa3060 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -99,8 +99,6 @@ void iwl_set_flags_for_band(struct iwl_priv *priv,
 			    struct iwl_rxon_context *ctx,
 			    enum ieee80211_band band,
 			    struct ieee80211_vif *vif);
-u8 iwl_get_single_channel_number(struct iwl_priv *priv,
-				  enum ieee80211_band band);
 void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_config *ht_conf);
 bool iwl_is_ht40_tx_allowed(struct iwl_priv *priv,
 			    struct iwl_rxon_context *ctx,
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 4338d49..f3e5c2a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -451,6 +451,46 @@ static u16 iwl_get_passive_dwell_time(struct iwl_priv *priv,
 	return iwl_limit_dwell(priv, passive);
 }
 
+/* Return valid, unused, channel for a passive scan to reset the RF */
+static u8 iwl_get_single_channel_number(struct iwl_priv *priv,
+				 enum ieee80211_band band)
+{
+	const struct iwl_channel_info *ch_info;
+	int i;
+	u8 channel = 0;
+	u8 min, max;
+	struct iwl_rxon_context *ctx;
+
+	if (band == IEEE80211_BAND_5GHZ) {
+		min = 14;
+		max = priv->channel_count;
+	} else {
+		min = 0;
+		max = 14;
+	}
+
+	for (i = min; i < max; i++) {
+		bool busy = false;
+
+		for_each_context(priv, ctx) {
+			busy = priv->channel_info[i].channel ==
+				le16_to_cpu(ctx->staging.channel);
+			if (busy)
+				break;
+		}
+
+		if (busy)
+			continue;
+
+		channel = priv->channel_info[i].channel;
+		ch_info = iwl_get_channel_info(priv, band, channel);
+		if (is_channel_valid(ch_info))
+			break;
+	}
+
+	return channel;
+}
+
 static int iwl_get_single_channel_for_scan(struct iwl_priv *priv,
 					   struct ieee80211_vif *vif,
 					   enum ieee80211_band band,
-- 
1.7.0.4

