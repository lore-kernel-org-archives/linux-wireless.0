Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:33715 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751466AbdIQTka (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 17 Sep 2017 15:40:30 -0400
Received: by mail-lf0-f68.google.com with SMTP id y15so3543572lfd.0
        for <linux-wireless@vger.kernel.org>; Sun, 17 Sep 2017 12:40:29 -0700 (PDT)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC v3 06/11] ath10k: htt: High latency RX support
Date: Sun, 17 Sep 2017 21:40:08 +0200
Message-Id: <20170917194013.8658-7-erik.stromdahl@gmail.com> (sfid-20170917_214037_490329_25EE7A47)
In-Reply-To: <20170917194013.8658-1-erik.stromdahl@gmail.com>
References: <20170917194013.8658-1-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Special HTT RX handling for high latency interfaces.

Since no DMA physical addresses are used in the RX ring
config message (this is not supported by the high latency
devices), no RX ring is allocated.
All RX skb's are allocated by the driver and passed directly
to mac80211 in the HTT RX indication handler.

A nice side effect of this is that no huge buffer will be
allocated with dma_alloc_coherent. On embedded systems with
limited memory resources, the allocation of the RX ring is
prone to fail.

Some tweaks made to "make it work":

Removal of protected bit in 802.11 header frame control field.
The chipset seems to do hw decryption but the frame_control
protected bit is still set.

This is necessary for mac80211 not to drop the frame.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/core.c    |  27 ++++---
 drivers/net/wireless/ath/ath10k/htt.h     |  47 ++++++++++++
 drivers/net/wireless/ath/ath10k/htt_rx.c  | 119 +++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/rx_desc.h |  15 ++++
 4 files changed, 195 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index c21227a74996..1880570989ae 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2083,10 +2083,12 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
 	ar->htt.rx_ring.in_ord_rx = !!(test_bit(WMI_SERVICE_RX_FULL_REORDER,
 						ar->wmi.svc_map));
 
-	status = ath10k_htt_rx_alloc(&ar->htt);
-	if (status) {
-		ath10k_err(ar, "failed to alloc htt rx: %d\n", status);
-		goto err_htt_tx_detach;
+	if (!ar->is_high_latency) {
+		status = ath10k_htt_rx_alloc(&ar->htt);
+		if (status) {
+			ath10k_err(ar, "failed to alloc htt rx: %d\n", status);
+			goto err_htt_tx_detach;
+		}
 	}
 
 	status = ath10k_hif_start(ar);
@@ -2203,10 +2205,13 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
 		}
 	}
 
-	status = ath10k_htt_rx_ring_refill(ar);
-	if (status) {
-		ath10k_err(ar, "failed to refill htt rx ring: %d\n", status);
-		goto err_hif_stop;
+	if (!ar->is_high_latency) {
+		status = ath10k_htt_rx_ring_refill(ar);
+		if (status) {
+			ath10k_err(ar, "failed to refill htt rx ring: %d\n",
+				   status);
+			goto err_hif_stop;
+		}
 	}
 
 	if (ar->max_num_vdevs >= 64)
@@ -2235,7 +2240,8 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
 err_hif_stop:
 	ath10k_hif_stop(ar);
 err_htt_rx_detach:
-	ath10k_htt_rx_free(&ar->htt);
+	if (!ar->is_high_latency)
+		ath10k_htt_rx_free(&ar->htt);
 err_htt_tx_detach:
 	ath10k_htt_tx_free(&ar->htt);
 err_wmi_detach:
@@ -2280,7 +2286,8 @@ void ath10k_core_stop(struct ath10k *ar)
 
 	ath10k_hif_stop(ar);
 	ath10k_htt_tx_stop(&ar->htt);
-	ath10k_htt_rx_free(&ar->htt);
+	if (!ar->is_high_latency)
+		ath10k_htt_rx_free(&ar->htt);
 	ath10k_wmi_detach(ar);
 	ar->is_started = false;
 }
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index bac453f5753e..ac5603ef4ba5 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -646,6 +646,15 @@ struct htt_rx_indication {
 	struct htt_rx_indication_mpdu_range mpdu_ranges[0];
 } __packed;
 
+/* High latency version of the RX indication */
+struct htt_rx_indication_hl {
+	struct htt_rx_indication_hdr hdr;
+	struct htt_rx_indication_ppdu ppdu;
+	struct htt_rx_indication_prefix prefix;
+	struct fw_rx_desc_hl fw_desc;
+	struct htt_rx_indication_mpdu_range mpdu_ranges[0];
+} __packed;
+
 static inline struct htt_rx_indication_mpdu_range *
 		htt_rx_ind_get_mpdu_ranges(struct htt_rx_indication *rx_ind)
 {
@@ -658,6 +667,18 @@ static inline struct htt_rx_indication_mpdu_range *
 	return ptr;
 }
 
