Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:35864
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756534AbXK2TAt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2007 14:00:49 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] b43: Fix radio LED problem
Date: Thu, 29 Nov 2007 19:58:45 +0100
Cc: John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <474dfe58.85Rcj/BwOPxQm8eE%Larry.Finger@lwfinger.net>
In-Reply-To: <474dfe58.85Rcj/BwOPxQm8eE%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711291958.45631.mb@bu3sch.de> (sfid-20071129_190053_541430_02CB71A3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 29 November 2007 00:48:40 Larry Finger wrote:

> Index: wireless-2.6/drivers/net/wireless/b43/rfkill.c
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/b43/rfkill.c
> +++ wireless-2.6/drivers/net/wireless/b43/rfkill.c
> @@ -60,8 +60,12 @@ static void b43_rfkill_poll(struct input
>  	}
>  	mutex_unlock(&wl->mutex);
>  
> -	if (unlikely(report_change))
> -		input_report_key(poll_dev->input, KEY_WLAN, enabled);
> +	/* send the radio switch event to the system - note both a key press
> +	 * and a release are required */

Ok, nice. Didn't know that.

> +	if (unlikely(report_change)) {
> +		input_report_key(poll_dev->input, KEY_WLAN, 1);
> +		input_report_key(poll_dev->input, KEY_WLAN, 0);
> +	}
>  }
>  
>  /* Called when the RFKILL toggled in software. */
> @@ -133,6 +137,12 @@ void b43_rfkill_init(struct b43_wldev *d
>  	rfk->poll_dev->poll = b43_rfkill_poll;
>  	rfk->poll_dev->poll_interval = 1000; /* msecs */
>  
> +	rfk->poll_dev->input->name = rfk->name;
> +	rfk->poll_dev->input->id.bustype = BUS_HOST;
> +	rfk->poll_dev->input->id.vendor = dev->dev->bus->boardinfo.vendor;
> +	rfk->poll_dev->input->evbit[0] = BIT(EV_KEY);
> +	set_bit(KEY_WLAN, rfk->poll_dev->input->keybit);
> +
>  	err = rfkill_register(rfk->rfkill);
>  	if (err)
>  		goto err_free_polldev;
> Index: wireless-2.6/drivers/net/wireless/b43/main.c
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/b43/main.c
> +++ wireless-2.6/drivers/net/wireless/b43/main.c
> @@ -2156,7 +2156,6 @@ static void b43_mgmtframe_txantenna(stru
>  static void b43_chip_exit(struct b43_wldev *dev)
>  {
>  	b43_radio_turn_off(dev, 1);
> -	b43_leds_exit(dev);
>  	b43_gpio_cleanup(dev);
>  	/* firmware is released later */
>  }
> @@ -2184,11 +2183,10 @@ static int b43_chip_init(struct b43_wlde
>  	err = b43_gpio_init(dev);
>  	if (err)
>  		goto out;	/* firmware is released later */
> -	b43_leds_init(dev);
>  
>  	err = b43_upload_initvals(dev);
>  	if (err)
> -		goto err_leds_exit;
> +		goto err_gpio_clean;
>  	b43_radio_turn_on(dev);
>  
>  	b43_write16(dev, 0x03E6, 0x0000);
> @@ -2267,8 +2265,7 @@ out:
>  
>  err_radio_off:
>  	b43_radio_turn_off(dev, 1);
> -err_leds_exit:
> -	b43_leds_exit(dev);
> +err_gpio_clean:
>  	b43_gpio_cleanup(dev);
>  	return err;
>  }
> @@ -2703,7 +2700,8 @@ static int b43_antenna_from_ieee80211(u8
>  static int b43_op_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
>  {
>  	struct b43_wl *wl = hw_to_b43_wl(hw);
> -	struct b43_wldev *dev;
> +	struct b43_rfkill *rfk = &(wl->rfkill);
> +	struct b43_wldev *uninitialized_var(dev);
>  	struct b43_phy *phy;
>  	unsigned long flags;
>  	unsigned int new_phymode = 0xFFFF;
> @@ -2802,6 +2800,13 @@ static int b43_op_config(struct ieee8021
>        out_unlock_mutex:
>  	mutex_unlock(&wl->mutex);
>  
> +	/* if a LED is devoted to the radio and the switch is on, send
> +	 * KEY_WLAN press/release keystrokes */
> +	if (!err && dev->radio_hw_enable && &dev->led_radio) {
                                            ^^^^^^^^^^^^^^^
This condition is always true.

> +		input_report_key(rfk->poll_dev->input, KEY_WLAN, 1);
> +		input_report_key(rfk->poll_dev->input, KEY_WLAN, 0);
> +	}
> +

Anyway, sending a key event here seems pretty bogus. The comment
doesn't really say anything useful why this is needed.

>  	return err;
>  }
>  
> @@ -3284,9 +3289,7 @@ static void b43_wireless_core_exit(struc
>  		return;
>  	b43_set_status(dev, B43_STAT_UNINIT);
>  
> -	mutex_unlock(&dev->wl->mutex);
> -	b43_rfkill_exit(dev);
> -	mutex_lock(&dev->wl->mutex);
> +	b43_leds_exit(dev);
>  
>  	b43_rng_exit(dev->wl);
>  	b43_pio_free(dev);
> @@ -3409,8 +3412,8 @@ static int b43_wireless_core_init(struct
>  	memset(wl->mac_addr, 0, ETH_ALEN);
>  	b43_upload_card_macaddress(dev);
>  	b43_security_init(dev);
> -	b43_rfkill_init(dev);
>  	b43_rng_init(wl);
> +	b43_leds_init(dev);
>  
>  	b43_set_status(dev, B43_STAT_INITIALIZED);
>  
> @@ -3503,6 +3506,7 @@ static int b43_op_start(struct ieee80211
>  	int did_init = 0;
>  	int err = 0;
>  
> +	b43_rfkill_init(dev);

Init rfkill _after_ the device is up.

>  	mutex_lock(&wl->mutex);
>  
>  	if (b43_status(dev) < B43_STAT_INITIALIZED) {
> @@ -3537,6 +3541,7 @@ static void b43_op_stop(struct ieee80211
>  		b43_wireless_core_stop(dev);
>  	b43_wireless_core_exit(dev);
>  	mutex_unlock(&wl->mutex);
> +	b43_rfkill_exit(dev);

Exit rfkill before the device is going down.

>  }
>  
>  static int b43_op_set_retry_limit(struct ieee80211_hw *hw,
> Index: wireless-2.6/drivers/net/wireless/b43/leds.c
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/b43/leds.c
> +++ wireless-2.6/drivers/net/wireless/b43/leds.c
> @@ -232,4 +232,5 @@ void b43_leds_exit(struct b43_wldev *dev
>  	b43_unregister_led(&dev->led_tx);
>  	b43_unregister_led(&dev->led_rx);
>  	b43_unregister_led(&dev->led_assoc);
> +	b43_unregister_led(&dev->led_radio);
>  }
> 
> 



-- 
Greetings Michael.
