Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost05.isp.att.net ([207.115.11.55]:48331 "EHLO
	fmailhost05.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbZDPPKT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 11:10:19 -0400
Message-ID: <49E74A47.5010309@lwfinger.net> (sfid-20090416_171023_612853_25438DFD)
Date: Thu, 16 Apr 2009 10:09:59 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
CC: Hin-Tak Leung <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFT/RFC V3] rtl8187: Implement TX/RX blink for LED
References: <49e644a4.3DqmSbwccrtRsayP%Larry.Finger@lwfinger.net> <200904161142.03296.herton@mandriva.com.br>
In-Reply-To: <200904161142.03296.herton@mandriva.com.br>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Herton Ronaldo Krzesinski wrote:
> Em Quarta-feira 15 Abril 2009, =E0s 17:33:40, Larry Finger escreveu:
>> The following patch implements some control over the LED on RTL8187B=
 and
>> RTL8187L devices. Triggers are registered for TX and RX. Whenever th=
e
>> trigger event occurs, the LED is turned off for 1/20 second, then tu=
rned
>> back on.
>>
>> Note: For those RTL8187X devices that are built into the computer an=
d have
>> a LED that is expected to be controlled with a radio switch, this pa=
tch
>> will not operate that LED. That will take a separate patch to be pre=
pared
>> later.
>>
>> Please test and comment.
>=20
> It didn't work for me, I need to fix this typo in V3 patch:
>=20
>  ./drivers/net/wireless/rtl818x/rtl8187_leds.c
> --- ./drivers/net/wireless/rtl818x/rtl8187_leds.c.orig	2009-04-15=20
> 18:47:24.000000000 -0300
> +++ ./drivers/net/wireless/rtl818x/rtl8187_leds.c	2009-04-16=20
> 11:32:11.000000000 -0300
> @@ -64,7 +64,7 @@ static void led_turn_off(struct work_str
>  	 */
>  	u8 reg;
>  	struct rtl8187_priv *priv =3D container_of(work, struct rtl8187_pri=
v,
> -				    led_on.work);
> +				    led_off.work);
>  	struct rtl8187_led *led =3D &priv->led_tx;
> =20
>  	/* Don't change the LED, when the device is down. */

Thanks for catching this. That was a copy-and-paste gone wrong.


> Also, it doens't turn on led on interface up, probably because we don=
't have a=20
> 'radio' led and now removed led on from init_regs, may be we could do=
 this:
>=20
> @@ -186,8 +187,10 @@ void rtl8187_leds_init(struct ieee80211_
>  		 "rtl8187-%s::rx", wiphy_name(dev->wiphy));
>  	err =3D rtl8187_register_led(dev, &priv->led_rx, name,
>  			 ieee80211_get_rx_led_name(dev), ledpin);
> -	if (!err)
> +	if (!err) {
> +		queue_delayed_work(priv->dev->workqueue, &priv->led_on, 0);
>  		return;
> +	}

I had thought of this as a feature in that the LED comes on when the fi=
rst
transmit occurs, but it is more instructive to have it on as soon as th=
e LED
system is ready.

>  	/* registration of RX LED failed - unregister TX */
>  	rtl8187_unregister_led(&priv->led_tx);
>  error:
>=20
>=20
> For the led off/stop code you added on rtl8187_stop, may be we would =
want to=20
> protect:
>        rtl818x_iowrite8(priv, &priv->map->GPIO, 0x01);
>        rtl818x_iowrite8(priv, &priv->map->GP_ENABLE, 0x01);
> inside an ifdef CONFIG_RTL8187_LEDS, but it will not work also for ot=
her led=20
> hardware (the ones which don't use GPIO/GP_ENABLE to set leds. we cou=
ld do=20
> this instead on rtl8187_leds_exit:
>=20
> @@ -200,6 +203,7 @@ void rtl8187_leds_exit(struct ieee80211_
>  {
>  	struct rtl8187_priv *priv =3D dev->priv;
> =20
> +	queue_delayed_work(priv->dev->workqueue, &priv->led_off, 0);
>  	cancel_delayed_work_sync(&priv->led_off);
>  	cancel_delayed_work_sync(&priv->led_on);
>  	rtl8187_unregister_led(&priv->led_tx);
>=20
> but then it will not turn off led on interface stop, just on module r=
emoval...

If we are turning the LED on in rtl8187_leds_init(), it should be off i=
n
rtl8187_leds_exit(). I'll rework for V4.

Thanks for the review.

Larry

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
