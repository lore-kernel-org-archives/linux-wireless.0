Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:42476 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753912AbYJWD2w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 23:28:52 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2008 20:28:52 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 1/3] ath9k: remove pointless sc_txintrperiod and spin_lock_bh on tx prepare
Date: Wed, 22 Oct 2008 13:28:43 -0700
Message-ID: <1224707325-13101-1-git-send-email-lrodriguez@atheros.com> (sfid-20081023_052910_943682_6D2B11F1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sc_txintrperiod is currently set to 0 and never updated. We won't
be using this, if anything we will consider using TX interrupt
mitigation but that is different and not yet tested. So remove
sc_txintrperiod and the pointless spin_lock_bh() on tx prepare.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h |   13 +++++++++++++
 drivers/net/wireless/ath9k/core.h  |    4 ----
 drivers/net/wireless/ath9k/xmit.c  |   27 ++-------------------------
 3 files changed, 15 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index accace5..a6063de 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -138,6 +138,19 @@ struct ath_desc {
 #define ATH9K_TXDESC_NOACK		0x0002
 #define ATH9K_TXDESC_RTSENA		0x0004
 #define ATH9K_TXDESC_CTSENA		0x0008
+/* ATH9K_TXDESC_INTREQ forces a tx interrupt to be generated for
+ * the descriptor its marked on.  We take a tx interrupt to reap
+ * descriptors when the h/w hits an EOL condition or
+ * when the descriptor is specifically marked to generate
+ * an interrupt with this flag. Descriptors should be
+ * marked periodically to insure timely replenishing of the
+ * supply needed for sending frames. Defering interrupts
+ * reduces system load and potentially allows more concurrent
+ * work to be done but if done to aggressively can cause
+ * senders to backup. When the hardware queue is left too
+ * large rate control information may also be too out of
+ * date. An Alternative for this is TX interrupt mitigation
+ * but this needs more testing. */
 #define ATH9K_TXDESC_INTREQ		0x0010
 #define ATH9K_TXDESC_VEOL		0x0020
 #define ATH9K_TXDESC_EXT_ONLY		0x0040
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 59d835b..fbff9aa 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -443,9 +443,6 @@ struct ath_txq {
 	u8 axq_aggr_depth;		/* aggregates queued */
 	u32 axq_totalqueued;		/* total ever queued */
 
-	/* count to determine if descriptor should generate int on this txq. */
-	u32 axq_intrcnt;
-
 	bool stopped;			/* Is mac80211 queue stopped ? */
 	struct ath_buf *axq_linkbuf;	/* virtual addr of last buffer*/
 
@@ -1007,7 +1004,6 @@ struct ath_softc {
 	struct ath_txq sc_txq[ATH9K_NUM_TX_QUEUES];
 	struct ath_descdma sc_txdma;
 	u32 sc_txqsetup;
-	u32 sc_txintrperiod;	/* tx interrupt batching */
 	int sc_haltype2q[ATH9K_WME_AC_VO+1]; /* HAL WME	AC -> h/w qnum */
 	u16 seq_no; /* TX sequence number */
 
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index ec5ae30..781c6cc 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -286,7 +286,8 @@ static int ath_tx_prepare(struct ath_softc *sc,
 
 	/* Fill flags */
 
-	txctl->flags |= ATH9K_TXDESC_CLRDMASK; /* needed for crypto errors */
+	txctl->flags |= ATH9K_TXDESC_CLRDMASK /* needed for crypto errors */
+		| ATH9K_TXDESC_INTREQ; /* Generate an interrupt */
 
 	if (tx_info->flags & IEEE80211_TX_CTL_NO_ACK)
 		txctl->flags |= ATH9K_TXDESC_NOACK;
@@ -363,28 +364,6 @@ static int ath_tx_prepare(struct ath_softc *sc,
 		rcs[0].tries = ATH_TXMAXTRY;
 	}
 
-	/*
-	 * Determine if a tx interrupt should be generated for
-	 * this descriptor.  We take a tx interrupt to reap
-	 * descriptors when the h/w hits an EOL condition or
-	 * when the descriptor is specifically marked to generate
-	 * an interrupt.  We periodically mark descriptors in this
-	 * way to insure timely replenishing of the supply needed
-	 * for sending frames.  Defering interrupts reduces system
-	 * load and potentially allows more concurrent work to be
-	 * done but if done to aggressively can cause senders to
-	 * backup.
-	 *
-	 * NB: use >= to deal with sc_txintrperiod changing
-	 *     dynamically through sysctl.
-	 */
-	spin_lock_bh(&txq->axq_lock);
-	if ((++txq->axq_intrcnt >= sc->sc_txintrperiod)) {
-		txctl->flags |= ATH9K_TXDESC_INTREQ;
-		txq->axq_intrcnt = 0;
-	}
-	spin_unlock_bh(&txq->axq_lock);
-
 	if (is_multicast_ether_addr(hdr->addr1)) {
 		antenna = sc->sc_mcastantenna + 1;
 		sc->sc_mcastantenna = (sc->sc_mcastantenna + 1) & 0x1;
@@ -1166,7 +1145,6 @@ static int ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 	nacked = 0;
 	for (;;) {
 		spin_lock_bh(&txq->axq_lock);
-		txq->axq_intrcnt = 0; /* reset periodic desc intr count */
 		if (list_empty(&txq->axq_q)) {
 			txq->axq_link = NULL;
 			txq->axq_linkbuf = NULL;
@@ -2164,7 +2142,6 @@ struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype)
 		txq->axq_depth = 0;
 		txq->axq_aggr_depth = 0;
 		txq->axq_totalqueued = 0;
-		txq->axq_intrcnt = 0;
 		txq->axq_linkbuf = NULL;
 		sc->sc_txqsetup |= 1<<qnum;
 	}
-- 
1.5.6.3

