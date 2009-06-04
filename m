Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48587 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbZFDGTt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2009 02:19:49 -0400
Subject: Re: [PATCH] cfg80211: fix Kconfig for users of cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Dave <kilroyd@googlemail.com>
Cc: John Linville <linville@tuxdriver.com>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Samuel Ortiz <samuel@sortiz.org>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
In-Reply-To: <4A26CBD3.8050009@gmail.com>
References: <1244046631.4862.34.camel@johannes.local>
	 <4A26CBD3.8050009@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tIdNzemTRn5YZhIJLrH6"
Date: Thu, 04 Jun 2009 08:19:41 +0200
Message-Id: <1244096381.22576.8.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tIdNzemTRn5YZhIJLrH6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-06-03 at 20:15 +0100, Dave wrote:
> Johannes Berg wrote:
> >  * iwm doesn't depend on cfg80211 or wireless extensions
> >  * rndis wlan selects cfg80211 - needs to depend
> >  * mac80211 selects cfg80211 - needs to depend
>=20
> Hmm. Consider:
>=20
> 1. User using a rndis_wlan device on old kernel with cfg80211 unselected.
> 2. Upgrades kernel with make old_config
>=20
> Result: the rndis_wlan driver is no longer configured to build.
>=20
> I don't think it's a big issue, as you can reconfigure and rebuild as
> soon as you realise. But you may have to 'realise' without google access.

Yeah, I know that can happen. That's why I added the note that gets
displayed if you _don't_ have cfg80211 instead of mac80211 when it can't
be selected. I don't think it's a huge issue.

> The only reason I'm thinking of this is because orinoco may be in the
> same boat shortly. Ditto other wireless drivers as they get converted.
> So I had a play with Kconfig. How about something like the patch below
> instead?
>=20
> cfg80211 should just get autoselected in the most appropriate mode, and
> drivers get the same restrictions as cfg80211. The option setting
> appears to work fine, but I haven't done any build testing.
>=20
> It might be possible to chain things like this, so mac80211 could be
> done in the same way. But I guess we wouldn't want too much of this
> going on...
>=20
>=20
>=20
> Dave.
>=20
> ---
> diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
> index a67d292..9038bd6 100644
> --- a/drivers/net/wireless/Kconfig
> +++ b/drivers/net/wireless/Kconfig
> @@ -333,11 +333,12 @@ config USB_ZD1201
>  config USB_NET_RNDIS_WLAN
>         tristate "Wireless RNDIS USB support"
>         depends on USB && WLAN_80211 && EXPERIMENTAL
> +       depends on CFG80211_AS_MODULE
>         select USB_USBNET
>         select USB_NET_CDCETHER
>         select USB_NET_RNDIS_HOST
>         select WIRELESS_EXT
> -       select CFG80211
> +       select CFG80211_USED
>         ---help---
>           This is a driver for wireless RNDIS devices.
>           These are USB based adapters found in devices such as:
> diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
> index 9cbf545..2de2bd8 100644
> --- a/net/mac80211/Kconfig
> +++ b/net/mac80211/Kconfig
> @@ -1,12 +1,14 @@
> +# If cfg80211 has to be configured as a module, so do we
>  config MAC80211
>         tristate "Generic IEEE 802.11 Networking Stack (mac80211)"
> +       depends on CFG80211_AS_MODULE
>         select CRYPTO
>         select CRYPTO_ECB
>         select CRYPTO_ARC4
>         select CRYPTO_AES
>         select CRC32
>         select WIRELESS_EXT
> -       select CFG80211
> +       select CFG80211_USED
>         ---help---
>           This option enables the hardware independent IEEE 802.11
>           networking stack.
> diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
> index 4428dd5..d3f08c4 100644
> --- a/net/wireless/Kconfig
> +++ b/net/wireless/Kconfig
> @@ -1,6 +1,23 @@
> -config CFG80211
> -       tristate "Improved wireless configuration API"
> +# Selected by drivers which use cfg80211
> +config CFG80211_USED
> +       tristate
> +
> +# Is cfg80211 restricted to being a module by its dependencies?
> +# Drivers must depend on this so they inherit the restriction.
> +#
> +# Careful: m means that CFG80211 is restricted to being a module
> +#          Both n and y mean there is no restriction
> +config CFG80211_AS_MODULE
> +       tristate
>         depends on RFKILL || !RFKILL
> +       default y
> +
> +# Avoid presenting a UI option so we inherit the value of CFG80211_USED
> +# If one driver is set to m, and another to y, CFG80211_USED will be y.
> +config CFG80211
> +       tristate
> +       depends on CFG80211_AS_MODULE
> +       default CFG80211_USED

Doesn't that mean you cannot ever select cfg80211 by itself? That's
kinda strange too.

johannes

--=-tIdNzemTRn5YZhIJLrH6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKJ2d6AAoJEODzc/N7+QmaW/QQALROiCBF0xkbXx5jZTEMN7nR
5ULJr8U9Ba6pTPo0EfvHmX8FhbuLykjZvNmamui/YbJAAsudFyuJ8aN/zOSced4Y
u4UEm4FHqfBa10aDgmUCJBa45o0a7Gb4TQt0r8LasKx7571kfX0HdzmoqHOk6lXp
WCYIdQnluxdKVNB+raJy8jpY71/Om1oUkTTrWNMVmng4gNSx5GUHYvDOSBQkdfKD
Ia4WIivqQmyKvRloB5fgMqlsdBuEBhAXaqAYmTeXLD/7TgzPyCOgCTM/QNg97dOA
5PAx2uUxno4r+7C6hVgvC5cR4iRXtE+2XX7Nw2XGSzNaVdkJmMa+lkIn1JKgywzn
95TT1L9NLCa36wiQg6f8br8/91oo0wE+5DuxkomP90WJobtK22FZRjTw1wwG+d4y
fSgq//ZC/rjrQvh1GAkHyOBfd0Z/3VFxCDKeMIXQHTCsgzaXiB6p9LZ0uiWhw2Xf
F5LvFvG5kH/ZKAMgKv/V06KidtlZu9eyebjylMBmJsKUi2fp3ZEDx74BgFiuVIjq
8GL5kd+HX7Y/0W4zqc8d6P8ZXw4RKTMUFAMmN16irH/OmreF8TRjdv0tyWAYLTk7
XISzh4/HU8NvzbdsVU2oFGeE+RdTHXpS5IeH1uqWsetbMmXXcLx83JrOMvn6Hfpc
q/rJDysMHo9O+4E34Q5r
=57J6
-----END PGP SIGNATURE-----

--=-tIdNzemTRn5YZhIJLrH6--

