Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:35939 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbbKMGbI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2015 01:31:08 -0500
Received: by wmww144 with SMTP id w144so15748282wmw.1
        for <linux-wireless@vger.kernel.org>; Thu, 12 Nov 2015 22:31:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1446572241-2246-1-git-send-email-borja.salazar@fon.com>
References: <1446572241-2246-1-git-send-email-borja.salazar@fon.com>
Date: Fri, 13 Nov 2015 07:31:06 +0100
Message-ID: <CALhHN=ov0kqqgGGHwPMOq3VaVsg9oD59Ed_NNsdcKVyS2+go2Q@mail.gmail.com> (sfid-20151113_073121_523601_AE09A0A4)
Subject: Re: [PATCH] ath9k: incorrect queue may be stopped/awaken
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Borja Salazar <borja.salazar@fon.com>,
	Sujith Manoharan <sujith@msujith.org>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3 November 2015 at 18:37, Borja Salazar <borja.salazar@fon.com> wrote:
> When channel context is enabled, we could be
> stopping/awakening an incorrect queue.
> ---
>  drivers/net/wireless/ath/ath9k/xmit.c | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
> index 3e3dac3..9b17a59 100644
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -147,7 +147,12 @@ static void ath_txq_skb_done(struct ath_softc *sc, struct ath_txq *txq,
>  {
>         struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
>         struct ath_frame_info *fi = get_frame_info(skb);
> -       int q = fi->txq;
> +       int q;
> +
> +       if (ath9k_is_chanctx_enabled())
> +               q = fi->txq;
> +       else
> +               q = info->hw_queue;
>
>         if (q < 0)
>                 return;
> @@ -158,10 +163,7 @@ static void ath_txq_skb_done(struct ath_softc *sc, struct ath_txq *txq,
>
>         if (txq->stopped &&
>             txq->pending_frames < sc->tx.txq_max_pending[q]) {
> -               if (ath9k_is_chanctx_enabled())
> -                       ieee80211_wake_queue(sc->hw, info->hw_queue);
> -               else
> -                       ieee80211_wake_queue(sc->hw, q);
> +               ieee80211_wake_queue(sc->hw, q);
>                 txq->stopped = false;
>         }
>  }
> @@ -2299,17 +2301,17 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
>          * info are no longer valid (overwritten by the ath_frame_info data.
>          */
>
> -       q = skb_get_queue_mapping(skb);
> +       if (ath9k_is_chanctx_enabled())
> +               q = skb_get_queue_mapping(skb);
> +       else
> +               q = info->hw_queue;
>
>         ath_txq_lock(sc, txq);
>         if (txq == sc->tx.txq_map[q]) {
>                 fi->txq = q;
>                 if (++txq->pending_frames > sc->tx.txq_max_pending[q] &&
>                     !txq->stopped) {
> -                       if (ath9k_is_chanctx_enabled())
> -                               ieee80211_stop_queue(sc->hw, info->hw_queue);
> -                       else
> -                               ieee80211_stop_queue(sc->hw, q);
> +                       ieee80211_stop_queue(sc->hw, q);
>                         txq->stopped = true;
>                 }
>         }
> --
> 2.3.6
>
Hello, could you check it again?
I see such patch that enable hw_queues only for MCC and disable for
non-MCC mode.

ath9k: Enable HW queue control only for MCC

    Enabling HW queue control for normal (non-mcc) mode
    causes problems with queue management, resulting
    in traffic stall. Since it is mainly required for
    fairness in MCC mode, disable it for the general case.

    Bug: https://dev.openwrt.org/ticket/18164

BR
Janusz
