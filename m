Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56111 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbZKGUTC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 15:19:02 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	mcgrof@gmail.com, "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"Jouni.Malinen" <Jouni.Malinen@atheros.com>
Subject: [PATCH 06/29] ath9k: use correct hw for tx aggregation TX completion
Date: Sat,  7 Nov 2009 15:18:43 -0500
Message-Id: <1257625146-17971-7-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
References: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When ath9k virtual wiphys are used the sc->hw will not always represent
the active hw, instead we need to get it from the skb->cb private
driver area. This ensures the right hw is used to find a sta for
the TX'd skb.

Cc: Jouni.Malinen <Jouni.Malinen@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 8e052f4..63c644b 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -267,7 +267,10 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 	struct ath_node *an = NULL;
 	struct sk_buff *skb;
 	struct ieee80211_sta *sta;
+	struct ieee80211_hw *hw;
 	struct ieee80211_hdr *hdr;
+	struct ieee80211_tx_info *tx_info;
+	struct ath_tx_info_priv *tx_info_priv;
 	struct ath_atx_tid *tid = NULL;
 	struct ath_buf *bf_next, *bf_last = bf->bf_lastbf;
 	struct ath_desc *ds = bf_last->bf_desc;
@@ -280,6 +283,10 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 	skb = bf->bf_mpdu;
 	hdr = (struct ieee80211_hdr *)skb->data;
 
+	tx_info = IEEE80211_SKB_CB(skb);
+	tx_info_priv = (struct ath_tx_info_priv *) tx_info->rate_driver_data[0];
+	hw = tx_info_priv->aphy->hw;
+
 	rcu_read_lock();
 
 	/* XXX: use ieee80211_find_sta! */
-- 
1.6.5.2.143.g8cc62

