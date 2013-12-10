Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:38957 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910Ab3LJPUo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Dec 2013 10:20:44 -0500
Received: by mail-ea0-f174.google.com with SMTP id b10so2306129eae.19
        for <linux-wireless@vger.kernel.org>; Tue, 10 Dec 2013 07:20:43 -0800 (PST)
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH 1/2] ath10k: split the if_limits and if_comb
Date: Tue, 10 Dec 2013 16:20:39 +0100
Message-Id: <1386688840-12181-1-git-send-email-bartosz.markowski@tieto.com> (sfid-20131210_162055_193854_1194E6A7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Split the interface limits and inteface combination,
to reflect the 10.X capabilites (no P2P, no STA and 8 VAP).

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |   26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index ce9ef349..35952a4 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3464,14 +3464,12 @@ static const struct ieee80211_iface_limit ath10k_if_limits[] = {
 	},
 };
 
-#ifdef CONFIG_ATH10K_DFS_CERTIFIED
-static const struct ieee80211_iface_limit ath10k_if_dfs_limits[] = {
+static const struct ieee80211_iface_limit ath10k_10x_if_limits[] = {
 	{
 	.max	= 8,
 	.types	= BIT(NL80211_IFTYPE_AP)
 	},
 };
-#endif
 
 static const struct ieee80211_iface_combination ath10k_if_comb[] = {
 	{
@@ -3481,19 +3479,22 @@ static const struct ieee80211_iface_combination ath10k_if_comb[] = {
 		.num_different_channels = 1,
 		.beacon_int_infra_match = true,
 	},
-#ifdef CONFIG_ATH10K_DFS_CERTIFIED
+};
+
+static const struct ieee80211_iface_combination ath10k_10x_if_comb[] = {
 	{
-		.limits = ath10k_if_dfs_limits,
-		.n_limits = ARRAY_SIZE(ath10k_if_dfs_limits),
+		.limits = ath10k_10x_if_limits,
+		.n_limits = ARRAY_SIZE(ath10k_10x_if_limits),
 		.max_interfaces = 8,
 		.num_different_channels = 1,
 		.beacon_int_infra_match = true,
+#ifdef CONFIG_ATH10K_DFS_CERTIFIED
 		.radar_detect_widths =	BIT(NL80211_CHAN_WIDTH_20_NOHT) |
 					BIT(NL80211_CHAN_WIDTH_20) |
 					BIT(NL80211_CHAN_WIDTH_40) |
 					BIT(NL80211_CHAN_WIDTH_80),
-	}
 #endif
+	},
 };
 
 static struct ieee80211_sta_vht_cap ath10k_create_vht_cap(struct ath10k *ar)
@@ -3717,8 +3718,15 @@ int ath10k_mac_register(struct ath10k *ar)
 	 */
 	ar->hw->queues = 4;
 
-	ar->hw->wiphy->iface_combinations = ath10k_if_comb;
-	ar->hw->wiphy->n_iface_combinations = ARRAY_SIZE(ath10k_if_comb);
+	if (!test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features)) {
+
+		ar->hw->wiphy->iface_combinations = ath10k_if_comb;
+		ar->hw->wiphy->n_iface_combinations = ARRAY_SIZE(ath10k_if_comb);
+
+	} else {
+		ar->hw->wiphy->iface_combinations = ath10k_10x_if_comb;
+		ar->hw->wiphy->n_iface_combinations = ARRAY_SIZE(ath10k_10x_if_comb);
+	}
 
 	ar->hw->netdev_features = NETIF_F_HW_CSUM;
 
-- 
1.7.10

