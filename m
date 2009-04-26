Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35361 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbZDZIpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Apr 2009 04:45:12 -0400
Subject: Re: [PATCH RFC] cfg80211: Add ies_allocated check before copying
 ies
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <200904261040.10838.mb@bu3sch.de>
References: <200904252236.34802.mb@bu3sch.de>
	 <1240734752.17781.3.camel@johannes.local> <200904261040.10838.mb@bu3sch.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-6bXlUjPI7adJ10G72cBs"
Date: Sun, 26 Apr 2009 10:45:09 +0200
Message-Id: <1240735509.17781.6.camel@johannes.local> (sfid-20090426_104517_617227_689FDBCB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6bXlUjPI7adJ10G72cBs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-04-26 at 10:40 +0200, Michael Buesch wrote:

> > I think it should simply be:
> >=20
> > >  			size_t ielen =3D res->pub.len_information_elements;
> > > =20
> > > -			if (ksize(found) >=3D used + ielen) {
> > > +			if (!found->ies_allocated && ksize(found) >=3D used + ielen) {
> > >  				memcpy(found->pub.information_elements,
> > >  				       res->pub.information_elements, ielen);
> > >  				found->pub.len_information_elements =3D ielen;
> > >=20
> >=20
> > so that the else branch gets a chance to reallocate if necessary, would
> > you agree?
>=20
> Yeah I first also considered this option, but I thought that the code lik=
es to
> prefer putting the stuff into the "found" tail, if it fits.
> But yes, your fix is perfectly fine. If it was allocated once, it will al=
ways be
> allocated (and grown) from then on.
> It won't shrink the buffer anymore for future ies that are smaller, but I=
 guess that's OK.

Ah, yes, but then the correct fix would be to kfree the allocated IEs
and use the old buffer again, not discard the data :) I don't think it's
worth bothering, the entire structures are usually freed fairly quickly
anyway. Do you want to redo the patch or would you prefer if I sent it?

johannes

--=-6bXlUjPI7adJ10G72cBs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ9B8SAAoJEKVg1VMiehFYVoIP+gNLNmZwsn3Pj1je42zO4y5H
jxFKXioED7BvSLYL5Wqg/GiG7LU/0IFy1+5ZgiMgerXwQksAuCctVT6OnHuNmny0
oDtJjtkvxeA8ri+jSMsNClw5Mb6UO5gDCuwjPT1hrzg/RAheKQYaWY8AXh/KUF4f
10ZfSODlDLvnuzHW4FFvQ7jshK+CdBrrz1ejKZG1Lh54Xuchf8Njnj/oCVzqhRec
aJ1vlkpjVhqvZBWX/v22Kqbe6rKgAr++lmfTlRe8OXgkbAzNp0j8fzMN6XRAHM2f
yFZbYB0DWlSMYF/Njw06ITuqiTIKOVq0Wj7Lj+sOQ1g7DLRGg6oY1VDW60Cdrf3X
dzRBpSNuznJ20W5I1KyJXqN1dfq1MTO9rTD68HTJbMt3KaVRi7Cb3GDBHq7hFYJ5
DEKvvMkJkCvvitUmY4s0IdjUEiVpsS4umbVaeb6cFXnUQRkJJ3IMrppx950Zj+1I
Jx3Q8C/iz11XzpVn2oAIXpLG/Ck7Zpt7IynnoYhBjucVSKgsJW1WGpi89I5m9ifV
/DKKxSBVFG0XgcjE6ZNhkmtxvmf1C73BAnVgiFbys5MLDf96gplJChUTo39XCS0G
fXOO6xiZAZaa+UZr9ywYJLePP8dHljFiwe1o7qgo1Q64Eplwv8fv3BBIaFjX0wIu
0D/Dnpf1n8ICk08SbymK
=0t3S
-----END PGP SIGNATURE-----

--=-6bXlUjPI7adJ10G72cBs--

