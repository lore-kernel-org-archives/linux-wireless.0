Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34103 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753940Ab3EQK6c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 May 2013 06:58:32 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH v2 3.10 2/3] ath9k: fix rate handling/reporting
Date: Fri, 17 May 2013 12:58:25 +0200
Message-Id: <1368788306-1605-2-git-send-email-nbd@openwrt.org> (sfid-20130517_125836_714293_832264A4)
In-Reply-To: <1368788306-1605-1-git-send-email-nbd@openwrt.org>
References: <1368788306-1605-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes some issues introduced in the rate control API rework.
When not running aggregation, copy bf->rates into info->control.rates
before applying the rate control status to it.
In ath_lookup_rate, the rates need to be pulled from bf->rates, not the
tx info.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index a47bf69..ad6e0b3 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -630,6 +630,7 @@ static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
 				  struct ath_tx_status *ts, struct ath_buf *bf,
 				  struct list_head *bf_head)
 {
+	struct ieee80211_tx_info *info;
 	bool txok, flush;
 
 	txok = !(ts->ts_status & ATH9K_TXERR_MASK);
@@ -641,8 +642,12 @@ static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
 		txq->axq_ampdu_depth--;
 
 	if (!bf_isampdu(bf)) {
-		if (!flush)
+		if (!flush) {
+			info = IEEE80211_SKB_CB(bf->bf_mpdu);
+			memcpy(info->control.rates, bf->rates,
+			       sizeof(info->control.rates));
 			ath_tx_rc_status(sc, bf, ts, 1, txok ? 0 : 1, txok);
+		}
 		ath_tx_complete_buf(sc, bf, txq, bf_head, ts, txok);
 	} else
 		ath_tx_complete_aggr(sc, txq, bf, bf_head, ts, txok);
@@ -686,7 +691,7 @@ static u32 ath_lookup_rate(struct ath_softc *sc, struct ath_buf *bf,
 
 	skb = bf->bf_mpdu;
 	tx_info = IEEE80211_SKB_CB(skb);
-	rates = tx_info->control.rates;
+	rates = bf->rates;
 
 	/*
 	 * Find the lowest frame length among the rate series that will have a
-- 
1.8.0.2

