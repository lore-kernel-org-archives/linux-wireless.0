Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44904 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764985AbZAPJ0b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 04:26:31 -0500
Subject: Re: [PATCH 09/13] cfg80211: rename fw_handles_regulatory to
	custom_regulatory
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1232064746-17134-10-git-send-email-lrodriguez@atheros.com>
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
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/GDQC6UBZGOtTY6JZ4JD"
Date: Fri, 16 Jan 2009 10:25:59 +0100
Message-Id: <1232097959.3854.29.camel@johannes> (sfid-20090116_102651_901867_6320E8E4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/GDQC6UBZGOtTY6JZ4JD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-15 at 16:12 -0800, Luis R. Rodriguez wrote:
> Drivers without firmware can also have custom regulatory maps
> which do not map to a specific ISO / IEC alpha2 country code.

Seems fine.

> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-core.c     |    2 +-
>  drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
>  include/net/wireless.h                      |    6 +++---
>  net/wireless/reg.c                          |    2 +-
>  4 files changed, 6 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wirele=
ss/iwlwifi/iwl-core.c
> index d2ef3e1..1d568ac 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-core.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-core.c
> @@ -811,7 +811,7 @@ int iwl_setup_mac(struct iwl_priv *priv)
>  		BIT(NL80211_IFTYPE_STATION) |
>  		BIT(NL80211_IFTYPE_ADHOC);
> =20
> -	hw->wiphy->fw_handles_regulatory =3D true;
> +	hw->wiphy->custom_regulatory =3D true;
> =20
>  	/* Default value; 4 EDCA QOS priorities */
>  	hw->queues =3D 4;
> diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wi=
reless/iwlwifi/iwl3945-base.c
> index 15425a0..bbd44d5 100644
> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> @@ -7388,7 +7388,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, =
const struct pci_device_id *e
>  		BIT(NL80211_IFTYPE_STATION) |
>  		BIT(NL80211_IFTYPE_ADHOC);
> =20
> -	hw->wiphy->fw_handles_regulatory =3D true;
> +	hw->wiphy->custom_regulatory =3D true;
> =20
>  	/* 4 EDCA QOS priorities */
>  	hw->queues =3D 4;
> diff --git a/include/net/wireless.h b/include/net/wireless.h
> index 232047b..21e45bf 100644
> --- a/include/net/wireless.h
> +++ b/include/net/wireless.h
> @@ -184,8 +184,8 @@ struct ieee80211_supported_band {
>   * @ignore_country_ies: tells us the wireless core should ignore country=
 IEs
>   *	received by itself or by other wireless drivers. This will only
>   *	apply if the driver has provided a regulatory_hint()
> - * @fw_handles_regulatory: tells us the firmware for this device
> - * 	has its own regulatory solution and cannot identify the
> + * @custom_regulatory: tells us the driver for this device
> + * 	has its own custom regulatory domain and cannot identify the
>   * 	ISO / IEC 3166 alpha2 it belongs to. When this is enabled
>   * 	we will disregard the first regulatory hint (when the
>   * 	initiator is %REGDOM_SET_BY_CORE).
> @@ -204,7 +204,7 @@ struct wiphy {
>  	/* Supported interface modes, OR together BIT(NL80211_IFTYPE_...) */
>  	u16 interface_modes;
> =20
> -	bool fw_handles_regulatory;
> +	bool custom_regulatory;
>  	bool ignore_country_ies;
> =20
>  	/* If multiple wiphys are registered and you're handed e.g.
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index f0ad937..8bf999d 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -1009,7 +1009,7 @@ static bool ignore_reg_update(struct wiphy *wiphy, =
enum reg_set_by setby)
>  	if (!last_request)
>  		return true;
>  	if (setby =3D=3D REGDOM_SET_BY_CORE &&
> -		  wiphy->fw_handles_regulatory)
> +		  wiphy->custom_regulatory)
>  		return true;
>  	return false;
>  }

--=-/GDQC6UBZGOtTY6JZ4JD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJcFKlAAoJEKVg1VMiehFYQ2UQAJ/sdhBcvEXRJMq3vYbLMRMV
QAANoU5ba7sUR+wp7l3JOX/2GB+yJ0+RGHCTAeAUrc/DgvbLY6z6NAmmppHaZw0i
XX7TynPgN/iTYrCBOCekaBM2IbfzXCUgoQisypGuYu6X1i7NRxmi/8my4RlhGQeU
sN/JP6ajoOcR+ysS3Bfbe2ziaI822JsEg5FdCxeNj9w230vHzUWheV5BpMr0PPPq
EAy82esYcDDofBFVTLFP4qUOwBqNNhP6WhsM4FsCVPONaIZr4FRNeApCrUh7WD9I
J+yU+WXm/gV+Ci/19brfa+C5y+liwEbdEi24UICeJhnPwcrc2yK58dgq104Rrt4H
ViQuG6Y9mhxs7bhBCzhlRpc6tx3oFT1DnP5ml38KuCwvn9wefmvWlhJZb9wjsDPS
heJfM7piZUu/t1MCX1nmgkTKFFeNFKz1hS6XVuIeAuRMExj0bFGYz+TN+Cj0tmEV
kDIHYpxO6DCvtyEYMlgZW9tcHZ7DZR4BiXwYT0PFWtHBMXvwtLi9khN7c8IXz7BR
Ho4CluHa1bXW4NxrtIlWCEXllipmQeQ6NxmL/gxVLxZmy9HBHPEuS8I9GuK1PfKW
uMDRqpIHbTHM15REKoNX+5q4xwkOkZ/NAomhE27ITyvTlQEwusgtLHypEN2IONOx
VkDEJOfXtBbRAIVPFr9j
=y/93
-----END PGP SIGNATURE-----

--=-/GDQC6UBZGOtTY6JZ4JD--

