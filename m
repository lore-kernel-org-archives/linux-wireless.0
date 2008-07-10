Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33628 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbYGJJrI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 05:47:08 -0400
Subject: [PATCH] mac80211: fix TX sequence numbers
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 10 Jul 2008 11:21:26 +0200
Message-Id: <1215681686.3932.12.camel@johannes.berg> (sfid-20080710_114714_417795_F09D30AB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch makes mac80211 assign proper sequence numbers to
QoS-data frames. It also removes the old sequence number code
because we noticed that only the driver or hardware can assign
sequence numbers to non-QoS-data and especially management
frames in a race-free manner because beacons aren't passed
through mac80211's TX path.

This patch also adds temporary code to the rt2x00 drivers to
not break them completely, that code will have to be reworked
for proper sequence numbers on beacons.

It also moves sequence number assignment down in the TX path
so no sequence numbers are assigned to frames that are dropped.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/b43/xmit.c         |    3 -
 drivers/net/wireless/b43legacy/xmit.c   |    3 -
 drivers/net/wireless/rt2x00/rt2x00.h    |    2 
 drivers/net/wireless/rt2x00/rt2x00mac.c |   13 +++++
 include/net/mac80211.h                  |   12 ++++
 net/mac80211/ieee80211_i.h              |    2 
 net/mac80211/iface.c                    |    1 
 net/mac80211/sta_info.h                 |    1 
 net/mac80211/tx.c                       |   79 ++++++++++++++++++++------------
 9 files changed, 82 insertions(+), 34 deletions(-)

--- everything.orig/net/mac80211/ieee80211_i.h	2008-07-10 11:14:27.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-07-10 11:17:18.000000000 +0200
@@ -419,8 +419,6 @@ struct ieee80211_sub_if_data {
 	 */
 	u64 basic_rates;
 
-	u16 sequence;
-
 	/* Fragment table for host-based reassembly */
 	struct ieee80211_fragment_entry	fragments[IEEE80211_FRAGMENT_MAX];
 	unsigned int fragment_next;
--- everything.orig/net/mac80211/tx.c	2008-07-10 11:14:27.000000000 +0200
+++ everything/net/mac80211/tx.c	2008-07-10 11:17:18.000000000 +0200
@@ -38,16 +38,6 @@
 
 /* misc utils */
 
-static inline void ieee80211_include_sequence(struct ieee80211_sub_if_data *sdata,
-					      struct ieee80211_hdr *hdr)
-{
-	/* Set the sequence number for this frame. */
-	hdr->seq_ctrl = cpu_to_le16(sdata->sequence);
-
-	/* Increase the sequence number. */
-	sdata->sequence = (sdata->sequence + 0x10) & IEEE80211_SCTL_SEQ;
-}
-
 #ifdef CONFIG_MAC80211_LOWTX_FRAME_DUMP
 static void ieee80211_dump_frame(const char *ifname, const char *title,
 				 const struct sk_buff *skb)
@@ -274,17 +264,6 @@ ieee80211_tx_h_check_assoc(struct ieee80
 	return TX_CONTINUE;
 }
 
-static ieee80211_tx_result debug_noinline
-ieee80211_tx_h_sequence(struct ieee80211_tx_data *tx)
-{
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
-
-	if (ieee80211_hdrlen(hdr->frame_control) >= 24)
-		ieee80211_include_sequence(tx->sdata, hdr);
-
-	return TX_CONTINUE;
-}
-
 /* This function is called whenever the AP is about to exceed the maximum limit
  * of buffered frames for power saving STAs. This situation should not really
  * happen often during normal operation, so dropping the oldest buffered packet
@@ -642,6 +621,49 @@ ieee80211_tx_h_misc(struct ieee80211_tx_
 }
 
 static ieee80211_tx_result debug_noinline
+ieee80211_tx_h_sequence(struct ieee80211_tx_data *tx)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
+	u16 *seq;
+	u8 *qc;
+	int tid;
+
+	/* only for injected frames */
+	if (unlikely(ieee80211_is_ctl(hdr->frame_control)))
+		return TX_CONTINUE;
+
+	if (ieee80211_hdrlen(hdr->frame_control) < 24)
+		return TX_CONTINUE;
+
+	if (!ieee80211_is_data_qos(hdr->frame_control)) {
+		info->flags |= IEEE80211_TX_CTL_ASSIGN_SEQ;
+		return TX_CONTINUE;
+	}
+
+	/*
+	 * This should be true for injected/management frames only, for
+	 * management frames we have set the IEEE80211_TX_CTL_ASSIGN_SEQ
+	 * above since they are not QoS-data frames.
+	 */
+	if (!tx->sta)
+		return TX_CONTINUE;
+
+	/* include per-STA, per-TID sequence counter */
+
+	qc = ieee80211_get_qos_ctl(hdr);
+	tid = *qc & IEEE80211_QOS_CTL_TID_MASK;
+	seq = &tx->sta->tid_seq[tid];
+
+	hdr->seq_ctrl = cpu_to_le16(*seq);
+
+	/* Increase the sequence number. */
+	*seq = (*seq + 0x10) & IEEE80211_SCTL_SEQ;
+
+	return TX_CONTINUE;
+}
+
+static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_fragment(struct ieee80211_tx_data *tx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
@@ -1110,12 +1132,12 @@ static int invoke_tx_handlers(struct iee
 		goto txh_done;
 
 	CALL_TXH(ieee80211_tx_h_check_assoc)
-	CALL_TXH(ieee80211_tx_h_sequence)
 	CALL_TXH(ieee80211_tx_h_ps_buf)
 	CALL_TXH(ieee80211_tx_h_select_key)
 	CALL_TXH(ieee80211_tx_h_michael_mic_add)
 	CALL_TXH(ieee80211_tx_h_rate_ctrl)
 	CALL_TXH(ieee80211_tx_h_misc)
+	CALL_TXH(ieee80211_tx_h_sequence)
 	CALL_TXH(ieee80211_tx_h_fragment)
 	/* handlers after fragment must be aware of tx info fragmentation! */
 	CALL_TXH(ieee80211_tx_h_encrypt)
@@ -1834,9 +1856,6 @@ struct sk_buff *ieee80211_beacon_get(str
 			memcpy(skb_put(skb, beacon->head_len), beacon->head,
 			       beacon->head_len);
 
-			ieee80211_include_sequence(sdata,
-					(struct ieee80211_hdr *)skb->data);
-
 			/*
 			 * Not very nice, but we want to allow the driver to call
 			 * ieee80211_beacon_get() as a response to the set_tim()
@@ -1926,14 +1945,18 @@ struct sk_buff *ieee80211_beacon_get(str
 
 	info->control.vif = vif;
 	info->tx_rate_idx = rsel.rate_idx;
+
+	info->flags |= IEEE80211_TX_CTL_NO_ACK;
+	info->flags |= IEEE80211_TX_CTL_DO_NOT_ENCRYPT;
+	info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
+	info->flags |= IEEE80211_TX_CTL_ASSIGN_SEQ;
 	if (sdata->bss_conf.use_short_preamble &&
 	    sband->bitrates[rsel.rate_idx].flags & IEEE80211_RATE_SHORT_PREAMBLE)
 		info->flags |= IEEE80211_TX_CTL_SHORT_PREAMBLE;
+
 	info->antenna_sel_tx = local->hw.conf.antenna_sel_tx;
-	info->flags |= IEEE80211_TX_CTL_NO_ACK;
-	info->flags |= IEEE80211_TX_CTL_DO_NOT_ENCRYPT;
 	info->control.retry_limit = 1;
-	info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
+
 	(*num_beacons)++;
 out:
 	rcu_read_unlock();
--- everything.orig/net/mac80211/iface.c	2008-07-10 11:14:27.000000000 +0200
+++ everything/net/mac80211/iface.c	2008-07-10 11:17:18.000000000 +0200
@@ -162,7 +162,6 @@ int ieee80211_if_change_type(struct ieee
 	/* reset some values that shouldn't be kept across type changes */
 	sdata->basic_rates = 0;
 	sdata->drop_unencrypted = 0;
-	sdata->sequence = 0;
 
 	return 0;
 }
--- everything.orig/include/net/mac80211.h	2008-07-10 11:14:27.000000000 +0200
+++ everything/include/net/mac80211.h	2008-07-10 11:17:18.000000000 +0200
@@ -239,6 +239,17 @@ struct ieee80211_bss_conf {
  * 	is for the whole aggregation.
  * @IEEE80211_TX_STAT_AMPDU_NO_BACK: no block ack was returned,
  * 	so consider using block ack request (BAR).
+ * @IEEE80211_TX_CTL_ASSIGN_SEQ: The driver has to assign a sequence
+ *	number to this frame, taking care of not overwriting the fragment
+ *	number and increasing the sequence number only when the
+ *	IEEE80211_TX_CTL_FIRST_FRAGMENT flags is set. mac80211 will properly
+ *	assign sequence numbers to QoS-data frames but cannot do so correctly
+ *	for non-QoS-data and management frames because beacons need them from
+ *	that counter as well and mac80211 cannot guarantee proper sequencing.
+ *	If this flag is set, the driver should instruct the hardware to
+ *	assign a sequence number to the frame or assign one itself. Cf. IEEE
+ *	802.11-2007 7.1.3.4.1 paragraph 3. This flag will always be set for
+ *	beacons always be clear for frames without a sequence number field.
  */
 enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_REQ_TX_STATUS		= BIT(0),
@@ -265,6 +276,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_STAT_ACK			= BIT(21),
 	IEEE80211_TX_STAT_AMPDU			= BIT(22),
 	IEEE80211_TX_STAT_AMPDU_NO_BACK		= BIT(23),
+	IEEE80211_TX_CTL_ASSIGN_SEQ		= BIT(24),
 };
 
 
--- everything.orig/drivers/net/wireless/b43/xmit.c	2008-07-10 11:14:27.000000000 +0200
+++ everything/drivers/net/wireless/b43/xmit.c	2008-07-10 11:17:18.000000000 +0200
@@ -317,7 +317,8 @@ int b43_generate_txhdr(struct b43_wldev 
 	/* MAC control */
 	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
 		mac_ctl |= B43_TXH_MAC_ACK;
-	if (!ieee80211_is_pspoll(fctl))
+	/* use hardware sequence counter as the non-TID counter */
+	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ)
 		mac_ctl |= B43_TXH_MAC_HWSEQ;
 	if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
 		mac_ctl |= B43_TXH_MAC_STMSDU;
--- everything.orig/net/mac80211/sta_info.h	2008-07-10 11:14:27.000000000 +0200
+++ everything/net/mac80211/sta_info.h	2008-07-10 11:17:18.000000000 +0200
@@ -285,6 +285,7 @@ struct sta_info {
 	unsigned long tx_fragments;
 	int txrate_idx;
 	int last_txrate_idx;
+	u16 tid_seq[IEEE80211_QOS_CTL_TID_MASK + 1];
 #ifdef CONFIG_MAC80211_DEBUG_COUNTERS
 	unsigned int wme_tx_queue[NUM_RX_DATA_QUEUES];
 #endif
--- everything.orig/drivers/net/wireless/rt2x00/rt2x00.h	2008-07-10 11:14:27.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt2x00.h	2008-07-10 11:17:18.000000000 +0200
@@ -364,6 +364,8 @@ struct rt2x00_intf {
 #define DELAYED_UPDATE_BEACON		0x00000001
 #define DELAYED_CONFIG_ERP		0x00000002
 #define DELAYED_LED_ASSOC		0x00000004
+
+	u16 seqno;
 };
 
 static inline struct rt2x00_intf* vif_to_intf(struct ieee80211_vif *vif)
--- everything.orig/drivers/net/wireless/rt2x00/rt2x00mac.c	2008-07-10 11:14:27.000000000 +0200
+++ everything/drivers/net/wireless/rt2x00/rt2x00mac.c	2008-07-10 11:17:18.000000000 +0200
@@ -96,6 +96,7 @@ int rt2x00mac_tx(struct ieee80211_hw *hw
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr *)skb->data;
 	enum data_queue_qid qid = skb_get_queue_mapping(skb);
+	struct rt2x00_intf *intf = vif_to_intf(tx_info->control.vif);
 	struct data_queue *queue;
 	u16 frame_control;
 
@@ -151,6 +152,18 @@ int rt2x00mac_tx(struct ieee80211_hw *hw
 		}
 	}
 
+	/*
+	 * XXX: This is as wrong as the old mac80211 code was,
+	 *	due to beacons not getting sequence numbers assigned
+	 *	properly.
+	 */
+	if (tx_info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
+		if (tx_info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
+			intf->seqno += 0x10;
+		ieee80211hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
+		ieee80211hdr->seq_ctrl |= cpu_to_le16(intf->seqno);
+	}
+
 	if (rt2x00queue_write_tx_frame(queue, skb)) {
 		ieee80211_stop_queue(rt2x00dev->hw, qid);
 		return NETDEV_TX_BUSY;
--- everything.orig/drivers/net/wireless/b43legacy/xmit.c	2008-07-10 11:14:27.000000000 +0200
+++ everything/drivers/net/wireless/b43legacy/xmit.c	2008-07-10 11:17:18.000000000 +0200
@@ -295,8 +295,7 @@ static int generate_txhdr_fw3(struct b43
 	/* MAC control */
 	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
 		mac_ctl |= B43legacy_TX4_MAC_ACK;
-	if (!(((fctl & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL) &&
-	      ((fctl & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PSPOLL)))
+	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ)
 		mac_ctl |= B43legacy_TX4_MAC_HWSEQ;
 	if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
 		mac_ctl |= B43legacy_TX4_MAC_STMSDU;


