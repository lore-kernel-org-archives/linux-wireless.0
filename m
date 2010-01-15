Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50120 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab0AOKtv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jan 2010 05:49:51 -0500
Subject: Re: [PATCH] mac80211: check that ieee80211_set_power_mgmt only
 handles STA interfaces.
From: Johannes Berg <johannes@sipsolutions.net>
To: Benoit Papillault <benoit.papillault@free.fr>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1263516497-17332-1-git-send-email-benoit.papillault@free.fr>
References: <1263516497-17332-1-git-send-email-benoit.papillault@free.fr>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ea/8idZPNezVaDCgOVqg"
Date: Fri, 15 Jan 2010 11:17:48 +0100
Message-ID: <1263550668.18341.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ea/8idZPNezVaDCgOVqg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-01-15 at 01:48 +0100, Benoit Papillault wrote:
> ieee80211_set_power_mgmt is meant for STA interfaces only. Moreover,
> since sdata->u.mgd.mtx is only initialized for STA interfaces, using
> this code for any other type of interface (like IBSS) will result in a
> oops.

Odd that nobody else ever saw a problem, is everybody running cards that
don't do power management?

> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 8286df5..c9de4e3 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -1382,6 +1382,9 @@ static int ieee80211_set_power_mgmt(struct wiphy
> *wiphy, struct net_device *dev,
>  	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
>  	struct ieee80211_conf *conf =3D &local->hw.conf;
> =20
> +	if (sdata->vif.type !=3D NL80211_IFTYPE_STATION)
> +		return 0;

You want -EOPNOTSUPP here, and cc stable.

johannes

--=-ea/8idZPNezVaDCgOVqg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLUEDHAAoJEODzc/N7+Qma6MgP/0rJcRY5P9XYchomUgilsvFo
i8mG8UZihmFdDUkMaOn7YgDDlEKidFOkqfSAR06FUA+ecsd0KwRsw3zP9QPwpyNs
MFHq15AgsREGijt9jM13rpLCwaBWDnAH+br6/TwkKZoulR4q4yEln5DvOnRPvk9Z
Nu8f9LNX1jzJUWJ5Ro0l4TyC1FxfnqwUclTykrgmxHbSNi/N9yR+Qs3XqFrn/f6l
Km2PRLoj2fvddqDGgtwK9DsEAjngdmHDEEbyQ56wqWkSK9b0JapGZQ+OXTbpKB+q
3OKhpU08hDYhaigg18E/Xw2R9Sq8p/msIWftaeBp6VESrHOIK0zTYZJ7AusmD84+
VeouqICuRTJwXcstL/krE2PH/E/0O5aQKhTPLjbtSu6NWPJXPGh2SFlQvvb7JicB
Hm/Dgwlzq8FS34zMH8XXIZXAWZJoNlCfU/OzShNYquIwfNXzVtznu1obviUnq1FF
wFFsbzFRG3UQ6ZOIjJpTZ2oznvN1osOShGEUgZqKrrAZzNo5QTOr5b7mPucc84g6
1uHEsykl69sMwKOpM3ySD4eiuPwsKjpkcFXr+Fd/TqJUsbw6JN9FTOpzmBi5D+fC
qOueoFwdubp4DMs2ADCO7Hz3QzfGR6mrtmzrqkqmPe03CZ9Rx4DlX7C2Po4o+MLO
Pg8TS+9A2xQuw0YCoTtg
=8YMi
-----END PGP SIGNATURE-----

--=-ea/8idZPNezVaDCgOVqg--

