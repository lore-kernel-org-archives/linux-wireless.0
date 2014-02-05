Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42537 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949AbaBEOjG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Feb 2014 09:39:06 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH v2] mac80211: move VHT related RX_FLAG to another variable
Date: Wed,  5 Feb 2014 16:37:11 +0200
Message-Id: <1391611031-29099-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140205_153953_370021_C92652B0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_rx_status.flags is full. Define a new vht_flag
variable to be able to set more VHT related flags and make
room in flags.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
v2: Fix ath10k compilation
---
 drivers/net/wireless/ath/ath10k/txrx.c |  4 ++--
 drivers/net/wireless/iwlwifi/mvm/rx.c  |  4 ++--
 include/net/mac80211.h                 | 23 +++++++++++++++++------
 net/mac80211/cfg.c                     |  6 +++---
 net/mac80211/rx.c                      |  9 +++++----
 net/mac80211/sta_info.h                |  2 ++
 net/mac80211/util.c                    |  6 +++---
 7 files changed, 34 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 74f45fa6..27f20e0 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -204,7 +204,7 @@ static void process_rx_rates(struct ath10k *ar, struct htt_rx_info *info,
 			break;
 		/* 80MHZ */
 		case 2:
-			status->flag |= RX_FLAG_80MHZ;
+			status->vht_flag |= RX_VHT_FLAG_80MHZ;
 		}
 
 		status->flag |= RX_FLAG_VHT;
@@ -266,7 +266,7 @@ void ath10k_process_rx(struct ath10k *ar, struct htt_rx_info *info)
 		   status->flag & RX_FLAG_HT ? "ht" : "",
 		   status->flag & RX_FLAG_VHT ? "vht" : "",
 		   status->flag & RX_FLAG_40MHZ ? "40" : "",
-		   status->flag & RX_FLAG_80MHZ ? "80" : "",
+		   status->vht_flag & RX_VHT_FLAG_80MHZ ? "80" : "",
 		   status->flag & RX_FLAG_SHORT_GI ? "sgi " : "",
 		   status->rate_idx,
 		   status->vht_nss,
diff --git a/drivers/net/wireless/iwlwifi/mvm/rx.c b/drivers/net/wireless/iwlwifi/mvm/rx.c
index a85b60f..c67d637 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rx.c
@@ -364,10 +364,10 @@ int iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 		rx_status.flag |= RX_FLAG_40MHZ;
 		break;
 	case RATE_MCS_CHAN_WIDTH_80:
-		rx_status.flag |= RX_FLAG_80MHZ;
+		rx_status.vht_flag |= RX_VHT_FLAG_80MHZ;
 		break;
 	case RATE_MCS_CHAN_WIDTH_160:
-		rx_status.flag |= RX_FLAG_160MHZ;
+		rx_status.vht_flag |= RX_VHT_FLAG_160MHZ;
 		break;
 	}
 	if (rate_n_flags & RATE_MCS_SGI_MSK)
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 304fb56..0b9dcec 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -808,9 +808,6 @@ ieee80211_tx_info_clear_status(struct ieee80211_tx_info *info)
  * @RX_FLAG_HT: HT MCS was used and rate_idx is MCS index
  * @RX_FLAG_VHT: VHT MCS was used and rate_index is MCS index
  * @RX_FLAG_40MHZ: HT40 (40 MHz) was used
- * @RX_FLAG_80MHZ: 80 MHz was used
- * @RX_FLAG_80P80MHZ: 80+80 MHz was used
- * @RX_FLAG_160MHZ: 160 MHz was used
  * @RX_FLAG_SHORT_GI: Short guard interval was used
  * @RX_FLAG_NO_SIGNAL_VAL: The signal strength value is not present.
  *	Valid only for data frames (mainly A-MPDU)
