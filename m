Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost06.isp.att.net ([204.127.217.106]:33060 "EHLO
	fmailhost06.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbZDBVZo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2009 17:25:44 -0400
Message-ID: <49D52D27.4010607@lwfinger.net> (sfid-20090402_232548_841184_57A17228)
Date: Thu, 02 Apr 2009 16:24:55 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: How does rfkill work?
References: <49D44635.80306@lwfinger.net>	 <1238666206.4141.12.camel@johannes.local>  <49D4CF50.2060100@lwfinger.net>	 <1238684527.4141.63.camel@johannes.local>  <49D4D833.9070107@lwfinger.net>	 <1238689637.24708.41.camel@johannes.local> <49D5018E.6050001@lwfinger.net>	 <1238696967.6137.5.camel@johannes.local> <49D506FE.5070405@lwfinger.net>	 <1238698084.7630.3.camel@johannes.local>	 (sfid-20090402_204842_882765_82560824) <1238698667.7630.7.camel@johannes.local>	 <49D521BF.2080301@lwfinger.net> <1238705420.8363.14.camel@johannes.local>
In-Reply-To: <1238705420.8363.14.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:

> Ah, yes. Using a shorter name is probably a good idea then. I don't
> think changing that define makes too much sense.
> 
> On my test with iwlwifi the rfkill LED trigger is definitely called -- I
> cannot pinpoint why it shouldn't be on your setup. :(
> 
> Actually. Are you positive it works without my patch? The confusing this
> is that this code never seems to call led_trigger_event() outside of
> rfkill_led_trigger_activate() which is only called once... Can you try
> this patch please?

No, it hasn't worked for some time, but until you rationalized the rfkill code,
I didn't want to mess with it. :)

>  net/rfkill/core.c |   22 +++++++++++++++++++---
>  1 file changed, 19 insertions(+), 3 deletions(-)
> 
> --- wireless-testing.orig/net/rfkill/core.c	2009-04-02 22:47:05.000000000 +0200
> +++ wireless-testing/net/rfkill/core.c	2009-04-02 22:49:53.000000000 +0200
> @@ -83,12 +83,10 @@ static bool rfkill_epo_lock_active;
>  
>  
>  #ifdef CONFIG_RFKILL_LEDS
> -static void rfkill_led_trigger_activate(struct led_classdev *led)
> +static void rfkill_led_trigger_event(struct rfkill *rfkill)
>  {
> -	struct rfkill *rfkill;
>  	struct led_trigger *trigger;
>  
> -	rfkill = container_of(led->trigger, struct rfkill, led_trigger);
>  	trigger = &rfkill->led_trigger;
>  
>  	if (rfkill->blocked)
> @@ -97,6 +95,15 @@ static void rfkill_led_trigger_activate(
>  		led_trigger_event(trigger, LED_FULL);
>  }
>  
> +static void rfkill_led_trigger_activate(struct led_classdev *led)
> +{
> +	struct rfkill *rfkill;
> +
> +	rfkill = container_of(led->trigger, struct rfkill, led_trigger);
> +
> +	rfkill_led_trigger_event(rfkill);
> +}
> +
>  const char *rfkill_get_led_trigger_name(struct rfkill *rfkill)
>  {
>  	return rfkill->led_trigger.name;
> @@ -124,6 +131,10 @@ static void rfkill_led_trigger_unregiste
>  	led_trigger_unregister(&rfkill->led_trigger);
>  }
>  #else
> +static void rfkill_led_trigger_event(struct rfkill *rfkill)
> +{
> +}
> +
>  static inline int rfkill_led_trigger_register(struct rfkill *rfkill)
>  {
>  	return 0;
> @@ -158,6 +169,8 @@ static bool __rfkill_set_hw_state(struct
>  
>  	*change = prev != blocked;
>  
> +	rfkill_led_trigger_event(rfkill);
> +
>  	return blocked || !!test_bit(RFKILL_BLOCK_SW_BIT, &rfkill->blocked);
>  }
>  
> @@ -214,6 +227,7 @@ static void rfkill_set_block(struct rfki
>  			clear_bit(RFKILL_BLOCK_SW_BIT, &rfkill->blocked);
>  	}
>  
> +	rfkill_led_trigger_event(rfkill);
>  	rfkill_uevent(rfkill);
>  }
>  
> @@ -400,6 +414,8 @@ bool rfkill_set_sw_state(struct rfkill *
>  	if (prev != blocked && !hwblock)
>  		schedule_work(&rfkill->uevent_work);
>  
> +	rfkill_led_trigger_event(rfkill);
> +
>  	return blocked || hwblock;
>  }
>  EXPORT_SYMBOL(rfkill_set_sw_state);

This patch does the trick. Not only is the set brightness callback routine being
called, but the LED is going on/off as expected. It even ends up in the off
state when the module is loaded with the switch off. It toggles on/off in that
case, but I'm not going to complain as long as it ends up off. That part broke
first, then everything broke later..

Thanks for the help.


Larry
