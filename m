Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42459 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbYKXKcS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 05:32:18 -0500
Subject: Re: [PATCH 1/2] mac80211: enabling an AP that can't support fully
	PS clients (wireless-testing).
From: Johannes Berg <johannes@sipsolutions.net>
To: Rami Rosen <ramirose@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org, j@w1.fi
In-Reply-To: <eb3ff54b0811232344m77f979aaj79e9e965eefa325c@mail.gmail.com> (sfid-20081124_084436_838260_D016B0A0)
References: <eb3ff54b0811232344m77f979aaj79e9e965eefa325c@mail.gmail.com>
	 (sfid-20081124_084436_838260_D016B0A0)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RVF/xCcoObi9FBYYf6px"
Date: Mon, 24 Nov 2008 11:32:12 +0100
Message-Id: <1227522732.3599.58.camel@johannes.berg> (sfid-20081124_113222_669792_70F6E08C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RVF/xCcoObi9FBYYf6px
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-11-24 at 09:44 +0200, Rami Rosen wrote:
> This patch enables mac80211 to support the PS challenged mode when
> used in master mode.
> A new attribute, NL80211_ATTR_WIPHY_AP_PS_CHALLENGED, was added to
> nl80211_attrs; also a new member (ap_ps_challenged) was added to
> struct wiphy; and nl80211_send_wiphy() was adjusted accordingly.
>=20
> User space applications (like hostapd) should check the
> NL80211_ATTR_WIPHY_AP_PS_CHALLENGED
> attribute and  display a proper message, if it is set, to inform the
> users.

Jouni, thoughts about the naming? I proposed this to Rami but I'm not
married to it, any better idea?

> Signed-off-by: Rami Rosen <ramirose@gmail.com>
>=20
> diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
> index 7982734..dbe15e0 100644
> --- a/include/linux/nl80211.h
> +++ b/include/linux/nl80211.h
> @@ -256,6 +256,9 @@ enum nl80211_commands {
>   *	supported interface types, each a flag attribute with the number
>   *	of the interface mode.
>   *
> + * @NL80211_ATTR_WIPHY_AP_PS_CHALLENGED: indicates that the wiphy suppor=
t
> + *  for PS is not full.
> + *
>   * @NL80211_ATTR_MAX: highest attribute number currently defined
>   * @__NL80211_ATTR_AFTER_LAST: internal use
>   */
> @@ -316,6 +319,8 @@ enum nl80211_attrs {
>=20
>  	NL80211_ATTR_WIPHY_TXQ_PARAMS,
>=20
> +	NL80211_ATTR_WIPHY_AP_PS_CHALLENGED,
> +
>  	/* add attributes here, update the policy in nl80211.c */
>=20
>  	__NL80211_ATTR_AFTER_LAST,
> @@ -329,6 +334,7 @@ enum nl80211_attrs {
>  #define NL80211_ATTR_HT_CAPABILITY NL80211_ATTR_HT_CAPABILITY
>  #define NL80211_ATTR_BSS_BASIC_RATES NL80211_ATTR_BSS_BASIC_RATES
>  #define NL80211_ATTR_WIPHY_TXQ_PARAMS NL80211_ATTR_WIPHY_TXQ_PARAMS
> +#define NL80211_ATTR_WIPHY_AP_PS_CHALLENGED NL80211_ATTR_WIPHY_AP_PS_CHA=
LLENGED
>=20
>  #define NL80211_MAX_SUPP_RATES			32
>  #define NL80211_MAX_SUPP_REG_RULES		32
> diff --git a/include/net/wireless.h b/include/net/wireless.h
> index aedefa5..c7ec68b 100644
> --- a/include/net/wireless.h
> +++ b/include/net/wireless.h
> @@ -198,6 +198,8 @@ struct wiphy {
>  	u16 interface_modes;
>=20
>  	bool fw_handles_regulatory;
> +	/* enable AP (master mode) when the AP is without proper power saving m=
ode */
> +	bool ap_ps_challenged;
>=20
>  	/* If multiple wiphys are registered and you're handed e.g.
>  	 * a regular netdev with assigned ieee80211_ptr, you won't
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 00121ce..73098fe 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -149,6 +149,8 @@ static int nl80211_send_wiphy(struct sk_buff *msg,
> u32 pid, u32 seq, int flags,
>  	}
>=20
>  	nla_nest_end(msg, nl_modes);
> +	if (dev->wiphy.ap_ps_challenged)
> +	    NLA_PUT_FLAG(msg, NL80211_ATTR_WIPHY_AP_PS_CHALLENGED);
          ^^^^

Use tabs for indentation please.

johannes

--=-RVF/xCcoObi9FBYYf6px
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJKoKnAAoJEKVg1VMiehFYtHAP/2pkLSSIdhtRaqvfUXFDk0Pn
b898pCiCjx3FDMt35paqKNOwphQJb3XPym6aXXsIiIwAw8xR54mp7xRAYcVzQBU+
bso3R9nKc6J0gxK/LinB4yHqoLooL3Rik7OlADUSQ6u6uEgDeKWZedO4uHvzLO2f
Hz+eQ7eNrIIPKYUge6gmGSctVmM3cvKL+JPGU7u7n3T9OzqrMA0pMoMO38PeseCw
JY6Hy5sGTph0ARw/vUv0DoEfvhkohWFumpE0o5peOe33npVR5z3zgK6J2lTBlflB
MLj7ctnydSmeAa3XyVj2Ga1ekkkVsIeZQyWw3aSwhnb2+lWPa5I7LYdhumKlPY6L
UH5+mDuNcD2DQfsmt0tvged6X1xaUnBuwEDk8+o5tZtR8IA389Gg9IJuY6Hs9CLc
8zCy+8KBqH+PNO1uVCbpnjCENgs30DQnGuxB82TrrVR1R90A7++CqsNLwrztQ0O6
GqQ5WdPLEyYYiJkjCof2RITi8Sj6uLnxKSTS9DpvLA+bTk5HiE8uSBZKwNFQRVuD
FhWvVEc/VNqn/3vUD57cnXNHDhQbamM7WEZ7eiUK4vsvVm20QmXQD4ruMYgCQvjg
H3/+Yn/BDxtp4buX/JdIeA3Mg9PLCwkHuxfN/QzuMOfWklO+RabcrYyJmvVGvQu7
55Be6r5A+Dingv8Dya9X
=PDmZ
-----END PGP SIGNATURE-----

--=-RVF/xCcoObi9FBYYf6px--

