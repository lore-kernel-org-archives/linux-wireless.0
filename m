Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52264 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbYCQJ6q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2008 05:58:46 -0400
Subject: Re: [ipw3945-devel] [PATCH 1/5] mac80211: allows driver to request
	a Phase 2 key
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1ba2fa240803161721q5d01bve2292f99d3fe9eb8@mail.gmail.com> (sfid-20080317_002118_132302_5D857FBC)
References: <1205366762-12828-1-git-send-email-reinette.chatre@intel.com>
	 <1205366762-12828-2-git-send-email-reinette.chatre@intel.com>
	 <1205591906.15910.44.camel@johannes.berg>
	 <1ba2fa240803161721q5d01bve2292f99d3fe9eb8@mail.gmail.com>
	 (sfid-20080317_002118_132302_5D857FBC)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Biig7xyp0UbZhAyl8Ean"
Date: Mon, 17 Mar 2008 10:58:32 +0100
Message-Id: <1205747912.1614.19.camel@johannes.berg> (sfid-20080317_095849_842520_1C348FE5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Biig7xyp0UbZhAyl8Ean
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >  Also, looking at what you do here, I found this comment:
> >         /* FIXME: need to differenciate between static and dynamic key
> >          * in the level of mac80211 */
> >         static_key =3D !iwl4965_is_associated(priv);
> >
> >  I think that is pretty bogus because there isn't really a distinction
> >  between dynamic and static keys, what's the reason for differentiating
> >  in the driver? Also, the driver will do rather odd things when
> >   * associate
> >   * set a key
> >   * disassociate
> >   * delete the key
> >
>=20
> This is actually quite a bug in mac80211. There is substantial
> difference between dynamic and static key.
> While static key  is used for crypto of all stations in BSS. Dynamic
> key is also called pairwise key and is generated for 'pair'

Gee, can you then please stick to terminology used in the spec so other
people can understand it?

> Currently mac80211 set static key with broadcast address which iis
> wrong cause driver cannot distinguish whether this key is
> multicast/broadcast dynamic key or a static key. Shell it use it for
> all traffic or only for mcast/bcast? Who can tell?

Actually, you're making it look like a much larger problem than it is.
If you assume anything WEP is a "static key" and everything else is a
"dynamic key" (using your terminology), the only problem will be with
dynamic WEP, and even then it's not really a problem because as far as I
understand even dynamic WEP doesn't distinguish between group and
pairwise keys.

> Other difference while there can be 4 static key installed that the
> same time possible switching between indexes  There can be only one
> dynamic key per station if you also consider mcast/bcast station to be
> an entity. (TKIP actally uses different  key index for bcast but
> that's just little execption)
> The terminology which is used is also wrong and I guess this is just
> wrong interpretation of  old implementation - 'default key' is used
> for static key. Key mapping key is used for dynamic keys.

I don't think I understand the last paragraph?

In any case, actual TX key selection is done by mac80211 anyway, so
you're never interested in that. Only RX key selection is interesting to
the driver, and as far as I can tell it ought to work if you simply
always use the broadcast address key when it's WEP, and otherwise the
pairwise keys and/or the broadcast key for bc/mc frames.

Note that there's another case in AP mode where bc/mc keys are TX-only,
those are added with a zeroed MAC address.

johannes

--=-Biig7xyp0UbZhAyl8Ean
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR95Ax6Vg1VMiehFYAQKdyhAAoULV7qhmrzL519kebb8peVoSohtKwCgu
/86mwbkobyt5py0DG5SZ7sYI9XVkfx9dJRecJ8662aNKVofGoNCvUalJnL3USDWf
EUZRVwUmcdwahF1T8JByopT7BEpR5pnmBHRxGxU1sa0El1zefJJ8BvttDbCBrbj9
X1xsDgwvKg4Uje5Zk1JB2r9uf9/XyXhSJGQk6pQX1wj6SHj97SX4T97xfu7jMbuL
hUsttgzc+jHq/xb8AGJRV2McGCjk+aQj2oz4Hcq/5rm7Bcyo6JyfBw3ZSRo2Dcwn
9BtQp8CK3EL8knpt27laaaXQFpCekVU8Og0BUCweLDT6SYXRWjvw8HpitP1/XCMw
ml9tQVeDo3LAbtvkQswMQnyvj1tVWhENYMEOu3mi5iMg1vYZhNo+Q7w8+ccAwIKq
bZE3oRZUuWrEnyB7SdoFi5Zy/a5617y4a1gXGYLGnBiKqeUbx2xa7BX7QX1Ht030
dCA38JKxeiHZubZ7U35yyyag3VNQ6fhJPkRklDfqdHzimZH8bvV7ATjINW4S5beL
W97V477uf6GDwcZJHKiBF9MVT6/vTuBG1/MX2HR+oqJWjSXEl1gYLqOI6Q7VvZml
4r0ahCXspOsTVVAxchV3d+1sy/jDD5AsuGRLwXxnAdCDf89xn32ndG/iipXbg3A4
ODla6YROvmY=
=TEg0
-----END PGP SIGNATURE-----

--=-Biig7xyp0UbZhAyl8Ean--

