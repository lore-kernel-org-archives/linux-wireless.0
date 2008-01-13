Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52184 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019AbYAMVnX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jan 2008 16:43:23 -0500
Subject: Re: [PATCH 1/2] mac80211: A-MPDU Rx stop aggregation on proper dev
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <12002413181718-git-send-email-ron.rindjunsky@intel.com>
References: <12002413181718-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-EoXJ6HDWC7QYTEwyhL93"
Date: Sun, 13 Jan 2008 22:43:03 +0100
Message-Id: <1200260583.5887.8.camel@johannes.berg> (sfid-20080113_214327_860073_94E46577)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-EoXJ6HDWC7QYTEwyhL93
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Sun, 2008-01-13 at 18:21 +0200, Ron Rindjunsky wrote:
> This patch adds a check to insure that Rx A-MPDU will be stopped only
> for the proper device.

Thanks.

> Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/ieee80211.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
>=20
> diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
> index 1770402..5dcc2d6 100644
> --- a/net/mac80211/ieee80211.c
> +++ b/net/mac80211/ieee80211.c
> @@ -299,9 +299,11 @@ static int ieee80211_stop(struct net_device *dev)
>  	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> =20
>  	list_for_each_entry(sta, &local->sta_list, list) {
> -		for (i =3D 0; i <  STA_TID_NUM; i++)
> -			ieee80211_sta_stop_rx_ba_session(sta->dev, sta->addr,
> -						i, WLAN_BACK_RECIPIENT,
> +		if (sta->dev =3D=3D dev)
> +			for (i =3D 0; i <  STA_TID_NUM; i++)
> +				ieee80211_sta_stop_rx_ba_session(sta->dev,
> +						sta->addr, i,
> +						WLAN_BACK_RECIPIENT,
>  						WLAN_REASON_QSTA_LEAVE_QBSS);
>  	}
> =20

--=-EoXJ6HDWC7QYTEwyhL93
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4qF5qVg1VMiehFYAQLOpxAAvcSFwLKwytJu5vC58Gj+qHTwot9ft68H
9aBpQllSumfG7E8fTW9EZKC4ZbYWhV+TiWoJlLqbzmf1EgCbGhr27/scfO5ESFLO
7jFyCFnitBfW3ZUTWWB3DScwaumReE1ozT2fRL/eZDnps6zjE1grtDBUlJblsyMJ
rafXp7Ao0njHuYBmLCy/nFgCoNXeY1a1mUdNvTxvrYv1Veef8nOt4mob6nRnkoct
RvAp3klXWceYc8zrvGYCtpZDqMnnjiLSWCG6HFrcuFkmXx+hZpNYVMAuwFxLw9va
/iAZoy3SeJILB8OfE2OJSRrOymc7HQXVif9lg6kujeY78p5jNxkPUUykJViYUWkf
XyKXABWTKVzFh/4ljlBDiNMtSX85mJX5taQusrg4YPVhiCkXqROx8Tx92BVgp+um
mWA7ExtVWha1ewQyK+kns3VPnA/10vpAv5DhPVtKiQdqbpuSufrhK24rPb9Izqkg
bOeeymCX2B/jScFW5jVs7WB2GPr2SG8Tf0A6kugYHsMzctphzH/kgOnNwHb8A4L6
pySWuh4cpunIR3QjizNdhpfSjO4dUo0CgCAR1vkTAl6q70bNHxRx8+WTYvSuGFqU
O709VoUQCOD6+kOS+MBHf0AgQVrHCxsPxMc9RSlofKnqB1JW5XCOMKdbejOzabxh
gz1Q9jOlPEk=
=LuXp
-----END PGP SIGNATURE-----

--=-EoXJ6HDWC7QYTEwyhL93--

