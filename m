Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38791 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757983AbXHHHhN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 03:37:13 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 03/28] iwlwifi: Endianity fix for 4965 rate scaling
Date: Wed,  8 Aug 2007 15:33:20 +0800
Message-Id: <11865584342308-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1186558432932-git-send-email-yi.zhu@intel.com>
References: <11865584251026-git-send-email-yi.zhu@intel.com>
 <11865584292234-git-send-email-yi.zhu@intel.com>
 <1186558432932-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch fixes endianity issues in 4965 rate scaling algorithm.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-4965-hw.h  |    4 ++-
 drivers/net/wireless/iwl-4965-rs.c  |   54 ++++++++++++++++++++++-------------
 drivers/net/wireless/iwl-4965.c     |   18 ++++++------
 drivers/net/wireless/iwl-commands.h |   11 -------
 4 files changed, 46 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/iwl-4965-hw.h b/drivers/net/wireless/iwl-4965-hw.h
index d7b69f5..fc9f506 100644
--- a/drivers/net/wireless/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwl-4965-hw.h
@@ -314,7 +314,9 @@ struct iwl_link_quality_cmd {
 	__le16 control;
 	struct iwl_link_qual_general_params general_params;
 	struct iwl_link_qual_agg_params agg_params;
-	struct iwl_rate rate_scale_table[LINK_QUAL_MAX_RETRY_NUM];
+	struct {
+		__le32 rate_n_flags;
+	} rs_table[LINK_QUAL_MAX_RETRY_NUM];
 	__le32 reserved2;
 } __attribute__ ((packed));
 
diff --git a/drivers/net/wireless/iwl-4965-rs.c b/drivers/net/wireless/iwl-4965-rs.c
index 07fe911..3fab3c9 100644
--- a/drivers/net/wireless/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwl-4965-rs.c
@@ -69,6 +69,17 @@ static u8 rs_ht_to_legacy[] = {
 	IWL_RATE_48M_INDEX, IWL_RATE_54M_INDEX
 };
 
