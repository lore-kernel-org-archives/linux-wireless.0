Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11826 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbaFKKut (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 06:50:49 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 28/28] ath9k: Advertise multichannel support
Date: Wed, 11 Jun 2014 16:18:16 +0530
Message-ID: <1402483696-2498-29-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140611_130457_124576_5D7EA9EB)
In-Reply-To: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/init.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 7afb405..79fdab6 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -672,6 +672,12 @@ static const struct ieee80211_iface_limit wds_limits[] = {
 	{ .max = 2048,	.types = BIT(NL80211_IFTYPE_WDS) },
 };
 
+static const struct ieee80211_iface_limit if_limits_multi[] = {
+	{ .max = 1,	.types = BIT(NL80211_IFTYPE_STATION) },
+	{ .max = 1,	.types = BIT(NL80211_IFTYPE_P2P_CLIENT) |
+				 BIT(NL80211_IFTYPE_P2P_GO) },
+};
+
 static const struct ieee80211_iface_limit if_dfs_limits[] = {
 	{ .max = 1,	.types = BIT(NL80211_IFTYPE_AP) |
 #ifdef CONFIG_MAC80211_MESH
@@ -680,6 +686,16 @@ static const struct ieee80211_iface_limit if_dfs_limits[] = {
 				 BIT(NL80211_IFTYPE_ADHOC) },
 };
 
+static const struct ieee80211_iface_combination if_comb_multi[] = {
+	{
+		.limits = if_limits_multi,
+		.n_limits = ARRAY_SIZE(if_limits_multi),
+		.max_interfaces = 2,
+		.num_different_channels = 2,
+		.beacon_int_infra_match = true,
+	},
+};
+
 static const struct ieee80211_iface_combination if_comb[] = {
 	{
 		.limits = if_limits,
@@ -748,12 +764,14 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 			BIT(NL80211_IFTYPE_STATION) |
 			BIT(NL80211_IFTYPE_ADHOC) |
 			BIT(NL80211_IFTYPE_MESH_POINT);
-		hw->wiphy->iface_combinations = if_comb;
 		if (!ath9k_use_chanctx) {
+			hw->wiphy->iface_combinations = if_comb;
 			hw->wiphy->n_iface_combinations = ARRAY_SIZE(if_comb);
 			hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_WDS);
 		} else {
-			hw->wiphy->n_iface_combinations = 1;
+			hw->wiphy->iface_combinations = if_comb_multi;
+			hw->wiphy->n_iface_combinations =
+				ARRAY_SIZE(if_comb_multi);
 			hw->wiphy->max_scan_ssids = 255;
 			hw->wiphy->max_scan_ie_len = IEEE80211_MAX_DATA_LEN;
 			hw->wiphy->max_remain_on_channel_duration = 10000;
-- 
2.0.0

