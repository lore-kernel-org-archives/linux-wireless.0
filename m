Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:35841 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242AbaKXOf7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:35:59 -0500
Received: by mail-wi0-f171.google.com with SMTP id bs8so5834080wib.16
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:35:58 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 38/75] iwlwifi: build mac80211 rx_status in place
Date: Mon, 24 Nov 2014 16:34:14 +0200
Message-Id: <1416839691-28533-38-git-send-email-egrumbach@gmail.com> (sfid-20141124_154346_477480_91DF402A)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of building the rx_status on the stack and then
copying it to the skb, allocate the skb a bit earlier
and then build the rx_status in place.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: IdoX Yariv <ido@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rx.c | 99 +++++++++++++++++------------------
 1 file changed, 49 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rx.c b/drivers/net/wireless/iwlwifi/mvm/rx.c
index 93d5b69..57052e6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rx.c
@@ -96,22 +96,13 @@ int iwl_mvm_rx_rx_phy_cmd(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
  * Adds the rxb to a new skb and give it to mac80211
  */
 static void iwl_mvm_pass_packet_to_mac80211(struct iwl_mvm *mvm,
+					    struct sk_buff *skb,
 					    struct ieee80211_hdr *hdr, u16 len,
 					    u32 ampdu_status,
-					    struct iwl_rx_cmd_buffer *rxb,
-					    struct ieee80211_rx_status *stats)
+					    struct iwl_rx_cmd_buffer *rxb)
 {
-	struct sk_buff *skb;
 	unsigned int hdrlen, fraglen;
 
-	/* Dont use dev_alloc_skb(), we'll have enough headroom once
-	 * ieee80211_hdr pulled.
-	 */
-	skb = alloc_skb(128, GFP_ATOMIC);
-	if (!skb) {
-		IWL_ERR(mvm, "alloc_skb failed\n");
-		return;
-	}
 	/* If frame is small enough to fit in skb->head, pull it completely.
 	 * If not, only pull ieee80211_hdr so that splice() or TCP coalesce
 	 * are more efficient.
@@ -129,8 +120,6 @@ static void iwl_mvm_pass_packet_to_mac80211(struct iwl_mvm *mvm,
 				fraglen, rxb->truesize);
 	}
 
-	memcpy(IEEE80211_SKB_RXCB(skb), stats, sizeof(*stats));
-
 	ieee80211_rx(mvm->hw, skb);
 }
 
@@ -242,11 +231,12 @@ int iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 		       struct iwl_device_cmd *cmd)
 {
 	struct ieee80211_hdr *hdr;
-	struct ieee80211_rx_status rx_status = {};
+	struct ieee80211_rx_status *rx_status;
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_rx_phy_info *phy_info;
 	struct iwl_rx_mpdu_res_start *rx_res;
 	struct ieee80211_sta *sta;
+	struct sk_buff *skb;
 	u32 len;
 	u32 ampdu_status;
 	u32 rate_n_flags;
@@ -259,20 +249,31 @@ int iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 	rx_pkt_status = le32_to_cpup((__le32 *)
 		(pkt->data + sizeof(*rx_res) + len));
 
-	memset(&rx_status, 0, sizeof(rx_status));
+	/* Dont use dev_alloc_skb(), we'll have enough headroom once
+	 * ieee80211_hdr pulled.
+	 */
+	skb = alloc_skb(128, GFP_ATOMIC);
+	if (!skb) {
+		IWL_ERR(mvm, "alloc_skb failed\n");
+		return 0;
+	}
+
+	rx_status = IEEE80211_SKB_RXCB(skb);
 
 	/*
 	 * drop the packet if it has failed being decrypted by HW
 	 */
-	if (iwl_mvm_set_mac80211_rx_flag(mvm, hdr, &rx_status, rx_pkt_status)) {
+	if (iwl_mvm_set_mac80211_rx_flag(mvm, hdr, rx_status, rx_pkt_status)) {
 		IWL_DEBUG_DROP(mvm, "Bad decryption results 0x%08x\n",
 			       rx_pkt_status);
+		kfree_skb(skb);
 		return 0;
 	}
 
 	if ((unlikely(phy_info->cfg_phy_cnt > 20))) {
 		IWL_DEBUG_DROP(mvm, "dsp size out of range [0,20]: %d\n",
 			       phy_info->cfg_phy_cnt);
+		kfree_skb(skb);
 		return 0;
 	}
 
@@ -283,31 +284,31 @@ int iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 	if (!(rx_pkt_status & RX_MPDU_RES_STATUS_CRC_OK) ||
 	    !(rx_pkt_status & RX_MPDU_RES_STATUS_OVERRUN_OK)) {
 		IWL_DEBUG_RX(mvm, "Bad CRC or FIFO: 0x%08X.\n", rx_pkt_status);
-		rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;
+		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
 	}
 
 	/* This will be used in several places later */
 	rate_n_flags = le32_to_cpu(phy_info->rate_n_flags);
 
 	/* rx_status carries information about the packet to mac80211 */
-	rx_status.mactime = le64_to_cpu(phy_info->timestamp);
-	rx_status.device_timestamp = le32_to_cpu(phy_info->system_timestamp);
-	rx_status.band =
+	rx_status->mactime = le64_to_cpu(phy_info->timestamp);
+	rx_status->device_timestamp = le32_to_cpu(phy_info->system_timestamp);
+	rx_status->band =
 		(phy_info->phy_flags & cpu_to_le16(RX_RES_PHY_FLAGS_BAND_24)) ?
 				IEEE80211_BAND_2GHZ : IEEE80211_BAND_5GHZ;
-	rx_status.freq =
+	rx_status->freq =
 		ieee80211_channel_to_frequency(le16_to_cpu(phy_info->channel),
-					       rx_status.band);
+					       rx_status->band);
 	/*
 	 * TSF as indicated by the fw is at INA time, but mac80211 expects the
 	 * TSF at the beginning of the MPDU.
 	 */
-	/*rx_status.flag |= RX_FLAG_MACTIME_MPDU;*/
+	/*rx_status->flag |= RX_FLAG_MACTIME_MPDU;*/
 
-	iwl_mvm_get_signal_strength(mvm, phy_info, &rx_status);
+	iwl_mvm_get_signal_strength(mvm, phy_info, rx_status);
 
-	IWL_DEBUG_STATS_LIMIT(mvm, "Rssi %d, TSF %llu\n", rx_status.signal,
-			      (unsigned long long)rx_status.mactime);
+	IWL_DEBUG_STATS_LIMIT(mvm, "Rssi %d, TSF %llu\n", rx_status->signal,
+			      (unsigned long long)rx_status->mactime);
 
 	rcu_read_lock();
 	/*
@@ -326,15 +327,14 @@ int iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 	if (sta) {
 		struct iwl_mvm_sta *mvmsta;
 		mvmsta = iwl_mvm_sta_from_mac80211(sta);
-		rs_update_last_rssi(mvm, &mvmsta->lq_sta,
-				    &rx_status);
+		rs_update_last_rssi(mvm, &mvmsta->lq_sta, rx_status);
 	}
 
 	rcu_read_unlock();
 
 	/* set the preamble flag if appropriate */
 	if (phy_info->phy_flags & cpu_to_le16(RX_RES_PHY_FLAGS_SHORT_PREAMBLE))
-		rx_status.flag |= RX_FLAG_SHORTPRE;
+		rx_status->flag |= RX_FLAG_SHORTPRE;
 
 	if (phy_info->phy_flags & cpu_to_le16(RX_RES_PHY_FLAGS_AGG)) {
 		/*
@@ -342,8 +342,8 @@ int iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 		 * together since we get a single PHY response
 		 * from the firmware for all of them
 		 */
-		rx_status.flag |= RX_FLAG_AMPDU_DETAILS;
-		rx_status.ampdu_reference = mvm->ampdu_ref;
+		rx_status->flag |= RX_FLAG_AMPDU_DETAILS;
+		rx_status->ampdu_reference = mvm->ampdu_ref;
 	}
 
 	/* Set up the HT phy flags */
@@ -351,50 +351,49 @@ int iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 	case RATE_MCS_CHAN_WIDTH_20:
 		break;
 	case RATE_MCS_CHAN_WIDTH_40:
-		rx_status.flag |= RX_FLAG_40MHZ;
+		rx_status->flag |= RX_FLAG_40MHZ;
 		break;
 	case RATE_MCS_CHAN_WIDTH_80:
-		rx_status.vht_flag |= RX_VHT_FLAG_80MHZ;
+		rx_status->vht_flag |= RX_VHT_FLAG_80MHZ;
 		break;
 	case RATE_MCS_CHAN_WIDTH_160:
-		rx_status.vht_flag |= RX_VHT_FLAG_160MHZ;
+		rx_status->vht_flag |= RX_VHT_FLAG_160MHZ;
 		break;
 	}
 	if (rate_n_flags & RATE_MCS_SGI_MSK)
