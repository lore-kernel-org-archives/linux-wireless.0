Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40166 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320AbXKWV4b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2007 16:56:31 -0500
Subject: Re: [PATCH] b43: include FCS in frames handed to mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1195849664.4149.160.camel@johannes.berg> (sfid-20071123_202751_471966_3DB802BA)
References: <1195814776.4149.90.camel@johannes.berg>
	 <200711231451.58564.mb@bu3sch.de> <1195849664.4149.160.camel@johannes.berg>
	 (sfid-20071123_202751_471966_3DB802BA)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-leM4EBF0sVt0z61K7Klj"
Date: Fri, 23 Nov 2007 22:56:25 +0100
Message-Id: <1195854985.4149.177.camel@johannes.berg> (sfid-20071123_215634_348585_AB4AE33F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-leM4EBF0sVt0z61K7Klj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Fri, 2007-11-23 at 21:27 +0100, Johannes Berg wrote:
> > > --- everything.orig/drivers/net/wireless/b43/xmit.c	2007-11-22 23:36:=
05.668676810 +0100
> > > +++ everything/drivers/net/wireless/b43/xmit.c	2007-11-22 23:36:22.66=
8677190 +0100
> > > @@ -489,7 +489,6 @@ void b43_rx(struct b43_wldev *dev, struc
> > >  	}
> > >  	wlhdr =3D (struct ieee80211_hdr *)(skb->data);
> > >  	fctl =3D le16_to_cpu(wlhdr->frame_control);
> > > -	skb_trim(skb, skb->len - FCS_LEN);
> > > =20
> > >  	if (macstat & B43_RX_MAC_DEC) {
> > >  		unsigned int keyidx;
> > >=20
> > >=20
> > >=20
> > >=20
> >=20
> > Does this work with all encryption and non-encryption modes?
> > There was a crypto related reason why we snipped off the FCS.
> > Maybe that's gone, though.
>=20
> Yeah there was but to be honest I couldn't think of the reason any more
> and I can't see one here because right afterwards the only thing we do
> is hand the frame to mac80211.

Ah, I remember now. We were doing "device hides WEP" and snipped off the
ICV so didn't want to move around the FCS.

johannes

--=-leM4EBF0sVt0z61K7Klj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0dMiKVg1VMiehFYAQIErhAAqXDEXehkys0zkK/OWfyooT9br4MBiqUA
oJJ10yaSLh6cqGxFaO7NKlXVOCBiNNueMkLVWCoV7j/bFbgEn5fQtOpdYRoyGrvf
v9X6/7UrfFVw4F0uDrdaM/0jmP7K9ZZRzoZreU2AFUQMVniFbDZCHlWw3qkoFExk
QQNu7COeOqBm6qESB8ipSmvOoNHPWvuXdlYmprwuitKdP0h5dGdhIOrgYMaYlz+T
DxvK987w5mhuGluPAho4t8UpEidmDkSIPoLvpKBVmy5OZh0AlZLitPQpUxrbiO/w
cEcfWpow38V7/UTqncAr1qerl2FTSl2jBYnCqmUAnl3i+zBLqdOcfH4SzwKHKRX2
Ja2jXMSdZ6Wnbn1aZW2A38WBldVQER0DZ8qfWPBGPxoV3uiQUZaIRjdNVbpoxr3d
+pqiUz/xkRNBy9c6lFjd031GS9O5ijD1YZ9IbLQHrwWX6Gp1kQ9X+JXWrPxRwTU6
52xk1sHIsTjFSVj4dXzPXvlhFDLG6T5VY9rukXCAflvcljfC4gedQ6BqSDm7X0yE
PHpxeC6Y0Li9Q/DJ+zQYmUkrK8v/lITdojrP3lnICtWrfpIEUXzVosSqwblEb3N4
nBSVCGdTTPWwz0wYNuIlHRAoY2iH6O0Mp/4hDgMplnEcj2YWeuOdJHxv614J7bzv
4D0a9KHbH0A=
=R745
-----END PGP SIGNATURE-----

--=-leM4EBF0sVt0z61K7Klj--

