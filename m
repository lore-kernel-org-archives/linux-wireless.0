Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43874 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963AbZIQCFU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 22:05:20 -0400
Subject: Re: Re[2]: 2.6.25 kernel & compat-wireless-2009-09-14
From: Johannes Berg <johannes@sipsolutions.net>
To: Nikolai ZHUBR <zhubr@mail.ru>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <142272111.20090917060119@mail.ru>
References: <191513177.20090917035628@mail.ru>
	 <43e72e890909161654x141f48e4q54f0526bf6c04ea3@mail.gmail.com>
	 <142272111.20090917060119@mail.ru>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-DxWxdwqIH9LRI6/8AHwT"
Date: Wed, 16 Sep 2009 19:04:48 -0700
Message-Id: <1253153088.9450.10.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DxWxdwqIH9LRI6/8AHwT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-09-17 at 06:01 +0300, Nikolai ZHUBR wrote:
> Thursday, September 17, 2009, 2:54:28 AM, Luis R. Rodriguez wrote:
> >> device_add in 2.6.25.20 wants some bus_id, but bus_id seems to not
> >> be assigned anymore, so device_add fails. Therefore, wiphy_register
> >> fails, and then clearly ieee80211_register_hw fails too.
> >>
> >> Any ideas how to properly fix this?
>=20
> > FIgure out what the bus_id is used for first.
>=20
> Hmm, don't know, but the following helps and wlan0 appears:
>=20
> --- everything.orig/net/wireless/core.c 2009-09-16 23:45:40.000000000 +04=
00
> +++ everything/net/wireless/core.c      2009-09-16 23:48:22.000000000 +04=
00
> @@ -350,6 +350,7 @@
> =20
>         /* give it a proper name */
>         dev_set_name(&rdev->wiphy.dev, PHY_NAME "%d", rdev->wiphy_idx);
> +       snprintf(rdev->wiphy.dev.bus_id, BUS_ID_SIZE, PHY_NAME "%d", rdev=
->wiphy_idx);

Isn't that exactly what dev_set_name() is/was supposed to do?

johannes


--=-DxWxdwqIH9LRI6/8AHwT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKsZk8AAoJEODzc/N7+Qman/YQAKo85z+C3ml+6RhYxF2t5/xH
y8ZE9waNo+AaMSEq5K9OCRMSyr0l1TOx4tmppopz0Qs+VaSdCmSu6yOqMH09mSip
YoUSWr3Nvh0c5PLaGqJpdRvGDbUBhP8rEAGtbSdzbgfTHglJgH6eMFSnu9807TCr
ACm/5RNMducmrFz4w89Tc4C6US0GsNLfkIOqhxYd+ZL0eSMecWD/UIfNQ21+4Hh6
ekC7dEOhtKpOMtyYOjSndQOeMIDIvL//1pp0yUDqochPwbkBCzIrs1HwOh2a4iJ1
UBqOHZAHp9rbxsuoZkLJVwZQ0qlO0LcLGWxMYJZ3bwktvcTWnvSk/gQZPELPgK5w
QV8Gh48uC+qzSocQlMK84h6xZHdvDUnFMqYrH2L2msERacBhayyu3CA7VS/9/OCh
cPbpvgr5GQDJcFYrdF8D8hKSow4JqoAq1jyKok2FsQvgNdwRVXCB/4+kOU/aVvZc
CkU2irJOWVsWrwaDNKMv7J7rhlIoa+skmfTZSnR79KccUoru4heyQtTRV6pn4N9q
U0YA0Yj5Yfz56qhFo2gSTGlGqZ0vy96efQO2M/766TeIsXWnyIv6iP8NpXy+iQxB
sx19BPJO8xaVImSN5ixESZ0UQhXkgratvs/kb6V6BuAXpTPL/hhoWL32cdP8bJ+i
G0c5ewLHvTLd4iqalT3d
=3QUD
-----END PGP SIGNATURE-----

--=-DxWxdwqIH9LRI6/8AHwT--

