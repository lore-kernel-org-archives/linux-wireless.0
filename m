Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:58071 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab1KSQPm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Nov 2011 11:15:42 -0500
Received: by wwe3 with SMTP id 3so2867235wwe.1
        for <linux-wireless@vger.kernel.org>; Sat, 19 Nov 2011 08:15:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1321684883-6870-1-git-send-email-mar.kolya@gmail.com>
References: <1321684883-6870-1-git-send-email-mar.kolya@gmail.com>
Date: Sat, 19 Nov 2011 21:45:41 +0530
Message-ID: <CAD2nsn37SxnbwponwWPGMgxfcY3sEZjUFXkNBonobGZ=3Dr38Q@mail.gmail.com> (sfid-20111119_171550_442187_1E71D159)
Subject: Re: [PATCH] ath9k: Improve ath_tx_aggr_stop to avoid TID stuck in
 cleanup state.
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Nikolay Martynov <mar.kolya@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, rodrigue@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Nikolay,

On Sat, Nov 19, 2011 at 12:11 PM, Nikolay Martynov <mar.kolya@gmail.com> wrote:
> From: kolya <mar.kolya@gmail.com>
>
>  When tx agg is being stopped TID is flushed using ath_tx_flush_tid. It is possible that ath_tx_flush_tid completelly flushes TID (if all packets in this TID have already been retried). If this happened ath_tx_aggr_stop would leave TID in cleanup state permanently. Fix this by making ath_tx_flush_tid remove AGGR_ADDBA_COMPLETE and AGGR_CLEANUP flags from TID status if TID is empty.
> ---
>  drivers/net/wireless/ath/ath9k/xmit.c |   13 ++++++-------
>  1 files changed, 6 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
> index 55d077e..3574b0f 100644
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -180,6 +180,11 @@ static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
>        }
>
>        spin_unlock_bh(&txq->axq_lock);
> +
> +       if (tid->baw_head == tid->baw_tail) {
> +               tid->state &= ~AGGR_ADDBA_COMPLETE;
> +               tid->state &= ~AGGR_CLEANUP;
> +       }

should this in be protected by axq_lock ?

>  }
>
>  static void ath_tx_update_baw(struct ath_softc *sc, struct ath_atx_tid *tid,
> @@ -556,15 +561,9 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
>                spin_unlock_bh(&txq->axq_lock);
>        }
>
> -       if (tid->state & AGGR_CLEANUP) {
> +       if (tid->state & AGGR_CLEANUP)
>                ath_tx_flush_tid(sc, tid);
>
> -               if (tid->baw_head == tid->baw_tail) {
> -                       tid->state &= ~AGGR_ADDBA_COMPLETE;
> -                       tid->state &= ~AGGR_CLEANUP;
> -               }
> -       }
> -
>        rcu_read_unlock();
>
>        if (needreset) {

based on my understanding if we don't clear this flag, i assume we
might have problem in ath_tx_aggr_start?
but should not this be properly cleared ath_txcomplete_aggr via tasklet path?
please let me know if i had  missed somthing?

> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
shafi
