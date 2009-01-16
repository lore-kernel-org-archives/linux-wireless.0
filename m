Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:42198 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbZAPTdt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 14:33:49 -0500
Received: by bwz14 with SMTP id 14so5553531bwz.13
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2009 11:33:47 -0800 (PST)
To: Christian Lamparter <chunkeey@web.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] p54spi: fix build dependencies
References: <E1LNgyq-0006iZ-0M@sipsolutions.net>
	<1232098259.3854.39.camel@johannes>
	<200901161929.30204.chunkeey@web.de>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 16 Jan 2009 21:33:43 +0200
In-Reply-To: <200901161929.30204.chunkeey@web.de> (Christian Lamparter's message of "Fri\, 16 Jan 2009 19\:29\:29 +0100")
Message-ID: <87k58vxcyw.fsf@litku.valot.fi> (sfid-20090116_203355_171715_033D87C2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter <chunkeey@web.de> writes:

>> p54spi only depends on SPI_MASTER, but includes arm-specific files.
>
> Signed-off-by: Christian Lamparter <chunkeey@web.de>
> ---
> diff --git a/drivers/net/wireless/p54/Kconfig b/drivers/net/wireless/p54/Kconfig
> index cfc5f41..131dba3 100644
> --- a/drivers/net/wireless/p54/Kconfig
> +++ b/drivers/net/wireless/p54/Kconfig
> @@ -64,7 +64,8 @@ config P54_PCI
>  
>  config P54_SPI
>  	tristate "Prism54 SPI (stlc45xx) support"
> -	depends on P54_COMMON && SPI_MASTER
> +	depends on P54_COMMON && SPI_MASTER && ARCH_OMAP && \
> +		   (MACH_NOKIA_N800 || MACH_NOKIA_N810)

N800 and N810 support is not on mainline yet, for stlc45xx I decided
to add module parameters for the gpio numbers. Here's the commit from
stlc45xx repo:

http://gitorious.org/projects/stlc45xx/repos/mainline/commits/35afc5df0027d02d49e6f5bf986dcc4deb4ee6cf

After that the driver is generic and should compile everywhere.
omap_get_config() is deprecated anyway, we should use proper
platform_data instead.

-- 
Kalle Valo
