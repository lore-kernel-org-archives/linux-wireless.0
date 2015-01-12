Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:8821 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbbALJs7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2015 04:48:59 -0500
Message-ID: <54B39888.2080701@broadcom.com> (sfid-20150112_104902_619696_72FBE370)
Date: Mon, 12 Jan 2015 10:48:56 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Hong Xu <hong@topbug.net>
CC: <linux-wireless@vger.kernel.org>, <linux@rempel-privat.de>
Subject: Re: [PATCH v2] ath9k_htc: Add a module parameter to disable blink
References: <1421005553-19447-1-git-send-email-hong@topbug.net>
In-Reply-To: <1421005553-19447-1-git-send-email-hong@topbug.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/11/15 20:45, Hong Xu wrote:
> Add an option "blink" to enable or disable the LED blink. The default
> value is set to 1 so that existing users would not experience any
> unexpected changes.
>
> Signed-off-by: Hong Xu<hong@topbug.net>
> ---
>   drivers/net/wireless/ath/ath9k/htc.h          | 3 +++
>   drivers/net/wireless/ath/ath9k/htc_drv_gpio.c | 4 ++++
>   drivers/net/wireless/ath/ath9k/htc_drv_init.c | 4 ++++
>   3 files changed, 11 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
> index 9dde265..c43fec5 100644
> --- a/drivers/net/wireless/ath/ath9k/htc.h
> +++ b/drivers/net/wireless/ath/ath9k/htc.h
> @@ -44,6 +44,9 @@
>
>   extern struct ieee80211_ops ath9k_htc_ops;
>   extern int htc_modparam_nohwcrypt;
> +#ifdef CONFIG_MAC80211_LEDS
> +extern int led_blink;
> +#endif
>
>   enum htc_phymode {
>   	HTC_MODE_11NA		= 0,
> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
> index 50f74a2..998b558 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
> @@ -279,6 +279,10 @@ void ath9k_init_leds(struct ath9k_htc_priv *priv)
>   	else
>   		priv->ah->led_pin = ATH_LED_PIN_DEF;
>
> +	if (!led_blink)
> +		priv->led_cdev.default_trigger =
> +			ieee80211_get_radio_led_name(priv->hw);
> +

So is this function/file also conditionally compiled on 
CONFIG_MAC80211_LEDS. In my tree it is not so you will get a warning and 
loading the module will probably fail.

Regards,
Arend

>   	ath9k_configure_leds(priv);
>
>   	snprintf(priv->led_name, sizeof(priv->led_name),
> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
> index e8fa944..9470127 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
> @@ -39,6 +39,10 @@ module_param_named(ps_enable, ath9k_ps_enable, int, 0444);
>   MODULE_PARM_DESC(ps_enable, "Enable WLAN PowerSave");
>
>   #ifdef CONFIG_MAC80211_LEDS
> +int led_blink = 1;
> +module_param_named(blink, led_blink, int, 0444);
> +MODULE_PARM_DESC(blink, "Enable LED blink on activity");
> +
>   static const struct ieee80211_tpt_blink ath9k_htc_tpt_blink[] = {
>   	{ .throughput = 0 * 1024, .blink_time = 334 },
>   	{ .throughput = 1 * 1024, .blink_time = 260 },

