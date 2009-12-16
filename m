Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36235 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758875AbZLPQvr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2009 11:51:47 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: greg@kroah.com, stable@kernel.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Vivek Natarajan <Vivek.Natarajan@atheros.com>
Subject: [PATCH 2/5] ath9k: fix processing of TX PS null data frames
Date: Wed, 16 Dec 2009 11:51:42 -0500
Message-Id: <1260982305-32244-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1260982305-32244-1-git-send-email-lrodriguez@atheros.com>
References: <1260982305-32244-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When mac80211 was telling us to go into Powersave we listened
and immediately turned RX off. This meant hardware would not
see the ACKs from the AP we're associated with and hardware
we'd end up retransmiting the null data frame in a loop
helplessly.

Fix this by keeping track of the transmitted nullfunc frames
and only when we are sure the AP has sent back an ACK do we
go ahead and shut RX off.

This is a backport of upstream commit:

e7824a50662f7f79b1a739f705b4d906c31cf221

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Vivek Natarajan <Vivek.Natarajan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    3 +++
 drivers/net/wireless/ath/ath9k/mac.c   |    2 ++
 drivers/net/wireless/ath/ath9k/mac.h   |    1 +
 drivers/net/wireless/ath/ath9k/main.c  |    9 ++++++++-
 drivers/net/wireless/ath/ath9k/xmit.c  |   16 ++++++++++++++++
 5 files changed, 30 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 1d59f10..cdb90c5 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -139,6 +139,7 @@ struct ath_buf {
 	dma_addr_t bf_daddr;		/* physical addr of desc */
 	dma_addr_t bf_buf_addr;		/* physical addr of data buffer */
 	bool bf_stale;
+	bool bf_isnullfunc;
 	u16 bf_flags;
 	struct ath_buf_state bf_state;
 	dma_addr_t bf_dmacontext;
@@ -524,6 +525,8 @@ struct ath_led {
 #define SC_OP_BEACON_SYNC       BIT(19)
 #define SC_OP_BTCOEX_ENABLED    BIT(20)
 #define SC_OP_BT_PRIORITY_DETECTED BIT(21)
+#define SC_OP_NULLFUNC_COMPLETED   BIT(22)
+#define SC_OP_PS_ENABLED	BIT(23)
 
 struct ath_bus_ops {
 	void		(*read_cachesize)(struct ath_softc *sc, int *csz);
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 800bfab..561a40e 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -222,6 +222,8 @@ int ath9k_hw_txprocdesc(struct ath_hw *ah, struct ath_desc *ds)
 	ds->ds_txstat.ts_status = 0;
 	ds->ds_txstat.ts_flags = 0;
 
+	if (ads->ds_txstatus1 & AR_FrmXmitOK)
+		ds->ds_txstat.ts_status |= ATH9K_TX_ACKED;
 	if (ads->ds_txstatus1 & AR_ExcessiveRetries)
 		ds->ds_txstat.ts_status |= ATH9K_TXERR_XRETRY;
 	if (ads->ds_txstatus1 & AR_Filtered)
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index f56e77d..ff65f85 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -76,6 +76,7 @@
 #define ATH9K_TXERR_FIFO           0x04
 #define ATH9K_TXERR_XTXOP          0x08
 #define ATH9K_TXERR_TIMER_EXPIRED  0x10
+#define ATH9K_TX_ACKED		   0x20
 
 #define ATH9K_TX_BA                0x01
 #define ATH9K_TX_PWRMGMT           0x02
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 43d2be9..59359e3 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2327,6 +2327,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 
 	if (changed & IEEE80211_CONF_CHANGE_PS) {
 		if (conf->flags & IEEE80211_CONF_PS) {
+			sc->sc_flags |= SC_OP_PS_ENABLED;
 			if (!(ah->caps.hw_caps &
 			      ATH9K_HW_CAP_AUTOSLEEP)) {
 				if ((sc->imask & ATH9K_INT_TIM_TIMER) == 0) {
@@ -2334,11 +2335,17 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 					ath9k_hw_set_interrupts(sc->sc_ah,
 							sc->imask);
 				}
-				ath9k_hw_setrxabort(sc->sc_ah, 1);
 			}
 			sc->ps_enabled = true;
+			if ((sc->sc_flags & SC_OP_NULLFUNC_COMPLETED)) {
+				sc->sc_flags &= ~SC_OP_NULLFUNC_COMPLETED;
+				sc->ps_enabled = true;
+				ath9k_hw_setrxabort(sc->sc_ah, 1);
+			}
 		} else {
 			sc->ps_enabled = false;
+			sc->sc_flags &= ~(SC_OP_PS_ENABLED |
+					  SC_OP_NULLFUNC_COMPLETED);
 			ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_AWAKE);
 			if (!(ah->caps.hw_caps &
 			      ATH9K_HW_CAP_AUTOSLEEP)) {
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 972e775..e78bd57 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1592,6 +1592,13 @@ static int ath_tx_setup_buffer(struct ieee80211_hw *hw, struct ath_buf *bf,
 	}
 
 	bf->bf_buf_addr = bf->bf_dmacontext;
+
+	if (ieee80211_is_nullfunc(fc) && ieee80211_has_pm(fc)) {
+		bf->bf_isnullfunc = true;
+		sc->sc_flags &= ~SC_OP_NULLFUNC_COMPLETED;
+	} else
+		bf->bf_isnullfunc = false;
+
 	return 0;
 }
 
@@ -1989,6 +1996,15 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 		if (ds == txq->axq_gatingds)
 			txq->axq_gatingds = NULL;
 
+		if (bf->bf_isnullfunc &&
+		    (ds->ds_txstat.ts_status & ATH9K_TX_ACKED)) {
+			if ((sc->sc_flags & SC_OP_PS_ENABLED)) {
+				sc->ps_enabled = true;
+				ath9k_hw_setrxabort(sc->sc_ah, 1);
+			} else
+				sc->sc_flags |= SC_OP_NULLFUNC_COMPLETED;
+		}
+
 		/*
 		 * Remove ath_buf's of the same transmit unit from txq,
 		 * however leave the last descriptor back as the holding
-- 
1.6.3.3

