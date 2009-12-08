Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:60580 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753831AbZLHLDN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 06:03:13 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC/RFT] rtl8187: Fix 'queuing ieee80211 work while going to suspend' warning
Date: Tue, 8 Dec 2009 12:02:02 +0100
Cc: John W Linville <linville@tuxdriver.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
References: <4b1db502./oHzXA5LInBxxQjb%Larry.Finger@lwfinger.net>
In-Reply-To: <4b1db502./oHzXA5LInBxxQjb%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200912081202.04591.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 08 December 2009 03:08:02 Larry Finger wrote:
> In http://marc.info/?l=linux-wireless&m=125916285209175&w=2, Michael
> Buesch reports a problem with rtl8187 queuing LED on/off requests after
> the suspend has begun. On my system this is present during a suspend
> to disk.
> 
> This solution involves adding the power management entries to the
> driver to set a flag indicating that the system is suspending. When the
> flag is set, no LED on/off events are queued.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187.h
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187.h
> +++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187.h
> @@ -138,6 +138,7 @@ struct rtl8187_priv {
>  		__le32 bits32;
>  	} *io_dmabuf;
>  	bool rfkill_off;
> +	bool suspending;	/* true if shutting down */
>  };
>  
>  void rtl8187_write_phy(struct ieee80211_hw *dev, u8 addr, u32 data);
> Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_dev.c
> +++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
> @@ -1521,6 +1521,7 @@ static int __devinit rtl8187_probe(struc
>  	       wiphy_name(dev->wiphy), dev->wiphy->perm_addr,
>  	       chip_name, priv->asic_rev, priv->rf->name, priv->rfkill_mask);
>  
> +	priv->suspending = 0;
>  #ifdef CONFIG_RTL8187_LEDS
>  	eeprom_93cx6_read(&eeprom, 0x3F, &reg);
>  	reg &= 0xFF;
> @@ -1539,6 +1540,38 @@ static int __devinit rtl8187_probe(struc
>  	return err;
>  }
>  
> +#ifdef CONFIG_PM
> +static int rtl8187_suspend(struct usb_interface *intf, pm_message_t message)
> +{
> +	struct ieee80211_hw *dev = usb_get_intfdata(intf);
> +	struct rtl8187_priv *priv;
> +
> +	if (!dev)
> +		return -ENODEV;
> +
> +	priv = dev->priv;
> +	priv->suspending = 1;
> +#ifdef CONFIG_RTL8187_LEDS
> +	cancel_delayed_work_sync(&priv->led_off);
> +	cancel_delayed_work_sync(&priv->led_on);
> +#endif
> +	return 0;
> +}
> +
> +static int rtl8187_resume(struct usb_interface *intf)
> +{
> +	struct ieee80211_hw *dev = usb_get_intfdata(intf);
> +	struct rtl8187_priv *priv;
> +
> +	if (!dev)
> +		return -ENODEV;
> +
> +	priv = dev->priv;
> +	priv->suspending = 0;
> +	return 0;
> +}
> +#endif
> +
>  static void __devexit rtl8187_disconnect(struct usb_interface *intf)
>  {
>  	struct ieee80211_hw *dev = usb_get_intfdata(intf);
> @@ -1564,6 +1597,10 @@ static struct usb_driver rtl8187_driver
>  	.name		= KBUILD_MODNAME,
>  	.id_table	= rtl8187_table,
>  	.probe		= rtl8187_probe,
> +#ifdef CONFIG_PM
> +	.suspend	= rtl8187_suspend,
> +	.resume		= rtl8187_resume,
> +#endif
>  	.disconnect	= __devexit_p(rtl8187_disconnect),
>  };
>  
> Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_leds.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_leds.c
> +++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_leds.c
> @@ -107,6 +107,8 @@ static void rtl8187_led_brightness_set(s
>  	struct ieee80211_hw *hw = led->dev;
>  	struct rtl8187_priv *priv = hw->priv;
>  
> +	if (priv->suspending)
> +		return;
>  	if (brightness == LED_OFF) {
>  		ieee80211_queue_delayed_work(hw, &priv->led_off, 0);
>  		/* The LED is off for 1/20 sec so that it just blinks. */
> @@ -209,11 +211,12 @@ void rtl8187_leds_exit(struct ieee80211_
>  	struct rtl8187_priv *priv = dev->priv;
>  
>  	/* turn the LED off before exiting */
> -	ieee80211_queue_delayed_work(dev, &priv->led_off, 0);
> -	rtl8187_unregister_led(&priv->led_rx);
> -	rtl8187_unregister_led(&priv->led_tx);
> +	if (!priv->suspending)
> +		ieee80211_queue_delayed_work(dev, &priv->led_off, 0);
>  	cancel_delayed_work_sync(&priv->led_off);
>  	cancel_delayed_work_sync(&priv->led_on);
> +	rtl8187_unregister_led(&priv->led_rx);
> +	rtl8187_unregister_led(&priv->led_tx);
>  }
>  #endif /* def CONFIG_RTL8187_LED */
>  
> 
> 

Did you test this? I think it can't work.
mac80211's suspend calls stop operation before rtl8187_suspend() is run. So the
actual suspend operations runs without suspend flag set.
I think setting a flag is wrong. I also did that mistake in the broadcom driver
and it's wrong. IMO the LED register/unregister code must be completely removed
from the start/stop suspend/resume and hibernate paths. Instead the LEDs must be
registered at device attach phase (that's where the device is registered to mac80211).

-- 
Greetings, Michael.
