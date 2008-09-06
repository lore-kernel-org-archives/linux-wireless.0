Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58920 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbYIFS56 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 14:57:58 -0400
Subject: Re: [PATCH] b43legacy: Fix failure in rate-adjustment mechanism
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	bcm43xx-dev@lists.berlios.de,
	John W Linville <linville@tuxdriver.com>,
	Tim Gardner <tim.gardner@canonical.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200809062055.51797.mb@bu3sch.de> (sfid-20080906_205617_386457_7E0F455E)
References: <48c2cd1a.pA60sTEK0WsW6wtt%Larry.Finger@lwfinger.net>
	 <200809062041.06035.mb@bu3sch.de> <48C2D185.4000003@lwfinger.net>
	 <200809062055.51797.mb@bu3sch.de> (sfid-20080906_205617_386457_7E0F455E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3xV8Je+u1EmB1dNu/c56"
Date: Sat, 06 Sep 2008 20:57:50 +0200
Message-Id: <1220727470.10102.9.camel@johannes.berg> (sfid-20080906_205800_663562_9AC6FADA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3xV8Je+u1EmB1dNu/c56
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-09-06 at 20:55 +0200, Michael Buesch wrote:
> On Saturday 06 September 2008 20:52:53 Larry Finger wrote:
> > Michael Buesch wrote:
> > > On Saturday 06 September 2008 20:34:02 Larry Finger wrote:
> > >> A coding error present since b43legacy was incorporated into the
> > >> kernel has prevented the driver from using the rate-setting mechanis=
m
> > >> of mac80211. The driver has been forced to remain at a 1 Mb/s rate.
> > >=20
> > > Does version3 firmware have a different bitlayout for the status?
> >=20
> > It seems so. I found this because I was not getting any acks back to=20
> > net/mac80211/rc80211_pid_algo.c. I then reviewed the V3 specs, found=20
> > that bit 0, not bit 1, contained the ack. Test prints confirmed that=20
> > result. With this patch, both my BCM4306/2 and BCM4303 reach the=20
> > maximum rate. With the current code, 54 Mb/s is not as fast as 36=20
> > Mb/s, but at least the algorithm is working.
>=20
> Yeah ok. I just asked, because it seems the _whole_ flags bitfield
> is rightshifted by one (so the other flags are wrong, too. See the
> intermediate flag)

It is, this isn't really a difference between the two but a result of
you shifting it up/down due to the tx status via dma queue vs. tx status
via registers thing.

johannes

--=-3xV8Je+u1EmB1dNu/c56
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIwtKqAAoJEKVg1VMiehFY3akP/RkwIOag92jY0kdAd1PD2jfO
y4jpo0o4melKjNSAlKWRV7A8zJaGyN6T6bXxff+lw4RJE7W4xUjAS88rjcx1m7f/
TqwEAZgaEKScs7DdCOsb7bLd6prfuqn0gCpFmML5Fd1NQ3C2SNvk/QP0bWO4sOEk
g2bfWrTwzOcvUNA/9kJdcHYG5ndqmcJyL7RSulLagpcb0h2WPX+C3VUSddQ/MmgC
8mglb4td7tF50AnvQCsqdmZe+9Wy/1gx6s8+xRs3rKsqbJtGErVCIQghPSn2KDpb
0amSfJdmxnZzBE7KBNZzO+32PsyVzpjuxFFaEIy0NNYe/hrj7+CI2lFG2UJweDZD
+VU9LOwbaeKM4FWfw6rJPVTfovOGmEdAKJhI4Ypl4d2npvh6ICF9uUNb1dfh0miB
UMK2d047a+PliyYouQ92+yh1qUHOoqVzzn7jDk+xpkwLeu7HaoahMJ89fabpJiLm
dRiw/IG/NfvnsPdBQBDZzzPS7zYTuI514xSBpnBOcn5HeTiXca+Lwt282tB1BJuq
W3OnlG5HgNBP8z6+jZDasTBXS+i/Y3t44MwkIF67KoRyoza16Zt+A2YD/uhAQNAA
y5wh+BReYqVp5Nt7l6L4fx7AMKKWtZlY8WeNVkmUJwOjEOlBD8Oyxf9ON0mT8piG
YMKDhrHkxQMLsLUu09I0
=+ssI
-----END PGP SIGNATURE-----

--=-3xV8Je+u1EmB1dNu/c56--

