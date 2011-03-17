Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65082 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173Ab1CQS7S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2011 14:59:18 -0400
Received: by mail-iy0-f174.google.com with SMTP id 26so3126341iyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2011 11:59:18 -0700 (PDT)
From: Brian Cavagnolo <brian@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: buytenh@wantstofly.org, Nishant Sarmukadam <nishants@marvell.com>,
	Brian Cavagnolo <brian@cozybit.com>
Subject: [PATCH 6/9] mwl8k: Initiate BA sessions
Date: Thu, 17 Mar 2011 11:58:46 -0700
Message-Id: <1300388329-15380-6-git-send-email-brian@cozybit.com>
In-Reply-To: <1300388329-15380-1-git-send-email-brian@cozybit.com>
References: <1300388329-15380-1-git-send-email-brian@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Nishant Sarmukadam <nishants@marvell.com>

Specifically, handle ampdu_action and attempt to start a BA
session on receiving the first qos packet from mac80211 for
transmission to a HT sta.  While the BA session is being created,
all the packets belonging to that stream will be dropped to
prevent sequence number mismatch at the recipient.

Contains contributions from:
Yogesh Powar <yogeshp@marvell.com>
Pradeep Nemavat <pnemavat@marvell.com>
Brian Cavagnolo <brian@cozybit.com>

Signed-off-by: Brian Cavagnolo <brian@cozybit.com>
---
 drivers/net/wireless/mwl8k.c |  194 ++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 187 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index dcd4508..ec1190a 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1577,7 +1577,8 @@ mwl8k_txq_reclaim(struct ieee80211_hw *hw, int index, int limit, int force)
 		processed++;
 	}
 
-	if (processed && priv->radio_on && !mutex_is_locked(&priv->fw_mutex))
+	if (index < MWL8K_TX_WMM_QUEUES && processed && priv->radio_on &&
+	    !mutex_is_locked(&priv->fw_mutex))
 		ieee80211_wake_queue(hw, index);
 
 	return processed;
@@ -1677,6 +1678,7 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 	struct mwl8k_priv *priv = hw->priv;
 	struct ieee80211_tx_info *tx_info;
 	struct mwl8k_vif *mwl8k_vif;
+	struct ieee80211_sta *sta;
 	struct ieee80211_hdr *wh;
 	struct mwl8k_tx_queue *txq;
 	struct mwl8k_tx_desc *tx;
@@ -1684,6 +1686,10 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 	u32 txstatus;
 	u8 txdatarate;
 	u16 qos;
+	int txpriority;
+	u8 tid = 0;
+	struct mwl8k_ampdu_stream *stream = NULL;
+	bool start_ba_session = false;
 
 	wh = (struct ieee80211_hdr *)skb->data;
 	if (ieee80211_is_data_qos(wh->frame_control))
@@ -1699,6 +1705,7 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 	wh = &((struct mwl8k_dma_data *)skb->data)->wh;
 
 	tx_info = IEEE80211_SKB_CB(skb);
+	sta = tx_info->control.sta;
 	mwl8k_vif = MWL8K_VIF(tx_info->control.vif);
 
 	if (tx_info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
@@ -1726,12 +1733,70 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 			qos |= MWL8K_QOS_ACK_POLICY_NORMAL;
 	}
 
