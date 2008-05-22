Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50459 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758545AbYEVH1I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 03:27:08 -0400
Subject: Re: [PATCH 5/5] mac80211: move TX info into skb->cb
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
	"David S. Miller" <davem@davemloft.net>
In-Reply-To: <20080522031021.GB10561@tuxdriver.com>
References: <20080515105524.359863000@sipsolutions.net>
	 <20080515105948.820956000@sipsolutions.net>
	 <20080522031021.GB10561@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-07AvubG5kU+RfPChY34k"
Date: Thu, 22 May 2008 09:25:59 +0200
Message-Id: <1211441159.3698.31.camel@johannes.berg> (sfid-20080522_092718_831896_C5D9B234)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-07AvubG5kU+RfPChY34k
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > --- everything.orig/net/mac80211/tx.c	2008-05-15 12:09:40.000000000 +02=
00
> > +++ everything/net/mac80211/tx.c	2008-05-15 12:09:59.000000000 +0200
>=20
> > @@ -1325,9 +1324,10 @@ int ieee80211_master_start_xmit(struct s
> >  		dev_kfree_skb(skb);
> >  		return 0;
> >  	}
> > +
> >  	osdata =3D IEEE80211_DEV_TO_SUB_IF(odev);
> > =20
> > -	encrypt =3D !(pkt_data->flags & IEEE80211_TXPD_DO_NOT_ENCRYPT);
> > +	encrypt =3D !(info->flags & IEEE80211_TX_CTL_DO_NOT_ENCRYPT);
> > =20
> >  	headroom =3D osdata->local->tx_headroom;
> >  	if (encrypt)
>=20
> This hunk didn't apply, please review the merge results.

That's because I forgot to send you a patch: "mac80211: clean up skb
reallocation code"... Sorry about that, I'll rebase it and send it to
you now.

johannes

--=-07AvubG5kU+RfPChY34k
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASDUgBqVg1VMiehFYAQIZ2w/+KLVrTSQnSGf2W+caDgiOGEUvo+NEjyGH
7h67yPiEZoEnzCSMXKFfZKx3dunKYWuepxl6b2el2UCF5cf5S1QZ2jXaE9EsglFa
oXkXsoqbTKcTn9FPg9niqxSZQpFn7EWaksXs/ajF/msSl9u3hIzQGIexBeBg1v7Z
VkI9ck+9EFJCsEezPKPCK0TMLuHDXMZgQoV2YeyRkbduA4LhNbaLopthzCshXaJN
o6tCF+XNDPWK+iRrTEH9LWvPutWOzI6wuOWfjPOe8BL99s3d2C4yVrJdUHQAH41G
BtoAX+IuNLxAhtzsCnjEpr81eIRNWjcAcesd99n6nYZqmDqGFpny5fi13+pen0pp
cjmWM+3jej//UCfPCTDkaOWGPTvdp5+iSySx9nTfdL1riYTYjngbyLKM9vm4xQzS
Gw03EnsKv6TZwmNuMCY51/cvSqRSnyQaveujwGJFGboN38JaFDJTEZwP093gszKt
2AukPOQrfbMxtHJqg3ndAnY5cDMThQ/hAKzDEXD0H0ge2LsQbtEai6mz9w4KHeow
7VSzYYDYvuUJBXJ+uZ4kyaT6NjXPac4XEw55rvEQ96qK7cEgxMtqI9KSR9K7XUXr
ds859yuWWUADzRP5UBx4CsV11n9UDXLCnJT+4vihzDk1D1UPmZko6WKUr9XaAG3W
1LwUHnrk/Lc=
=2JZ/
-----END PGP SIGNATURE-----

--=-07AvubG5kU+RfPChY34k--

