Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48607 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585AbaAGXPV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 18:15:21 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 02/12] mac80211_hwsim: prepare for different channel support
Date: Wed,  8 Jan 2014 00:15:07 +0100
Message-Id: <1389136517-21216-3-git-send-email-johannes@sipsolutions.net> (sfid-20140108_001526_459401_A81BA5EB)
In-Reply-To: <1389136517-21216-1-git-send-email-johannes@sipsolutions.net>
References: <1389136517-21216-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Prepare the code to support, in theory, different devices
with a different number of channels supported. Right now
this doesn't really change anything, but will allow for
dynamic device registration in the future.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 67 +++++++++++++++++++----------------
 1 file changed, 36 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 03d7b1d..4e94224 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -332,8 +332,10 @@ struct mac80211_hwsim_data {
 	struct ieee80211_channel channels_2ghz[ARRAY_SIZE(hwsim_channels_2ghz)];
 	struct ieee80211_channel channels_5ghz[ARRAY_SIZE(hwsim_channels_5ghz)];
 	struct ieee80211_rate rates[ARRAY_SIZE(hwsim_rates)];
+	struct ieee80211_iface_combination if_combination;
 
 	struct mac_address addresses[2];
+	int channels;
 
 	struct ieee80211_channel *tmp_chan;
 	struct delayed_work roc_done;
@@ -878,7 +880,7 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw,
 		return;
 	}
 