-		rx_status.flag |= RX_FLAG_SHORT_GI;
+		rx_status->flag |= RX_FLAG_SHORT_GI;
 	if (rate_n_flags & RATE_HT_MCS_GF_MSK)
-		rx_status.flag |= RX_FLAG_HT_GF;
+		rx_status->flag |= RX_FLAG_HT_GF;
 	if (rate_n_flags & RATE_MCS_LDPC_MSK)
-		rx_status.flag |= RX_FLAG_LDPC;
+		rx_status->flag |= RX_FLAG_LDPC;
 	if (rate_n_flags & RATE_MCS_HT_MSK) {
 		u8 stbc = (rate_n_flags & RATE_MCS_HT_STBC_MSK) >>
 				RATE_MCS_STBC_POS;
-		rx_status.flag |= RX_FLAG_HT;
-		rx_status.rate_idx = rate_n_flags & RATE_HT_MCS_INDEX_MSK;
-		rx_status.flag |= stbc << RX_FLAG_STBC_SHIFT;
+		rx_status->flag |= RX_FLAG_HT;
+		rx_status->rate_idx = rate_n_flags & RATE_HT_MCS_INDEX_MSK;
+		rx_status->flag |= stbc << RX_FLAG_STBC_SHIFT;
 	} else if (rate_n_flags & RATE_MCS_VHT_MSK) {
 		u8 stbc = (rate_n_flags & RATE_MCS_VHT_STBC_MSK) >>
 				RATE_MCS_STBC_POS;
-		rx_status.vht_nss =
+		rx_status->vht_nss =
 			((rate_n_flags & RATE_VHT_MCS_NSS_MSK) >>
 						RATE_VHT_MCS_NSS_POS) + 1;
-		rx_status.rate_idx = rate_n_flags & RATE_VHT_MCS_RATE_CODE_MSK;
-		rx_status.flag |= RX_FLAG_VHT;
-		rx_status.flag |= stbc << RX_FLAG_STBC_SHIFT;
+		rx_status->rate_idx = rate_n_flags & RATE_VHT_MCS_RATE_CODE_MSK;
+		rx_status->flag |= RX_FLAG_VHT;
+		rx_status->flag |= stbc << RX_FLAG_STBC_SHIFT;
 		if (rate_n_flags & RATE_MCS_BF_MSK)
-			rx_status.vht_flag |= RX_VHT_FLAG_BF;
+			rx_status->vht_flag |= RX_VHT_FLAG_BF;
 	} else {
-		rx_status.rate_idx =
+		rx_status->rate_idx =
 			iwl_mvm_legacy_rate_to_mac80211_idx(rate_n_flags,
-							    rx_status.band);
+							    rx_status->band);
 	}
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	iwl_mvm_update_frame_stats(mvm, &mvm->drv_rx_stats, rate_n_flags,
-				   rx_status.flag & RX_FLAG_AMPDU_DETAILS);
+				   rx_status->flag & RX_FLAG_AMPDU_DETAILS);
 #endif
-	iwl_mvm_pass_packet_to_mac80211(mvm, hdr, len, ampdu_status,
-					rxb, &rx_status);
+	iwl_mvm_pass_packet_to_mac80211(mvm, skb, hdr, len, ampdu_status, rxb);
 	return 0;
 }
 
-- 
1.9.1

