Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:39218 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934426Ab3DGWVv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Apr 2013 18:21:51 -0400
Received: by mail-wi0-f169.google.com with SMTP id c10so3286785wiw.0
        for <linux-wireless@vger.kernel.org>; Sun, 07 Apr 2013 15:21:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1365372253-32782-7-git-send-email-nbd@openwrt.org>
References: <1365372253-32782-1-git-send-email-nbd@openwrt.org>
	<1365372253-32782-2-git-send-email-nbd@openwrt.org>
	<1365372253-32782-3-git-send-email-nbd@openwrt.org>
	<1365372253-32782-4-git-send-email-nbd@openwrt.org>
	<1365372253-32782-5-git-send-email-nbd@openwrt.org>
	<1365372253-32782-6-git-send-email-nbd@openwrt.org>
	<1365372253-32782-7-git-send-email-nbd@openwrt.org>
Date: Sun, 7 Apr 2013 15:21:49 -0700
Message-ID: <CAJ-VmokPT5orM5zgZkZYnhFsMC9KKjzMXvRn-isNhtCLMSCquw@mail.gmail.com> (sfid-20130408_002156_171499_7B64B171)
Subject: Re: [PATCH 7/7] ath9k: implement buffer holding handling for EDMA FIFO
From: Adrian Chadd <adrian@freebsd.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For what it's worth, I've verified this DMA behaviour with the MAC
team and tested a similar fix for FreeBSD's EDMA code.

(They were confused as to why were doing this in the first place,
until I pointed out how we do CABQ.)

I'm happy to provide more background into the issue if people care.

Thanks,



Adrian

On 7 April 2013 15:04, Felix Fietkau <nbd@openwrt.org> wrote:
> Inside one FIFO slot queue, EDMA chipsets have the same link pointer
> re-read race condition as older chipsets, so the same buffer holding
> logic needs to be used in order to avoid use-after-free bugs.
> Unlike on older chips, it can be skipped for the end of the queue.
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  drivers/net/wireless/ath/ath9k/xmit.c | 30 +++++++++++++++++++-----------
>  1 file changed, 19 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
> index 94b2ee1..5bc5802 100644
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -516,8 +516,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
>                  * not a holding desc.
>                  */
>                 INIT_LIST_HEAD(&bf_head);
> -               if ((sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) ||
> -                   bf_next != NULL || !bf_last->bf_stale)
> +               if (bf_next != NULL || !bf_last->bf_stale)
>                         list_move_tail(&bf->list, &bf_head);
>
>                 if (!txpending || (tid->state & AGGR_CLEANUP)) {
> @@ -537,8 +536,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
>                                 !txfail);
>                 } else {
>                         /* retry the un-acked ones */
> -                       if (!(sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) &&
> -                           bf->bf_next == NULL && bf_last->bf_stale) {
> +                       if (bf->bf_next == NULL && bf_last->bf_stale) {
>                                 struct ath_buf *tbf;
>
>                                 tbf = ath_clone_txbuf(sc, bf_last);
> @@ -2264,6 +2262,7 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
>         struct ath_txq *txq;
>         struct ath_buf *bf, *lastbf;
>         struct list_head bf_head;
> +       struct list_head *fifo_list;
>         int status;
>
>         for (;;) {
> @@ -2291,20 +2290,24 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
>
>                 TX_STAT_INC(txq->axq_qnum, txprocdesc);
>
> -               if (list_empty(&txq->txq_fifo[txq->txq_tailidx])) {
> +               fifo_list = &txq->txq_fifo[txq->txq_tailidx];
> +               if (list_empty(fifo_list)) {
>                         ath_txq_unlock(sc, txq);
>                         return;
>                 }
>
> -               bf = list_first_entry(&txq->txq_fifo[txq->txq_tailidx],
> -                                     struct ath_buf, list);
> +               bf = list_first_entry(fifo_list, struct ath_buf, list);
> +               if (bf->bf_stale) {
> +                       list_del(&bf->list);
> +                       ath_tx_return_buffer(sc, bf);
> +                       bf = list_first_entry(fifo_list, struct ath_buf, list);
> +               }
> +
>                 lastbf = bf->bf_lastbf;
>
>                 INIT_LIST_HEAD(&bf_head);
> -               list_cut_position(&bf_head, &txq->txq_fifo[txq->txq_tailidx],
> -                                 &lastbf->list);
> -
> -               if (list_empty(&txq->txq_fifo[txq->txq_tailidx])) {
> +               if (list_is_last(&lastbf->list, fifo_list)) {
> +                       list_splice_tail_init(fifo_list, &bf_head);
>                         INCR(txq->txq_tailidx, ATH_TXFIFO_DEPTH);
>
>                         if (!list_empty(&txq->axq_q)) {
> @@ -2315,6 +2318,11 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
>                                 list_splice_tail_init(&txq->axq_q, &bf_q);
>                                 ath_tx_txqaddbuf(sc, txq, &bf_q, true);
>                         }
> +               } else {
> +                       lastbf->bf_stale = true;
> +                       if (bf != lastbf)
> +                               list_cut_position(&bf_head, fifo_list,
> +                                                 lastbf->list.prev);
>                 }
>
>                 ath_tx_process_buffer(sc, txq, &ts, bf, &bf_head);
> --
> 1.8.0.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