@@ -866,9 +863,6 @@ enum mac80211_rx_flags {
 	RX_FLAG_AMPDU_DELIM_CRC_KNOWN	= BIT(20),
 	RX_FLAG_MACTIME_END		= BIT(21),
 	RX_FLAG_VHT			= BIT(22),
-	RX_FLAG_80MHZ			= BIT(23),
-	RX_FLAG_80P80MHZ		= BIT(24),
-	RX_FLAG_160MHZ			= BIT(25),
 	RX_FLAG_STBC_MASK		= BIT(26) | BIT(27),
 	RX_FLAG_10MHZ			= BIT(28),
 	RX_FLAG_5MHZ			= BIT(29),
@@ -878,6 +872,21 @@ enum mac80211_rx_flags {
 #define RX_FLAG_STBC_SHIFT		26
 
 /**
+ * enum mac80211_rx_vht_flags - receive VHT flags
+ *
+ * These flags are used with the @vht_flag member of
+ *	&struct ieee80211_rx_status.
+ * @RX_VHT_FLAG_80MHZ: 80 MHz was used
+ * @RX_VHT_FLAG_80P80MHZ: 80+80 MHz was used
+ * @RX_VHT_FLAG_160MHZ: 160 MHz was used
+ */
+enum mac80211_rx_vht_flags {
+	RX_VHT_FLAG_80MHZ		= BIT(0),
+	RX_VHT_FLAG_80P80MHZ		= BIT(1),
+	RX_VHT_FLAG_160MHZ		= BIT(2),
+};
+
+/**
  * struct ieee80211_rx_status - receive status
  *
  * The low-level driver should provide this information (the subset
@@ -902,6 +911,7 @@ enum mac80211_rx_flags {
  *	HT or VHT is used (%RX_FLAG_HT/%RX_FLAG_VHT)
  * @vht_nss: number of streams (VHT only)
  * @flag: %RX_FLAG_*
+ * @vht_flag: %RX_VHT_FLAG_*
  * @rx_flags: internal RX flags for mac80211
  * @ampdu_reference: A-MPDU reference number, must be a different value for
  *	each A-MPDU but the same for each subframe within one A-MPDU
@@ -913,6 +923,7 @@ struct ieee80211_rx_status {
 	u32 ampdu_reference;
 	u32 flag;
 	u16 freq;
+	u8 vht_flag;
 	u8 rate_idx;
 	u8 vht_nss;
 	u8 rx_flags;
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index f9ae9b8..b296015 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -451,11 +451,11 @@ void sta_set_rate_info_rx(struct sta_info *sta, struct rate_info *rinfo)
 		rinfo->flags |= RATE_INFO_FLAGS_40_MHZ_WIDTH;
 	if (sta->last_rx_rate_flag & RX_FLAG_SHORT_GI)
 		rinfo->flags |= RATE_INFO_FLAGS_SHORT_GI;
-	if (sta->last_rx_rate_flag & RX_FLAG_80MHZ)
+	if (sta->last_rx_rate_vht_flag & RX_VHT_FLAG_80MHZ)
 		rinfo->flags |= RATE_INFO_FLAGS_80_MHZ_WIDTH;
-	if (sta->last_rx_rate_flag & RX_FLAG_80P80MHZ)
+	if (sta->last_rx_rate_vht_flag & RX_VHT_FLAG_80P80MHZ)
 		rinfo->flags |= RATE_INFO_FLAGS_80P80_MHZ_WIDTH;
-	if (sta->last_rx_rate_flag & RX_FLAG_160MHZ)
+	if (sta->last_rx_rate_vht_flag & RX_VHT_FLAG_160MHZ)
 		rinfo->flags |= RATE_INFO_FLAGS_160_MHZ_WIDTH;
 }
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5ff001b..8dc5f6b 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -321,7 +321,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 
 		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_VHT);
 		/* known field - how to handle 80+80? */
-		if (status->flag & RX_FLAG_80P80MHZ)
+		if (status->vht_flag & RX_VHT_FLAG_80P80MHZ)
 			known &= ~IEEE80211_RADIOTAP_VHT_KNOWN_BANDWIDTH;
 		put_unaligned_le16(known, pos);
 		pos += 2;
@@ -330,11 +330,11 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 			*pos |= IEEE80211_RADIOTAP_VHT_FLAG_SGI;
 		pos++;
 		/* bandwidth */
-		if (status->flag & RX_FLAG_80MHZ)
+		if (status->vht_flag & RX_VHT_FLAG_80MHZ)
 			*pos++ = 4;
-		else if (status->flag & RX_FLAG_80P80MHZ)
+		else if (status->vht_flag & RX_VHT_FLAG_80P80MHZ)
 			*pos++ = 0; /* marked not known above */
-		else if (status->flag & RX_FLAG_160MHZ)
+		else if (status->vht_flag & RX_VHT_FLAG_160MHZ)
 			*pos++ = 11;
 		else if (status->flag & RX_FLAG_40MHZ)
 			*pos++ = 1;
@@ -1218,6 +1218,7 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 			if (ieee80211_is_data(hdr->frame_control)) {
 				sta->last_rx_rate_idx = status->rate_idx;
 				sta->last_rx_rate_flag = status->flag;
+				sta->last_rx_rate_vht_flag = status->vht_flag;
 				sta->last_rx_rate_vht_nss = status->vht_nss;
 			}
 		}
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index d77ff70..d4d85de 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -261,6 +261,7 @@ struct ieee80211_tx_latency_stat {
  *	"the" transmit rate
  * @last_rx_rate_idx: rx status rate index of the last data packet
  * @last_rx_rate_flag: rx status flag of the last data packet
+ * @last_rx_rate_vht_flag: rx status vht flag of the last data packet
  * @last_rx_rate_vht_nss: rx status nss of last data packet
  * @lock: used for locking all fields that require locking, see comments
  *	in the header file.
@@ -397,6 +398,7 @@ struct sta_info {
 	struct ieee80211_tx_rate last_tx_rate;
 	int last_rx_rate_idx;
 	u32 last_rx_rate_flag;
+	u32 last_rx_rate_vht_flag;
 	u8 last_rx_rate_vht_nss;
 	u16 tid_seq[IEEE80211_QOS_CTL_TID_MASK + 1];
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 676dc09..0883c7b 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2272,11 +2272,11 @@ u64 ieee80211_calculate_rx_timestamp(struct ieee80211_local *local,
 		ri.nss = status->vht_nss;
 		if (status->flag & RX_FLAG_40MHZ)
 			ri.flags |= RATE_INFO_FLAGS_40_MHZ_WIDTH;
-		if (status->flag & RX_FLAG_80MHZ)
+		if (status->vht_flag & RX_VHT_FLAG_80MHZ)
 			ri.flags |= RATE_INFO_FLAGS_80_MHZ_WIDTH;
-		if (status->flag & RX_FLAG_80P80MHZ)
+		if (status->vht_flag & RX_VHT_FLAG_80P80MHZ)
 			ri.flags |= RATE_INFO_FLAGS_80P80_MHZ_WIDTH;
-		if (status->flag & RX_FLAG_160MHZ)
+		if (status->vht_flag & RX_VHT_FLAG_160MHZ)
 			ri.flags |= RATE_INFO_FLAGS_160_MHZ_WIDTH;
 		if (status->flag & RX_FLAG_SHORT_GI)
 			ri.flags |= RATE_INFO_FLAGS_SHORT_GI;
-- 
1.8.3.2

