Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:51025 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbZK0Lp1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2009 06:45:27 -0500
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: htl10@users.sourceforge.net
Subject: Re: RTL8187 warnings on suspend
Date: Fri, 27 Nov 2009 09:45:31 -0200
Cc: Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <665313.63774.qm@web23102.mail.ird.yahoo.com>
In-Reply-To: <665313.63774.qm@web23102.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200911270945.31125.herton@mandriva.com.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Qui 26 Nov 2009, às 22:10:10, Hin-Tak Leung escreveu:
> --- On Thu, 26/11/09, Herton Ronaldo Krzesinski <herton@mandriva.com.br> wrote:
> 
> > > My approach wasn't good, I have another try, this one
> > I couldn't test yet
> > > as I'm away from the laptop with rtl8187 until
> > tomorrow, but I decided to post
> > > it now (sorry for another patch dump, this I hope
> > should work):
> > 
> > There were some missing bits, this worked in my tests:
> > 
> > diff --git a/drivers/net/wireless/rtl818x/rtl8187.h
> > b/drivers/net/wireless/rtl818x/rtl8187.h
> > index bf9175a..6d4bd5c 100644
> > --- a/drivers/net/wireless/rtl818x/rtl8187.h
> > +++ b/drivers/net/wireless/rtl818x/rtl8187.h
> > @@ -134,6 +134,7 @@ struct rtl8187_priv {
> >          __le32 bits32;
> >      } *io_dmabuf;
> >      bool rfkill_off;
> > +    bool stopped;
> >  };
> >  
> >  void rtl8187_write_phy(struct ieee80211_hw *dev, u8 addr,
> > u32 data);
> > diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c
> > b/drivers/net/wireless/rtl818x/rtl8187_dev.c
> > index 2017ccc..159e5bf 100644
> > --- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
> > +++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
> > @@ -990,6 +990,7 @@ static int rtl8187_start(struct
> > ieee80211_hw *dev)
> >  
> >  rtl8187_start_exit:
> >     
> > mutex_unlock(&priv->conf_mutex);
> > +    priv->stopped = false;
> >      return ret;
> >  }
> >  
> > @@ -1022,6 +1023,14 @@ static void rtl8187_stop(struct
> > ieee80211_hw *dev)
> >  
> >      if (!priv->is_rtl8187b)
> >         
> > cancel_delayed_work_sync(&priv->work);
> > +
> > +#ifdef CONFIG_RTL8187_LEDS
> > +    /* XXX: turn the LED off */
> > +   
> > cancel_delayed_work_sync(&priv->led_on);
> > +    ieee80211_queue_delayed_work(dev,
> > &priv->led_off, 0);
> > +   
> > flush_delayed_work(&priv->led_off);
> > +#endif
> > +    priv->stopped = true;
> >  }
> >  
> >  static int rtl8187_add_interface(struct ieee80211_hw
> > *dev,
> > diff --git a/drivers/net/wireless/rtl818x/rtl8187_leds.c
> > b/drivers/net/wireless/rtl818x/rtl8187_leds.c
> > index cf8a4a4..fd07235 100644
> > --- a/drivers/net/wireless/rtl818x/rtl8187_leds.c
> > +++ b/drivers/net/wireless/rtl818x/rtl8187_leds.c
> > @@ -107,6 +107,9 @@ static void
> > rtl8187_led_brightness_set(struct led_classdev *led_dev,
> >      struct ieee80211_hw *hw = led->dev;
> >      struct rtl8187_priv *priv =
> > hw->priv;
> >  
> > +    if (priv->stopped)
> > +        return;
> > +
> >      if (brightness == LED_OFF) {
> >         
> > ieee80211_queue_delayed_work(hw, &priv->led_off, 0);
> >          /* The LED is off
> > for 1/20 sec so that it just blinks. */
> > @@ -192,10 +195,8 @@ void rtl8187_leds_init(struct
> > ieee80211_hw *dev, u16 custid)
> >     
> >      "rtl8187-%s::rx",
> > wiphy_name(dev->wiphy));
> >      err = rtl8187_register_led(dev,
> > &priv->led_rx, name,
> >         
> >      ieee80211_get_rx_led_name(dev),
> > ledpin);
> > -    if (!err) {
> > -       
> > ieee80211_queue_delayed_work(dev, &priv->led_on, 0);
> > +    if (!err)
> >          return;
> > -    }
> >      /* registration of RX LED failed -
> > unregister TX */
> >     
> > rtl8187_unregister_led(&priv->led_tx);
> >  error:
> > @@ -208,8 +209,6 @@ void rtl8187_leds_exit(struct
> > ieee80211_hw *dev)
> >  {
> >      struct rtl8187_priv *priv =
> > dev->priv;
> >  
> > -    /* turn the LED off before exiting */
> > -    ieee80211_queue_delayed_work(dev,
> > &priv->led_off, 0);
> >     
> > rtl8187_unregister_led(&priv->led_rx);
> >     
> > rtl8187_unregister_led(&priv->led_tx);
> >     
> > cancel_delayed_work_sync(&priv->led_off);
> > 
> > 
> > But it is a bit of a hack, I think we should change
> > LEDS_OFF case to not have
> > to turn the led off on stop/exit (mac80211 already calls
> > led off on stop, but
> > on rtl8187 because the LEDS_OFF treatment in
> > rtl8187_led_brightness_set
> > we have to turn it off on exit). I'll see if I can make a
> > better patch.
> > 
> 
> 
> Apologies for being not very responsive. This looks a bit ugly - you are trying to set a flag so that if _stop() is called first, most of _led_set() is by-passed... is there a better way?

_stop will always be called first in suspend, mac80211 calls everything in
right order. The problem here is that in suspend the device is disconnected
(probably because we don't have any reset/resume support), so
rtl8187_disconnect is called while mac80211 is already suspended.
In rtl8187_disconnect we unregister the leds, and the leds subsystem calls
rtl8187_led_brightness_set to turn the led off again, which calls
ieee80211_queue_delayed_work and thus the warning.

Also because we don't register assoc/radio leds, we end up now having to put
led switch code in rtl8187_stop, and assume led always on in tx/rx, this is
something now worth to look and fix.

A better patch is below, tested here now too, avoiding adding the extra stopped
flag:

diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index 2017ccc..25cd10c 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -1022,6 +1022,13 @@ static void rtl8187_stop(struct ieee80211_hw *dev)
 
 	if (!priv->is_rtl8187b)
 		cancel_delayed_work_sync(&priv->work);
+
+#ifdef CONFIG_RTL8187_LEDS
+	/* XXX: turn the LED off */
+	cancel_delayed_work_sync(&priv->led_on);
+	ieee80211_queue_delayed_work(dev, &priv->led_off, 0);
+	flush_delayed_work(&priv->led_off);
+#endif
 }
 
 static int rtl8187_add_interface(struct ieee80211_hw *dev,
diff --git a/drivers/net/wireless/rtl818x/rtl8187_leds.c b/drivers/net/wireless/rtl818x/rtl8187_leds.c
index cf8a4a4..f7f43c6 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_leds.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_leds.c
@@ -107,6 +107,16 @@ static void rtl8187_led_brightness_set(struct led_classdev *led_dev,
 	struct ieee80211_hw *hw = led->dev;
 	struct rtl8187_priv *priv = hw->priv;
 
+	/* Don't queue led work if we are unregistering, we and mac80211 already
+	 * turns led off on rtl8187 stop, and we get warnings on suspend without
+	 * this, as interface is already suspended and we can't call anymore
+	 * ieee80211_queue_delayed_work. We depend here on the fact that
+	 * led_classdev_unregister calls led_trigger_set(led_dev, NULL), and
+	 * trigger is set to NULL before led_set_brightness inside
+	 * led_trigger_set */
+	if (!led_dev->trigger)
+		return;
+
 	if (brightness == LED_OFF) {
 		ieee80211_queue_delayed_work(hw, &priv->led_off, 0);
 		/* The LED is off for 1/20 sec so that it just blinks. */
@@ -208,8 +218,6 @@ void rtl8187_leds_exit(struct ieee80211_hw *dev)
 {
 	struct rtl8187_priv *priv = dev->priv;
 
-	/* turn the LED off before exiting */
-	ieee80211_queue_delayed_work(dev, &priv->led_off, 0);
 	rtl8187_unregister_led(&priv->led_rx);
 	rtl8187_unregister_led(&priv->led_tx);
 	cancel_delayed_work_sync(&priv->led_off);


> 
> Hin-Tak
> 
> 
>       
> 

-- 
[]'s
Herton
