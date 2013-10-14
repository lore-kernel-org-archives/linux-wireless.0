Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:49879 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756362Ab3JNRvb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 13:51:31 -0400
Received: by mail-ea0-f176.google.com with SMTP id q16so3486448ead.7
        for <linux-wireless@vger.kernel.org>; Mon, 14 Oct 2013 10:51:30 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] mac80211_hwsim: Add iface comb for DFS
Date: Mon, 14 Oct 2013 19:51:18 +0200
Message-Id: <1381773079-2678-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131014_195135_973970_61B866A6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add iface combination that allow DFS support.
Add also debugfs dfs_simulate_radar file that
can be used to simulate radar event.
This could be usefull for mac80211/cfg80211/
regulatory/hostap code testing without real HW.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/mac80211_hwsim.c |   51 +++++++++++++++++++++++++++------
 1 file changed, 43 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 2cd3f54..1a4eca0 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -370,6 +370,8 @@ struct mac80211_hwsim_data {
 	s64 bcn_delta;
 	/* absolute beacon transmission time. Used to cover up "tx" delay. */
 	u64 abs_bcn_ts;
+
+	struct dentry *debugfs_radar;
 };
 
 
@@ -1714,6 +1716,7 @@ static void mac80211_hwsim_free(void)
 
 	list_for_each_entry_safe(data, tmpdata, &tmplist, list) {
 		debugfs_remove(data->debugfs_group);
+		debugfs_remove(data->debugfs_radar);
 		debugfs_remove(data->debugfs_ps);
 		debugfs_remove(data->debugfs);
 		ieee80211_unregister_hw(data->hw);
@@ -1872,6 +1875,17 @@ static int hwsim_fops_ps_write(void *dat, u64 val)
 DEFINE_SIMPLE_ATTRIBUTE(hwsim_fops_ps, hwsim_fops_ps_read, hwsim_fops_ps_write,
 			"%llu\n");
 
+static int hwsim_write_simulate_radar(void *dat, u64 val)
+{
+	struct mac80211_hwsim_data *data = dat;
+
+	ieee80211_radar_detected(data->hw);
+
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(hwsim_simulate_radar, NULL,
+			hwsim_write_simulate_radar, "%llu\n");
 
 static int hwsim_fops_group_read(void *dat, u64 *val)
 {
@@ -2173,11 +2187,28 @@ static const struct ieee80211_iface_limit hwsim_if_limits[] = {
 	{ .max = 1, .types = BIT(NL80211_IFTYPE_P2P_DEVICE) },
 };
 
-static struct ieee80211_iface_combination hwsim_if_comb = {
-	.limits = hwsim_if_limits,
-	.n_limits = ARRAY_SIZE(hwsim_if_limits),
-	.max_interfaces = 2048,
-	.num_different_channels = 1,
+static const struct ieee80211_iface_limit hwsim_if_dfs_limits[] = {
+	{ .max = 8, .types = BIT(NL80211_IFTYPE_AP) },
+};
+
+static struct ieee80211_iface_combination hwsim_if_comb[] = {
+	{
+		.limits = hwsim_if_limits,
+		.n_limits = ARRAY_SIZE(hwsim_if_limits),
+		.max_interfaces = 2048,
+		.num_different_channels = 1,
+	},
+	{
+		.limits = hwsim_if_dfs_limits,
+		.n_limits = ARRAY_SIZE(hwsim_if_dfs_limits),
+		.max_interfaces = 8,
+		.num_different_channels = 1,
+		.radar_detect_widths = BIT(NL80211_CHAN_WIDTH_20_NOHT) |
+				       BIT(NL80211_CHAN_WIDTH_20) |
+				       BIT(NL80211_CHAN_WIDTH_40) |
+				       BIT(NL80211_CHAN_WIDTH_80) |
+				       BIT(NL80211_CHAN_WIDTH_160),
+	}
 };
 
 static int __init init_mac80211_hwsim(void)
@@ -2195,7 +2226,7 @@ static int __init init_mac80211_hwsim(void)
 		return -EINVAL;
 
 	if (channels > 1) {
-		hwsim_if_comb.num_different_channels = channels;
+		hwsim_if_comb[0].num_different_channels = channels;
 		mac80211_hwsim_ops.hw_scan = mac80211_hwsim_hw_scan;
 		mac80211_hwsim_ops.cancel_hw_scan =
 			mac80211_hwsim_cancel_hw_scan;
@@ -2275,8 +2306,8 @@ static int __init init_mac80211_hwsim(void)
 		hw->wiphy->n_addresses = 2;
 		hw->wiphy->addresses = data->addresses;
 
-		hw->wiphy->iface_combinations = &hwsim_if_comb;
-		hw->wiphy->n_iface_combinations = 1;
+		hw->wiphy->iface_combinations = hwsim_if_comb;
+		hw->wiphy->n_iface_combinations = ARRAY_SIZE(hwsim_if_comb);
 
 		if (channels > 1) {
 			hw->wiphy->max_scan_ssids = 255;
@@ -2519,6 +2550,10 @@ static int __init init_mac80211_hwsim(void)
 		data->debugfs_group = debugfs_create_file("group", 0666,
 							data->debugfs, data,
 							&hwsim_fops_group);
+		data->debugfs_radar = debugfs_create_file("dfs_simulate_radar",
+							 0222, data->debugfs,
+							 data,
+							 &hwsim_simulate_radar);
 
 		tasklet_hrtimer_init(&data->beacon_timer,
 				     mac80211_hwsim_beacon,
-- 
1.7.9.5

