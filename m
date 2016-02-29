Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:45126 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbcB2Vu7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 16:50:59 -0500
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath10k:  Fix mgmt tx status for 10.4.3 firmware.
Date: Mon, 29 Feb 2016 13:50:54 -0800
Message-Id: <1456782654-24723-1-git-send-email-greearb@candelatech.com> (sfid-20160229_225102_667448_86CAB317)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

When testing a 10.4.3 firmware in station mode, I notice that
when the AP is powered down, the ath10k does not notice AP is gone
because mgt frames get tx status of 3, which is not handled.

It appears that status 3 means something similar to failed-retry.

Treating it thus lets the station disconnect properly.

Tested against a non-stock 10.4.3 firmware, but likely upstream
firmware acts similarly in this case.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

This patch is against a heavily patched tree based on 4.4, hopefully
it can be applied to upstream code w/out too much trouble.

Someone should verify this on stock 10.4-ish firmware before applying.

 drivers/net/wireless/ath/ath10k/htt.h    |  4 +++-
 drivers/net/wireless/ath/ath10k/htt_rx.c | 11 +++++++++--
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index c31a31f..de663a6 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -309,7 +309,9 @@ struct htt_mgmt_tx_desc {
 enum htt_mgmt_tx_status {
 	HTT_MGMT_TX_STATUS_OK    = 0,
 	HTT_MGMT_TX_STATUS_RETRY = 1,
-	HTT_MGMT_TX_STATUS_DROP  = 2
+	HTT_MGMT_TX_STATUS_DROP  = 2,
+	HTT_MGMT_TX_STATUS_TXFILT = 3 /* Seems to be logically similar to
+					 RETRY failure. */
 };
 
 /*=== target -> host messages ===============================================*/
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 2953aa7..88918ab 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1721,8 +1721,10 @@ static void ath10k_htt_rx_frm_tx_compl(struct ath10k *ar,
 		break;
 	}
 
-	ath10k_dbg(ar, ATH10K_DBG_HTT, "htt tx completion num_msdus %d\n",
-		   resp->data_tx_completion.num_msdus);
+	ath10k_dbg(ar, ATH10K_DBG_HTT,
+		   "htt tx completion num_msdus %d status: %d  discard: %d  no-ack: %d\n",
+		   resp->data_tx_completion.num_msdus, status,
+		   (int)tx_done.discard, (int)tx_done.no_ack);
 
 	if (test_bit(ATH10K_FW_FEATURE_TXRATE_CT, ar->fw_features) &&
 	    ar->wmi.op_version != ATH10K_FW_WMI_OP_VERSION_10_4) {
@@ -2406,6 +2408,7 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 			tx_done.success = true;
 			break;
 		case HTT_MGMT_TX_STATUS_RETRY:
+		case HTT_MGMT_TX_STATUS_TXFILT:
 			tx_done.no_ack = true;
 			break;
 		case HTT_MGMT_TX_STATUS_DROP:
@@ -2413,6 +2416,10 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 			break;
 		}
 
+		ath10k_dbg(ar, ATH10K_DBG_HTT,
+			   "mgmt-tx-completion, status: %d  discard: %d  no-ack: %d\n",
+			   status, (int)tx_done.discard, (int)tx_done.no_ack);
+
 		ath10k_txrx_tx_unref(htt, &tx_done);
 		ath10k_mac_tx_push_pending(ar);
 		break;
-- 
2.4.3

