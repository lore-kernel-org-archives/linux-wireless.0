Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53407 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbZFTLcz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Jun 2009 07:32:55 -0400
Subject: Re: [PATCH] wext: optimise, comment and fix event sending
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890906191059m321907dbr98395dda9e16b139@mail.gmail.com>
References: <1245421739.16399.22.camel@johannes.local>
	 <43e72e890906191059m321907dbr98395dda9e16b139@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-UWzZpyo7X+tGyYzF2yTV"
Date: Sat, 20 Jun 2009 13:32:51 +0200
Message-Id: <1245497571.16399.25.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UWzZpyo7X+tGyYzF2yTV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-06-19 at 10:59 -0700, Luis R. Rodriguez wrote:

> >        /* Get the description of the Event */
> >        if (cmd <=3D SIOCIWLAST) {
> > @@ -1430,25 +1395,60 @@ void wireless_send_event(struct net_devi
> >        hdr_len =3D event_type_size[descr->header_type];
> >        event_len =3D hdr_len + extra_len;
> >
> > -       /* Create temporary buffer to hold the event */
> > -       event =3D kmalloc(event_len, GFP_ATOMIC);
>=20
> Hm, for stable purposes can this be fixed with a kzalloc here? If so
> can this patch be split it up in 2 for that purpose?

Yes, but since this bug has been around _forever_, and we've also known
about it for a long time too, I don't think it's necessary to fix in
stable.

johannes

--=-UWzZpyo7X+tGyYzF2yTV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKPMjeAAoJEODzc/N7+QmaXb0P/0qnzXKvDVBkpjmWNAoswJWr
XHmvdYCt9ineMAxoODGnhcXpLLOfK9inlU8rHKNYSRpwnOZc9MxGc/MTJUNhtUUi
0UWtPI+Q7CkSAtTeKBRx1muJPGQgCVK7H0p0pq0z2xbHSgbML9WQPmbvRx8H0GPe
0aqRvMYMWY3IHBn0uLnOsf7su25yaQ1RqJX/6EUbM12+1jY8I6DT8Bp620bHVoNw
rCf7OHL/VO8+IvZgGqVGSjbgdaatmNN38DjdQ9Q9++P9F2zEr5AB96yRKNlsye9C
TSaoPuagrLvGHKvqYtOaL1kbjdceiajVtvsKrlvhc76frji+F0QlczdbLJOGN3BL
UgXXlz4z7hqfbX6/D3N9Kb752+VMiDPkHqCJ8ueaE+45tVrmlZ3ctl37aQJCw5uE
47LLusFlPKcK+eQ3Us/YxTm1TvohK4EperiR5vD3ZU2Id7tMZ1lhDiSbC1+vCvKa
taRuiIPRbO741Vt0ftuEluu2ebcfUgd2Ia817qa3h/k6syCE/fPlX0fb1r6sKX6H
Oagobs5ZgjL2HvAVVtsiChVlMHLNwax1kMHyohzwPdoFglUtnsItd7nD0yxo24wq
ywWxx3EnzKSI2WgFpvjXMUloz1DJL6Py/AanFvx2sHnadKYciU4CbYjpmDN6248G
SykA59iyCUGS1DXp8Zl4
=/tWz
-----END PGP SIGNATURE-----

--=-UWzZpyo7X+tGyYzF2yTV--

