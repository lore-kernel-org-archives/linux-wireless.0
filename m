Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:52040 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755958AbaE2Jkc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2014 05:40:32 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH v2] ath9k: Fix interface combinations for multi-channel concurrency
Date: Thu, 29 May 2014 15:11:09 +0530
Message-ID: <1401356469-14619-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140529_114037_291002_2FE40BA9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently mac80211 does not support WDS and DFS with channel context
drivers. So advertise these features only when the driver is not
supporting channel context and modparam "use_chanctx" is introduced
for preparing channel context support in ath9k.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/init.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 1af7708..0246b99 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -61,6 +61,10 @@ static int ath9k_ps_enable;
 module_param_named(ps_enable, ath9k_ps_enable, int, 0444);
 MODULE_PARM_DESC(ps_enable, "Enable WLAN PowerSave");
 
+static int ath9k_use_chanctx;
+module_param_named(use_chanctx, ath9k_use_chanctx, int, 0444);
+MODULE_PARM_DESC(use_chanctx, "Enable channel context for concurrency");
+
 bool is_ath9k_unloaded;
 
 #ifdef CONFIG_MAC80211_LEDS
@@ -646,8 +650,7 @@ static void ath9k_init_txpower_limits(struct ath_softc *sc)
 }
 
 static const struct ieee80211_iface_limit if_limits[] = {
-	{ .max = 2048,	.types = BIT(NL80211_IFTYPE_STATION) |
-				 BIT(NL80211_IFTYPE_WDS) },
+	{ .max = 2048,	.types = BIT(NL80211_IFTYPE_STATION) },
 	{ .max = 8,	.types =
 #ifdef CONFIG_MAC80211_MESH
 				 BIT(NL80211_IFTYPE_MESH_POINT) |
@@ -657,6 +660,10 @@ static const struct ieee80211_iface_limit if_limits[] = {
 				 BIT(NL80211_IFTYPE_P2P_GO) },
 };
 
+static const struct ieee80211_iface_limit wds_limits[] = {
+	{ .max = 2048,	.types = BIT(NL80211_IFTYPE_WDS) },
+};
+
 static const struct ieee80211_iface_limit if_dfs_limits[] = {
 	{ .max = 1,	.types = BIT(NL80211_IFTYPE_AP) |
 #ifdef CONFIG_MAC80211_MESH
@@ -673,6 +680,13 @@ static const struct ieee80211_iface_combination if_comb[] = {
 		.num_different_channels = 1,
 		.beacon_int_infra_match = true,
 	},
+	{
+		.limits = wds_limits,
+		.n_limits = ARRAY_SIZE(wds_limits),
+		.max_interfaces = 2048,
+		.num_different_channels = 1,
+		.beacon_int_infra_match = true,
+	},
 #ifdef CONFIG_ATH9K_DFS_CERTIFIED
 	{
 		.limits = if_dfs_limits,
@@ -722,12 +736,15 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 			BIT(NL80211_IFTYPE_P2P_GO) |
 			BIT(NL80211_IFTYPE_P2P_CLIENT) |
 			BIT(NL80211_IFTYPE_AP) |
-			BIT(NL80211_IFTYPE_WDS) |
 			BIT(NL80211_IFTYPE_STATION) |
 			BIT(NL80211_IFTYPE_ADHOC) |
 			BIT(NL80211_IFTYPE_MESH_POINT);
 		hw->wiphy->iface_combinations = if_comb;
-		hw->wiphy->n_iface_combinations = ARRAY_SIZE(if_comb);
+		if (!ath9k_use_chanctx) {
+			hw->wiphy->n_iface_combinations = ARRAY_SIZE(if_comb);
+			hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_WDS);
+		} else
+			hw->wiphy->n_iface_combinations = 1;
 	}
 
 	hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
-- 
1.9.3

