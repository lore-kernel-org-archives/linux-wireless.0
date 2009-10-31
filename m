Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45606 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755630AbZJaJZP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Oct 2009 05:25:15 -0400
Subject: Re: ieee80211_tx_status: headroom too small
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Nikolai ZHUBR <zhubr@mail.ru>, linux-wireless@vger.kernel.org
In-Reply-To: <200910310959.43260.IvDoorn@gmail.com>
References: <1094614475.20091030230028@mail.ru>
	 <200910310951.30016.IvDoorn@gmail.com>
	 <1256979370.3555.91.camel@johannes.local>
	 <200910310959.43260.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-+tPSlcVmobla1OWgk/47"
Date: Sat, 31 Oct 2009 10:25:13 +0100
Message-ID: <1256981113.3555.92.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+tPSlcVmobla1OWgk/47
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-10-31 at 09:59 +0100, Ivo van Doorn wrote:
> On Saturday 31 October 2009, Johannes Berg wrote:
> > On Sat, 2009-10-31 at 09:51 +0100, Ivo van Doorn wrote:
> >=20
> > > > Ok. I looked at the problem and it's a very odd problem -- mac80211
> > > > should always reserve enough headroom in buffers it passes to the
> > > > driver. Does rt61pci somehow realloc frames?
> > >=20
> > > It does use skb_push. but will/should always stay within the limits
> > > of rt2x00dev->hw->extra_tx_headroom. Although I just realize there
> > > might be a situation where it needs to align the frame to a 4-byte bo=
undary,
> > > it could exceed that amount. :(
> >=20
> > extra_tx_headroom is set to max_t(driver, mac80211) so that there's
> > always some headroom. This doesn't take into account alignment though.
> > Should we simply add 2 to that value?
>=20
> 4 actually, wasn't there some cases where the header could have an odd
> number of bytes and would require 3 bytes for alignment?

Hm, is there? I thought they changed the 11s draft to no longer have
that.

johannes

--=-+tPSlcVmobla1OWgk/47
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK7AJ1AAoJEODzc/N7+Qmau2wP/i71n16fdAOqU+rq/Ymgz93y
7HCERIE2G2dw9kyBUmz07U1gEaAmcX+LfeEiIyQu2xEqAzaqFRKQKCJbPr40Aa0P
hS7FbyOvFb9rpFTL3E85msLgP7592wlG90sSZSBPrspSfXh/kRVCMfG6PJowwgEC
MvfJNzsGR0pKt2PAqScQlEBdn43SRulBrUF7HWtvH65ClVryHDjO9qqeiA+veFrQ
2mVjCllpM48tV7LsjFCkHhwS9yHTUZhYEeUoTHNDk6LJbzpOTEvADfK1DCEQEkPc
esKbviXnt/qxI0HLp3gSpBzZRIneHlQH3VrzBI+sY/AjZGAR8UirI9A+YR0XVyl0
IpYUNwZFLpdRFjSXe+TjTvCHMA2Nq39JTL4/9x5JUCf2un5oSqxZroVngimrWTYW
yUa++acXMVY0MDPGBjZyOFfSk+q3C6cvcTHxNpcwYXkI3kkwg9ppNXZQat0y9w56
zn5/q2HoSRieP9jBXAAQ0kIwNbsEpXQ+86RqO/Kqthjh2DYJfwSISy97L02xAANa
PgifSSZugjWhGD1mGiEec6ItzVpS3rOxCSI4nR4rqt8zOKVbcAYmEEAVfmz42/1M
EZN5dSvosBtcHjdXACDjBeBz2xP8mgGkQqbMruZWGjsXhnChAwfPeUQCuSDHNekC
KKW3GuPc9Q60uTKdqqVQ
=0RgP
-----END PGP SIGNATURE-----

--=-+tPSlcVmobla1OWgk/47--

