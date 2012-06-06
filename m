Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33669 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561Ab2FFNWW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 09:22:22 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 06/29] iwlwifi: use mac80211 channels for reset scan
Date: Wed,  6 Jun 2012 15:21:47 +0200
Message-Id: <1338988930-11561-6-git-send-email-johannes@sipsolutions.net> (sfid-20120606_152245_106400_2F368305)
In-Reply-To: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
References: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of iterating our own channel list,
use the mac80211 channel list since that's
already processed per band and thus makes
for less code.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c |   28 ++++++++--------------------
 1 file changed, 8 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index ea05ae8..069849e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -447,27 +447,17 @@ static u16 iwl_get_passive_dwell_time(struct iwl_priv *priv,
 
 /* Return valid, unused, channel for a passive scan to reset the RF */
 static u8 iwl_get_single_channel_number(struct iwl_priv *priv,
-				 enum ieee80211_band band)
+					enum ieee80211_band band)
 {
-	const struct iwl_channel_info *ch_info;
-	int i;
-	u8 channel = 0;
-	u8 min, max;
+	struct ieee80211_supported_band *sband = priv->hw->wiphy->bands[band];
 	struct iwl_rxon_context *ctx;
+	int i;
 
-	if (band == IEEE80211_BAND_5GHZ) {
-		min = 14;
-		max = priv->channel_count;
-	} else {
-		min = 0;
-		max = 14;
-	}
-
-	for (i = min; i < max; i++) {
+	for (i = 0; i < sband->n_channels; i++) {
 		bool busy = false;
 
 		for_each_context(priv, ctx) {
-			busy = priv->channel_info[i].channel ==
+			busy = sband->channels[i].hw_value ==
 				le16_to_cpu(ctx->staging.channel);
 			if (busy)
 				break;
@@ -476,13 +466,11 @@ static u8 iwl_get_single_channel_number(struct iwl_priv *priv,
 		if (busy)
 			continue;
 
-		channel = priv->channel_info[i].channel;
-		ch_info = iwl_get_channel_info(priv, band, channel);
-		if (is_channel_valid(ch_info))
-			break;
+		if (!(sband->channels[i].flags & IEEE80211_CHAN_DISABLED))
+			return sband->channels[i].hw_value;
 	}
 
-	return channel;
+	return 0;
 }
 
 static int iwl_get_single_channel_for_scan(struct iwl_priv *priv,
-- 
1.7.10

