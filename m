Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36774 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbYGDMZN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jul 2008 08:25:13 -0400
Subject: Re: [PATCH 4/4] rt2x00: Report RX end time for rt2400pci
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linville@tuxdriver.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
In-Reply-To: <200807041425.00591.IvDoorn@gmail.com> (sfid-20080704_141900_848972_FC3E76EA)
References: <200807041340.28103.IvDoorn@gmail.com>
	 <200807041341.57998.IvDoorn@gmail.com>
	 <1215171723.19862.4.camel@johannes.berg>
	 <200807041425.00591.IvDoorn@gmail.com>
	 (sfid-20080704_141900_848972_FC3E76EA)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9a3K42siO5RD864aTG6a"
Date: Fri, 04 Jul 2008 14:23:53 +0200
Message-Id: <1215174233.19862.8.camel@johannes.berg> (sfid-20080704_142516_861612_C42F4B39)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9a3K42siO5RD864aTG6a
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-07-04 at 14:25 +0200, Ivo van Doorn wrote:
> On Friday 04 July 2008, Johannes Berg wrote:
> >=20
> > >  	rt2x00_desc_read(entry_priv->desc, 0, &word0);
> > >  	rt2x00_desc_read(entry_priv->desc, 2, &word2);
> > >  	rt2x00_desc_read(entry_priv->desc, 3, &word3);
> > > +	rt2x00_desc_read(entry_priv->desc, 4, &word4);
> > > =20
> > >  	if (rt2x00_get_field32(word0, RXD_W0_CRC_ERROR))
> > >  		rxdesc->flags |=3D RX_FLAG_FAILED_FCS_CRC;
> > > @@ -1106,6 +1108,7 @@ static void rt2400pci_fill_rxdone(struct queue_=
entry *entry,
> > >  	 * The signal is the PLCP value, and needs to be stripped
> > >  	 * of the preamble bit (0x08).
> > >  	 */
> > > +	rxdesc->timestamp =3D rt2x00_get_field32(word4, RXD_W4_RX_END_TIME)=
;
> >=20
> > You really should extend that, like this it's going to cause trouble as
> > soon as it has overflowed 32 bits once.
>=20
> Ok, but if I do the get_tsf() callback, to grab the upper 32 bytes of the=
 timestamp,
> you will get the same problems during wraparounds, because the upper 32 b=
ytes
> can be from _after_ the wrapround while the lower 32 bytes from the descr=
iptor
> are still from _before_ the wraparound.

You mean bits. But no, it's not a problem, you can safely assume that
you call get_tsf() within 2^32 usecs of getting the frame (that's quite
a long time after all).

Then do something like this:

ts =3D word4
high32 | =EF=BB=BFlow32 =3D get_tsf()

if (ts >=3D low32)
  // wrapped around while we were not looking
  high32 -=3D 1

tsf =3D high32 | ts

johannes

--=-9a3K42siO5RD864aTG6a
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIbhZUAAoJEKVg1VMiehFYkBUP/jzyhWYZuqEftWHUFlqtbCWM
B+gxgtqKE2tyiItJlh79s+fbqyvU+rHyp0s+B8HK3XCQq9LrnJbuJSbo7ZcMyZ6O
GAn+nARKzHPs1rLhkfFbWCeJeSN/YQstml1sR9TtijKcvNC8Yb+5yOlbY+K+uhYV
OXorS47zq/sVp29myadRDZ4Fqjoz501sosP9Fs3duWXBrzXgP2zdeLkQyGoptRB2
IN0FPvd6M6n0cewUSgdlwun3bitktNHgbp0891maWtgW9piDuVX2827lLVVj0AxJ
nfKnb+Ao/K7YaszdFtte2bXa6iLNyh4JIYDUg9A/0IXCF1dOvdbjAC0R3Srivqe3
QbwF+GatVmw+GuGQNHxBNbCydfQrKz8vnFxYE7oeDWWnUMV07q390kidvVfB2/1N
JfV+1jRWbx9xkpcNT8E9WtOLT/FAVR/Eep0TC4KAK5nS6dyzhFSG5Jl16nbbmUb7
6Fx7V6z7qRTCoP36EZ8mKTmH6xYQ/P4DaPS0ve0YyqcpgZ7IQ/QaDoOGHgoA83Bu
dGbYgHO2XW9i1DhQk8WS755rKXJa4EHl5ABXFn+7WE2rUBGHbRlc0/ZXVSegJsPU
quNIhXVCa+6tkIj6gsgSxfz+ul34uUmCeoeLXMISTMjVC192TPfoRa/rDRRCC8uG
oF/QraACDgsr6RqcknF0
=eyhB
-----END PGP SIGNATURE-----

--=-9a3K42siO5RD864aTG6a--

