Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:12682 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751354Ab1AYFYP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jan 2011 00:24:15 -0500
Received: from vs3009.wh2.ocn.ne.jp (125.206.180.237)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0707103053
	for <linux-wireless@vger.kernel.org>; Tue, 25 Jan 2011 14:24:13 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: [PATCH 1/2] ath5k: use tracing for packet tx/rx dump
Date: Tue, 25 Jan 2011 14:24:10 +0900
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	mickflemm@gmail.com, jirislaby@gmail.com, lrodriguez@atheros.com
References: <1295929976-11858-1-git-send-email-me@bobcopeland.com>
In-Reply-To: <1295929976-11858-1-git-send-email-me@bobcopeland.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201101251424.10765.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue January 25 2011 13:32:55 Bob Copeland wrote:
> This adds a few tracepoints to ath5k driver transmit and
> receive callbacks in order to record packet traffic.
> We record the entire packet in the trace buffer so that
> the data can be extracted with trace-cmd and external
> plugins.
> 
> Compared to the previous debugging calls, this approach
> removes an out-of-line function call from the tx and rx
> paths in the compiled-in-but-disabled case, while
> improving the ability to process the logged data.
> 
> A new option, CONFIG_ATH5K_TRACER, is added so that one
> may disable the tracepoints completely.
> 
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
> 
>  drivers/net/wireless/ath/ath5k/Kconfig |   11 +++
>  drivers/net/wireless/ath/ath5k/base.c  |   16 +++--
>  drivers/net/wireless/ath/ath5k/trace.h |  107
> ++++++++++++++++++++++++++++++++ 3 files changed, 128 insertions(+), 6
> deletions(-)
>  create mode 100644 drivers/net/wireless/ath/ath5k/trace.h
> 
> diff --git a/drivers/net/wireless/ath/ath5k/Kconfig
> b/drivers/net/wireless/ath/ath5k/Kconfig index e079331..e18a9aa 100644
> --- a/drivers/net/wireless/ath/ath5k/Kconfig
> +++ b/drivers/net/wireless/ath/ath5k/Kconfig
> @@ -40,6 +40,17 @@ config ATH5K_DEBUG
> 
>  	  modprobe ath5k debug=0x00000400
> 
> +config ATH5K_TRACER
> +	bool "Atheros 5xxx tracer"
> +	depends on ATH5K
> +	depends on EVENT_TRACING
> +	---help---
> +	  Say Y here to enable tracepoints for the ath5k driver
> +	  using the kernel tracing infrastructure.  Select this
> +	  option if you are interested in debugging the driver.
> +
> +	  If unsure, say N.
> +
>  config ATH5K_AHB
>  	bool "Atheros 5xxx AHB bus support"
>  	depends on (ATHEROS_AR231X && !PCI)
> diff --git a/drivers/net/wireless/ath/ath5k/base.c
> b/drivers/net/wireless/ath/ath5k/base.c index 14377ac..9c59cb6 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -61,6 +61,9 @@
>  #include "debug.h"
>  #include "ani.h"
> 
> +#define CREATE_TRACE_POINTS
> +#include "trace.h"
> +
>  int ath5k_modparam_nohwcrypt;
>  module_param_named(nohwcrypt, ath5k_modparam_nohwcrypt, bool, S_IRUGO);
>  MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
> @@ -1384,7 +1387,7 @@ ath5k_receive_frame(struct ath5k_softc *sc, struct
> sk_buff *skb,
> sc->sbands[sc->curchan->band].bitrates[rxs->rate_idx].hw_value_short)
> rxs->flag |= RX_FLAG_SHORTPRE;
> 
> -	ath5k_debug_dump_skb(sc, skb, "RX  ", 0);
> +	trace_ath5k_rx(sc, skb);
> 
>  	ath5k_update_beacon_rssi(sc, skb, rs->rs_rssi);
> 
> @@ -1529,7 +1532,7 @@ ath5k_tx_queue(struct ieee80211_hw *hw, struct
> sk_buff *skb, unsigned long flags;
>  	int padsize;
> 
> -	ath5k_debug_dump_skb(sc, skb, "TX  ", 1);
> +	trace_ath5k_tx(sc, skb, txq);
> 
>  	/*
>  	 * The hardware expects the header padded to 4 byte boundaries.
> @@ -1578,7 +1581,7 @@ drop_packet:
> 
>  static void
>  ath5k_tx_frame_completed(struct ath5k_softc *sc, struct sk_buff *skb,
> -			 struct ath5k_tx_status *ts)
> +			 struct ath5k_txq *txq, struct ath5k_tx_status *ts)
>  {
>  	struct ieee80211_tx_info *info;
>  	int i;
> @@ -1630,6 +1633,7 @@ ath5k_tx_frame_completed(struct ath5k_softc *sc,
> struct sk_buff *skb, else
>  		sc->stats.antenna_tx[0]++; /* invalid */
> 
> +	trace_ath5k_tx_complete(sc, skb, txq, ts);
>  	ieee80211_tx_status(sc->hw, skb);
>  }
> 
> @@ -1666,7 +1670,7 @@ ath5k_tx_processq(struct ath5k_softc *sc, struct
> ath5k_txq *txq)
> 
>  			dma_unmap_single(sc->dev, bf->skbaddr, skb->len,
>  					DMA_TO_DEVICE);
> -			ath5k_tx_frame_completed(sc, skb, &ts);
> +			ath5k_tx_frame_completed(sc, skb, txq, &ts);
>  		}
> 
>  		/*
> @@ -1808,8 +1812,6 @@ ath5k_beacon_update(struct ieee80211_hw *hw, struct
> ieee80211_vif *vif) goto out;
>  	}
> 
> -	ath5k_debug_dump_skb(sc, skb, "BC  ", 1);
> -
>  	ath5k_txbuf_free_skb(sc, avf->bbuf);
>  	avf->bbuf->skb = skb;
>  	ret = ath5k_beacon_setup(sc, avf->bbuf);
> @@ -1904,6 +1906,8 @@ ath5k_beacon_send(struct ath5k_softc *sc)
>  			sc->opmode == NL80211_IFTYPE_MESH_POINT)
>  		ath5k_beacon_update(sc->hw, vif);
> 
> +	trace_ath5k_tx(sc, bf->skb, &sc->txqs[sc->bhalq]);
> +
>  	ath5k_hw_set_txdp(ah, sc->bhalq, bf->daddr);
>  	ath5k_hw_start_tx_dma(ah, sc->bhalq);
>  	ATH5K_DBG(sc, ATH5K_DEBUG_BEACON, "TXDP[%u] = %llx (%p)\n",
> diff --git a/drivers/net/wireless/ath/ath5k/trace.h
> b/drivers/net/wireless/ath/ath5k/trace.h new file mode 100644
> index 0000000..2de68ad
> --- /dev/null
> +++ b/drivers/net/wireless/ath/ath5k/trace.h
> @@ -0,0 +1,107 @@
> +#if !defined(__TRACE_ATH5K_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define __TRACE_ATH5K_H
> +
> +#include <linux/tracepoint.h>
> +#include "base.h"
> +
> +#ifndef CONFIG_ATH5K_TRACER
> +#undef TRACE_EVENT
> +#define TRACE_EVENT(name, proto, ...) \
> +static inline void trace_ ## name(proto) {}
> +#endif
> +
> +struct sk_buff;
> +
> +#define PRIV_ENTRY  __field(struct ath5k_softc *, priv)
> +#define PRIV_ASSIGN __entry->priv = priv
> +
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM ath5k
> +
> +TRACE_EVENT(ath5k_rx,
> +	TP_PROTO(struct ath5k_softc *priv, struct sk_buff *skb),
> +	TP_ARGS(priv, skb),
> +	TP_STRUCT__entry(
> +		PRIV_ENTRY
> +		__field(unsigned long, skbaddr)
> +		__dynamic_array(u8, frame, skb->len)
> +	),
> +	TP_fast_assign(
> +		PRIV_ASSIGN;
> +		__entry->skbaddr = (unsigned long) skb;
> +		memcpy(__get_dynamic_array(frame), skb->data, skb->len);
> +	),
> +	TP_printk(
> +		"[%p] RX skb=%lx", __entry->priv, __entry->skbaddr
> +	)
> +);
> +
> +TRACE_EVENT(ath5k_tx,
> +	TP_PROTO(struct ath5k_softc *priv, struct sk_buff *skb,
> +		 struct ath5k_txq *q),
> +
> +	TP_ARGS(priv, skb, q),
> +
> +	TP_STRUCT__entry(
> +		PRIV_ENTRY
> +		__field(unsigned long, skbaddr)
> +		__field(u8, qnum)
> +		__dynamic_array(u8, frame, skb->len)
> +	),
> +
> +	TP_fast_assign(
> +		PRIV_ASSIGN;
> +		__entry->skbaddr = (unsigned long) skb;
> +		__entry->qnum = (u8) q->qnum;
> +		memcpy(__get_dynamic_array(frame), skb->data, skb->len);
> +	),
> +
> +	TP_printk(
> +		"[%p] TX skb=%lx q=%d", __entry->priv, __entry->skbaddr,
> +		__entry->qnum
> +	)
> +);
> +
> +TRACE_EVENT(ath5k_tx_complete,
> +	TP_PROTO(struct ath5k_softc *priv, struct sk_buff *skb,
> +		 struct ath5k_txq *q, struct ath5k_tx_status *ts),
> +
> +	TP_ARGS(priv, skb, q, ts),
> +
> +	TP_STRUCT__entry(
> +		PRIV_ENTRY
> +		__field(unsigned long, skbaddr)
> +		__field(u8, qnum)
> +		__field(u8, ts_status)
> +		__field(s8, ts_rssi)
> +		__field(u8, ts_antenna)
> +	),
> +
> +	TP_fast_assign(
> +		PRIV_ASSIGN;
> +		__entry->skbaddr = (unsigned long) skb;
> +		__entry->qnum = (u8) q->qnum;
> +		__entry->ts_status = ts->ts_status;
> +		__entry->ts_rssi =  ts->ts_rssi;
> +		__entry->ts_antenna = ts->ts_antenna;
> +	),
> +
> +	TP_printk(
> +		"[%p] TX end skb=%lx q=%d stat=%x rssi=%d ant=%x",
> +		__entry->priv, __entry->skbaddr, __entry->qnum,
> +		__entry->ts_status, __entry->ts_rssi, __entry->ts_antenna
> +	)
> +);
> +
> +#endif /* __TRACE_ATH5K_H */
> +
> +#ifdef CONFIG_ATH5K_TRACER
> +
> +#undef TRACE_INCLUDE_PATH
> +#define TRACE_INCLUDE_PATH ../../drivers/net/wireless/ath/ath5k
> +#undef TRACE_INCLUDE_FILE
> +#define TRACE_INCLUDE_FILE trace
> +
> +#include <trace/define_trace.h>
> +
> +#endif

Acked-by: Bruno Randolf <br1@einfach.org>
