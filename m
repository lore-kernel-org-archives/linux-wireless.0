Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.221.174]:47784 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbZKDFuR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 00:50:17 -0500
Received: by qyk4 with SMTP id 4so3263650qyk.33
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2009 21:50:22 -0800 (PST)
Message-ID: <4AF1161D.8070708@gmail.com>
Date: Wed, 04 Nov 2009 00:50:21 -0500
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: wireless <linux-wireless@vger.kernel.org>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	John Linville <linville@tuxdriver.com>
Subject: Re: Possible fix for rtl8187: kernel oops when leds enabled
References: <4AE5BD6C.2050303@gmail.com> <4AE5C55B.5070309@lwfinger.net> <4AE5CDCB.8090400@gmail.com> <4AF0BB45.5000402@lwfinger.net>
In-Reply-To: <4AF0BB45.5000402@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> Rick,
>
> Does this patch fix your problem? I tried to bisect this problem as it
> looked like a regression; however, the problem was sometimes a little
> flakey. On one boot of a given kernel, it might run for 3-400 cycles
> without failing, then fail immediately after rebooting. I suspect that
> the random contents of some memory location would control that.
>
>   

Larry,
As you mentioned, this bug was not 100% reliable to reproduce in the 
first place for either of us, I merely had a much much higher chance of 
panick for some unknown reason.  That said, I have plugged and unplugged 
the device a few dozen times while bringing the interface up and down 
and making the led blink and I'm thrilled to say it no longer kernel 
panicks on my system.  I'm left with a usable wifi card with a cool 
flashing led, many thanks for fixing this.

John,

imho this patch should go upstream asap, next dot release if at all 
possible.  This fixes a significant issue in that the kernel panicked on 
my system nearly 100% of the time on unplug if the led was enabled.  
Either way it is up to the maintainers but consider this my vote of 
confidence.

Acked-By: Rick Farina
Tested-By: Rick Farina

Thanks,
Rick Farina

> This patch was inspired by the code in p54usb, which does not have the
> problem.
>
>
> Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_leds.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_leds.c
> +++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_leds.c
> @@ -210,10 +210,10 @@ void rtl8187_leds_exit(struct ieee80211_
>
>  	/* turn the LED off before exiting */
>  	ieee80211_queue_delayed_work(dev, &priv->led_off, 0);
> -	cancel_delayed_work_sync(&priv->led_off);
> -	cancel_delayed_work_sync(&priv->led_on);
>  	rtl8187_unregister_led(&priv->led_rx);
>  	rtl8187_unregister_led(&priv->led_tx);
> +	cancel_delayed_work_sync(&priv->led_off);
> +	cancel_delayed_work_sync(&priv->led_on);
>  }
>  #endif /* def CONFIG_RTL8187_LED */
>
> Thanks for testing,
>
> Larry
>
>
>
>
>
>
>
>   

