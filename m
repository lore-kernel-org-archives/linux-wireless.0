Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-sa02.nokia.com ([147.243.1.48]:28008 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab0IUFha (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 01:37:30 -0400
Subject: Re: [PATCH v6 3/7] wl12xx: add platform data passing support
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Ohad Ben-Cohen <ohad@wizery.com>,
	John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	San Mehat <san@google.com>,
	"Quadros Roger (Nokia-MS/Helsinki)" <roger.quadros@nokia.com>,
	Tony Lindgren <tony@atomide.com>,
	Nicolas Pitre <nico@fluxnic.net>, Ido Yariv <ido@wizery.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	Russell King <linux@arm.linux.org.uk>,
	Vitaly Wool <vitalywool@gmail.com>
In-Reply-To: <1284593472-29964-1-git-send-email-ohad@wizery.com>
References: <1284593472-29964-1-git-send-email-ohad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Sep 2010 08:36:21 +0300
Message-ID: <1285047381.17849.11.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-09-16 at 01:31 +0200, ext Ohad Ben-Cohen wrote:
> Add a simple mechanism to pass platform data to the
> SDIO instances of wl12xx.
> 
> This way there is no confusion over who owns the 'embedded data',
> typechecking is preserved, and no possibility for the wrong driver to
> pick up the data.
> 
> Originally proposed by Russell King.
> 
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> ---

Acked-by: Luciano Coelho <luciano.coelho@nokia.com>


> diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
> index 5d4ce4d..85af697 100644
> --- a/drivers/net/wireless/Makefile
> +++ b/drivers/net/wireless/Makefile
> @@ -50,5 +50,7 @@ obj-$(CONFIG_ATH_COMMON)	+= ath/
>  obj-$(CONFIG_MAC80211_HWSIM)	+= mac80211_hwsim.o
>  
>  obj-$(CONFIG_WL12XX)	+= wl12xx/
> +# small builtin driver bit
> +obj-$(CONFIG_WL12XX_PLATFORM_DATA)	+= wl12xx/wl12xx_platform_data.o
>  
>  obj-$(CONFIG_IWM)	+= iwmc3200wifi/

I guess this part should be acked by John Linville as well, since it
adds something to the generic wireless driver object.  John?


-- 
Cheers,
Luca.

