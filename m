Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39430 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753427AbYIPDSJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 23:18:09 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH v2] mac80211: re-enable aggregation
Date: Mon, 15 Sep 2008 20:17:53 -0700
Message-ID: <1221535073-6937-1-git-send-email-lrodriguez@atheros.com> (sfid-20080916_051843_672228_89C8F228)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Re-enable aggregation by addressing skb->cb overwrites
after insertion into the qdisc. Aggregation was disabled
after the new TX multiqueue changes were introduced. Instead
of relying on the skb->cb we use a new skb->requeue flag
and an internal mac80211 is_part_amdu().

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

I haven't tested this patch as its late and I should go home already.

 drivers/net/wireless/ath9k/main.c         |    2 +-
 drivers/net/wireless/ath9k/xmit.c         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c   |    6 ++++--
 drivers/net/wireless/iwlwifi/iwl-5000.c   |    6 ++++--
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    8 ++++----
 drivers/net/wireless/iwlwifi/iwl-tx.c     |    4 ++--
 include/linux/skbuff.h                    |    4 ++++
 include/net/mac80211.h                    |   15 ++++++++++++---
 net/mac80211/main.c                       |    7 ++-----
 net/mac80211/rx.c                         |    7 ++-----
 net/mac80211/tx.c                         |    6 ++----
 net/mac80211/wme.c                        |   19 ++++---------------
 12 files changed, 42 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index c5107f2..878e45f 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1241,7 +1241,7 @@ static int ath_attach(u16 devid,
 	/* FIXME: Have to figure out proper hw init values later */
 
 	hw->queues = 4;
-	hw->ampdu_queues = 1;
+	hw->ampdu_queues = 8;
 
 	/* Register rate control */
 	hw->rate_control_algorithm = "ath9k_rate_control";
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 550129f..fed9cd0 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -371,7 +371,7 @@ static int ath_tx_prepare(struct ath_softc *sc,
 
 		/* Enable HT only for DATA frames and not for EAPOL */
 		txctl->ht = (hw->conf.ht_conf.ht_supported &&
-			    (tx_info->flags & IEEE80211_TX_CTL_AMPDU));
+			    is_part_ampdu(skb, hw));
 
 		if (is_multicast_ether_addr(hdr->addr1)) {
 			rcs[0].rix = (u8)
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 23fed32..c43502e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2060,6 +2060,7 @@ static int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 
 	/* # frames attempted by Tx command */
 	if (agg->frame_count == 1) {
+		struct sk_buff *skb;
 		/* Only one frame was attempted; no block-ack will arrive */
 		status = le16_to_cpu(frame_status[0].status);
 		idx = start_idx;
@@ -2068,9 +2069,10 @@ static int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 		IWL_DEBUG_TX_REPLY("FrameCnt = %d, StartIdx=%d idx=%d\n",
 				   agg->frame_count, agg->start_idx, idx);
 
-		info = IEEE80211_SKB_CB(priv->txq[txq_id].txb[idx].skb[0]);
+		skb = priv->txq[txq_id].txb[idx].skb[0];
+
+		info = IEEE80211_SKB_CB(skb);
 		info->status.retry_count = tx_resp->failure_frame;
-		info->flags &= ~IEEE80211_TX_CTL_AMPDU;
 		info->flags |= iwl_is_tx_success(status)?
 			IEEE80211_TX_STAT_ACK : 0;
 		iwl_hwrate_to_tx_control(priv, rate_n_flags, info);
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index b08036a..5eae679 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1172,6 +1172,7 @@ static int iwl5000_tx_status_reply_tx(struct iwl_priv *priv,
 
 	/* # frames attempted by Tx command */
 	if (agg->frame_count == 1) {
+		struct sk_buff *skb;
 		/* Only one frame was attempted; no block-ack will arrive */
 		status = le16_to_cpu(frame_status[0].status);
 		idx = start_idx;
@@ -1180,9 +1181,10 @@ static int iwl5000_tx_status_reply_tx(struct iwl_priv *priv,
 		IWL_DEBUG_TX_REPLY("FrameCnt = %d, StartIdx=%d idx=%d\n",
 				   agg->frame_count, agg->start_idx, idx);
 
-		info = IEEE80211_SKB_CB(priv->txq[txq_id].txb[idx].skb[0]);
+		skb = priv->txq[txq_id].txb[idx].skb[0];
+
+		info = IEEE80211_SKB_CB(skb);
 		info->status.retry_count = tx_resp->failure_frame;
-		info->flags &= ~IEEE80211_TX_CTL_AMPDU;
 		info->flags |= iwl_is_tx_success(status)?
 			IEEE80211_TX_STAT_ACK : 0;
 		iwl_hwrate_to_tx_control(priv, rate_n_flags, info);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 90a2b6d..42e5295 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -802,7 +802,7 @@ static void rs_tx_status(void *priv_rate, struct net_device *dev,
 		return;
 
 	/* This packet was aggregated but doesn't carry rate scale info */
-	if ((info->flags & IEEE80211_TX_CTL_AMPDU) &&
+	if (is_part_ampdu(skb, hw) &&
 	    !(info->flags & IEEE80211_TX_STAT_AMPDU))
 		return;
 
@@ -924,7 +924,7 @@ static void rs_tx_status(void *priv_rate, struct net_device *dev,
 			tpt = search_tbl->expected_tpt[rs_index];
 		else
 			tpt = 0;
-		if (info->flags & IEEE80211_TX_CTL_AMPDU)
+		if (is_part_ampdu(skb, hw))
 			rs_collect_tx_data(search_win, rs_index, tpt,
 					   info->status.ampdu_ack_len,
 					   info->status.ampdu_ack_map);
@@ -940,7 +940,7 @@ static void rs_tx_status(void *priv_rate, struct net_device *dev,
 			tpt = curr_tbl->expected_tpt[rs_index];
 		else
 			tpt = 0;
-		if (info->flags & IEEE80211_TX_CTL_AMPDU)
+		if (is_part_ampdu(skb, hw))
 			rs_collect_tx_data(window, rs_index, tpt,
 					   info->status.ampdu_ack_len,
 					   info->status.ampdu_ack_map);
@@ -952,7 +952,7 @@ static void rs_tx_status(void *priv_rate, struct net_device *dev,
 	/* If not searching for new mode, increment success/failed counter
 	 * ... these help determine when to start searching again */
 	if (lq_sta->stay_in_tbl) {
-		if (info->flags & IEEE80211_TX_CTL_AMPDU) {
+		if (is_part_ampdu(skb, hw)) {
 			lq_sta->total_success += info->status.ampdu_ack_map;
 			lq_sta->total_failed +=
 			     (info->status.ampdu_ack_len - info->status.ampdu_ack_map);
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 78b1a7a..79a1b1f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -724,7 +724,7 @@ static void iwl_tx_cmd_build_hwcrypto(struct iwl_priv *priv,
 	case ALG_CCMP:
 		tx_cmd->sec_ctl = TX_CMD_SEC_CCM;
 		memcpy(tx_cmd->key, keyconf->key, keyconf->keylen);
-		if (info->flags & IEEE80211_TX_CTL_AMPDU)
+		if (is_part_ampdu(skb_frag, priv->hw))
 			tx_cmd->tx_flags |= TX_CMD_FLG_AGG_CCMP_MSK;
 		IWL_DEBUG_TX("tx_cmd with aes hwcrypto\n");
 		break;
@@ -857,7 +857,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		hdr->seq_ctrl |= cpu_to_le16(seq_number);
 		seq_number += 0x10;
 		/* aggregation is on for this <sta,tid> */
-		if (info->flags & IEEE80211_TX_CTL_AMPDU)
+		if (skb->queue_mapping >= priv->hw->queues)
 			txq_id = priv->stations[sta_id].tid[tid].agg.txq_id;
 		priv->stations[sta_id].tid[tid].tfds_in_queue++;
 	}
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 9099237..4724211 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -244,6 +244,9 @@ typedef unsigned char *sk_buff_data_t;
  *	@tc_verd: traffic control verdict
  *	@ndisc_nodetype: router type (from link layer)
  *	@do_not_encrypt: set to prevent encryption of this frame
+ *	@requeue: set to indicate that the wireless core should attempt
+ *		a software retry on this frame if we failed to
+ *		receive an ACK for it
  *	@dma_cookie: a cookie to one of several possible DMA operations
  *		done by skb DMA functions
  *	@secmark: security marking
@@ -319,6 +322,7 @@ struct sk_buff {
 #endif
 #if defined(CONFIG_MAC80211) || defined(CONFIG_MAC80211_MODULE)
 	__u8			do_not_encrypt:1;
+	__u8			requeue:1;
 #endif
 	/* 0/13/14 bit hole */
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index ff137fd..0fe4da4 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -221,7 +221,6 @@ struct ieee80211_bss_conf {
  * @IEEE80211_TX_CTL_LONG_RETRY_LIMIT: this frame should be send using the
  *	through set_retry_limit configured long retry value
  * @IEEE80211_TX_CTL_SEND_AFTER_DTIM: send this frame after DTIM beacon
- * @IEEE80211_TX_CTL_AMPDU: this frame should be sent as part of an A-MPDU
  * @IEEE80211_TX_CTL_OFDM_HT: this frame can be sent in HT OFDM rates. number
  *	of streams when this flag is on can be extracted from antenna_sel_tx,
  *	so if 1 antenna is marked use SISO, 2 antennas marked use MIMO, n
@@ -257,12 +256,10 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_NO_ACK			= BIT(4),
 	IEEE80211_TX_CTL_RATE_CTRL_PROBE	= BIT(5),
 	IEEE80211_TX_CTL_CLEAR_PS_FILT		= BIT(6),
-	IEEE80211_TX_CTL_REQUEUE		= BIT(7),
 	IEEE80211_TX_CTL_FIRST_FRAGMENT		= BIT(8),
 	IEEE80211_TX_CTL_SHORT_PREAMBLE		= BIT(9),
 	IEEE80211_TX_CTL_LONG_RETRY_LIMIT	= BIT(10),
 	IEEE80211_TX_CTL_SEND_AFTER_DTIM	= BIT(12),
-	IEEE80211_TX_CTL_AMPDU			= BIT(13),
 	IEEE80211_TX_CTL_OFDM_HT		= BIT(14),
 	IEEE80211_TX_CTL_GREEN_FIELD		= BIT(15),
 	IEEE80211_TX_CTL_40_MHZ_WIDTH		= BIT(16),
@@ -849,6 +846,18 @@ static inline int ieee80211_num_regular_queues(struct ieee80211_hw *hw)
 	return hw->queues;
 }
 
+/**
+ * is_part_ampdu - tells us whether this buffer is part of an AMPDU
+ *
+ * @skb: the buffer we want to check
+ * @hw: the &struct ieee80211_hw to check the queue mapping on
+ */
+static inline bool is_part_ampdu(struct sk_buff *skb, struct ieee80211_hw *hw)
+{
+	return (skb_get_queue_mapping(skb) >=
+		ieee80211_num_regular_queues(hw));
+}
+
 static inline int ieee80211_num_queues(struct ieee80211_hw *hw)
 {
 	return hw->queues + hw->ampdu_queues;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index aa5a191..6d57eac 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1293,8 +1293,6 @@ static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
 					    struct sta_info *sta,
 					    struct sk_buff *skb)
 {
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-
 	sta->tx_filtered_count++;
 
 	/*
@@ -1341,10 +1339,9 @@ static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
 		return;
 	}
 
-	if (!test_sta_flags(sta, WLAN_STA_PS) &&
-	    !(info->flags & IEEE80211_TX_CTL_REQUEUE)) {
+	if (!test_sta_flags(sta, WLAN_STA_PS) && !skb->requeue) {
 		/* Software retry the packet once */
-		info->flags |= IEEE80211_TX_CTL_REQUEUE;
+		skb->requeue = 1;
 		ieee80211_remove_tx_extra(local, sta->key, skb);
 		dev_queue_xmit(skb);
 		return;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 6db8545..3e3c870 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -666,7 +666,6 @@ static int ap_sta_ps_end(struct net_device *dev, struct sta_info *sta)
 	struct sk_buff *skb;
 	int sent = 0;
 	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_tx_info *info;
 	DECLARE_MAC_BUF(mac);
 
 	sdata = sta->sdata;
@@ -685,13 +684,11 @@ static int ap_sta_ps_end(struct net_device *dev, struct sta_info *sta)
 
 	/* Send all buffered frames to the station */
 	while ((skb = skb_dequeue(&sta->tx_filtered)) != NULL) {
-		info = IEEE80211_SKB_CB(skb);
 		sent++;
-		info->flags |= IEEE80211_TX_CTL_REQUEUE;
+		skb->requeue = 1;
 		dev_queue_xmit(skb);
 	}
 	while ((skb = skb_dequeue(&sta->ps_tx_buf)) != NULL) {
-		info = IEEE80211_SKB_CB(skb);
 		local->total_ps_buffered--;
 		sent++;
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
@@ -699,7 +696,7 @@ static int ap_sta_ps_end(struct net_device *dev, struct sta_info *sta)
 		       "since STA not sleeping anymore\n", dev->name,
 		       print_mac(mac, sta->addr), sta->aid);
 #endif /* CONFIG_MAC80211_VERBOSE_PS_DEBUG */
-		info->flags |= IEEE80211_TX_CTL_REQUEUE;
+		skb->requeue = 1;
 		dev_queue_xmit(skb);
 	}
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 4788f7b..a29b577 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -682,9 +682,7 @@ ieee80211_tx_h_fragment(struct ieee80211_tx_data *tx)
 	 * This scenario is handled in __ieee80211_tx_prepare but extra
 	 * caution taken here as fragmented ampdu may cause Tx stop.
 	 */
-	if (WARN_ON(tx->flags & IEEE80211_TX_CTL_AMPDU ||
-		    skb_get_queue_mapping(tx->skb) >=
-			ieee80211_num_regular_queues(&tx->local->hw)))
+	if (WARN_ON((is_part_ampdu(tx->skb, &tx->local->hw))))
 		return TX_DROP;
 
 	first = tx->skb;
@@ -1014,7 +1012,7 @@ __ieee80211_tx_prepare(struct ieee80211_tx_data *tx,
 		if ((tx->flags & IEEE80211_TX_UNICAST) &&
 		    skb->len + FCS_LEN > local->fragmentation_threshold &&
 		    !local->ops->set_frag_threshold &&
-		    !(info->flags & IEEE80211_TX_CTL_AMPDU))
+		    !(is_part_ampdu(skb, &tx->local->hw)))
 			tx->flags |= IEEE80211_TX_FRAGMENTED;
 		else
 			tx->flags &= ~IEEE80211_TX_FRAGMENTED;
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 4310e2f..c53bd56 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -113,11 +113,11 @@ static u16 classify80211(struct sk_buff *skb, struct net_device *dev)
 	return ieee802_1d_to_ac[skb->priority];
 }
 
+/* XXX: Remove usage of tid_to_tx_q and only map frames to an AC */
 u16 ieee80211_select_queue(struct net_device *dev, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct sta_info *sta;
 	u16 queue;
 	u8 tid;
@@ -126,7 +126,7 @@ u16 ieee80211_select_queue(struct net_device *dev, struct sk_buff *skb)
 	if (unlikely(queue >= local->hw.queues))
 		queue = local->hw.queues - 1;
 
-	if (info->flags & IEEE80211_TX_CTL_REQUEUE) {
+	if (skb->requeue) {
 		rcu_read_lock();
 		sta = sta_info_get(local, hdr->addr1);
 		tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
@@ -135,12 +135,8 @@ u16 ieee80211_select_queue(struct net_device *dev, struct sk_buff *skb)
 			int ampdu_queue = sta->tid_to_tx_q[tid];
 
 			if ((ampdu_queue < ieee80211_num_queues(hw)) &&
-			    test_bit(ampdu_queue, local->queue_pool)) {
+			    test_bit(ampdu_queue, local->queue_pool))
 				queue = ampdu_queue;
-				info->flags |= IEEE80211_TX_CTL_AMPDU;
-			} else {
-				info->flags &= ~IEEE80211_TX_CTL_AMPDU;
-			}
 		}
 		rcu_read_unlock();
 
@@ -169,12 +165,8 @@ u16 ieee80211_select_queue(struct net_device *dev, struct sk_buff *skb)
 			struct ieee80211_hw *hw = &local->hw;
 
 			if ((ampdu_queue < ieee80211_num_queues(hw)) &&
-			    test_bit(ampdu_queue, local->queue_pool)) {
+			    test_bit(ampdu_queue, local->queue_pool))
 				queue = ampdu_queue;
-				info->flags |= IEEE80211_TX_CTL_AMPDU;
-			} else {
-				info->flags &= ~IEEE80211_TX_CTL_AMPDU;
-			}
 		}
 
 		rcu_read_unlock();
@@ -188,9 +180,6 @@ int ieee80211_ht_agg_queue_add(struct ieee80211_local *local,
 {
 	int i;
 
-	/* XXX: currently broken due to cb/requeue use */
-	return -EPERM;
-
 	/* prepare the filter and save it for the SW queue
 	 * matching the received HW queue */
 
-- 
1.5.6.3

