Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:56405 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab1EJTsH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 15:48:07 -0400
Received: by qyk7 with SMTP id 7so1920223qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 10 May 2011 12:48:07 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1304720674-27031-1-git-send-email-greearb@candelatech.com>
References: <1304720674-27031-1-git-send-email-greearb@candelatech.com>
Date: Tue, 10 May 2011 21:48:06 +0200
Message-ID: <BANLkTi=LyX5z_Cmev85Ln-YEmxmmTW8=fA@mail.gmail.com> (sfid-20110510_214811_949169_3C782050)
Subject: Re: [PATCH] ath5k: Fix lockup due to un-init spinlock.
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 7, 2011 at 12:24 AM,  <greearb@candelatech.com> wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> This was introduced in 2.6.39-rc1 it seems.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> :100644 100644 203243b... 2204762... M  drivers/net/wireless/ath/ath5k/base.c
>  drivers/net/wireless/ath/ath5k/base.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> index 203243b..2204762 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -2394,7 +2394,7 @@ ath5k_init_softc(struct ath5k_softc *sc, const struct ath_bus_ops *bus_ops)
>        spin_lock_init(&sc->rxbuflock);
>        spin_lock_init(&sc->txbuflock);
>        spin_lock_init(&sc->block);
> -
> +       spin_lock_init(&sc->irqlock);
>
>        /* Setup interrupt handler */
>        ret = request_irq(sc->irq, ath5k_intr, IRQF_SHARED, "ath", sc);
> --
> 1.7.3.4
>
>

Tested against linux-next (next-20110510).

- Sedat -
