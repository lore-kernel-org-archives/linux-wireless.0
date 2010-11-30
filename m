Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:49378 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753758Ab0K3Pbb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 10:31:31 -0500
Subject: Re: [PATCH 2/2 v4] mac80211: add throughput based LED blink trigger
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1291103925.3624.1.camel@jlt3.sipsolutions.net>
References: <1290884614.3700.3.camel@jlt3.sipsolutions.net>
	 <1290885648.3700.4.camel@jlt3.sipsolutions.net>
	 <1290947171.3467.7.camel@jlt3.sipsolutions.net>
	 <1291103925.3624.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain
Date: Tue, 30 Nov 2010 07:30:13 -0800
Message-Id: <1291131013.13968.1.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Mon, 2010-11-29 at 23:58 -0800, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> iwlwifi and other drivers like to blink their LED
> based on throughput. Implement this generically in
> mac80211, based on a throughput table the driver
> specifies. That way, drivers can set the blink
> frequencies depending on their desired behaviour
> and max throughput.
> 
> All the drivers need to do is provide an LED class
> device, best with blink hardware offload.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> v2: turn off LED when turning off radio
> v3: - use only data frames
>     - fix update frequency to 1 second
>     - use DIV_ROUND_UP
> v4: - allow using -1 for always blinking
>     - run timer function once when enabling
> 
>  include/net/mac80211.h     |   38 ++++++++++++++
>  net/mac80211/ieee80211_i.h |   13 ++++
>  net/mac80211/iface.c       |    1
>  net/mac80211/led.c         |  121 +++++++++++++++++++++++++++++++++++++++++++++
>  net/mac80211/led.h         |   44 +++++++++++++---
>  net/mac80211/rx.c          |    3 +
>  net/mac80211/tx.c          |    3 +
>  net/mac80211/util.c        |    2
>  8 files changed, 216 insertions(+), 9 deletions(-)
> 
> --- wireless-testing.orig/include/net/mac80211.h        2010-11-29 11:05:32.000000000 +0100
> +++ wireless-testing/include/net/mac80211.h     2010-11-30 08:57:13.000000000 +0100
> @@ -1852,11 +1852,26 @@ struct ieee80211_hw *ieee80211_alloc_hw(
>   */
>  int ieee80211_register_hw(struct ieee80211_hw *hw);
> 
> +/**
> + * struct ieee80211_tpt_blink - throughput blink description
> + * @throughput: throughput in Kbit/sec
> + * @blink_time: blink time in milliseconds
> + *     (full cycle, ie. one off + one on period)
> + */
> +struct ieee80211_tpt_blink {
> +       int throughput;
> +       int blink_time;
> +};
> +
>  #ifdef CONFIG_MAC80211_LEDS
>  extern char *__ieee80211_get_tx_led_name(struct ieee80211_hw *hw);
>  extern char *__ieee80211_get_rx_led_name(struct ieee80211_hw *hw);
>  extern char *__ieee80211_get_assoc_led_name(struct ieee80211_hw *hw);
>  extern char *__ieee80211_get_radio_led_name(struct ieee80211_hw *hw);
> +extern char *__ieee80211_create_tpt_led_trigger(
> +                               struct ieee80211_hw *hw,
> +                               const struct ieee80211_tpt_blink *blink_table,
> +                               unsigned int blink_table_len);
>  #endif
>  /**
>   * ieee80211_get_tx_led_name - get name of TX LED
> @@ -1932,6 +1947,29 @@ static inline char *ieee80211_get_radio_
>  #else
>         return NULL;
>  #endif
> +}
> +
> +/**
> + * ieee80211_create_tpt_led_trigger - create throughput LED trigger
> + * @hw: the hardware to create the trigger for
> + * @blink_table: the blink table -- needs to be ordered by throughput
> + * @blink_table_len: size of the blink table
> + *
> + * This function returns %NULL (in case of error, or if no LED
> + * triggers are configured) or the name of the new trigger.
> + * This function must be called before ieee80211_register_hw().
> + */
> +static inline char *
> +ieee80211_create_tpt_led_trigger(struct ieee80211_hw *hw,
> +                                const struct ieee80211_tpt_blink *blink_table,
> +                                unsigned int blink_table_len)
> +{
> +#ifdef CONFIG_MAC80211_LEDS
> +       return __ieee80211_create_tpt_led_trigger(hw, blink_table,
> +                                                 blink_table_len);
> +#else
> +       return NULL;
> +#endif
>  }
> 
>  /**
> --- wireless-testing.orig/net/mac80211/ieee80211_i.h    2010-11-29 11:05:32.000000000 +0100
> +++ wireless-testing/net/mac80211/ieee80211_i.h 2010-11-30 08:57:13.000000000 +0100
> @@ -23,6 +23,7 @@
>  #include <linux/types.h>
>  #include <linux/spinlock.h>
>  #include <linux/etherdevice.h>
> +#include <linux/leds.h>
>  #include <net/ieee80211_radiotap.h>
>  #include <net/cfg80211.h>
>  #include <net/mac80211.h>
> @@ -641,6 +642,17 @@ enum queue_stop_reason {
>         IEEE80211_QUEUE_STOP_REASON_SKB_ADD,
>  };
> 
> +struct tpt_led_trigger {
> +       struct led_trigger trig;
> +       char name[32];
> +       const struct ieee80211_tpt_blink *blink_table;
> +       unsigned int blink_table_len;
> +       struct timer_list timer;
> +       bool running;
> +       unsigned long prev_traffic;
> +       unsigned long tx_bytes, rx_bytes;
> +};
> +
>  /**
>   * mac80211 scan flags - currently active scan mode
>   *
> @@ -849,6 +861,7 @@ struct ieee80211_local {
>  #ifdef CONFIG_MAC80211_LEDS
>         int tx_led_counter, rx_led_counter;
>         struct led_trigger *tx_led, *rx_led, *assoc_led, *radio_led;
> +       struct tpt_led_trigger *tpt_led_trigger;
>         char tx_led_name[32], rx_led_name[32],
>              assoc_led_name[32], radio_led_name[32];
>  #endif
> --- wireless-testing.orig/net/mac80211/led.c    2010-11-29 11:05:32.000000000 +0100
> +++ wireless-testing/net/mac80211/led.c 2010-11-30 08:57:13.000000000 +0100
> @@ -103,6 +103,13 @@ void ieee80211_led_init(struct ieee80211
>                         local->radio_led = NULL;
>                 }
>         }
> +
> +       if (local->tpt_led_trigger) {
> +               if (led_trigger_register(&local->tpt_led_trigger->trig)) {
> +                       kfree(local->tpt_led_trigger);
> +                       local->tpt_led_trigger = NULL;
> +               }
> +       }
>  }
> 
>  void ieee80211_led_exit(struct ieee80211_local *local)
> @@ -123,6 +130,11 @@ void ieee80211_led_exit(struct ieee80211
>                 led_trigger_unregister(local->rx_led);
>                 kfree(local->rx_led);
>         }
> +
> +       if (local->tpt_led_trigger) {
> +               led_trigger_unregister(&local->tpt_led_trigger->trig);
> +               kfree(local->tpt_led_trigger);
> +       }
>  }
> 
>  char *__ieee80211_get_radio_led_name(struct ieee80211_hw *hw)
> @@ -156,3 +168,112 @@ char *__ieee80211_get_rx_led_name(struct
>         return local->rx_led_name;
>  }
>  EXPORT_SYMBOL(__ieee80211_get_rx_led_name);
> +
> +static unsigned long tpt_trig_traffic(struct ieee80211_local *local,
> +                                     struct tpt_led_trigger *tpt_trig)
> +{
> +       unsigned long traffic, delta;
> +
> +       traffic = tpt_trig->tx_bytes + tpt_trig->rx_bytes;
> +
> +       delta = traffic - tpt_trig->prev_traffic;
> +       tpt_trig->prev_traffic = traffic;
> +       return DIV_ROUND_UP(delta, 1024 / 8);
> +}
> +
> +static void tpt_trig_timer(unsigned long data)
> +{
> +       struct ieee80211_local *local = (void *)data;
> +       struct tpt_led_trigger *tpt_trig = local->tpt_led_trigger;
> +       struct led_classdev *led_cdev;
> +       unsigned long on, off, tpt;
> +       int i;
> +
> +       if (!tpt_trig->running)
> +               return;
> +
> +       mod_timer(&tpt_trig->timer, round_jiffies(jiffies + HZ));
> +
> +       tpt = tpt_trig_traffic(local, tpt_trig);
> +
> +       /* default to just solid on */
> +       on = 1;
> +       off = 0;
> +
> +       for (i = tpt_trig->blink_table_len - 1; i >= 0; i--) {
> +               if (tpt_trig->blink_table[i].throughput < 0 ||
> +                   tpt > tpt_trig->blink_table[i].throughput) {
> +                       off = tpt_trig->blink_table[i].blink_time / 2;
> +                       on = tpt_trig->blink_table[i].blink_time - off;
> +                       break;
> +               }
> +       }

I know it is the case for iwlwifi today, but is true "on time" == "off
time"?

Wey



