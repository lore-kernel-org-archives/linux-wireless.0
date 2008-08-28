Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51359 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbYH1MTX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 08:19:23 -0400
Subject: Re: [PATCH] mac80211: Fix debugfs union misuse and pointer
	corruption
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080828121206.GA4863@jm.kir.nu>
References: <20080828121206.GA4863@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sItF1AIdZtEmpB9lwTCS"
Date: Thu, 28 Aug 2008 14:18:43 +0200
Message-Id: <1219925923.25321.12.camel@johannes.berg> (sfid-20080828_141925_326643_868B18DE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sItF1AIdZtEmpB9lwTCS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-08-28 at 15:12 +0300, Jouni Malinen wrote:
> debugfs union in struct ieee80211_sub_if_data is misused by including a
> common default_key dentry as a union member. This ends occupying the same
> memory area with the first dentry in other union members (structures;
> usually drop_unencrypted). Consequently, debugfs operations on
> default_key symlinks and drop_unencrypted entry are using the same
> dentry pointer even though they are supposed to be separate ones. This
> can lead to removing entries incorrectly or potentially leaving
> something behind since one of the dentry pointers gets lost.
>=20
> Fix this by moving the default_key dentry to a new struct
> (common_debugfs) that contains dentries (more to be added in future)
> that are shared by all vif types. The debugfs union must only be used
> for vif type-specific entries to avoid this type of pointer corruption.
>=20
> Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

also the other similar patch, sorry about this, it's surely my mistake.

>=20
> Index: wireless-testing/net/mac80211/ieee80211_i.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-testing.orig/net/mac80211/ieee80211_i.h
> +++ wireless-testing/net/mac80211/ieee80211_i.h
> @@ -498,8 +498,10 @@ struct ieee80211_sub_if_data {
>  		struct {
>  			struct dentry *mode;
>  		} monitor;
> -		struct dentry *default_key;
>  	} debugfs;
> +	struct {
> +		struct dentry *default_key;
> +	} common_debugfs;
> =20
>  #ifdef CONFIG_MAC80211_MESH
>  	struct dentry *mesh_stats_dir;
> Index: wireless-testing/net/mac80211/debugfs_key.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-testing.orig/net/mac80211/debugfs_key.c
> +++ wireless-testing/net/mac80211/debugfs_key.c
> @@ -265,7 +265,7 @@ void ieee80211_debugfs_key_add_default(s
>  	key =3D sdata->default_key;
>  	if (key) {
>  		sprintf(buf, "../keys/%d", key->debugfs.cnt);
> -		sdata->debugfs.default_key =3D
> +		sdata->common_debugfs.default_key =3D
>  			debugfs_create_symlink("default_key",
>  					       sdata->debugfsdir, buf);
>  	} else
> @@ -277,8 +277,8 @@ void ieee80211_debugfs_key_remove_defaul
>  	if (!sdata)
>  		return;
> =20
> -	debugfs_remove(sdata->debugfs.default_key);
> -	sdata->debugfs.default_key =3D NULL;
> +	debugfs_remove(sdata->common_debugfs.default_key);
> +	sdata->common_debugfs.default_key =3D NULL;
>  }
> =20
>  void ieee80211_debugfs_key_sta_del(struct ieee80211_key *key,
>=20
>=20

--=-sItF1AIdZtEmpB9lwTCS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJItpeeAAoJEKVg1VMiehFY3DgP/2cMiGCdOza+j7YGDHoz1ZlS
q2YfwtYozP7EEbdjtBHBqLHOtoUuW5mv2JUpj+ceMjtsCBKeEEK4W8YZQqFp3p9c
9TNJoTyvQ0CNAZGs3W61soxPky0f+xho3vcrWBBmGtZYGDvzojPPKzx6FMZOUcpU
UuvhSq1X1U+UIdAED+vWvAhG/j1zla9QFSKczdB8rSpXlngaM0G+RQbmS+3wNtdB
6+Q8uUTp0oCCe7jz4AeM5ASq1v7Wg1fropehq9v5f1qFI9Lul0KdDbdNB/TbfKV2
kLLNYx/1XbVwkn9ptg+OD6qpJSphwYavO1naCvxTqkV71fbMVgNf2wiMlr0LHFPR
Em2vgvQNWCua1KQynyg2EznXModyuoazGK1nomPONQdtSIzdfco5jVTB4VsfVVM3
TFnI7+/uknBHIy5HgDuAccO0FPsExvRQIXm7EbBrGT4IxuGRkgJg3s2GbOA8/HUa
YwdrfRELej1a6krBP/VaTuS4mA/S2SflLG1bkHN/ewhJ3uCzbKRL1tMpVj5ybtxE
2RfhMHhU/u/tgnEspyJ936+b1+DEiiVT/TcIcQeUk7NrtXW1btOZ52IGOgHzF6on
PujBe0cdBdzyriI6hl81auSI/HABj1IFb8v6LZmAt40NNRaMGVIMw5LqC6n26lXE
xep0V/aza2FWr71DUCkX
=aGHg
-----END PGP SIGNATURE-----

--=-sItF1AIdZtEmpB9lwTCS--

