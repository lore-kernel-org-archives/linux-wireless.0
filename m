Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53764 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006Ab0LCGfX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Dec 2010 01:35:23 -0500
Received: by mail-qw0-f46.google.com with SMTP id 7so9253838qwb.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 22:35:23 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20101203040938.GD2988@makis.mantri>
References: <20101203040938.GD2988@makis.mantri>
Date: Fri, 3 Dec 2010 07:35:22 +0100
Message-ID: <AANLkTik7TLLJ0_TpUf7D25otkq6gDEY8y+sPcPgzsVO3@mail.gmail.com>
Subject: Re: [PATCH 4/6] ath5k: Fix reporting of RX dma stop failure
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org,
	sedat.dilek@googlemail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tested-by: Sedat Dilek <sedat.dilek@gmail.com>

On Fri, Dec 3, 2010 at 5:09 AM, Nick Kossifidis <mickflemm@gmail.com> wrote:
>  * Correctly report failure to stop RX DMA
>
>  Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
>
> ---
>  drivers/net/wireless/ath/ath5k/dma.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/dma.c b/drivers/net/wireless/ath/ath5k/dma.c
> index 82541fe..0064be7 100644
> --- a/drivers/net/wireless/ath/ath5k/dma.c
> +++ b/drivers/net/wireless/ath/ath5k/dma.c
> @@ -72,7 +72,7 @@ static int ath5k_hw_stop_rx_dma(struct ath5k_hw *ah)
>                        i--)
>                udelay(100);
>
> -       if (i)
> +       if (!i)
>                ATH5K_DBG(ah->ah_sc, ATH5K_DEBUG_DMA,
>                                "failed to stop RX DMA !\n");
>
>
