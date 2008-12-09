Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39746 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbYLIPLF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 10:11:05 -0500
Subject: Re: [RFC] mac80211: Disable requests for new scans in AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20081209145722.GA2285@jm.kir.nu> (sfid-20081209_155731_121545_5A093E5A)
References: <20081209145722.GA2285@jm.kir.nu>
	 (sfid-20081209_155731_121545_5A093E5A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-uaqby9Uk0dWSMggMG/Zh"
Date: Tue, 09 Dec 2008 16:10:30 +0100
Message-Id: <1228835431.1029.4.camel@johannes.berg> (sfid-20081209_161110_764612_BE2A1859)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-uaqby9Uk0dWSMggMG/Zh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-12-09 at 16:57 +0200, Jouni Malinen wrote:
> AP mode operations are seriously affected if mac80211 runs through a
> multi-second scan while the AP is trying to send Beacon frames on the
> operation channel. While this could be implemented in a way that does
> not cause too many problems, it is not very simple and will require
> synchronization with Beacon frame scheduling in the drivers (scan one
> channel at a time between Beacon frames). Furthermore, such scanning
> takes quite a bit longer time and existing userspace applications
> would be likely to timeout while waiting for the results.
>=20
> For now, just refuse requests for new scans (SIOCSIWSCAN) when in AP
> mode. In practice, this moves the rejection from iwl* drivers into
> mac80211 to make it apply to every mac80211-based driver.
>=20
> This issue shows up in associated stations getting disconnected when
> something (e.g., Network Manager) requests a scan while the interface
> is in AP mode. When doing this continuously (e.g., NM does it every 60
> seconds), the network gets close to useless.
>=20
> Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

>=20
> Index: wireless-testing/drivers/net/wireless/iwlwifi/iwl-agn.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-agn.c	2008-12-=
09 16:27:49.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-agn.c	2008-12-09 16=
:31:25.000000000 +0200
> @@ -2972,12 +2972,6 @@ static int iwl_mac_hw_scan(struct ieee80
>  		goto out_unlock;
>  	}
> =20
> -	if (priv->iw_mode =3D=3D NL80211_IFTYPE_AP) {	/* APs don't scan */
> -		ret =3D -EIO;
> -		IWL_ERROR("ERROR: APs don't scan\n");
> -		goto out_unlock;
> -	}
> -
>  	/* We don't schedule scan within next_scan_jiffies period.
>  	 * Avoid scanning during possible EAPOL exchange, return
>  	 * success immediately.
> Index: wireless-testing/drivers/net/wireless/iwlwifi/iwl3945-base.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	200=
8-12-09 16:34:51.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-12-=
09 16:35:14.000000000 +0200
> @@ -2105,11 +2105,6 @@ static void iwl3945_setup_rxon_timing(st
> =20
>  static int iwl3945_scan_initiate(struct iwl3945_priv *priv)
>  {
> -	if (priv->iw_mode =3D=3D NL80211_IFTYPE_AP) {
> -		IWL_ERROR("APs don't scan.\n");
> -		return 0;
> -	}
> -
>  	if (!iwl3945_is_ready_rf(priv)) {
>  		IWL_DEBUG_SCAN("Aborting scan due to not ready.\n");
>  		return -EIO;
> @@ -6991,12 +6986,6 @@ static int iwl3945_mac_hw_scan(struct ie
>  		goto out_unlock;
>  	}
> =20
> -	if (priv->iw_mode =3D=3D NL80211_IFTYPE_AP) {	/* APs don't scan */
> -		rc =3D -EIO;
> -		IWL_ERROR("ERROR: APs don't scan\n");
> -		goto out_unlock;
> -	}
> -
>  	/* we don't schedule scan within next_scan_jiffies period */
>  	if (priv->next_scan_jiffies &&
>  			time_after(priv->next_scan_jiffies, jiffies)) {
> Index: wireless-testing/net/mac80211/wext.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-testing.orig/net/mac80211/wext.c	2008-12-09 16:31:01.0000000=
00 +0200
> +++ wireless-testing/net/mac80211/wext.c	2008-12-09 16:31:13.000000000 +0=
200
> @@ -418,8 +418,7 @@ static int ieee80211_ioctl_siwscan(struc
> =20
>  	if (sdata->vif.type !=3D NL80211_IFTYPE_STATION &&
>  	    sdata->vif.type !=3D NL80211_IFTYPE_ADHOC &&
> -	    sdata->vif.type !=3D NL80211_IFTYPE_MESH_POINT &&
> -	    sdata->vif.type !=3D NL80211_IFTYPE_AP)
> +	    sdata->vif.type !=3D NL80211_IFTYPE_MESH_POINT)
>  		return -EOPNOTSUPP;
> =20
>  	/* if SSID was specified explicitly then use that */
>=20

--=-uaqby9Uk0dWSMggMG/Zh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJPopjAAoJEKVg1VMiehFYpYIP/1xeJJk3sJeQFoJkeHF9w62V
060VVa7cHylQF4fMmQAn5hhyKSK/q2bnqQzKesEO4YCEtdP9378TQ8jSWFl5xYIM
MEZ4yZQ5E65huLF13GD63bUbTkuqZqDjDmGaqZkoVPPMfL9HIaEVXt65s7AItrDf
6rJU0Ai5L42tnuauDyZ1y5VIPG5XBkmheb3+OUOHPLAczlQYkIdXVTZP3KNTmjak
nupOw18CvoQuZsZZLDU7GqRLW6o5c9wuZICAwN6iJfxQF6mFNsmyICTLq8a7UshL
GzFOFgWA71ToH8WScT/F5mOu2CzUo68pVNn0f4ya60bGOKkNb84pEB03ddXl+Aak
UPrR7Lu+UUCzwM102dOpqiAuDZL55OS3upPdOu32rNXtFCHKZs8ehoibdVm36Jjc
OYSuUkksIW8lhzNlYgrAwNQsrBzL1egak4VHqSUPzv+pf5m9xT8LRlyGAP20gv1R
NE6rPTL1h0jnL16iRAupE9liTg6hnhzEvEINYDXw0KgvdP6sZecgPVFqwFac7rKr
mqx7HQde6IqH8lIMdej9ih6EQRPz6bf3QMwU9L+m5Ak+mcP1i3GumZDzNaBIwOlK
Hdra88CIVLnJEpRjPNTlKicOSkAPBH7G4VgWFNt0vB/EJzaSoamL0bQbXdmPfwcg
LP/xVNYG0nArRG3fDpgk
=j+sj
-----END PGP SIGNATURE-----

--=-uaqby9Uk0dWSMggMG/Zh--

