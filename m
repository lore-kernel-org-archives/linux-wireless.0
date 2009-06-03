Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56925 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbZFCHJQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 03:09:16 -0400
Subject: Re: [PATCH] ath5k: disable beacon interrupt when interface is down
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: linville@tuxdriver.com, henk@god.dyndns.org,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	jirislaby@gmail.com, mickflemm@gmail.com, lrodriguez@atheros.com
In-Reply-To: <1243998186-9200-1-git-send-email-me@bobcopeland.com>
References: <1243998186-9200-1-git-send-email-me@bobcopeland.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-oLeCGPQAxujNDhIv2omy"
Date: Wed, 03 Jun 2009 09:09:04 +0200
Message-Id: <1244012944.7176.16.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oLeCGPQAxujNDhIv2omy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-02 at 23:03 -0400, Bob Copeland wrote:
> When we remove the active interface, there's no need to continue
> sending beacons; doing so would cause a null pointer deref in
> ieee80211_beacon_get().  Disable the interrupt in remove_interface
> and add a WARN_ON(!vif) in case there are other instances lurking.

There's a beacon_enabled setting passed in from mac80211, you should
just use that?

johannes

> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
>  drivers/net/wireless/ath/ath5k/base.c |   17 ++++++++++++++++-
>  1 files changed, 16 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless=
/ath/ath5k/base.c
> index ab2048b..85a00db 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -2070,6 +2070,13 @@ err_unmap:
>  	return ret;
>  }
> =20
> +static void ath5k_beacon_disable(struct ath5k_softc *sc)
> +{
> +	sc->imask &=3D ~(AR5K_INT_BMISS | AR5K_INT_SWBA);
> +	ath5k_hw_set_imr(sc->ah, sc->imask);
> +	ath5k_hw_stop_tx_dma(sc->ah, sc->bhalq);
> +}
> +
>  /*
>   * Transmit a beacon frame at SWBA.  Dynamic updates to the
>   * frame contents are done as needed and the slot time is
> @@ -2757,6 +2764,7 @@ ath5k_remove_interface(struct ieee80211_hw *hw,
>  		goto end;
> =20
>  	ath5k_hw_set_lladdr(sc->ah, mac);
> +	ath5k_beacon_disable(sc);
>  	sc->vif =3D NULL;
>  end:
>  	mutex_unlock(&sc->lock);
> @@ -3060,7 +3068,14 @@ ath5k_beacon_update(struct ieee80211_hw *hw, struc=
t ieee80211_vif *vif)
>  {
>  	int ret;
>  	struct ath5k_softc *sc =3D hw->priv;
> -	struct sk_buff *skb =3D ieee80211_beacon_get(hw, vif);
> +	struct sk_buff *skb;
> +
> +	if (WARN_ON(!vif)) {
> +		ret =3D -EINVAL;
> +		goto out;
> +	}
> +
> +	skb =3D ieee80211_beacon_get(hw, vif);
> =20
>  	if (!skb) {
>  		ret =3D -ENOMEM;

--=-oLeCGPQAxujNDhIv2omy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKJiGNAAoJEODzc/N7+QmaF7YQAJoLla2NPUUxUX1b6c+yCS14
tK2jUORUl4Z2wpv0tyVTh4yStJscjaQOzV7/yfwcbiRo9s/FBjLnu682tMZQ414q
eoODgnTC9oDA0QzTcOw8KEkmsH8kr8yzDeXbGfeUy+6FGfyXN7PajEkbfcWEd+dU
rVPEgghWGoUzHZiHv9g1lQJqrvWGQN3YJQMZ+LmIOaewhPY6m4U+GtTqhdmizh6B
SLCunNf41qEwvKBfv6KdXvk4mMjnJAamEgUnluqWOWHwmK1/jUby9DdnqQhnPCfZ
gFCjK0QaoKnsuPJrPFudoTjfzzXCKWwnisXIyIajHjJZkNMylcjHCLqEbkfY5zKc
wtkFNPxtJds8fHbHzeZSzQ/j8E9nwrTDPbQk/M7qg0lNWmx3ysMklrX65f60mEQY
6SpyXPCNuYT8HrJGI3e1jqebiW0QbLyOUPGcNrBgrHjVf0Ei8+D7lRWCl0qeO6Ay
kLUyeKnukJ2FB8lYptVA+IKFvhUIxAt2vhxepEmwE5qoC24jA9uV8Eug5QL3to/g
S+JqEWRNPd/r4VUAJ4jmkhMtP5R9rrArOtbUMqoLHL71BtOtXei55K+X/Ce0qX96
4GDZ6QNC3IEam2qUMFmdBbUL2LT32TxHS506mtR5J7NgdrWKxnpDdoGWsoehO8ha
DkASCVYsJbFxrtt2rsgO
=Rh7m
-----END PGP SIGNATURE-----

--=-oLeCGPQAxujNDhIv2omy--

