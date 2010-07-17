Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1230 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756627Ab0GQTgF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Jul 2010 15:36:05 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: ath5k-devel@lists.ath5k.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH/RFC 2/3] ath5k: use tracing for packet tx/rx dump
Date: Sat, 17 Jul 2010 15:35:35 -0400
Message-Id: <1279395336-856-3-git-send-email-me@bobcopeland.com>
In-Reply-To: <1279395336-856-1-git-send-email-me@bobcopeland.com>
References: <1279395336-856-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds a few tracepoints to ath5k driver transmit and
receive callbacks in order to record packet traffic.

The advantage of this approach over the previous debug
statements in the kernel printk buffer is that the debug
information is no longer an out-of-line function call,
and the trace can be combined with mac80211 tracepoints.

We record the entire packet in the trace buffer so that
the data can be extracted with external scripts.

The corresponding debug dump functions are removed.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/ath5k_trace.h |   97 ++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath5k/base.c        |   12 ++-
 drivers/net/wireless/ath/ath5k/debug.c       |   20 -----
 drivers/net/wireless/ath/ath5k/debug.h       |    4 -
 4 files changed, 105 insertions(+), 28 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath5k/ath5k_trace.h

diff --git a/drivers/net/wireless/ath/ath5k/ath5k_trace.h b/drivers/net/wireless/ath/ath5k/ath5k_trace.h
new file mode 100644
index 0000000..00d9773
--- /dev/null
+++ b/drivers/net/wireless/ath/ath5k/ath5k_trace.h
@@ -0,0 +1,97 @@
+#if !defined(__TRACE_ATH5K_H) || defined(TRACE_HEADER_MULTI_READ)
+#define __TRACE_ATH5K_H
+
+#include <linux/tracepoint.h>
+#include "base.h"
+
+struct sk_buff;
+
+#define PRIV_ENTRY  __field(struct ath5k_softc *, priv)
+#define PRIV_ASSIGN __entry->priv = priv
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM ath5k
+
+TRACE_EVENT(ath5k_rx,
+	TP_PROTO(struct ath5k_softc *priv, struct sk_buff *skb),
+	TP_ARGS(priv, skb),
+	TP_STRUCT__entry(
+		PRIV_ENTRY
+		__field(unsigned long, skbaddr)
+		__dynamic_array(u8, frame, skb->len)
+	),
+	TP_fast_assign(
+		PRIV_ASSIGN;
+		__entry->skbaddr = (unsigned long) skb;
+		memcpy(__get_dynamic_array(frame), skb->data, skb->len);
+	),
+	TP_printk(
+		"[%p] RX skb=%lx", __entry->priv, __entry->skbaddr
+	)
+);
+
+TRACE_EVENT(ath5k_tx,
+	TP_PROTO(struct ath5k_softc *priv, struct sk_buff *skb,
+		 struct ath5k_txq *q),
+
+	TP_ARGS(priv, skb, q),
+
+	TP_STRUCT__entry(
+		PRIV_ENTRY
+		__field(unsigned long, skbaddr)
+		__field(u8, qnum)
+		__dynamic_array(u8, frame, skb->len)
+	),
+
+	TP_fast_assign(
+		PRIV_ASSIGN;
+		__entry->skbaddr = (unsigned long) skb;
+		__entry->qnum = (u8) q->qnum;
+		memcpy(__get_dynamic_array(frame), skb->data, skb->len);
+	),
+
+	TP_printk(
+		"[%p] TX skb=%lx q=%d", __entry->priv, __entry->skbaddr,
+		__entry->qnum
+	)
+);
+
+TRACE_EVENT(ath5k_tx_complete,
+	TP_PROTO(struct ath5k_softc *priv, struct sk_buff *skb,
+		 struct ath5k_txq *q, struct ath5k_tx_status *ts),
+
+	TP_ARGS(priv, skb, q, ts),
+
+	TP_STRUCT__entry(
+		PRIV_ENTRY
+		__field(unsigned long, skbaddr)
+		__field(u8, qnum)
+		__field(u8, ts_status)
+		__field(s8, ts_rssi)
+		__field(u8, ts_antenna)
+	),
+
+	TP_fast_assign(
+		PRIV_ASSIGN;
+		__entry->skbaddr = (unsigned long) skb;
+		__entry->qnum = (u8) q->qnum;
+		__entry->ts_status = ts->ts_status;
+		__entry->ts_rssi =  ts->ts_rssi;
+		__entry->ts_antenna = ts->ts_antenna;
+	),
+
+	TP_printk(
+		"[%p] TX end skb=%lx q=%d stat=%x rssi=%d ant=%x",
+		__entry->priv, __entry->skbaddr, __entry->qnum,
+		__entry->ts_status, __entry->ts_rssi, __entry->ts_antenna
+	)
+);
+
+#endif /* _TRACE_ATH5K_H */
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH ../../drivers/net/wireless/ath/ath5k
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE ath5k_trace
+
+#include <trace/define_trace.h>
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 0d5de25..23a5679 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -61,6 +61,9 @@
 #include "debug.h"
 #include "ani.h"
 
+#define CREATE_TRACE_POINTS
+#include "ath5k_trace.h"
+
 static int modparam_nohwcrypt;
 module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
@@ -1962,7 +1965,7 @@ ath5k_receive_frame(struct ath5k_softc *sc, struct sk_buff *skb,
 	    sc->curband->bitrates[rxs->rate_idx].hw_value_short)
 		rxs->flag |= RX_FLAG_SHORTPRE;
 
