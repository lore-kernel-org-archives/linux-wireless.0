Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55462 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbaFKKs3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 06:48:29 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, Felix Fietkau <nbd@openwrt.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 05/28] ath9k: channel context based transmission
Date: Wed, 11 Jun 2014 16:17:53 +0530
Message-ID: <1402483696-2498-6-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140611_124831_769069_39B12C58)
In-Reply-To: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
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
index 8f59cea..ddd2e81 100644
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
index 5aaed39..7972e1e 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2185,13 +2185,18 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
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
@@ -2212,15 +2217,28 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
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

