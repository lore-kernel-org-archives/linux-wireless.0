Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56860 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbZJWQpy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 12:45:54 -0400
Subject: Re: [ath9k-devel] mac80211/ath9k/hostapd: Some clients unable to
 associate with AP
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: =?ISO-8859-1?Q?Bj=F6rn?= Smedman <bjorn.smedman@venatech.se>,
	Joerg Pommnitz <pommnitz@yahoo.com>,
	Will Dyson <will.dyson@gmail.com>,
	ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
In-Reply-To: <20091023163001.GA4911@jm.kir.nu>
References: <133e8d7e0910200711s7c44b899nbcd5f1037cc5ee49@mail.gmail.com>
	 <133e8d7e0910210448y39551160o7a12a8af2da43f85@mail.gmail.com>
	 <20091022161021.GA5532@jm.kir.nu>
	 <8e6f94720910221645n2b0b1edcq29358f175a41d3ad@mail.gmail.com>
	 <389827.53102.qm@web51401.mail.re2.yahoo.com>
	 <133e8d7e0910230346q176fca69y55d8fb66b61d3fbf@mail.gmail.com>
	 <133e8d7e0910230827x4febf4ccw6920d88830444abd@mail.gmail.com>
	 <20091023163001.GA4911@jm.kir.nu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-+kQSOjMGPHyD+NuguhU9"
Date: Fri, 23 Oct 2009 18:45:37 +0200
Message-Id: <1256316337.12174.181.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+kQSOjMGPHyD+NuguhU9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-10-23 at 09:30 -0700, Jouni Malinen wrote:

> > diff -urN compat-wireless-2009-10-21-before_seqnum_fix/net/mac80211/tx.=
c
> > compat-wireless-2009-10-21/net/mac80211/tx.c
> > @@ -1445,7 +1445,7 @@
> >                                 if (tmp_sdata->vif.type !=3D NL80211_IF=
TYPE_AP)
> >                                         continue;
> >                                 if (compare_ether_addr(tmp_sdata->dev->=
dev_addr,
> > -                                                      hdr->addr2)) {
> > +                                                      hdr->addr2) =3D=
=3D 0) {
> >                                         dev_hold(tmp_sdata->dev);
> >                                         dev_put(sdata->dev);
> >                                         sdata =3D tmp_sdata;
>=20
> This does indeed look like a typo. Though, I'm not sure how this would
> have caused a regression between compat-wireless-2009-06-02 and
> compat-wireless-2.6.32-rc1. The incorrect compare_ether_addr() use seems
> to be there in the original commit that added this code
> (25d834e16294c8dfd923dae6bdb8a055391a99a5 from September 12, 2008)..
>=20
> Johannes: Any idea why the sequence number allocation for injected
> frames from hostapd would have changed between 2009-06-02 and now? This
> bug seems to be too old to explain that ;-).

Indeed, I have no idea though.

johannes

--=-+kQSOjMGPHyD+NuguhU9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK4d2tAAoJEODzc/N7+QmarMgP/3cDx37fNccWRFK4d3zSaK8F
4u1/944c0WC6RMwkTQUCLAkOqPt7BNR0opxhyutwtuYTMnKZble/iKOb7/WL3Qx/
NukG+JbIKd5ppfYQBLYu4tHRbGJWFjh5BqX04NMjuqIVHFd/c+mdtnAq7a4BaCrc
m4p4Eg0vQmvbKl0icfiobhG2e/rDSA0o0oM1R3AMFVoOBaSkexNs0BIlaQxL6OvM
SynzxQNmvrEtMQFU43h0jW5dlQ0vYCicDbPFTO1kmvxIgaW/8jIIj7rs4f44Vaz6
JWbAXKrPMrWyrVgVFDa2RRbVgA391VsEahKNa0iTJsEeUR8kauJZqEDo2YjCylGk
lGhmwf05af2tRgpJeTgg2+4mrHMeS/hPA0oAD1uXLO2tVYiG9+c0gpZhCy9gNfDJ
TTn7GUzuKKmPTQYqnPLonTpsHJ2SlPjq4NH1xFBEuEF9xROWjTqrgvrN3e6HBYOA
ZYvo8ENLSFkgWrC9ZXrAIXZyiks0xCgheg3wPr2LAV41K2WjQMzmyhlSKr55fhs8
wPxjUa8kjsL5weYdkt3iQ1KqZ14byeovkUwM/jJX5din1EdBNtL9JFMWMxz7FGs+
3heGdT9DT0aJbcMv2lS5MlSw502jOmzGHzb20p/FnqtU98CoiDKFJYEKmHDCPLJL
thk+SGSWBUGKtAJXC0C/
=IKoZ
-----END PGP SIGNATURE-----

--=-+kQSOjMGPHyD+NuguhU9--

