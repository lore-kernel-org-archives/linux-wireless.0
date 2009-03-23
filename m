Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33577 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876AbZCWO3Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 10:29:16 -0400
Subject: Re: [PATCH 5/5] ar9170: update Makefile, Kconfig and MAINTAINERS
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
In-Reply-To: <200903212311.49348.chunkeey@web.de> (sfid-20090321_231155_795243_87D9F561)
References: <200903212311.49348.chunkeey@web.de>
	 (sfid-20090321_231155_795243_87D9F561)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-7VCzLTvXnQTGulA9vH+1"
Date: Mon, 23 Mar 2009 15:29:11 +0100
Message-Id: <1237818551.6147.15.camel@johannes.local> (sfid-20090323_152933_819941_BB0291E1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7VCzLTvXnQTGulA9vH+1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-03-21 at 23:11 +0100, Christian Lamparter wrote:

> +config AR9170_COMMON
> +	tristate "Atheros AR9170 support"
> +	depends on WLAN_80211 && MAC80211 && EXPERIMENTAL
> +	help
> +	  This is common code for AR9170 based devices.
> +	  This module does nothing by itself - the USB/(SPI) frontends
> +	  also need to be enabled in order to support any devices.
> +
> +	  Say Y if you have the hardware, or M to build a module called
> +	  ar9170common.
> +
> +config AR9170_USB
> +	tristate "Atheros AR9170 USB support"
> +	depends on AR9170_COMMON && USB
> +	select FW_LOADER
> +	help
> +	  This is a driver for the Atheros "otus" 802.11n USB devices.
> +
> +	  These devices require additional firmware (2 files).
> +	  For now, these files can be downloaded from here:
> +	  http://wireless.kernel.org/en/users/Drivers/ar9170
> +
> +	  If you choose to build a module, it'll be called ar9170usb.
> +
> +config AR9170_LEDS
> +	bool
> +	depends on AR9170_COMMON && MAC80211_LEDS && (LEDS_CLASS =3D y || LEDS_=
CLASS =3D AR9170_COMMON)
> +	default y
> diff --git a/drivers/net/wireless/ar9170/Makefile b/drivers/net/wireless/=
ar9170/Makefile
> new file mode 100644
> index 0000000..3f0e468
> --- /dev/null
> +++ b/drivers/net/wireless/ar9170/Makefile
> @@ -0,0 +1,5 @@
> +ar9170common-objs +=3D main.o cmd.o mac.o phy.o led.o
> +ar9170usb-objs +=3D usb.o
> +
> +obj-$(CONFIG_AR9170_COMMON) +=3D ar9170common.o
> +obj-$(CONFIG_AR9170_USB) +=3D ar9170usb.o

I think it would make sense to link them into the same module as long as
we don't have a second user of the common code. I actually doubt we will
see a second user of the common code at all, even if it is in theory
possible with the hardware design.

johannes

--=-7VCzLTvXnQTGulA9vH+1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJx5y0AAoJEKVg1VMiehFYwskQAIeiC4YGY+f9hn20QkZm2fH5
Um4MvgFhhn8ngZwKVj92wXvHfLKTbBJAoirl+HFotQ6WtXg1JUZgaFxRFc/uA/ft
6I3AhDPjOVOzQgMnNXIWWi+kR7YxSEoHq86eGKs32EZZW4xKwozLXqb2EEq3zf9i
CX8vdBDWthkGN9DDj2ZStZg7cKwbnI5RwUI5awrOxuStAZX1mnMPHdzHHKQwgowF
BXhYg3ykRfoAnmKwOm9znbCpaUR0ZPpMnVlfB4sMTT5yya7cZgwbPhHb8VMBwty1
ooHB7gn8Hf5DKglRrv+m2Fwu9ZhCOeuDHMxiFrKZ+ew2LtQblNmEo5USNM+V+U3e
jIDE8wGjpuQArieSIRU5mEN3D9oxFDqHQKuHtjv7i7rZUTDyqCrSfwdj3x+5VYY6
nZfOA/FxYu11LLWX2H90HGIjtWNL1cwFHAGEuv2GXZOaXBRVcO3edpxpFwj3vGLG
yJDCHxrlCA9as73mVtdK0vgWsuK5NwKVvmMX7g3L36yfx8TojuuC6UtrcSetjeEP
piuOv/Or9SucYkeFGATzYfrKZmqY34N+okLE/K9qvCjP9ycyY5jNeoH5vxbWIX0D
aA+WiTG50rxPl2+rpPHngOOtXOnVXw4R/cAAQPa94BXk0DvXGIu7EkceaPXNWjUF
l8oD1zonGSdaXlB3Wtnq
=mbmM
-----END PGP SIGNATURE-----

--=-7VCzLTvXnQTGulA9vH+1--

