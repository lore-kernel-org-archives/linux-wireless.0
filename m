Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:38761 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500Ab2KMHXO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 02:23:14 -0500
Message-ID: <1352791357.28369.7.camel@cumari.coelho.fi> (sfid-20121113_082318_030496_0CD682B3)
Subject: Re: [wl12xx] wl1271 and SPI mode
From: Luciano Coelho <coelho@ti.com>
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>
CC: <linux-wireless@vger.kernel.org>
Date: Tue, 13 Nov 2012 09:22:37 +0200
In-Reply-To: <CAFED-jker_rDU7160AukGW4av0hT4yphkfOnd6GsYC83e-t68g@mail.gmail.com>
References: <CAFED-jker_rDU7160AukGW4av0hT4yphkfOnd6GsYC83e-t68g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-05 at 14:53 +0100, Janusz Dziedzic wrote:
> Hello,

Hi Janusz,


> I have a question connected with wl12xx - I am using wl1271 driver.
> This is the SPI one (NOKIA N950).
> After driver probe I have dump like below. I added small patch - but
> the question is how stable is it - SPI mode. Will work correctly, is
> "stable" now and someone test it? Is SPI supported correctly and
> "fully" in latest code? Will firmware also support SPI correctly with
> the newest code?

Only Nokia was using wl1271 with SPI and since I left Nokia I haven't
had a device with wl1271 connected over SPI, so it has not been tested
at all for a while.

We try to keep SPI working, but we haven't put much effort into it in
the past couple of years.  Since we can't test, some people even
proposed removing SPI support altogether, but I preferred not to do it
so that someone (like you!) could try it at some point and report bugs
(as you did!) so we can fix them. ;)

So please, *do* test it and let us know how it goes.  If you find any
issues, we'll try to fix them.


> BTW. I don't have any issues with SDIO version (N9 phone) - works perfectly.

That's great to hear! We *do* test the SDIO version of our drivers. ;)
BTW, which kernel version are you using?


> Patch (drivers/net/wireless/ti/wlcore/spi.c)
> 
> +static int wl12xx_spi_power(struct device *child, bool enable)
> +{
> +	struct wl1271 *wl = dev_get_drvdata(child);
> +	if (wl->set_power)
> +		wl->set_power(enable);
> +	return 0;
> +}
> +
>  static struct wl1271_if_operations spi_ops = {
>  	.read		= wl12xx_spi_raw_read,
>  	.write		= wl12xx_spi_raw_write,
>  	.reset		= wl12xx_spi_reset,
>  	.init		= wl12xx_spi_init,
> +	.power		= wl12xx_spi_power,
>  	.set_block_size = NULL,
>  };

This looks reasonable.  Do you want to send it in a git patch format so
I can apply? Otherwise I can create the commit myself.

Thanks for your work!

--
Cheers,
Luca.

