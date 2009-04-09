Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:35853 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913AbZDILvf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Apr 2009 07:51:35 -0400
Received: by fxm2 with SMTP id 2so551158fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 09 Apr 2009 04:51:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49dd785f.mp1oc4nY+m3n0uHL%Larry.Finger@lwfinger.net>
References: <49dd785f.mp1oc4nY+m3n0uHL%Larry.Finger@lwfinger.net>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Thu, 9 Apr 2009 13:51:17 +0200
Message-ID: <69e28c910904090451k38ffa9bcvea771bd1b9fda086@mail.gmail.com> (sfid-20090409_135140_762935_AF351D2A)
Subject: Re: [RFT/RFC] rtl8187: Implement TX/RX blink for LED
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 9, 2009 at 6:23 AM, Larry Finger <Larry.Finger@lwfinger.net=
> wrote:
> The following patch implements some control over the LED on RTL8187B =
and
> RTL8187L devices. Triggers are registered for TX and RX. Whenever the
> trigger event occurs, the LED is turned off for 1/20 second, then tur=
ned
> back on.
>
> Please test and comment.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>
> Index: wireless-testing/drivers/net/wireless/Kconfig
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-testing.orig/drivers/net/wireless/Kconfig
> +++ wireless-testing/drivers/net/wireless/Kconfig
> @@ -433,6 +433,13 @@ config RTL8187
>
> =A0 =A0 =A0 =A0 =A0Thanks to Realtek for their support!
>
> +# If possible, automatically enable LED's for RTL8187.

Spelling error: "LED's" should be "LEDs".

> +
> +config RTL8187_LEDS
> + =A0 =A0 =A0 bool
> + =A0 =A0 =A0 depends on RTL8187 && MAC80211_LEDS && (LEDS_CLASS =3D =
y || LEDS_CLASS =3D RTL8187)
> + =A0 =A0 =A0 default y
> +
> =A0config ADM8211
> =A0 =A0 =A0 =A0tristate "ADMtek ADM8211 support"
> =A0 =A0 =A0 =A0depends on MAC80211 && PCI && WLAN_80211 && EXPERIMENT=
AL

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
