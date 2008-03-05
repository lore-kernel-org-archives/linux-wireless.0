Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57759 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757976AbYCEJgM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 04:36:12 -0500
Subject: Re: [linux-wireless] [RFC PATCH]iwlwifi: Fix for monitor mode
	captures management frames only.
From: Johannes Berg <johannes@sipsolutions.net>
To: "Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <BD524EA7912ED5469DFD0BAEF6BC752F035C2DAD@orsmsx411.amr.corp.intel.com>
References: <BD524EA7912ED5469DFD0BAEF6BC752F035C2DAD@orsmsx411.amr.corp.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GB0PHlSbv4gooa3OD8w1"
Date: Wed, 05 Mar 2008 10:35:59 +0100
Message-Id: <1204709759.25502.46.camel@johannes.berg> (sfid-20080305_093645_581937_71F86936)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GB0PHlSbv4gooa3OD8w1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Tue, 2008-03-04 at 19:43 -0800, Kolekar, Abhijeet wrote:
> If monitor mode is set then mac80211 stack now passes the information to
> driver.
>=20
> >From 1e21ee62c88c5defacf49a4044d26677b8a79032 Mon Sep 17 00:00:00 2001
> From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
> Date: Tue, 4 Mar 2008 17:04:56 -0800
> Subject: [PATCH] Monitor mode bug fix.
> Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-4965.c |    5 +++++
>  net/mac80211/ieee80211.c                |   10 ++++++++++
>  2 files changed, 15 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c
> b/drivers/net/wireless/iwlwifi/iwl-4965.c
> index 3e122a9..5ed75aa 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-4965.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
> @@ -3822,6 +3822,11 @@ static void iwl4965_rx_reply_rx(struct
> iwl4965_priv *priv,
>  	/* Find max signal strength (dBm) among 3 antenna/receiver
> chains */
>  	rx_status.ssi =3D iwl4965_calc_rssi(rx_start);
> =20
> +	if (priv->iw_mode =3D=3D IEEE80211_IF_TYPE_MNTR) {
> +		iwl4965_handle_data_packet(priv, 1, include_phy, rxb,
> &rx_status);
> +		return;
> +	}
> +
>  	/* Meaningful noise values are available only from beacon
> statistics,
>  	 *   which are gathered only when associated, and indicate noise
>  	 *   only for the associated network channel ...
> diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
> index 484b063..85e37c8 100644
> --- a/net/mac80211/ieee80211.c
> +++ b/net/mac80211/ieee80211.c
> @@ -327,6 +327,16 @@ static int ieee80211_open(struct net_device *dev)
>  		netif_tx_lock_bh(local->mdev);
>  		ieee80211_configure_filter(local);
>  		netif_tx_unlock_bh(local->mdev);
> +
> +		conf.vif =3D &sdata->vif;
> +		conf.type =3D sdata->vif.type;
> +		conf.mac_addr =3D dev->dev_addr;
> +		res =3D local->ops->add_interface(local_to_hw(local),
> &conf);
> +		if (res && !local->open_count && local->ops->stop)
> +			local->ops->stop(local_to_hw(local));
> +		if (res)
> +			return res;
> +
>  		break;

NACK. Not passing this to the driver is intentional. There's the
radiotap flag (that really indicates "have monitors") to use.

johannes

--=-GB0PHlSbv4gooa3OD8w1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR85pfaVg1VMiehFYAQL21Q/9E5RNsZEnU4Arv33/NWLX2e7cOz92wp72
G0KhyCoegy41f+8HZ1mYkZ0IcegIGFdUm/QNLiRsqeVAPrB5OU57vEHIg4YHg7Lr
IacIageyelYWsnA2kMng/99FBKZyBrCMOTkU4T7zfKPdvqRSJS3h//b2g68mK35j
lHm6LBmn0seWY5Gn+szj7C/ei+//9J0SuRdGE9omtt4jqAq7Skvx7R9Qycy1jYqp
3McFFekxPUVQORlWykouauPRem3NnWshWoI+6q/0zu29h/DYPgSS9v7KsfPC9Aie
nBMilmvuo9ZPD4jZRPfXr/gxoLIG1GGjT+c38zpmBfm0wxBgMU5mf91+79H8SpSV
1XrMlLMM1B9OdonaykgfLHmbPfcZa+uH9fyAISjpQNThK8ZyAQyFNKZl3ePNseq2
1ZLNK/LgQiM67c5m3mr+t4lidYzlnOYqPWtuXqEYB3DQzaaoI4844ImpzycrwxId
8evAts3Ca0EsaUwke3OePTcaPrCfGdz3p3hMoygdVaXlqqEeIwOIhd3qdRpcHNvN
8FHPojTYSqQhmBhFQF/SOw2riIUgEc6Rs7n87kPmUG6JYZiW7/VZDLN6MTD3GN/b
lYbnhO5e73Npyme1c1q1vlI93jnfXl9lT6CJ1xKrFP6FSr5VGD3+w9TpjH3JNS6l
pgZ4wBbrxpo=
=tM1c
-----END PGP SIGNATURE-----

--=-GB0PHlSbv4gooa3OD8w1--