+	txpriority = index;
+
+	if (ieee80211_is_data_qos(wh->frame_control) &&
+	    skb->protocol != cpu_to_be16(ETH_P_PAE) &&
+	    sta->ht_cap.ht_supported && priv->ap_fw) {
+		tid = qos & 0xf;
+		spin_lock(&priv->stream_lock);
+		stream = mwl8k_lookup_stream(hw, sta->addr, tid);
+		if (stream != NULL) {
+			if (stream->state == AMPDU_STREAM_ACTIVE) {
+				txpriority = stream->txq_idx;
+				index = stream->txq_idx;
+			} else if (stream->state == AMPDU_STREAM_NEW) {
+				/* We get here if the driver sends us packets
+				 * after we've initiated a stream, but before
+				 * our ampdu_action routine has been called
+				 * with IEEE80211_AMPDU_TX_START to get the SSN
+				 * for the ADDBA request.  So this packet can
+				 * go out with no risk of sequence number
+				 * mismatch.  No special handling is required.
+				 */
+			} else {
+				/* Drop packets that would go out after the
+				 * ADDBA request was sent but before the ADDBA
+				 * response is received.  If we don't do this,
+				 * the recipient would probably receive it
+				 * after the ADDBA request with SSN 0.  This
+				 * will cause the recipient's BA receive window
+				 * to shift, which would cause the subsequent
+				 * packets in the BA stream to be discarded.
+				 * mac80211 queues our packets for us in this
+				 * case, so this is really just a safety check.
+				 */
+				wiphy_warn(hw->wiphy,
+					   "Cannot send packet while ADDBA "
+					   "dialog is underway.\n");
+				spin_unlock(&priv->stream_lock);
+				dev_kfree_skb(skb);
+				return;
+			}
+		} else {
+			/* Defer calling mwl8k_start_stream so that the current
+			 * skb can go out before the ADDBA request.  This
+			 * prevents sequence number mismatch at the recepient
+			 * as described above.
+			 */
+			stream = mwl8k_add_stream(hw, sta, tid);
+			if (stream != NULL)
+				start_ba_session = true;
+		}
+		spin_unlock(&priv->stream_lock);
+	}
+
 	dma = pci_map_single(priv->pdev, skb->data,
 				skb->len, PCI_DMA_TODEVICE);
 
 	if (pci_dma_mapping_error(priv->pdev, dma)) {
 		wiphy_debug(hw->wiphy,
 			    "failed to dma map skb, dropping TX frame.\n");
+		if (start_ba_session) {
+			spin_lock(&priv->stream_lock);
+			mwl8k_remove_stream(hw, stream);
+			spin_unlock(&priv->stream_lock);
+		}
 		dev_kfree_skb(skb);
 		return;
 	}
@@ -1740,12 +1805,22 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 
 	txq = priv->txq + index;
 
+	if (index >= MWL8K_TX_WMM_QUEUES && txq->len >= MWL8K_TX_DESCS) {
+		/* This is the case in which the tx packet is destined for an
+		 * AMPDU queue and that AMPDU queue is full.  Because we don't
+		 * start and stop the AMPDU queues, we must drop these packets.
+		 */
+		dev_kfree_skb(skb);
+		spin_unlock_bh(&priv->tx_lock);
+		return;
+	}
+
 	BUG_ON(txq->skb[txq->tail] != NULL);
 	txq->skb[txq->tail] = skb;
 
 	tx = txq->txd + txq->tail;
 	tx->data_rate = txdatarate;
-	tx->tx_priority = index;
+	tx->tx_priority = txpriority;
 	tx->qos_control = cpu_to_le16(qos);
 	tx->pkt_phys_addr = cpu_to_le32(dma);
 	tx->pkt_len = cpu_to_le16(skb->len);
@@ -1764,12 +1839,20 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 	if (txq->tail == MWL8K_TX_DESCS)
 		txq->tail = 0;
 
-	if (txq->head == txq->tail)
+	if (txq->head == txq->tail && index < MWL8K_TX_WMM_QUEUES)
 		ieee80211_stop_queue(hw, index);
 
 	mwl8k_tx_start(priv);
 
 	spin_unlock_bh(&priv->tx_lock);
+
+	/* Initiate the ampdu session here */
+	if (start_ba_session) {
+		spin_lock(&priv->stream_lock);
+		if (mwl8k_start_stream(hw, stream))
+			mwl8k_remove_stream(hw, stream);
+		spin_unlock(&priv->stream_lock);
+	}
 }
 
 
@@ -4632,21 +4715,118 @@ static int mwl8k_get_survey(struct ieee80211_hw *hw, int idx,
 	return 0;
 }
 
