Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57409 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbZGaHpz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 03:45:55 -0400
Subject: Re: [PATCH] cfg80211: fix regression on beacon world roaming
 feature
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
In-Reply-To: <1249001028-15110-1-git-send-email-lrodriguez@atheros.com>
References: <1249001028-15110-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-EiMOLjD9GF40O341Dolu"
Date: Fri, 31 Jul 2009 09:45:24 +0200
Message-Id: <1249026324.29587.15.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-EiMOLjD9GF40O341Dolu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-30 at 17:43 -0700, Luis R. Rodriguez wrote:

> By doing so though we also disallowed beacon hints on devices
> registering their wiphy with custom world regulatory domains
> enabled, this happens to be currently ath5k, ath9k and ar9170.
> The passive scan and beacon restrictions on those devices would
> never be lifted even if we did find a beacon and the hardware did
> support such enhancements when world roaming.

I dislike this solution, it just adds proliferation of possible
behaviours. Can't those devices just set the _flags_ in their reg
notifier, and clear the corresponding bit in the orig_flags?

johannes

--=-EiMOLjD9GF40O341Dolu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKcqEQAAoJEODzc/N7+Qmadi0P/ihFU8IUG+7kazXvaHMEp5nM
XNjgeh1VnDI4uliNcGfudqbSi82lMm6LjMdhNLxcn7gwT8xtYAne+26pIxT83LwM
zsFe1lHd36LwuI3CgnzRKhSvwuutFVeNv9wygZsfSVCHWTk000/Us+ABfNoUuwBQ
0RrHCOKvRZuO3nhQJ5CEuAX2iHVDjNvnmUcNEGZ8jmbk0FODtOw8SsHxhIcCrt03
0CcS3PAqbf2AgYC89GDNnGqcGR3W4Iko4OAHoKB4QSR+iQ5F5sxe7UYyJ2AkOl8G
ZomHW3uWFuGDrXRfUojElWnum0XotLVHQaJicJA2sD4Ysb/jLEAGeBiGzAY4tIN9
42baJtr1aOJeXxT7RsR/0GrYg+/K2lOuVIfzvalskm9sK4pXL1LOzZ1tFzYHnsK0
JMI8Q+VMBnW7P9bWMqFDxdVkb4b6o1l5tnBgNXmFMMAKKsD0OYpcjXu5Jrc2DEhP
bjs+X3WQcJqLkyBanOjCJiQ8st99EWJZ8rnRwvbNb35mLc+mExZZgXydSJ2odMvZ
wgU1LgfhsB1TDnSOMi+hyaw4M6blPY+DOXFYrNp3Aj/2LFLfCmR09skF8o0ADOLq
ekTIuPr7vXDbgPotRKgyqzcxZj1TixeLXpyeg35IINvB6megNsEiD0aBTzE2YW08
zwl/Li7oVNoCUkovw2cI
=Bzfx
-----END PGP SIGNATURE-----

--=-EiMOLjD9GF40O341Dolu--

