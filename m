Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49288 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755395AbdD1Ige (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Apr 2017 04:36:34 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/4] mac80211: rename ieee80211_rx_status::vht_nss to just nss
Date: Fri, 28 Apr 2017 10:36:25 +0200
Message-Id: <20170428083626.3463-4-johannes@sipsolutions.net> (sfid-20170428_103737_461425_018D5A15)
In-Reply-To: <20170428083626.3463-1-johannes@sipsolutions.net>
References: <20170428083626.3463-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This field will need to be used again for HE, so rename it now.

Again, mostly done with this spatch:

@@
expression status;
@@
-status->vht_nss
+status->nss
@@
expression status;
@@
-status.vht_nss
+status.nss

type=feature

Change-Id: Ib7b3008edee91c49484084a054b25be7daf5fdbf
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c             | 6 +++---
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c          | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c        | 2 +-
 drivers/net/wireless/mac80211_hwsim.c                | 2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c | 2 +-
 include/net/mac80211.h                               | 4 ++--
 net/mac80211/rx.c                                    | 8 ++++----
 net/mac80211/sta_info.h                              | 2 +-
 net/mac80211/util.c                                  | 4 ++--
 9 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index f5ddb83e285f..84b6067ff6e7 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -689,7 +689,7 @@ static void ath10k_htt_rx_h_rates(struct ath10k *ar,
 		}
 
 		status->rate_idx = mcs;
-		status->vht_nss = nss;
+		status->nss = nss;
 
 		if (sgi)
 			status->enc_flags |= RX_ENC_FLAG_SHORT_GI;
