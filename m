Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51967 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756699Ab3FGQMG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jun 2013 12:12:06 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH v3 3/3] ath9k: limit multicast buffer hardware queue depth
Date: Fri,  7 Jun 2013 18:12:02 +0200
Message-Id: <1370621522-59812-3-git-send-email-nbd@openwrt.org> (sfid-20130607_181301_204914_CCFB3748)
In-Reply-To: <1370621522-59812-1-git-send-email-nbd@openwrt.org>
References: <1370621522-59812-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The CAB (Content after Beacon) queue is used for beacon-triggered
transmission of buffered multicast frames. If lots of multicast frames
were buffered and this queue fills up, it drowns out all regular
traffic. To limit the damage that buffered traffic can do, try to limit
the queued data to becaon_interval / 8.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |   2 +
 drivers/net/wireless/ath/ath9k/beacon.c |  23 +------
 drivers/net/wireless/ath/ath9k/xmit.c   | 115 +++++++++++++++++++++++++++-----
 3 files changed, 104 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index bd35a54..a6e666b 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -344,6 +344,8 @@ int ath_txq_update(struct ath_softc *sc, int qnum,
 void ath_update_max_aggr_framelen(struct ath_softc *sc, int queue, int txop);
 int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 		 struct ath_tx_control *txctl);
+void ath_tx_cabq(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		 struct sk_buff *skb);
 void ath_tx_tasklet(struct ath_softc *sc);
 void ath_tx_edma_tasklet(struct ath_softc *sc);
 int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index fd1eeba..1a17732 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -108,23 +108,6 @@ static void ath9k_beacon_setup(struct ath_softc *sc, struct ieee80211_vif *vif,
 	ath9k_hw_set_txdesc(ah, bf->bf_desc, &info);
 }
 
-static void ath9k_tx_cabq(struct ieee80211_hw *hw, struct sk_buff *skb)
-{
-	struct ath_softc *sc = hw->priv;
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	struct ath_tx_control txctl;
-
-	memset(&txctl, 0, sizeof(struct ath_tx_control));
-	txctl.txq = sc->beacon.cabq;
-
-	ath_dbg(common, XMIT, "transmitting CABQ packet, skb: %p\n", skb);
-
-	if (ath_tx_start(hw, skb, &txctl) != 0) {
-		ath_dbg(common, XMIT, "CABQ TX failed\n");
-		ieee80211_free_txskb(hw, skb);
-	}
-}
-
 static struct ath_buf *ath9k_beacon_generate(struct ieee80211_hw *hw,
 					     struct ieee80211_vif *vif)
 {
@@ -206,10 +189,8 @@ static struct ath_buf *ath9k_beacon_generate(struct ieee80211_hw *hw,
 
 	ath9k_beacon_setup(sc, vif, bf, info->control.rates[0].idx);
 
-	while (skb) {
-		ath9k_tx_cabq(hw, skb);
-		skb = ieee80211_get_buffered_bc(hw, vif);
-	}
+	if (skb)
+		ath_tx_cabq(hw, vif, skb);
 
 	return bf;
 }
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 6c9ff9c..7e19d9b 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1970,22 +1970,16 @@ static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
 	return bf;
 }
 
-/* Upon failure caller should free skb */
-int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
-		 struct ath_tx_control *txctl)
+static int ath_tx_prepare(struct ieee80211_hw *hw, struct sk_buff *skb,
+			  struct ath_tx_control *txctl)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_sta *sta = txctl->sta;
 	struct ieee80211_vif *vif = info->control.vif;
 	struct ath_softc *sc = hw->priv;
-	struct ath_txq *txq = txctl->txq;
-	struct ath_atx_tid *tid = NULL;
-	struct ath_buf *bf;
-	int padpos, padsize;
 	int frmlen = skb->len + FCS_LEN;
-	u8 tidno;
-	int q;
+	int padpos, padsize;
 
 	/* NOTE:  sta can be NULL according to net/mac80211.h */
 	if (sta)
@@ -2006,6 +2000,11 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 		hdr->seq_ctrl |= cpu_to_le16(sc->tx.seq_no);
 	}
 
