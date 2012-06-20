Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39629 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279Ab2FTHiz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 03:38:55 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 11/12] iwlwifi: use minimal time for radio reset scan
Date: Wed, 20 Jun 2012 09:38:13 +0200
Message-Id: <1340177894-12992-12-git-send-email-johannes@sipsolutions.net> (sfid-20120620_093858_562840_B6EE4502)
In-Reply-To: <1340177894-12992-1-git-send-email-johannes@sipsolutions.net>
References: <1340177894-12992-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The effect of using a short single-channel scan
to reset the radio is that scanning a channel
that isn't in use needs to re-tune the radio.
This means that the dwell time is irrelevant,
so use a shorter time.

While at it, clean up the code for this a bit.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/scan.c |   41 ++++++++++++++-----------------
 1 file changed, 19 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/scan.c b/drivers/net/wireless/iwlwifi/dvm/scan.c
index 2f271c9..f5b1452 100644
--- a/drivers/net/wireless/iwlwifi/dvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/dvm/scan.c
@@ -51,6 +51,9 @@
 #define IWL_CHANNEL_TUNE_TIME       5
 #define MAX_SCAN_CHANNEL	    50
 
+/* For reset radio, need minimal dwell time only */
+#define IWL_RADIO_RESET_DWELL_TIME	5
+
 static int iwl_send_scan_abort(struct iwl_priv *priv)
 {
 	int ret;
@@ -469,45 +472,39 @@ static u8 iwl_get_single_channel_number(struct iwl_priv *priv,
 	return 0;
 }
 
-static int iwl_get_single_channel_for_scan(struct iwl_priv *priv,
-					   struct ieee80211_vif *vif,
-					   enum ieee80211_band band,
-					   struct iwl_scan_channel *scan_ch)
+static int iwl_get_channel_for_reset_scan(struct iwl_priv *priv,
+					  struct ieee80211_vif *vif,
+					  enum ieee80211_band band,
+					  struct iwl_scan_channel *scan_ch)
 {
 	const struct ieee80211_supported_band *sband;
-	u16 passive_dwell = 0;
-	u16 active_dwell = 0;
-	int added = 0;
-	u16 channel = 0;
+	u16 channel;
 
 	sband = iwl_get_hw_mode(priv, band);
 	if (!sband) {
 		IWL_ERR(priv, "invalid band\n");
-		return added;
+		return 0;
 	}
 
-	active_dwell = iwl_get_active_dwell_time(priv, band, 0);
-	passive_dwell = iwl_get_passive_dwell_time(priv, band);
-
-	if (passive_dwell <= active_dwell)
-		passive_dwell = active_dwell + 1;
-
 	channel = iwl_get_single_channel_number(priv, band);
 	if (channel) {
 		scan_ch->channel = cpu_to_le16(channel);
 		scan_ch->type = SCAN_CHANNEL_TYPE_PASSIVE;
-		scan_ch->active_dwell = cpu_to_le16(active_dwell);
-		scan_ch->passive_dwell = cpu_to_le16(passive_dwell);
+		scan_ch->active_dwell =
+			cpu_to_le16(IWL_RADIO_RESET_DWELL_TIME);
+		scan_ch->passive_dwell =
+			cpu_to_le16(IWL_RADIO_RESET_DWELL_TIME);
 		/* Set txpower levels to defaults */
 		scan_ch->dsp_atten = 110;
 		if (band == IEEE80211_BAND_5GHZ)
 			scan_ch->tx_gain = ((1 << 5) | (3 << 3)) | 3;
 		else
 			scan_ch->tx_gain = ((1 << 5) | (5 << 3));
-		added++;
-	} else
-		IWL_ERR(priv, "no valid channel found\n");
-	return added;
+		return 1;
+	}
+
+	IWL_ERR(priv, "no valid channel found\n");
+	return 0;
 }
 
 static int iwl_get_channels_for_scan(struct iwl_priv *priv,
@@ -896,7 +893,7 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	switch (priv->scan_type) {
 	case IWL_SCAN_RADIO_RESET:
 		scan->channel_count =
-			iwl_get_single_channel_for_scan(priv, vif, band,
+			iwl_get_channel_for_reset_scan(priv, vif, band,
 				(void *)&scan->data[cmd_len]);
 		break;
 	case IWL_SCAN_NORMAL:
-- 
1.7.10

