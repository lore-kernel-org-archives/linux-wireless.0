Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35703 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab1EJTpy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 15:45:54 -0400
Date: Tue, 10 May 2011 15:42:11 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath5k:  Fix lockup due to un-init spinlock.
Message-ID: <20110510194211.GG2520@tuxdriver.com> (sfid-20110510_214600_387415_FAB4F64F)
References: <1304720674-27031-1-git-send-email-greearb@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1304720674-27031-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When applied to wireless-2.6, I get this:

  CC [M]  drivers/net/wireless/ath/ath5k/base.o
drivers/net/wireless/ath/ath5k/base.c: In function ‘ath5k_init_softc’:
drivers/net/wireless/ath/ath5k/base.c:2357:2: error: ‘struct ath5k_softc’ has no member named ‘irqlock’
drivers/net/wireless/ath/ath5k/base.c:2357:2: error: ‘struct ath5k_softc’ has no member named ‘irqlock’

Is this only for -next?

On Fri, May 06, 2011 at 03:24:34PM -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> This was introduced in 2.6.39-rc1 it seems.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> :100644 100644 203243b... 2204762... M	drivers/net/wireless/ath/ath5k/base.c
>  drivers/net/wireless/ath/ath5k/base.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> index 203243b..2204762 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -2394,7 +2394,7 @@ ath5k_init_softc(struct ath5k_softc *sc, const struct ath_bus_ops *bus_ops)
>  	spin_lock_init(&sc->rxbuflock);
>  	spin_lock_init(&sc->txbuflock);
>  	spin_lock_init(&sc->block);
> -
> +	spin_lock_init(&sc->irqlock);
>  
>  	/* Setup interrupt handler */
>  	ret = request_irq(sc->irq, ath5k_intr, IRQF_SHARED, "ath", sc);
> -- 
> 1.7.3.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
