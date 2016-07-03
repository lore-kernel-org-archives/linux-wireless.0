Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60810 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752891AbcGCTtE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jul 2016 15:49:04 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
Date: Sun,  3 Jul 2016 22:48:45 +0300
Message-Id: <1467575332-32112-6-git-send-email-luca@coelho.fi> (sfid-20160703_214924_548262_10A06123)
In-Reply-To: <467405215.1837.15.camel@coelho.fi>
References: <467405215.1837.15.camel@coelho.fi>
Subject: [PATCH 06/13] iwlwifi: mvm: update mpdu metadata API
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

rx_phy notification is no longer sent in devices with
multiple rx queues.
All the needed data is now set in the metadata - update
code accordingly to reflect all the features as in the
previous RX path.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |  5 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h | 24 +++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      | 51 +++++++++++++++-------
 4 files changed, 58 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 8193d36..2f024c7 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -211,6 +211,7 @@ struct iwl_cmd_header_wide {
 #define FH_RSCSR_FRAME_SIZE_MSK		0x00003FFF	/* bits 0-13 */
 #define FH_RSCSR_FRAME_INVALID		0x55550000
 #define FH_RSCSR_FRAME_ALIGN		0x40
+#define FH_RSCSR_RPA_EN			BIT(25)
 
 struct iwl_rx_packet {
 	/*
@@ -220,7 +221,9 @@ struct iwl_rx_packet {
 	 * 31:    flag flush RB request
 	 * 30:    flag ignore TC (terminal counter) request
 	 * 29:    flag fast IRQ request
-	 * 28-14: Reserved
+	 * 28-26: Reserved
+	 * 25:    Offload enabled
+	 * 24-14: Reserved
 	 * 13-00: RX frame size
 	 */
 	__le32 len_n_flags;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
index bb8ff40..1994331 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
@@ -336,6 +336,18 @@ enum iwl_rx_mpdu_reorder_data {
 	IWL_RX_MPDU_REORDER_BA_OLD_SN		= 0x80000000,
 };
 
+enum iwl_rx_mpdu_phy_info {
+	IWL_RX_MPDU_PHY_AMPDU		= BIT(5),
+	IWL_RX_MPDU_PHY_AMPDU_TOGGLE	= BIT(6),
+	IWL_RX_MPDU_PHY_SHORT_PREAMBLE	= BIT(7),
+	IWL_RX_MPDU_PHY_TSF_OVERLOAD	= BIT(8),
+};
+
+enum iwl_rx_mpdu_mac_info {
+	IWL_RX_MPDU_PHY_MAC_INDEX_MASK		= 0x0f,
+	IWL_RX_MPDU_PHY_PHY_INDEX_MASK		= 0xf0,
+};
+
 struct iwl_rx_mpdu_desc {
 	/* DW2 */
 	__le16 mpdu_len;
@@ -343,9 +355,9 @@ struct iwl_rx_mpdu_desc {
 	u8 mac_flags2;
 	/* DW3 */
 	u8 amsdu_info;
-	__le16 reserved_for_software;
+	__le16 phy_info;
 	u8 mac_phy_idx;
-	/* DW4 */
+	/* DW4 - carries csum data only when rpa_en == 1 */
 	__le16 raw_csum; /* alledgedly unreliable */
 	__le16 l3l4_flags;
 	/* DW5 */
@@ -354,17 +366,17 @@ struct iwl_rx_mpdu_desc {
 	u8 sta_id_flags;
 	/* DW6 */
 	__le32 reorder_data;
-	/* DW7 */
+	/* DW7 - carries rss_hash only when rpa_en == 1 */
 	__le32 rss_hash;
-	/* DW8 */
+	/* DW8 - carries filter_match only when rpa_en == 1 */
 	__le32 filter_match;
 	/* DW9 */
 	__le32 rate_n_flags;
 	/* DW10 */
-	u8 energy_a, energy_b, channel, reserved;
+	u8 energy_a, energy_b, channel, mac_context;
 	/* DW11 */
 	__le32 gp2_on_air_rise;
-	/* DW12 & DW13 */
+	/* DW12 & DW13 - carries TSF only TSF_OVERLOAD bit == 0 */
 	__le64 tsf_on_air_rise;
 } __packed;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index dd0b8f8..65f9a4b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -731,6 +731,7 @@ struct iwl_mvm {
 	struct iwl_sf_region sf_space;
 
 	u32 ampdu_ref;
+	bool ampdu_toggle;
 
 	struct iwl_notif_wait_data notif_wait;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 67924fc..1f4fef4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -737,6 +737,7 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 	struct ieee80211_hdr *hdr = (void *)(pkt->data + sizeof(*desc));
 	u32 len = le16_to_cpu(desc->mpdu_len);
 	u32 rate_n_flags = le32_to_cpu(desc->rate_n_flags);
+	u16 phy_info = le16_to_cpu(desc->phy_info);
 	struct ieee80211_sta *sta = NULL;
 	struct sk_buff *skb;
 	u8 crypt_len = 0;
@@ -767,16 +768,34 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 			     le16_to_cpu(desc->status));
 		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
 	}
-
-	rx_status->mactime = le64_to_cpu(desc->tsf_on_air_rise);
+	/* set the preamble flag if appropriate */
+	if (phy_info & IWL_RX_MPDU_PHY_SHORT_PREAMBLE)
+		rx_status->flag |= RX_FLAG_SHORTPRE;
+
+	if (likely(!(phy_info & IWL_RX_MPDU_PHY_TSF_OVERLOAD))) {
+		rx_status->mactime = le64_to_cpu(desc->tsf_on_air_rise);
+		/* TSF as indicated by the firmware is at INA time */
+		rx_status->flag |= RX_FLAG_MACTIME_PLCP_START;
+	}
 	rx_status->device_timestamp = le32_to_cpu(desc->gp2_on_air_rise);
 	rx_status->band = desc->channel > 14 ? NL80211_BAND_5GHZ :
 					       NL80211_BAND_2GHZ;
 	rx_status->freq = ieee80211_channel_to_frequency(desc->channel,
 							 rx_status->band);
 	iwl_mvm_get_signal_strength(mvm, desc, rx_status);
-	/* TSF as indicated by the firmware is at INA time */
-	rx_status->flag |= RX_FLAG_MACTIME_PLCP_START;
+
+	/* update aggregation data for monitor sake on default queue */
+	if (!queue && (phy_info & IWL_RX_MPDU_PHY_AMPDU)) {
+		bool toggle_bit = phy_info & IWL_RX_MPDU_PHY_AMPDU_TOGGLE;
+
+		rx_status->flag |= RX_FLAG_AMPDU_DETAILS;
+		rx_status->ampdu_reference = mvm->ampdu_ref;
+		/* toggle is switched whenever new aggregation starts */
+		if (toggle_bit != mvm->ampdu_toggle) {
+			mvm->ampdu_ref++;
+			mvm->ampdu_toggle = toggle_bit;
+		}
+	}
 
 	rcu_read_lock();
 
@@ -831,8 +850,6 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 				iwl_mvm_fw_dbg_collect_trig(mvm, trig, NULL);
 		}
 
-		/* TODO: multi queue TCM */
-
 		if (ieee80211_is_data(hdr->frame_control))
 			iwl_mvm_rx_csum(sta, skb, desc);
 
@@ -857,14 +874,6 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 			iwl_mvm_agg_rx_received(mvm, baid);
 	}
 
-	/*
-	 * TODO: PHY info.
-	 * Verify we don't have the information in the MPDU descriptor and
-	 * that it is not needed.
-	 * Make sure for monitor mode that we are on default queue, update
-	 * ampdu_ref and the rest of phy info then
-	 */
-
 	/* Set up the HT phy flags */
 	switch (rate_n_flags & RATE_MCS_CHAN_WIDTH_MSK) {
 	case RATE_MCS_CHAN_WIDTH_20:
@@ -908,8 +917,18 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 							    rx_status->band);
 	}
 
-	/* TODO: PHY info - update ampdu queue statistics (for debugfs) */
-	/* TODO: PHY info - gscan */
+	/* management stuff on default queue */
+	if (!queue) {
+		if (unlikely((ieee80211_is_beacon(hdr->frame_control) ||
+			      ieee80211_is_probe_resp(hdr->frame_control)) &&
+			     mvm->sched_scan_pass_all ==
+			     SCHED_SCAN_PASS_ALL_ENABLED))
+			mvm->sched_scan_pass_all = SCHED_SCAN_PASS_ALL_FOUND;
+
+		if (unlikely(ieee80211_is_beacon(hdr->frame_control) ||
+			     ieee80211_is_probe_resp(hdr->frame_control)))
+			rx_status->boottime_ns = ktime_get_boot_ns();
+	}
 
 	iwl_mvm_create_skb(skb, hdr, len, crypt_len, rxb);
 	if (!iwl_mvm_reorder(mvm, napi, queue, sta, skb, desc))
-- 
2.8.1

