Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41519 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbYJ3KoT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 06:44:19 -0400
Subject: Re: [PATCH 2/4] nl80211: Add basic rate configuration for AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20081029175238.066813010@localhost>
References: <20081029174934.817700763@localhost>
	 <20081029175238.066813010@localhost>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QIU2d6caUIuJIizcLX0Q"
Date: Thu, 30 Oct 2008 11:44:14 +0100
Message-Id: <1225363454.3690.19.camel@johannes.berg> (sfid-20081030_114424_304657_F8C83A80)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QIU2d6caUIuJIizcLX0Q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-10-29 at 19:49 +0200, Jouni Malinen wrote:
> plain text document attachment (basic_rate_config.patch)
> Add a new attribute, NL80211_ATTR_BSS_BASIC_RATES, that can be used with
> NL80211_CMD_SET_BSS for userspace (e.g., hostapd) to set which rates are
> in the basic rate set.

Looks good to me, thanks.

> Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> Index: wireless-testing/include/linux/nl80211.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-testing.orig/include/linux/nl80211.h
> +++ wireless-testing/include/linux/nl80211.h
> @@ -243,6 +243,9 @@ enum nl80211_commands {
>   *	(u8, 0 or 1)
>   * @NL80211_ATTR_BSS_SHORT_SLOT_TIME: whether short slot time enabled
>   *	(u8, 0 or 1)
> + * @NL80211_ATTR_BSS_BASIC_RATES: basic rates, array of basic
> + *	rates in format defined by IEEE 802.11 7.3.2.2 but without the length
> + *	restriction (at most %NL80211_MAX_SUPP_RATES).
>   *
>   * @NL80211_ATTR_HT_CAPABILITY: HT Capability information element (from
>   *	association request when used with NL80211_CMD_NEW_STATION)
> @@ -307,6 +310,8 @@ enum nl80211_attrs {
> =20
>  	NL80211_ATTR_MESH_PARAMS,
> =20
> +	NL80211_ATTR_BSS_BASIC_RATES,
> +
>  	/* add attributes here, update the policy in nl80211.c */
> =20
>  	__NL80211_ATTR_AFTER_LAST,
> @@ -318,6 +323,7 @@ enum nl80211_attrs {
>   * here
>   */
>  #define NL80211_ATTR_HT_CAPABILITY NL80211_ATTR_HT_CAPABILITY
> +#define NL80211_ATTR_BSS_BASIC_RATES NL80211_ATTR_BSS_BASIC_RATES
> =20
>  #define NL80211_MAX_SUPP_RATES			32
>  #define NL80211_MAX_SUPP_REG_RULES		32
> Index: wireless-testing/include/net/cfg80211.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-testing.orig/include/net/cfg80211.h
> +++ wireless-testing/include/net/cfg80211.h
> @@ -280,11 +280,16 @@ struct mpath_info {
>   *	(0 =3D no, 1 =3D yes, -1 =3D do not change)
>   * @use_short_slot_time: Whether the use of short slot time is allowed
>   *	(0 =3D no, 1 =3D yes, -1 =3D do not change)
> + * @basic_rates: basic rates in IEEE 802.11 format
> + *	(or NULL for no change)
> + * @basic_rates_len: number of basic rates
>   */
>  struct bss_parameters {
>  	int use_cts_prot;
>  	int use_short_preamble;
>  	int use_short_slot_time;
> +	u8 *basic_rates;
> +	u8 basic_rates_len;
>  };
> =20
>  /**
> Index: wireless-testing/net/mac80211/cfg.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-testing.orig/net/mac80211/cfg.c
> +++ wireless-testing/net/mac80211/cfg.c
> @@ -1046,6 +1046,24 @@ static int ieee80211_change_bss(struct w
>  		changed |=3D BSS_CHANGED_ERP_SLOT;
>  	}
> =20
> +	if (params->basic_rates) {
> +		int i, j;
> +		u32 rates =3D 0;
> +		struct ieee80211_local *local =3D wiphy_priv(wiphy);
> +		struct ieee80211_supported_band *sband =3D
> +			wiphy->bands[local->oper_channel->band];
> +
> +		for (i =3D 0; i < params->basic_rates_len; i++) {
> +			int rate =3D (params->basic_rates[i] & 0x7f) * 5;
> +			for (j =3D 0; j < sband->n_bitrates; j++) {
> +				if (sband->bitrates[j].bitrate =3D=3D rate)
> +					rates |=3D BIT(j);
> +			}
> +		}
> +		sdata->vif.bss_conf.basic_rates =3D rates;
> +		changed |=3D BSS_CHANGED_BASIC_RATES;
> +	}
> +
>  	ieee80211_bss_info_change_notify(sdata, changed);
> =20
>  	return 0;
> Index: wireless-testing/net/wireless/nl80211.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-testing.orig/net/wireless/nl80211.c
> +++ wireless-testing/net/wireless/nl80211.c
> @@ -95,6 +95,8 @@ static struct nla_policy nl80211_policy[
>  	[NL80211_ATTR_BSS_CTS_PROT] =3D { .type =3D NLA_U8 },
>  	[NL80211_ATTR_BSS_SHORT_PREAMBLE] =3D { .type =3D NLA_U8 },
>  	[NL80211_ATTR_BSS_SHORT_SLOT_TIME] =3D { .type =3D NLA_U8 },
> +	[NL80211_ATTR_BSS_BASIC_RATES] =3D { .type =3D NLA_BINARY,
> +					   .len =3D NL80211_MAX_SUPP_RATES },
> =20
>  	[NL80211_ATTR_MESH_PARAMS] =3D { .type =3D NLA_NESTED },
> =20
> @@ -1613,6 +1615,12 @@ static int nl80211_set_bss(struct sk_buf
>  	if (info->attrs[NL80211_ATTR_BSS_SHORT_SLOT_TIME])
>  		params.use_short_slot_time =3D
>  		    nla_get_u8(info->attrs[NL80211_ATTR_BSS_SHORT_SLOT_TIME]);
> +	if (info->attrs[NL80211_ATTR_BSS_BASIC_RATES]) {
> +		params.basic_rates =3D
> +			nla_data(info->attrs[NL80211_ATTR_BSS_BASIC_RATES]);
> +		params.basic_rates_len =3D
> +			nla_len(info->attrs[NL80211_ATTR_BSS_BASIC_RATES]);
> +	}
> =20
>  	err =3D get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
>  	if (err)
>=20
> --
>=20
> --=20
> Jouni Malinen                                            PGP id EFC895FA
>=20

--=-QIU2d6caUIuJIizcLX0Q
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJCY/7AAoJEKVg1VMiehFYx3IQAJqKDUtoyFxC11pO2dSrtKOH
Me++BIVSor1/k9ckEom6JDdqddyjxIOZzxM50knES1KUmtwS3m4Qc705WNoLTPMH
eBVXfABAgHaoZ21L4OVg85BdGcgIIBjS//gK9lXXviDRG02NiU7NHTqY0Xr7/3xJ
ClfnQ5QDAHIxneqwZlqJf4LNAdkmQ2N8A8qL85qstq+SkByfUA4RAr1qNYfL0z+t
allCxDwnp8TtByHHksjJPv7XBfeDQqiyDcgdUvwpGB1NFefnTlS2qpGKoZnCyT91
MuRBo21HhVDThBTK4l+qABCj/yVUn+S8fJff1kxnrBplCNdc960F0LiqZyGjR1Rm
i0RdTSUqjL5/KIVU20/hk06217hotB9DANbFIsK3jvI9Gl3tz8NKP+mHBZ9294o8
+166gcMctE/HMwA67TcWtkyMx0yZvo1q+xM6dHZLzM0qzijocZyGKqGPFAqN+Pyt
XKgmv8VprzFqfS1VcdS4TWw1bJ+2q6oEYgR3Zp/8W8atXweOXYSOOpPo0FWrhJK6
GutQMN1eIQb05Mgq2qFNO5+/Q57WqxP6QJmLaFRCT5umnk0MKZdhgrjrWBDzoxbm
T344zI8HNgJ4cm/HsISqx9p/0UwPNOXLXS7QMolI0jy1kKvmLxo2mptHbGp1eSu9
hQ1ZsddNMmMUmStYKySj
=Rtqd
-----END PGP SIGNATURE-----

--=-QIU2d6caUIuJIizcLX0Q--

