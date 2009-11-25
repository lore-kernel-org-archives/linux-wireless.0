Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:34420 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933118AbZKYXSD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 18:18:03 -0500
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: RTL8187 warnings on suspend
Date: Wed, 25 Nov 2009 21:18:05 -0200
Cc: "Hin-Tak Leung" <htl10@users.sourceforge.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <200911251626.15959.mb@bu3sch.de> <200911251944.25381.herton@mandriva.com.br> <200911252318.15738.mb@bu3sch.de>
In-Reply-To: <200911252318.15738.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200911252118.05822.herton@mandriva.com.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Qua 25 Nov 2009, às 20:18:14, Michael Buesch escreveu:
> On Wednesday 25 November 2009 22:44:25 Herton Ronaldo Krzesinski wrote:
> > Hmm strange, reviewing it now I only see a missing #ifdef CONFIG_RTL8187_LEDS
> > around rtl8187_leds_start inside rtl8187_start. Despite it, the patch worked
> > here, may be something I'm not seeing...
> 
> http://bu3sch.de/misc/rtl8187.JPG

My approach wasn't good, I have another try, this one I couldn't test yet
as I'm away from the laptop with rtl8187 until tomorrow, but I decided to post
it now (sorry for another patch dump, this I hope should work):

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
index cf8a4a4..40419b3 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_leds.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_leds.c
@@ -107,6 +107,10 @@ static void rtl8187_led_brightness_set(struct led_classdev *led_dev,
 	struct ieee80211_hw *hw = led->dev;
 	struct rtl8187_priv *priv = hw->priv;
 
+	/* Don't change the LED, when the device is down. */
+	if (priv->mode == NL80211_IFTYPE_UNSPECIFIED)
+		return;
+
 	if (brightness == LED_OFF) {
 		ieee80211_queue_delayed_work(hw, &priv->led_off, 0);
 		/* The LED is off for 1/20 sec so that it just blinks. */
@@ -208,8 +212,6 @@ void rtl8187_leds_exit(struct ieee80211_hw *dev)
 {
 	struct rtl8187_priv *priv = dev->priv;
 
-	/* turn the LED off before exiting */
-	ieee80211_queue_delayed_work(dev, &priv->led_off, 0);
 	rtl8187_unregister_led(&priv->led_rx);
 	rtl8187_unregister_led(&priv->led_tx);
 	cancel_delayed_work_sync(&priv->led_off);


-- 
[]'s
Herton
