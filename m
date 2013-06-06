Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:55833 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932076Ab3FFJNT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 05:13:19 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, nbd@nbd.name,
	johannes@sipsolutions.net, mickflemm@gmail.com,
	mcgrof@qca.qualcomm.com, rmanohar@qca.qualcomm.com,
	adrian@freebsd.org, ath5k-devel@lists.ath5k.org,
	bvahl@net.t-labs.tu-berlin.de
Subject: [PATCH] ath5k: make use of the new rate control API
Date: Thu,  6 Jun 2013 11:04:52 +0200
Message-Id: <1370509492-24293-1-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20130606_111351_425302_D74A9BBA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch enabels ath5k to use the new rate table to lookup each
mrr rate and retry information per packet.

Signed-off-by: Benjamin Vahl <bvahl@net.t-labs.tu-berlin.de>
Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
 drivers/net/wireless/ath/ath5k/base.c         |   73 +++++++++++++++++++++----
 drivers/net/wireless/ath/ath5k/base.h         |   14 +++--
 drivers/net/wireless/ath/ath5k/mac80211-ops.c |    2 +-
 3 files changed, 70 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 7f702fe..d447b6d 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -60,6 +60,7 @@
 
 #include <asm/unaligned.h>
 
+#include <net/mac80211.h>
 #include "base.h"
 #include "reg.h"
 #include "debug.h"
@@ -666,15 +667,53 @@ static enum ath5k_pkt_type get_hw_packet_type(struct sk_buff *skb)
 	return htype;
 }
 
