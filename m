Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:16356 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757853AbZFSUpd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jun 2009 16:45:33 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 4/5] iwlwifi: scan requested channels only
Date: Fri, 19 Jun 2009 13:52:44 -0700
Message-Id: <1245444765-29079-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1245444765-29079-4-git-send-email-reinette.chatre@intel.com>
References: <1245444765-29079-1-git-send-email-reinette.chatre@intel.com>
 <1245444765-29079-2-git-send-email-reinette.chatre@intel.com>
 <1245444765-29079-3-git-send-email-reinette.chatre@intel.com>
 <1245444765-29079-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

When userspace requests only certain channels to be scanned,
we currently ignore that request entirely.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 -
 drivers/net/wireless/iwlwifi/iwl-scan.c     |   31 ++++++++++++--------------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   14 ++++++------
 3 files changed, 21 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index dabf663..356d4e3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -384,7 +384,6 @@ static inline __le32 iwl_hw_set_rate_n_flags(u8 rate, u32 flags)
 void iwl_init_scan_params(struct iwl_priv *priv);
 int iwl_scan_cancel(struct iwl_priv *priv);
 int iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms);
-int iwl_scan_initiate(struct iwl_priv *priv);
 int iwl_mac_hw_scan(struct ieee80211_hw *hw, struct cfg80211_scan_request *req);
 u16 iwl_fill_probe_req(struct iwl_priv *priv, struct ieee80211_mgmt *frame,
 		       const u8 *ie, int ie_len, int left);
@@ -398,7 +397,6 @@ void iwl_bg_scan_check(struct work_struct *data);
 void iwl_bg_abort_scan(struct work_struct *work);
 void iwl_bg_scan_completed(struct work_struct *work);
 void iwl_setup_scan_deferred_work(struct iwl_priv *priv);
