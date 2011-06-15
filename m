Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59156 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753508Ab1FOCcD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2011 22:32:03 -0400
Subject: Re: [PATCH][TRIVIAL] if_spi: Fix compilation warning - unused
 variable
From: Dan Williams <dcbw@redhat.com>
To: Nikanth Karthikesan <nikanth@google.com>
Cc: Jiri Kosina <trivial@kernel.org>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org
Date: Tue, 14 Jun 2011 21:33:54 -0500
In-Reply-To: <1308030827.28682.32.camel@nikanth.blr.corp.google.com>
References: <1307696222.28682.20.camel@nikanth.blr.corp.google.com>
	 <1307976362.2117.4.camel@dcbw.foobar.com>
	 <1308030827.28682.32.camel@nikanth.blr.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1308105236.6398.5.camel@dcbw.foobar.com> (sfid-20110615_043213_562620_EDBDAF52)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-06-14 at 11:23 +0530, Nikanth Karthikesan wrote:
> if_spi: Fix compilation warning - unused variable 'spi'
> 
> drivers/net/wireless/libertas/if_spi.c: In function ‘if_spi_init_card’:
> drivers/net/wireless/libertas/if_spi.c:1035: warning: unused variable ‘spi’
> 
> The variable is used only in a macro which uses the args only for DEBUG builds.
> Remove the 'spi' variable completely.
> 
> Signed-off-by: Nikanth Karthikesan <nikanth@google.com>

Acked-by: Dan Williams <dcbw@redhat.com>

> 
> ---
> 
> Index: linux-2.6/drivers/net/wireless/libertas/if_spi.c
> ===================================================================
> --- linux-2.6.orig/drivers/net/wireless/libertas/if_spi.c	2011-06-10 14:16:17.990985032 +0530
> +++ linux-2.6/drivers/net/wireless/libertas/if_spi.c	2011-06-14 09:33:16.151025614 +0530
> @@ -1032,7 +1032,6 @@
>  static int if_spi_init_card(struct if_spi_card *card)
>  {
>  	struct lbs_private *priv = card->priv;
> -	struct spi_device *spi = card->spi;
>  	int err, i;
>  	u32 scratch;
>  	const struct firmware *helper = NULL;
> @@ -1080,8 +1079,9 @@
>  				"attached to SPI bus_num %d, chip_select %d. "
>  				"spi->max_speed_hz=%d\n",
>  				card->card_id, card->card_rev,
> -				spi->master->bus_num, spi->chip_select,
> -				spi->max_speed_hz);
> +				card->spi->master->bus_num,
> +				card->spi->chip_select,
> +				card->spi->max_speed_hz);
>  		err = if_spi_prog_helper_firmware(card, helper);
>  		if (err)
>  			goto out;
> 
> 
> 
> _______________________________________________
> libertas-dev mailing list
> libertas-dev@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/libertas-dev


