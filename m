Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:37018 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581AbYLCTfW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2008 14:35:22 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 03 Dec 2008 11:35:22 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Sujith <Sujith.Manoharan@atheros.com>
Subject: [PATCH v3 2/2] ath9k: Use GFP_ATOMIC when allocating TX private area
Date: Wed, 3 Dec 2008 03:35:30 -0800
Message-ID: <1228304130-11337-3-git-send-email-lrodriguez@atheros.com> (sfid-20081203_203526_763236_CD8AD72C)
In-Reply-To: <1228304130-11337-2-git-send-email-lrodriguez@atheros.com>
References: <1228304130-11337-1-git-send-email-lrodriguez@atheros.com>
 <1228304130-11337-2-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using GFP_KERNEL was wrong and produces a 'scheduling while atomic'
bug as we're in a tasklet. Also, check for proper return values
now, in case allocation fails and be sure to stop the TX queue
in case of memory issues but gaurantee the TX queue will
eventually be woken up.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/xmit.c |   22 ++++++++++++++++++++--
 1 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index f98a795..1b97ced 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -1663,7 +1663,9 @@ static int ath_tx_setup_buffer(struct ath_softc *sc, struct ath_buf *bf,
 	int hdrlen;
 	__le16 fc;
 
-	tx_info_priv = kzalloc(sizeof(*tx_info_priv), GFP_KERNEL);
+	tx_info_priv = kzalloc(sizeof(*tx_info_priv), GFP_ATOMIC);
+	if (unlikely(!tx_info_priv))
+		return -ENOMEM;
 	tx_info->rate_driver_data[0] = tx_info_priv;
 	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
 	fc = hdr->frame_control;
@@ -1813,10 +1815,26 @@ int ath_tx_start(struct ath_softc *sc, struct sk_buff *skb,
 
 	r = ath_tx_setup_buffer(sc, bf, skb, txctl);
 	if (unlikely(r)) {
-		spin_lock_bh(&sc->sc_txbuflock);
+		struct ath_txq *txq = txctl->txq;
+
 		DPRINTF(sc, ATH_DBG_FATAL, "TX mem alloc failure\n");
+
+		/* upon ath_tx_processq() this TX queue will be resumed, we
+		 * guarantee this will happen by knowing beforehand that
+		 * we will at least have to run TX completionon one buffer
+		 * on the queue */
+		spin_lock_bh(&txq->axq_lock);
+		if (ath_txq_depth(sc, txq->axq_qnum) > 1) {
+			ieee80211_stop_queue(sc->hw,
+				skb_get_queue_mapping(skb));
+			txq->stopped = 1;
+		}
+		spin_unlock_bh(&txq->axq_lock);
+
+		spin_lock_bh(&sc->sc_txbuflock);
 		list_add_tail(&bf->list, &sc->sc_txbuf);
 		spin_unlock_bh(&sc->sc_txbuflock);
+
 		return r;
 	}
 
-- 
1.5.6.rc2.15.g457bb.dirty

