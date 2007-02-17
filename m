Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55806 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946620AbXBQKQn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Feb 2007 05:16:43 -0500
Subject: Re: [PATCH] d80211: fix incorrect hw.priv setting in  ieee80211_alloc_hw()
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20070217074208.348.69546.stgit@dv.roinet.com>
References: <20070217074208.348.69546.stgit@dv.roinet.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8tCzIhNDa9u5EsmEZOq9"
Date: Sat, 17 Feb 2007 11:16:37 +0100
Message-Id: <1171707397.3487.5.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8tCzIhNDa9u5EsmEZOq9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-02-17 at 02:42 -0500, Pavel Roskin wrote:
> hw.priv is set twice, and the second time it's set incorrectly to an
> area relative to the master device, which wasn't allocated for private
> data.

Yeah, this is obviously correct. Guess I was drinking when I did these
patches. I really wonder why I never saw any of your problems though, I
do have bcm43xx running here. Not that the driver actually does anything
for me, it always refuses to associate...

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> Signed-off-by: Pavel Roskin <proski@gnu.org>
> ---
>=20
>  net/d80211/ieee80211.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
>=20
> diff --git a/net/d80211/ieee80211.c b/net/d80211/ieee80211.c
> index 456beb3..4f77e27 100644
> --- a/net/d80211/ieee80211.c
> +++ b/net/d80211/ieee80211.c
> @@ -4550,9 +4550,6 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv=
_data_len,
>  	mdev->ieee80211_ptr =3D &sdata->wdev;
>  	sdata->wdev.wiphy =3D wiphy;
> =20
> -	local->hw.priv =3D (char *)mdev->priv +
> -			 ((sizeof(struct ieee80211_sub_if_data) +
> -			   NETDEV_ALIGN_CONST) & ~NETDEV_ALIGN_CONST);
>  	local->hw.queues =3D 1; /* default */
> =20
>  	local->mdev =3D mdev;
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=-8tCzIhNDa9u5EsmEZOq9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF1tYF/ETPhpq3jKURAkjLAJ9T2uQZQ0Nv7X0N6ZIuBMjO+XpJDACeJGdZ
LUcyY70EVvSTIpableQRGqU=
=gSfY
-----END PGP SIGNATURE-----

--=-8tCzIhNDa9u5EsmEZOq9--

