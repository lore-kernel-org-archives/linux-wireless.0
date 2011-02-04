Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64881 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab1BDHgV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 02:36:21 -0500
Received: by iwn9 with SMTP id 9so1888439iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Feb 2011 23:36:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1296800640-6381-1-git-send-email-vnatarajan@atheros.com>
References: <1296800640-6381-1-git-send-email-vnatarajan@atheros.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 3 Feb 2011 23:36:01 -0800
Message-ID: <AANLkTi=tANgmxukLg0GQbLRkc-XuEBi-hmpJono=q=m8@mail.gmail.com>
Subject: Re: [PATCH 1/2] ath9k: Drain txq before sending a nullfunc frame.
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 3, 2011 at 10:23 PM, Vivek Natarajan <vnatarajan@atheros.com> wrote:
> In a highly noisy environment, a data frame which is queued before
> a nullfunc frame on a different hw queue may be sent over the air
> after the tx completion of nullfunc frame. This causes the station
> to enter power save and the AP to see the station as awake and
> continues to send the data traffic. Fix this by draining all tx
> queues before we send the null function frame with PM bit set.
>
> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>

Hm nice, this is a good example of one of those random not-so-critical
but still nice fixes which I wish would go to stable. John, Greg, any
qualms for such things to go to stable if they apply? It was my
impression we could send it, but I want to verify with both you guys
so neither we or John get bashed if we try to send it as a stable fix.

Vivek, is this applicable to stable kernels or does the hunk not even apply?

  Luis

> ---
>  drivers/net/wireless/ath/ath9k/xmit.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
> index 68a1c76..0cb6017 100644
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -1710,7 +1710,6 @@ static struct ath_buf *ath_tx_setup_buffer(struct ieee80211_hw *hw,
>                            bf->bf_buf_addr,
>                            txq->axq_qnum);
>
> -
>        return bf;
>  }
>
> @@ -1813,6 +1812,15 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
>        if (unlikely(!bf))
>                return -ENOMEM;
>
> +       if (ieee80211_is_nullfunc(hdr->frame_control) &&
> +           ieee80211_has_pm(hdr->frame_control)) {
> +               /* Drain all the pending frames before we send a nullfunc frame
> +                * to avoid any power save state mismatch between the station
> +                * and the AP.
> +                */
> +               ath_drain_all_txq(sc, false);
> +       }
> +
>        q = skb_get_queue_mapping(skb);
>        spin_lock_bh(&txq->axq_lock);
>        if (txq == sc->tx.txq_map[q] &&
> --
> 1.6.3.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
