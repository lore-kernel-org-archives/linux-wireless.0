Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:53248 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756323Ab3DQQjc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 12:39:32 -0400
Date: Wed, 17 Apr 2013 18:39:22 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com
Subject: Re: [PATCH 2/2] ath9k: always set common->macaddr to the MAC
 adress of a virtual interface
Message-ID: <20130417163922.GA22804@pandem0nium> (sfid-20130417_183937_355182_209FA722)
References: <1366109517-64645-1-git-send-email-nbd@openwrt.org>
 <1366109517-64645-2-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
In-Reply-To: <1366109517-64645-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 16, 2013 at 12:51:57PM +0200, Felix Fietkau wrote:
> In some cases it can be useful to change the MAC address of a virtual
> interface to something that's completely different from the EEPROM
> stored MAC address. In this case it is a bad idea to use the EEPROM MAC
> address for calculating the BSSID mask, as that would make it too wide.
>=20
> In one case a few devices have been observed to send ACKs for many
> packets on the channel not directed at them, which results in a neat
> Denial of Service attack on the channel.

This was really giving me a hard time. Thanks a lot for finding the cause
and fixing that. :)

Cheers,
	Simon
>=20
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  drivers/net/wireless/ath/ath9k/ath9k.h | 7 +++----
>  drivers/net/wireless/ath/ath9k/main.c  | 9 +++++++--
>  2 files changed, 10 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireles=
s/ath/ath9k/ath9k.h
> index 86d3572..1915f12 100644
> --- a/drivers/net/wireless/ath/ath9k/ath9k.h
> +++ b/drivers/net/wireless/ath/ath9k/ath9k.h
> @@ -658,11 +658,10 @@ enum sc_op_flags {
>  struct ath_rate_table;
> =20
>  struct ath9k_vif_iter_data {
> -	const u8 *hw_macaddr; /* phy's hardware address, set
> -			       * before starting iteration for
> -			       * valid bssid mask.
> -			       */
> +	u8 hw_macaddr[ETH_ALEN]; /* address of the first vif */
>  	u8 mask[ETH_ALEN]; /* bssid mask */
> +	bool has_hw_macaddr;
> +
>  	int naps;      /* number of AP vifs */
>  	int nmeshes;   /* number of mesh vifs */
>  	int nstations; /* number of station vifs */
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless=
/ath/ath9k/main.c
> index a383483..6963862 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -839,10 +839,14 @@ static void ath9k_vif_iter(void *data, u8 *mac, str=
uct ieee80211_vif *vif)
>  	struct ath9k_vif_iter_data *iter_data =3D data;
>  	int i;
> =20
> -	if (iter_data->hw_macaddr)
> +	if (iter_data->has_hw_macaddr) {
>  		for (i =3D 0; i < ETH_ALEN; i++)
>  			iter_data->mask[i] &=3D
>  				~(iter_data->hw_macaddr[i] ^ mac[i]);
> +	} else {
> +		memcpy(iter_data->hw_macaddr, mac, ETH_ALEN);
> +		iter_data->has_hw_macaddr =3D true;
> +	}
> =20
>  	switch (vif->type) {
>  	case NL80211_IFTYPE_AP:
> @@ -891,7 +895,6 @@ void ath9k_calculate_iter_data(struct ieee80211_hw *h=
w,
>  	 * together with the BSSID mask when matching addresses.
>  	 */
>  	memset(iter_data, 0, sizeof(*iter_data));
> -	iter_data->hw_macaddr =3D common->macaddr;
>  	memset(&iter_data->mask, 0xff, ETH_ALEN);
> =20
>  	if (vif)
> @@ -901,6 +904,8 @@ void ath9k_calculate_iter_data(struct ieee80211_hw *h=
w,
>  	ieee80211_iterate_active_interfaces_atomic(
>  		sc->hw, IEEE80211_IFACE_ITER_RESUME_ALL,
>  		ath9k_vif_iter, iter_data);
> +
> +	memcpy(common->macaddr, iter_data->hw_macaddr, ETH_ALEN);
>  }
> =20
>  /* Called with sc->mutex held. */
> --=20
> 1.8.0.2
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlFu0DoACgkQrzg/fFk7axb72QCghAfAO8iQSvEdV54b+WIk7jvL
KLQAoLsLLqWa8zlXvuS+LoFNjKP0mERB
=WQZe
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
