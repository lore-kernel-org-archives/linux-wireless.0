Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:58562 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab2KXWha (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2012 17:37:30 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so5002804lag.19
        for <linux-wireless@vger.kernel.org>; Sat, 24 Nov 2012 14:37:28 -0800 (PST)
Message-ID: <50B14BD6.8050302@mvista.com> (sfid-20121124_233734_370533_7F900D50)
Date: Sun, 25 Nov 2012 02:36:06 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	wim@iguana.be, linux-watchdog@vger.kernel.org,
	castet.matthieu@free.fr, biblbroks@sezampro.rs, m@bues.ch,
	zajec5@gmail.com, linux-mips@linux-mips.org
Subject: Re: [PATCH 04/15] watchdog: bcm47xx_wdt.c: rename wdt_timeout to
 timeout
References: <1353795855-22236-1-git-send-email-hauke@hauke-m.de> <1353795855-22236-5-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1353795855-22236-5-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.

On 25-11-2012 2:24, Hauke Mehrtens wrote:

> Rename rename

    Once it enough. :-)

> wdt_timeout

    'wdt_time', you mean?

> to timeout to name it like the other watchdog
> driver do it.

    It's not the only change you're doing.

> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>   drivers/watchdog/bcm47xx_wdt.c |   14 +++++++-------
>   1 file changed, 7 insertions(+), 7 deletions(-)

> diff --git a/drivers/watchdog/bcm47xx_wdt.c b/drivers/watchdog/bcm47xx_wdt.c
> index 66f2d2b..b6a8c49 100644
> --- a/drivers/watchdog/bcm47xx_wdt.c
> +++ b/drivers/watchdog/bcm47xx_wdt.c
> @@ -30,13 +30,13 @@
>   #define DRV_NAME		"bcm47xx_wdt"
>
>   #define WDT_DEFAULT_TIME	30	/* seconds */
> -#define WDT_MAX_TIME		255	/* seconds */
> +#define WDT_SOFTTIMER_MAX	3600	/* seconds */
>
> -static int wdt_time = WDT_DEFAULT_TIME;
> +static int timeout = WDT_DEFAULT_TIME;
>   static bool nowayout = WATCHDOG_NOWAYOUT;
>
> -module_param(wdt_time, int, 0);
> -MODULE_PARM_DESC(wdt_time, "Watchdog time in seconds. (default="
> +module_param(timeout, int, 0);
> +MODULE_PARM_DESC(timeout, "Watchdog time in seconds. (default="
>   				__MODULE_STRING(WDT_DEFAULT_TIME) ")");
>
>   module_param(nowayout, bool, 0);
> @@ -94,9 +94,9 @@ static int bcm47xx_wdt_soft_stop(struct watchdog_device *wdd)
>   static int bcm47xx_wdt_soft_set_timeout(struct watchdog_device *wdd,
>   					unsigned int new_time)
>   {
> -	if (new_time < 1 || new_time > WDT_MAX_TIME) {
> +	if (new_time < 1 || new_time > WDT_SOFTTIMER_MAX) {
>   		pr_warn("timeout value must be 1<=x<=%d, using %d\n",
> -			WDT_MAX_TIME, new_time);
> +			WDT_SOFTTIMER_MAX, new_time);
>   		return -EINVAL;
>   	}
>

WBR, Sergei


