Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:43356 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228Ab0KGK21 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Nov 2010 05:28:27 -0500
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Tony Lindgren <tony@atomide.com>,
	Ohad Ben-Cohen <ohad@wizery.com>, luciano.coelho@nokia.com
Subject: Re: [PATCH 3/3] wl1251: use wl12xx_platform_data to pass data
References: <1288822429-24541-1-git-send-email-notasas@gmail.com>
	<1288822429-24541-4-git-send-email-notasas@gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Sun, 07 Nov 2010 12:28:19 +0200
In-Reply-To: <1288822429-24541-4-git-send-email-notasas@gmail.com> (Grazvydas Ignotas's message of "Thu\,  4 Nov 2010 00\:13\:49 +0200")
Message-ID: <874obtzauz.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Grazvydas Ignotas <notasas@gmail.com> writes:

> Make use the newly added method to pass platform data for wl1251 too.
> This allows to eliminate some redundant code.
>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Ohad Ben-Cohen <ohad@wizery.com>
> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>

For the wl1251 part:

Acked-by: Kalle Valo <kvalo@adurom.com>

> ---
> This touches arch/arm/mach-omap2/* but I think it should go through
> the wireless tree to avoid cross-tree dependencies, if Tony and others
> are ok with this.

I agree, better to push this through the wireless tree.

>  arch/arm/mach-omap2/board-omap3pandora.c |   32 +++++++-------------------
>  drivers/net/wireless/wl1251/sdio.c       |   35 +----------------------------
>  drivers/net/wireless/wl12xx/Kconfig      |    2 +-

We need to CC Luciano for the wl12xx change.

> --- a/drivers/net/wireless/wl12xx/Kconfig
> +++ b/drivers/net/wireless/wl12xx/Kconfig
> @@ -42,5 +42,5 @@ config WL1271_SDIO
>  
>  config WL12XX_PLATFORM_DATA
>  	bool
> -	depends on WL1271_SDIO != n
> +	depends on WL1271_SDIO != n || WL1251_SDIO != n
>  	default y

Oh, I didn't take this into account when I moved wl1251 out from the
wl12xx directory. Now wl1251 has a dependency to wl12xx stuff. 

Oh well, it's a small issue. I guess we can live with that :)

-- 
Kalle Valo
