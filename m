Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37512 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab1ASA1B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 19:27:01 -0500
Message-ID: <4D362FC5.3090003@candelatech.com>
Date: Tue, 18 Jan 2011 16:26:45 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com
Subject: Re: [PATCH 1/2] ath9k: try more than one tid when scheduling a new
 aggregate
References: <1295098215-98910-1-git-send-email-nbd@openwrt.org>
In-Reply-To: <1295098215-98910-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/15/2011 05:30 AM, Felix Fietkau wrote:
> Sometimes the first TID in the first AC's list is not available for forming
> a new aggregate (the BAW might not allow it), however other TIDs may have
> data available for sending.
> Prevent a slowdown of other TIDs by going through multiple entries until
> we've either hit the last one or enough AMPDUs are pending in the hardware
> queue.

I had attempted a similar patch, but I was thinking we should iterate
through all of the txq->axq_acq entries, not just use the first one?

If you agree, I can merge my patch with your patch below
and re-post.

Thanks,
Ben


 >
 > Signed-off-by: Felix Fietkau<nbd@openwrt.org>
 > ---
 >   drivers/net/wireless/ath/ath9k/xmit.c |    9 ++++++---
 >   1 files changed, 6 insertions(+), 3 deletions(-)
 >
 > diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
 > index ab4f7b4..fffd13d 100644
 > --- a/drivers/net/wireless/ath/ath9k/xmit.c
 > +++ b/drivers/net/wireless/ath/ath9k/xmit.c
 > @@ -1224,12 +1224,14 @@ void ath_tx_cleanupq(struct ath_softc *sc, struct ath_txq *txq)
 >   void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 >   {
 >   	struct ath_atx_ac *ac;
 > -	struct ath_atx_tid *tid;
 > +	struct ath_atx_tid *tid, *last;
 >
 > -	if (list_empty(&txq->axq_acq))
 > +	if (list_empty(&txq->axq_acq) ||
 > +	    txq->axq_ampdu_depth>= ATH_AGGR_MIN_QDEPTH)
 >   		return;
 >
 >   	ac = list_first_entry(&txq->axq_acq, struct ath_atx_ac, list);
 > +	last = list_entry(ac->tid_q.prev, struct ath_atx_tid, list);
 >   	list_del(&ac->list);
 >   	ac->sched = false;
 >
 > @@ -1253,7 +1255,8 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 >   		if (!list_empty(&tid->buf_q))
 >   			ath_tx_queue_tid(txq, tid);
 >
 > -		break;
 > +		if (tid == last || txq->axq_ampdu_depth>= ATH_AGGR_MIN_QDEPTH)
 > +			break;
 >   	} while (!list_empty(&ac->tid_q));
 >
 >   	if (!list_empty(&ac->tid_q)) {

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

