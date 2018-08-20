Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53402 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbeHTMwr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Aug 2018 08:52:47 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH] ath9k: fix tx99 with monitor mode interface
Date: Mon, 20 Aug 2018 11:37:51 +0200
Message-Id: <20180820093751.63406-1-nbd@nbd.name> (sfid-20180820_113757_239877_AE2CFA01)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tx99 is typically configured via a monitor mode interface, which does
not get added to the driver as a vif. Since the code currently expects
a configured virtual interface for tx99, enabling tx99 via debugfs fails.
Since the vif is not needed anyway, remove all checks for it.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  1 -
 drivers/net/wireless/ath/ath9k/main.c  | 12 +++---------
 drivers/net/wireless/ath/ath9k/tx99.c  |  9 ---------
 drivers/net/wireless/ath/ath9k/xmit.c  |  2 +-
 4 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 21ba20981a80..003e9fb456ac 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -1074,7 +1074,6 @@ struct ath_softc {
 
 	struct ath_spec_scan_priv spec_priv;
 
-	struct ieee80211_vif *tx99_vif;
 	struct sk_buff *tx99_skb;
 	bool tx99_state;
 	s16 tx99_power;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 1049773378f2..fea1f17500aa 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1251,15 +1251,10 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 	struct ath_vif *avp = (void *)vif->drv_priv;
 	struct ath_node *an = &avp->mcast_node;
 
-	mutex_lock(&sc->mutex);
+	if (IS_ENABLED(CPTCFG_ATH9K_TX99))
+		return -EOPNOTSUPP;
 
-	if (IS_ENABLED(CONFIG_ATH9K_TX99)) {
-		if (sc->cur_chan->nvifs >= 1) {
-			mutex_unlock(&sc->mutex);
-			return -EOPNOTSUPP;
-		}
-		sc->tx99_vif = vif;
-	}
+	mutex_lock(&sc->mutex);
 
 	ath_dbg(common, CONFIG, "Attach a VIF of type: %d\n", vif->type);
 	sc->cur_chan->nvifs++;
@@ -1342,7 +1337,6 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 	ath9k_p2p_remove_vif(sc, vif);
 
 	sc->cur_chan->nvifs--;
-	sc->tx99_vif = NULL;
 	if (!ath9k_is_chanctx_enabled())
 		list_del(&avp->list);
 
diff --git a/drivers/net/wireless/ath/ath9k/tx99.c b/drivers/net/wireless/ath/ath9k/tx99.c
index ce50d8f5835e..9b05ffb68c34 100644
--- a/drivers/net/wireless/ath/ath9k/tx99.c
+++ b/drivers/net/wireless/ath/ath9k/tx99.c
@@ -54,12 +54,6 @@ static struct sk_buff *ath9k_build_tx99_skb(struct ath_softc *sc)
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_tx_info *tx_info;
 	struct sk_buff *skb;
-	struct ath_vif *avp;
-
-	if (!sc->tx99_vif)
-		return NULL;
-
-	avp = (struct ath_vif *)sc->tx99_vif->drv_priv;
 
 	skb = alloc_skb(len, GFP_KERNEL);
 	if (!skb)
@@ -77,14 +71,11 @@ static struct sk_buff *ath9k_build_tx99_skb(struct ath_softc *sc)
 	memcpy(hdr->addr2, hw->wiphy->perm_addr, ETH_ALEN);
 	memcpy(hdr->addr3, hw->wiphy->perm_addr, ETH_ALEN);
 
-	hdr->seq_ctrl |= cpu_to_le16(avp->seq_no);
-
 	tx_info = IEEE80211_SKB_CB(skb);
 	memset(tx_info, 0, sizeof(*tx_info));
 	rate = &tx_info->control.rates[0];
 	tx_info->band = sc->cur_chan->chandef.chan->band;
 	tx_info->flags = IEEE80211_TX_CTL_NO_ACK;
-	tx_info->control.vif = sc->tx99_vif;
 	rate->count = 1;
 	if (ah->curchan && IS_CHAN_HT(ah->curchan)) {
 		rate->flags |= IEEE80211_TX_RC_MCS;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 43b6c8508e49..66b6a8872c06 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2973,7 +2973,7 @@ int ath9k_tx99_send(struct ath_softc *sc, struct sk_buff *skb,
 		return -EINVAL;
 	}
 
-	ath_set_rates(sc->tx99_vif, NULL, bf);
+	ath_set_rates(NULL, NULL, bf);
 
 	ath9k_hw_set_desc_link(sc->sc_ah, bf->bf_desc, bf->bf_daddr);
 	ath9k_hw_tx99_start(sc->sc_ah, txctl->txq->axq_qnum);
-- 
2.17.0
