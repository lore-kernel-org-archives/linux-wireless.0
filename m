Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18000 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345AbaFDNr2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 09:47:28 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, Felix Fietkau <nbd@openwrt.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 05/13] ath9k: channel context based transmission
Date: Wed, 4 Jun 2014 19:16:31 +0530
Message-ID: <1401889599-412-6-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140604_154802_863783_3D6CA6BC)
In-Reply-To: <1401889599-412-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1401889599-412-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

Force queueing of all frames that belong to a virtual interface on
a different channel context, to ensure that they are sent on the
correct channel.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  3 ++-
 drivers/net/wireless/ath/ath9k/xmit.c  | 24 +++++++++++++++++++++---
 2 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 052a2f9..3457234 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -275,8 +275,9 @@ struct ath_node {
 struct ath_tx_control {
 	struct ath_txq *txq;
 	struct ath_node *an;
-	u8 paprd;
 	struct ieee80211_sta *sta;
+	u8 paprd;
+	bool force_channel;
 };
 
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 0c9571a..10a35cd 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2168,13 +2168,18 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_sta *sta = txctl->sta;
 	struct ieee80211_vif *vif = info->control.vif;
+	struct ath_vif *avp = NULL;
 	struct ath_softc *sc = hw->priv;
 	struct ath_txq *txq = txctl->txq;
 	struct ath_atx_tid *tid = NULL;
 	struct ath_buf *bf;
+	bool queue;
 	int q;
 	int ret;
 
+	if (vif)
+		avp = (void *)vif->drv_priv;
+
 	ret = ath_tx_prepare(hw, skb, txctl);
 	if (ret)
 	    return ret;
@@ -2195,15 +2200,28 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 		txq->stopped = true;
 	}
 
-	if (txctl->an && ieee80211_is_data_present(hdr->frame_control))
+	queue = ieee80211_is_data_present(hdr->frame_control);
+
+	/* Force queueing of all frames that belong to a virtual interface on
+	 * a different channel context, to ensure that they are sent on the
+	 * correct channel.
+	 */
+	if (((avp && avp->chanctx != sc->cur_chan) ||
+	     sc->cur_chan->stopped) && !txctl->force_channel) {
+		if (!txctl->an)
+			txctl->an = &avp->mcast_node;
+		info->flags &= ~IEEE80211_TX_CTL_PS_RESPONSE;
+		queue = true;
+	}
+
+	if (txctl->an && queue)
 		tid = ath_get_skb_tid(sc, txctl->an, skb);
 
 	if (info->flags & IEEE80211_TX_CTL_PS_RESPONSE) {
 		ath_txq_unlock(sc, txq);
 		txq = sc->tx.uapsdq;
 		ath_txq_lock(sc, txq);
-	} else if (txctl->an &&
-		   ieee80211_is_data_present(hdr->frame_control)) {
+	} else if (txctl->an && queue) {
 		WARN_ON(tid->ac->txq != txctl->txq);
 
 		if (info->flags & IEEE80211_TX_CTL_CLEAR_PS_FILT)
-- 
2.0.0