+static struct ieee80211_rate *
+ath5k_get_rate(const struct ieee80211_hw *hw,
+	       const struct ieee80211_tx_info *info,
+	       struct ath5k_buf *bf, int idx)
+{
+	/*
+	* convert a ieee80211_tx_rate RC-table entry to
+	* the respective ieee80211_rate struct
+	*/
+	if (bf->rates[idx].idx < 0) {
+		return NULL;
+	}
+
+	return &hw->wiphy->bands[info->band]->bitrates[ bf->rates[idx].idx ];
+}
+
+static u16
+ath5k_get_rate_hw_value(const struct ieee80211_hw *hw,
+			const struct ieee80211_tx_info *info,
+			struct ath5k_buf *bf, int idx)
+{
+	struct ieee80211_rate *rate;
+	u16 hw_rate;
+	u8 rc_flags;
+
+	rate = ath5k_get_rate(hw, info, bf, idx);
+	if (!rate)
+		return 0;
+
+	rc_flags = bf->rates[idx].flags;
+	hw_rate = (rc_flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE) ?
+		   rate->hw_value_short : rate->hw_value;
+
+	return hw_rate;
+}
+
 static int
 ath5k_txbuf_setup(struct ath5k_hw *ah, struct ath5k_buf *bf,
-		  struct ath5k_txq *txq, int padsize)
+		  struct ath5k_txq *txq, int padsize,
+		  struct ieee80211_tx_control *control)
 {
 	struct ath5k_desc *ds = bf->desc;
 	struct sk_buff *skb = bf->skb;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	unsigned int pktlen, flags, keyidx = AR5K_TXKEYIX_INVALID;
 	struct ieee80211_rate *rate;
+	struct ieee80211_tx_rate txrate;
 	unsigned int mrr_rate[3], mrr_tries[3];
 	int i, ret;
 	u16 hw_rate;
@@ -688,7 +727,11 @@ ath5k_txbuf_setup(struct ath5k_hw *ah, struct ath5k_buf *bf,
 	bf->skbaddr = dma_map_single(ah->dev, skb->data, skb->len,
 			DMA_TO_DEVICE);
 
-	rate = ieee80211_get_tx_rate(ah->hw, info);
+	ieee80211_get_tx_rates(info->control.vif, (control) ? control->sta : NULL, skb, bf->rates,
+			       ARRAY_SIZE(bf->rates));
+
+	rate = ath5k_get_rate(ah->hw, info, bf, 0);
+
 	if (!rate) {
 		ret = -EINVAL;
 		goto err_unmap;
@@ -698,8 +741,8 @@ ath5k_txbuf_setup(struct ath5k_hw *ah, struct ath5k_buf *bf,
 		flags |= AR5K_TXDESC_NOACK;
 
 	rc_flags = info->control.rates[0].flags;
-	hw_rate = (rc_flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE) ?
-		rate->hw_value_short : rate->hw_value;
+
+	hw_rate = ath5k_get_rate_hw_value(ah->hw, info, bf, 0);
 
 	pktlen = skb->len;
 
@@ -722,12 +765,15 @@ ath5k_txbuf_setup(struct ath5k_hw *ah, struct ath5k_buf *bf,
 		duration = le16_to_cpu(ieee80211_ctstoself_duration(ah->hw,
 			info->control.vif, pktlen, info));
 	}
+
+	txrate.count = bf->rates[0].count;
+
 	ret = ah->ah_setup_tx_desc(ah, ds, pktlen,
 		ieee80211_get_hdrlen_from_skb(skb), padsize,
 		get_hw_packet_type(skb),
 		(ah->ah_txpower.txp_requested * 2),
 		hw_rate,
-		info->control.rates[0].count, keyidx, ah->ah_tx_ant, flags,
+		txrate.count, keyidx, ah->ah_tx_ant, flags,
 		cts_rate, duration);
 	if (ret)
 		goto err_unmap;
@@ -736,13 +782,15 @@ ath5k_txbuf_setup(struct ath5k_hw *ah, struct ath5k_buf *bf,
 	if (ah->ah_capabilities.cap_has_mrr_support) {
 		memset(mrr_rate, 0, sizeof(mrr_rate));
 		memset(mrr_tries, 0, sizeof(mrr_tries));
+
 		for (i = 0; i < 3; i++) {
-			rate = ieee80211_get_alt_retry_rate(ah->hw, info, i);
+
+			rate = ath5k_get_rate(ah->hw, info, bf, i);
 			if (!rate)
 				break;
 
-			mrr_rate[i] = rate->hw_value;
-			mrr_tries[i] = info->control.rates[i + 1].count;
+			mrr_rate[i] = ath5k_get_rate_hw_value(ah->hw, info, bf, i);
+			mrr_tries[i] = bf->rates[i].count;
 		}
 
 		ath5k_hw_setup_mrr_tx_desc(ah, ds,
@@ -1515,7 +1563,7 @@ unlock:
 
 void
 ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
-	       struct ath5k_txq *txq)
+	       struct ath5k_txq *txq, struct ieee80211_tx_control *control)
 {
 	struct ath5k_hw *ah = hw->priv;
 	struct ath5k_buf *bf;
@@ -1555,7 +1603,7 @@ ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
 
 	bf->skb = skb;
 
-	if (ath5k_txbuf_setup(ah, bf, txq, padsize)) {
+	if (ath5k_txbuf_setup(ah, bf, txq, padsize, control)) {
 		bf->skb = NULL;
 		spin_lock_irqsave(&ah->txbuflock, flags);
 		list_add_tail(&bf->list, &ah->txbuf);
@@ -1917,7 +1965,7 @@ ath5k_beacon_send(struct ath5k_hw *ah)
 
 	skb = ieee80211_get_buffered_bc(ah->hw, vif);
 	while (skb) {
-		ath5k_tx_queue(ah->hw, skb, ah->cabq);
+		ath5k_tx_queue(ah->hw, skb, ah->cabq, NULL);
 
 		if (ah->cabq->txq_len >= ah->cabq->txq_max)
 			break;
@@ -2442,7 +2490,8 @@ ath5k_init_ah(struct ath5k_hw *ah, const struct ath_bus_ops *bus_ops)
 			IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 			IEEE80211_HW_SIGNAL_DBM |
 			IEEE80211_HW_MFP_CAPABLE |
-			IEEE80211_HW_REPORTS_TX_ACK_STATUS;
+			IEEE80211_HW_REPORTS_TX_ACK_STATUS |
+			IEEE80211_HW_SUPPORTS_RC_TABLE;
 
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_AP) |
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index 6c94c7f..ca9a83c 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -47,6 +47,7 @@ struct ath5k_hw;
 struct ath5k_txq;
 struct ieee80211_channel;
 struct ath_bus_ops;
+struct ieee80211_tx_control;
 enum nl80211_iftype;
 
 enum ath5k_srev_type {
@@ -61,11 +62,12 @@ struct ath5k_srev_name {
 };
 
 struct ath5k_buf {
-	struct list_head	list;
-	struct ath5k_desc	*desc;	/* virtual addr of desc */
-	dma_addr_t		daddr;	/* physical addr of desc */
-	struct sk_buff		*skb;	/* skbuff for buf */
-	dma_addr_t		skbaddr;/* physical addr of skb data */
+	struct list_head		list;
+	struct ath5k_desc		*desc;		/* virtual addr of desc */
+	dma_addr_t			daddr;		/* physical addr of desc */
+	struct sk_buff			*skb;		/* skbuff for buf */
+	dma_addr_t			skbaddr;	/* physical addr of skb data */
+	struct ieee80211_tx_rate	rates[4];	/* number of multi-rate stages */
 };
 
 struct ath5k_vif {
@@ -103,7 +105,7 @@ int ath5k_chan_set(struct ath5k_hw *ah, struct ieee80211_channel *chan);
 void ath5k_txbuf_free_skb(struct ath5k_hw *ah, struct ath5k_buf *bf);
 void ath5k_rxbuf_free_skb(struct ath5k_hw *ah, struct ath5k_buf *bf);
 void ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
-		    struct ath5k_txq *txq);
+		    struct ath5k_txq *txq, struct ieee80211_tx_control *control);
 
 const char *ath5k_chip_name(enum ath5k_srev_type type, u_int16_t val);
 
diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index 06f86f4..81b686c 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -66,7 +66,7 @@ ath5k_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 		return;
 	}
 
-	ath5k_tx_queue(hw, skb, &ah->txqs[qnum]);
+	ath5k_tx_queue(hw, skb, &ah->txqs[qnum], control);
 }
 
 
-- 
1.7.9.5

