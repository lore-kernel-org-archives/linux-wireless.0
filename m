Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40737 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186Ab1DXIJA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Apr 2011 04:09:00 -0400
Subject: Re: [PATCH 2.6.39] iwlegacy: led stay solid on when no traffic
From: Johannes Berg <johannes@sipsolutions.net>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1303578538-19474-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1303578538-19474-1-git-send-email-wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 24 Apr 2011 10:08:53 +0200
Message-ID: <1303632533.3795.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-04-23 at 10:08 -0700, Wey-Yi Guy wrote:
> commit 843f26f06a41c5797f19e843c23ca4ed2a71a0bc change the led behavior
> for iwlwifi driver; the side effect cause led blink all the time.

Uh, no, it didn't change behaviour, that was intentional and was the way
it was before as well...

> Modify the led blink table to fix this problem

Fine with me.

> Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---
>  drivers/net/wireless/iwlegacy/iwl-led.c |   22 +++++++++++++++++++++-
>  1 files changed, 21 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlegacy/iwl-led.c b/drivers/net/wireless/iwlegacy/iwl-led.c
> index 15eb8b7..b226a3c 100644
> --- a/drivers/net/wireless/iwlegacy/iwl-led.c
> +++ b/drivers/net/wireless/iwlegacy/iwl-led.c
> @@ -48,8 +48,22 @@ module_param(led_mode, int, S_IRUGO);
>  MODULE_PARM_DESC(led_mode, "0=system default, "
>  		"1=On(RF On)/Off(RF Off), 2=blinking");
>  
> +/* Throughput		OFF time(ms)	ON time (ms)
> + *	>300			25		25
> + *	>200 to 300		40		40
> + *	>100 to 200		55		55
> + *	>70 to 100		65		65
> + *	>50 to 70		75		75
> + *	>20 to 50		85		85
> + *	>10 to 20		95		95
> + *	>5 to 10		110		110
> + *	>1 to 5			130		130
> + *	>0 to 1			167		167
> + *	<=0					SOLID ON
> + */
>  static const struct ieee80211_tpt_blink iwl_blink[] = {
> -	{ .throughput = 0 * 1024 - 1, .blink_time = 334 },
> +	{ .throughput = 0 * 1024 - 1, .blink_time = 0 },
> +	{ .throughput = 0 * 1024, .blink_time = 334 },

The -1, 0 is default, so you can leave that line out.

johannes

>  	{ .throughput = 1 * 1024 - 1, .blink_time = 260 },
>  	{ .throughput = 5 * 1024 - 1, .blink_time = 220 },
>  	{ .throughput = 10 * 1024 - 1, .blink_time = 190 },
> @@ -101,6 +115,12 @@ static int iwl_legacy_led_cmd(struct iwl_priv *priv,
>  	if (priv->blink_on == on && priv->blink_off == off)
>  		return 0;
>  
> +	if (on == 0) {
> +		/* led is SOLID_ON */
> +		on = IWL_LED_SOLID;
> +		off = 0;
> +	}

Why would you want to do that?

johannes