-	if (channels == 1) {
+	if (data->channels == 1) {
 		channel = data->channel;
 	} else if (txi->hw_queue == 4) {
 		channel = data->tmp_chan;
@@ -1141,7 +1143,7 @@ static int mac80211_hwsim_config(struct ieee80211_hw *hw, u32 changed)
 
 	data->channel = conf->chandef.chan;
 
-	WARN_ON(data->channel && channels > 1);
+	WARN_ON(data->channel && data->channels > 1);
 
 	data->power_level = conf->power_level;
 	if (!data->started || !data->beacon_int)
@@ -1700,8 +1702,7 @@ static void mac80211_hwsim_unassign_vif_chanctx(struct ieee80211_hw *hw,
 	hwsim_check_chanctx_magic(ctx);
 }
 
-static struct ieee80211_ops mac80211_hwsim_ops =
-{
+static const struct ieee80211_ops mac80211_hwsim_ops = {
 	.tx = mac80211_hwsim_tx,
 	.start = mac80211_hwsim_start,
 	.stop = mac80211_hwsim_stop,
@@ -1726,6 +1727,7 @@ static struct ieee80211_ops mac80211_hwsim_ops =
 	.set_tsf = mac80211_hwsim_set_tsf,
 };
 
+static struct ieee80211_ops mac80211_hwsim_mchan_ops;
 
 static void mac80211_hwsim_free(void)
 {
@@ -2206,7 +2208,7 @@ static const struct ieee80211_iface_limit hwsim_if_dfs_limits[] = {
 	{ .max = 8, .types = BIT(NL80211_IFTYPE_AP) },
 };
 
-static struct ieee80211_iface_combination hwsim_if_comb[] = {
+static const struct ieee80211_iface_combination hwsim_if_comb[] = {
 	{
 		.limits = hwsim_if_limits,
 		.n_limits = ARRAY_SIZE(hwsim_if_limits),
@@ -2233,6 +2235,7 @@ static int __init init_mac80211_hwsim(void)
 	struct mac80211_hwsim_data *data;
 	struct ieee80211_hw *hw;
 	enum ieee80211_band band;
+	const struct ieee80211_ops *ops;
 
 	if (radios < 1 || radios > 100)
 		return -EINVAL;
@@ -2240,28 +2243,20 @@ static int __init init_mac80211_hwsim(void)
 	if (channels < 1)
 		return -EINVAL;
 
-	if (channels > 1) {
-		hwsim_if_comb[0].num_different_channels = channels;
-		mac80211_hwsim_ops.hw_scan = mac80211_hwsim_hw_scan;
-		mac80211_hwsim_ops.cancel_hw_scan =
-			mac80211_hwsim_cancel_hw_scan;
-		mac80211_hwsim_ops.sw_scan_start = NULL;
-		mac80211_hwsim_ops.sw_scan_complete = NULL;
-		mac80211_hwsim_ops.remain_on_channel =
-			mac80211_hwsim_roc;
-		mac80211_hwsim_ops.cancel_remain_on_channel =
-			mac80211_hwsim_croc;
-		mac80211_hwsim_ops.add_chanctx =
-			mac80211_hwsim_add_chanctx;
-		mac80211_hwsim_ops.remove_chanctx =
-			mac80211_hwsim_remove_chanctx;
-		mac80211_hwsim_ops.change_chanctx =
-			mac80211_hwsim_change_chanctx;
-		mac80211_hwsim_ops.assign_vif_chanctx =
-			mac80211_hwsim_assign_vif_chanctx;
-		mac80211_hwsim_ops.unassign_vif_chanctx =
-			mac80211_hwsim_unassign_vif_chanctx;
-	}
+	mac80211_hwsim_mchan_ops = mac80211_hwsim_ops;
+	mac80211_hwsim_mchan_ops.hw_scan = mac80211_hwsim_hw_scan;
+	mac80211_hwsim_mchan_ops.cancel_hw_scan = mac80211_hwsim_cancel_hw_scan;
+	mac80211_hwsim_mchan_ops.sw_scan_start = NULL;
+	mac80211_hwsim_mchan_ops.sw_scan_complete = NULL;
+	mac80211_hwsim_mchan_ops.remain_on_channel = mac80211_hwsim_roc;
+	mac80211_hwsim_mchan_ops.cancel_remain_on_channel = mac80211_hwsim_croc;
+	mac80211_hwsim_mchan_ops.add_chanctx = mac80211_hwsim_add_chanctx;
+	mac80211_hwsim_mchan_ops.remove_chanctx = mac80211_hwsim_remove_chanctx;
+	mac80211_hwsim_mchan_ops.change_chanctx = mac80211_hwsim_change_chanctx;
+	mac80211_hwsim_mchan_ops.assign_vif_chanctx =
+		mac80211_hwsim_assign_vif_chanctx;
+	mac80211_hwsim_mchan_ops.unassign_vif_chanctx =
+		mac80211_hwsim_unassign_vif_chanctx;
 
 	spin_lock_init(&hwsim_radio_lock);
 	INIT_LIST_HEAD(&hwsim_radios);
@@ -2282,7 +2277,10 @@ static int __init init_mac80211_hwsim(void)
 	for (i = 0; i < radios; i++) {
 		printk(KERN_DEBUG "mac80211_hwsim: Initializing radio %d\n",
 		       i);
-		hw = ieee80211_alloc_hw(sizeof(*data), &mac80211_hwsim_ops);
+		ops = &mac80211_hwsim_ops;
+		if (channels > 1)
+			ops = &mac80211_hwsim_mchan_ops;
+		hw = ieee80211_alloc_hw(sizeof(*data), ops);
 		if (!hw) {
 			printk(KERN_DEBUG "mac80211_hwsim: ieee80211_alloc_hw "
 			       "failed\n");
@@ -2321,15 +2319,22 @@ static int __init init_mac80211_hwsim(void)
 		hw->wiphy->n_addresses = 2;
 		hw->wiphy->addresses = data->addresses;
 
-		hw->wiphy->iface_combinations = hwsim_if_comb;
-		hw->wiphy->n_iface_combinations = ARRAY_SIZE(hwsim_if_comb);
+		data->channels = channels;
 
-		if (channels > 1) {
+		if (data->channels > 1) {
 			hw->wiphy->max_scan_ssids = 255;
 			hw->wiphy->max_scan_ie_len = IEEE80211_MAX_DATA_LEN;
 			hw->wiphy->max_remain_on_channel_duration = 1000;
 			/* For channels > 1 DFS is not allowed */
 			hw->wiphy->n_iface_combinations = 1;
+			hw->wiphy->iface_combinations = &data->if_combination;
+			data->if_combination = hwsim_if_comb[0];
+			data->if_combination.num_different_channels =
+				data->channels;
+		} else {
+			hw->wiphy->iface_combinations = hwsim_if_comb;
+			hw->wiphy->n_iface_combinations =
+				ARRAY_SIZE(hwsim_if_comb);
 		}
 
 		INIT_DELAYED_WORK(&data->roc_done, hw_roc_done);
-- 
1.8.5.1

