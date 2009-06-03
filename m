Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:15916 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173AbZFCShS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 14:37:18 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5/6] iwlwifi: add value and range define for link quality command
Date: Wed,  3 Jun 2009 11:44:11 -0700
Message-Id: <1244054652-19451-6-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1244054652-19451-5-git-send-email-reinette.chatre@intel.com>
References: <1244054652-19451-1-git-send-email-reinette.chatre@intel.com>
 <1244054652-19451-2-git-send-email-reinette.chatre@intel.com>
 <1244054652-19451-3-git-send-email-reinette.chatre@intel.com>
 <1244054652-19451-4-git-send-email-reinette.chatre@intel.com>
 <1244054652-19451-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Instead of hardcoding the link quality parameters inside the functions,
adding #define in iwl-commands.h to shared by different functions.
Also include the valid range for number of link quality parameters.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c   |    7 ++++---
 drivers/net/wireless/iwlwifi/iwl-commands.h |   12 ++++++++++++
 drivers/net/wireless/iwlwifi/iwl-sta.c      |    5 +++--
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 2cdd191..ff20e50 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2787,9 +2787,10 @@ static void rs_fill_link_cmd(const struct iwl_priv *priv,
 		repeat_rate--;
 	}
 
-	lq_cmd->agg_params.agg_frame_cnt_limit = 64;
-	lq_cmd->agg_params.agg_dis_start_th = 3;
-	lq_cmd->agg_params.agg_time_limit = cpu_to_le16(4000);
+	lq_cmd->agg_params.agg_frame_cnt_limit = LINK_QUAL_AGG_FRAME_LIMIT_MAX;
+	lq_cmd->agg_params.agg_dis_start_th = LINK_QUAL_AGG_DISABLE_START_DEF;
+	lq_cmd->agg_params.agg_time_limit =
+		cpu_to_le16(LINK_QUAL_AGG_TIME_LIMIT_DEF);
 }
 
 static void *rs_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index b3229f2..c87033b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -1913,6 +1913,18 @@ struct iwl_link_qual_general_params {
 	u8 start_rate_index[LINK_QUAL_AC_NUM];
 } __attribute__ ((packed));
 
+#define LINK_QUAL_AGG_TIME_LIMIT_DEF	(4000) /* 4 milliseconds */
+#define LINK_QUAL_AGG_TIME_LIMIT_MAX	(65535)
+#define LINK_QUAL_AGG_TIME_LIMIT_MIN	(0)
+
+#define LINK_QUAL_AGG_DISABLE_START_DEF	(3)
+#define LINK_QUAL_AGG_DISABLE_START_MAX	(255)
+#define LINK_QUAL_AGG_DISABLE_START_MIN	(0)
+
+#define LINK_QUAL_AGG_FRAME_LIMIT_DEF	(31)
+#define LINK_QUAL_AGG_FRAME_LIMIT_MAX	(64)
+#define LINK_QUAL_AGG_FRAME_LIMIT_MIN	(0)
+
 /**
  * struct iwl_link_qual_agg_params
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 5ea3bc7..2addf73 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -985,8 +985,9 @@ static void iwl_sta_init_lq(struct iwl_priv *priv, const u8 *addr, bool is_ap)
 	link_cmd.general_params.single_stream_ant_msk =
 				first_antenna(priv->hw_params.valid_tx_ant);
 	link_cmd.general_params.dual_stream_ant_msk = 3;
-	link_cmd.agg_params.agg_dis_start_th = 3;
-	link_cmd.agg_params.agg_time_limit = cpu_to_le16(4000);
+	link_cmd.agg_params.agg_dis_start_th = LINK_QUAL_AGG_DISABLE_START_DEF;
+	link_cmd.agg_params.agg_time_limit =
+		cpu_to_le16(LINK_QUAL_AGG_TIME_LIMIT_DEF);
 
 	/* Update the rate scaling for control frame Tx to AP */
 	link_cmd.sta_id = is_ap ? IWL_AP_ID : priv->hw_params.bcast_sta_id;
-- 
1.5.6.3

