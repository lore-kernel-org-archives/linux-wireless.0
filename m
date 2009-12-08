Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:45360 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019AbZLHPlT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 10:41:19 -0500
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [RFC/RFT] rtl8187: Fix 'queuing ieee80211 work while going to suspend' warning
Date: Tue, 8 Dec 2009 13:41:20 -0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	"Hin-Tak Leung" <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
References: <4b1db502./oHzXA5LInBxxQjb%Larry.Finger@lwfinger.net> <200912081202.04591.mb@bu3sch.de>
In-Reply-To: <200912081202.04591.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200912081341.20682.herton@mandriva.com.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Ter 08 Dez 2009, às 09:02:02, Michael Buesch escreveu:
> On Tuesday 08 December 2009 03:08:02 Larry Finger wrote:
> > In http://marc.info/?l=linux-wireless&m=125916285209175&w=2, Michael
> > Buesch reports a problem with rtl8187 queuing LED on/off requests after
> > the suspend has begun. On my system this is present during a suspend
> > to disk.
> >
> > This solution involves adding the power management entries to the
> > driver to set a flag indicating that the system is suspending. When the
> > flag is set, no LED on/off events are queued.
> >
> > Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> > ---
> >
> > Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187.h
> > ===================================================================
> > --- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187.h
> > +++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187.h
> > @@ -138,6 +138,7 @@ struct rtl8187_priv {
> >  		__le32 bits32;
> >  	} *io_dmabuf;
> >  	bool rfkill_off;
> > +	bool suspending;	/* true if shutting down */
> >  };
> >
> >  void rtl8187_write_phy(struct ieee80211_hw *dev, u8 addr, u32 data);
> > Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
> > ===================================================================
> > --- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_dev.c
> > +++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
> > @@ -1521,6 +1521,7 @@ static int __devinit rtl8187_probe(struc
> >  	       wiphy_name(dev->wiphy), dev->wiphy->perm_addr,
> >  	       chip_name, priv->asic_rev, priv->rf->name, priv-
>rfkill_mask);
> >
> > +	priv->suspending = 0;
> >  #ifdef CONFIG_RTL8187_LEDS
> >  	eeprom_93cx6_read(&eeprom, 0x3F, &reg);
> >  	reg &= 0xFF;
> > @@ -1539,6 +1540,38 @@ static int __devinit rtl8187_probe(struc
> >  	return err;
> >  }
> >
> > +#ifdef CONFIG_PM
> > +static int rtl8187_suspend(struct usb_interface *intf, pm_message_t
> > message) +{
> > +	struct ieee80211_hw *dev = usb_get_intfdata(intf);
> > +	struct rtl8187_priv *priv;
> > +
> > +	if (!dev)
> > +		return -ENODEV;
> > +
> > +	priv = dev->priv;
> > +	priv->suspending = 1;
> > +#ifdef CONFIG_RTL8187_LEDS
> > +	cancel_delayed_work_sync(&priv->led_off);
> > +	cancel_delayed_work_sync(&priv->led_on);
> > +#endif
> > +	return 0;
> > +}
> > +
> > +static int rtl8187_resume(struct usb_interface *intf)
> > +{
> > +	struct ieee80211_hw *dev = usb_get_intfdata(intf);
> > +	struct rtl8187_priv *priv;
> > +
> > +	if (!dev)
> > +		return -ENODEV;
> > +
> > +	priv = dev->priv;
> > +	priv->suspending = 0;
> > +	return 0;
> > +}
> > +#endif
> > +
> >  static void __devexit rtl8187_disconnect(struct usb_interface *intf)
> >  {
> >  	struct ieee80211_hw *dev = usb_get_intfdata(intf);
> > @@ -1564,6 +1597,10 @@ static struct usb_driver rtl8187_driver
> >  	.name		= KBUILD_MODNAME,
> >  	.id_table	= rtl8187_table,
> >  	.probe		= rtl8187_probe,
> > +#ifdef CONFIG_PM
> > +	.suspend	= rtl8187_suspend,
> > +	.resume		= rtl8187_resume,
> > +#endif
> >  	.disconnect	= __devexit_p(rtl8187_disconnect),
> >  };
> >
> > Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_leds.c
> > ===================================================================
> > --- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_leds.c
> > +++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_leds.c
> > @@ -107,6 +107,8 @@ static void rtl8187_led_brightness_set(s
> >  	struct ieee80211_hw *hw = led->dev;
> >  	struct rtl8187_priv *priv = hw->priv;
> >
> > +	if (priv->suspending)
> > +		return;
> >  	if (brightness == LED_OFF) {
> >  		ieee80211_queue_delayed_work(hw, &priv->led_off, 0);
> >  		/* The LED is off for 1/20 sec so that it just blinks. */
> > @@ -209,11 +211,12 @@ void rtl8187_leds_exit(struct ieee80211_
> >  	struct rtl8187_priv *priv = dev->priv;
> >
> >  	/* turn the LED off before exiting */
> > -	ieee80211_queue_delayed_work(dev, &priv->led_off, 0);
> > -	rtl8187_unregister_led(&priv->led_rx);
> > -	rtl8187_unregister_led(&priv->led_tx);
> > +	if (!priv->suspending)
> > +		ieee80211_queue_delayed_work(dev, &priv->led_off, 0);
> >  	cancel_delayed_work_sync(&priv->led_off);
> >  	cancel_delayed_work_sync(&priv->led_on);
> > +	rtl8187_unregister_led(&priv->led_rx);
> > +	rtl8187_unregister_led(&priv->led_tx);
> >  }
> >  #endif /* def CONFIG_RTL8187_LED */
> 
> Did you test this? I think it can't work.
> mac80211's suspend calls stop operation before rtl8187_suspend() is run. So
>  the actual suspend operations runs without suspend flag set.
> I think setting a flag is wrong. I also did that mistake in the broadcom
>  driver and it's wrong. IMO the LED register/unregister code must be
>  completely removed from the start/stop suspend/resume and hibernate paths.
>  Instead the LEDs must be registered at device attach phase (that's where
>  the device is registered to mac80211).

That's why in my last patch I added code to register the radio led, we have to 
go that way to fix properly the issue (also this way we turn the led on/off only 
when mac80211 wants it, which is the right way), so we can avoid having to 
place code in start/stop or creating suspend/resume hooks only because the 
issue.

The problem here is not simple: we have leds code triggering work and mac80211 
scheduling led tx work even after radio led stop on device shutdown:
- On unregistering led device, even after mac80211 did the work to turn off the 
led, the unregister code of led subsystem calls again led_brightness_set to 
turn off the led, which causes the original warning without suspend/resume 
hooks (also in leds_exit code we were scheduling work which triggered more 
warnings).
- When I was testing, sometimes mac80211 on device shutdown (modprobe -r) 
wasn't calling led stop code in the right order, so sometimes after removing 
module the led was kept turned on (scheduling led tx code after led radio off). 
This happens because ieee80211_tx_status can call ieee80211_led_tx after 
mac80211 calls ieee80211_led_radio to turn the led off, and as we are 
"emulating" a radio led (we have only one real led to signal radio and tx/rx, 
no differentiation on hardware) we are affected by this.

So besides registering the radio led, I had to add that radio_on variable 
check on last patch, to handle these two problems. The patch worked, but Larry 
reported a crash, I'll try to review it more and see what could cause a crash 
on removal, may be some delayed_work related thing missing, unfortunately I'm 
a bit busy here since then, but will try to get to it soon.

--
[]'s
Herton
