Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:38807 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751202AbdI3Ri3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 30 Sep 2017 13:38:29 -0400
Received: by mail-pf0-f193.google.com with SMTP id a7so1758460pfj.5
        for <linux-wireless@vger.kernel.org>; Sat, 30 Sep 2017 10:38:28 -0700 (PDT)
From: silexcommon@gmail.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Alagu Sankar <alagusankar@silex-india.com>
Subject: [PATCH 01/11] ath10k_sdio: sdio htt data transfer fixes
Date: Sat, 30 Sep 2017 23:07:38 +0530
Message-Id: <1506793068-27445-2-git-send-email-alagusankar@silex-india.com> (sfid-20170930_193754_250537_7239156C)
In-Reply-To: <1506793068-27445-1-git-send-email-alagusankar@silex-india.com>
References: <1506793068-27445-1-git-send-email-alagusankar@silex-india.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alagu Sankar <alagusankar@silex-india.com>

The ath10k sdio firmware does not allow transmitting packets with the
reduced tx completion HI_ACS option. sdio firmware uses 1544 as
alternate credit size, which is not big enough for the maximum sized
mac80211 frames. Disable both these HI_ACS flags for SDIO.

Transmit completion for SDIO is similar to PCIe, via the T2H message
HTT_T2H_MSG_TYPE_TX_COMPL_IND.  Modify the high latency path to allow
SDIO modules to use the htt transmit completion path. This differs from
the high latency path taken by the USB devices.

Signed-off-by: Alagu Sankar <alagusankar@silex-india.com>
---
 drivers/net/wireless/ath/ath10k/core.c   | 20 +++++++++++++++++---
 drivers/net/wireless/ath/ath10k/htt_rx.c |  6 ++++--
 drivers/net/wireless/ath/ath10k/htt_tx.c | 24 +++++++++++++++++++-----
 3 files changed, 40 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 4351341..b4f66cd 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -494,11 +494,25 @@ static void ath10k_init_sdio(struct ath10k *ar)
 	ath10k_bmi_write32(ar, hi_mbox_isr_yield_limit, 99);
 	ath10k_bmi_read32(ar, hi_acs_flags, &param);
 
-	param |= (HI_ACS_FLAGS_SDIO_SWAP_MAILBOX_SET |
-		  HI_ACS_FLAGS_SDIO_REDUCE_TX_COMPL_SET |
-		  HI_ACS_FLAGS_ALT_DATA_CREDIT_SIZE);
+	/* Data transfer is not initiated, when reduced Tx completion
+	 * is used for SDIO. disable it until fixed
+	 */
+	param &= ~HI_ACS_FLAGS_SDIO_REDUCE_TX_COMPL_SET;
+
+	/* Alternate credit size of 1544 as used by SDIO firmware is
+	 * not big enough for mac80211 / native wifi frames. disable it
+	 */
+	param &= ~HI_ACS_FLAGS_ALT_DATA_CREDIT_SIZE;
 
+	param |= HI_ACS_FLAGS_SDIO_SWAP_MAILBOX_SET;
 	ath10k_bmi_write32(ar, hi_acs_flags, param);
