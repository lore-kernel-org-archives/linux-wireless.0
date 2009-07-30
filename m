Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44604 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbZG3H6P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 03:58:15 -0400
Subject: Re: [RFT] cfg80211: enable country IE support to all cfg80211
 drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1248915719-6208-1-git-send-email-lrodriguez@atheros.com>
References: <1248915719-6208-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-CVhXs3INGUzoJ5lRNvB7"
Date: Thu, 30 Jul 2009 09:57:42 +0200
Message-Id: <1248940662.8925.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CVhXs3INGUzoJ5lRNvB7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-07-29 at 18:01 -0700, Luis R. Rodriguez wrote:
> Since the bss is always set now once we are connected, if the
> bss has its own information element we refer to it and pass that
> instead of relying on mac80211's parsing.
>=20
> Now all cfg80211 drivers get country IE support, automatically.
>=20
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>=20
> Johill, I think this is what you wanted in the end, I tested it and
> I get no country IE hint going through :( I could debug further but I'm
> done for now and gotta work on some other stuff, not sure when I can
> get back to this.

Well, you've made a critical mistake:

+       regulatory_hint_11d(wdev->wiphy,
+                           bss->information_elements,
+                           bss->len_information_elements);

needs to be

	const u8 *country_ie

	country_ie =3D ieee80211_bss_get_ie(&bss->pub, WLAN_EID_COUNTRY);
	if (country_ie)
		regulatory_hint_11d(wdev->wiphy,
				    country_ie + 2,
				    country_ie[1]);


It's rather likely that it doesn't come first, so whatever is in
information_elements first would end up not looking like a country IE or
having the right length, so the _11d function would just throw it out.


johannes

--=-CVhXs3INGUzoJ5lRNvB7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKcVJyAAoJEODzc/N7+Qmahz4P/0tOrt+hXKVBkx/tYoySkMOw
j76QNgo5sbN0TkbkWIm2NBasHrnUX9JHVAUcKfRrW2g3zqYWQa1Qb+iFLa1opEqi
3IIRKoLNtMSgmzkptoYGWUX8x1bEZl6iak7pCREnvGUMNOvkih0LmJw3G55fQQrc
2WYY7JnekoeyLd6W9fv50RwCYU8cIDL0enOn3lXCvJdwdKP4ru27xOecR9+XBOw8
49zQhmXiT6nHl7gyhUa+7N9Xv0ve2b//EryboYqdvz2xEX1xpLhw7W0mDzEycl1M
JumL/OhO3IDH6AUQwGQ7SJ6vuiOqetU4S+u3DsgD0uj/GBsSp/SPawUiJG2MWNzP
d6ziR+f1lEVHgVOfGxtrrN6FbJras1PwUiLNrDwqtrhVMPDKJEG8YMKzUWNhe0XG
ym63nez4vj5WR3oDwJpEOZo/WIqEJHBTtej9J/Q6l6Fv8bj9i3knd7196v2UebwC
G/3l+PWAtaCydD+kRY6VaB7oXZZLlxplOu83QrwTiVGRPhwOJkO+3N03+ZKw8foH
pYJLPGUvL7WpIfjHJq509HGBjvbQRHz2V4o5wRFKnAXpIoq06sNwe5ukXi0xzPeg
UIM8ha4g89txv1ycXdU1JUxYu7eeWor4jlWK4JmYIhdL3Tu4yX57t7dcHpwPRYmP
HSZeUm0ZJ7mveazzht94
=+XTr
-----END PGP SIGNATURE-----

--=-CVhXs3INGUzoJ5lRNvB7--

