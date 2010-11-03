Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47738 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850Ab0KCLkb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Nov 2010 07:40:31 -0400
Received: by iwn10 with SMTP id 10so670053iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 03 Nov 2010 04:40:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CD08C86.9030202@openwrt.org>
References: <alpine.DEB.2.00.1011021655080.23045@vtdt3>
	<4CD046D2.4080703@openwrt.org>
	<4CD04C61.4070007@openwrt.org>
	<AANLkTikUUue=Nt0iFPcQC68kDCh=EeEpeBT9xnhW6bf+@mail.gmail.com>
	<4CD05E49.70701@openwrt.org>
	<AANLkTinBSeUSGR_9P-e5ZgKSeLfp36JfUbJOk73hpnQ2@mail.gmail.com>
	<4CD08C86.9030202@openwrt.org>
Date: Wed, 3 Nov 2010 12:35:28 +0100
Message-ID: <AANLkTi=zzGv7Vagb18Rpby=Xo_+g2yuVoFvAejU1KEud@mail.gmail.com>
Subject: Re: [ath9k-devel] [RFC] ath9k: fix tx queue selection
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Felix Fietkau <nbd@openwrt.org>
Cc: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/11/2 Felix Fietkau <nbd@openwrt.org>:
> On 2010-11-02 8:16 PM, Björn Smedman wrote:
>> 2010/11/2 Felix Fietkau <nbd@openwrt.org>:
>>> On 2010-11-02 7:20 PM, Björn Smedman wrote:
>>>> 2010/11/2 Felix Fietkau <nbd@openwrt.org>:
>>>>> +       q = ath_get_mac80211_qnum(txq->axq_class, sc);
>>>>>        r = ath_tx_setup_buffer(hw, bf, skb, txctl);
>>>>>        if (unlikely(r)) {
>>>>>                ath_print(common, ATH_DBG_FATAL, "TX mem alloc failure\n");
>>>>> @@ -1756,8 +1757,8 @@ int ath_tx_start(struct ieee80211_hw *hw
>>>>>                 * we will at least have to run TX completionon one buffer
>>>>>                 * on the queue */
>>>>>                spin_lock_bh(&txq->axq_lock);
>>>>> -               if (!txq->stopped && txq->axq_depth > 1) {
>>>>> -                       ath_mac80211_stop_queue(sc, skb_get_queue_mapping(skb));
>>>>> +               if (q >= 0 && !txq->stopped && txq->axq_depth > 1) {
>>>>> +                       ath_mac80211_stop_queue(sc, q);
>>>>>                        txq->stopped = 1;
>>>>>                }
>>>>
>>>> You cannot be sure that you are stopping the queue that the skb
>>>> actually came in on here since mac80211 queues are mapped to hw queues
>>>> by ath_get_hal_qnum() and that mapping is not reversible (due to the
>>>> default statement):
>>> How does the default statement matter here? The queue number always
>>> comes from an index of the ieee802_1d_to_ac[] array, which only contains
>>> numbers from 0 to 3. That should make the conversion reversible.
>>
>> True, but then you have a functional dependency on that data/code
>> (with catastrophic consequences if it ever changes). I understand the
>> name of that array suggests that it will be fixed forever but I don't
>> think we can be sure that a queue mapping will always be an AC. I
>> think it may be very reasonable to expand it to be a TID (0-7) or even
>> a separate queue per RA and TID. Are you prepared to put a BUG_ON()
>> under that default? If so that's a start.
>>
>> But it's not only the default statement that may make that mapping
>> non-reversible. It could also be that e.g. sc->tx.hwq_map[WME_AC_VI]
>> == sc->tx.hwq_map[WME_AC_VO]. You need some BUG_ONs there too and you
>> better not try to support a chipset with less than 4 hw queues.
> How about this then? I decoupled the WME_AC_* definitions from the
> ath9k_hw queue subtypes, so that I could redefine them to the numbers
> used by mac80211. That gets rid of another crappy abstraction.
> With this patch, pending frames will only be counted for the case where
> the txq is correct wrt. skb queue mapping.
> I still don't think fetching the tid from the data buffer again is the
> right thing to do. I double checked ath9k's tid -> ac conversion and it
> looks correct to me.

This is one good looking patch. :) And I agree, looking at the header
qos is good to avoid.

But there is still the risk of queue selection mismatch as I see it...
See comments below.

/Björn

> --- a/drivers/net/wireless/ath/ath9k/ath9k.h
> +++ b/drivers/net/wireless/ath/ath9k/ath9k.h
> @@ -195,7 +195,6 @@ enum ATH_AGGR_STATUS {
>
>  #define ATH_TXFIFO_DEPTH 8
>  struct ath_txq {
> -       int axq_class;
>        u32 axq_qnum;
>        u32 *axq_link;
>        struct list_head axq_q;
> @@ -208,11 +207,12 @@ struct ath_txq {
>        struct list_head txq_fifo_pending;
>        u8 txq_headidx;
>        u8 txq_tailidx;
> +       int pending_frames;
>  };
>
>  struct ath_atx_ac {
> +       struct ath_txq *txq;
>        int sched;
> -       int qnum;
>        struct list_head list;
>        struct list_head tid_q;
>  };
> @@ -290,12 +290,11 @@ struct ath_tx_control {
>  struct ath_tx {
>        u16 seq_no;
>        u32 txqsetup;
> -       int hwq_map[WME_NUM_AC];
>        spinlock_t txbuflock;
>        struct list_head txbuf;
>        struct ath_txq txq[ATH9K_NUM_TX_QUEUES];
>        struct ath_descdma txdma;
> -       int pending_frames[WME_NUM_AC];
> +       struct ath_txq *txq_map[WME_NUM_AC];
>  };
>
>  struct ath_rx_edma {
> @@ -325,7 +324,6 @@ void ath_rx_cleanup(struct ath_softc *sc
>  int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp);
>  struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype);
>  void ath_tx_cleanupq(struct ath_softc *sc, struct ath_txq *txq);
> -int ath_tx_setup(struct ath_softc *sc, int haltype);
>  void ath_drain_all_txq(struct ath_softc *sc, bool retry_tx);
>  void ath_draintxq(struct ath_softc *sc,
>                     struct ath_txq *txq, bool retry_tx);
> @@ -665,7 +663,6 @@ struct ath_wiphy {
>
>  void ath9k_tasklet(unsigned long data);
>  int ath_reset(struct ath_softc *sc, bool retry_tx);
> -int ath_get_mac80211_qnum(u32 queue, struct ath_softc *sc);
>  int ath_cabq_update(struct ath_softc *);
>
>  static inline void ath_read_cachesize(struct ath_common *common, int *csz)
> --- a/drivers/net/wireless/ath/ath9k/beacon.c
> +++ b/drivers/net/wireless/ath/ath9k/beacon.c
> @@ -28,7 +28,7 @@ int ath_beaconq_config(struct ath_softc
>        struct ath_hw *ah = sc->sc_ah;
>        struct ath_common *common = ath9k_hw_common(ah);
>        struct ath9k_tx_queue_info qi, qi_be;
> -       int qnum;
> +       struct ath_txq *txq;
>
>        ath9k_hw_get_txq_props(ah, sc->beacon.beaconq, &qi);
>        if (sc->sc_ah->opmode == NL80211_IFTYPE_AP) {
> @@ -38,8 +38,8 @@ int ath_beaconq_config(struct ath_softc
>                qi.tqi_cwmax = 0;
>        } else {
>                /* Adhoc mode; important thing is to use 2x cwmin. */
> -               qnum = sc->tx.hwq_map[WME_AC_BE];
> -               ath9k_hw_get_txq_props(ah, qnum, &qi_be);
> +               txq = sc->tx.txq_map[WME_AC_BE];
> +               ath9k_hw_get_txq_props(ah, txq->axq_qnum, &qi_be);
>                qi.tqi_aifs = qi_be.tqi_aifs;
>                qi.tqi_cwmin = 4*qi_be.tqi_cwmin;
>                qi.tqi_cwmax = qi_be.tqi_cwmax;
> --- a/drivers/net/wireless/ath/ath9k/common.h
> +++ b/drivers/net/wireless/ath/ath9k/common.h
> @@ -31,10 +31,11 @@
>  #define WME_MAX_BA              WME_BA_BMP_SIZE
>  #define ATH_TID_MAX_BUFS        (2 * WME_MAX_BA)
>
> -#define WME_AC_BE   0
> -#define WME_AC_BK   1
> -#define WME_AC_VI   2
> -#define WME_AC_VO   3
> +/* These must match mac80211 skb queue mapping numbers */
> +#define WME_AC_VO   0
> +#define WME_AC_VI   1
> +#define WME_AC_BE   2
> +#define WME_AC_BK   3
>  #define WME_NUM_AC  4
>
>  #define ATH_RSSI_DUMMY_MARKER   0x127
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -331,7 +331,7 @@ void ath_paprd_calibrate(struct work_str
>        struct ath_tx_control txctl;
>        struct ath9k_hw_cal_data *caldata = ah->caldata;
>        struct ath_common *common = ath9k_hw_common(ah);
> -       int qnum, ftype;
> +       int ftype;
>        int chain_ok = 0;
>        int chain;
>        int len = 1800;
> @@ -358,8 +358,7 @@ void ath_paprd_calibrate(struct work_str
>        memcpy(hdr->addr3, hw->wiphy->perm_addr, ETH_ALEN);
>
>        memset(&txctl, 0, sizeof(txctl));
> -       qnum = sc->tx.hwq_map[WME_AC_BE];
> -       txctl.txq = &sc->tx.txq[qnum];
> +       txctl.txq = sc->tx.txq_map[WME_AC_BE];
>
>        ath9k_ps_wakeup(sc);
>        ar9003_paprd_init_table(ah);
> @@ -1025,56 +1024,6 @@ int ath_reset(struct ath_softc *sc, bool
>        return r;
>  }
>
> -static int ath_get_hal_qnum(u16 queue, struct ath_softc *sc)
> -{
> -       int qnum;
> -
> -       switch (queue) {
> -       case 0:
> -               qnum = sc->tx.hwq_map[WME_AC_VO];
> -               break;
> -       case 1:
> -               qnum = sc->tx.hwq_map[WME_AC_VI];
> -               break;
> -       case 2:
> -               qnum = sc->tx.hwq_map[WME_AC_BE];
> -               break;
> -       case 3:
> -               qnum = sc->tx.hwq_map[WME_AC_BK];
> -               break;
> -       default:
> -               qnum = sc->tx.hwq_map[WME_AC_BE];
> -               break;
> -       }
> -
> -       return qnum;
> -}
> -
> -int ath_get_mac80211_qnum(u32 queue, struct ath_softc *sc)
> -{
> -       int qnum;
> -
> -       switch (queue) {
> -       case WME_AC_VO:
> -               qnum = 0;
> -               break;
> -       case WME_AC_VI:
> -               qnum = 1;
> -               break;
> -       case WME_AC_BE:
> -               qnum = 2;
> -               break;
> -       case WME_AC_BK:
> -               qnum = 3;
> -               break;
> -       default:
> -               qnum = -1;
> -               break;
> -       }
> -
> -       return qnum;
> -}

Nice to see this go. This I like. :)

> -
>  /* XXX: Remove me once we don't depend on ath9k_channel for all
>  * this redundant data */
>  void ath9k_update_ichannel(struct ath_softc *sc, struct ieee80211_hw *hw,
> @@ -1244,7 +1193,6 @@ static int ath9k_tx(struct ieee80211_hw
>        struct ath_tx_control txctl;
>        int padpos, padsize;
>        struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
> -       int qnum;
>
>        if (aphy->state != ATH_WIPHY_ACTIVE && aphy->state != ATH_WIPHY_SCAN) {
>                ath_print(common, ATH_DBG_XMIT,
> @@ -1317,8 +1265,7 @@ static int ath9k_tx(struct ieee80211_hw
>                memmove(skb->data, skb->data + padsize, padpos);
>        }
>
> -       qnum = ath_get_hal_qnum(skb_get_queue_mapping(skb), sc);
> -       txctl.txq = &sc->tx.txq[qnum];
> +       txctl.txq = sc->tx.txq_map[skb_get_queue_mapping(skb)];

Could we be indexing txq_map[] out of bounds here? I guess this
question is the fundamental one: can we be sure that
skb_get_queue_mapping(skb) will return an AC i.e. range 0-3? Not only
now but forever? Or do we need a comment in mac80211 saying driver
will crash if anything else is returned?

>
>        ath_print(common, ATH_DBG_XMIT, "transmitting packet, skb: %p\n", skb);
>
> @@ -1802,12 +1749,15 @@ static int ath9k_conf_tx(struct ieee8021
>        struct ath_wiphy *aphy = hw->priv;
>        struct ath_softc *sc = aphy->sc;
>        struct ath_common *common = ath9k_hw_common(sc->sc_ah);
> +       struct ath_txq *txq;
>        struct ath9k_tx_queue_info qi;
> -       int ret = 0, qnum;
> +       int ret = 0;
>
>        if (queue >= WME_NUM_AC)
>                return 0;
>
> +       txq = sc->tx.txq_map[queue];
> +
>        mutex_lock(&sc->mutex);
>
>        memset(&qi, 0, sizeof(struct ath9k_tx_queue_info));
> @@ -1816,20 +1766,19 @@ static int ath9k_conf_tx(struct ieee8021
>        qi.tqi_cwmin = params->cw_min;
>        qi.tqi_cwmax = params->cw_max;
>        qi.tqi_burstTime = params->txop;
> -       qnum = ath_get_hal_qnum(queue, sc);
>
>        ath_print(common, ATH_DBG_CONFIG,
>                  "Configure tx [queue/halq] [%d/%d],  "
>                  "aifs: %d, cw_min: %d, cw_max: %d, txop: %d\n",
> -                 queue, qnum, params->aifs, params->cw_min,
> +                 queue, txq->axq_qnum, params->aifs, params->cw_min,
>                  params->cw_max, params->txop);
>
> -       ret = ath_txq_update(sc, qnum, &qi);
> +       ret = ath_txq_update(sc, txq->axq_qnum, &qi);
>        if (ret)
>                ath_print(common, ATH_DBG_FATAL, "TXQ Update failed\n");
>
>        if (sc->sc_ah->opmode == NL80211_IFTYPE_ADHOC)
> -               if ((qnum == sc->tx.hwq_map[WME_AC_BE]) && !ret)
> +               if (queue == WME_AC_BE && !ret)
>                        ath_beaconq_config(sc);
>
>        mutex_unlock(&sc->mutex);
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -124,7 +124,7 @@ static void ath_tx_queue_tid(struct ath_
>
>  static void ath_tx_resume_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
>  {
> -       struct ath_txq *txq = &sc->tx.txq[tid->ac->qnum];
> +       struct ath_txq *txq = tid->ac->txq;
>
>        WARN_ON(!tid->paused);
>
> @@ -142,7 +142,7 @@ unlock:
>
>  static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
>  {
> -       struct ath_txq *txq = &sc->tx.txq[tid->ac->qnum];
> +       struct ath_txq *txq = tid->ac->txq;
>        struct ath_buf *bf;
>        struct list_head bf_head;
>        struct ath_tx_status ts;
> @@ -817,7 +817,7 @@ void ath_tx_aggr_stop(struct ath_softc *
>  {
>        struct ath_node *an = (struct ath_node *)sta->drv_priv;
>        struct ath_atx_tid *txtid = ATH_AN_2_TID(an, tid);
> -       struct ath_txq *txq = &sc->tx.txq[txtid->ac->qnum];
> +       struct ath_txq *txq = txtid->ac->txq;
>
>        if (txtid->state & AGGR_CLEANUP)
>                return;
> @@ -888,10 +888,16 @@ struct ath_txq *ath_txq_setup(struct ath
>        struct ath_hw *ah = sc->sc_ah;
>        struct ath_common *common = ath9k_hw_common(ah);
>        struct ath9k_tx_queue_info qi;
> +       static const int subtype_txq_to_hwq[] = {
> +               [WME_AC_BE] = ATH_TXQ_AC_BE,
> +               [WME_AC_BK] = ATH_TXQ_AC_BK,
> +               [WME_AC_VI] = ATH_TXQ_AC_VI,
> +               [WME_AC_VO] = ATH_TXQ_AC_VO,
> +       };
>        int qnum, i;
>
>        memset(&qi, 0, sizeof(qi));
> -       qi.tqi_subtype = subtype;
> +       qi.tqi_subtype = subtype_txq_to_hwq[subtype];
>        qi.tqi_aifs = ATH9K_TXQ_USEDEFAULT;
>        qi.tqi_cwmin = ATH9K_TXQ_USEDEFAULT;
>        qi.tqi_cwmax = ATH9K_TXQ_USEDEFAULT;
> @@ -940,7 +946,6 @@ struct ath_txq *ath_txq_setup(struct ath
>        if (!ATH_TXQ_SETUP(sc, qnum)) {
>                struct ath_txq *txq = &sc->tx.txq[qnum];
>
> -               txq->axq_class = subtype;
>                txq->axq_qnum = qnum;
>                txq->axq_link = NULL;
>                INIT_LIST_HEAD(&txq->axq_q);
> @@ -1210,24 +1215,6 @@ void ath_txq_schedule(struct ath_softc *
>        }
>  }
>
> -int ath_tx_setup(struct ath_softc *sc, int haltype)
> -{
> -       struct ath_txq *txq;
> -
> -       if (haltype >= ARRAY_SIZE(sc->tx.hwq_map)) {
> -               ath_print(ath9k_hw_common(sc->sc_ah), ATH_DBG_FATAL,
> -                         "HAL AC %u out of range, max %zu!\n",
> -                        haltype, ARRAY_SIZE(sc->tx.hwq_map));
> -               return 0;
> -       }
> -       txq = ath_txq_setup(sc, ATH9K_TX_QUEUE_DATA, haltype);
> -       if (txq != NULL) {
> -               sc->tx.hwq_map[haltype] = txq->axq_qnum;
> -               return 1;
> -       } else
> -               return 0;
> -}
> -
>  /***********/
>  /* TX, DMA */
>  /***********/
> @@ -1747,6 +1734,7 @@ int ath_tx_start(struct ieee80211_hw *hw
>                return -1;
>        }
>
> +       q = skb_get_queue_mapping(skb);
>        r = ath_tx_setup_buffer(hw, bf, skb, txctl);
>        if (unlikely(r)) {
>                ath_print(common, ATH_DBG_FATAL, "TX mem alloc failure\n");
> @@ -1756,8 +1744,9 @@ int ath_tx_start(struct ieee80211_hw *hw
>                 * we will at least have to run TX completionon one buffer
>                 * on the queue */
>                spin_lock_bh(&txq->axq_lock);
> -               if (!txq->stopped && txq->axq_depth > 1) {
> -                       ath_mac80211_stop_queue(sc, skb_get_queue_mapping(skb));
> +               if (txq == sc->tx.txq_map[q] && !txq->stopped &&
> +                   txq->axq_depth > 1) {
> +                       ath_mac80211_stop_queue(sc, q);

Again, possible index out of bounds, no? Also, what happens if txq !=
sc->tx.txq_map[q]? I guess that's less catastrophic but still;
meaningful code will not execute.

>                        txq->stopped = 1;
>                }
>                spin_unlock_bh(&txq->axq_lock);
> @@ -1767,13 +1756,10 @@ int ath_tx_start(struct ieee80211_hw *hw
>                return r;
>        }
>
> -       q = skb_get_queue_mapping(skb);
> -       if (q >= 4)
> -               q = 0;
> -
>        spin_lock_bh(&txq->axq_lock);
> -       if (++sc->tx.pending_frames[q] > ATH_MAX_QDEPTH && !txq->stopped) {
> -               ath_mac80211_stop_queue(sc, skb_get_queue_mapping(skb));
> +       if (txq == sc->tx.txq_map[q] &&
> +           ++txq->pending_frames > ATH_MAX_QDEPTH && !txq->stopped) {
> +               ath_mac80211_stop_queue(sc, q);

Same as above.

>                txq->stopped = 1;
>        }
>        spin_unlock_bh(&txq->axq_lock);
> @@ -1887,12 +1873,12 @@ static void ath_tx_complete(struct ath_s
>        if (unlikely(tx_info->pad[0] & ATH_TX_INFO_FRAME_TYPE_INTERNAL))
>                ath9k_tx_status(hw, skb);
>        else {
> -               q = skb_get_queue_mapping(skb);
> -               if (q >= 4)
> -                       q = 0;
> +               struct ath_txq *txq;
>
> -               if (--sc->tx.pending_frames[q] < 0)
> -                       sc->tx.pending_frames[q] = 0;
> +               q = skb_get_queue_mapping(skb);
> +               txq = sc->tx.txq_map[q];
> +               if (--txq->pending_frames < 0)
> +                       txq->pending_frames = 0;

This is off topic, cut do we really need this? Where do those missing
frames go? :) I would much prefer a BUG_ON(txq->pending_frames < 0).

>
>                ieee80211_tx_status(hw, skb);
>        }
> @@ -1927,7 +1913,7 @@ static void ath_tx_complete_buf(struct a
>                else
>                        complete(&sc->paprd_complete);
>        } else {
> -               ath_debug_stat_tx(sc, txq, bf, ts);
> +               ath_debug_stat_tx(sc, bf, ts);
>                ath_tx_complete(sc, skb, bf->aphy, tx_flags);
>        }
>        /* At this point, skb (bf->bf_mpdu) is consumed...make sure we don't
> @@ -2018,16 +2004,13 @@ static void ath_tx_rc_status(struct ath_
>        tx_info->status.rates[tx_rateindex].count = ts->ts_longretry + 1;
>  }
>
> -static void ath_wake_mac80211_queue(struct ath_softc *sc, struct ath_txq *txq)
> +static void ath_wake_mac80211_queue(struct ath_softc *sc, int qnum)
>  {
> -       int qnum;
> -
> -       qnum = ath_get_mac80211_qnum(txq->axq_class, sc);
> -       if (qnum == -1)
> -               return;
> +       struct ath_txq *txq;
>
> +       txq = sc->tx.txq_map[qnum];
>        spin_lock_bh(&txq->axq_lock);
> -       if (txq->stopped && sc->tx.pending_frames[qnum] < ATH_MAX_QDEPTH) {
> +       if (txq->stopped && txq->pending_frames < ATH_MAX_QDEPTH) {
>                if (ath_mac80211_start_queue(sc, qnum))
>                        txq->stopped = 0;
>        }
> @@ -2044,6 +2027,7 @@ static void ath_tx_processq(struct ath_s
>        struct ath_tx_status ts;
>        int txok;
>        int status;
> +       int qnum;
>
>        ath_print(common, ATH_DBG_QUEUE, "tx queue %d (%x), link %p\n",
>                  txq->axq_qnum, ath9k_hw_gettxbuf(sc->sc_ah, txq->axq_qnum),
> @@ -2119,12 +2103,15 @@ static void ath_tx_processq(struct ath_s
>                        ath_tx_rc_status(bf, &ts, txok ? 0 : 1, txok, true);
>                }
>
> +               qnum = skb_get_queue_mapping(bf->bf_mpdu);
> +
>                if (bf_isampdu(bf))
>                        ath_tx_complete_aggr(sc, txq, bf, &bf_head, &ts, txok);
>                else
>                        ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, txok, 0);
>
> -               ath_wake_mac80211_queue(sc, txq);
> +               if (txq == sc->tx.txq_map[qnum])
> +                       ath_wake_mac80211_queue(sc, qnum);

Out of bounds? But I like the fact that we are selecting the queue to
start based on skb_get_queue_mapping(bf->bf_mpdu). :)

>
>                spin_lock_bh(&txq->axq_lock);
>                if (sc->sc_flags & SC_OP_TXAGGR)
> @@ -2194,6 +2181,7 @@ void ath_tx_edma_tasklet(struct ath_soft
>        struct list_head bf_head;
>        int status;
>        int txok;
> +       int qnum;
>
>        for (;;) {
>                status = ath9k_hw_txprocdesc(ah, NULL, (void *)&txs);
> @@ -2237,13 +2225,16 @@ void ath_tx_edma_tasklet(struct ath_soft
>                        ath_tx_rc_status(bf, &txs, txok ? 0 : 1, txok, true);
>                }
>
> +               qnum = skb_get_queue_mapping(bf->bf_mpdu);
> +
>                if (bf_isampdu(bf))
>                        ath_tx_complete_aggr(sc, txq, bf, &bf_head, &txs, txok);
>                else
>                        ath_tx_complete_buf(sc, bf, txq, &bf_head,
>                                            &txs, txok, 0);
>
> -               ath_wake_mac80211_queue(sc, txq);
> +               if (txq == sc->tx.txq_map[qnum])
> +                       ath_wake_mac80211_queue(sc, qnum);

Out of bounds?

>
>                spin_lock_bh(&txq->axq_lock);
>                if (!list_empty(&txq->txq_fifo_pending)) {
> @@ -2375,7 +2366,7 @@ void ath_tx_node_init(struct ath_softc *
>        for (acno = 0, ac = &an->ac[acno];
>             acno < WME_NUM_AC; acno++, ac++) {
>                ac->sched    = false;
> -               ac->qnum = sc->tx.hwq_map[acno];
> +               ac->txq = sc->tx.txq_map[acno];
>                INIT_LIST_HEAD(&ac->tid_q);
>        }
>  }
> @@ -2385,17 +2376,13 @@ void ath_tx_node_cleanup(struct ath_soft
>        struct ath_atx_ac *ac;
>        struct ath_atx_tid *tid;
>        struct ath_txq *txq;
> -       int i, tidno;
> +       int tidno;
>
>        for (tidno = 0, tid = &an->tid[tidno];
>             tidno < WME_NUM_TID; tidno++, tid++) {
> -               i = tid->ac->qnum;
> -
> -               if (!ATH_TXQ_SETUP(sc, i))
> -                       continue;
>
> -               txq = &sc->tx.txq[i];
>                ac = tid->ac;
> +               txq = ac->txq;

This is where it gets interesting... Since we do select the tid by
looking at the header qos and the tid maps to an ac, we implicitly
select the txq by looking at the header qos, no?

This means that when we get to ath_tx_start_dma() we lock the txq
selected by looking at the skb queue mapping (i.e. txctl->txq), but we
then procede into ath_tx_send_ampdu() where the packet is queued to a
tid selected by looking at the header qos field. Later that packet
will be transmitted on the txq corresponding to that tid (tid ->ac
->txq).

It comes down to this: either we look at the header qos when we select
the queue (so the above cannot happen) or we relay on mac80211 to set
the header qos and the skb queue mapping in a certain way. If we
choose the later I vote for a BUG_ON(txctl->txq != tid->ac->txq) in
ath_tx_send_ampdu().

>
>                spin_lock_bh(&txq->axq_lock);
>
> --- a/drivers/net/wireless/ath/ath9k/hw.h
> +++ b/drivers/net/wireless/ath/ath9k/hw.h
> @@ -157,6 +157,13 @@
>  #define PAPRD_GAIN_TABLE_ENTRIES    32
>  #define PAPRD_TABLE_SZ              24
>
> +enum ath_hw_txq_subtype {
> +       ATH_TXQ_AC_BE = 0,
> +       ATH_TXQ_AC_BK = 1,
> +       ATH_TXQ_AC_VI = 2,
> +       ATH_TXQ_AC_VO = 3,
> +};
> +
>  enum ath_ini_subsys {
>        ATH_INI_PRE = 0,
>        ATH_INI_CORE,
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
> @@ -20,8 +20,15 @@
>  /* TX */
>  /******/
>
> +static const int subtype_txq_to_hwq[] = {
> +       [WME_AC_BE] = ATH_TXQ_AC_BE,
> +       [WME_AC_BK] = ATH_TXQ_AC_BK,
> +       [WME_AC_VI] = ATH_TXQ_AC_VI,
> +       [WME_AC_VO] = ATH_TXQ_AC_VO,
> +};
> +
>  #define ATH9K_HTC_INIT_TXQ(subtype) do {                       \
> -               qi.tqi_subtype = subtype;                       \
> +               qi.tqi_subtype = subtype_txq_to_hwq[subtype];   \
>                qi.tqi_aifs = ATH9K_TXQ_USEDEFAULT;             \
>                qi.tqi_cwmin = ATH9K_TXQ_USEDEFAULT;            \
>                qi.tqi_cwmax = ATH9K_TXQ_USEDEFAULT;            \
> --- a/drivers/net/wireless/ath/ath9k/init.c
> +++ b/drivers/net/wireless/ath/ath9k/init.c
> @@ -396,7 +396,8 @@ static void ath9k_init_crypto(struct ath
>
>  static int ath9k_init_btcoex(struct ath_softc *sc)
>  {
> -       int r, qnum;
> +       struct ath_txq *txq;
> +       int r;
>
>        switch (sc->sc_ah->btcoex_hw.scheme) {
>        case ATH_BTCOEX_CFG_NONE:
> @@ -409,8 +410,8 @@ static int ath9k_init_btcoex(struct ath_
>                r = ath_init_btcoex_timer(sc);
>                if (r)
>                        return -1;
> -               qnum = sc->tx.hwq_map[WME_AC_BE];
> -               ath9k_hw_init_btcoex_hw(sc->sc_ah, qnum);
> +               txq = sc->tx.txq_map[WME_AC_BE];
> +               ath9k_hw_init_btcoex_hw(sc->sc_ah, txq->axq_qnum);
>                sc->btcoex.bt_stomp_type = ATH_BTCOEX_STOMP_LOW;
>                break;
>        default:
> @@ -423,59 +424,18 @@ static int ath9k_init_btcoex(struct ath_
>
>  static int ath9k_init_queues(struct ath_softc *sc)
>  {
> -       struct ath_common *common = ath9k_hw_common(sc->sc_ah);
>        int i = 0;
>
> -       for (i = 0; i < ARRAY_SIZE(sc->tx.hwq_map); i++)
> -               sc->tx.hwq_map[i] = -1;
> -
>        sc->beacon.beaconq = ath9k_hw_beaconq_setup(sc->sc_ah);
> -       if (sc->beacon.beaconq == -1) {
> -               ath_print(common, ATH_DBG_FATAL,
> -                         "Unable to setup a beacon xmit queue\n");
> -               goto err;
> -       }
> -
>        sc->beacon.cabq = ath_txq_setup(sc, ATH9K_TX_QUEUE_CAB, 0);
> -       if (sc->beacon.cabq == NULL) {
> -               ath_print(common, ATH_DBG_FATAL,
> -                         "Unable to setup CAB xmit queue\n");
> -               goto err;
> -       }
>
>        sc->config.cabqReadytime = ATH_CABQ_READY_TIME;
>        ath_cabq_update(sc);
>
> -       if (!ath_tx_setup(sc, WME_AC_BK)) {
> -               ath_print(common, ATH_DBG_FATAL,
> -                         "Unable to setup xmit queue for BK traffic\n");
> -               goto err;
> -       }
> -
> -       if (!ath_tx_setup(sc, WME_AC_BE)) {
> -               ath_print(common, ATH_DBG_FATAL,
> -                         "Unable to setup xmit queue for BE traffic\n");
> -               goto err;
> -       }
> -       if (!ath_tx_setup(sc, WME_AC_VI)) {
> -               ath_print(common, ATH_DBG_FATAL,
> -                         "Unable to setup xmit queue for VI traffic\n");
> -               goto err;
> -       }
> -       if (!ath_tx_setup(sc, WME_AC_VO)) {
> -               ath_print(common, ATH_DBG_FATAL,
> -                         "Unable to setup xmit queue for VO traffic\n");
> -               goto err;
> -       }
> +       for (i = 0; i < WME_NUM_AC; i++)
> +               sc->tx.txq_map[i] = ath_txq_setup(sc, ATH9K_TX_QUEUE_DATA, i);

Can we be sure that ath_txq_setup() will always return a distinct txq
on each call? Otherwise I suggest an inner loop of BUG_ON() to make
sure no two elements of txq_map are the same.

>
>        return 0;
> -
> -err:
> -       for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++)
> -               if (ATH_TXQ_SETUP(sc, i))
> -                       ath_tx_cleanupq(sc, &sc->tx.txq[i]);
> -
> -       return -EIO;
>  }
>
>  static int ath9k_init_channels_rates(struct ath_softc *sc)
> --- a/drivers/net/wireless/ath/ath9k/virtual.c
> +++ b/drivers/net/wireless/ath/ath9k/virtual.c
> @@ -187,7 +187,7 @@ static int ath9k_send_nullfunc(struct at
>        info->control.rates[1].idx = -1;
>
>        memset(&txctl, 0, sizeof(struct ath_tx_control));
> -       txctl.txq = &sc->tx.txq[sc->tx.hwq_map[WME_AC_VO]];
> +       txctl.txq = sc->tx.txq_map[WME_AC_VO];
>        txctl.frame_type = ps ? ATH9K_IFT_PAUSE : ATH9K_IFT_UNPAUSE;
>
>        if (ath_tx_start(aphy->hw, skb, &txctl) != 0)
> --- a/drivers/net/wireless/ath/ath9k/debug.c
> +++ b/drivers/net/wireless/ath/ath9k/debug.c
> @@ -579,10 +579,10 @@ static const struct file_operations fops
>        do {                                                            \
>                len += snprintf(buf + len, size - len,                  \
>                                "%s%13u%11u%10u%10u\n", str,            \
> -               sc->debug.stats.txstats[sc->tx.hwq_map[WME_AC_BE]].elem, \
> -               sc->debug.stats.txstats[sc->tx.hwq_map[WME_AC_BK]].elem, \
> -               sc->debug.stats.txstats[sc->tx.hwq_map[WME_AC_VI]].elem, \
> -               sc->debug.stats.txstats[sc->tx.hwq_map[WME_AC_VO]].elem); \
> +               sc->debug.stats.txstats[WME_AC_BE].elem, \
> +               sc->debug.stats.txstats[WME_AC_BK].elem, \
> +               sc->debug.stats.txstats[WME_AC_VI].elem, \
> +               sc->debug.stats.txstats[WME_AC_VO].elem); \
>  } while(0)
>
>  static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
> @@ -624,33 +624,35 @@ static ssize_t read_file_xmit(struct fil
>        return retval;
>  }
>
> -void ath_debug_stat_tx(struct ath_softc *sc, struct ath_txq *txq,
> -                      struct ath_buf *bf, struct ath_tx_status *ts)
> +void ath_debug_stat_tx(struct ath_softc *sc, struct ath_buf *bf,
> +                      struct ath_tx_status *ts)
>  {
> -       TX_STAT_INC(txq->axq_qnum, tx_pkts_all);
> -       sc->debug.stats.txstats[txq->axq_qnum].tx_bytes_all += bf->bf_mpdu->len;
> +       int qnum = skb_get_queue_mapping(bf->bf_mpdu);
> +
> +       TX_STAT_INC(qnum, tx_pkts_all);
> +       sc->debug.stats.txstats[qnum].tx_bytes_all += bf->bf_mpdu->len;
>
>        if (bf_isampdu(bf)) {
>                if (bf_isxretried(bf))
> -                       TX_STAT_INC(txq->axq_qnum, a_xretries);
> +                       TX_STAT_INC(qnum, a_xretries);
>                else
> -                       TX_STAT_INC(txq->axq_qnum, a_completed);
> +                       TX_STAT_INC(qnum, a_completed);
>        } else {
> -               TX_STAT_INC(txq->axq_qnum, completed);
> +               TX_STAT_INC(qnum, completed);
>        }
>
>        if (ts->ts_status & ATH9K_TXERR_FIFO)
> -               TX_STAT_INC(txq->axq_qnum, fifo_underrun);
> +               TX_STAT_INC(qnum, fifo_underrun);
>        if (ts->ts_status & ATH9K_TXERR_XTXOP)
> -               TX_STAT_INC(txq->axq_qnum, xtxop);
> +               TX_STAT_INC(qnum, xtxop);
>        if (ts->ts_status & ATH9K_TXERR_TIMER_EXPIRED)
> -               TX_STAT_INC(txq->axq_qnum, timer_exp);
> +               TX_STAT_INC(qnum, timer_exp);
>        if (ts->ts_flags & ATH9K_TX_DESC_CFG_ERR)
> -               TX_STAT_INC(txq->axq_qnum, desc_cfg_err);
> +               TX_STAT_INC(qnum, desc_cfg_err);
>        if (ts->ts_flags & ATH9K_TX_DATA_UNDERRUN)
> -               TX_STAT_INC(txq->axq_qnum, data_underrun);
> +               TX_STAT_INC(qnum, data_underrun);
>        if (ts->ts_flags & ATH9K_TX_DELIM_UNDERRUN)
> -               TX_STAT_INC(txq->axq_qnum, delim_underrun);
> +               TX_STAT_INC(qnum, delim_underrun);
>  }
>
>  static const struct file_operations fops_xmit = {
>
>
