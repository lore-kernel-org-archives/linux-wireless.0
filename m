Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37412 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbYL3AcQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2008 19:32:16 -0500
Subject: Re: [PATCH] mac80211: clean up set_key callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240812291417w6e99dd17t3ffc2973774ed824@mail.gmail.com> (sfid-20081229_231749_711526_6708F26B)
References: <1230551709.3116.30.camel@johannes>
	 <1ba2fa240812291417w6e99dd17t3ffc2973774ed824@mail.gmail.com>
	 (sfid-20081229_231749_711526_6708F26B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2d11TwVe4sW0MSQSczQt"
Date: Tue, 30 Dec 2008 01:32:40 +0100
Message-Id: <1230597160.3116.74.camel@johannes> (sfid-20081230_013220_639016_C5808926)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2d11TwVe4sW0MSQSczQt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-12-30 at 00:17 +0200, Tomas Winkler wrote:

> > @@ -3038,6 +3039,9 @@ static int iwl_mac_set_key(struct ieee80
> >        int ret =3D 0;
> >        u8 sta_id =3D IWL_INVALID_STATION;
> >        u8 is_default_wep_key =3D 0;
> > +       static const u8 bcast_addr[ETH_ALEN] =3D
> > +               { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, };
> > +       static const u8 *addr;
>=20
> >        IWL_DEBUG_MAC80211("enter\n");
> >
> > @@ -3046,9 +3050,7 @@ static int iwl_mac_set_key(struct ieee80
> >                return -EOPNOTSUPP;
> >        }
> >
> > -       if (is_zero_ether_addr(addr))
> > -               /* only support pairwise keys */
> > -               return -EOPNOTSUPP;
> > +       addr =3D sta ? sta->addr : bcast_addr;
> >
>=20
> Please use this code instead in both iwlwifi drivers.
>=20
> +sta_id =3D sta ? iwl_find_station(priv, sta->addr) :
> priv->hw_params.bcast_sta_id;
> - sta_id =3D iwl_find_station(priv, addr);

Should probably be a separate patch though since this particular patch
isn't meant to change semantics here, I think.

johannes

--=-2d11TwVe4sW0MSQSczQt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJWWwlAAoJEKVg1VMiehFYctwQALlNudaBWB9UoSLUqlWNEfnW
G6zgdH6sCHUW+ohkImoNFfxagmkc9qFEcdU6s0Wc41ymw0uEwCCOKZdBmAnTfLVv
1gIlmO1t+DIh2EnNjAlkXyTIy2grDievlT3XzDo9WBW31y11iKyE48FE8n8Dh4Eq
peWZX1LLmj3rQ2oW8mjXXMJluq3F+GdXXlD9UUXvrXCHVGnT6bMu6wIHL4ZwtZZ0
naFnKBISTN4ivl6RcaTgY4q4Xxn0kMEd/W0hE6JPHX2LiwMY6QYu5/RIFUP9BWr/
Upyk1/Sxo2yduw/8GOz8/bfjEiH6Kr9AfO8UmsjzYU2N7uT1yGsRCeumMM3+YNdk
Rp4eYnQhdtC6n2WTLDG4jRyk9GxaYkinBv6iE5CI/jzqJW3iC7646ROEOP/GKA9y
nJc0QkJ7Kla/iuMYvorcMoW3UX1g2OdG+dyAO31ywWsr5SmqHtHifFwX2uZMOOq7
PWmcfHZoUyi05xmujSWTb+Q2l998XdDB7Pj8kVeVWqXLEMbPFJYjOlGNyGIvXWWg
pvIdlgcYew9BOTTaKv5ZPAMRajcr+4dYJpSlmuAUwn+1zeaGslRkglJLwxrqtcuP
FwdELSpoaitzXRNlWKkvrePhneZFr/fy0XDQTQ8AaaOlAo943mab+o2nLHpJYHLQ
SQml8mBbcvVsQ1YHAx/2
=WFnh
-----END PGP SIGNATURE-----

--=-2d11TwVe4sW0MSQSczQt--

