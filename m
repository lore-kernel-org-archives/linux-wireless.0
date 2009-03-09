Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35511 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbZCIOuH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2009 10:50:07 -0400
Subject: Re: [PATCH] mac80211: handle failed scan requests in STA mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <200903091547.09223.helmut.schaa@gmail.com> (sfid-20090309_154751_798473_51238D7E)
References: <200903091547.09223.helmut.schaa@gmail.com>
	 (sfid-20090309_154751_798473_51238D7E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7z/oqsO6QtC821G/UqnD"
Date: Mon, 09 Mar 2009 15:50:00 +0100
Message-Id: <1236610200.4205.82.camel@johannes.local> (sfid-20090309_155028_768125_3392C4B0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7z/oqsO6QtC821G/UqnD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-03-09 at 15:47 +0100, Helmut Schaa wrote:
> If cfg80211 requests a scan it awaits either a return code !=3D 0 from
> the scan function or the cfg80211_scan_done to be called. In case of
> a STA mac80211's scan function ever returns 0 and queues the scan request=
.
> If ieee80211_sta_work is executed and ieee80211_start_scan fails for
> some reason cfg80211_scan_done will never be called but cfg80211 still
> thinks the scan was triggered successfully and will refuse any future
> scan requests due to drv->scan_req not being cleaned up.
>=20
> If a scan is triggered from within the MLME a similar problem appears. If
> ieee80211_start_scan returns an error, local->scan_req will not be reset
> and mac80211 will refuse any future scan requests.
>=20
> Hence, in both cases call ieee80211_scan_failed (which notifies cfg80211
> and resets local->scan_req) if ieee80211_start_scan returns an error.

This patch looks good.

> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> ---
>=20
> It just happend to me that after rf-killing iwlwifi wpa_supplicant trigge=
red
> a scan (which was accepted by mac80211 as it is not rfkill aware yet) whi=
ch
> failed in iwlwifi and left cfg80211 in a state where it won't accept a ne=
w
> scan request even after unkilling the radio again.
>=20
> Johannes, do you think it is worth to add something like a scan watchdog =
that
> triggers after 30 seconds to cfg80211 and prints "scan request failed", c=
ancels
> the scan request and notifies user space?

But I don't really think it's worth doing that.

johannes

--=-7z/oqsO6QtC821G/UqnD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJtSyWAAoJEKVg1VMiehFYFQkP/1JhT+xiqGnJbZJsYb/AGn4I
vTgBXM3ulvRgfjonF8ABARZ4KxpV0IAlNORpP2zpxmXcbp9BUVi19MFXYhgUO6L7
y0W2nO4gsrPGNAV1aVBzDfAuD/tggfxcS8Vb/I9/YqtyHTQLUQfbq+mUEAg0nq8u
EUe/jIWYm4PfBfgm+ISWbRdCqRAxi/++7+8H1JC+Tcuyxrb4RaNG7H+NNEnLTh1T
nUU/PEjr0kSfn7FpwNQ6Ymc7v/HEjXyBSMD2n423lVXHHnBtq55PuSL1KwHWp6MH
J3jRQMCExLZ+Iq3NdV5N0DZYm4KI8S7e4u59K4awqsOkw62Uzb5n5+VVNR1+/yvY
f71Jdv96HE+2BjaLHPj+fStfTLXgJsQyIXR4rtcqKJRl+vOddO44PDJ9toR5boh1
FJvrGMNnQ92g+keHcxdFELug790Sy6aPI7q0iiYzb3TSZ20RBP0LCZs1DzFlfX5K
SzvzvF+hmp8k3uu3QjS58xpN7JszO6ymAeqbRiVH9vJ1QIaxYQJpmQbmmJYjmOl9
Dp6YNybSb78Ev3zU5hXQELjwp/YWXe3bFeERT6RigimZuE/BXaxoS/BJJfzAM2I7
r3gGodnQF9nSszeepvE1ThVkZGx4PktlbNxVGEAOuxLqgkjz8APszk4OkxISe0Bo
5e70w3TN5Q+Gt32PUB5I
=3KUS
-----END PGP SIGNATURE-----

--=-7z/oqsO6QtC821G/UqnD--

