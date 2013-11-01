Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:58265 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab3KATg3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 15:36:29 -0400
Received: by mail-ee0-f48.google.com with SMTP id d49so2147572eek.7
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 12:36:28 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2 2/3] mac80211_hwsim: Add iface comb for DFS
Date: Fri,  1 Nov 2013 20:35:59 +0100
Message-Id: <1383334560-10672-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131101_203634_650630_CF86B553)
In-Reply-To: <1383334560-10672-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1383334560-10672-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add iface combination that will allow DFS
support. Add also debugfs dfs_simulate_radar
file that can be used to simulate radar event.
This could be useful for mac80211/cfg80211/
regulatory/hostap code testing without real HW.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/mac80211_hwsim.c |   46 +++++++++++++++++++++++++++------
 1 file changed, 38 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index cb6b98e..085d165 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1868,6 +1868,17 @@ static int hwsim_fops_ps_write(void *dat, u64 val)
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
@@ -2169,11 +2180,28 @@ static const struct ieee80211_iface_limit hwsim_if_limits[] = {
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
@@ -2191,7 +2219,7 @@ static int __init init_mac80211_hwsim(void)
 		return -EINVAL;
 
 	if (channels > 1) {
-		hwsim_if_comb.num_different_channels = channels;
+		hwsim_if_comb[0].num_different_channels = channels;
 		mac80211_hwsim_ops.hw_scan = mac80211_hwsim_hw_scan;
 		mac80211_hwsim_ops.cancel_hw_scan =
 			mac80211_hwsim_cancel_hw_scan;
@@ -2271,8 +2299,8 @@ static int __init init_mac80211_hwsim(void)
 		hw->wiphy->n_addresses = 2;
 		hw->wiphy->addresses = data->addresses;
 
-		hw->wiphy->iface_combinations = &hwsim_if_comb;
-		hw->wiphy->n_iface_combinations = 1;
+		hw->wiphy->iface_combinations = hwsim_if_comb;
+		hw->wiphy->n_iface_combinations = ARRAY_SIZE(hwsim_if_comb);
 
 		if (channels > 1) {
 			hw->wiphy->max_scan_ssids = 255;
@@ -2511,6 +2539,8 @@ static int __init init_mac80211_hwsim(void)
 				    &hwsim_fops_ps);
 		debugfs_create_file("group", 0666, data->debugfs, data,
 				    &hwsim_fops_group);
+		debugfs_create_file("dfs_simulate_radar", 0222, data->debugfs,
+				    data, &hwsim_simulate_radar);
 
 		tasklet_hrtimer_init(&data->beacon_timer,
 				     mac80211_hwsim_beacon,
-- 
1.7.9.5