-int iwl_send_scan_abort(struct iwl_priv *priv);
 
 /* For faster active scanning, scan will move to the next channel if fewer than
  * PLCP_QUIET_THRESH packets are heard on this channel within
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index e26875d..00398d9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -109,7 +109,7 @@ int iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms)
 }
 EXPORT_SYMBOL(iwl_scan_cancel_timeout);
 
-int iwl_send_scan_abort(struct iwl_priv *priv)
+static int iwl_send_scan_abort(struct iwl_priv *priv)
 {
 	int ret = 0;
 	struct iwl_rx_packet *res;
@@ -150,7 +150,6 @@ int iwl_send_scan_abort(struct iwl_priv *priv)
 
 	return ret;
 }
-EXPORT_SYMBOL(iwl_send_scan_abort);
 
 /* Service response to REPLY_SCAN_CMD (0x80) */
 static void iwl_rx_reply_scan(struct iwl_priv *priv,
@@ -322,7 +321,7 @@ static int iwl_get_channels_for_scan(struct iwl_priv *priv,
 				     u8 is_active, u8 n_probes,
 				     struct iwl_scan_channel *scan_ch)
 {
-	const struct ieee80211_channel *channels = NULL;
+	struct ieee80211_channel *chan;
 	const struct ieee80211_supported_band *sband;
 	const struct iwl_channel_info *ch_info;
 	u16 passive_dwell = 0;
@@ -334,20 +333,19 @@ static int iwl_get_channels_for_scan(struct iwl_priv *priv,
 	if (!sband)
 		return 0;
 
-	channels = sband->channels;
-
 	active_dwell = iwl_get_active_dwell_time(priv, band, n_probes);
 	passive_dwell = iwl_get_passive_dwell_time(priv, band);
 
 	if (passive_dwell <= active_dwell)
 		passive_dwell = active_dwell + 1;
 
-	for (i = 0, added = 0; i < sband->n_channels; i++) {
-		if (channels[i].flags & IEEE80211_CHAN_DISABLED)
+	for (i = 0, added = 0; i < priv->scan_request->n_channels; i++) {
+		chan = priv->scan_request->channels[i];
+
+		if (chan->band != band)
 			continue;
 
-		channel =
-			ieee80211_frequency_to_channel(channels[i].center_freq);
+		channel = ieee80211_frequency_to_channel(chan->center_freq);
 		scan_ch->channel = cpu_to_le16(channel);
 
 		ch_info = iwl_get_channel_info(priv, band, channel);
@@ -358,7 +356,7 @@ static int iwl_get_channels_for_scan(struct iwl_priv *priv,
 		}
 
 		if (!is_active || is_channel_passive(ch_info) ||
-		    (channels[i].flags & IEEE80211_CHAN_PASSIVE_SCAN))
+		    (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN))
 			scan_ch->type = SCAN_CHANNEL_TYPE_PASSIVE;
 		else
 			scan_ch->type = SCAN_CHANNEL_TYPE_ACTIVE;
@@ -405,7 +403,7 @@ void iwl_init_scan_params(struct iwl_priv *priv)
 		priv->scan_tx_ant[IEEE80211_BAND_2GHZ] = ant_idx;
 }
 
-int iwl_scan_initiate(struct iwl_priv *priv)
+static int iwl_scan_initiate(struct iwl_priv *priv)
 {
 	if (!iwl_is_ready_rf(priv)) {
 		IWL_DEBUG_SCAN(priv, "Aborting scan due to not ready.\n");
@@ -423,10 +421,6 @@ int iwl_scan_initiate(struct iwl_priv *priv)
 	}
 
 	IWL_DEBUG_INFO(priv, "Starting scan...\n");
-	if (priv->cfg->sku & IWL_SKU_G)
-		priv->scan_bands |= BIT(IEEE80211_BAND_2GHZ);
-	if (priv->cfg->sku & IWL_SKU_A)
-		priv->scan_bands |= BIT(IEEE80211_BAND_5GHZ);
 	set_bit(STATUS_SCANNING, &priv->status);
 	priv->scan_start = jiffies;
 	priv->scan_pass_start = priv->scan_start;
@@ -435,7 +429,6 @@ int iwl_scan_initiate(struct iwl_priv *priv)
 
 	return 0;
 }
-EXPORT_SYMBOL(iwl_scan_initiate);
 
 #define IWL_DELAY_NEXT_SCAN (HZ*2)
 
@@ -444,7 +437,7 @@ int iwl_mac_hw_scan(struct ieee80211_hw *hw,
 {
 	unsigned long flags;
 	struct iwl_priv *priv = hw->priv;
-	int ret;
+	int ret, i;
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 
@@ -478,6 +471,10 @@ int iwl_mac_hw_scan(struct ieee80211_hw *hw,
 		goto out_unlock;
 	}
 
+	priv->scan_bands = 0;
+	for (i = 0; i < req->n_channels; i++)
+		priv->scan_bands |= BIT(req->channels[i]->band);
+
 	priv->scan_request = req;
 
 	ret = iwl_scan_initiate(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index cb9bd4c..016567f 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1844,7 +1844,7 @@ static int iwl3945_get_channels_for_scan(struct iwl_priv *priv,
 				     u8 is_active, u8 n_probes,
 				     struct iwl3945_scan_channel *scan_ch)
 {
-	const struct ieee80211_channel *channels = NULL;
+	struct ieee80211_channel *chan;
 	const struct ieee80211_supported_band *sband;
 	const struct iwl_channel_info *ch_info;
 	u16 passive_dwell = 0;
@@ -1855,19 +1855,19 @@ static int iwl3945_get_channels_for_scan(struct iwl_priv *priv,
 	if (!sband)
 		return 0;
 
-	channels = sband->channels;
-
 	active_dwell = iwl_get_active_dwell_time(priv, band, n_probes);
 	passive_dwell = iwl_get_passive_dwell_time(priv, band);
 
 	if (passive_dwell <= active_dwell)
 		passive_dwell = active_dwell + 1;
 
-	for (i = 0, added = 0; i < sband->n_channels; i++) {
-		if (channels[i].flags & IEEE80211_CHAN_DISABLED)
+	for (i = 0, added = 0; i < priv->scan_request->n_channels; i++) {
+		chan = priv->scan_request->channels[i];
+
+		if (chan->band != band)
 			continue;
 
-		scan_ch->channel = channels[i].hw_value;
+		scan_ch->channel = chan->hw_value;
 
 		ch_info = iwl_get_channel_info(priv, band, scan_ch->channel);
 		if (!is_channel_valid(ch_info)) {
@@ -1882,7 +1882,7 @@ static int iwl3945_get_channels_for_scan(struct iwl_priv *priv,
 		 *  and use long active_dwell time.
 		 */
 		if (!is_active || is_channel_passive(ch_info) ||
-		    (channels[i].flags & IEEE80211_CHAN_PASSIVE_SCAN)) {
+		    (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN)) {
 			scan_ch->type = 0;	/* passive */
 			if (IWL_UCODE_API(priv->ucode_ver) == 1)
 				scan_ch->active_dwell = cpu_to_le16(passive_dwell - 1);
-- 
1.5.6.3

