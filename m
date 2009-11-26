Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:50335 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbZKZSEE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 13:04:04 -0500
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: RTL8187 warnings on suspend
Date: Thu, 26 Nov 2009 16:04:03 -0200
Cc: "Hin-Tak Leung" <htl10@users.sourceforge.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <200911251626.15959.mb@bu3sch.de> <200911252318.15738.mb@bu3sch.de> <200911252118.05822.herton@mandriva.com.br>
In-Reply-To: <200911252118.05822.herton@mandriva.com.br>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200911261604.04008.herton@mandriva.com.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Qua 25 Nov 2009, às 21:18:05, Herton Ronaldo Krzesinski escreveu:
> Em Qua 25 Nov 2009, às 20:18:14, Michael Buesch escreveu:
> > On Wednesday 25 November 2009 22:44:25 Herton Ronaldo Krzesinski wrote:
> > > Hmm strange, reviewing it now I only see a missing #ifdef CONFIG_RTL8187_LEDS
> > > around rtl8187_leds_start inside rtl8187_start. Despite it, the patch worked
> > > here, may be something I'm not seeing...
> > 
> > http://bu3sch.de/misc/rtl8187.JPG
> 
> My approach wasn't good, I have another try, this one I couldn't test yet
> as I'm away from the laptop with rtl8187 until tomorrow, but I decided to post
> it now (sorry for another patch dump, this I hope should work):

There were some missing bits, this worked in my tests:

diff --git a/drivers/net/wireless/rtl818x/rtl8187.h b/drivers/net/wireless/rtl818x/rtl8187.h
index bf9175a..6d4bd5c 100644
--- a/drivers/net/wireless/rtl818x/rtl8187.h
+++ b/drivers/net/wireless/rtl818x/rtl8187.h
@@ -134,6 +134,7 @@ struct rtl8187_priv {
 		__le32 bits32;
 	} *io_dmabuf;
 	bool rfkill_off;
+	bool stopped;
 };
 
 void rtl8187_write_phy(struct ieee80211_hw *dev, u8 addr, u32 data);
diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index 2017ccc..159e5bf 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -990,6 +990,7 @@ static int rtl8187_start(struct ieee80211_hw *dev)
 
 rtl8187_start_exit:
 	mutex_unlock(&priv->conf_mutex);
+	priv->stopped = false;
 	return ret;
 }
 
@@ -1022,6 +1023,14 @@ static void rtl8187_stop(struct ieee80211_hw *dev)
 
 	if (!priv->is_rtl8187b)
 		cancel_delayed_work_sync(&priv->work);
+
+#ifdef CONFIG_RTL8187_LEDS
+	/* XXX: turn the LED off */
+	cancel_delayed_work_sync(&priv->led_on);
+	ieee80211_queue_delayed_work(dev, &priv->led_off, 0);
+	flush_delayed_work(&priv->led_off);
+#endif
+	priv->stopped = true;
 }
 
 static int rtl8187_add_interface(struct ieee80211_hw *dev,
diff --git a/drivers/net/wireless/rtl818x/rtl8187_leds.c b/drivers/net/wireless/rtl818x/rtl8187_leds.c
index cf8a4a4..fd07235 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_leds.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_leds.c
@@ -107,6 +107,9 @@ static void rtl8187_led_brightness_set(struct led_classdev *led_dev,
 	struct ieee80211_hw *hw = led->dev;
 	struct rtl8187_priv *priv = hw->priv;
 
+	if (priv->stopped)
+		return;
+
 	if (brightness == LED_OFF) {
 		ieee80211_queue_delayed_work(hw, &priv->led_off, 0);
 		/* The LED is off for 1/20 sec so that it just blinks. */
@@ -192,10 +195,8 @@ void rtl8187_leds_init(struct ieee80211_hw *dev, u16 custid)
 		 "rtl8187-%s::rx", wiphy_name(dev->wiphy));
 	err = rtl8187_register_led(dev, &priv->led_rx, name,
 			 ieee80211_get_rx_led_name(dev), ledpin);
-	if (!err) {
-		ieee80211_queue_delayed_work(dev, &priv->led_on, 0);
+	if (!err)
 		return;
-	}
 	/* registration of RX LED failed - unregister TX */
 	rtl8187_unregister_led(&priv->led_tx);
 error:
@@ -208,8 +209,6 @@ void rtl8187_leds_exit(struct ieee80211_hw *dev)
 {
 	struct rtl8187_priv *priv = dev->priv;
 
-	/* turn the LED off before exiting */
-	ieee80211_queue_delayed_work(dev, &priv->led_off, 0);
 	rtl8187_unregister_led(&priv->led_rx);
 	rtl8187_unregister_led(&priv->led_tx);
 	cancel_delayed_work_sync(&priv->led_off);


But it is a bit of a hack, I think we should change LEDS_OFF case to not have
to turn the led off on stop/exit (mac80211 already calls led off on stop, but
on rtl8187 because the LEDS_OFF treatment in rtl8187_led_brightness_set
we have to turn it off on exit). I'll see if I can make a better patch.

-- 
[]'s
Herton
