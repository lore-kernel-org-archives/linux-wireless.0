Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:39178 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab2KMRzz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 12:55:55 -0500
Date: Tue, 13 Nov 2012 18:55:47 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Ignacy Gawedzki <i@lri.fr>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCHv3] mac80211: deinitialize ibss-internals after
 emptiness check
Message-ID: <20121113175547.GA19223@pandem0nium> (sfid-20121113_185559_850169_1F9D6C8C)
References: <1352828583-19502-1-git-send-email-siwu@hrz.tu-chemnitz.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
In-Reply-To: <1352828583-19502-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Whoops, there was actually never a version one or two posted here ...
Please consider this version 1.

Sorry,
	Simon

On Tue, Nov 13, 2012 at 06:43:03PM +0100, Simon Wunderlich wrote:
> The check whether the IBSS is active and can be removed should be
> performed before deinitializing the fields used for the check/search.
> Otherwise, the configured BSS will not be found and removed properly.
>=20
> To make it more clear for the future, rename sdata->u.ibss to the
> local pointer ifibss which is used within the checks.
>=20
> This behaviour was introduced by
> f3209bea110cade12e2b133da8b8499689cb0e2e
> ("mac80211: fix IBSS teardown race")
>=20
> Cc: Ignacy Gawedzki <i@lri.fr>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
> ---
>  net/mac80211/ibss.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
> index c7386b2..67774b0 100644
> --- a/net/mac80211/ibss.c
> +++ b/net/mac80211/ibss.c
> @@ -1156,10 +1156,6 @@ int ieee80211_ibss_leave(struct ieee80211_sub_if_d=
ata *sdata)
> =20
>  	mutex_lock(&sdata->u.ibss.mtx);
> =20
> -	sdata->u.ibss.state =3D IEEE80211_IBSS_MLME_SEARCH;
> -	memset(sdata->u.ibss.bssid, 0, ETH_ALEN);
> -	sdata->u.ibss.ssid_len =3D 0;
> -
>  	active_ibss =3D ieee80211_sta_active_ibss(sdata);
> =20
>  	if (!active_ibss && !is_zero_ether_addr(ifibss->bssid)) {
> @@ -1180,6 +1176,10 @@ int ieee80211_ibss_leave(struct ieee80211_sub_if_d=
ata *sdata)
>  		}
>  	}
> =20
> +	ifibss->state =3D IEEE80211_IBSS_MLME_SEARCH;
> +	memset(ifibss->bssid, 0, ETH_ALEN);
> +	ifibss->ssid_len =3D 0;
> +
>  	sta_info_flush(sdata->local, sdata);
> =20
>  	spin_lock_bh(&ifibss->incomplete_lock);
> --=20
> 1.7.10
>=20
>=20

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlCiiaMACgkQrzg/fFk7axbxPACeOk41LYcbQbaCpZ10+DL8rwLo
ALAAoK9vuJaSTUN/yJuSb2us/qzM5qtR
=5ozk
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
