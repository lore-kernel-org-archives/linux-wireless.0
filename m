Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44392 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788Ab1AJFCg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 00:02:36 -0500
Message-ID: <4D2A92E3.6010403@openwrt.org>
Date: Sun, 09 Jan 2011 22:02:27 -0700
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath9k:  Restart xmit logic in xmit watchdog.
References: <1294559160-29298-1-git-send-email-greearb@candelatech.com> <4D29FC3F.2030103@openwrt.org> <4D2A8D74.80304@candelatech.com>
In-Reply-To: <4D2A8D74.80304@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-01-09 9:39 PM, Ben Greear wrote:
> On 01/09/2011 10:19 AM, Felix Fietkau wrote:
>>  On 2011-01-09 12:46 AM, greearb@candelatech.com wrote:
>>>  diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
>>>  index d9a4144..1b3a62c 100644
>>>  --- a/drivers/net/wireless/ath/ath9k/xmit.c
>>>  +++ b/drivers/net/wireless/ath/ath9k/xmit.c
>>>  @@ -1988,19 +1988,30 @@ static void ath_tx_rc_status(struct ath_buf *bf, struct ath_tx_status *ts,
>>>  tx_info->status.rates[tx_rateindex].count = ts->ts_longretry + 1;
>>>  }
>>>
>>>  -static void ath_wake_mac80211_queue(struct ath_softc *sc, int qnum)
>>>  +/* Has no locking. */
>>>  +static void __ath_wake_mac80211_queue(struct ath_softc *sc, struct ath_txq *txq)
>>>  {
>>>  - struct ath_txq *txq;
>>>  -
>>>  - txq = sc->tx.txq_map[qnum];
>>>  - spin_lock_bh(&txq->axq_lock);
>>>  if (txq->stopped&&  txq->pending_frames<  ATH_MAX_QDEPTH) {
>>>  - if (ath_mac80211_start_queue(sc, qnum))
>>>  + if (ath_mac80211_start_queue(sc, txq->axq_qnum))
>>>  txq->stopped = 0;
>>>  }
>>>  +}
>>  This part is quite broken, I think you got confused with various types of queue numbers. txq->axq_qnum refers to the atheros hw queue index, whereas the qnum
>>  argument to this function refers to the mac80211 queue index (which is also the correct index for sc->tx.txq_map - not to be confused with the sc->tx.txq array).
>
> Yeah, I am confused on all of this.  Looks like I should add a member to the txq struct to
> record it's mac80211 index and use that instead?
How about just passing the proper qnum? You can get it from the skb 
queue mapping anyway.

> In the upstream code, is this correct?  It seems to me that it should always
> be waking 'txq' since it just completed a packet.  Why the check
> against txq_map?
>
> 		if (txq == sc->tx.txq_map[qnum])
> 			ath_wake_mac80211_queue(sc, qnum);
Things like CAB (or maybe UAPSD at some point), where a frame might go 
out through a queue other than the 4 WMM data queues.

- Felix
