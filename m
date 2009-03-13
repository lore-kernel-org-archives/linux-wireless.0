Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:63487 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754116AbZCMDaO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2009 23:30:14 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2009 20:30:13 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18873.53841.235529.897227@gargle.gargle.HOWL> (sfid-20090313_043020_150237_97A2AF1D)
Date: Fri, 13 Mar 2009 08:56:09 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 6/7] ath9k: Fill in ack signal in TX status
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fills the ack_signal field in TX status with an appropriate
value from the TX descriptor.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/xmit.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index e3f3766..0aae8f3 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -1852,13 +1852,17 @@ static int ath_tx_num_badfrms(struct ath_softc *sc, struct ath_buf *bf,
 	return nbad;
 }
 
-static void ath_tx_rc_status(struct ath_buf *bf, struct ath_desc *ds, int nbad)
+static void ath_tx_rc_status(struct ath_buf *bf, struct ath_desc *ds,
+			     int nbad, int txok)
 {
 	struct sk_buff *skb = (struct sk_buff *)bf->bf_mpdu;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ath_tx_info_priv *tx_info_priv = ATH_TX_INFO_PRIV(tx_info);
 
+	if (txok)
+		tx_info->status.ack_signal = ds->ds_txstat.ts_rssi;
+
 	tx_info_priv->update_rc = false;
 	if (ds->ds_txstat.ts_status & ATH9K_TXERR_FILT)
 		tx_info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
@@ -1996,7 +2000,7 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 			nbad = ath_tx_num_badfrms(sc, bf, txok);
 		}
 
-		ath_tx_rc_status(bf, ds, nbad);
+		ath_tx_rc_status(bf, ds, nbad, txok);
 
 		if (bf_isampdu(bf))
 			ath_tx_complete_aggr(sc, txq, bf, &bf_head, txok);
-- 
1.6.2

