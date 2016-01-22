Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34270 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726AbcAVA4d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 19:56:33 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH] ath9k: do not limit the number of DFS channel interfaces to 1
Date: Fri, 22 Jan 2016 01:56:30 +0100
Message-Id: <1453424190-64499-1-git-send-email-nbd@openwrt.org> (sfid-20160122_015636_811889_EF2A1C81)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I think this limit was added when CSA with multiple interfaces wasn't
working yet. It should no longer be necessary

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/init.c | 25 +++++--------------------
 1 file changed, 5 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index ab7a1ac..d4e0ac9 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -751,14 +751,6 @@ static const struct ieee80211_iface_combination if_comb_multi[] = {
 
 #endif /* CONFIG_ATH9K_CHANNEL_CONTEXT */
 
-static const struct ieee80211_iface_limit if_dfs_limits[] = {
-	{ .max = 1,	.types = BIT(NL80211_IFTYPE_AP) |
-#ifdef CONFIG_MAC80211_MESH
-				 BIT(NL80211_IFTYPE_MESH_POINT) |
-#endif
-				 BIT(NL80211_IFTYPE_ADHOC) },
-};
-
 static const struct ieee80211_iface_combination if_comb[] = {
 	{
 		.limits = if_limits,
@@ -766,6 +758,11 @@ static const struct ieee80211_iface_combination if_comb[] = {
 		.max_interfaces = 2048,
 		.num_different_channels = 1,
 		.beacon_int_infra_match = true,
+#ifdef CONFIG_ATH9K_DFS_CERTIFIED
+		.radar_detect_widths =	BIT(NL80211_CHAN_WIDTH_20_NOHT) |
+					BIT(NL80211_CHAN_WIDTH_20) |
+					BIT(NL80211_CHAN_WIDTH_40),
+#endif
 	},
 	{
 		.limits = wds_limits,
@@ -774,18 +771,6 @@ static const struct ieee80211_iface_combination if_comb[] = {
 		.num_different_channels = 1,
 		.beacon_int_infra_match = true,
 	},
-#ifdef CONFIG_ATH9K_DFS_CERTIFIED
-	{
-		.limits = if_dfs_limits,
-		.n_limits = ARRAY_SIZE(if_dfs_limits),
-		.max_interfaces = 1,
-		.num_different_channels = 1,
-		.beacon_int_infra_match = true,
-		.radar_detect_widths =	BIT(NL80211_CHAN_WIDTH_20_NOHT) |
-					BIT(NL80211_CHAN_WIDTH_20) |
-					BIT(NL80211_CHAN_WIDTH_40),
-	}
-#endif
 };
 
 #ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
-- 
2.2.2