+struct iwl_rate {
+	union {
+		struct {
+			u8 rate;
+			u8 flags;
+			u16 ext_flags;
+		} s;
+		u32 rate_n_flags;
+	};
+} __attribute__ ((packed));
+
 struct iwl_rate_scale_data {
 	u64 data;
 	s32 success_counter;
@@ -205,7 +216,7 @@ static int rs_send_lq_cmd(struct iwl_priv *priv,
 #ifdef CONFIG_IWLWIFI_DEBUG
 	for (i = 0; i < LINK_QUAL_MAX_RETRY_NUM; i++)
 		IWL_DEBUG_RATE("lq index %d 0x%X\n",
-			       i, lq->rate_scale_table[i].rate_n_flags);
+			       i, lq->rs_table[i].rate_n_flags);
 #endif
 
 	if (flags & CMD_ASYNC)
@@ -340,8 +351,8 @@ int static rs_mcs_from_tbl(struct iwl_rate *mcs_rate,
 	return rc;
 }
 
-static int rs_get_tbl_info_from_mcs(struct iwl_rate *mcs_rate, int phymode,
-				    struct iwl_scale_tbl_info *tbl,
+static int rs_get_tbl_info_from_mcs(const struct iwl_rate *mcs_rate,
+				    int phymode, struct iwl_scale_tbl_info *tbl,
 				    int *rate_idx)
 {
 	int index;
@@ -665,17 +676,17 @@ static void rs_tx_status(void *priv_rate,
 	}
 
 	if (retries &&
-	    (tx_mcs.rate_n_flags != table->rate_scale_table[0].rate_n_flags)) {
+	    (tx_mcs.rate_n_flags != table->rs_table[0].rate_n_flags)) {
 		IWL_DEBUG_RATE("initial rate does not match 0x%x 0x%x\n",
 				tx_mcs.rate_n_flags,
-				table->rate_scale_table[0].rate_n_flags);
+				table->rs_table[0].rate_n_flags);
 		sta_info_put(sta);
 		return;
 	}
 
 	while (retries) {
 		tx_mcs.rate_n_flags =
-		    table->rate_scale_table[index].rate_n_flags;
+		    le32_to_cpu(table->rs_table[index].rate_n_flags);
 		rs_get_tbl_info_from_mcs(&tx_mcs, priv->phymode,
 					  &tbl_type, &rs_index);
 
@@ -708,7 +719,7 @@ static void rs_tx_status(void *priv_rate,
 		tx_mcs.rate_n_flags = tx_resp->control.tx_rate;
 	else
 		tx_mcs.rate_n_flags =
-			table->rate_scale_table[index].rate_n_flags;
+			le32_to_cpu(table->rs_table[index].rate_n_flags);
 
 	rs_get_tbl_info_from_mcs(&tx_mcs, priv->phymode,
 				  &tbl_type, &rs_index);
@@ -1572,7 +1583,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
  lq_update:
 	if (update_lq) {
 		rs_mcs_from_tbl(&mcs_rate, tbl, index, is_green);
-		rs_fill_link_cmd(lq_data, &mcs_rate, &(lq_data->lq), sta);
+		rs_fill_link_cmd(lq_data, &mcs_rate, &lq_data->lq, sta);
 
 		if (!rs_send_lq_cmd(priv, &lq_data->lq, CMD_ASYNC))
 			lq_data->commit_lq = 0;
@@ -1773,7 +1784,7 @@ static struct ieee80211_rate *rs_get_rate(void *priv_rate,
 		}
 		if ((sta_id != IWL_INVALID_STATION)) {
 			lq->lq.sta_id = sta_id;
-			lq->lq.rate_scale_table[0].rate_n_flags = 0;
+			lq->lq.rs_table[0].rate_n_flags = 0;
 			lq->ibss_sta_added = 1;
 			lq->commit_lq = 1;
 			rs_initialize_lq(priv, sta);
@@ -1858,7 +1869,7 @@ static void rs_rate_init(void *priv_rate, void *priv_sta,
 		}
 		if ((sta_id != IWL_INVALID_STATION)) {
 			crl->lq.sta_id = sta_id;
-			crl->lq.rate_scale_table[0].rate_n_flags = 0;
+			crl->lq.rs_table[0].rate_n_flags = 0;
 		}
 		priv->lq_mngr.lq_ready = 1;
 	}
@@ -1912,6 +1923,7 @@ static int rs_fill_link_cmd(struct iwl_rate_scale_priv *lq_data,
 	u8 use_ht_possible = 1;
 	u8 repeat_cur_rate = 0;
 	struct iwl_rate new_rate;
+	struct iwl_rate tbl_rate;
 	struct iwl_scale_tbl_info tbl_type = { 0 };
 
 	rs_get_tbl_info_from_mcs(tx_mcs, lq_data->phymode,
@@ -1923,7 +1935,8 @@ static int rs_fill_link_cmd(struct iwl_rate_scale_priv *lq_data,
 	} else
 		repeat_cur_rate = IWL_HT_NUMBER_TRY;
 
-	lq_cmd->rate_scale_table[index].rate_n_flags = tx_mcs->rate_n_flags;
+	lq_cmd->rs_table[index].rate_n_flags =
+			cpu_to_le32(tx_mcs->rate_n_flags);
 	lq_cmd->general_params.mimo_delimiter =
 			is_mimo(tbl_type.lq_type) ? 1 : 0;
 	new_rate.rate_n_flags = tx_mcs->rate_n_flags;
@@ -1947,13 +1960,14 @@ static int rs_fill_link_cmd(struct iwl_rate_scale_priv *lq_data,
 					ant_toggle_count = 1;
 				}
 			}
-			lq_cmd->rate_scale_table[index].rate_n_flags =
-				    new_rate.rate_n_flags;
+			lq_cmd->rs_table[index].rate_n_flags =
+					cpu_to_le32(new_rate.rate_n_flags);
 			repeat_cur_rate--;
 			index++;
 		}
-		rs_get_tbl_info_from_mcs(&lq_cmd->rate_scale_table[index - 1],
-					 lq_data->phymode, &tbl_type,
+		tbl_rate.rate_n_flags =
+			le32_to_cpu(lq_cmd->rs_table[index - 1].rate_n_flags);
+		rs_get_tbl_info_from_mcs(&tbl_rate, lq_data->phymode, &tbl_type,
 					 &rate_idx);
 		if (is_mimo(tbl_type.lq_type))
 			lq_cmd->general_params.mimo_delimiter = index;
@@ -1974,19 +1988,19 @@ static int rs_fill_link_cmd(struct iwl_rate_scale_priv *lq_data,
 
 		use_ht_possible = 0;
 
-		lq_cmd->rate_scale_table[index].rate_n_flags =
-				new_rate.rate_n_flags;
-		/* lq_cmd->rate_scale_table[index].rate_n_flags = 0x800d; */
+		lq_cmd->rs_table[index].rate_n_flags =
+				cpu_to_le32(new_rate.rate_n_flags);
+		/* lq_cmd->rs_table[index].rate_n_flags = 0x800d; */
 
 		index++;
 		repeat_cur_rate--;
 	}
 
-	/* lq_cmd->rate_scale_table[0].rate_n_flags = 0x800d; */
+	/* lq_cmd->rs_table[0].rate_n_flags = 0x800d; */
 
 	lq_cmd->general_params.dual_stream_ant_msk = 3;
 	lq_cmd->agg_params.agg_dis_start_th = 3;
-	lq_cmd->agg_params.agg_time_limit = 4000;
+	lq_cmd->agg_params.agg_time_limit = cpu_to_le16(4000);
 	return rc;
 }
 
diff --git a/drivers/net/wireless/iwl-4965.c b/drivers/net/wireless/iwl-4965.c
index 6b8fd73..58ea2a1 100644
--- a/drivers/net/wireless/iwl-4965.c
+++ b/drivers/net/wireless/iwl-4965.c
@@ -4382,11 +4382,10 @@ void iwl4965_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap)
 	struct iwl_link_quality_cmd link_cmd = {
 		.reserved1 = 0,
 	};
-	struct iwl_rate *table = link_cmd.rate_scale_table;
+	u16 rate_flags;
 
 	/* Set up the rate scaling to start at 54M and fallback
 	 * all the way to 1M in IEEE order and then spin on IEEE */
-	i = 0;
 	if (is_ap)
 		r = IWL_RATE_54M_INDEX;
 	else if ((priv->phymode == MODE_IEEE80211A) ||
@@ -4395,21 +4394,22 @@ void iwl4965_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap)
 	else
 		r = IWL_RATE_1M_INDEX;
 
-	while (i < LINK_QUAL_MAX_RETRY_NUM) {
+	for (i = 0; i < LINK_QUAL_MAX_RETRY_NUM; i++) {
+		rate_flags = 0;
 		if (r >= IWL_FIRST_CCK_RATE && r <= IWL_LAST_CCK_RATE)
-			table[i].rate_n_flags |= RATE_MCS_CCK_MSK;
+			rate_flags |= RATE_MCS_CCK_MSK;
 
-		table[i].s.rate = iwl_rates[r].plcp;
-		table[i].rate_n_flags |= RATE_MCS_ANT_B_MSK;
-		table[i].rate_n_flags &= ~RATE_MCS_ANT_A_MSK;
+		rate_flags |= RATE_MCS_ANT_B_MSK;
+		rate_flags &= ~RATE_MCS_ANT_A_MSK;
+		link_cmd.rs_table[i].rate_n_flags =
+			iwl_hw_set_rate_n_flags(iwl_rates[r].plcp, rate_flags);
 		r = iwl_get_prev_ieee_rate(r);
-		i++;
 	}
 
 	link_cmd.general_params.single_stream_ant_msk = 2;
 	link_cmd.general_params.dual_stream_ant_msk = 3;
 	link_cmd.agg_params.agg_dis_start_th = 3;
-	link_cmd.agg_params.agg_time_limit = 4000;
+	link_cmd.agg_params.agg_time_limit = cpu_to_le16(4000);
 
 	/* Update the rate scaling for control frame Tx to AP */
 	link_cmd.sta_id = is_ap ? IWL_AP_ID : IWL_BROADCAST_ID;
diff --git a/drivers/net/wireless/iwl-commands.h b/drivers/net/wireless/iwl-commands.h
index 1942c8c..2327ec3 100644
--- a/drivers/net/wireless/iwl-commands.h
+++ b/drivers/net/wireless/iwl-commands.h
@@ -214,17 +214,6 @@ struct iwl_rate {
 		__le16 rate_n_flags;
 	};
 } __attribute__ ((packed));
-#elif IWL == 4965
-struct iwl_rate {
-	union {
-		struct {
-			u8 rate;
-			u8 flags;
-			__le16 ext_flags;
-		} s;
-		__le32 rate_n_flags;
-	};
-} __attribute__ ((packed));
 #endif
 
 struct iwl_dram_scratch {
-- 
1.5.2
