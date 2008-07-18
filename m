Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51263 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756067AbYGRSxq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 14:53:46 -0400
Subject: Re: [PATCH 6/6] rt2x00: Fix GCC warning because aifs is now
	unsigned
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <200807182045.24303.IvDoorn@gmail.com> (sfid-20080718_204131_622021_F7D810A6)
References: <200807182043.08990.IvDoorn@gmail.com>
	 <200807182044.45140.IvDoorn@gmail.com>
	 <200807182045.04530.IvDoorn@gmail.com>
	 <200807182045.24303.IvDoorn@gmail.com>
	 (sfid-20080718_204131_622021_F7D810A6)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5xA0B3/iz8/HD5BHhcst"
Date: Fri, 18 Jul 2008 20:53:41 +0200
Message-Id: <1216407221.27738.47.camel@johannes.berg> (sfid-20080718_205356_465373_746C3C07)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5xA0B3/iz8/HD5BHhcst
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-07-18 at 20:45 +0200, Ivo van Doorn wrote:
> The aifs type has recently been changed to unsigned,
> this triggered the following gcc warning:
>=20
>   CC [M]  drivers/net/wireless/rt2x00/rt2x00mac.o
>   drivers/net/wireless/rt2x00/rt2x00mac.c: In function 'rt2x00mac_conf_tx=
':
>   drivers/net/wireless/rt2x00/rt2x00mac.c:557: warning: comparison is alw=
ays true due to limited range of data type
>=20
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> ---
>  drivers/net/wireless/rt2x00/rt2x00mac.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wirele=
ss/rt2x00/rt2x00mac.c
> index 77af1df..f1dcbaa 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00mac.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
> @@ -554,10 +554,7 @@ int rt2x00mac_conf_tx(struct ieee80211_hw *hw, u16 q=
ueue_idx,
>  	else
>  		queue->cw_max =3D 10; /* cw_min: 2^10 =3D 1024. */
> =20
> -	if (params->aifs >=3D 0)
> -		queue->aifs =3D params->aifs;
> -	else
> -		queue->aifs =3D 2;
> +	queue->aifs =3D params->aifs;

davem already took my patch doing exactly that into his tree, it just
hasn't arrived back yet.

johannes

--=-5xA0B3/iz8/HD5BHhcst
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIgOaxAAoJEKVg1VMiehFYwMQQAL9zFEMwUUSuZMFNguzatzSa
38U7ri5jkKm0mG97Ck/Onzpcy/frs7CfgvaxQuQlPYX1wCyTvQvnwx7EPTLkwk5V
D64iwUpSrq0JWPe3pRHF43mSUxMHBsruXWioS6uy1HAYzpw/bNpx79O36nN+FdwE
oF+E5RtLemU8qVAna1hzfn1HIdsiAfQ/JHvPigl6UYehlVcaEf+DCqa82CiU8IvR
D0Xxi6Ao6itQE+s+hEN70uVwfCKuinm4HUbav//yhMw9yOvUpiRmRXv5ZAvCxKr4
Jz03D+tXQacM7NfIrSLGuPCBbfvZJVsq9WPyVoKWuEFrwNaaPymJkwAk0MDlCf+5
8uLIdviv18MVDYMX74CVyxkoIypdMBTOPrHbGkiBiVJAWiiCWSPi7DFYReTbbXSl
JXjjUfyE/5pnO9+G9+twLrU/HZ8rvhW/QFfsW23Dw/jX86etfjpfLhn+9y/aTKW6
SOVLbt6oCjK1jMmu90YC1wZLDAhrp14fick1LCzwRtz7YfkNrz5evLizs0Zb4ZbC
OPQh0yP51Uk/a8311SpOUMf8wJsDQiiABgmGF32v//zFENDxGnmr87cjnJmAN7Nh
k12k2pjfk3CXr7jO9A72Y73cfyaAii68JzLTxgsFN9+S7ktAJMWS0OW1P90EVr3D
2EwZUW3huudISgE1VeLx
=sTL1
-----END PGP SIGNATURE-----

--=-5xA0B3/iz8/HD5BHhcst--

