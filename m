Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50556 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289AbZBWTpV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 14:45:21 -0500
Date: Mon, 23 Feb 2009 14:37:04 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Peter Chubb <peterc@gelato.unsw.edu.au>
Cc: jirislaby@gmail.com, mickflemm@gmail.com, lrodriguz@atheros.com,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Subject: Re: [PATCH] Fix transmit LED on Acer Aspire One
Message-ID: <20090223193704.GC3553@tuxdriver.com> (sfid-20090223_204524_888117_028385C6)
References: <87wsbobfza.wl%peter@chubb.wattle.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87wsbobfza.wl%peter@chubb.wattle.id.au>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 18, 2009 at 02:07:05PM +1100, Peter Chubb wrote:
> 
> I've seen a whole heap of fixes for the Aspire One's wireless LED on
> the web, but nothing in the kernel yet.
> 
> Here's my take on it.  My only worry is other machines with the same card.
> 
> Signed-off-by: Peter Chubb <peterc@gelato.unsw.edu.au>
> 
> ---
> ---
>  drivers/net/wireless/ath5k/base.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> Index: linux-2.6/drivers/net/wireless/ath5k/base.c
> ===================================================================
> --- linux-2.6.orig/drivers/net/wireless/ath5k/base.c	2009-02-18 10:26:48.000000000 +1100
> +++ linux-2.6/drivers/net/wireless/ath5k/base.c	2009-02-18 14:06:06.000000000 +1100
> @@ -2619,6 +2619,12 @@
>  		sc->led_pin = 1;
>  		sc->led_on = 1;  /* active high */
>  	}
> +	/* Enable softled on Acer Aspire One */
> +	else if (pdev->subsystem_vendor == 0x105b && pdev->subsystem_device == 0xe008) {
> +		__set_bit(ATH_STAT_LEDSOFT, sc->status);
> +		sc->led_pin = 3;
> +		sc->led_on = 0;
> +	}
>  	if (!test_bit(ATH_STAT_LEDSOFT, sc->status))
>  		goto out;

Any comment on this from the ath5k guys?  That 0x105b subvendor ID
would seem to correspond to "Foxconn International, Inc.", which
doesn't sound much like "Acer"...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
