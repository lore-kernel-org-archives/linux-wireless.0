Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54863 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169AbZG0I12 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 04:27:28 -0400
Subject: Re: [PATCH 1/3] mac80211: cooperate more with network namespaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1248653082.3106.7.camel@mj>
References: <20090713223333.042733013@sipsolutions.net>
	 <20090713223413.255405284@sipsolutions.net>  <1248653082.3106.7.camel@mj>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-bcelWGSbb2MUY3+Pvtdx"
Date: Mon, 27 Jul 2009 10:27:29 +0200
Message-Id: <1248683249.19945.29.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bcelWGSbb2MUY3+Pvtdx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Thanks Pavel,

> >  		while (!skb_queue_empty(&local->pending[i])) {
> >  			struct sk_buff *skb =3D __skb_dequeue(&local->pending[i]);
> > +			struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
> > +			struct ieee80211_sub_if_data *sdata;
> > +
> > +			sdata =3D vif_to_sdata(info->control.vif);
> > +			dev_hold(sdata->dev);
>=20
> I'm getting a panic at this point if I run hostapd on ath9k and a
> Windows client tries to authenticate with a wrong WPA key.
>=20
> Debugging shows that sdata->dev is NULL.

I suspect 'sdata' is already pointing to something bogus, since it's the
result of a container_of().

Can you try with the sanity checking patch I'm about to send?

johannes

--=-bcelWGSbb2MUY3+Pvtdx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKbWTuAAoJEODzc/N7+QmaRYAQAI5FX4ElS0ZSYowSZ/vxKzMl
X33AvPo4jdrxjWx1FxiRplSNTTKWpdH7HslbBktQEHKxWFQ4fcnXADQe8dFpDMuP
ShularGDlQEI0pzqKbAVS7jvb2+V14EH2W7/ud5gOClqQCDq1DTZbT/C60jvzzud
sWTQXM6y1N7lXfSCncMbCRs3UZPYhK09EFDGy5w9e93SK6U+6i1UqojIv8zIe/aO
epU3d7RJOwMAwPhRPjGRkG+S4Nf4WWjYWY2F4xxwTxtWcKNMKp3oV4iimKMkP5uJ
RV6dNiChIvsAsZdnMVB+KRlb1+dTrXmXre+SILbsKonM7VO1V6gdKqzleUmF1eKN
LjS6aJeZahTgFYvp4ESjjaRKBH/YXAE3dDq2HS5NU6nqXzwrTK8776u2ZawLgmZh
pD/6kRPkXfgsPeERnS+7ZW0TiOLqLtmRJOgcc/3KGmAOfsMtIVeCL5fdjWVNpypH
Bx8n9dunxGpC8cs2+L8v9vFEkQJuBo+dShaUqjMWmuX85xbUBiSW+CBDv5XDeoRi
N7S73ewnZbkuo+dxP85lk38z5Tg/EfcAW/qxcrPnpSqk4BXYyELmgn7mA2D5AiOF
jgMkRkOfqh9PBd0bu9kANbLYXHilannJgL1ZMCMGTWPl/0Nl69a0Lnjnq48lMpva
w+nG0P4sl1jZwPxr1zBD
=g4fL
-----END PGP SIGNATURE-----

--=-bcelWGSbb2MUY3+Pvtdx--