-	ath5k_debug_dump_skb(sc, skb, "RX  ", 0);
+	trace_ath5k_rx(sc, skb);
 
 	ath5k_update_beacon_rssi(sc, skb, rs->rs_rssi);
 
@@ -2183,6 +2186,7 @@ ath5k_tx_processq(struct ath5k_softc *sc, struct ath5k_txq *txq)
 		else
 			sc->stats.antenna_tx[0]++; /* invalid */
 
+		trace_ath5k_tx_complete(sc, skb, txq, &ts);
 		ieee80211_tx_status(sc->hw, skb);
 
 		spin_lock(&sc->txbuflock);
@@ -2352,6 +2356,8 @@ ath5k_beacon_send(struct ath5k_softc *sc)
 	if (sc->opmode == NL80211_IFTYPE_AP)
 		ath5k_beacon_update(sc->hw, sc->vif);
 
+	trace_ath5k_tx(sc, bf->skb, &sc->txqs[sc->bhalq]);
+
 	ath5k_hw_set_txdp(ah, sc->bhalq, bf->daddr);
 	ath5k_hw_start_tx_dma(ah, sc->bhalq);
 	ATH5K_DBG(sc, ATH5K_DEBUG_BEACON, "TXDP[%u] = %llx (%p)\n",
@@ -2878,7 +2884,7 @@ static int ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
 	unsigned long flags;
 	int padsize;
 
-	ath5k_debug_dump_skb(sc, skb, "TX  ", 1);
+	trace_ath5k_tx(sc, skb, txq);
 
 	if (sc->opmode == NL80211_IFTYPE_MONITOR)
 		ATH5K_DBG(sc, ATH5K_DEBUG_XMIT, "tx in monitor (scan?)\n");
@@ -3410,8 +3416,6 @@ ath5k_beacon_update(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 		goto out;
 	}
 
-	ath5k_debug_dump_skb(sc, skb, "BC  ", 1);
-
 	ath5k_txbuf_free_skb(sc, sc->bbuf);
 	sc->bbuf->skb = skb;
 	ret = ath5k_beacon_setup(sc, sc->bbuf);
diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index 2222022..d107cd6 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -305,8 +305,6 @@ static const struct {
 	{ ATH5K_DEBUG_CALIBRATE, "calib",	"periodic calibration" },
 	{ ATH5K_DEBUG_TXPOWER,	"txpower",	"transmit power setting" },
 	{ ATH5K_DEBUG_LED,	"led",		"LED management" },
-	{ ATH5K_DEBUG_DUMP_RX,	"dumprx",	"print received skb content" },
-	{ ATH5K_DEBUG_DUMP_TX,	"dumptx",	"print transmit skb content" },
 	{ ATH5K_DEBUG_DUMPBANDS, "dumpbands",	"dump bands" },
 	{ ATH5K_DEBUG_ANI,	"ani",		"adaptive noise immunity" },
 	{ ATH5K_DEBUG_DESC,	"desc",		"descriptor chains" },
@@ -955,24 +953,6 @@ ath5k_debug_printrxbuffs(struct ath5k_softc *sc, struct ath5k_hw *ah)
 }
 
 void
-ath5k_debug_dump_skb(struct ath5k_softc *sc,
-			struct sk_buff *skb, const char *prefix, int tx)
-{
-	char buf[16];
-
-	if (likely(!((tx && (sc->debug.level & ATH5K_DEBUG_DUMP_TX)) ||
-		     (!tx && (sc->debug.level & ATH5K_DEBUG_DUMP_RX)))))
-		return;
-
-	snprintf(buf, sizeof(buf), "%s %s", wiphy_name(sc->hw->wiphy), prefix);
-
-	print_hex_dump_bytes(buf, DUMP_PREFIX_NONE, skb->data,
-		min(200U, skb->len));
-
-	printk(KERN_DEBUG "\n");
-}
-
-void
 ath5k_debug_printtxbuf(struct ath5k_softc *sc, struct ath5k_buf *bf)
 {
 	struct ath5k_desc *ds = bf->desc;
diff --git a/drivers/net/wireless/ath/ath5k/debug.h b/drivers/net/wireless/ath/ath5k/debug.h
index 9b22722..c260b00 100644
--- a/drivers/net/wireless/ath/ath5k/debug.h
+++ b/drivers/net/wireless/ath/ath5k/debug.h
@@ -91,8 +91,6 @@ struct ath5k_dbg_info {
  * @ATH5K_DEBUG_CALIBRATE: periodic calibration
  * @ATH5K_DEBUG_TXPOWER: transmit power setting
  * @ATH5K_DEBUG_LED: led management
- * @ATH5K_DEBUG_DUMP_RX: print received skb content
- * @ATH5K_DEBUG_DUMP_TX: print transmit skb content
  * @ATH5K_DEBUG_DUMPBANDS: dump bands
  * @ATH5K_DEBUG_TRACE: trace function calls
  * @ATH5K_DEBUG_DESC: descriptor setup
@@ -114,8 +112,6 @@ enum ath5k_debug_level {
 	ATH5K_DEBUG_CALIBRATE	= 0x00000020,
 	ATH5K_DEBUG_TXPOWER	= 0x00000040,
 	ATH5K_DEBUG_LED		= 0x00000080,
-	ATH5K_DEBUG_DUMP_RX	= 0x00000100,
-	ATH5K_DEBUG_DUMP_TX	= 0x00000200,
 	ATH5K_DEBUG_DUMPBANDS	= 0x00000400,
 	ATH5K_DEBUG_ANI		= 0x00002000,
 	ATH5K_DEBUG_DESC	= 0x00004000,
-- 
1.7.1.1


