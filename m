Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44968 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763490AbZAPJ2Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 04:28:16 -0500
Subject: Re: [PATCH 12/13] mac80211: allow mac80211 drivers to get to
	struct ieee80211_hw from wiphy
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1232064746-17134-13-git-send-email-lrodriguez@atheros.com>
References: <1232064746-17134-1-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-2-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-3-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-4-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-5-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-6-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-7-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-8-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-9-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-10-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-11-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-12-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-13-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NzAZ1ITCFvvkoPyi1R3V"
Date: Fri, 16 Jan 2009 10:27:35 +0100
Message-Id: <1232098055.3854.35.camel@johannes> (sfid-20090116_102822_454661_AE416157)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NzAZ1ITCFvvkoPyi1R3V
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-15 at 16:12 -0800, Luis R. Rodriguez wrote:
> If a driver is given a wiphy and it wants to get to its private
> mac80211 driver area it can use wiphy_to_ieee80211_hw() to get first
> to its ieee80211_hw and then access the private structure via hw->priv. T=
he
> wiphy_priv() is already being used internally by mac80211 and drivers
> should not use this. This can be helpful in a drivers reg_notifier().
>=20
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  include/net/mac80211.h |   13 +++++++++++++
>  net/mac80211/util.c    |    9 +++++++++
>  2 files changed, 22 insertions(+), 0 deletions(-)
>=20
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 9a5869e..b29c41b 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -965,6 +965,19 @@ struct ieee80211_hw {
>  };
> =20
>  /**
> + * wiphy_to_ieee80211_hw - return a mac80211 driver hw struct from a wip=
hy
> + *
> + * @wiphy: the &struct wiphy which we want to query
> + *
> + * mac80211 drivers can use this to get to their respective
> + * &struct ieee80211_hw. Drivers wishing to get to their own private
> + * structure can then access it via hw->priv. Note that mac802111 driver=
s should
> + * not use wiphy_priv() to try to get their private driver structure as =
this
> + * is already used internally by mac80211.
> + */
> +struct ieee80211_hw *wiphy_to_ieee80211_hw(struct wiphy *wiphy);
> +
> +/**
>   * SET_IEEE80211_DEV - set device for 802.11 hardware
>   *
>   * @hw: the &struct ieee80211_hw to set the device for
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index 963e047..9016c8d 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -41,6 +41,15 @@ const unsigned char rfc1042_header[] __aligned(2) =3D
>  const unsigned char bridge_tunnel_header[] __aligned(2) =3D
>  	{ 0xaa, 0xaa, 0x03, 0x00, 0x00, 0xf8 };
> =20
> +struct ieee80211_hw *wiphy_to_ieee80211_hw(struct wiphy *wiphy)
> +{
> +	struct ieee80211_local *local;
> +	BUG_ON(!wiphy);
> +
> +	local =3D wiphy_priv(wiphy);
> +	return &local->hw;
> +}
> +EXPORT_SYMBOL(wiphy_to_ieee80211_hw);
> =20
>  u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len,
>  			enum nl80211_iftype type)

--=-NzAZ1ITCFvvkoPyi1R3V
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJcFMFAAoJEKVg1VMiehFYXKQP/3WYovGvlkGcvAWo5w00IHmW
u2dr6V9Ug3aXOsDppSgwT295F0SK4kkkE//UNW+t5rgTzcjCz2mQpqeymS9Q5kWh
HXBdOlTq+JDWizXYfgCwLd6mS853iflgwzdAUbcn8gcRj2J1T/MBDQKIZCDHi7ab
NsJXtX1WzKTnMf2yS0EcnvHGWLGGMIU/rQktmoIcb6qUOF5zVvMIVTIS8FZgOO65
KlyKhs0urpusj5YUJtCRJynAFvrO7Y7mKUbBJ/gqL1Il+opVkupPnDkrZsHX7mb4
QKZefGd6CAbe9Sv6XFEwjBc6A0X450zTqdaazBVZQKzAqVDFyWc2Y8LsK51emIl7
4zxWH6nQ/gCG4GoUApWi+2J2gje3nQE/d+zly/1/fuLoosNOArmHl9SflIi3e77N
EwG/zhLhY2Urip8wgXizNRxMftnOEOkZFQJZ0ODr+xYioAyyE0NGXkHbb562yiWb
V7eKW7b9XfvDuf0GdKCDMnq3dumgDQQqkLhbkt3PAhCsYA/bwaR3DpnXBlrn+nDr
YMcdG3cY5o0mIfCNBa8Z4Eq9fOjjN2xwn13aYyQUpL9CZk0bIUhvFh0Ng1n8f1tH
MQLkeENzxSW8zY0trjqAv/lYiPU5DC3KfsyDpmNquqNzGxe61z9q+p5aJ2UmFM3g
P0E4i9Wvtk1EPkUh0hEX
=8pgh
-----END PGP SIGNATURE-----

--=-NzAZ1ITCFvvkoPyi1R3V--