+#define MAX_AMPDU_ATTEMPTS 5
+
 static int
 mwl8k_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		   enum ieee80211_ampdu_mlme_action action,
 		   struct ieee80211_sta *sta, u16 tid, u16 *ssn,
 		   u8 buf_size)
 {
+
+	int i, rc = 0;
+	struct mwl8k_priv *priv = hw->priv;
+	struct mwl8k_ampdu_stream *stream;
+	u8 *addr = sta->addr;
+
+	if (!(hw->flags & IEEE80211_HW_AMPDU_AGGREGATION))
+		return -ENOTSUPP;
+
+	spin_lock(&priv->stream_lock);
+	stream = mwl8k_lookup_stream(hw, addr, tid);
+
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
 	case IEEE80211_AMPDU_RX_STOP:
-		if (!(hw->flags & IEEE80211_HW_AMPDU_AGGREGATION))
-			return -ENOTSUPP;
-		return 0;
+		break;
+	case IEEE80211_AMPDU_TX_START:
+		/* By the time we get here the hw queues may contain outgoing
+		 * packets for this RA/TID that are not part of this BA
+		 * session.  The hw will assign sequence numbers to these
+		 * packets as they go out.  So if we query the hw for its next
+		 * sequence number and use that for the SSN here, it may end up
+		 * being wrong, which will lead to sequence number mismatch at
+		 * the recipient.  To avoid this, we reset the sequence number
+		 * to O for the first MPDU in this BA stream.
+		 */
+		*ssn = 0;
+		if (stream == NULL) {
+			/* This means that somebody outside this driver called
+			 * ieee80211_start_tx_ba_session.  This is unexpected
+			 * because we do our own rate control.  Just warn and
+			 * move on.
+			 */
+			wiphy_warn(hw->wiphy, "Unexpected call to %s.  "
+				   "Proceeding anyway.\n", __func__);
+			stream = mwl8k_add_stream(hw, sta, tid);
+		}
+		if (stream == NULL) {
+			wiphy_debug(hw->wiphy, "no free AMPDU streams\n");
+			rc = -EBUSY;
+			break;
+		}
+		stream->state = AMPDU_STREAM_IN_PROGRESS;
+
+		/* Release the lock before we do the time consuming stuff */
+		spin_unlock(&priv->stream_lock);
+		for (i = 0; i < MAX_AMPDU_ATTEMPTS; i++) {
+			rc = mwl8k_check_ba(hw, stream);
+
+			if (!rc)
+				break;
+			/*
+			 * HW queues take time to be flushed, give them
+			 * sufficient time
+			 */
+
+			msleep(1000);
+		}
+		spin_lock(&priv->stream_lock);
+		if (rc) {
+			wiphy_err(hw->wiphy, "Stream for tid %d busy after %d"
+				" attempts\n", tid, MAX_AMPDU_ATTEMPTS);
+			mwl8k_remove_stream(hw, stream);
+			rc = -EBUSY;
+			break;
+		}
+		ieee80211_start_tx_ba_cb_irqsafe(vif, addr, tid);
+		break;
+	case IEEE80211_AMPDU_TX_STOP:
+		if (stream == NULL)
+			break;
+		if (stream->state == AMPDU_STREAM_ACTIVE) {
+			spin_unlock(&priv->stream_lock);
+			mwl8k_destroy_ba(hw, stream);
+			spin_lock(&priv->stream_lock);
+		}
+		mwl8k_remove_stream(hw, stream);
+		ieee80211_stop_tx_ba_cb_irqsafe(vif, addr, tid);
+		break;
+	case IEEE80211_AMPDU_TX_OPERATIONAL:
+		BUG_ON(stream == NULL);
+		BUG_ON(stream->state != AMPDU_STREAM_IN_PROGRESS);
+		spin_unlock(&priv->stream_lock);
+		rc = mwl8k_create_ba(hw, stream, buf_size);
+		spin_lock(&priv->stream_lock);
+		if (!rc)
+			stream->state = AMPDU_STREAM_ACTIVE;
+		else {
+			spin_unlock(&priv->stream_lock);
+			mwl8k_destroy_ba(hw, stream);
+			spin_lock(&priv->stream_lock);
+			wiphy_debug(hw->wiphy,
+				"Failed adding stream for sta %pM tid %d\n",
+				addr, tid);
+			mwl8k_remove_stream(hw, stream);
+		}
+		break;
+
 	default:
-		return -ENOTSUPP;
+		rc = -ENOTSUPP;
 	}
+
+	spin_unlock(&priv->stream_lock);
+	return rc;
 }
 
 static const struct ieee80211_ops mwl8k_ops = {
-- 
1.7.1.1