@@ -874,7 +874,7 @@ static void ath10k_htt_rx_h_ppdu(struct ath10k *ar,
 		/* New PPDU starts so clear out the old per-PPDU status. */
 		status->freq = 0;
 		status->rate_idx = 0;
-		status->vht_nss = 0;
+		status->nss = 0;
 		status->encoding = RX_ENC_LEGACY;
 		status->bw = RATE_INFO_BW_20;
 		status->flag &= ~RX_FLAG_MACTIME_END;
@@ -946,7 +946,7 @@ static void ath10k_process_rx(struct ath10k *ar,
 		   (status->bw == RATE_INFO_BW_160) ? "160" : "",
 		   status->enc_flags & RX_ENC_FLAG_SHORT_GI ? "sgi " : "",
 		   status->rate_idx,
-		   status->vht_nss,
+		   status->nss,
 		   status->freq,
 		   status->band, status->flag,
 		   !!(status->flag & RX_FLAG_FAILED_FCS_CRC),
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index 93226329e077..fb368d19c0a3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -451,7 +451,7 @@ void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct napi_struct *napi,
 	} else if (rate_n_flags & RATE_MCS_VHT_MSK) {
 		u8 stbc = (rate_n_flags & RATE_MCS_VHT_STBC_MSK) >>
 				RATE_MCS_STBC_POS;
-		rx_status->vht_nss =
+		rx_status->nss =
 			((rate_n_flags & RATE_VHT_MCS_NSS_MSK) >>
 						RATE_VHT_MCS_NSS_POS) + 1;
 		rx_status->rate_idx = rate_n_flags & RATE_VHT_MCS_RATE_CODE_MSK;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 447f030c5c0a..d66b2b527bd8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -982,7 +982,7 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 	} else if (rate_n_flags & RATE_MCS_VHT_MSK) {
 		u8 stbc = (rate_n_flags & RATE_MCS_VHT_STBC_MSK) >>
 				RATE_MCS_STBC_POS;
-		rx_status->vht_nss =
+		rx_status->nss =
 			((rate_n_flags & RATE_VHT_MCS_NSS_MSK) >>
 						RATE_VHT_MCS_NSS_POS) + 1;
 		rx_status->rate_idx = rate_n_flags & RATE_VHT_MCS_RATE_CODE_MSK;
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 358f5f8ff6b9..87444af20fc5 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1192,7 +1192,7 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
 	if (info->control.rates[0].flags & IEEE80211_TX_RC_VHT_MCS) {
 		rx_status.rate_idx =
 			ieee80211_rate_get_vht_mcs(&info->control.rates[0]);
-		rx_status.vht_nss =
+		rx_status.nss =
 			ieee80211_rate_get_vht_nss(&info->control.rates[0]);
 		rx_status.encoding = RX_ENC_VHT;
 	} else {
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
index 2182a3ec5b9f..03665e82065f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/trx.c
@@ -531,7 +531,7 @@ bool rtl8821ae_rx_query_desc(struct ieee80211_hw *hw,
 	if (status->is_short_gi)
 		rx_status->enc_flags |= RX_ENC_FLAG_SHORT_GI;
 
-	rx_status->vht_nss = status->vht_nss;
+	rx_status->nss = status->vht_nss;
 	rx_status->flag |= RX_FLAG_MACTIME_START;
 
 	/* hw will set status->decrypted true, if it finds the
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index c7c1f75a4a48..f1b58b580080 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1171,7 +1171,7 @@ enum mac80211_rx_encoding {
  * @antenna: antenna used
  * @rate_idx: index of data rate into band's supported rates or MCS index if
  *	HT or VHT is used (%RX_FLAG_HT/%RX_FLAG_VHT)
- * @vht_nss: number of streams (VHT only)
+ * @nss: number of streams (VHT and HE only)
  * @flag: %RX_FLAG_\*
  * @encoding: &enum mac80211_rx_encoding
  * @bw: &enum rate_info_bw
@@ -1191,7 +1191,7 @@ struct ieee80211_rx_status {
 	u8 enc_flags;
 	u8 encoding:2, bw:3;
 	u8 rate_idx;
-	u8 vht_nss;
+	u8 nss;
 	u8 rx_flags;
 	u8 band;
 	u8 antenna;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 762e89cf737a..35f4c7d7a500 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -479,7 +479,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 			*pos++ = 0;
 		}
 		/* MCS/NSS */
-		*pos = (status->rate_idx << 4) | status->vht_nss;
+		*pos = (status->rate_idx << 4) | status->nss;
 		pos += 4;
 		/* coding field */
 		if (status->enc_flags & RX_ENC_FLAG_LDPC)
@@ -4308,10 +4308,10 @@ void ieee80211_rx_napi(struct ieee80211_hw *hw, struct ieee80211_sta *pubsta,
 			break;
 		case RX_ENC_VHT:
 			if (WARN_ONCE(status->rate_idx > 9 ||
-				      !status->vht_nss ||
-				      status->vht_nss > 8,
+				      !status->nss ||
+				      status->nss > 8,
 				      "Rate marked as a VHT rate but data is invalid: MCS: %d, NSS: %d\n",
-				      status->rate_idx, status->vht_nss))
+				      status->rate_idx, status->nss))
 				goto drop;
 			break;
 		default:
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index c7f259409187..150f478c7c63 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -747,7 +747,7 @@ static inline u16 sta_stats_encode_rate(struct ieee80211_rx_status *s)
 
 	switch (s->encoding) {
 	case RX_ENC_VHT:
-		r |= STA_STATS_RATE_TYPE_VHT | (s->vht_nss << 4);
+		r |= STA_STATS_RATE_TYPE_VHT | (s->nss << 4);
 		break;
 	case RX_ENC_HT:
 		r |= STA_STATS_RATE_TYPE_HT;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index e9c28904998b..83342b73e9aa 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2726,7 +2726,7 @@ u64 ieee80211_calculate_rx_timestamp(struct ieee80211_local *local,
 	case RX_ENC_VHT:
 		ri.flags |= RATE_INFO_FLAGS_VHT_MCS;
 		ri.mcs = status->rate_idx;
-		ri.nss = status->vht_nss;
+		ri.nss = status->nss;
 		ri.bw = status->bw;
 		if (status->enc_flags & RX_ENC_FLAG_SHORT_GI)
 			ri.flags |= RATE_INFO_FLAGS_SHORT_GI;
@@ -2773,7 +2773,7 @@ u64 ieee80211_calculate_rx_timestamp(struct ieee80211_local *local,
 	if (WARN_ONCE(!rate,
 		      "Invalid bitrate: flags=0x%llx, idx=%d, vht_nss=%d\n",
 		      (unsigned long long)status->flag, status->rate_idx,
-		      status->vht_nss))
+		      status->nss))
 		return 0;
 
 	/* rewind from end of MPDU */
-- 
2.11.0
