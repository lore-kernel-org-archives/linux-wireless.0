Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59611 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144AbZB0VD7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 16:03:59 -0500
Subject: Re: [RFC] nl80211: Authentication and association events
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org, Samuel Ortiz <samuel@sortiz.org>,
	Kalle Valo <kalle.valo@nokia.com>
In-Reply-To: <20090226185710.GA22925@jm.kir.nu>
References: <20090218200210.GA13955@jm.kir.nu>
	 <1234988740.4023.51.camel@johannes.local>
	 <20090220192557.GA17914@jm.kir.nu>
	 <1235440527.4455.45.camel@johannes.local>
	 <20090226143758.GB24380@jm.kir.nu> <1235666926.4099.2.camel@johannes.local>
	 <20090226185710.GA22925@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mKlNm58cFlq4Xo55Pcm9"
Date: Fri, 27 Feb 2009 08:47:27 -0800
Message-Id: <1235753247.7426.27.camel@johannes.local> (sfid-20090227_220402_354541_CAC54D87)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mKlNm58cFlq4Xo55Pcm9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

[adding Kalle, Samuel]

On Thu, 2009-02-26 at 20:57 +0200, Jouni Malinen wrote:

> Actually, iwconfig works fine in my current version since it just uses
> the information from same functions that were used in
> net/mac80211/mlme.c. In other words, when I complete association with an
> external SME (wpa_supplicant), iwconfig can still show the BSSID etc.
> info.

Yes, I know, but we really want to move the wext stuff into cfg80211 and
then it won't really work this way any more.

> I'm now able to complete authentication and association in two steps and
> use only nl80211 for it (i.e., no WEXT code needed in driver_nl80211.c
> for auth/assoc/deauth/disassoc processing). The mlme.c changes are not
> the cleanest possible and there are still couple of places where mlme.c
> shows its SME nature by deciding to automatically do something, but
> other than that, this seems to be functional.

Sounds good. I guess we can do things piecewise...

One thing we were saying yesterday is that it might make more sense to
not do assoc w/o auth for those hardware that doesn't support it, but
rather add a new "connect" command instead so the distinction is
clearer. Not sure though.

Couple of thoughts. Trivial one: can the SSID really be 0 bytes as
documented? Does that make any sense?

Another thing I would like to do -- instead of passing this struct:

+struct cfg80211_auth_request {
+       struct ieee80211_channel *chan;
+       u8 *peer_addr;
+       const u8 *ssid;
+       size_t ssid_len;
+       enum nl80211_auth_type auth_type;
+       const u8 *ie;
+       size_t ie_len;
+};

why don't we pass a cfg80211_bss pointer and the IE info? That might
mean that cfg80211 would need to invoke scanning and have a small state
machine, but that seems reasonable. Then we inc the ref on that bss
struct and keep it around, so it stays in scan results too.

We'd probably need to change the event functions to include the BSS
pointer (if we want to allow multiple authentications to be in flight at
the same time) and whether the authentication was actually successful
(maybe we can parse that out of the reported frame).

The result of that is that we can
 * check, in MLME.associate, that we're already authenticated, and do it
   generically in cfg80211
 * keep around the BSS in scan results without having to add some extra
   code to drivers/mac80211 when we start filtering beacons
 * easily tell userspace what's going on

and we can keep around the BSS that we're associated with too for the
same reasons and to verify we're only on one BSS at a time and catch
userspace requesting a second one.

The other upside of this is that drivers will stop working entirely if
they do not provide the proper events, which is good because it means
all drivers will take great care to provide them.

johannes

--=-mKlNm58cFlq4Xo55Pcm9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJqBkcAAoJEKVg1VMiehFYhnUQAMH9Lam3PJJARKPESAZUb9Z8
q1b/2H64Pr8xoxDOQqyHc42ufB1jUUj5L+liJmUyMV80qEOo/270DvR4bdlVctLe
PjNuXgrgzUwEN9QgPVORXHIanG/PbEt2kHtE6Qq4OajE5udPK191vVnug20aDB8F
CGMOgSbkjPu05YKPU0AO2GW4Uh1s6dKKoWywMqAvbNNivoTNweuKRrfnlj3s2pXb
A45Ai8LkqhFZAKChXjJbCuW994RJy1k5NcobHnJ5Phc3OvXS0SUr2Ue5qEvvbHBc
emDDF4zcrAL4jGJ37YGMQdkabLVuKarbdwVahpv+4C+6pRxn6d0SIvkfYExQneGL
l8TRGNg6h7/+4VvBY5lROFNSIT9gubG8BZ+3lnV4TP4nWFClpY/oi6JQrzVIFA8y
xrWzWSi51D1uQkrutQjruSftkWyD1Y+jY0plSf++qDBi5eQu64/M+lFZZQtHPsxA
+JDOVuJmsZLUkYK2co2tdEWEHEEfzWpMSwzDmfAU4vS7f1UlNBeIxSrCn7CEHnDY
zLzSJsbxptzxuzSw873wK8i2oiCoYr4v0fuHmNMcXIAO3EyvkFgpqbN5mrxXlpxZ
2AMTJEgUUi0PGMHDhLaWn93DuTyf9XarIdfcRwOAzLHTLErDIESh8dBqfhJM4qtm
EhEgGw4Hq/thw5tlr58e
=CWiN
-----END PGP SIGNATURE-----

--=-mKlNm58cFlq4Xo55Pcm9--

