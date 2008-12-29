Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38143 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbYL2LO3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2008 06:14:29 -0500
Subject: Re: [PATCH] mac80211: initialize RC data for all mesh links upon
	allocation
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@web.de>
Cc: wireless <linux-wireless@vger.kernel.org>, andrey@cozybit.com,
	John W Linville <linville@tuxdriver.com>
In-Reply-To: <200812272219.49555.chunkeey@web.de>
References: <200812272219.49555.chunkeey@web.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jBfvYESDciEV1XLQ7J0m"
Date: Mon, 29 Dec 2008 12:14:51 +0100
Message-Id: <1230549291.3116.27.camel@johannes> (sfid-20081229_121433_862385_3593194F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jBfvYESDciEV1XLQ7J0m
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-12-27 at 22:19 +0100, Christian Lamparter wrote:
> This patch fixes a panic that might occur, if the device is part of a mes=
h
> and tries to send with a higher rate index than "0".

I think we really should try to move this into sta_info_alloc() at some
point ...

> kernel BUG at net/mac80211/rate.c:239!=20
> invalid opcode: 0000 [#1] SMP=20
> [...]
>  Call Trace:
>  <IRQ> <0> ? invoke_tx_handlers+0x474/0xb57 [mac80211]
>  ? __ieee80211_tx_prepare+0x260/0x2a8 [mac80211]
>  ? ieee80211_master_start_xmit+0x300/0x43a [mac80211]
>  ? __qdisc_run+0xde/0x1da
>  ? net_tx_action+0xb4/0x102
>  Kernel panic - not syncing: Fatal exception in interrupt
>=20
> Signed-off-by: Christian Lamparter <chunkeey@web.de>
> ---
> I'm not sure if we need a rate_control_rate_init in mesh_neighbour_update=
 as well.
> So, there's one patch[1] with and another one[2] without rate_control_rat=
e_init in
> mesh_neighbour_update...

Hard to tell.

> ---
> diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
> index faac101..1c1474d 100644
> --- a/net/mac80211/mesh_plink.c
> +++ b/net/mac80211/mesh_plink.c
> @@ -107,6 +107,7 @@ static struct sta_info *mesh_plink_alloc(struct ieee8=
0211_sub_if_data *sdata,
> =20
>  	sta->flags =3D WLAN_STA_AUTHORIZED;
>  	sta->sta.supp_rates[local->hw.conf.channel->band] =3D rates;
> +	rate_control_rate_init(sta);
> =20
>  	return sta;
>  }
> @@ -244,6 +245,7 @@ void mesh_neighbour_update(u8 *hw_addr, u64 rates, st=
ruct ieee80211_sub_if_data
> =20
>  	sta->last_rx =3D jiffies;
>  	sta->sta.supp_rates[local->hw.conf.channel->band] =3D rates;
> +	rate_control_rate_init(sta);
>  	if (peer_accepting_plinks && sta->plink_state =3D=3D PLINK_LISTEN &&
>  			sdata->u.mesh.accepting_plinks &&
>  			sdata->u.mesh.mshcfg.auto_open_plinks)
> ---
> diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
> index faac101..a540ab8 100644
> --- a/net/mac80211/mesh_plink.c
> +++ b/net/mac80211/mesh_plink.c
> @@ -107,6 +107,7 @@ static struct sta_info *mesh_plink_alloc(struct ieee8=
0211_sub_if_data *sdata,
> =20
>  	sta->flags =3D WLAN_STA_AUTHORIZED;
>  	sta->sta.supp_rates[local->hw.conf.channel->band] =3D rates;
> +	rate_control_rate_init(sta);
> =20
>  	return sta;
>  }
>=20

--=-jBfvYESDciEV1XLQ7J0m
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJWLEnAAoJEKVg1VMiehFYdfkP/RN/KLCKfvFBIFZ1blr83JoH
j49q5sKMaBaj4fEwpCpVCDyjoku2ktz21XUNGLsrTM391ROlAU2qSjQi5pIffawO
Tq4xZiunyjWgL+Mic0PaZoLx5OEh/r1grvRScMaqFB2sYyk+blkjq+71P/T6fROZ
XzPa9pK7CVUa5/lKy9/moWn4Y+2lx7azka+5lBVLF6Od0gGoe3Vy2Ht8Xf5e0gGM
tkTek4F0itJnZWexNt1dNgjkVZTdYiVLJGoB0ZBxFboN+XV5/saeYYygbiFw2FDZ
AMqeqEXMAPAtMD4H84L3L/Y9/fWqlXJxlADrCcGTPT2K8JXO6raf+NcbODpX3tZE
+9dL+vEKcQ5KvLkpQ5Nnf0v/DMrbAsCBFwQYK4gHRj4DaH37cif8+HlrxppUXgN8
8nBVbuC/jM32Dh0QGCPOSZqwiitwMpqaikaEupQ8DHjwUHjzM9hGrlIi3PITg4zy
42nSKVpXSf/CUza7kx9TZ4ACFYE5JHqHeuZUp0cc4y4e8oL7+/TXkZJU0xopOIdl
4ksnxuk+fD4/kzYilIzePCTXWvOFf8VkS3Du0OTJ26vLkOiYs58puu4izQ2Q9wbC
thYuq/wlW2W3K6Fy3w81FsQUDBvhRFGlvH/LM3VSWE68uqyzcrQZoetHDFEjINF+
jzCnTMEEdCS6mUJ8fKyG
=ejZ3
-----END PGP SIGNATURE-----

--=-jBfvYESDciEV1XLQ7J0m--

