Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:8563 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756629AbZHZDqi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2009 23:46:38 -0400
Received: by qw-out-2122.google.com with SMTP id 8so1855859qwh.37
        for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2009 20:46:39 -0700 (PDT)
Message-ID: <4A94B01E.9040309@gmail.com>
Date: Tue, 25 Aug 2009 23:46:38 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: John W Linville <linville@tuxdriver.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8187: Fix for kernel oops when unloading with LEDs
 enabled
References: <4a5cf0b4.F1C7R/E9sD5tpPd2%Larry.Finger@lwfinger.net>
In-Reply-To: <4a5cf0b4.F1C7R/E9sD5tpPd2%Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> When rtl8187 is unloaded and CONFIG_RTL8187_LEDS is set, the kernel
> may oops when the module is unloaded as the workqueue for led_on was
> not being cancelled.
>
> This patch fixes the problem reported in
> http://marc.info/?l=linux-wireless&m=124742957615781&w=2.
>
> Reported-by: Gábor Stefanik <netrolller.3d@gmail.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger>
> ---
>
> V2 - Do not create a new workqueue.
>
> John,
>
> This patch is 2.6.31 material. To the best of my knowledge, a formal bug
> report was never filed; however, it was reported in the reference given above.
>
>   
Anyone know what happened here? This bug still seems very much alive in 
compat-wireless-2.6.31-rc7.  I know the window is closed and this really
isn't "earthshattering" but a kernel panick is kind of "a big deal".  I 
seems like it was tested doing a proper modprobe -r but not if you just 
unplug the usb card.
When I unplug the usb I get instadeath, very uncool.  If someone can 
teach me how to get the kernel output from a non-functional system I am 
happy to provide whatever.

thanks,
Rick Farina
> Larry
> ---
>
> Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_leds.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_leds.c
> +++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_leds.c
> @@ -208,11 +208,12 @@ void rtl8187_leds_exit(struct ieee80211_
>  {
>  	struct rtl8187_priv *priv = dev->priv;
>  
> -	rtl8187_unregister_led(&priv->led_tx);
>  	/* turn the LED off before exiting */
>  	queue_delayed_work(dev->workqueue, &priv->led_off, 0);
>  	cancel_delayed_work_sync(&priv->led_off);
> +	cancel_delayed_work_sync(&priv->led_on);
>  	rtl8187_unregister_led(&priv->led_rx);
> +	rtl8187_unregister_led(&priv->led_tx);
>  }
>  #endif /* def CONFIG_RTL8187_LED */
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   

