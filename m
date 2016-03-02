Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:22360 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220AbcCBH5d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 02:57:33 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 17/43] iwlwifi: mvm: don't enable A-MSDU when the rates are too low
Date: Wed,  2 Mar 2016 09:56:18 +0200
Message-Id: <1456905404-14435-17-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160302_085737_818019_18532303)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow A-MSDU only when we are not downscaling and the
initial MCS is at least 5.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c  | 24 ++++++++++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h |  2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c  |  3 ++-
 3 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index 3dc94d2..61d0a8cd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -1673,6 +1673,20 @@ static void rs_stay_in_table(struct iwl_lq_sta *lq_sta, bool force_search)
 	}
 }
 
+static void rs_set_amsdu_len(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
+			     struct iwl_scale_tbl_info *tbl,
+			     enum rs_action scale_action)
+{
+	struct iwl_mvm_sta *sta_priv = iwl_mvm_sta_from_mac80211(sta);
+
+	if ((!is_vht(&tbl->rate) && !is_ht(&tbl->rate)) ||
+	    tbl->rate.index < IWL_RATE_MCS_5_INDEX ||
+	    scale_action == RS_ACTION_DOWNSCALE)
+		sta_priv->tlc_amsdu = false;
+	else
+		sta_priv->tlc_amsdu = true;
+}
+
 /*
  * setup rate table in uCode
  */
@@ -2416,6 +2430,7 @@ lq_update:
 		tbl->rate.index = index;
 		if (IWL_MVM_RS_80_20_FAR_RANGE_TWEAK)
 			rs_tweak_rate_tbl(mvm, sta, lq_sta, tbl, scale_action);
+		rs_set_amsdu_len(mvm, sta, tbl, scale_action);
 		rs_update_rate_tbl(mvm, sta, lq_sta, tbl);
 	}
 
@@ -3099,6 +3114,7 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	sband = hw->wiphy->bands[band];
 
 	lq_sta->lq.sta_id = sta_priv->sta_id;
+	sta_priv->tlc_amsdu = false;
 
 	for (j = 0; j < LQ_SIZE; j++)
 		rs_rate_scale_clear_tbl_windows(mvm, &lq_sta->lq_info[j]);
@@ -3658,10 +3674,13 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 	ssize_t ret;
 
 	struct iwl_lq_sta *lq_sta = file->private_data;
+	struct iwl_mvm_sta *mvmsta =
+		container_of(lq_sta, struct iwl_mvm_sta, lq_sta);
 	struct iwl_mvm *mvm;
 	struct iwl_scale_tbl_info *tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
 	struct rs_rate *rate = &tbl->rate;
 	u32 ss_params;
+
 	mvm = lq_sta->pers.drv;
 	buff = kmalloc(2048, GFP_KERNEL);
 	if (!buff)
@@ -3687,10 +3706,11 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 				(is_ht20(rate)) ? "20MHz" :
 				(is_ht40(rate)) ? "40MHz" :
 				(is_ht80(rate)) ? "80Mhz" : "BAD BW");
-		desc += sprintf(buff + desc, " %s %s %s\n",
+		desc += sprintf(buff + desc, " %s %s %s %s\n",
 				(rate->sgi) ? "SGI" : "NGI",
 				(rate->ldpc) ? "LDPC" : "BCC",
-				(lq_sta->is_agg) ? "AGG on" : "");
+				(lq_sta->is_agg) ? "AGG on" : "",
+				(mvmsta->tlc_amsdu) ? "AMSDU on" : "");
 	}
 	desc += sprintf(buff+desc, "last tx rate=0x%X\n",
 			lq_sta->last_rate_n_flags);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
index b01650a..f95f603 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
@@ -313,6 +313,7 @@ struct iwl_mvm_key_pn {
  * @tx_protection: reference counter for controlling the Tx protection.
  * @tt_tx_protection: is thermal throttling enable Tx protection?
  * @disable_tx: is tx to this STA disabled?
+ * @tlc_amsdu: true if A-MSDU is allowed
  * @agg_tids: bitmap of tids whose status is operational aggregated (IWL_AGG_ON)
  * @sleep_tx_count: the number of frames that we told the firmware to let out
  *	even when that station is asleep. This is useful in case the queue
@@ -347,6 +348,7 @@ struct iwl_mvm_sta {
 	bool tt_tx_protection;
 
 	bool disable_tx;
+	bool tlc_amsdu;
 	u8 agg_tids;
 	u8 sleep_tx_count;
 };
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index a5a55da1..a73ae01 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -460,7 +460,8 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 		return -EINVAL;
 
 	if (!sta->max_amsdu_len ||
-	    !ieee80211_is_data_qos(hdr->frame_control)) {
+	    !ieee80211_is_data_qos(hdr->frame_control) ||
+	    !mvmsta->tlc_amsdu) {
 		num_subframes = 1;
 		pad = 0;
 		goto segment;
-- 
2.5.0

