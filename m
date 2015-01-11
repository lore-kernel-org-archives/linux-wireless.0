Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:63110 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbbAKJkX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jan 2015 04:40:23 -0500
Message-ID: <54B24504.60105@broadcom.com> (sfid-20150111_104032_964955_5D483223)
Date: Sun, 11 Jan 2015 10:40:20 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Hong Xu <hong@topbug.net>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k_htc: Add a module parameter to disable blink
References: <1420968029-1222-1-git-send-email-hong@topbug.net>
In-Reply-To: <1420968029-1222-1-git-send-email-hong@topbug.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/11/15 10:20, Hong Xu wrote:
> Add an option "blink" to enable or disable the LED blink. The default
> value is set to 1 so that existing users would not experience any
> unexpected changes.
> ---
>   drivers/net/wireless/ath/ath9k/htc.h          | 1 +
>   drivers/net/wireless/ath/ath9k/htc_drv_gpio.c | 4 ++++
>   drivers/net/wireless/ath/ath9k/htc_drv_init.c | 4 ++++
>   3 files changed, 9 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
> index 9dde265..5697097 100644
> --- a/drivers/net/wireless/ath/ath9k/htc.h
> +++ b/drivers/net/wireless/ath/ath9k/htc.h
> @@ -44,6 +44,7 @@
>
>   extern struct ieee80211_ops ath9k_htc_ops;
>   extern int htc_modparam_nohwcrypt;
> +extern int led_blink;
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
>   	ath9k_configure_leds(priv);
>
>   	snprintf(priv->led_name, sizeof(priv->led_name),
> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
> index e8fa944..c762d84 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
> @@ -38,6 +38,10 @@ static int ath9k_ps_enable;
>   module_param_named(ps_enable, ath9k_ps_enable, int, 0444);
>   MODULE_PARM_DESC(ps_enable, "Enable WLAN PowerSave");
>
> +int led_blink = 1;
> +module_param_named(blink, led_blink, int, 0444);
> +MODULE_PARM_DESC(blink, "Enable LED blink on activity");
> +

Seems like this module parameter is only applicable if 
CONFIG_MAC80211_LEDS is set.

Regards,
Arend

>   #ifdef CONFIG_MAC80211_LEDS
>   static const struct ieee80211_tpt_blink ath9k_htc_tpt_blink[] = {
>   	{ .throughput = 0 * 1024, .blink_time = 334 },

