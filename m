Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50648 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbZJXSEA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Oct 2009 14:04:00 -0400
Subject: Re: [ath9k-devel] mac80211/ath9k/hostapd: Some clients unable to
 associate with AP
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Bj=F6rn?= Smedman <bjorn.smedman@venatech.se>
Cc: Jouni Malinen <j@w1.fi>, Joerg Pommnitz <pommnitz@yahoo.com>,
	Will Dyson <will.dyson@gmail.com>,
	ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
In-Reply-To: <133e8d7e0910232012g718dae3kf297bf5d2301b48@mail.gmail.com>
References: <133e8d7e0910200711s7c44b899nbcd5f1037cc5ee49@mail.gmail.com>
	 <133e8d7e0910210448y39551160o7a12a8af2da43f85@mail.gmail.com>
	 <20091022161021.GA5532@jm.kir.nu>
	 <8e6f94720910221645n2b0b1edcq29358f175a41d3ad@mail.gmail.com>
	 <389827.53102.qm@web51401.mail.re2.yahoo.com>
	 <133e8d7e0910230346q176fca69y55d8fb66b61d3fbf@mail.gmail.com>
	 <133e8d7e0910230827x4febf4ccw6920d88830444abd@mail.gmail.com>
	 <20091023163001.GA4911@jm.kir.nu>
	 <133e8d7e0910232012g718dae3kf297bf5d2301b48@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-noqfokSZWRSz7JJ3QTuM"
Date: Sat, 24 Oct 2009 20:03:56 +0200
Message-Id: <1256407436.12174.499.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-noqfokSZWRSz7JJ3QTuM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-10-24 at 05:12 +0200, Bj=C3=B6rn Smedman wrote:

> >> diff -urN compat-wireless-2009-10-21-before_seqnum_fix/net/mac80211/tx=
.c
> >> compat-wireless-2009-10-21/net/mac80211/tx.c
> >> @@ -1445,7 +1445,7 @@
> >>                                 if (tmp_sdata->vif.type !=3D NL80211_I=
FTYPE_AP)
> >>                                         continue;
> >>                                 if (compare_ether_addr(tmp_sdata->dev-=
>dev_addr,
> >> -                                                      hdr->addr2)) {
> >> +                                                      hdr->addr2) =3D=
=3D 0) {
> >>                                         dev_hold(tmp_sdata->dev);
> >>                                         dev_put(sdata->dev);
> >>                                         sdata =3D tmp_sdata;
> >
> > This does indeed look like a typo. Though, I'm not sure how this would
> > have caused a regression between compat-wireless-2009-06-02 and
> > compat-wireless-2.6.32-rc1. The incorrect compare_ether_addr() use seem=
s
> > to be there in the original commit that added this code
> > (25d834e16294c8dfd923dae6bdb8a055391a99a5 from September 12, 2008)..
>=20
> Interesting puzzle. :) It looks like there was a complementary bug
> (the pointer hdr was set to point len_rthdr * sizeof(struct
> ieee80211_hdr) bytes into the skbuff) in that commit:
> ...
> +		len_rthdr =3D ieee80211_get_radiotap_len(skb->data);
> +		hdr =3D (struct ieee80211_hdr *)skb->data + len_rthdr;
> ...
> So the frame source address used to be compared with random data which
> was likely to result in inequality, causing the first ap interface to
> be "found" and the code to work as expected. I guess the pointer bug
> was fixed somewhere between 2006-06-02 and now "causing" the sequence
> number problem.

Heh, indeed, interesting. I remember somebody fixing that, but was
unaware of the second bug (obviously).

johannes

--=-noqfokSZWRSz7JJ3QTuM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK40GHAAoJEODzc/N7+QmaaawQAMmjUyVl+UzRN6Nws5GzeYFg
afXaiVidnC0V0csgXg6hLFZGr8qwpZ4ZxMa1fIP3OsIJW512gwDOVT+gWp+ImTu4
EEgBSyYrWJa46gZz9gZDl6lhakI8k5XrVdQ/iMYTC/+WIg5BlqbCxABfCHvoaceW
h8b7y+CmROZG4AlTRBeJw2D9r/TGHPiHEqPb1poqSoEhLcVgJ0B8Iy50Pk0tNoXB
Nl/B9K/x61XgbOqanoNDMedEFeEC7RnkLRMgALP0fj4KzAG5R/LoIJdOv26cNnda
gP4ABNpKiBn5+TdF3tppQgRDHDrzpnIFZjCOEtytKIqfeWkRozyeHz5Gsb+AygJL
HQvQw+wMn+YvGTbPpWB0BsiuaLN5SaywImb/sQFbn6hPnuQQkzsOzW+uJ0+gOLyr
Eys+KyB+dRIkMVEuXdCfhVsF/U1Kq0nI1tpZ7fEspAcylibA4ame4OIGJyx6+Uih
UPsdKcTIPmWsAoWU4+82SoWsF63MAW4MDDIkvlBjRsimUbLbtN5H9fN3CzjxjhrW
EnbQOZr91WcXyCYaedya4ALBuXzOHTYrxkvzPA2dZ1iqwbZzuvOWOLCmgt2hwvRq
bNDmIizvjnyX8PjXwECy1BZce8pggJBOv0A+lHr5IG6v0I5VQzbPvVoelmRSkkXA
fWA+gLHB+bMDlwzOquaP
=ff4+
-----END PGP SIGNATURE-----

--=-noqfokSZWRSz7JJ3QTuM--

