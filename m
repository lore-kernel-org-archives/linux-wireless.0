Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37681 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244Ab3APN6S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 08:58:18 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 6/6] iwlwifi: improve the reports in TX path
Date: Wed, 16 Jan 2013 14:58:39 +0100
Message-Id: <1358344719-26486-6-git-send-email-johannes@sipsolutions.net> (sfid-20130116_145827_541149_D1DE13DD)
In-Reply-To: <1358344719-26486-1-git-send-email-johannes@sipsolutions.net>
References: <1358344682.22862.4.camel@jlt4.sipsolutions.net>
 <1358344719-26486-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Also when things go wrong (queues don't get emtpy), try to
get some data from the HW.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/mac80211.c |  3 --
 drivers/net/wireless/iwlwifi/dvm/tx.c       | 28 +++++++++++--------
 drivers/net/wireless/iwlwifi/pcie/trans.c   | 43 ++++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/pcie/tx.c      |  7 ++---
 4 files changed, 61 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index fef17c1..2da2627 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -521,9 +521,6 @@ static void iwlagn_mac_tx(struct ieee80211_hw *hw,
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 
-	IWL_DEBUG_TX(priv, "dev->xmit(%d bytes) at rate 0x%02x\n", skb->len,
-		     ieee80211_get_tx_rate(hw, IEEE80211_SKB_CB(skb))->bitrate);
-
 	if (iwlagn_tx_skb(priv, control->sta, skb))
 		ieee80211_free_txskb(hw, skb);
 }
diff --git a/drivers/net/wireless/iwlwifi/dvm/tx.c b/drivers/net/wireless/iwlwifi/dvm/tx.c
index df76881..b0aad71 100644
--- a/drivers/net/wireless/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tx.c
@@ -231,13 +231,11 @@ static void iwlagn_tx_cmd_build_hwcrypto(struct iwl_priv *priv,
 		memcpy(tx_cmd->key, keyconf->key, keyconf->keylen);
 		if (info->flags & IEEE80211_TX_CTL_AMPDU)
 			tx_cmd->tx_flags |= TX_CMD_FLG_AGG_CCMP_MSK;
-		IWL_DEBUG_TX(priv, "tx_cmd with AES hwcrypto\n");
 		break;
 
 	case WLAN_CIPHER_SUITE_TKIP:
 		tx_cmd->sec_ctl = TX_CMD_SEC_TKIP;
 		ieee80211_get_tkip_p2k(keyconf, skb_frag, tx_cmd->key);
-		IWL_DEBUG_TX(priv, "tx_cmd with tkip hwcrypto\n");
 		break;
 
 	case WLAN_CIPHER_SUITE_WEP104:
@@ -355,8 +353,6 @@ int iwlagn_tx_skb(struct iwl_priv *priv,
 		}
 	}
 
-	IWL_DEBUG_TX(priv, "station Id %d\n", sta_id);
-
 	if (sta)
 		sta_priv = (void *)sta->drv_priv;
 
@@ -472,6 +468,9 @@ int iwlagn_tx_skb(struct iwl_priv *priv,
 	WARN_ON_ONCE(is_agg &&
 		     priv->queue_to_mac80211[txq_id] != info->hw_queue);
 
+	IWL_DEBUG_TX(priv, "TX to [%d|%d] Q:%d - seq: 0x%x\n", sta_id, tid,
+		     txq_id, seq_number);
+
 	if (iwl_trans_tx(priv->trans, skb, dev_cmd, txq_id))
 		goto drop_unlock_sta;
 
@@ -953,12 +952,6 @@ static void iwl_rx_reply_tx_agg(struct iwl_priv *priv,
 		if (status & (AGG_TX_STATE_FEW_BYTES_MSK |
 			      AGG_TX_STATE_ABORT_MSK))
 			continue;
-
-		IWL_DEBUG_TX_REPLY(priv, "status %s (0x%08x), "
-				   "try-count (0x%08x)\n",
-				   iwl_get_agg_tx_fail_reason(fstatus),
-				   fstatus & AGG_TX_STATUS_MSK,
-				   fstatus & AGG_TX_TRY_MSK);
 	}
 }
 
@@ -1212,16 +1205,27 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
 			freed++;
 		}
 
-		WARN_ON(!is_agg && freed != 1);
+		if (!is_agg && freed != 1)
+			IWL_ERR(priv, "Q: %d, freed %d\n", txq_id, freed);
 
 		/*
 		 * An offchannel frame can be send only on the AUX queue, where
 		 * there is no aggregation (and reordering) so it only is single
 		 * skb is expected to be processed.
 		 */
-		WARN_ON(is_offchannel_skb && freed != 1);
+		if (is_offchannel_skb && freed != 1)
+			IWL_ERR(priv, "OFFCHANNEL SKB freed %d\n", freed);
 	}
 
