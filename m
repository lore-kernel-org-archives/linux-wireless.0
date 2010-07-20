Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:18544 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753487Ab0GTFSh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jul 2010 01:18:37 -0400
Received: from vs3013.wh2.ocn.ne.jp (125.206.180.245)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0648973115
	for <linux-wireless@vger.kernel.org>; Tue, 20 Jul 2010 14:18:35 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: [PATCH/RFC 3/3] ath5k: trace resets
Date: Tue, 20 Jul 2010 14:20:49 +0900
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
References: <1279395336-856-1-git-send-email-me@bobcopeland.com> <1279395336-856-4-git-send-email-me@bobcopeland.com>
In-Reply-To: <1279395336-856-4-git-send-email-me@bobcopeland.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201007201420.49305.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun July 18 2010 04:35:36 Bob Copeland wrote:
> This change adds a tracepoint for ath5k_reset.  We record the
> reason for each reset and the new channel frequency.
> 
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
>  drivers/net/wireless/ath/ath5k/ath5k_trace.h |   38 +++++++++++++++++
>  drivers/net/wireless/ath/ath5k/base.c        |   56
> +++++++------------------- drivers/net/wireless/ath/ath5k/base.h        | 
>  12 ++++++
>  drivers/net/wireless/ath/ath5k/debug.c       |    7 ++-
>  drivers/net/wireless/ath/ath5k/debug.h       |    2 -
>  5 files changed, 70 insertions(+), 45 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath5k/ath5k_trace.h
> b/drivers/net/wireless/ath/ath5k/ath5k_trace.h index 00d9773..3a5112d
> 100644
> --- a/drivers/net/wireless/ath/ath5k/ath5k_trace.h
> +++ b/drivers/net/wireless/ath/ath5k/ath5k_trace.h
> @@ -12,6 +12,44 @@ struct sk_buff;
>  #undef TRACE_SYSTEM
>  #define TRACE_SYSTEM ath5k
> 
> +TRACE_EVENT(ath5k_reset,
> +	TP_PROTO(struct ath5k_softc *priv, struct ieee80211_channel *chan,
> +		 enum ath5k_reset_reason reason),
> +
> +	TP_ARGS(priv, chan, reason),
> +	TP_STRUCT__entry(
> +		PRIV_ENTRY
> +		__field(u32, reason)
> +		__field(u16, freq)
> +	),
> +	TP_fast_assign(
> +		PRIV_ASSIGN;
> +		__entry->reason = reason;
> +		__entry->freq = chan->center_freq;
> +	),
> +	TP_printk(
> +		"[%p] reset reason=%d freq=%u", __entry->priv,
> +		__entry->reason, __entry->freq
> +	)
> +);
> +
> +TRACE_EVENT(ath5k_reset_end,
> +	TP_PROTO(struct ath5k_softc *priv, int result),
> +
> +	TP_ARGS(priv, result),
> +	TP_STRUCT__entry(
> +		PRIV_ENTRY
> +		__field(s32, result)
> +	),
> +	TP_fast_assign(
> +		PRIV_ASSIGN;
> +		__entry->result = (s32) result;
> +	),
> +	TP_printk(
> +		"[%p] reset ret=%d", __entry->priv, __entry->result
> +	)
> +);
> +
>  TRACE_EVENT(ath5k_rx,
>  	TP_PROTO(struct ath5k_softc *priv, struct sk_buff *skb),
>  	TP_ARGS(priv, skb),
> diff --git a/drivers/net/wireless/ath/ath5k/base.c
> b/drivers/net/wireless/ath/ath5k/base.c index 23a5679..44732b5 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -224,7 +224,8 @@ static struct pci_driver ath5k_pci_driver = {
>  static int ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb);
>  static int ath5k_tx_queue(struct ieee80211_hw *hw, struct sk_buff *skb,
>  		struct ath5k_txq *txq);
> -static int ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel
> *chan); +static int ath5k_reset(struct ath5k_softc *sc, struct
> ieee80211_channel *chan, +		       enum ath5k_reset_reason
> ath5k_reset_reason);
>  static int ath5k_start(struct ieee80211_hw *hw);
>  static void ath5k_stop(struct ieee80211_hw *hw);
>  static int ath5k_add_interface(struct ieee80211_hw *hw,
> @@ -1120,17 +1121,13 @@ ath5k_setup_bands(struct ieee80211_hw *hw)
>  static int
>  ath5k_chan_set(struct ath5k_softc *sc, struct ieee80211_channel *chan)
>  {
> -	ATH5K_DBG(sc, ATH5K_DEBUG_RESET,
> -		  "channel set, resetting (%u -> %u MHz)\n",
> -		  sc->curchan->center_freq, chan->center_freq);
> -
>  	/*
>  	 * To switch channels clear any pending DMA operations;
>  	 * wait long enough for the RX fifo to drain, reset the
>  	 * hardware at the new frequency, and then re-enable
>  	 * the relevant bits of the h/w.
>  	 */
> -	return ath5k_reset(sc, chan);
> +	return ath5k_reset(sc, chan, RESET_SET_CHANNEL);
>  }
> 
>  static void
> @@ -1615,8 +1612,6 @@ ath5k_txq_drainq(struct ath5k_softc *sc, struct
> ath5k_txq *txq) */
>  	spin_lock_bh(&txq->lock);
>  	list_for_each_entry_safe(bf, bf0, &txq->q, list) {
> -		ath5k_debug_printtxbuf(sc, bf);
> -
>  		ath5k_txbuf_free_skb(sc, bf);
> 
>  		spin_lock_bh(&sc->txbuflock);
> @@ -1641,18 +1636,9 @@ ath5k_txq_cleanup(struct ath5k_softc *sc)
>  	if (likely(!test_bit(ATH_STAT_INVALID, sc->status))) {
>  		/* don't touch the hardware if marked invalid */
>  		ath5k_hw_stop_tx_dma(ah, sc->bhalq);
> -		ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "beacon queue %x\n",
> -			ath5k_hw_get_txdp(ah, sc->bhalq));
>  		for (i = 0; i < ARRAY_SIZE(sc->txqs); i++)
> -			if (sc->txqs[i].setup) {
> +			if (sc->txqs[i].setup)
>  				ath5k_hw_stop_tx_dma(ah, sc->txqs[i].qnum);
> -				ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "txq [%u] %x, "
> -					"link %p\n",
> -					sc->txqs[i].qnum,
> -					ath5k_hw_get_txdp(ah,
> -							sc->txqs[i].qnum),
> -					sc->txqs[i].link);
> -			}
>  	}
> 
>  	for (i = 0; i < ARRAY_SIZE(sc->txqs); i++)
> @@ -1693,9 +1679,6 @@ ath5k_rx_start(struct ath5k_softc *sc)
> 
>  	common->rx_bufsize = roundup(IEEE80211_MAX_LEN, common->cachelsz);
> 
> -	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "cachelsz %u rx_bufsize %u\n",
> -		  common->cachelsz, common->rx_bufsize);
> -
>  	spin_lock_bh(&sc->rxbuflock);
>  	sc->rxlink = NULL;
>  	list_for_each_entry(bf, &sc->rxbuf, list) {
> @@ -2329,8 +2312,7 @@ ath5k_beacon_send(struct ath5k_softc *sc)
>  			ATH5K_DBG(sc, ATH5K_DEBUG_BEACON,
>  				"stuck beacon time (%u missed)\n",
>  				sc->bmisscount);
> -			ATH5K_DBG(sc, ATH5K_DEBUG_RESET,
> -				  "stuck beacon, resetting\n");
> +			sc->reset_reason = RESET_STUCK_BEACON;
>  			ieee80211_queue_work(sc->hw, &sc->reset_work);
>  		}
>  		return;
> @@ -2561,8 +2543,6 @@ ath5k_init(struct ath5k_softc *sc)
> 
>  	mutex_lock(&sc->lock);
> 
> -	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "mode %d\n", sc->opmode);
> -
>  	/*
>  	 * Stop anything previously setup.  This is safe
>  	 * no matter this is the first time through or not.
> @@ -2582,7 +2562,7 @@ ath5k_init(struct ath5k_softc *sc)
>  		AR5K_INT_RXORN | AR5K_INT_TXDESC | AR5K_INT_TXEOL |
>  		AR5K_INT_FATAL | AR5K_INT_GLOBAL | AR5K_INT_MIB;
> 
> -	ret = ath5k_reset(sc, NULL);
> +	ret = ath5k_reset(sc, NULL, RESET_INIT);
>  	if (ret)
>  		goto done;
> 
> @@ -2608,9 +2588,6 @@ ath5k_stop_locked(struct ath5k_softc *sc)
>  {
>  	struct ath5k_hw *ah = sc->ah;
> 
> -	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "invalid %u\n",
> -			test_bit(ATH_STAT_INVALID, sc->status));
> -
>  	/*
>  	 * Shutdown the hardware and driver:
>  	 *    stop output from above
> @@ -2686,9 +2663,6 @@ ath5k_stop_hw(struct ath5k_softc *sc)
>  		 * on the device (same as initial state after attach) and
>  		 * leave it idle (keep MAC/BB on warm reset) */
>  		ret = ath5k_hw_on_hold(sc->ah);
> -
> -		ATH5K_DBG(sc, ATH5K_DEBUG_RESET,
> -				"putting device to sleep\n");
>  	}
>  	ath5k_txbuf_free_skb(sc, sc->bbuf);
> 
> @@ -2743,8 +2717,7 @@ ath5k_intr(int irq, void *dev_id)
>  			 * Fatal errors are unrecoverable.
>  			 * Typically these are caused by DMA errors.
>  			 */
> -			ATH5K_DBG(sc, ATH5K_DEBUG_RESET,
> -				  "fatal int, resetting\n");
> +			sc->reset_reason = RESET_FATAL;
>  			ieee80211_queue_work(sc->hw, &sc->reset_work);
>  		} else if (unlikely(status & AR5K_INT_RXORN)) {
>  			/*
> @@ -2758,8 +2731,7 @@ ath5k_intr(int irq, void *dev_id)
>  			 */
>  			sc->stats.rxorn_intr++;
>  			if (ah->ah_mac_srev < AR5K_SREV_AR5212) {
> -				ATH5K_DBG(sc, ATH5K_DEBUG_RESET,
> -					  "rx overrun, resetting\n");
> +				sc->reset_reason = RESET_RXORN;
>  				ieee80211_queue_work(sc->hw, &sc->reset_work);
>  			}
>  			else
> @@ -2829,7 +2801,7 @@ ath5k_tasklet_calibrate(unsigned long data)
>  		 * Rfgain is out of bounds, reset the chip
>  		 * to load new gain values.
>  		 */
> -		ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "calibration, resetting\n");
> +		sc->reset_reason = RESET_CALIBRATION;
>  		ieee80211_queue_work(sc->hw, &sc->reset_work);
>  	}
>  	if (ath5k_hw_phy_calibrate(ah, sc->curchan))
> @@ -2938,12 +2910,13 @@ drop_packet:
>   * This should be called with sc->lock.
>   */
>  static int
> -ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan)
> +ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan,
> +            enum ath5k_reset_reason reason)
>  {
>  	struct ath5k_hw *ah = sc->ah;
>  	int ret;
> 
> -	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "resetting\n");
> +	trace_ath5k_reset(sc, chan, reason);
> 
>  	ath5k_hw_set_imr(ah, 0);
>  	synchronize_irq(sc->pdev->irq);
> @@ -2990,8 +2963,9 @@ ath5k_reset(struct ath5k_softc *sc, struct
> ieee80211_channel *chan)
> 
>  	ieee80211_wake_queues(sc->hw);
> 
> -	return 0;
> +	ret = 0;
>  err:
> +	trace_ath5k_reset_end(sc, ret);
>  	return ret;
>  }
> 
> @@ -3001,7 +2975,7 @@ static void ath5k_reset_work(struct work_struct
> *work) reset_work);
> 
>  	mutex_lock(&sc->lock);
> -	ath5k_reset(sc, sc->curchan);
> +	ath5k_reset(sc, sc->curchan, sc->reset_reason);
>  	mutex_unlock(&sc->lock);
>  }
> 
> diff --git a/drivers/net/wireless/ath/ath5k/base.h
> b/drivers/net/wireless/ath/ath5k/base.h index dc1241f..cb6e2be 100644
> --- a/drivers/net/wireless/ath/ath5k/base.h
> +++ b/drivers/net/wireless/ath/ath5k/base.h
> @@ -140,6 +140,17 @@ struct ath5k_statistics {
>  	unsigned int rxeol_intr;
>  };
> 
> +/* Reset tracing */
> +enum ath5k_reset_reason {
> +	RESET_INIT,
> +	RESET_SET_CHANNEL,
> +	RESET_STUCK_BEACON,
> +	RESET_FATAL,
> +	RESET_RXORN,
> +	RESET_CALIBRATION,
> +	RESET_DEBUGFS,
> +};
> +
>  #if CHAN_DEBUG
>  #define ATH_CHAN_MAX	(26+26+26+200+200)
>  #else
> @@ -192,6 +203,7 @@ struct ath5k_softc {
>  				led_on;		/* pin setting for LED on */
> 
>  	struct work_struct	reset_work;	/* deferred chip reset */
> +	enum ath5k_reset_reason	reset_reason;	/* reason for resetting */
> 
>  	unsigned int		rxbufsize;	/* rx size based on mtu */
>  	struct list_head	rxbuf;		/* receive buffer */
> diff --git a/drivers/net/wireless/ath/ath5k/debug.c
> b/drivers/net/wireless/ath/ath5k/debug.c index d107cd6..9ddbfd5 100644
> --- a/drivers/net/wireless/ath/ath5k/debug.c
> +++ b/drivers/net/wireless/ath/ath5k/debug.c
> @@ -278,7 +278,7 @@ static ssize_t write_file_reset(struct file *file,
>  				 size_t count, loff_t *ppos)
>  {
>  	struct ath5k_softc *sc = file->private_data;
> -	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "debug file triggered reset\n");
> +	sc->reset_reason = RESET_DEBUGFS;
>  	ieee80211_queue_work(sc->hw, &sc->reset_work);
>  	return count;
>  }
> @@ -297,7 +297,6 @@ static const struct {
>  	const char *name;
>  	const char *desc;
>  } dbg_info[] = {
> -	{ ATH5K_DEBUG_RESET,	"reset",	"reset and initialization" },
>  	{ ATH5K_DEBUG_INTR,	"intr",		"interrupt handling" },
>  	{ ATH5K_DEBUG_MODE,	"mode",		"mode init/setup" },
>  	{ ATH5K_DEBUG_XMIT,	"xmit",		"basic xmit operation" },
> @@ -931,6 +930,7 @@ ath5k_debug_printrxbuf(struct ath5k_buf *bf, int done,
>  void
>  ath5k_debug_printrxbuffs(struct ath5k_softc *sc, struct ath5k_hw *ah)
>  {
> +#if 0
>  	struct ath5k_desc *ds;
>  	struct ath5k_buf *bf;
>  	struct ath5k_rx_status rs = {};
> @@ -950,11 +950,13 @@ ath5k_debug_printrxbuffs(struct ath5k_softc *sc,
> struct ath5k_hw *ah) ath5k_debug_printrxbuf(bf, status == 0, &rs);
>  	}
>  	spin_unlock_bh(&sc->rxbuflock);
> +#endif
>  }
> 
>  void
>  ath5k_debug_printtxbuf(struct ath5k_softc *sc, struct ath5k_buf *bf)
>  {
> +#if 0
>  	struct ath5k_desc *ds = bf->desc;
>  	struct ath5k_hw_5212_tx_desc *td = &ds->ud.ds_tx5212;
>  	struct ath5k_tx_status ts = {};
> @@ -971,6 +973,7 @@ ath5k_debug_printtxbuf(struct ath5k_softc *sc, struct
> ath5k_buf *bf) td->tx_ctl.tx_control_2, td->tx_ctl.tx_control_3,
>  		td->tx_stat.tx_status_0, td->tx_stat.tx_status_1,
>  		done ? ' ' : (ts.ts_status == 0) ? '*' : '!');
> +#endif
>  }
> 
>  #endif /* ifdef CONFIG_ATH5K_DEBUG */
> diff --git a/drivers/net/wireless/ath/ath5k/debug.h
> b/drivers/net/wireless/ath/ath5k/debug.h index c260b00..8a484f2 100644
> --- a/drivers/net/wireless/ath/ath5k/debug.h
> +++ b/drivers/net/wireless/ath/ath5k/debug.h
> @@ -83,7 +83,6 @@ struct ath5k_dbg_info {
>  /**
>   * enum ath5k_debug_level - ath5k debug level
>   *
> - * @ATH5K_DEBUG_RESET: reset processing
>   * @ATH5K_DEBUG_INTR: interrupt handling
>   * @ATH5K_DEBUG_MODE: mode init/setup
>   * @ATH5K_DEBUG_XMIT: basic xmit operation
> @@ -104,7 +103,6 @@ struct ath5k_dbg_info {
>   * be combined together by bitwise OR.
>   */
>  enum ath5k_debug_level {
> -	ATH5K_DEBUG_RESET	= 0x00000001,
>  	ATH5K_DEBUG_INTR	= 0x00000002,
>  	ATH5K_DEBUG_MODE	= 0x00000004,
>  	ATH5K_DEBUG_XMIT	= 0x00000008,

again, here my same concerns: printing the reasons for resets is something 
which is useful on embedded boards and production setups which can't have 
tracing enabled. which is why i want to object against this change!

also adding a reason argument to the reset function just for tracing seems to 
be... umm... not so nice... couldn't you add the tracepoints before? 
and: didn't we want to split channel change out of reset anyhow?

bruno
