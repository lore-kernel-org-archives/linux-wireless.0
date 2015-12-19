Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35142 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbbLSAWR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2015 19:22:17 -0500
Date: Fri, 18 Dec 2015 16:22:12 -0800
From: Darren Hart <dvhart@infradead.org>
To: =?iso-8859-1?Q?Jo=E3o?= Paulo Rechi Vita <jprvita@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>
Cc: Corentin Chary <corentin.chary@gmail.com>,
	platform-driver-x86@vger.kernel.org,
	acpi4asus-user@lists.sourceforge.net,
	=?iso-8859-1?Q?Jo=E3o?= Paulo Rechi Vita
	<jprvita@endlessm.com>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 3/4] net/rfkill: Create "airplane mode" LED trigger
Message-ID: <20151219002212.GC7244@malice.jf.intel.com> (sfid-20151219_012254_473178_2B03D077)
References: <1450193442-7930-1-git-send-email-jprvita@endlessm.com>
 <1450193442-7930-4-git-send-email-jprvita@endlessm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1450193442-7930-4-git-send-email-jprvita@endlessm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 15, 2015 at 10:30:41AM -0500, João Paulo Rechi Vita wrote:
> For platform drivers to be able to correctly drive the "Airplane Mode"
> indicative LED there needs to be a RFKill LED trigger tied to the global
> state of RFKILL_TYPE_ALL (instead of to a specific RFKill) and that
> works in an inverted manner of regular RFKill LED triggers, that is, the
> LED is ON when the state is blocked, and OFF otherwise.
> 
> This commit implements such a trigger, which will be used by the
> asus-wrc x86 platform driver.

So this will need to go through Johannes and David per get_maintainer.pl before
we can use it in platform drivers.

+Johannes
+David
+wireless
+netdev

-- 
Darren Hart
Intel Open Source Technology Center

> 
> Signed-off-by: João Paulo Rechi Vita <jprvita@endlessm.com>
> ---
>  net/rfkill/core.c | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/net/rfkill/core.c b/net/rfkill/core.c
> index b41e9ea..3effc29 100644
> --- a/net/rfkill/core.c
> +++ b/net/rfkill/core.c
> @@ -124,6 +124,26 @@ static bool rfkill_epo_lock_active;
>  
>  
>  #ifdef CONFIG_RFKILL_LEDS
> +static void airplane_mode_led_trigger_activate(struct led_classdev *led);
> +
> +static struct led_trigger airplane_mode_led_trigger = {
> +	.name     = "rfkill-airplane-mode",
> +	.activate = airplane_mode_led_trigger_activate,
> +};
> +
> +static void airplane_mode_led_trigger_event(void)
> +{
> +	if (rfkill_global_states[RFKILL_TYPE_ALL].cur & RFKILL_BLOCK_ANY)
> +		led_trigger_event(&airplane_mode_led_trigger, LED_FULL);
> +	else
> +		led_trigger_event(&airplane_mode_led_trigger, LED_OFF);
> +}
> +
> +static void airplane_mode_led_trigger_activate(struct led_classdev *led)
> +{
> +	airplane_mode_led_trigger_event();
> +}
> +
>  static void rfkill_led_trigger_event(struct rfkill *rfkill)
>  {
>  	struct led_trigger *trigger;
> @@ -175,6 +195,10 @@ static void rfkill_led_trigger_unregister(struct rfkill *rfkill)
>  	led_trigger_unregister(&rfkill->led_trigger);
>  }
>  #else
> +static void airplane_mode_led_trigger_event(void)
> +{
> +}
> +
>  static void rfkill_led_trigger_event(struct rfkill *rfkill)
>  {
>  }
> @@ -346,6 +370,7 @@ static void __rfkill_switch_all(const enum rfkill_type type, bool blocked)
>  
>  		for (i = 0; i < NUM_RFKILL_TYPES; i++)
>  			rfkill_global_states[i].cur = blocked;
> +		airplane_mode_led_trigger_event();
>  	} else {
>  		rfkill_global_states[type].cur = blocked;
>  	}
> @@ -1177,6 +1202,7 @@ static ssize_t rfkill_fop_write(struct file *file, const char __user *buf,
>  			enum rfkill_type i;
>  			for (i = 0; i < NUM_RFKILL_TYPES; i++)
>  				rfkill_global_states[i].cur = ev.soft;
> +			airplane_mode_led_trigger_event();
>  		} else {
>  			rfkill_global_states[ev.type].cur = ev.soft;
>  		}
> @@ -1293,6 +1319,10 @@ static int __init rfkill_init(void)
>  	}
>  #endif
>  
> +#ifdef CONFIG_RFKILL_LEDS
> +	led_trigger_register(&airplane_mode_led_trigger);
> +#endif
> +
>   out:
>  	return error;
>  }
> -- 
> 2.5.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe platform-driver-x86" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
