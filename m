Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49956 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbZKXBLg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 20:11:36 -0500
Subject: Re: [PATCH 2/2] mac80211: minstrel try all rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Adam Wozniak <awozniak@irobot.com>
Cc: Derek Smithies <derek@indranet.co.nz>,
	Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <4B0B2F6E.7050907@irobot.com>
References: <4AF0D54D.4090303@irobot.com>
	 <alpine.DEB.2.00.0911111508391.6214@kauri.acheron.indranet.co.nz>
	 <4AFC655A.5020706@irobot.com> <200911122103.27455.chunkeey@googlemail.com>
	 <4AFC8E4F.5090307@irobot.com>  <4AFC8F0D.5020700@irobot.com>
	 <1258097352.3899.75.camel@johannes.local>  <4AFDDF19.8060202@irobot.com>
	 <1258191039.6167.40.camel@johannes.local>  <4B018B26.2070008@irobot.com>
	 <1258392453.32159.28.camel@johannes.local> <4B0192A6.9050808@irobot.com>
	 <alpine.DEB.2.00.0911170938380.3829@kauri.acheron.indranet.co.nz>
	 <4B01D4A5.7060204@irobot.com>
	 <alpine.DEB.2.00.0911171156210.3829@kauri.acheron.indranet.co.nz>
	 <4B01E298.3030602@irobot.com>
	 <alpine.DEB.2.00.0911171314470.3829@kauri.acheron.indranet.co.nz>
	 <1258443484.1375.8.camel@johannes.local> <4B02DFE3.9040602@irobot.com>
	 <4B0AEEE3.2050808@irobot.com> <1259018866.7094.189.camel@johannes.local>
	 <4B0B2F6E.7050907@irobot.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ErcR5Op3ClUwgR23I76r"
Date: Tue, 24 Nov 2009 02:11:07 +0100
Message-ID: <1259025067.7094.208.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ErcR5Op3ClUwgR23I76r
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-11-23 at 16:57 -0800, Adam Wozniak wrote:
> In Ad-Hoc mode, it is possible for minstrel to be initialized without=20
> complete rate information.  In these cases, throughput suffers because=20
> not all rates are tried.  This patch tells minstrel to try all rates. =20
> This won't cause problems, because unsupported rates will simply fail,=20
> causing minstrel to set their probability to 0%.

Both your patches are completely whitespace damaged.

I really don't like this patch anyhow though, it's at best a hackish
workaround around an issue that should just be fixed instead.

Will take another look at the other patch tomorrow.

johannes

> Signed-off-by: Adam Wozniak <awozniak@irobot.com>
> ---
> diff --git a/net/mac80211/rc80211_minstrel.c=20
> b/net/mac80211/rc80211_minstrel.c
> index 6e5d68b..3a8fe30 100644
> --- a/net/mac80211/rc80211_minstrel.c
> +++ b/net/mac80211/rc80211_minstrel.c
> @@ -395,8 +395,6 @@ minstrel_rate_init(void *priv, struct=20
> ieee80211_supported_band *sband,
>          unsigned int tx_time_single;
>          unsigned int cw =3D mp->cw_min;
> =20
> -        if (!rate_supported(sta, sband->band, i))
> -            continue;
>          n++;
>          memset(mr, 0, sizeof(*mr));
> =20
>=20
>=20


--=-ErcR5Op3ClUwgR23I76r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLCzKnAAoJEODzc/N7+QmavIIQAIX68E3+zv72RZQsbChwxUOz
yPLtsdsk5hz0XyVwUCwAPpF0U945WQe5osVWmBqZbaBZ+J61wKhojUe8p1cKy0mM
Bf99Hl0fe1sz9ducW8iMy/yOiaBYvxNHVuq6tcrhnbqhWmqf86o1zt0lzE2VyN+w
XIoL725OFJKNNrw5pnx1gQU2GCquMVOmLH6bpgVSGuhJJoI8NFpLUQcH1TO4Ct6a
uLpfa8bb0wwBtjqU9TFUw2D+MHzi28OGn6FKkl5CCg9ME8/HtJyTZqFvdhu+74TY
dc10HllcLv7R5gpcKT1jRDgInh6jMW1CLk/AWbAYJBdGN0JBWS2Y1/HElCF5f2oz
DcXiiZZ3pIuoKiJCqLnq/MU7hvCRkhNxPbD2oBcsMEKuU6k8ixiQSXAWHQ0F4oQZ
G0Z6u5xcd3X67EmUYscZNb7kREfWXOrlwLPKbTtADO/O9ILaX5GOrzIhJ6E7rn7w
VxhfHi0dXbP6NGcn2mKWHhgHiosSsiI/qlc/4oqYyM2y122fGpK6A4mUENY1ijEx
yN+sMZ5vOyKif0g2yqY8fp1hLuilCWK6Dv0dAOAgmfxFS/ZwIGtj/BFXT2cHeZXp
xxRKldn5TExdsLzsQSETju1eC/mWiZA8dUsJvii7dAeU4bgt3xAdXkQkYtGyQWvn
tDJDypvkerKFMF5CTtPg
=zTqu
-----END PGP SIGNATURE-----

--=-ErcR5Op3ClUwgR23I76r--

