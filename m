Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11786 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754618AbbAVUew (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 15:34:52 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 36/38] iwlwifi: mvm: rs: remove stats argument from functions
Date: Thu, 22 Jan 2015 22:33:27 +0200
Message-Id: <1421958809-3371-36-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150122_214446_977950_F8A33EB6)
In-Reply-To: <1421958313.6424.2.camel@egrumbacBox>
References: <1421958313.6424.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The stats argument is always only passed as &mvm->drv_rx_stats, so
there's no point in passing it when the mvm pointer is passed.
Remove the argument entirely.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mvm.h |  4 +-
 drivers/net/wireless/iwlwifi/mvm/rs.c  | 92 ++++++++++++++++++++++++++--------
 drivers/net/wireless/iwlwifi/mvm/rx.c  |  2 +-
 3 files changed, 72 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index aa93ee7..979ac23 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1143,9 +1143,7 @@ iwl_mvm_vif_dbgfs_clean(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 /* rate scaling */
 int iwl_mvm_send_lq_cmd(struct iwl_mvm *mvm, struct iwl_lq_cmd *lq, bool init);
-void iwl_mvm_update_frame_stats(struct iwl_mvm *mvm,
-				struct iwl_mvm_frame_stats *stats,
-				u32 rate, bool agg);
+void iwl_mvm_update_frame_stats(struct iwl_mvm *mvm, u32 rate, bool agg);
 int rs_pretty_print_rate(char *buf, const u32 rate);
 void rs_update_last_rssi(struct iwl_mvm *mvm,
 			 struct iwl_lq_sta *lq_sta,
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index f30eff2..9f32f2d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -2600,68 +2600,116 @@ static void rs_vht_set_enabled_rates(struct ieee80211_sta *sta,
 	}
 }
 
+static void rs_ht_init(struct iwl_mvm *mvm,
+		       struct ieee80211_sta *sta,
+		       struct iwl_lq_sta *lq_sta,
+		       struct ieee80211_sta_ht_cap *ht_cap)
+{
+	/* active_siso_rate mask includes 9 MBits (bit 5),
+	 * and CCK (bits 0-3), supp_rates[] does not;
+	 * shift to convert format, force 9 MBits off.
+	 */
+	lq_sta->active_siso_rate = ht_cap->mcs.rx_mask[0] << 1;
+	lq_sta->active_siso_rate |= ht_cap->mcs.rx_mask[0] & 0x1;
+	lq_sta->active_siso_rate &= ~((u16)0x2);
+	lq_sta->active_siso_rate <<= IWL_FIRST_OFDM_RATE;
+
+	lq_sta->active_mimo2_rate = ht_cap->mcs.rx_mask[1] << 1;
+	lq_sta->active_mimo2_rate |= ht_cap->mcs.rx_mask[1] & 0x1;
+	lq_sta->active_mimo2_rate &= ~((u16)0x2);
+	lq_sta->active_mimo2_rate <<= IWL_FIRST_OFDM_RATE;
+
+	if (mvm->cfg->ht_params->ldpc &&
+	    (ht_cap->cap & IEEE80211_HT_CAP_LDPC_CODING))
+		lq_sta->ldpc = true;
+
+	if (mvm->cfg->ht_params->stbc &&
+	    (num_of_ant(iwl_mvm_get_valid_tx_ant(mvm)) > 1) &&
+	    (ht_cap->cap & IEEE80211_HT_CAP_RX_STBC))
+		lq_sta->stbc = true;
+
+	lq_sta->is_vht = false;
+}
+
+static void rs_vht_init(struct iwl_mvm *mvm,
+			struct ieee80211_sta *sta,
+			struct iwl_lq_sta *lq_sta,
+			struct ieee80211_sta_vht_cap *vht_cap)
+{
+	rs_vht_set_enabled_rates(sta, vht_cap, lq_sta);
+
+	if (mvm->cfg->ht_params->ldpc &&
+	    (vht_cap->cap & IEEE80211_VHT_CAP_RXLDPC))
+		lq_sta->ldpc = true;
+
+	if (mvm->cfg->ht_params->stbc &&
+	    (num_of_ant(iwl_mvm_get_valid_tx_ant(mvm)) > 1) &&
+	    (vht_cap->cap & IEEE80211_VHT_CAP_RXSTBC_MASK))
+		lq_sta->stbc = true;
+
+	lq_sta->is_vht = true;
+}
+
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-static void iwl_mvm_reset_frame_stats(struct iwl_mvm *mvm,
-				      struct iwl_mvm_frame_stats *stats)
+static void iwl_mvm_reset_frame_stats(struct iwl_mvm *mvm)
 {
 	spin_lock_bh(&mvm->drv_stats_lock);
-	memset(stats, 0, sizeof(*stats));
+	memset(&mvm->drv_rx_stats, 0, sizeof(mvm->drv_rx_stats));
 	spin_unlock_bh(&mvm->drv_stats_lock);
 }
 
-void iwl_mvm_update_frame_stats(struct iwl_mvm *mvm,
-				struct iwl_mvm_frame_stats *stats,
-				u32 rate, bool agg)
+void iwl_mvm_update_frame_stats(struct iwl_mvm *mvm, u32 rate, bool agg)
 {
 	u8 nss = 0, mcs = 0;
 
 	spin_lock(&mvm->drv_stats_lock);
 
 	if (agg)
-		stats->agg_frames++;
+		mvm->drv_rx_stats.agg_frames++;
 
-	stats->success_frames++;
+	mvm->drv_rx_stats.success_frames++;
 
 	switch (rate & RATE_MCS_CHAN_WIDTH_MSK) {
 	case RATE_MCS_CHAN_WIDTH_20:
-		stats->bw_20_frames++;
+		mvm->drv_rx_stats.bw_20_frames++;
 		break;
 	case RATE_MCS_CHAN_WIDTH_40:
-		stats->bw_40_frames++;
+		mvm->drv_rx_stats.bw_40_frames++;
 		break;
 	case RATE_MCS_CHAN_WIDTH_80:
-		stats->bw_80_frames++;
+		mvm->drv_rx_stats.bw_80_frames++;
 		break;
 	default:
 		WARN_ONCE(1, "bad BW. rate 0x%x", rate);
 	}
 
 	if (rate & RATE_MCS_HT_MSK) {
-		stats->ht_frames++;
+		mvm->drv_rx_stats.ht_frames++;
 		mcs = rate & RATE_HT_MCS_RATE_CODE_MSK;
 		nss = ((rate & RATE_HT_MCS_NSS_MSK) >> RATE_HT_MCS_NSS_POS) + 1;
 	} else if (rate & RATE_MCS_VHT_MSK) {
-		stats->vht_frames++;
+		mvm->drv_rx_stats.vht_frames++;
 		mcs = rate & RATE_VHT_MCS_RATE_CODE_MSK;
 		nss = ((rate & RATE_VHT_MCS_NSS_MSK) >>
 		       RATE_VHT_MCS_NSS_POS) + 1;
 	} else {
-		stats->legacy_frames++;
+		mvm->drv_rx_stats.legacy_frames++;
 	}
 
 	if (nss == 1)
-		stats->siso_frames++;
+		mvm->drv_rx_stats.siso_frames++;
 	else if (nss == 2)
-		stats->mimo2_frames++;
+		mvm->drv_rx_stats.mimo2_frames++;
 
 	if (rate & RATE_MCS_SGI_MSK)
-		stats->sgi_frames++;
+		mvm->drv_rx_stats.sgi_frames++;
 	else
-		stats->ngi_frames++;
+		mvm->drv_rx_stats.ngi_frames++;
 
-	stats->last_rates[stats->last_frame_idx] = rate;
-	stats->last_frame_idx = (stats->last_frame_idx + 1) %
-		ARRAY_SIZE(stats->last_rates);
+	mvm->drv_rx_stats.last_rates[mvm->drv_rx_stats.last_frame_idx] = rate;
+	mvm->drv_rx_stats.last_frame_idx =
+		(mvm->drv_rx_stats.last_frame_idx + 1) %
+			ARRAY_SIZE(mvm->drv_rx_stats.last_rates);
 
 	spin_unlock(&mvm->drv_stats_lock);
 }
@@ -2749,7 +2797,7 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	lq_sta->tx_agg_tid_en = IWL_AGG_ALL_TID;
 	lq_sta->is_agg = 0;
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-	iwl_mvm_reset_frame_stats(mvm, &mvm->drv_rx_stats);
+	iwl_mvm_reset_frame_stats(mvm);
 #endif
 	rs_initialize_lq(mvm, sta, lq_sta, band, init);
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/rx.c b/drivers/net/wireless/iwlwifi/mvm/rx.c
index 7919a7b..f922131 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rx.c
@@ -407,7 +407,7 @@ int iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 	}
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-	iwl_mvm_update_frame_stats(mvm, &mvm->drv_rx_stats, rate_n_flags,
+	iwl_mvm_update_frame_stats(mvm, rate_n_flags,
 				   rx_status->flag & RX_FLAG_AMPDU_DETAILS);
 #endif
 	iwl_mvm_pass_packet_to_mac80211(mvm, skb, hdr, len, ampdu_status,
-- 
1.9.1