+	IWL_DEBUG_TX_REPLY(priv, "TXQ %d status %s (0x%08x)\n", txq_id,
+			   iwl_get_tx_fail_reason(status), status);
+
+	IWL_DEBUG_TX_REPLY(priv,
+			   "\t\t\t\tinitial_rate 0x%x retries %d, idx=%d ssn=%d seq_ctl=0x%x\n",
+			   le32_to_cpu(tx_resp->rate_n_flags),
+			   tx_resp->failure_frame, SEQ_TO_INDEX(sequence), ssn,
+			   le16_to_cpu(tx_resp->seq_ctl));
+
 	iwl_check_abort_status(priv, tx_resp->frame_count, status);
 	spin_unlock(&priv->sta_lock);
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 59340ff..c57641e 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -890,6 +890,8 @@ static int iwl_trans_pcie_wait_txq_empty(struct iwl_trans *trans)
 	struct iwl_queue *q;
 	int cnt;
 	unsigned long now = jiffies;
+	u32 scd_sram_addr;
+	u8 buf[16];
 	int ret = 0;
 
 	/* waiting for all the tx frames complete might take a while */
@@ -903,11 +905,50 @@ static int iwl_trans_pcie_wait_txq_empty(struct iwl_trans *trans)
 			msleep(1);
 
 		if (q->read_ptr != q->write_ptr) {
-			IWL_ERR(trans, "fail to flush all tx fifo queues\n");
+			IWL_ERR(trans,
+				"fail to flush all tx fifo queues Q %d\n", cnt);
 			ret = -ETIMEDOUT;
 			break;
 		}
 	}
+
+	if (!ret)
+		return 0;
+
+	IWL_ERR(trans, "Current SW read_ptr %d write_ptr %d\n",
+		txq->q.read_ptr, txq->q.write_ptr);
+
+	scd_sram_addr = trans_pcie->scd_base_addr +
+			SCD_TX_STTS_QUEUE_OFFSET(txq->q.id);
+	iwl_trans_read_mem_bytes(trans, scd_sram_addr, buf, sizeof(buf));
+
+	iwl_print_hex_error(trans, buf, sizeof(buf));
+
+	for (cnt = 0; cnt < FH_TCSR_CHNL_NUM; cnt++)
+		IWL_ERR(trans, "FH TRBs(%d) = 0x%08x\n", cnt,
+			iwl_read_direct32(trans, FH_TX_TRB_REG(cnt)));
+
+	for (cnt = 0; cnt < trans->cfg->base_params->num_of_queues; cnt++) {
+		u32 status = iwl_read_prph(trans, SCD_QUEUE_STATUS_BITS(cnt));
+		u8 fifo = (status >> SCD_QUEUE_STTS_REG_POS_TXF) & 0x7;
+		bool active = !!(status & BIT(SCD_QUEUE_STTS_REG_POS_ACTIVE));
+		u32 tbl_dw =
+			iwl_trans_read_mem32(trans, trans_pcie->scd_base_addr +
+					     SCD_TRANS_TBL_OFFSET_QUEUE(cnt));
+
+		if (cnt & 0x1)
+			tbl_dw = (tbl_dw & 0xFFFF0000) >> 16;
+		else
+			tbl_dw = tbl_dw & 0x0000FFFF;
+
+		IWL_ERR(trans,
+			"Q %d is %sactive and mapped to fifo %d ra_tid 0x%04x [%d,%d]\n",
+			cnt, active ? "" : "in", fifo, tbl_dw,
+			iwl_read_prph(trans,
+				      SCD_QUEUE_RDPTR(cnt)) & (txq->q.n_bd - 1),
+			iwl_read_prph(trans, SCD_QUEUE_WRPTR(cnt)));
+	}
+
 	return ret;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index fd3280f..a93f067 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -309,6 +309,9 @@ void iwl_pcie_txq_inc_wr_ptr(struct iwl_trans *trans, struct iwl_txq *txq)
 				return;
 			}
 
+			IWL_DEBUG_TX(trans, "Q:%d WR: 0x%x\n", txq_id,
+				     txq->q.write_ptr);
+
 			iwl_write_direct32(trans, HBUS_TARG_WRPTR,
 				     txq->q.write_ptr | (txq_id << 8));
 
@@ -1660,10 +1663,6 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	tx_cmd->dram_lsb_ptr = cpu_to_le32(scratch_phys);
 	tx_cmd->dram_msb_ptr = iwl_get_dma_hi_addr(scratch_phys);
 
-	IWL_DEBUG_TX(trans, "sequence nr = 0X%x\n",
-		     le16_to_cpu(dev_cmd->hdr.sequence));
-	IWL_DEBUG_TX(trans, "tx_flags = 0X%x\n", le32_to_cpu(tx_cmd->tx_flags));
-
 	/* Set up entry for this TFD in Tx byte-count array */
 	iwl_pcie_txq_update_byte_cnt_tbl(trans, txq, le16_to_cpu(tx_cmd->len));
 
-- 
1.8.0

