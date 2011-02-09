Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:28790 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756006Ab1BIPEt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 10:04:49 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 09 Feb 2011 07:04:29 -0800
From: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 9 Feb 2011 20:34:45 +0530
Subject: RE: [RFC] ath9k: Implement op_flush()
Message-ID: <44EE5C37ADC36343B0625A05DD408C4850DAA785D1@CHEXMB-01.global.atheros.com>
References: <1297259390-8973-1-git-send-email-vasanth@atheros.com>,<4D52A17A.4030906@openwrt.org>
In-Reply-To: <4D52A17A.4030906@openwrt.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


________________________________________
From: Felix Fietkau [nbd@openwrt.org]
Sent: Wednesday, February 09, 2011 6:15 AM
To: Vasanth Thiagarajan
Cc: linville@tuxdriver.com; linux-wireless@vger.kernel.org
Subject: Re: [RFC] ath9k: Implement op_flush()

On 2011-02-09 2:49 PM, Vasanthakumar Thiagarajan wrote:
> When op_flush() is called with no drop (drop=false), the driver
> tries to tx as many frames as possible in 100ms on every hw queue.
> During this time period frames from sw queue are also scheduled on
> to respective hw queue.
>
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
>  drivers/net/wireless/ath/ath9k/main.c  |   72 ++++++++++++++++++++++++++++++++
>  drivers/net/wireless/ath/ath9k/xmit.c  |   27 +++++++-----
>  3 files changed, 89 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
> index 9272278..704521f 100644
> --- a/drivers/net/wireless/ath/ath9k/ath9k.h
> +++ b/drivers/net/wireless/ath/ath9k/ath9k.h
> @@ -192,6 +192,7 @@ struct ath_txq {
>       u32 axq_ampdu_depth;
>       bool stopped;
>       bool axq_tx_inprogress;
> +     bool txq_flush_inprogress;
>       struct list_head axq_acq;
>       struct list_head txq_fifo[ATH_TXFIFO_DEPTH];
>       struct list_head txq_fifo_pending;
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index 4ed43b2..cd07779 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -53,6 +53,21 @@ static u8 parse_mpdudensity(u8 mpdudensity)
>       }
>  }
>
ath9k_has_pending_frames would be a better name for this

yeah, thanks.

> +static bool ath9k_is_pending_frames(struct ath_softc *sc, struct ath_txq *txq)
> +{
> +     bool pending = false;
> +
> +     spin_lock_bh(&txq->axq_lock);
> +
> +     if (txq->axq_depth || !list_empty(&txq->axq_acq))
> +             pending = true;
> +     else if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)
> +             pending = !list_empty(&txq->txq_fifo_pending);
> +
> +     spin_unlock_bh(&txq->axq_lock);
> +     return pending;
> +}
> +
>  bool ath9k_setpower(struct ath_softc *sc, enum ath9k_power_mode mode)
>  {
>       unsigned long flags;
> @@ -2122,6 +2137,62 @@ static void ath9k_set_coverage_class(struct ieee80211_hw *hw, u8 coverage_class)
>       mutex_unlock(&sc->mutex);
>  }
>
> +static void ath9k_flush(struct ieee80211_hw *hw, bool drop)
> +{
> +#define ATH_FLUSH_TIMEOUT    100 /* ms */
> +     struct ath_softc *sc = hw->priv;
> +     struct ath_txq *txq;
> +     struct ath_hw *ah = sc->sc_ah;
> +     struct ath_common *common = ath9k_hw_common(ah);
> +     int i, j, npend = 0;
> +
> +     mutex_lock(&sc->mutex);
> +
> +     cancel_delayed_work_sync(&sc->tx_complete_work);
> +
> +     for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
> +             if (!ATH_TXQ_SETUP(sc, i))
> +                     continue;
> +             txq = &sc->tx.txq[i];
> +
> +             if (!drop) {
> +                     for (j = 0; j < ATH_FLUSH_TIMEOUT; i++) {
> +                             if (!ath9k_is_pending_frames(sc, txq))
> +                                     break;

Do not use mdelay, it blocks the CPU. msleep is better.

sure.
> +                             mdelay(1);
> +                     }
> +             }
> +
> +             if (drop || ath9k_is_pending_frames(sc, txq)) {
> +                     ath_dbg(common, ATH_DBG_QUEUE, "Drop frames from hw queue:%d\n",
> +                             txq->axq_qnum);
> +                     spin_lock_bh(&txq->axq_lock);
> +                     txq->txq_flush_inprogress = true;
> +                     spin_unlock_bh(&txq->axq_lock);
> +
> +                     ath9k_ps_wakeup(sc);
> +                     ath9k_hw_stoptxdma(ah, txq->axq_qnum);
> +                     npend = ath9k_hw_numtxpending(ah, txq->axq_qnum);
> +                     ath9k_ps_restore(sc);

Please move the reset outside of the for loop. Also, I think you can
leave out the spinlocks for the txq_flush_inprogress assignment below.

You mean the following code?, if we decided to do a reset, then we need not proceed
with the next queue. yeah, it is unnecessary to lock to access txq->txq_flush_inprogres
after a reset.
> +                     if (npend) {
> +                             ath_reset(sc, false);
> +                             spin_lock_bh(&txq->axq_lock);
> +                             txq->txq_flush_inprogress = false;
> +                             spin_unlock_bh(&txq->axq_lock);
> +                             break;
> +                     }
