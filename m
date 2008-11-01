Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42055 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbYKAIC7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2008 04:02:59 -0400
Subject: Re: [PATCH] mac80211_hwsim: enable Mesh Point operation
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <490bf5e7.2a528c0a.3951.19a9@mx.google.com> (sfid-20081101_072403_704359_64603084)
References: <490bf5e7.2a528c0a.3951.19a9@mx.google.com>
	 (sfid-20081101_072403_704359_64603084)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GkhMQvVofDQQv/sqp4Ny"
Date: Sat, 01 Nov 2008 09:02:58 +0100
Message-Id: <1225526578.3550.8.camel@johannes.berg> (sfid-20081101_090323_500520_54D3DDA5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GkhMQvVofDQQv/sqp4Ny
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-10-31 at 23:23 -0700, Andrey Yurovsky wrote:
> Initial mesh support: add Mesh Point to supported interfaces mask and all=
ow=20
> hwsim to send beacons in mesh mode.

That'll do AP beacons, right? And it won't really help because all
virtual stations see each other?

> Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless=
/mac80211_hwsim.c
> index 430d8b1..34f643f 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -370,7 +370,8 @@ static void mac80211_hwsim_beacon_tx(void *arg, u8 *m=
ac,
> =20
>  	hwsim_check_magic(vif);
> =20
> -	if (vif->type !=3D NL80211_IFTYPE_AP)
> +	if (vif->type !=3D NL80211_IFTYPE_AP && vif->type !=3D
> +			NL80211_IFTYPE_MESH_POINT)
>  		return;

I think I'd prefer if you'd write it as

if (vif->type !=3D NL80211... &&
    vif->type !=3D NL80211....)
	return;

but ultimately, I don't think it matters much. That above just looks a
little quirky, at least to me. :)

> =20
>  	skb =3D ieee80211_beacon_get(hw, vif);
> @@ -777,7 +778,8 @@ static int __init init_mac80211_hwsim(void)
>  		hw->queues =3D 4;
>  		hw->wiphy->interface_modes =3D
>  			BIT(NL80211_IFTYPE_STATION) |
> -			BIT(NL80211_IFTYPE_AP);
> +			BIT(NL80211_IFTYPE_AP) |
> +			BIT(NL80211_IFTYPE_MESH_POINT);
>  		hw->ampdu_queues =3D 1;
> =20
>  		/* ask mac80211 to reserve space for magic */
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=-GkhMQvVofDQQv/sqp4Ny
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJDA0uAAoJEKVg1VMiehFY920P+wTrelDy280jYtM+5xXuZd/y
8djdkyTutsSwLvrgYWW0eWdBR4J64XtY5Jn218fpCnW32k50IZ92OCO82xzLJQXC
0Nz9adFK4BNq2Oc6EKwg0nE3ro2vexnlT806SjLKIvbDlnccEJh59XSZNqW+00Tr
ZuNGEebqmq8RnlWH+/UW3VHSBt40/0cYIkQ4KBAT5VceET8wtB61DtusKCVvC4rD
s0PfbArNWwZmvbgsPZWbkwVUkJPRNo8Ph8WRRBpxbz0Kc8ROnKgb8wZbheVmea+7
rROVlGLu6zW0lOdc1Yw5guToAgYyqMbd+d+w9uyBBTXzPpXErFiJ93TrnUSSBYLF
Q91O58S+qz7zmC+DXhKlxZmC/4hdpK812KYefJ+5zfre9xaAuTHh2zgSfqSIplMy
qJd120XP2vme/z8SunD45fJWHXHt10eCJBPFvyN3fIfhsq7Qs0VAp+FrOx/3fYl+
NWp/f940MMJOe19Pc7rdnxBZkwQtBEoBaT3C9amIATeD5bBFqC8kTWWCv5obFSyJ
liKRmxqRpoBEGby0tzxNnTRjowKntvf+52jIX2RUbWwrjnRN8xdmG7X/TsUSzE+u
QIWou91RUgf0Hh3TVTSV6HfWi79QjHNWgv4OAs9UrBCxWp6zrTZeZ9utmPRs1o/4
LXRlUcTELCEa2pMpxD/O
=gzs1
-----END PGP SIGNATURE-----

--=-GkhMQvVofDQQv/sqp4Ny--