+	if ((vif && vif->type != NL80211_IFTYPE_AP &&
+	            vif->type != NL80211_IFTYPE_AP_VLAN) ||
+	    !ieee80211_is_data(hdr->frame_control))
+		info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
+
 	/* Add the padding after the header if this is not already done */
 	padpos = ieee80211_hdrlen(hdr->frame_control);
 	padsize = padpos & 3;
@@ -2015,16 +2014,34 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 
 		skb_push(skb, padsize);
 		memmove(skb->data, skb->data + padsize, padpos);
-		hdr = (struct ieee80211_hdr *) skb->data;
 	}
 
-	if ((vif && vif->type != NL80211_IFTYPE_AP &&
-	            vif->type != NL80211_IFTYPE_AP_VLAN) ||
-	    !ieee80211_is_data(hdr->frame_control))
-		info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
-
 	setup_frame_info(hw, sta, skb, frmlen);
+	return 0;
+}
+
 
+/* Upon failure caller should free skb */
+int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
+		 struct ath_tx_control *txctl)
+{
+	struct ieee80211_hdr *hdr;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_sta *sta = txctl->sta;
+	struct ieee80211_vif *vif = info->control.vif;
+	struct ath_softc *sc = hw->priv;
+	struct ath_txq *txq = txctl->txq;
+	struct ath_atx_tid *tid = NULL;
+	struct ath_buf *bf;
+	u8 tidno;
+	int q;
+	int ret;
+
+	ret = ath_tx_prepare(hw, skb, txctl);
+	if (ret)
+	    return ret;
+
+	hdr = (struct ieee80211_hdr *) skb->data;
 	/*
 	 * At this point, the vif, hw_key and sta pointers in the tx control
 	 * info are no longer valid (overwritten by the ath_frame_info data.
@@ -2086,6 +2103,74 @@ out:
 	return 0;
 }
 
+void ath_tx_cabq(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		 struct sk_buff *skb)
+{
+	struct ath_softc *sc = hw->priv;
+	struct ath_tx_control txctl = {
+		.txq = sc->beacon.cabq
+	};
+	struct ath_tx_info info = {};
+	struct ieee80211_hdr *hdr;
+	struct ath_buf *bf_tail = NULL;
+	struct ath_buf *bf;
+	LIST_HEAD(bf_q);
+	int duration = 0;
+	int max_duration;
+
+	max_duration =
+		sc->cur_beacon_conf.beacon_interval * 1000 *
+		sc->cur_beacon_conf.dtim_period / ATH_BCBUF;
+
+	do {
+		struct ath_frame_info *fi = get_frame_info(skb);
+
+		if (ath_tx_prepare(hw, skb, &txctl))
+			break;
+
+		bf = ath_tx_setup_buffer(sc, txctl.txq, NULL, skb);
+		if (!bf)
+			break;
+
+		bf->bf_lastbf = bf;
+		ath_set_rates(vif, NULL, bf);
+		ath_buf_set_rate(sc, bf, &info, fi->framelen);
+		duration += info.rates[0].PktDuration;
+		if (bf_tail)
+			bf_tail->bf_next = bf;
+
+		list_add_tail(&bf->list, &bf_q);
+		bf_tail = bf;
+		skb = NULL;
+
+		if (duration > max_duration)
+			break;
+
+		skb = ieee80211_get_buffered_bc(hw, vif);
+	} while(skb);
+
+	if (skb)
+		ieee80211_free_txskb(hw, skb);
+
+	if (list_empty(&bf_q))
+		return;
+
+	bf = list_first_entry(&bf_q, struct ath_buf, list);
+	hdr = (struct ieee80211_hdr *) bf->bf_mpdu->data;
+
+	if (hdr->frame_control & IEEE80211_FCTL_MOREDATA) {
+		hdr->frame_control &= ~IEEE80211_FCTL_MOREDATA;
+		dma_sync_single_for_device(sc->dev, bf->bf_buf_addr,
+			sizeof(*hdr), DMA_TO_DEVICE);
+	}
+
+	ath_txq_lock(sc, txctl.txq);
+	ath_tx_fill_desc(sc, bf, txctl.txq, 0);
+	ath_tx_txqaddbuf(sc, txctl.txq, &bf_q, false);
+	TX_STAT_INC(txctl.txq->axq_qnum, queued);
+	ath_txq_unlock(sc, txctl.txq);
+}
+
 /*****************/
 /* TX Completion */
 /*****************/
-- 
1.8.0.2

