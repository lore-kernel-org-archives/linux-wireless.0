Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:38230 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab2HZURO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Aug 2012 16:17:14 -0400
Date: Sun, 26 Aug 2012 22:17:01 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] ath9k_htc: advertise allowed VIFs combination
Message-ID: <20120826201701.GL7642@ritirata.org> (sfid-20120826_221751_599897_8FD2B251)
References: <1345968773-17166-1-git-send-email-ordex@autistici.org>
 <1345968773-17166-2-git-send-email-ordex@autistici.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lR6P3/j+HGelbRkf"
In-Reply-To: <1345968773-17166-2-git-send-email-ordex@autistici.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--lR6P3/j+HGelbRkf
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 26, 2012 at 10:12:53AM +0200, Antonio Quartulli wrote:
> This driver now advertises its allowed VIFs combination to the mac80211
> sublayer.
>=20
> Signed-off-by: Antonio Quartulli <ordex@autistici.org>

John I'll send v2 of this too because we also want to avoid that:
num_IBSS + num_AP <=3D ATH9K_HTC_MAX_BCN_VIF
and this is not the case with the current interface limitation I provided.

Cheers,


> ---
>  drivers/net/wireless/ath/ath9k/htc_drv_init.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>=20
> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/=
wireless/ath/ath9k/htc_drv_init.c
> index a035a38..59965e2 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
> @@ -689,6 +689,19 @@ err_hw:
>  	return ret;
>  }
> =20
> +static const struct ieee80211_iface_limit if_limits[] =3D {
> +	{ .max =3D ATH9K_HTC_MAX_VIF,  .types =3D BIT(NL80211_IFTYPE_STATION) },
> +	{ .max =3D ATH9K_HTC_MAX_BCN_VIF,  .types =3D BIT(NL80211_IFTYPE_AP) },
> +	{ .max =3D 1,  .types =3D BIT(NL80211_IFTYPE_ADHOC) },
> +};
> +
> +static const struct ieee80211_iface_combination if_comb =3D {
> +	.limits =3D if_limits,
> +	.n_limits =3D ARRAY_SIZE(if_limits),
> +	.max_interfaces =3D ATH9K_HTC_MAX_VIF,
> +	.num_different_channels =3D 1,
> +};
> +
>  static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
>  			       struct ieee80211_hw *hw)
>  {
> @@ -711,6 +724,9 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv =
*priv,
>  		BIT(NL80211_IFTYPE_P2P_GO) |
>  		BIT(NL80211_IFTYPE_P2P_CLIENT);
> =20
> +	hw->wiphy->iface_combinations =3D &if_comb;
> +	hw->wiphy->n_iface_combinations =3D 1;
> +
>  	hw->wiphy->flags &=3D ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
> =20
>  	hw->wiphy->flags |=3D WIPHY_FLAG_IBSS_RSN |
> --=20
> 1.7.12
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--lR6P3/j+HGelbRkf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlA6hD0ACgkQpGgxIkP9cwdt+QCdE2Tcx6lAIcFk2nAtyR8ra4Db
fJoAnRByJtuzCcfOCyhscHX9185ICezi
=n+Ao
-----END PGP SIGNATURE-----

--lR6P3/j+HGelbRkf--
