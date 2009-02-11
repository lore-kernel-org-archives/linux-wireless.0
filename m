Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58823 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709AbZBKQ5s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 11:57:48 -0500
Subject: Re: [PATCH] mac80211: Make sure non-HT connection when
	IEEE80211_STA_TKIP_WEP_USED is set
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1234370929-19519-1-git-send-email-vasanth@atheros.com>
References: <1234370929-19519-1-git-send-email-vasanth@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-F0ygMlHH4YVFVgqUk3zW"
Date: Wed, 11 Feb 2009 17:57:44 +0100
Message-Id: <1234371464.16004.11.camel@johannes.local> (sfid-20090211_175751_874412_019B2C91)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-F0ygMlHH4YVFVgqUk3zW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-02-11 at 22:18 +0530, Vasanthakumar Thiagarajan wrote:
> It is possible that some broken AP might send HT IEs in it's
> assoc response even though the STA has not sent them in assoc req
> when WEP/TKIP is used as pairwise cipher suite. Also it is important
> to check this bit before enabling ht mode in beacon receive path.
>=20
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> ---
>  net/mac80211/mlme.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 169f10c..e7aafb0 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -1532,7 +1532,8 @@ static void ieee80211_rx_mgmt_assoc_resp(struct iee=
e80211_sub_if_data *sdata,
>  					 elems.wmm_param_len);
> =20
>  	if (elems.ht_info_elem && elems.wmm_param &&
> -	    (ifsta->flags & IEEE80211_STA_WMM_ENABLED))
> +	    (ifsta->flags & IEEE80211_STA_WMM_ENABLED) &&
> +	    !(ifsta->flags & IEEE80211_STA_TKIP_WEP_USED))

Maybe we should have a separate flag for _REQUESTED_HT? I'm thinking
here that possibly we might be adding more conditions under which we do
not request HT?

Otherwise, looks ok to me.

johannes

--=-F0ygMlHH4YVFVgqUk3zW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJkwOFAAoJEKVg1VMiehFYKQgQAKDJ4dtppIehWA5qCGvmO9xw
myEzDs1unmSksFWJJkTbnWSzP6cBoDVODUdqMmpcgzg47YF9nRSC7VAyHX7HHofp
5opdqmWjY80nmcs2xf9zhhTS0uqVBlLSqAEn45kP4H9qRroTvf3t2lzWZfXfYc56
vquuHVXmnxZLPZcdHJImilDiE9/C4zOlRRvoR3qB6oSmlYabI+ytZHSIgqtmsPkx
1i1Eaes8QFIrTWHZWpTKEJdw9m3+33fxf/KXe4NTnkfKmGyVHw2NZEEehmstXF2b
1DyrHrGHQiV2ZyNAEx6WCIt3hOAlrZU6epKD+Uq0Zb0/iocTPDuCrEO+rBw9CamI
Aul6cnQg1LJ6+yxa6+nZeuOTFljFh2CviCCu7LCSVgU0NibqosrJDAhHU99P8OjH
TchYigXAJXEDHoxLgmRm+D2UE6j69852F6gkwZpfEEuEF7AjKMd0pfu5m99qDkUV
exxa5Q9W8nu07V5fYOmBkL4mKHBFzTE7qRw1OxN8dQaj0WbWXcJtCxWwumDi0+6L
q09WAr4SIWkI9dvOtLY5Gj98rFYDFcaSn/9v3K0SaC94KZ1gd+LxwcbZMZy9wYoL
BToy5QC0P3KlxloJoifbQcJkq3PeEBj8D2djq8a5aABS/wpyxIXtAAMRJ00rfakU
R5EXjW6U6U+uvIlNIKH/
=ADGB
-----END PGP SIGNATURE-----

--=-F0ygMlHH4YVFVgqUk3zW--

