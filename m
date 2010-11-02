Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:46314 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754440Ab0KBRhp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Nov 2010 13:37:45 -0400
Message-ID: <4CD04C61.4070007@openwrt.org>
Date: Tue, 02 Nov 2010 18:37:37 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
CC: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [RFC] ath9k: fix tx queue selection
References: <alpine.DEB.2.00.1011021655080.23045@vtdt3> <4CD046D2.4080703@openwrt.org>
In-Reply-To: <4CD046D2.4080703@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-11-02 6:13 PM, Felix Fietkau wrote:
> On 2010-11-02 5:13 PM, Björn Smedman wrote:
>> Hi all,
>> 
>> The following patch attempts to fix some problems with ath9k tx queue 
>> selection:
>> 
>> 1. There was a posible mismatch between the queue selected for QoS packets 
>> (on which locking, queue start/stop and statistics where performed) and 
>> the queue actually used for TX. This is fixed by selecting the tx queue 
>> based on the TID of the 802.11 header for this type of packet.
> This should not be necessary. mac80211 should take care of queue
> selection properly for QoS frames. If it doesn't, then that is the bug
> that needs to be fixed...
> 
>> 2. Even with the above fix there was still a risk of mac80211 queue 
>> "deadlock" because the queue to stop was selected on the basis of the skb 
>> queue mapping whereas the queue to start was selected based on the hardware
>> tx queue to mac80211 queue mapping. These may not in all situations be one 
>> and the same.
> Instead of working around this, we need to make sure that those are
> always identical.
> 
>> This patch is against latest wireless-testing but I've only tested it 
>> against compat-wireless-2010-10-19 with openwrt patches on top (including 
>> Luis latest pcu lock patch) and some other patches I'm working on. If you 
>> can run wireless-testing directly, please give it a spin. For me it's a 
>> big improvement in stability under high tx/rx load. 
>> 
>> Any thoughts?
> Let's do a thorough review of the tx path and figure out where the
> mismatch is actually coming from.

Björn, how about this instead? Please test if it improves the stability
in your tests.

--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1747,6 +1747,7 @@ int ath_tx_start(struct ieee80211_hw *hw
 		return -1;
 	}
 
+	q = ath_get_mac80211_qnum(txq->axq_class, sc);
 	r = ath_tx_setup_buffer(hw, bf, skb, txctl);
 	if (unlikely(r)) {
 		ath_print(common, ATH_DBG_FATAL, "TX mem alloc failure\n");
@@ -1756,8 +1757,8 @@ int ath_tx_start(struct ieee80211_hw *hw
 		 * we will at least have to run TX completionon one buffer
 		 * on the queue */
 		spin_lock_bh(&txq->axq_lock);
-		if (!txq->stopped && txq->axq_depth > 1) {
-			ath_mac80211_stop_queue(sc, skb_get_queue_mapping(skb));
+		if (q >= 0 && !txq->stopped && txq->axq_depth > 1) {
+			ath_mac80211_stop_queue(sc, q);
 			txq->stopped = 1;
 		}
 		spin_unlock_bh(&txq->axq_lock);
@@ -1767,13 +1768,10 @@ int ath_tx_start(struct ieee80211_hw *hw
 		return r;
 	}
 
-	q = skb_get_queue_mapping(skb);
-	if (q >= 4)
-		q = 0;
-
 	spin_lock_bh(&txq->axq_lock);
-	if (++sc->tx.pending_frames[q] > ATH_MAX_QDEPTH && !txq->stopped) {
-		ath_mac80211_stop_queue(sc, skb_get_queue_mapping(skb));
+	if (q >= 0 && ++sc->tx.pending_frames[q] > ATH_MAX_QDEPTH &&
+	    !txq->stopped) {
+		ath_mac80211_stop_queue(sc, q);
 		txq->stopped = 1;
 	}
 	spin_unlock_bh(&txq->axq_lock);
@@ -1841,7 +1839,8 @@ exit:
 /*****************/
 
 static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
-			    struct ath_wiphy *aphy, int tx_flags)
+			    struct ath_wiphy *aphy, struct ath_txq *txq,
+			    int tx_flags)
 {
 	struct ieee80211_hw *hw = sc->hw;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
@@ -1887,11 +1886,8 @@ static void ath_tx_complete(struct ath_s
 	if (unlikely(tx_info->pad[0] & ATH_TX_INFO_FRAME_TYPE_INTERNAL))
 		ath9k_tx_status(hw, skb);
 	else {
-		q = skb_get_queue_mapping(skb);
-		if (q >= 4)
-			q = 0;
-
-		if (--sc->tx.pending_frames[q] < 0)
+		q = ath_get_mac80211_qnum(txq->axq_class, sc);
+		if (q >= 0 && --sc->tx.pending_frames[q] < 0)
 			sc->tx.pending_frames[q] = 0;
 
 		ieee80211_tx_status(hw, skb);
@@ -1928,7 +1924,7 @@ static void ath_tx_complete_buf(struct a
 			complete(&sc->paprd_complete);
 	} else {
 		ath_debug_stat_tx(sc, txq, bf, ts);
-		ath_tx_complete(sc, skb, bf->aphy, tx_flags);
+		ath_tx_complete(sc, skb, bf->aphy, txq, tx_flags);
 	}
 	/* At this point, skb (bf->bf_mpdu) is consumed...make sure we don't
 	 * accidentally reference it later.
