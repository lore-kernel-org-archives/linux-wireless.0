Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36674 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757443AbXKWU1s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2007 15:27:48 -0500
Subject: Re: [PATCH] b43: include FCS in frames handed to mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200711231451.58564.mb@bu3sch.de>
References: <1195814776.4149.90.camel@johannes.berg>
	 <200711231451.58564.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sBVSq6iMBL9qOBbUomeb"
Date: Fri, 23 Nov 2007 21:27:44 +0100
Message-Id: <1195849664.4149.160.camel@johannes.berg> (sfid-20071123_202751_471966_3DB802BA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sBVSq6iMBL9qOBbUomeb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > --- everything.orig/drivers/net/wireless/b43/xmit.c	2007-11-22 23:36:05=
.668676810 +0100
> > +++ everything/drivers/net/wireless/b43/xmit.c	2007-11-22 23:36:22.6686=
77190 +0100
> > @@ -489,7 +489,6 @@ void b43_rx(struct b43_wldev *dev, struc
> >  	}
> >  	wlhdr =3D (struct ieee80211_hdr *)(skb->data);
> >  	fctl =3D le16_to_cpu(wlhdr->frame_control);
> > -	skb_trim(skb, skb->len - FCS_LEN);
> > =20
> >  	if (macstat & B43_RX_MAC_DEC) {
> >  		unsigned int keyidx;
> >=20
> >=20
> >=20
> >=20
>=20
> Does this work with all encryption and non-encryption modes?
> There was a crypto related reason why we snipped off the FCS.
> Maybe that's gone, though.

Yeah there was but to be honest I couldn't think of the reason any more
and I can't see one here because right afterwards the only thing we do
is hand the frame to mac80211.

johannes

--=-sBVSq6iMBL9qOBbUomeb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0c3v6Vg1VMiehFYAQIy1Q//XoqUOFJ1xceIsG/+Kf76neP1JihyiCWs
wRqUFvjKy3IKTdgF78D39M01VGyeFlZ+k89mxqUVyLIYRP6tDn2HQ03IXGgCWSUp
eW4OFMTH1fR+sMAwhJJ3lurvjDlD2x7N+ciQVc6u7aO+HPHuX6wqtr9POjxNvZdN
B78xRnUxmQuDIoymI1KwPxm29ULJCtke2FMutlyzIftIo+C+GKa4Er9XbCwUilgj
Gjx0SV0JMp4u6+Q2Rhu/a9sKkkJysbDuEZ/SZh4YbApDQNdRZ4F8HfORh5S7rqmp
d/E+225Pdq50HPB7TWx/hxoRCrgsYJAS3s5XNRvE/2wlexdzgAeDP2YMeihBLmSu
nK1TcwK1IFOw//z09YaSW6LOkKJFX4Fuqu7iPOlbYcLEF4zI73pdwd/nf0Lzw0mJ
JiyTWzhEJwRJaMIkxHvc2KPSO78kRLGK/XbTWqM+YVEbZRj7I3SwalZ3+BCqvAQE
OcsGZhjQIQp3Mz7mkNF08yBLiebKNepXxlRZW21TMJxHs+9CspksW1IHQOB5BJ2Q
UEvYsQ9uwCcLZnxok54Vx4eakcWZ1WP6ydzTqn06JFdgYtb6cD2O7dA7X/ww33Kx
5dnfTundvkkHRV+6EJlLamZmxWAmCx70OStbgzYJS0mU6aArjDEI1IohUYF8SZXE
jV3UNeNi6Pw=
=Dt9l
-----END PGP SIGNATURE-----

--=-sBVSq6iMBL9qOBbUomeb--

