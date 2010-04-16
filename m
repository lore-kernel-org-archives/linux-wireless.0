Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50641 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932573Ab0DPVwl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 17:52:41 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 01/21] iwlwifi: set correct single/dual stream mask
Date: Fri, 16 Apr 2010 14:52:18 -0700
Message-Id: <1271454758-14351-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1271454758-14351-1-git-send-email-reinette.chatre@intel.com>
References: <1271454758-14351-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Even the initial single/dual stream values will be overridden later when
issue link quality command; but still make sense not to use hard-code
value during initialization. Single/Dual stream mask are used to indicate the
best antenna for SISO/MIMO; different NIC has different tx antenna
configuration; so the parameter need to based on the valid tx antenna.

1x2 device: single tx antenna available, only SISO is valid
configuration, but still need to set up MIMO configuration, so set it up
with antenna A & B as default.
2x2 device: two tx antenna available, dual_stream will use both valid
antenna.

3x3 device: three tx antenna available, skip the first antenna and
choice the second and third antenna for dual_stream.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   13 +++++++++++--
 drivers/net/wireless/iwlwifi/iwl-sta.c    |   12 +++++++++++-
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 3c1cd41..5bc406c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2557,8 +2557,17 @@ void iwl_rs_rate_init(struct iwl_priv *priv, struct ieee80211_sta *sta, u8 sta_i
 		     lq_sta->active_mimo3_rate);
 
 	/* These values will be overridden later */
-	lq_sta->lq.general_params.single_stream_ant_msk = ANT_A;
-	lq_sta->lq.general_params.dual_stream_ant_msk = ANT_AB;
+	lq_sta->lq.general_params.single_stream_ant_msk =
+		first_antenna(priv->hw_params.valid_tx_ant);
+	lq_sta->lq.general_params.dual_stream_ant_msk =
+		priv->hw_params.valid_tx_ant &
+		~first_antenna(priv->hw_params.valid_tx_ant);
+	if (!lq_sta->lq.general_params.dual_stream_ant_msk) {
+		lq_sta->lq.general_params.dual_stream_ant_msk = ANT_AB;
+	} else if (num_of_ant(priv->hw_params.valid_tx_ant) == 2) {
+		lq_sta->lq.general_params.dual_stream_ant_msk =
+			priv->hw_params.valid_tx_ant;
+	}
 
 	/* as default allow aggregation for all tids */
 	lq_sta->tx_agg_tid_en = IWL_AGG_ALL_TID;
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index d86ecd2..09d9c4d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -451,7 +451,17 @@ static void iwl_sta_init_lq(struct iwl_priv *priv, const u8 *addr, bool is_ap)
 
 	link_cmd.general_params.single_stream_ant_msk =
 				first_antenna(priv->hw_params.valid_tx_ant);
-	link_cmd.general_params.dual_stream_ant_msk = 3;
+
+	link_cmd.general_params.dual_stream_ant_msk =
+		priv->hw_params.valid_tx_ant &
+		~first_antenna(priv->hw_params.valid_tx_ant);
+	if (!link_cmd.general_params.dual_stream_ant_msk) {
+		link_cmd.general_params.dual_stream_ant_msk = ANT_AB;
+	} else if (num_of_ant(priv->hw_params.valid_tx_ant) == 2) {
+		link_cmd.general_params.dual_stream_ant_msk =
+			priv->hw_params.valid_tx_ant;
+	}
+
 	link_cmd.agg_params.agg_dis_start_th = LINK_QUAL_AGG_DISABLE_START_DEF;
 	link_cmd.agg_params.agg_time_limit =
 		cpu_to_le16(LINK_QUAL_AGG_TIME_LIMIT_DEF);
-- 
1.6.3.3

