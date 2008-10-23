Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56677 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891AbYJWGwr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2008 02:52:47 -0400
Subject: Re: [PATCH] mac80211: Change WARN_ON to WARN_ON_ONCE
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni.Malinen@Atheros.com, Luis.Rodriguez@Atheros.com
In-Reply-To: <18688.7474.39470.106619@gargle.gargle.HOWL>
References: <18688.7474.39470.106619@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GXzBBSrB1+RR/G2yUt8k"
Date: Thu, 23 Oct 2008 08:52:42 +0200
Message-Id: <1224744762.5865.19.camel@johannes.berg> (sfid-20081023_085312_899271_25A5C87A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GXzBBSrB1+RR/G2yUt8k
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-23 at 12:14 +0530, Sujith wrote:
> A warning would be printed for every packet that
> is transmitted if the rate control information isn't
> setup. Change this to WARN_ON_ONCE.

> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

but please do set up the rate control information to fix the
fragmentation issue etc. :)

> ---
>  net/mac80211/tx.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 8b56048..3678325 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -565,8 +565,8 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx=
)
>  				IEEE80211_TX_RC_USE_RTS_CTS;
> =20
>  		/* RC is busted */
> -		if (WARN_ON(info->control.rates[i].idx >=3D
> -			    sband->n_bitrates)) {
> +		if (WARN_ON_ONCE(info->control.rates[i].idx >=3D
> +				 sband->n_bitrates)) {
>  			info->control.rates[i].idx =3D -1;
>  			continue;
>  		}

--=-GXzBBSrB1+RR/G2yUt8k
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJAB83AAoJEKVg1VMiehFYPT0QAKomlEZ0ndDP/+NYhTs8L1+x
pWKNsr1r744VDwbtmT4uRIUFz+Oh5nBriYuH2LlhZW909FfFwVWDQxz7qU+QBiMA
AvfSONAGuovqQlWIiAwKb9TGpiMG6BZdytVCDz72Gp1PHB/AnZzeR2lf9ybUbt0a
UL7eqcFtJEJPFanDScd87YgKguj6zjgLmoqLpkJZ5tbSmx1H4WWkBceyQYaKXdKA
K13yjzMErH/nD1tzf5MWsJ8r6GxrGknjlPnV5v6od/U3SpxUeZBX+lLfjyZzI5Pg
19uqNnpTnoymWjYxAN1dEMySVJy+J80wOyURqKAVrAocDdZJ+cP0eexPHW/7CYvE
TOAnjDlOp2snSMU/upChBvmwIMaDNawaVkJdjIxXz0Rj9ZeHMCn+T+hoOwKMh71o
EyjVnc/f1t39QNCEK0uuF1S+D/6vrcXhhecVJvjddGTlEbr67LVUyvzB+BXSCb8Z
T3yjtLO8mAJfA+NZcAsbEs8FBZhKY9sci1m4sYWtcfe8AJE85QFyoEqpPcdcijGW
Gxr0w79zU6eCetdmrTbyq5worxhwhrQVamz+kr67mG+tzKKi9gh9ZTWrrvsj3oqw
aFYCPdbevYWzbTMm0WBpMbdmJzMKMzqCAJeu/lgO/MsOjr/lJUakBMWnCOhbmanY
4Ip63HVra1FERx2M1VJU
=0Rvh
-----END PGP SIGNATURE-----

--=-GXzBBSrB1+RR/G2yUt8k--