+
+	/* Explicitly set fwlog prints to zero as target may turn it on
+	 * based on scratch registers.
+	 */
+	ath10k_bmi_read32(ar, hi_option_flag, &param);
+	param |= HI_OPTION_DISABLE_DBGLOG;
+	ath10k_bmi_write32(ar, hi_option_flag, param);
 }
 
 static int ath10k_init_configure_target(struct ath10k *ar)
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 569edd0..f025363 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1764,7 +1764,9 @@ static void ath10k_htt_rx_tx_compl_ind(struct ath10k *ar,
 		 *  Note that with only one concurrent reader and one concurrent
 		 *  writer, you don't need extra locking to use these macro.
 		 */
-		if (!kfifo_put(&htt->txdone_fifo, tx_done)) {
+		if (ar->hif.bus == ATH10K_BUS_SDIO) {
+			ath10k_txrx_tx_unref(htt, &tx_done);
+		} else if (!kfifo_put(&htt->txdone_fifo, tx_done)) {
 			ath10k_warn(ar, "txdone fifo overrun, msdu_id %d status %d\n",
 				    tx_done.msdu_id, tx_done.status);
 			ath10k_txrx_tx_unref(htt, &tx_done);
@@ -2541,7 +2543,7 @@ bool ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 		break;
 	}
 	case HTT_T2H_MSG_TYPE_TX_COMPL_IND:
-		if (!ar->is_high_latency)
+		if (!(ar->hif.bus == ATH10K_BUS_USB))
 			ath10k_htt_rx_tx_compl_ind(htt->ar, skb);
 		break;
 	case HTT_T2H_MSG_TYPE_SEC_IND: {
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index c74fc13..d7f59a2 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -153,7 +153,7 @@ void ath10k_htt_tx_txq_update(struct ieee80211_hw *hw,
 
 void ath10k_htt_tx_dec_pending(struct ath10k_htt *htt)
 {
-	if (htt->ar->is_high_latency)
+	if (htt->ar->hif.bus == ATH10K_BUS_USB)
 		return;
 
 	lockdep_assert_held(&htt->tx_lock);
@@ -165,7 +165,7 @@ void ath10k_htt_tx_dec_pending(struct ath10k_htt *htt)
 
 int ath10k_htt_tx_inc_pending(struct ath10k_htt *htt)
 {
-	if (htt->ar->is_high_latency)
+	if (htt->ar->hif.bus == ATH10K_BUS_USB)
 		return 0;
 
 	lockdep_assert_held(&htt->tx_lock);
@@ -454,7 +454,7 @@ void ath10k_htt_tx_destroy(struct ath10k_htt *htt)
 		return;
 
 	ath10k_htt_tx_free_cont_txbuf(htt);
-	if (!htt->ar->is_high_latency)
+	if (!(htt->ar->hif.bus == ATH10K_BUS_USB))
 		ath10k_htt_tx_free_txq(htt);
 	ath10k_htt_tx_free_cont_frag_desc(htt);
 	ath10k_htt_tx_free_txdone_fifo(htt);
@@ -475,7 +475,8 @@ void ath10k_htt_tx_free(struct ath10k_htt *htt)
 
 void ath10k_htt_htc_tx_complete(struct ath10k *ar, struct sk_buff *skb)
 {
-	dev_kfree_skb_any(skb);
+	if (!(ar->hif.bus == ATH10K_BUS_SDIO))
+		dev_kfree_skb_any(skb);
 }
 
 void ath10k_htt_hif_tx_complete(struct ath10k *ar, struct sk_buff *skb)
@@ -975,6 +976,7 @@ int ath10k_htt_tx_hl(struct ath10k_htt *htt, enum ath10k_hw_txrx_mode txmode,
 	u8 tid = ath10k_htt_tx_get_tid(msdu, is_eth);
 	u8 flags0 = 0;
 	u16 flags1 = 0;
+	u16 msdu_id = 0;
 
 	data_len = msdu->len;
 
@@ -1022,6 +1024,18 @@ int ath10k_htt_tx_hl(struct ath10k_htt *htt, enum ath10k_hw_txrx_mode txmode,
 		}
 	}
 
+	if (ar->hif.bus == ATH10K_BUS_SDIO) {
+		flags1 |= HTT_DATA_TX_DESC_FLAGS1_POSTPONED;
+		spin_lock_bh(&htt->tx_lock);
+		res = ath10k_htt_tx_alloc_msdu_id(htt, msdu);
+		spin_unlock_bh(&htt->tx_lock);
+		if (res < 0) {
+			ath10k_err(ar, "msdu_id allocation failed %d\n", res);
+			goto out;
+		}
+		msdu_id = res;
+	}
+
 	skb_push(msdu, sizeof(*cmd_hdr));
 	skb_push(msdu, sizeof(*tx_desc));
 	cmd_hdr = (struct htt_cmd_hdr *)msdu->data;
@@ -1031,7 +1045,7 @@ int ath10k_htt_tx_hl(struct ath10k_htt *htt, enum ath10k_hw_txrx_mode txmode,
 	tx_desc->flags0 = flags0;
 	tx_desc->flags1 = __cpu_to_le16(flags1);
 	tx_desc->len = __cpu_to_le16(data_len);
-	tx_desc->id = 0;
+	tx_desc->id = __cpu_to_le16(msdu_id);
 	tx_desc->frags_paddr = 0; /* always zero */
 	/* Initialize peer_id to INVALID_PEER because this is NOT
 	 * Reinjection path
-- 
1.9.1
