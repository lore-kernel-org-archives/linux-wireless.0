Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.211.196]:59242 "EHLO
	mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966598AbZLHWHS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 17:07:18 -0500
Received: by ywh34 with SMTP id 34so5760480ywh.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Dec 2009 14:07:24 -0800 (PST)
Message-ID: <4B1ECCCD.2010603@lwfinger.net>
Date: Tue, 08 Dec 2009 16:01:49 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
CC: htl10@users.sourceforge.net, Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: RTL8187 warnings on suspend
References: <665313.63774.qm@web23102.mail.ird.yahoo.com> <200911270945.31125.herton@mandriva.com.br> <4B10110E.8030402@lwfinger.net> <200912011149.49427.herton@mandriva.com.br>
In-Reply-To: <200912011149.49427.herton@mandriva.com.br>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/01/2009 07:49 AM, Herton Ronaldo Krzesinski wrote:
> Subject: [PATCH] rtl8187: add radio led and fix warnings on suspend
> 
> Michael Buesch reports that his rtl8187 gives warnings on suspend
> ("queueing ieee80211 work while going to suspend" warnings), as rtl8187
> can call ieee80211_queue_delayed_work after mac80211 is suspended.
> 
> This change enhances rtl8187 led code so we can avoid queuing work after
> mac80211 is suspended: now we register a radio led and make additional
> checks to ensure led is off/on properly as mac80211 wants.
> 
> Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
> ---
>  drivers/net/wireless/rtl818x/rtl8187.h      |    1 +
>  drivers/net/wireless/rtl818x/rtl8187_leds.c |   66 +++++++++++++++++---------
>  drivers/net/wireless/rtl818x/rtl8187_leds.h |    2 +
>  3 files changed, 46 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/net/wireless/rtl818x/rtl8187.h b/drivers/net/wireless/rtl818x/rtl8187.h
> index bf9175a..861ab0b 100644
> --- a/drivers/net/wireless/rtl818x/rtl8187.h
> +++ b/drivers/net/wireless/rtl818x/rtl8187.h
> @@ -104,6 +104,7 @@ struct rtl8187_priv {
>  	struct delayed_work work;
>  	struct ieee80211_hw *dev;
>  #ifdef CONFIG_RTL8187_LEDS
> +	struct rtl8187_led led_radio;
>  	struct rtl8187_led led_tx;
>  	struct rtl8187_led led_rx;
>  	struct delayed_work led_on;
> diff --git a/drivers/net/wireless/rtl818x/rtl8187_leds.c b/drivers/net/wireless/rtl818x/rtl8187_leds.c
> index cf8a4a4..84fdcdb 100644
> --- a/drivers/net/wireless/rtl818x/rtl8187_leds.c
> +++ b/drivers/net/wireless/rtl818x/rtl8187_leds.c
> @@ -106,18 +106,31 @@ static void rtl8187_led_brightness_set(struct led_classdev *led_dev,
>  					       led_dev);
>  	struct ieee80211_hw *hw = led->dev;
>  	struct rtl8187_priv *priv = hw->priv;
> -
> -	if (brightness == LED_OFF) {
> -		ieee80211_queue_delayed_work(hw, &priv->led_off, 0);
> -		/* The LED is off for 1/20 sec so that it just blinks. */
> -		ieee80211_queue_delayed_work(hw, &priv->led_on, HZ / 20);
> -	} else
> -		ieee80211_queue_delayed_work(hw, &priv->led_on, 0);
> +	static bool radio_on;
> +

	if (!hw)
		return;

> +	if (led->is_radio) {
> +		if (brightness == LED_FULL) {
> +			ieee80211_queue_delayed_work(hw, &priv->led_on, 0);

After adding the above change to stop processing for any LED that has
been deleted, the rmmod/insmod loop is running on my system. Still
testing, the the cycle count is nearing 200. After 4-500 cycles, I'll
try physically removing the device while active, and some of the
suspend to disk cycles as well.

Larry
