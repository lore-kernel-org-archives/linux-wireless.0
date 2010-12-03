Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:42157 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab0LCGet convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Dec 2010 01:34:49 -0500
Received: by mail-qy0-f181.google.com with SMTP id 12so11298293qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 22:34:49 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20101203040519.GB2988@makis.mantri>
References: <20101203040519.GB2988@makis.mantri>
Date: Fri, 3 Dec 2010 07:34:48 +0100
Message-ID: <AANLkTim7F82Y5qj2kZP=5Jn-3xV3vPnSNci5WVkfuAVs@mail.gmail.com>
Subject: Re: [PATCH 2/6] ath5k: Always free tx buffers before reset
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org,
	sedat.dilek@googlemail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tested-by: Sedat Dilek <sedat.dilek@gmail.com>

On Fri, Dec 3, 2010 at 5:05 AM, Nick Kossifidis <mickflemm@gmail.com> wrote:
>  * Always free tx buffers before reset, since we also empty hw queues.
>  If we don't and a queue gets stuck, we'll never decrease txq_len and sw
>  will keep thinking the queue is still stuck even after reset.
>
>  Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
>
> ---
>  drivers/net/wireless/ath/ath5k/base.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> index a8d380a..047b2a0 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -2512,9 +2512,11 @@ ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan,
>        synchronize_irq(sc->pdev->irq);
>        stop_tasklets(sc);
>
> +       /* We are going to empty hw queues
> +        * so we should also free any remaining
> +        * tx buffers */
> +       ath5k_drain_tx_buffs(sc);
>        if (chan) {
> -               ath5k_drain_tx_buffs(sc);
> -
>                sc->curchan = chan;
>                sc->curband = &sc->sbands[chan->band];
>        }
>