+static inline struct htt_rx_indication_mpdu_range *
+	htt_rx_ind_get_mpdu_ranges_hl(struct htt_rx_indication_hl *rx_ind)
+{
+	void *ptr = rx_ind;
+
+	ptr += sizeof(rx_ind->hdr)
+	     + sizeof(rx_ind->ppdu)
+	     + sizeof(rx_ind->prefix)
+	     + sizeof(rx_ind->fw_desc);
+	return ptr;
+}
+
 enum htt_rx_flush_mpdu_status {
 	HTT_RX_FLUSH_MPDU_DISCARD = 0,
 	HTT_RX_FLUSH_MPDU_REORDER = 1,
@@ -1530,6 +1551,7 @@ struct htt_resp {
 		struct htt_mgmt_tx_completion mgmt_tx_completion;
 		struct htt_data_tx_completion data_tx_completion;
 		struct htt_rx_indication rx_ind;
+		struct htt_rx_indication_hl rx_ind_hl;
 		struct htt_rx_fragment_indication rx_frag_ind;
 		struct htt_rx_peer_map peer_map;
 		struct htt_rx_peer_unmap peer_unmap;
@@ -1754,6 +1776,31 @@ struct htt_rx_desc {
 	u8 msdu_payload[0];
 };
 
+#define HTT_RX_DESC_HL_INFO_SEQ_NUM_MASK           0x00000fff
+#define HTT_RX_DESC_HL_INFO_SEQ_NUM_LSB            0
+#define HTT_RX_DESC_HL_INFO_ENCRYPTED_MASK         0x00001000
+#define HTT_RX_DESC_HL_INFO_ENCRYPTED_LSB          12
+#define HTT_RX_DESC_HL_INFO_CHAN_INFO_PRESENT_MASK 0x00002000
+#define HTT_RX_DESC_HL_INFO_CHAN_INFO_PRESENT_LSB  13
+#define HTT_RX_DESC_HL_INFO_MCAST_BCAST_MASK       0x00008000
+#define HTT_RX_DESC_HL_INFO_MCAST_BCAST_LSB        15
+#define HTT_RX_DESC_HL_INFO_FRAGMENT_MASK          0x00010000
+#define HTT_RX_DESC_HL_INFO_FRAGMENT_LSB           16
+#define HTT_RX_DESC_HL_INFO_KEY_ID_OCT_MASK        0x01fe0000
+#define HTT_RX_DESC_HL_INFO_KEY_ID_OCT_LSB         17
+
+struct htt_rx_desc_base_hl {
+	__le32 info; /* HTT_RX_DESC_HL_INFO_ */
+};
+
+struct htt_rx_chan_info {
+	__le16 primary_chan_center_freq_mhz;
+	__le16 contig_chan1_center_freq_mhz;
+	__le16 contig_chan2_center_freq_mhz;
+	u8 phy_mode;
+	u8 reserved;
+} __packed;
+
 #define HTT_RX_DESC_ALIGN 8
 
 #define HTT_MAC_ADDR_LEN 6
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index a3f5dc78353f..7461555ccad5 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1590,8 +1590,116 @@ static int ath10k_htt_rx_handle_amsdu(struct ath10k_htt *htt)
 	return num_msdus;
 }
 
-static void ath10k_htt_rx_proc_rx_ind(struct ath10k_htt *htt,
-				      struct htt_rx_indication *rx)
+static bool ath10k_htt_rx_proc_rx_ind_hl(struct ath10k_htt *htt,
+					 struct htt_rx_indication_hl *rx,
+					 struct sk_buff *skb)
+{
+	struct ath10k *ar = htt->ar;
+	struct ath10k_peer *peer;
+	struct htt_rx_indication_mpdu_range *mpdu_ranges;
+	struct fw_rx_desc_hl *fw_desc;
+	struct ieee80211_hdr *hdr;
+	struct ieee80211_rx_status *rx_status;
+	u16 peer_id;
+	u8 rx_desc_len;
+	int num_mpdu_ranges;
+	size_t tot_hdr_len;
+	struct ieee80211_channel *ch;
+
+	peer_id = __le16_to_cpu(rx->hdr.peer_id);
+
+	peer = ath10k_peer_find_by_id(ar, peer_id);
+	if (!peer)
+		ath10k_warn(ar, "Got RX ind from invalid peer: %u\n", peer_id);
+
+	num_mpdu_ranges = MS(__le32_to_cpu(rx->hdr.info1),
+			     HTT_RX_INDICATION_INFO1_NUM_MPDU_RANGES);
+	mpdu_ranges = htt_rx_ind_get_mpdu_ranges_hl(rx);
+	fw_desc = &rx->fw_desc;
+	rx_desc_len = fw_desc->len;
+
+	/* I have not yet seen any case where num_mpdu_ranges > 1.
+	 * qcacld does not seem handle that case either, so we introduce the
+	 * same limitiation here as well.
+	 */
+	if (num_mpdu_ranges > 1)
+		ath10k_warn(ar,
+			    "Unsupported number of MPDU ranges: %d, ignoring all but the first\n",
+			    num_mpdu_ranges);
+
+	if (mpdu_ranges->mpdu_range_status !=
+	    HTT_RX_IND_MPDU_STATUS_OK) {
+		ath10k_warn(ar, "MPDU range status: %d\n",
+			    mpdu_ranges->mpdu_range_status);
+		goto err;
+	}
+
+	/* Strip off all headers before the MAC header before delivery to
+	 * mac80211
+	 */
+	tot_hdr_len = sizeof(struct htt_resp_hdr) + sizeof(rx->hdr) +
+		      sizeof(rx->ppdu) + sizeof(rx->prefix) +
+		      sizeof(rx->fw_desc) +
+		      sizeof(*mpdu_ranges) * num_mpdu_ranges + rx_desc_len;
+	skb_pull(skb, tot_hdr_len);
+
+	hdr = (struct ieee80211_hdr *)skb->data;
+	rx_status = IEEE80211_SKB_RXCB(skb);
+	rx_status->chains |= BIT(0);
+	rx_status->signal = ATH10K_DEFAULT_NOISE_FLOOR +
+			    rx->ppdu.combined_rssi;
+	rx_status->flag &= ~RX_FLAG_NO_SIGNAL_VAL;
+
+	spin_lock_bh(&ar->data_lock);
+	ch = ar->scan_channel;
+	if (!ch)
+		ch = ar->rx_channel;
+	if (!ch)
+		ch = ath10k_htt_rx_h_any_channel(ar);
+	if (!ch)
+		ch = ar->tgt_oper_chan;
+	spin_unlock_bh(&ar->data_lock);
+
+	if (ch) {
+		rx_status->band = ch->band;
+		rx_status->freq = ch->center_freq;
+	}
+	if (rx->fw_desc.flags & FW_RX_DESC_FLAGS_LAST_MSDU)
+		rx_status->flag &= ~RX_FLAG_AMSDU_MORE;
+	else
+		rx_status->flag |= RX_FLAG_AMSDU_MORE;
+
+	/* Not entirely sure about this, but all frames from the chipset has
+	 * the protected flag set even though they have already been decrypted.
+	 * Unmasking this flag is necessary in order for mac80211 not to drop
+	 * the frame.
+	 * TODO: Verify this is always the case or find out a way to check
+	 * if there has been hw decryption.
+	 */
+	if (ieee80211_has_protected(hdr->frame_control)) {
+		hdr->frame_control &= ~__cpu_to_le16(IEEE80211_FCTL_PROTECTED);
+		rx_status->flag |= RX_FLAG_DECRYPTED |
+				   RX_FLAG_IV_STRIPPED |
+				   RX_FLAG_MMIC_STRIPPED;
+	}
+
+	local_bh_disable();
+	ieee80211_rx(ar->hw, skb);
+	local_bh_enable();
+
+	/* We have delivered the skb to the upper layers (mac80211) so we
+	 * must not free it.
+	 */
+	return false;
+err:
+	/* Tell the caller that it must free the skb since we have not
+	 * consumed it
+	 */
+	return true;
+}
+
+static void ath10k_htt_rx_proc_rx_ind_ll(struct ath10k_htt *htt,
+					 struct htt_rx_indication *rx)
 {
 	struct ath10k *ar = htt->ar;
 	struct htt_rx_indication_mpdu_range *mpdu_ranges;
@@ -2383,7 +2491,12 @@ bool ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 		break;
 	}
 	case HTT_T2H_MSG_TYPE_RX_IND:
-		ath10k_htt_rx_proc_rx_ind(htt, &resp->rx_ind);
+		if (ar->is_high_latency)
+			return ath10k_htt_rx_proc_rx_ind_hl(htt,
+							    &resp->rx_ind_hl,
+							    skb);
+		else
+			ath10k_htt_rx_proc_rx_ind_ll(htt, &resp->rx_ind);
 		break;
 	case HTT_T2H_MSG_TYPE_PEER_MAP: {
 		struct htt_peer_map_event ev = {
diff --git a/drivers/net/wireless/ath/ath10k/rx_desc.h b/drivers/net/wireless/ath/ath10k/rx_desc.h
index c1022a1cf855..76b2fe51ddac 100644
--- a/drivers/net/wireless/ath/ath10k/rx_desc.h
+++ b/drivers/net/wireless/ath/ath10k/rx_desc.h
@@ -1222,4 +1222,19 @@ struct fw_rx_desc_base {
 	u8 info0;
 } __packed;
 
+#define FW_RX_DESC_FLAGS_FIRST_MSDU (1 << 0)
+#define FW_RX_DESC_FLAGS_LAST_MSDU  (1 << 1)
+#define FW_RX_DESC_C3_FAILED        (1 << 2)
+#define FW_RX_DESC_C4_FAILED        (1 << 3)
+#define FW_RX_DESC_IPV6             (1 << 4)
+#define FW_RX_DESC_TCP              (1 << 5)
+#define FW_RX_DESC_UDP              (1 << 6)
+
+struct fw_rx_desc_hl {
+	u8 info0;
+	u8 version;
+	u8 len;
+	u8 flags;
+} __packed;
+
 #endif /* _RX_DESC_H_ */
-- 
2.14.1
