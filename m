Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:50265 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932799AbZHDQSc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 12:18:32 -0400
Subject: Re: [PATCH] libertas: check valid bits in SPI bus mode reg
From: Dan Williams <dcbw@redhat.com>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: linux-wireless@vger.kernel.org, tharvey@irobot.com
In-Reply-To: <1249065319-18643-1-git-send-email-andrey@cozybit.com>
References: <1249065319-18643-1-git-send-email-andrey@cozybit.com>
Content-Type: text/plain
Date: Tue, 04 Aug 2009 11:19:10 -0400
Message-Id: <1249399150.21155.3.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-07-31 at 11:35 -0700, Andrey Yurovsky wrote:
> The SPI driver writes to the bus mode register and performs a sanity
> check by reading back what we wrote, however only the lower four bits of
> that register are defined.  In some cases, the device side seems to set
> the higher bits, causing us to fail the sanity check unnecessarily.
> Check only the lower four bits instead.
> 
> Thanks to John Goyette from Schick Technologies for pointing out the
> problem.
> 
> Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/if_spi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
> index 6564282..86263a9 100644
> --- a/drivers/net/wireless/libertas/if_spi.c
> +++ b/drivers/net/wireless/libertas/if_spi.c
> @@ -376,7 +376,7 @@ static int spu_set_bus_mode(struct if_spi_card *card, u16 mode)
>  	err = spu_read_u16(card, IF_SPI_SPU_BUS_MODE_REG, &rval);
>  	if (err)
>  		return err;
> -	if (rval != mode) {
> +	if ((rval & 0xF) != mode) {
>  		lbs_pr_err("Can't read bus mode register.\n");
>  		return -EIO;
>  	}

