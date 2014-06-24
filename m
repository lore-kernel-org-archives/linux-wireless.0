Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:59336 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbaFXTjA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 15:39:00 -0400
Received: by mail-wi0-f170.google.com with SMTP id cc10so6444346wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2014 12:38:58 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/3] iwlwifi: mvm: rework sched scan channel configuration
Date: Tue, 24 Jun 2014 22:38:49 +0300
Message-Id: <1403638731-2381-1-git-send-email-egrumbach@gmail.com> (sfid-20140624_213903_723365_0F02A64A)
In-Reply-To: <53A9D396.1020306@gmail.com>
References: <53A9D396.1020306@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

The current sched scan channel configuration code
configures all the supported channels for scanning.

However, this can result in SYSASSERT in some cases,
when the configured channel is disabled.

Instead, configure only the channels given in the
req struct, and set the channel_count field appropriately.

While on it, change the code to use channel->hw_value
instead of recalculating the channel number.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 65 ++++++++++-----------------------
 1 file changed, 19 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 4b6c7d4..eac2b42 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -588,9 +588,7 @@ static void iwl_build_scan_cmd(struct iwl_mvm *mvm,
 			       struct iwl_scan_offload_cmd *scan,
 			       struct iwl_mvm_scan_params *params)
 {
-	scan->channel_count =
-		mvm->nvm_data->bands[IEEE80211_BAND_2GHZ].n_channels +
-		mvm->nvm_data->bands[IEEE80211_BAND_5GHZ].n_channels;
+	scan->channel_count = req->n_channels;
 	scan->quiet_time = cpu_to_le16(IWL_ACTIVE_QUIET_TIME);
 	scan->quiet_plcp_th = cpu_to_le16(IWL_PLCP_QUIET_THRESH);
 	scan->good_CRC_th = IWL_GOOD_CRC_TH_DEFAULT;
@@ -669,61 +667,37 @@ static void iwl_build_channel_cfg(struct iwl_mvm *mvm,
 				  struct cfg80211_sched_scan_request *req,
 				  struct iwl_scan_channel_cfg *channels,
 				  enum ieee80211_band band,
-				  int *head, int *tail,
+				  int *head,
 				  u32 ssid_bitmap,
 				  struct iwl_mvm_scan_params *params)
 {
-	struct ieee80211_supported_band *s_band;
-	int n_channels = req->n_channels;
-	int i, j, index = 0;
-	bool partial;
+	int i, index = 0;
 
-	/*
-	 * We have to configure all supported channels, even if we don't want to
-	 * scan on them, but we have to send channels in the order that we want
-	 * to scan. So add requested channels to head of the list and others to
-	 * the end.
-	*/
-	s_band = &mvm->nvm_data->bands[band];
-
-	for (i = 0; i < s_band->n_channels && *head <= *tail; i++) {
-		partial = false;
-		for (j = 0; j < n_channels; j++)
-			if (s_band->channels[i].center_freq ==
-						req->channels[j]->center_freq) {
-				index = *head;
-				(*head)++;
-				/*
-				 * Channels that came with the request will be
-				 * in partial scan .
-				 */
-				partial = true;
-				break;
-			}
-		if (!partial) {
-			index = *tail;
-			(*tail)--;
-		}
-		channels->channel_number[index] =
-			cpu_to_le16(ieee80211_frequency_to_channel(
-					s_band->channels[i].center_freq));
+	for (i = 0; i < req->n_channels; i++) {
+		struct ieee80211_channel *chan = req->channels[i];
+
+		if (chan->band != band)
+			continue;
+
+		index = *head;
+		(*head)++;
+
+		channels->channel_number[index] = cpu_to_le16(chan->hw_value);
 		channels->dwell_time[index][0] = params->dwell[band].active;
 		channels->dwell_time[index][1] = params->dwell[band].passive;
 
 		channels->iter_count[index] = cpu_to_le16(1);
 		channels->iter_interval[index] = 0;
 
-		if (!(s_band->channels[i].flags & IEEE80211_CHAN_NO_IR))
+		if (!(chan->flags & IEEE80211_CHAN_NO_IR))
 			channels->type[index] |=
 				cpu_to_le32(IWL_SCAN_OFFLOAD_CHANNEL_ACTIVE);
 
 		channels->type[index] |=
-				cpu_to_le32(IWL_SCAN_OFFLOAD_CHANNEL_FULL);
-		if (partial)
-			channels->type[index] |=
-				cpu_to_le32(IWL_SCAN_OFFLOAD_CHANNEL_PARTIAL);
+				cpu_to_le32(IWL_SCAN_OFFLOAD_CHANNEL_FULL |
+					    IWL_SCAN_OFFLOAD_CHANNEL_PARTIAL);
 
-		if (s_band->channels[i].flags & IEEE80211_CHAN_NO_HT40)
+		if (chan->flags & IEEE80211_CHAN_NO_HT40)
 			channels->type[index] |=
 				cpu_to_le32(IWL_SCAN_OFFLOAD_CHANNEL_NARROW);
 
@@ -740,7 +714,6 @@ int iwl_mvm_config_sched_scan(struct iwl_mvm *mvm,
 	int band_2ghz = mvm->nvm_data->bands[IEEE80211_BAND_2GHZ].n_channels;
 	int band_5ghz = mvm->nvm_data->bands[IEEE80211_BAND_5GHZ].n_channels;
 	int head = 0;
-	int tail = band_2ghz + band_5ghz - 1;
 	u32 ssid_bitmap;
 	int cmd_len;
 	int ret;
@@ -772,7 +745,7 @@ int iwl_mvm_config_sched_scan(struct iwl_mvm *mvm,
 					      &scan_cfg->scan_cmd.tx_cmd[0],
 					      scan_cfg->data);
 		iwl_build_channel_cfg(mvm, req, &scan_cfg->channel_cfg,
-				      IEEE80211_BAND_2GHZ, &head, &tail,
+				      IEEE80211_BAND_2GHZ, &head,
 				      ssid_bitmap, &params);
 	}
 	if (band_5ghz) {
@@ -782,7 +755,7 @@ int iwl_mvm_config_sched_scan(struct iwl_mvm *mvm,
 					      scan_cfg->data +
 						SCAN_OFFLOAD_PROBE_REQ_SIZE);
 		iwl_build_channel_cfg(mvm, req, &scan_cfg->channel_cfg,
-				      IEEE80211_BAND_5GHZ, &head, &tail,
+				      IEEE80211_BAND_5GHZ, &head,
 				      ssid_bitmap, &params);
 	}
 
-- 
1.8.3.2

