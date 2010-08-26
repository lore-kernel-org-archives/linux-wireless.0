Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309Ab0HZPrO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Aug 2010 11:47:14 -0400
Subject: Re: [rfc patch] libertas: fix if_spi_prog_helper_firmware()
From: Dan Williams <dcbw@redhat.com>
To: Dan Carpenter <error27@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Ben Hutchings <ben@decadent.org.uk>,
	Mike Frysinger <vapier.adi@gmail.com>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	kernel-janitors@vger.kernel.org
In-Reply-To: <20100824120743.GG29330@bicker>
References: <20100824120743.GG29330@bicker>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Aug 2010 10:48:45 -0500
Message-ID: <1282837725.3642.1.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-08-24 at 14:07 +0200, Dan Carpenter wrote:
> The indenting is not correct here.  I don't have this hardware and I'm
> just guessing as to what was intended.  I think that if there is an
> error we should return an error code, but if there isn't an error we
> should return success directly without releasing the firmware.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

I've significantly changed firmware loading in wireless-testing which
should hit the next merge window.  It won't have this problem, and it
does correctly release the firmware later on.  It does preserve the
existing behavior of releasing the firmware after load, instead of
keeping it around for resume.  If there are fixes I think they should be
against wireless-testing actually since that's what's "next".

Dan

> diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
> index fe3f080..123a541 100644
> --- a/drivers/net/wireless/libertas/if_spi.c
> +++ b/drivers/net/wireless/libertas/if_spi.c
> @@ -471,9 +471,12 @@ static int if_spi_prog_helper_firmware(struct if_spi_card *card)
>  		goto release_firmware;
>  	err = spu_write_u16(card, IF_SPI_CARD_INT_CAUSE_REG,
>  				IF_SPI_CIC_CMD_DOWNLOAD_OVER);
> +	if (err)
>  		goto release_firmware;
>  
> -	lbs_deb_spi("waiting for helper to boot...\n");
> +	lbs_deb_spi("helper firmware loaded...\n");
> +
> +	return 0;
>  
>  release_firmware:
>  	release_firmware(firmware);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


