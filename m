Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:25288 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328Ab1AGGvc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 01:51:32 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 06 Jan 2011 22:51:15 -0800
Date: Fri, 7 Jan 2011 12:21:01 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: "greearb@candelatech.com" <greearb@candelatech.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>
Subject: Re: [PATCH 2/3] ath9k:  Re-start xmit logic in xmit watchdog timer.
Message-ID: <20110107065101.GB13800@vasanth-laptop>
References: <1294361165-15308-1-git-send-email-greearb@candelatech.com> <1294361165-15308-2-git-send-email-greearb@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1294361165-15308-2-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 07, 2011 at 06:16:04AM +0530, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> We should not get to this state, but we do.  What is
> worse, many times the xmit logic still will not start,
> probably due to tids being paused when they shouldn't be.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> 
> NOTE:  This needs review.  It might be too much of a hack
> for upstream code, and at best it works around a small part
> of the problem.
> 
> :100644 100644 3aae523... 547fb44... M	drivers/net/wireless/ath/ath9k/xmit.c
>  drivers/net/wireless/ath/ath9k/xmit.c |   21 +++++++++++++++++++++
>  1 files changed, 21 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
> index 3aae523..547fb44 100644
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -2110,6 +2110,27 @@ static void ath_tx_complete_poll_work(struct work_struct *work)
>  				} else {
>  					txq->axq_tx_inprogress = true;
>  				}
> +			} else {
> +				/* If the queue has pending buffers, then it
> +				 * should be doing tx work (and have axq_depth).
> +				 * Shouldn't get to this state I think..but
> +				 * perhaps we do.
> +				 */
> +				if (!list_empty(&txq->axq_acq)) {
> +					ath_err(ath9k_hw_common(sc->sc_ah),
> +						"txq: %p axq_qnum: %i,"
> +						" axq_link: %p"
> +						" pending frames: %i"
> +						" axq_acq is not empty, but"
> +						" axq_depth is zero.  Calling"
> +						" ath_txq_schedule to restart"
> +						" tx logic.\n",
> +						txq, txq->axq_qnum,
> +						txq->axq_link,
> +						txq->pending_frames);
> +					ATH_DBG_WARN_ON_ONCE(1);
> +					ath_txq_schedule(sc, txq);

NAK. This complete work monitors the hw q periodically and does a reset if a
hang is detected. This work is no way meant to schedule aggr. This
change really does not make any sense. Scheduling a tid periodically
would introduce reordering issues especially when there are more
retries.


Vasanth
