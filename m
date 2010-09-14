Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48890 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab0INU3r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 16:29:47 -0400
Date: Tue, 14 Sep 2010 16:30:01 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@nokia.com>
Subject: Re: [PATCH] wl1271: sdio: claim host only when doing IO
Message-ID: <20100914203000.GF2484@tuxdriver.com>
References: <1283822661-16018-1-git-send-email-ohad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1283822661-16018-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 07, 2010 at 04:24:21AM +0300, Ohad Ben-Cohen wrote:
> Do not maintain a persistent sdio_claim_host state. Instead,
> claim host before doing IO and release host soon after.
> 
> This fixes several mmc deadlock scenarios, e.g. during
> suspend/resume.
> 
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>

<snip>

> @@ -160,13 +189,11 @@ static void wl1271_sdio_set_power(struct wl1271 *wl, bool enable)
>  	 * keep host claimed while wlan is in use to keep wl1271
>  	 * alive.
>  	 */
> -	if (enable) {
> -		sdio_claim_host(func);
> -		sdio_enable_func(func);
> -	} else {
> -		sdio_disable_func(func);
> -		sdio_release_host(func);
> -	}
> +	if (enable)
> +		return wl1271_sdio_power_on(wl);
> +	else
> +		return wl1271_sdio_power_off(wl);
> +
>  }

Please don't add new warnings...

drivers/net/wireless/wl12xx/wl1271_sdio.c: In function ‘wl1271_sdio_set_power’:
drivers/net/wireless/wl12xx/wl1271_sdio.c:193: warning: ‘return’ with a value, in function returning void
drivers/net/wireless/wl12xx/wl1271_sdio.c:195: warning: ‘return’ with a value, in function returning void
drivers/net/wireless/wl12xx/wl1271_sdio.c:186: warning: unused variable ‘func’

I'll fix these in a separate patch.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
