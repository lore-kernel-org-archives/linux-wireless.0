Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49466 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab0KCQ1W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Nov 2010 12:27:22 -0400
Received: by yxk8 with SMTP id 8so595953yxk.19
        for <linux-wireless@vger.kernel.org>; Wed, 03 Nov 2010 09:27:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CD14D39.5020401@openwrt.org>
References: <alpine.DEB.2.00.1011021655080.23045@vtdt3>
	<4CD046D2.4080703@openwrt.org>
	<4CD04C61.4070007@openwrt.org>
	<AANLkTikUUue=Nt0iFPcQC68kDCh=EeEpeBT9xnhW6bf+@mail.gmail.com>
	<4CD05E49.70701@openwrt.org>
	<AANLkTinBSeUSGR_9P-e5ZgKSeLfp36JfUbJOk73hpnQ2@mail.gmail.com>
	<4CD08C86.9030202@openwrt.org>
	<AANLkTi=zzGv7Vagb18Rpby=Xo_+g2yuVoFvAejU1KEud@mail.gmail.com>
	<4CD14D39.5020401@openwrt.org>
Date: Wed, 3 Nov 2010 17:27:21 +0100
Message-ID: <AANLkTinvmmqCsgKsfAikdsb88_bCV=VL2+1ZxrwdFHFm@mail.gmail.com>
Subject: Re: [ath9k-devel] [RFC] ath9k: fix tx queue selection
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Felix Fietkau <nbd@openwrt.org>
Cc: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/11/3 Felix Fietkau <nbd@openwrt.org>:
> On 2010-11-03 12:35 PM, Björn Smedman wrote:
>> This is one good looking patch. :) And I agree, looking at the header
>> qos is good to avoid.
>>
>> But there is still the risk of queue selection mismatch as I see it...
>> See comments below.
>>
>> /Björn
>
>>> -
>>>  /* XXX: Remove me once we don't depend on ath9k_channel for all
>>>  * this redundant data */
>>>  void ath9k_update_ichannel(struct ath_softc *sc, struct ieee80211_hw *hw,
>>> @@ -1244,7 +1193,6 @@ static int ath9k_tx(struct ieee80211_hw
>>>        struct ath_tx_control txctl;
>>>        int padpos, padsize;
>>>        struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
>>> -       int qnum;
>>>
>>>        if (aphy->state != ATH_WIPHY_ACTIVE && aphy->state != ATH_WIPHY_SCAN) {
>>>                ath_print(common, ATH_DBG_XMIT,
>>> @@ -1317,8 +1265,7 @@ static int ath9k_tx(struct ieee80211_hw
>>>                memmove(skb->data, skb->data + padsize, padpos);
>>>        }
>>>
>>> -       qnum = ath_get_hal_qnum(skb_get_queue_mapping(skb), sc);
>>> -       txctl.txq = &sc->tx.txq[qnum];
>>> +       txctl.txq = sc->tx.txq_map[skb_get_queue_mapping(skb)];
>>
>> Could we be indexing txq_map[] out of bounds here? I guess this
>> question is the fundamental one: can we be sure that
>> skb_get_queue_mapping(skb) will return an AC i.e. range 0-3? Not only
>> now but forever? Or do we need a comment in mac80211 saying driver
>> will crash if anything else is returned?
> mac80211 already makes the same assumption in several places. It should
> never be out of bounds unless something in the network stack is broken.
> And if there is a need for a defensive check for this, then ath9k is
> definitely not the right place for it.

Okej, if that is the stable contract I'm ok with it.

>>> @@ -1756,8 +1744,9 @@ int ath_tx_start(struct ieee80211_hw *hw
>>>                 * we will at least have to run TX completionon one buffer
>>>                 * on the queue */
>>>                spin_lock_bh(&txq->axq_lock);
>>> -               if (!txq->stopped && txq->axq_depth > 1) {
>>> -                       ath_mac80211_stop_queue(sc, skb_get_queue_mapping(skb));
>>> +               if (txq == sc->tx.txq_map[q] && !txq->stopped &&
>>> +                   txq->axq_depth > 1) {
>>> +                       ath_mac80211_stop_queue(sc, q);
>>
>> Again, possible index out of bounds, no? Also, what happens if txq !=
>> sc->tx.txq_map[q]? I guess that's less catastrophic but still;
>> meaningful code will not execute.
> I added that check primarily for the case where buffered frames go
> through the cabq.

Ok, if there is no other case then sure.

>
>>>                        txq->stopped = 1;
>>>                }
>>>                spin_unlock_bh(&txq->axq_lock);
>>> @@ -1767,13 +1756,10 @@ int ath_tx_start(struct ieee80211_hw *hw
>>>                return r;
>>>        }
>>>
>>> -       q = skb_get_queue_mapping(skb);
>>> -       if (q >= 4)
>>> -               q = 0;
>>> -
>>>        spin_lock_bh(&txq->axq_lock);
>>> -       if (++sc->tx.pending_frames[q] > ATH_MAX_QDEPTH && !txq->stopped) {
>>> -               ath_mac80211_stop_queue(sc, skb_get_queue_mapping(skb));
>>> +       if (txq == sc->tx.txq_map[q] &&
>>> +           ++txq->pending_frames > ATH_MAX_QDEPTH && !txq->stopped) {
>>> +               ath_mac80211_stop_queue(sc, q);
>>
>> Same as above.
>>
>>>                txq->stopped = 1;
>>>        }
>>>        spin_unlock_bh(&txq->axq_lock);
>>> @@ -1887,12 +1873,12 @@ static void ath_tx_complete(struct ath_s
>>>        if (unlikely(tx_info->pad[0] & ATH_TX_INFO_FRAME_TYPE_INTERNAL))
>>>                ath9k_tx_status(hw, skb);
>>>        else {
>>> -               q = skb_get_queue_mapping(skb);
>>> -               if (q >= 4)
>>> -                       q = 0;
>>> +               struct ath_txq *txq;
>>>
>>> -               if (--sc->tx.pending_frames[q] < 0)
>>> -                       sc->tx.pending_frames[q] = 0;
>>> +               q = skb_get_queue_mapping(skb);
>>> +               txq = sc->tx.txq_map[q];
>>> +               if (--txq->pending_frames < 0)
>>> +                       txq->pending_frames = 0;
>>
>> This is off topic, cut do we really need this? Where do those missing
>> frames go? :) I would much prefer a BUG_ON(txq->pending_frames < 0).
> BUG_ON is not a good idea, it's only supposed to be used for cases with
> potentially severe side effects, things like random memory corruption.
> A counting imbalance here would be completely harmless, so at most we
> should have a WARN_ON_ONCE here.

Ok, agree.

>
>>>                spin_lock_bh(&txq->axq_lock);
>>>                if (!list_empty(&txq->txq_fifo_pending)) {
>>> @@ -2375,7 +2366,7 @@ void ath_tx_node_init(struct ath_softc *
>>>        for (acno = 0, ac = &an->ac[acno];
>>>             acno < WME_NUM_AC; acno++, ac++) {
>>>                ac->sched    = false;
>>> -               ac->qnum = sc->tx.hwq_map[acno];
>>> +               ac->txq = sc->tx.txq_map[acno];
>>>                INIT_LIST_HEAD(&ac->tid_q);
>>>        }
>>>  }
>>> @@ -2385,17 +2376,13 @@ void ath_tx_node_cleanup(struct ath_soft
>>>        struct ath_atx_ac *ac;
>>>        struct ath_atx_tid *tid;
>>>        struct ath_txq *txq;
>>> -       int i, tidno;
>>> +       int tidno;
>>>
>>>        for (tidno = 0, tid = &an->tid[tidno];
>>>             tidno < WME_NUM_TID; tidno++, tid++) {
>>> -               i = tid->ac->qnum;
>>> -
>>> -               if (!ATH_TXQ_SETUP(sc, i))
>>> -                       continue;
>>>
>>> -               txq = &sc->tx.txq[i];
>>>                ac = tid->ac;
>>> +               txq = ac->txq;
>>
>> This is where it gets interesting... Since we do select the tid by
>> looking at the header qos and the tid maps to an ac, we implicitly
>> select the txq by looking at the header qos, no?
>>
>> This means that when we get to ath_tx_start_dma() we lock the txq
>> selected by looking at the skb queue mapping (i.e. txctl->txq), but we
>> then procede into ath_tx_send_ampdu() where the packet is queued to a
>> tid selected by looking at the header qos field. Later that packet
>> will be transmitted on the txq corresponding to that tid (tid ->ac
>> ->txq).
>>
>> It comes down to this: either we look at the header qos when we select
>> the queue (so the above cannot happen) or we relay on mac80211 to set
>> the header qos and the skb queue mapping in a certain way. If we
>> choose the later I vote for a BUG_ON(txctl->txq != tid->ac->txq) in
>> ath_tx_send_ampdu().
> For regular QoS data frames (and no other frames ever hit the
> aggregation code) there is only one possible way to map tid -> ac ->
> queue. I did review those code paths, and I believe them to be safe.
> If you want, we can add a WARN_ON_ONCE later, but definitely no BUG_ON.

I've briefly looked through the IEEE Std 802.11e-2005. There is a
clear requirement that "There shall be no reordering of unicast MSDUs
with the same TID value and addressed to the same destination" in
analog to what Hulmut pointed out earlier. Other than that the only
reference I can find is that: "The MAC data service for QSTAs shall
incorporate a TID with each MA-UNITDATA.request service. This TID
associates the MSDU with the AC or TS queue for the indicated
traffic." Why are you sure there is only one way to map tid -> ac ->
queue? I don't think it's hard to come up with a case where you want
to map differently (e.g. depending on RA or even TA).

Ok, regardless. So lets say there is a bug in mac80211 that allows a
"mismatch" between header qos tid and skb queue mapping to occur
(which in fact there is because this happens all the time with my
frame injection heavy app). Then it's ok for ath9k to screw up the
locking, possibly corrupt data and so on, silently?

Other than that I guess that it's basically an argument about
aesthetics, and you may very well be right. All I know is that I've
been following ath9k development now for almost two years and I'm
amazed by the severity of bugs that are still found, and I guess yet
to be found. We're dma:ing all over the place, deadlocking queues and
so on, on a regular basis, or at least we where 3 months ago. After
each one of these is fixed the attitude seems to be "now everything is
perfect and suggesting there could be some more problems or will be in
the future is just plain rude". Then yet another is found...

If you relay on something so fragile as the contents of frame data
"matching" skb_get_queue_mapping() I think you owe me at least a
WARN_ON_ONCE before you start corrupting memory. ;)

>>> @@ -423,59 +424,18 @@ static int ath9k_init_btcoex(struct ath_
>>>
>>>  static int ath9k_init_queues(struct ath_softc *sc)
>>>  {
>>> -       struct ath_common *common = ath9k_hw_common(sc->sc_ah);
>>>        int i = 0;
>>>
>>> -       for (i = 0; i < ARRAY_SIZE(sc->tx.hwq_map); i++)
>>> -               sc->tx.hwq_map[i] = -1;
>>> -
>>>        sc->beacon.beaconq = ath9k_hw_beaconq_setup(sc->sc_ah);
>>> -       if (sc->beacon.beaconq == -1) {
>>> -               ath_print(common, ATH_DBG_FATAL,
>>> -                         "Unable to setup a beacon xmit queue\n");
>>> -               goto err;
>>> -       }
>>> -
>>>        sc->beacon.cabq = ath_txq_setup(sc, ATH9K_TX_QUEUE_CAB, 0);
>>> -       if (sc->beacon.cabq == NULL) {
>>> -               ath_print(common, ATH_DBG_FATAL,
>>> -                         "Unable to setup CAB xmit queue\n");
>>> -               goto err;
>>> -       }
>>>
>>>        sc->config.cabqReadytime = ATH_CABQ_READY_TIME;
>>>        ath_cabq_update(sc);
>>>
>>> -       if (!ath_tx_setup(sc, WME_AC_BK)) {
>>> -               ath_print(common, ATH_DBG_FATAL,
>>> -                         "Unable to setup xmit queue for BK traffic\n");
>>> -               goto err;
>>> -       }
>>> -
>>> -       if (!ath_tx_setup(sc, WME_AC_BE)) {
>>> -               ath_print(common, ATH_DBG_FATAL,
>>> -                         "Unable to setup xmit queue for BE traffic\n");
>>> -               goto err;
>>> -       }
>>> -       if (!ath_tx_setup(sc, WME_AC_VI)) {
>>> -               ath_print(common, ATH_DBG_FATAL,
>>> -                         "Unable to setup xmit queue for VI traffic\n");
>>> -               goto err;
>>> -       }
>>> -       if (!ath_tx_setup(sc, WME_AC_VO)) {
>>> -               ath_print(common, ATH_DBG_FATAL,
>>> -                         "Unable to setup xmit queue for VO traffic\n");
>>> -               goto err;
>>> -       }
>>> +       for (i = 0; i < WME_NUM_AC; i++)
>>> +               sc->tx.txq_map[i] = ath_txq_setup(sc, ATH9K_TX_QUEUE_DATA, i);
>>
>> Can we be sure that ath_txq_setup() will always return a distinct txq
>> on each call? Otherwise I suggest an inner loop of BUG_ON() to make
>> sure no two elements of txq_map are the same.
> Yes, we can be sure. I reviewed the entire code path that this runs
> through and there is no way that this can fail. There are way too many
> layers of useless defensive code in ath9k, and I think we should start
> getting rid of them one by one ;)

As long as we agree that is the contract I'm fine with it.

/Björn
