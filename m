Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57464 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757732AbZKXHxU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2009 02:53:20 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Vivek Natarajan <Vivek.Natarajan@atheros.com>
Subject: [PATCH] ath9k: fix processing of TX PS null data frames
Date: Tue, 24 Nov 2009 02:53:25 -0500
Message-Id: <1259049205-32596-1-git-send-email-lrodriguez@atheros.com>
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

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Vivek Natarajan <Vivek.Natarajan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

This should illustrate some changes we need on mac80211 to help
with enabling and completing dynamic PS. The If we don't get an
ACK we be able to tell mac80211 enabling dynamic PS failed so it
can stop assuming we've successfully enabled it. 

Curious how this works with other hardware. When you enable
dynamic PS can you easily check for the ACK from the AP?

What can we do on mac80211 to help with this without making it
too complex?

  Luis


 drivers/net/wireless/ath/ath9k/ath9k.h  |    2 ++
 drivers/net/wireless/ath/ath9k/common.h |    1 +
 drivers/net/wireless/ath/ath9k/mac.c    |    9 +++++++++
 drivers/net/wireless/ath/ath9k/mac.h    |    6 ++++++
 drivers/net/wireless/ath/ath9k/main.c   |   20 ++++++++++++++++++--
 drivers/net/wireless/ath/ath9k/reg.h    |   15 ++++++++++++---
 drivers/net/wireless/ath/ath9k/xmit.c   |   21 +++++++++++++++++++++
 7 files changed, 69 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 2a40fa2..bc81401 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -421,6 +421,8 @@ struct ath_led {
 #define SC_OP_WAIT_FOR_TX_ACK   BIT(18)
 #define SC_OP_BEACON_SYNC       BIT(19)
 #define SC_OP_BT_PRIORITY_DETECTED BIT(21)
+#define SC_OP_NULLFUNC_COMPLETED BIT(22)
+#define SC_OP_PS_ENABLED	BIT(23)
 
 struct ath_wiphy;
 
diff --git a/drivers/net/wireless/ath/ath9k/common.h b/drivers/net/wireless/ath/ath9k/common.h
index 4e11760..b230bb1 100644
--- a/drivers/net/wireless/ath/ath9k/common.h
+++ b/drivers/net/wireless/ath/ath9k/common.h
@@ -78,6 +78,7 @@ struct ath_buf {
 	dma_addr_t bf_daddr;		/* physical addr of desc */
 	dma_addr_t bf_buf_addr;		/* physical addr of data buffer */
 	bool bf_stale;
+	bool bf_isnullfunc;
 	u16 bf_flags;
 	struct ath_buf_state bf_state;
 	dma_addr_t bf_dmacontext;
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 46466ff..09ed441 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -231,6 +231,8 @@ int ath9k_hw_txprocdesc(struct ath_hw *ah, struct ath_desc *ds)
 	ds->ds_txstat.ts_status = 0;
 	ds->ds_txstat.ts_flags = 0;
 
+	if (ads->ds_txstatus1 & AR_FrmXmitOK)
+		ds->ds_txstat.ts_status |= ATH9K_TX_ACKED;
 	if (ads->ds_txstatus1 & AR_ExcessiveRetries)
 		ds->ds_txstat.ts_status |= ATH9K_TXERR_XRETRY;
 	if (ads->ds_txstatus1 & AR_Filtered)
@@ -926,6 +928,13 @@ void ath9k_hw_setuprxdesc(struct ath_hw *ah, struct ath_desc *ds,
 }
 EXPORT_SYMBOL(ath9k_hw_setuprxdesc);
 
+/*
+ * This can stop or re-enables RX.
+ *
+ * If bool is set this will kill any frame which is currently being
+ * transferred between the MAC and baseband and also prevent any new
+ * frames from getting started.
+ */
 bool ath9k_hw_setrxabort(struct ath_hw *ah, bool set)
 {
 	u32 reg;
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index fefb65d..bd602b8 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -76,6 +76,7 @@
 #define ATH9K_TXERR_FIFO           0x04
 #define ATH9K_TXERR_XTXOP          0x08
 #define ATH9K_TXERR_TIMER_EXPIRED  0x10
+#define ATH9K_TX_ACKED		   0x20
 
 #define ATH9K_TX_BA                0x01
 #define ATH9K_TX_PWRMGMT           0x02
@@ -380,6 +381,11 @@ struct ar5416_desc {
 #define AR_TxBaStatus       0x40000000
 #define AR_TxStatusRsvd01   0x80000000
 
+/*
+ * AR_FrmXmitOK - Frame transmission success flag. If set, the frame was
+ * transmitted successfully. If clear, no ACK or BA was received to indicate
+ * successful transmission when we were expecting an ACK or BA.
+ */
 #define AR_FrmXmitOK            0x00000001
 #define AR_ExcessiveRetries     0x00000002
 #define AR_FIFOUnderrun         0x00000004
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 16bdb1b..3fc9af9 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2729,8 +2729,15 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		}
 	}
 
+	/*
+	 * We just prepare to enable PS. We have to wait until our AP has
+	 * ACK'd our null data frame to disable RX otherwise we'll ignore
+	 * those ACKs and end up retransmitting the same null data frames.
+	 * IEEE80211_CONF_CHANGE_PS is only passed by mac80211 for STA mode.
+	 */
 	if (changed & IEEE80211_CONF_CHANGE_PS) {
 		if (conf->flags & IEEE80211_CONF_PS) {
+			sc->sc_flags |= SC_OP_PS_ENABLED;
 			if (!(ah->caps.hw_caps &
 			      ATH9K_HW_CAP_AUTOSLEEP)) {
 				if ((sc->imask & ATH9K_INT_TIM_TIMER) == 0) {
@@ -2738,11 +2745,20 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 					ath9k_hw_set_interrupts(sc->sc_ah,
 							sc->imask);
 				}
-				ath9k_hw_setrxabort(sc->sc_ah, 1);
 			}
-			sc->ps_enabled = true;
+			/*
+			 * At this point we know hardware has received an ACK
+			 * of a previously sent null data frame.
+			 */
+			if ((sc->sc_flags & SC_OP_NULLFUNC_COMPLETED)) {
+				sc->sc_flags &= ~SC_OP_NULLFUNC_COMPLETED;
+				sc->ps_enabled = true;
+				ath9k_hw_setrxabort(sc->sc_ah, 1);
+                        }
 		} else {
 			sc->ps_enabled = false;
+			sc->sc_flags &= ~(SC_OP_PS_ENABLED |
+					  SC_OP_NULLFUNC_COMPLETED);
 			ath9k_setpower(sc, ATH9K_PM_AWAKE);
 			if (!(ah->caps.hw_caps &
 			      ATH9K_HW_CAP_AUTOSLEEP)) {
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 49ec25f..8e653fb 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -1332,13 +1332,22 @@ enum {
 #define AR_MCAST_FIL0       0x8040
 #define AR_MCAST_FIL1       0x8044
 
+/*
+ * AR_DIAG_SW - Register which can be used for diagnostics and testing purposes.
+ *
+ * The force RX abort (AR_DIAG_RX_ABORT, bit 25) can be used in conjunction with
+ * RX block (AR_DIAG_RX_DIS, bit 5) to help fast channel change to shut down
+ * receive. The force RX abort bit will kill any frame which is currently being
+ * transferred between the MAC and baseband. The RX block bit (AR_DIAG_RX_DIS)
+ * will prevent any new frames from getting started.
+ */
 #define AR_DIAG_SW                  0x8048
 #define AR_DIAG_CACHE_ACK           0x00000001
 #define AR_DIAG_ACK_DIS             0x00000002
 #define AR_DIAG_CTS_DIS             0x00000004
 #define AR_DIAG_ENCRYPT_DIS         0x00000008
 #define AR_DIAG_DECRYPT_DIS         0x00000010
-#define AR_DIAG_RX_DIS              0x00000020
+#define AR_DIAG_RX_DIS              0x00000020 /* RX block */
 #define AR_DIAG_LOOP_BACK           0x00000040
 #define AR_DIAG_CORR_FCS            0x00000080
 #define AR_DIAG_CHAN_INFO           0x00000100
@@ -1347,12 +1356,12 @@ enum {
 #define AR_DIAG_FRAME_NV0           0x00020000
 #define AR_DIAG_OBS_PT_SEL1         0x000C0000
 #define AR_DIAG_OBS_PT_SEL1_S       18
-#define AR_DIAG_FORCE_RX_CLEAR      0x00100000
+#define AR_DIAG_FORCE_RX_CLEAR      0x00100000 /* force rx_clear high */
 #define AR_DIAG_IGNORE_VIRT_CS      0x00200000
 #define AR_DIAG_FORCE_CH_IDLE_HIGH  0x00400000
 #define AR_DIAG_EIFS_CTRL_ENA       0x00800000
 #define AR_DIAG_DUAL_CHAIN_INFO     0x01000000
-#define AR_DIAG_RX_ABORT            0x02000000
+#define AR_DIAG_RX_ABORT            0x02000000 /* Force RX abort */
 #define AR_DIAG_SATURATE_CYCLE_CNT  0x04000000
 #define AR_DIAG_OBS_PT_SEL2         0x08000000
 #define AR_DIAG_RX_CLEAR_CTL_LOW    0x10000000
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 745d919..e9194e9 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1602,6 +1602,14 @@ static int ath_tx_setup_buffer(struct ieee80211_hw *hw, struct ath_buf *bf,
 	}
 
 	bf->bf_buf_addr = bf->bf_dmacontext;
+
+	/* tag if this is a nullfunc frame to enable PS when AP acks it */
+	if (ieee80211_is_nullfunc(fc) && ieee80211_has_pm(fc)) {
+		bf->bf_isnullfunc = true;
+		sc->sc_flags &= ~SC_OP_NULLFUNC_COMPLETED;
+	} else
+		bf->bf_isnullfunc = false;
+
 	return 0;
 }
 
@@ -1995,6 +2003,19 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 		}
 
 		/*
+		 * We now know the nullfunc frame has been ACKed so we
+		 * can disable RX.
+		 */
+		if (bf->bf_isnullfunc &&
+		    (ds->ds_txstat.ts_status & ATH9K_TX_ACKED)) {
+			if ((sc->sc_flags & SC_OP_PS_ENABLED)) {
+				sc->ps_enabled = true;
+				ath9k_hw_setrxabort(sc->sc_ah, 1);
+			} else
+				sc->sc_flags |= SC_OP_NULLFUNC_COMPLETED;
+		}
+
+		/*
 		 * Remove ath_buf's of the same transmit unit from txq,
 		 * however leave the last descriptor back as the holding
 		 * descriptor for hw.
-- 
1.6.5.2.155.gbb47

