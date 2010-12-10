Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42931 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754622Ab0LJUQx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Dec 2010 15:16:53 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH] ath9k: fix sequence number assigment for non-AMPDU QoS data frames
Date: Fri, 10 Dec 2010 21:16:46 +0100
Message-Id: <1292012206-12020-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wireless-testing commit 04caf863750bc7e042d1e8d57e5ce9d6326ab435
('ath9k: more tx setup cleanups') merged tx path code for HT vs
non-HT frames, however it did not pass the tid pointer to
ath_tx_send_normal, causing an inconsistency between AMPDU vs
non-AMPDU sequence number handling.
Fix this by always passing in the tid pointer for all QoS data frames.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 43c0109..96623695 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1685,17 +1685,20 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct list_head bf_head;
-	struct ath_atx_tid *tid;
+	struct ath_atx_tid *tid = NULL;
 	u8 tidno;
 
 	spin_lock_bh(&txctl->txq->axq_lock);
 
-	if ((tx_info->flags & IEEE80211_TX_CTL_AMPDU) && txctl->an) {
+	if (ieee80211_is_data_qos(hdr->frame_control) && txctl->an) {
 		tidno = ieee80211_get_qos_ctl(hdr)[0] &
 			IEEE80211_QOS_CTL_TID_MASK;
 		tid = ATH_AN_2_TID(txctl->an, tidno);
 
 		WARN_ON(tid->ac->txq != txctl->txq);
+	}
+
+	if ((tx_info->flags & IEEE80211_TX_CTL_AMPDU) && tid) {
 		/*
 		 * Try aggregation if it's a unicast data frame
 		 * and the destination is HT capable.
@@ -1712,7 +1715,7 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 			ar9003_hw_set_paprd_txdesc(sc->sc_ah, bf->bf_desc,
 						   bf->bf_state.bfs_paprd);
 
-		ath_tx_send_normal(sc, txctl->txq, NULL, &bf_head);
+		ath_tx_send_normal(sc, txctl->txq, tid, &bf_head);
 	}
 
 	spin_unlock_bh(&txctl->txq->axq_lock);
-- 
1.7.3.2

