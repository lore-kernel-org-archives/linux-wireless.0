Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:45190 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571AbaICT4c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 15:56:32 -0400
Received: by mail-wg0-f52.google.com with SMTP id m15so8937447wgh.11
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 12:56:31 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/36] iwlwifi: mvm: reduce the AMPDU size in low latency mode
Date: Wed,  3 Sep 2014 22:55:50 +0300
Message-Id: <1409774184-24665-2-git-send-email-egrumbach@gmail.com> (sfid-20140903_215636_155549_AE0D95D1)
In-Reply-To: <540771E5.6080908@gmail.com>
References: <540771E5.6080908@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This allows to leave a frame in the Tx Fifo which allows
the firmware to try to enter burst mode.
The end result of this is a better latency since the
firmware utilises the TxOP better.

Also limit the AMPDU size to the limit set in the ADDBA
response. This doesn't change much since the AMPDU size
was limited by the configuration of the hardware scheduler,
but here we add a software limit by the mean of the link
quality command.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 56 ++++++++++++++++++++++++-----------
 1 file changed, 38 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index c70e959..51fa571 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -2678,6 +2678,7 @@ static void rs_build_rates_table_from_fixed(struct iwl_mvm *mvm,
 	int i;
 	int num_rates = ARRAY_SIZE(lq_cmd->rs_table);
 	__le32 ucode_rate_le32 = cpu_to_le32(ucode_rate);
+	u8 ant = (ucode_rate & RATE_MCS_ANT_ABC_MSK) >> RATE_MCS_ANT_POS;
 
 	for (i = 0; i < num_rates; i++)
 		lq_cmd->rs_table[i] = ucode_rate_le32;
@@ -2688,6 +2689,13 @@ static void rs_build_rates_table_from_fixed(struct iwl_mvm *mvm,
 		lq_cmd->mimo_delim = num_rates - 1;
 	else
 		lq_cmd->mimo_delim = 0;
+
+	lq_cmd->reduced_tpc = 0;
+
+	if (num_of_ant(ant) == 1)
+		lq_cmd->single_stream_ant_msk = ant;
+
+	lq_cmd->agg_frame_cnt_limit = LINK_QUAL_AGG_FRAME_LIMIT_DEF;
 }
 #endif /* CONFIG_MAC80211_DEBUGFS */
 
@@ -2811,31 +2819,46 @@ static void rs_fill_lq_cmd(struct iwl_mvm *mvm,
 			   const struct rs_rate *initial_rate)
 {
 	struct iwl_lq_cmd *lq_cmd = &lq_sta->lq;
-	u8 ant = initial_rate->ant;
+	struct iwl_mvm_sta *mvmsta;
+	struct iwl_mvm_vif *mvmvif;
+
+	lq_cmd->agg_disable_start_th = LINK_QUAL_AGG_DISABLE_START_DEF;
+	lq_cmd->agg_time_limit =
+		cpu_to_le16(LINK_QUAL_AGG_TIME_LIMIT_DEF);
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 	if (lq_sta->pers.dbg_fixed_rate) {
 		rs_build_rates_table_from_fixed(mvm, lq_cmd,
 						lq_sta->band,
 						lq_sta->pers.dbg_fixed_rate);
-		lq_cmd->reduced_tpc = 0;
-		ant = (lq_sta->pers.dbg_fixed_rate & RATE_MCS_ANT_ABC_MSK) >>
-			RATE_MCS_ANT_POS;
-	} else
+		return;
+	}
 #endif
-		rs_build_rates_table(mvm, lq_sta, initial_rate);
+	if (WARN_ON_ONCE(!sta || !initial_rate))
+		return;
 
-	if (num_of_ant(ant) == 1)
-		lq_cmd->single_stream_ant_msk = ant;
+	rs_build_rates_table(mvm, lq_sta, initial_rate);
 
-	lq_cmd->agg_frame_cnt_limit = LINK_QUAL_AGG_FRAME_LIMIT_DEF;
-	lq_cmd->agg_disable_start_th = LINK_QUAL_AGG_DISABLE_START_DEF;
+	if (num_of_ant(initial_rate->ant) == 1)
+		lq_cmd->single_stream_ant_msk = initial_rate->ant;
 
-	lq_cmd->agg_time_limit =
-		cpu_to_le16(LINK_QUAL_AGG_TIME_LIMIT_DEF);
+	mvmsta = iwl_mvm_sta_from_mac80211(sta);
+	mvmvif = iwl_mvm_vif_from_mac80211(mvmsta->vif);
 
-	if (sta)
-		lq_cmd->agg_time_limit =
+	if (num_of_ant(initial_rate->ant) == 1)
+		lq_cmd->single_stream_ant_msk = initial_rate->ant;
+
+	lq_cmd->agg_frame_cnt_limit = mvmsta->max_agg_bufsize;
+
+	/*
+	 * In case of low latency, tell the firwmare to leave a frame in the
+	 * Tx Fifo so that it can start a transaction in the same TxOP. This
+	 * basically allows the firmware to send bursts.
+	 */
+	if (iwl_mvm_vif_low_latency(mvmvif))
+		lq_cmd->agg_frame_cnt_limit--;
+
+	lq_cmd->agg_time_limit =
 			cpu_to_le16(iwl_mvm_coex_agg_time_limit(mvm, sta));
 }
 
@@ -2932,10 +2955,7 @@ static void rs_program_fix_rate(struct iwl_mvm *mvm,
 		       lq_sta->lq.sta_id, lq_sta->pers.dbg_fixed_rate);
 
 	if (lq_sta->pers.dbg_fixed_rate) {
-		struct rs_rate rate;
-		rs_rate_from_ucode_rate(lq_sta->pers.dbg_fixed_rate,
-					lq_sta->band, &rate);
-		rs_fill_lq_cmd(mvm, NULL, lq_sta, &rate);
+		rs_fill_lq_cmd(mvm, NULL, lq_sta, NULL);
 		iwl_mvm_send_lq_cmd(lq_sta->pers.drv, &lq_sta->lq, false);
 	}
 }
-- 
1.9.1

