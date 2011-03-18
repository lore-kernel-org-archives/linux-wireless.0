Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:32968 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab1CRAUN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2011 20:20:13 -0400
Received: by iyb26 with SMTP id 26so3401122iyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2011 17:20:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1296119711-4024-4-git-send-email-vnatarajan@atheros.com>
References: <1296119711-4024-1-git-send-email-vnatarajan@atheros.com>
 <1296119711-4024-2-git-send-email-vnatarajan@atheros.com> <1296119711-4024-3-git-send-email-vnatarajan@atheros.com>
 <1296119711-4024-4-git-send-email-vnatarajan@atheros.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 17 Mar 2011 17:19:53 -0700
Message-ID: <AANLkTim=KNYmEVddpNRD33iOYiMBh+x0WnegBWD0i3FO@mail.gmail.com>
Subject: Re: [PATCH 4/5] ath9k: Fix a locking related issue.
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 27, 2011 at 1:15 AM, Vivek Natarajan <vnatarajan@atheros.com> wrote:
> Spin_lock has been tried to be acquired twice from ath9k_tasklet
> to ath_reset which resulted in a machine freeze.
>
> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
> ---

Was this a stable fix? :(


>  drivers/net/wireless/ath/ath9k/xmit.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
> index c73452d..84673fb 100644
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -564,8 +564,11 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
>
>        rcu_read_unlock();
>
> -       if (needreset)
> +       if (needreset) {
> +               spin_unlock_bh(&sc->sc_pcu_lock);
>                ath_reset(sc, false);
> +               spin_lock_bh(&sc->sc_pcu_lock);
> +       }
>  }
>
>  static u32 ath_lookup_rate(struct ath_softc *sc, struct ath_buf *bf,
> --
> 1.6.3.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
