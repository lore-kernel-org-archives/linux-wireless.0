Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798Ab1HOWth (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 18:49:37 -0400
Subject: Re: [patch] libertas: remove some dead code in
 if_spi_prog_helper_firmware()
From: Dan Williams <dcbw@redhat.com>
To: Dan Carpenter <error27@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"open list:MARVELL LIBERTAS..." <libertas-dev@lists.infradead.org>,
	"open list:NETWORKING [WIREL..." <linux-wireless@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Date: Mon, 15 Aug 2011 17:51:54 -0500
In-Reply-To: <20110806142344.GA10373@mwanda>
References: <20110806142344.GA10373@mwanda>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1313448716.6103.14.camel@dcbw.foobar.com> (sfid-20110816_004941_626653_49BE630B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-08-06 at 07:23 -0700, Dan Carpenter wrote:
> We always hit the goto and skip the printk().  The original code does
> the right thing even though it looks messy.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Acked-by: Dan Williams <dcbw@redhat.com>

> 
> diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
> index e0286cf..622ae6d 100644
> --- a/drivers/net/wireless/libertas/if_spi.c
> +++ b/drivers/net/wireless/libertas/if_spi.c
> @@ -531,10 +531,6 @@ static int if_spi_prog_helper_firmware(struct if_spi_card *card,
>  		goto out;
>  	err = spu_write_u16(card, IF_SPI_CARD_INT_CAUSE_REG,
>  				IF_SPI_CIC_CMD_DOWNLOAD_OVER);
> -		goto out;
> -
> -	lbs_deb_spi("waiting for helper to boot...\n");
> -
>  out:
>  	if (err)
>  		pr_err("failed to load helper firmware (err=%d)\n", err);


