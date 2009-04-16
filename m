Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:58835 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbZDPOmA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 10:42:00 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFT/RFC V3] rtl8187: Implement TX/RX blink for LED
Date: Thu, 16 Apr 2009 11:42:02 -0300
Cc: "Hin-Tak Leung" <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
References: <49e644a4.3DqmSbwccrtRsayP%Larry.Finger@lwfinger.net>
In-Reply-To: <49e644a4.3DqmSbwccrtRsayP%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Message-Id: <200904161142.03296.herton@mandriva.com.br> (sfid-20090416_164204_101674_5D22EFE6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Quarta-feira 15 Abril 2009, =E0s 17:33:40, Larry Finger escreveu:
> The following patch implements some control over the LED on RTL8187B =
and
> RTL8187L devices. Triggers are registered for TX and RX. Whenever the
> trigger event occurs, the LED is turned off for 1/20 second, then tur=
ned
> back on.
>
> Note: For those RTL8187X devices that are built into the computer and=
 have
> a LED that is expected to be controlled with a radio switch, this pat=
ch
> will not operate that LED. That will take a separate patch to be prep=
ared
> later.
>
> Please test and comment.

It didn't work for me, I need to fix this typo in V3 patch:

 ./drivers/net/wireless/rtl818x/rtl8187_leds.c
--- ./drivers/net/wireless/rtl818x/rtl8187_leds.c.orig	2009-04-15=20
18:47:24.000000000 -0300
+++ ./drivers/net/wireless/rtl818x/rtl8187_leds.c	2009-04-16=20
11:32:11.000000000 -0300
@@ -64,7 +64,7 @@ static void led_turn_off(struct work_str
 	 */
 	u8 reg;
 	struct rtl8187_priv *priv =3D container_of(work, struct rtl8187_priv,
-				    led_on.work);
+				    led_off.work);
 	struct rtl8187_led *led =3D &priv->led_tx;
=20
 	/* Don't change the LED, when the device is down. */


Also, it doens't turn on led on interface up, probably because we don't=
 have a=20
'radio' led and now removed led on from init_regs, may be we could do t=
his:

@@ -186,8 +187,10 @@ void rtl8187_leds_init(struct ieee80211_
 		 "rtl8187-%s::rx", wiphy_name(dev->wiphy));
 	err =3D rtl8187_register_led(dev, &priv->led_rx, name,
 			 ieee80211_get_rx_led_name(dev), ledpin);
-	if (!err)
+	if (!err) {
+		queue_delayed_work(priv->dev->workqueue, &priv->led_on, 0);
 		return;
+	}
 	/* registration of RX LED failed - unregister TX */
 	rtl8187_unregister_led(&priv->led_tx);
 error:


=46or the led off/stop code you added on rtl8187_stop, may be we would =
want to=20
protect:
       rtl818x_iowrite8(priv, &priv->map->GPIO, 0x01);
       rtl818x_iowrite8(priv, &priv->map->GP_ENABLE, 0x01);
inside an ifdef CONFIG_RTL8187_LEDS, but it will not work also for othe=
r led=20
hardware (the ones which don't use GPIO/GP_ENABLE to set leds. we could=
 do=20
this instead on rtl8187_leds_exit:

@@ -200,6 +203,7 @@ void rtl8187_leds_exit(struct ieee80211_
 {
 	struct rtl8187_priv *priv =3D dev->priv;
=20
+	queue_delayed_work(priv->dev->workqueue, &priv->led_off, 0);
 	cancel_delayed_work_sync(&priv->led_off);
 	cancel_delayed_work_sync(&priv->led_on);
 	rtl8187_unregister_led(&priv->led_tx);

but then it will not turn off led on interface stop, just on module rem=
oval...

>
> The behavior described above is found for my Level One RTL8187B. Prio=
r to
> this patch, the LED was on continuously. On a Netgear WG111V2 RTL8187=
L, the
> LED blinks erratically. Before the patch, the LED was off.
>
> If you test, please report the status of the LED before and after app=
lying
> the patch. In addition, find the line that looks like "rtl8187: Custo=
mer ID
> 0x00" in the dmesg output and report it. I also need to know if you h=
ave a
> B or L model.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>
> V2 fixed a locking problem that caused the RTL8187L to fail.
>
> V3 removes the code that turned the LED on at device startup, and tur=
ns
> it off when the driver is unloaded.
>
>
<snip>

--
[]'s
Herton
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
