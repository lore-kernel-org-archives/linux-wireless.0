Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54830 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298AbYEQJMe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2008 05:12:34 -0400
Subject: Re: [RFC-PATCH] mac80211: add helpers for frame control tests
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1210981687.5915.67.camel@brick> (sfid-20080517_014812_097664_2D7947A4)
References: <1210966154.5915.50.camel@brick>
	 <1210966704.5915.51.camel@brick>
	 (sfid-20080516_213833_934385_1E372539)  <1210969866.6381.46.camel@johannes.berg>
	 <1210971848.5915.58.camel@brick>
	 (sfid-20080516_230412_000613_CA74646C)  <1210972335.6381.52.camel@johannes.berg>
	 <1210975040.5915.63.camel@brick>
	 (sfid-20080516_235723_605932_ED6BE89E)  <1210975426.6381.70.camel@johannes.berg>
	 <1210981687.5915.67.camel@brick> (sfid-20080517_014812_097664_2D7947A4)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-chC4uH1Kflr/1MHPoGuH"
Date: Sat, 17 May 2008 11:12:20 +0200
Message-Id: <1211015540.3827.8.camel@johannes.berg> (sfid-20080517_111251_617961_EB7BD2B0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-chC4uH1Kflr/1MHPoGuH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > > Ahhh, I see what you are getting at now, how about ieee80211_stype_ma=
sk?
> > >=20
> > > That makes the & a little clearer and has better semantic meaning.
> > >=20
> > > The other option is still to call it stype_mask, but change it to
> > > return a __le16....so tests against !=3D 0 still work and really
> > > is just a wrapper around the byteswap of the constant and the &.
> >=20
> > Hmm. I'm not sure, how is all this really used? It seems you want
> >=20
> > ieee80211_has_qos_stype(hdr)
> > and
> >=20
> > ieee80211_has_stype(hdr, stype)
> >=20
> > instead, no?
>=20
> Just the latter I think.  But I'll do a few patches to see how it looks
> first.  If there end up being a few common ones (like qos) a few
> short-hand versions might be appropriate, I'll see how it goes.

Yeah but I was thinking of ieee80211_stype_is() or whatever you want to
call it (I think I actually like it that way around better than
is_stype/ftype) to check the exact match of the four bits, i.e.=20
	fc & stypemask =3D=3D argument

and the QoS one check that the bit is set.

johannes

--=-chC4uH1Kflr/1MHPoGuH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASC6hcqVg1VMiehFYAQJVwRAAxPqX9L+12k/pQAovdjuNBYkl1rUiCWoI
8vzQyfnKP7qNir4ek/C8Hs0jllOklGngYl04sBQZadLR2KbgMJGqo6I9u7ODapFA
EQ+jfXTK8znQoKQGZX5SUw93N4EvT5QcPqGYmdu5suwBSivETB2HCaGZcRDrpWHC
+jyBOI0PO/OGgIhzH276yk1TA49i8PdutVs/szGR3FikR+JwIAhHGX6hPYMvpIZl
eT3u1I0MDsGDQWl11MoBD2W9O/MRhual6YxK5vxCp5j/QZuiezcOv9IRE21G56fA
EA/dnmffA4FZXN0mAS120hlKc8GG4hrdQhEiOo4ZDrMnVqonuVBWD2u4hJuD4WIm
l98t6n6YoI9qMzkXihL61YESO3Q4AqCu0f7WZqLhYlTZAylGxU4Sj1nLHEkERjGi
whb/jYXim7386lbGNq45qR9BMCauNvWJv3TviwavuJplY7xMGBHJWwLfhwaJNanq
gwtfrkCTvREPT4Su5Wu0OnAFNIWBaeuy5vRb0ph5U1+PUkaHB0S+Dgd3kgDz4xpp
5+Mw5SR4rzQw6syqDVuhBMevx30uZj9D1U8eD8glko6ERh981fgOQu1Gftf5U/um
cH32RjTfAkFk0xMWjx5AXTrLx1baFt6uiOKtH0ovOHAw9OEVpwVJkd3tebR8hiWN
3Kr98XbGfKg=
=z47W
-----END PGP SIGNATURE-----

--=-chC4uH1Kflr/1MHPoGuH--

