Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:53951 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbcEKRCo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2016 13:02:44 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 14/21] ath10k: Add tx/rx bytes, cycle counters to ethtool stats.
Date: Wed, 11 May 2016 10:02:26 -0700
Message-Id: <1462986153-16318-15-git-send-email-greearb@candelatech.com> (sfid-20160511_192230_405095_9386F058)
In-Reply-To: <1462986153-16318-1-git-send-email-greearb@candelatech.com>
References: <1462986153-16318-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

The firmware does not offer tx/rx bytes counters, so just keep track of
it in the driver.

For the cycle counters:

Note these counters are since the chip reset, though the counters
wrap often.  When cycle-counters counter overflows on
certain hardware, it will right shift all 4 of the
related registers to the right by one bit (basically,
divide by two).  Since you have no idea what the others
were at when cycle-counter wrapped, you must simply
ignore any sample where cycle-counter wraps, and set
new baseline values to calculate diffs against next
time.

Hardware with this funny wrap logic will cause the
d_flags 'counter' to have bit 0x1 set, so that is how
user-space can know how to deal with this.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/core.h   |  3 +++
 drivers/net/wireless/ath/ath10k/debug.c  | 22 +++++++++++++++++-----
 drivers/net/wireless/ath/ath10k/htt_rx.c |  3 +++
 drivers/net/wireless/ath/ath10k/htt_tx.c | 22 +++++++++++++++++-----
 4 files changed, 40 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 91b1f95..cb6aa8c 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -466,6 +466,9 @@ struct ath10k_debug {
 	struct ath10k_dbglog_entry_storage dbglog_entry_data;
 
 	struct ath10k_fw_crash_data *fw_crash_data;
+
+	u64 tx_bytes; /* counter, firmware does not offer this stat */
+	u64 rx_bytes; /* counter, firmware does not offer this stat */
 };
 
 enum ath10k_state {
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 05b5ea4..a3da6ab 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -1496,11 +1496,15 @@ exit:
 /* This generally cooresponds to the debugfs fw_stats file */
 static const char ath10k_gstrings_stats[][ETH_GSTRING_LEN] = {
 	"tx_pkts_nic",
-	"tx_bytes_nic",
+	"tx_bytes_nic", /* from driver, firmware does not keep this stat. */
 	"rx_pkts_nic",
-	"rx_bytes_nic",
+	"rx_bytes_nic", /* from driver, firmware does not keep this stat. */
 	"d_noise_floor",
-	"d_cycle_count",
+	"d_cycle_count", /* this is duty cycle counter, basically channel-time. 88MHz clock */
+	"d_tx_cycle_count", /* tx cycle count */
+	"d_rx_cycle_count", /* rx cycle count */
+	"d_busy_count", /* Total channel busy time cycles (called 'clear' by firmware) */
+	"d_flags", /* 0x1:  hw has shifted cycle-count wrap, see ath10k_hw_fill_survey_time */
 	"d_phy_error",
 	"d_rts_bad",
 	"d_rts_good",
@@ -1572,6 +1576,7 @@ void ath10k_debug_get_et_stats(struct ieee80211_hw *hw,
 	static const struct ath10k_fw_stats_pdev zero_stats = {};
 	const struct ath10k_fw_stats_pdev *pdev_stats;
 	int i = 0, ret;
+	u64 d_flags = 0;
 
 	mutex_lock(&ar->conf_mutex);
 
@@ -1595,12 +1600,19 @@ void ath10k_debug_get_et_stats(struct ieee80211_hw *hw,
 
 	spin_lock_bh(&ar->data_lock);
 
+	if (ar->hw_params.has_shifted_cc_wraparound)
+		d_flags |= 0x1;
+
 	data[i++] = pdev_stats->hw_reaped; /* ppdu reaped */
-	data[i++] = 0; /* tx bytes */
+	data[i++] = ar->debug.tx_bytes;
 	data[i++] = pdev_stats->htt_mpdus;
-	data[i++] = 0; /* rx bytes */
+	data[i++] = ar->debug.rx_bytes;
 	data[i++] = pdev_stats->ch_noise_floor;
 	data[i++] = pdev_stats->cycle_count;
+	data[i++] = pdev_stats->tx_frame_count;
+	data[i++] = pdev_stats->rx_frame_count;
+	data[i++] = pdev_stats->rx_clear_count; /* yes, this appears to actually be 'busy' count */
+	data[i++] = d_flags; /* give user-space a chance to decode cycle counters */
 	data[i++] = pdev_stats->phy_err_count;
 	data[i++] = pdev_stats->rts_bad;
 	data[i++] = pdev_stats->rts_good;
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index cc979a4..47da904 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1379,6 +1379,9 @@ static void ath10k_htt_rx_h_mpdu(struct ath10k *ar,
 }
 
 	skb_queue_walk(amsdu, msdu) {
+#ifdef CONFIG_ATH10K_DEBUGFS
+		ar->debug.rx_bytes += msdu->len;
+#endif
 		ath10k_htt_rx_h_csum_offload(msdu);
 		ath10k_htt_rx_h_undecap(ar, msdu, status, first_hdr, enctype,
 					is_decrypted);
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 6269c61..06ec995 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -769,6 +769,7 @@ int ath10k_htt_mgmt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	int len = 0;
 	int msdu_id = -1;
 	int res;
+	int skb_len;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)msdu->data;
 
 	len += sizeof(cmd->hdr);
@@ -795,7 +796,8 @@ int ath10k_htt_mgmt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 		goto err_free_msdu_id;
 	}
 
-	skb_cb->paddr = dma_map_single(dev, msdu->data, msdu->len,
+	skb_len = msdu->len;
+	skb_cb->paddr = dma_map_single(dev, msdu->data, skb_len,
 				       DMA_TO_DEVICE);
 	res = dma_mapping_error(dev, skb_cb->paddr);
 	if (res) {
@@ -809,16 +811,20 @@ int ath10k_htt_mgmt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 
 	cmd->hdr.msg_type         = HTT_H2T_MSG_TYPE_MGMT_TX;
 	cmd->mgmt_tx.msdu_paddr = __cpu_to_le32(ATH10K_SKB_CB(msdu)->paddr);
-	cmd->mgmt_tx.len        = __cpu_to_le32(msdu->len);
+	cmd->mgmt_tx.len        = __cpu_to_le32(skb_len);
 	cmd->mgmt_tx.desc_id    = __cpu_to_le32(msdu_id);
 	cmd->mgmt_tx.vdev_id    = __cpu_to_le32(vdev_id);
 	memcpy(cmd->mgmt_tx.hdr, msdu->data,
-	       min_t(int, msdu->len, HTT_MGMT_FRM_HDR_DOWNLOAD_LEN));
+	       min_t(int, skb_len, HTT_MGMT_FRM_HDR_DOWNLOAD_LEN));
 
 	res = ath10k_htc_send(&htt->ar->htc, htt->eid, txdesc);
 	if (res)
 		goto err_unmap_msdu;
 
+#ifdef CONFIG_ATH10K_DEBUGFS
+	ar->debug.tx_bytes += skb_len;
+#endif
+
 	return 0;
 
 err_unmap_msdu:
@@ -852,6 +858,7 @@ int ath10k_htt_tx(struct ath10k_htt *htt, enum ath10k_hw_txrx_mode txmode,
 	u8 flags0 = 0;
 	u16 msdu_id, flags1 = 0;
 	u16 freq = 0;
+	int skb_len;
 	u32 frags_paddr = 0;
 	u32 txbuf_paddr;
 	struct htt_msdu_ext_desc *ext_desc = NULL;
@@ -990,13 +997,14 @@ int ath10k_htt_tx(struct ath10k_htt *htt, enum ath10k_hw_txrx_mode txmode,
 				__cpu_to_le32(HTT_INVALID_PEERID);
 	}
 
+	skb_len = msdu->len;
 	trace_ath10k_htt_tx(ar, msdu_id, msdu->len, vdev_id, tid);
 	ath10k_dbg(ar, ATH10K_DBG_HTT,
 		   "htt tx flags0 %hhu flags1 %hu len %d id %hu frags_paddr %08x, msdu_paddr %08x vdev %hhu tid %hhu freq %hu\n",
-		   flags0, flags1, msdu->len, msdu_id, frags_paddr,
+		   flags0, flags1, skb_len, msdu_id, frags_paddr,
 		   (u32)skb_cb->paddr, vdev_id, tid, freq);
 	ath10k_dbg_dump(ar, ATH10K_DBG_HTT_DUMP, NULL, "htt tx msdu: ",
-			msdu->data, msdu->len);
+			msdu->data, skb_len);
 	trace_ath10k_tx_hdr(ar, msdu->data, msdu->len);
 	trace_ath10k_tx_payload(ar, msdu->data, msdu->len);
 
@@ -1021,6 +1029,10 @@ int ath10k_htt_tx(struct ath10k_htt *htt, enum ath10k_hw_txrx_mode txmode,
 	if (res)
 		goto err_unmap_msdu;
 
+#ifdef CONFIG_ATH10K_DEBUGFS
+	ar->debug.tx_bytes += skb_len;
+#endif
+
 	return 0;
 
 err_unmap_msdu:
-- 
2.4.3

