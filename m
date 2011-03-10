Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:55272 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251Ab1CJJ0V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 04:26:21 -0500
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2011 01:25:59 -0800
Date: Thu, 10 Mar 2011 14:55:59 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH 3/4] ath9k: fix the .flush driver op implementation
Message-ID: <20110310092559.GC28100@vasanth-laptop>
References: <1299717303-42430-1-git-send-email-nbd@openwrt.org> <1299717303-42430-2-git-send-email-nbd@openwrt.org> <1299717303-42430-3-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1299717303-42430-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 10, 2011 at 06:05:02AM +0530, Felix Fietkau wrote:
> ath9k has a timeout of 60ms for the flush, but instead waiting 60 ms for
> all tx activity to finish, it resets it for every single queue.

No, it does not do reset for every queue.

> +	for (j = 0; j < timeout; j++) {
> +		int npend = 0;
> +		for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
> +			if (!ATH_TXQ_SETUP(sc, i))
> +				continue;
>  
> -		if (drop || ath9k_has_pending_frames(sc, txq)) {
> -			ath_dbg(common, ATH_DBG_QUEUE, "Drop frames from hw queue:%d\n",
> -				txq->axq_qnum);
> -			spin_lock_bh(&txq->axq_lock);
> -			txq->txq_flush_inprogress = true;
> -			spin_unlock_bh(&txq->axq_lock);
> -
> -			ath9k_ps_wakeup(sc);
> -			ath9k_hw_stoptxdma(ah, txq->axq_qnum);
> -			npend = ath9k_hw_numtxpending(ah, txq->axq_qnum);
> -			ath9k_ps_restore(sc);
> -			if (npend)
> -				break;
> -
> -			ath_draintxq(sc, txq, false);
> -			txq->txq_flush_inprogress = false;
> +			npend += ath9k_has_pending_frames(sc, &sc->tx.txq[i]);
>  		}
> -	}
>  
> -	if (npend) {
> -		ath_reset(sc, false);
> -		txq->txq_flush_inprogress = false;
> +		if (!npend)
> +		    goto out;
> +
> +		usleep_range(1000, 2000);

Existing flush gives about 60ms for every q, that is reasonable
time, but this 60ms for all the queues is too small. This flush
is also called before sending null func in PS, so reset after
hw queue stuck is necessary to find the hang early on.
The usage of txq_flush_inprogress needs to be removed in other
places in xmit.

Vasanth
