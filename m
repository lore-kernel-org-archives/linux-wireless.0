Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.187]:5442 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbXI0Ukf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2007 16:40:35 -0400
Received: by fk-out-0910.google.com with SMTP id z23so2838145fkz
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2007 13:40:33 -0700 (PDT)
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] b43: RF-kill support
Date: Thu, 27 Sep 2007 22:54:44 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <200709272135.35686.mb@bu3sch.de>
In-Reply-To: <200709272135.35686.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200709272254.44608.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> @@ -2401,8 +2401,7 @@ static void b43_periodic_every1sec(struc
>  	radio_hw_enable = b43_is_hw_radio_enabled(dev);
>  	if (unlikely(dev->radio_hw_enable != radio_hw_enable)) {
>  		dev->radio_hw_enable = radio_hw_enable;
> -		b43info(dev->wl, "Radio hardware status changed to %s\n",
> -			radio_hw_enable ? "ENABLED" : "DISABLED");
> +		b43_rfkill_toggled(dev, radio_hw_enable);

Isn't it better to use the input_polldev for scheduled input device checking?

> +static void b43_notify_rfkill_press(struct work_struct *work)
> +{
> +	struct b43_rfkill *rfk = container_of(work, struct b43_rfkill,
> +					      notify_work);
> +	struct b43_wl *wl = container_of(rfk, struct b43_wl, rfkill);
> +	struct b43_wldev *dev;
> +	enum rfkill_state state;

Same here, input_polldev was created especially for hardware
devices that don't trigger interrupts when the button was pressed.

> +	mutex_lock(&wl->mutex);
> +	dev = wl->current_dev;
> +	if (b43_status(dev) < B43_STAT_INITIALIZED) {
> +		mutex_unlock(&wl->mutex);
> +		return;
> +	}
> +	if (dev->radio_hw_enable)
> +		state = RFKILL_STATE_ON;
> +	else
> +		state = RFKILL_STATE_OFF;
> +	b43info(wl, "Radio hardware status changed to %s\n",
> +		dev->radio_hw_enable ? "ENABLED" : "DISABLED");
> +	mutex_unlock(&wl->mutex);
> +
> +	if (rfk->rfkill) {
> +		/* Be careful. This calls back into the software toggle routines.
> +		 * So we must unlock before calling. */
> +		rfkill_switch_all(rfk->rfkill->type, state);
> +	}
> +}

This is incorrect. Instead of rfkill_switch_all the driver must send
a signal over the input device it has registered. This will assure
the event is send to userspace or handled by the kernel when
the user has chosen that option.

I have recently send a patch to the list which added documentation
for rfkill and drivers to the Documentation/ folder.

It basically came down to this:
	- driver allocated rfkill
	- driver allocates input device or input_polldev
	- driver registers rfkill & input device
	- When button is pressed, driver should send a signal to the input device
	using the input_report_key(input_dev, KEY_WLAN, 1) event

rt2x00 did it wrong for some time, but this has been fixed now, so you
could use that as a reference.

> +/* Called when the RFKILL toggled in hardware.
> + * This is called with the mutex locked. */
> +void b43_rfkill_toggled(struct b43_wldev *dev, bool on)
> +{
> +	struct b43_wl *wl = dev->wl;
> +
> +	B43_WARN_ON(b43_status(dev) < B43_STAT_INITIALIZED);
> +	/* Update the RF status asynchronously, as rfkill will
> +	 * call back into the software toggle handler.
> +	 * This would deadlock if done synchronously. */
> +	queue_work(wl->hw->workqueue, &wl->rfkill.notify_work);
> +}
> +
> +/* Called when the RFKILL toggled in software.
> + * This is called without locking. */
> +static int b43_rfkill_soft_toggle(void *data, enum rfkill_state state)
> +{
> +	struct b43_wldev *dev = data;
> +	struct b43_wl *wl = dev->wl;
> +	int err = 0;
> +
> +	mutex_lock(&wl->mutex);
> +	if (b43_status(dev) < B43_STAT_INITIALIZED)
> +		goto out_unlock;
> +
> +	switch (state) {
> +	case RFKILL_STATE_ON:
> +		if (!dev->radio_hw_enable) {
> +			/* No luck. We can't toggle the hardware RF-kill
> +			 * button from software. */
> +			err = -EBUSY;
> +			goto out_unlock;
> +		}
> +		if (!dev->phy.radio_on)
> +			b43_radio_turn_on(dev);
> +		break;
> +	case RFKILL_STATE_OFF:
> +		if (dev->phy.radio_on)
> +			b43_radio_turn_off(dev, 0);
> +		break;
> +	}
> +
> +out_unlock:
> +	mutex_unlock(&wl->mutex);
> +
> +	return err;
> +}
> +
> +char * b43_rfkill_led_name(struct b43_wldev *dev)
> +{
> +	struct b43_wl *wl = dev->wl;
> +
> +	if (!wl->rfkill.rfkill)
> +		return NULL;
> +	return rfkill_get_led_name(wl->rfkill.rfkill);
> +}
> +
> +void b43_rfkill_init(struct b43_wldev *dev)
> +{
> +	struct b43_wl *wl = dev->wl;
> +	struct b43_rfkill *rfk = &(wl->rfkill);
> +	int err;
> +
> +	snprintf(rfk->name, sizeof(rfk->name),
> +		 "b43-%s", wiphy_name(wl->hw->wiphy));
> +	rfk->rfkill = rfkill_allocate(dev->dev->dev, RFKILL_TYPE_WLAN);
> +	if (!rfk->rfkill)
> +		goto error;
> +	rfk->rfkill->name = rfk->name;
> +	rfk->rfkill->state = RFKILL_STATE_ON;
> +	rfk->rfkill->data = dev;
> +	rfk->rfkill->toggle_radio = b43_rfkill_soft_toggle;
> +	rfk->rfkill->user_claim_unsupported = 1;
> +
> +	INIT_WORK(&rfk->notify_work, b43_notify_rfkill_press);
> +
> +	err = rfkill_register(rfk->rfkill);
> +	if (err)
> +		goto error;
> +
> +	return;
> +error:
> +	b43warn(dev->wl, "Failed to initialize the RF-kill button\n");
> +	rfkill_free(rfk->rfkill);
> +	rfk->rfkill = NULL;
> +}
> +
> +void b43_rfkill_exit(struct b43_wldev *dev)
> +{
> +	struct b43_rfkill *rfk = &(dev->wl->rfkill);
> +
> +	if (!rfk->rfkill)
> +		return;
> +	cancel_work_sync(&rfk->notify_work);
> +	rfkill_unregister(rfk->rfkill);
> +	rfkill_free(rfk->rfkill);
> +	rfk->rfkill = NULL;
> +}
> Index: wireless-2.6/drivers/net/wireless/b43/rfkill.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ wireless-2.6/drivers/net/wireless/b43/rfkill.h	2007-09-27 20:56:53.000000000 +0200
> @@ -0,0 +1,49 @@
> +#ifndef B43_RFKILL_H_
> +#define B43_RFKILL_H_
> +
> +struct b43_wldev;
> +
> +
> +#ifdef CONFIG_B43_RFKILL
> +
> +#include <linux/rfkill.h>
> +
> +struct b43_rfkill {
> +	/* The RFKILL subsystem data structure */
> +	struct rfkill *rfkill;
> +	/* The unique name of this rfkill switch */
> +	char name[32];
> +	/* Workqueue for asynchronous notification. */
> +	struct work_struct notify_work;
> +};
> +
> +void b43_rfkill_init(struct b43_wldev *dev);
> +void b43_rfkill_exit(struct b43_wldev *dev);
> +void b43_rfkill_toggled(struct b43_wldev *dev, bool on);
> +char * b43_rfkill_led_name(struct b43_wldev *dev);
> +
> +
> +#else /* CONFIG_B43_RFKILL */
> +/* No RFKILL support. */
> +
> +struct b43_rfkill {
> +	/* empty */
> +};
> +
> +static inline void b43_rfkill_init(struct b43_wldev *dev)
> +{
> +}
> +static inline void b43_rfkill_exit(struct b43_wldev *dev)
> +{
> +}
> +static inline void b43_rfkill_toggled(struct b43_wldev *dev, bool on)
> +{
> +}
> +static inline char * b43_rfkill_led_name(struct b43_wldev *dev)
> +{
> +	return NULL;
> +}
> +
> +#endif /* CONFIG_B43_RFKILL */
> +
> +#endif /* B43_RFKILL_H_ */
> Index: wireless-2.6/drivers/net/wireless/b43/leds.c
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/b43/leds.c	2007-09-27 20:53:39.000000000 +0200
> +++ wireless-2.6/drivers/net/wireless/b43/leds.c	2007-09-27 20:56:53.000000000 +0200
> @@ -154,12 +154,16 @@ static void b43_map_led(struct b43_wldev
>  				 ieee80211_get_rx_led_name(hw),
>  				 led_index, activelow);
>  		break;
> -	/*FIXME: We need another trigger for the "radio-on" LEDs below.
> -	 *       Wiggle that somehow into the rfkill subsystem. */
>  	case B43_LED_RADIO_ALL:
>  	case B43_LED_RADIO_A:
>  	case B43_LED_RADIO_B:
>  	case B43_LED_MODE_BG:
> +		snprintf(name, sizeof(name),
> +			 "b43-%s:radio", wiphy_name(hw->wiphy));
> +		b43_register_led(dev, &dev->led_radio, name,
> +				 b43_rfkill_led_name(dev),
> +				 led_index, activelow);
> +		break;
>  	case B43_LED_WEIRD:
>  	case B43_LED_ASSOC:
>  		snprintf(name, sizeof(name),
> Index: wireless-2.6/drivers/net/wireless/b43/phy.c
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/b43/phy.c	2007-09-27 20:53:39.000000000 +0200
> +++ wireless-2.6/drivers/net/wireless/b43/phy.c	2007-09-27 20:56:53.000000000 +0200
> @@ -4349,10 +4349,13 @@ void b43_radio_turn_on(struct b43_wldev 
>  	phy->radio_on = 1;
>  }
>  
> -void b43_radio_turn_off(struct b43_wldev *dev)
> +void b43_radio_turn_off(struct b43_wldev *dev, bool force)
>  {
>  	struct b43_phy *phy = &dev->phy;
>  
> +	if (!phy->radio_on && !force)
> +		return;
> +
>  	if (phy->type == B43_PHYTYPE_A) {
>  		b43_radio_write16(dev, 0x0004, 0x00FF);
>  		b43_radio_write16(dev, 0x0005, 0x00FB);
> @@ -4364,9 +4367,11 @@ void b43_radio_turn_off(struct b43_wldev
>  
>  		rfover = b43_phy_read(dev, B43_PHY_RFOVER);
>  		rfoverval = b43_phy_read(dev, B43_PHY_RFOVERVAL);
> -		phy->radio_off_context.rfover = rfover;
> -		phy->radio_off_context.rfoverval = rfoverval;
> -		phy->radio_off_context.valid = 1;
> +		if (!force) {
> +			phy->radio_off_context.rfover = rfover;
> +			phy->radio_off_context.rfoverval = rfoverval;
> +			phy->radio_off_context.valid = 1;
> +		}
>  		b43_phy_write(dev, B43_PHY_RFOVER, rfover | 0x008C);
>  		b43_phy_write(dev, B43_PHY_RFOVERVAL, rfoverval & 0xFF73);
>  	} else
> Index: wireless-2.6/drivers/net/wireless/b43/phy.h
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/b43/phy.h	2007-09-27 20:53:39.000000000 +0200
> +++ wireless-2.6/drivers/net/wireless/b43/phy.h	2007-09-27 20:56:53.000000000 +0200
> @@ -267,7 +267,7 @@ u16 b43_radio_init2050(struct b43_wldev 
>  void b43_radio_init2060(struct b43_wldev *dev);
>  
>  void b43_radio_turn_on(struct b43_wldev *dev);
> -void b43_radio_turn_off(struct b43_wldev *dev);
> +void b43_radio_turn_off(struct b43_wldev *dev, bool force);
>  
>  int b43_radio_selectchannel(struct b43_wldev *dev, u8 channel,
>  			    int synthetic_pu_workaround);
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


