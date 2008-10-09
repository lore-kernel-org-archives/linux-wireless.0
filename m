Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51127 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756046AbYJIJ44 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2008 05:56:56 -0400
Subject: Re: [PATCH] allow AP interfaces to handle BACK action frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <48ed3fd6.1e068e0a.7847.4d37@mx.google.com> (sfid-20081009_011853_725706_7A53CCE0)
References: <48ed3fd6.1e068e0a.7847.4d37@mx.google.com>
	 (sfid-20081009_011853_725706_7A53CCE0)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UuwOHIOWkYstPLwKFLTe"
Date: Thu, 09 Oct 2008 11:56:57 +0200
Message-Id: <1223546217.22490.31.camel@johannes.berg> (sfid-20081009_115701_441710_9A3E6B3A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UuwOHIOWkYstPLwKFLTe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-10-08 at 16:18 -0700, Andrey Yurovsky wrote:
> Add AP mode to the allowed interface check in ieee80211_rx_h_action.  Thi=
s
> function handles BACK action frames such as ADDBA and AP interfaces need =
to
> receive those.
>=20
> Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>

Fine with me, but I think you need to allow VLAN too? Also, how about
simply removing this check? Can anything bad happen when we try this in
an IBSS or on WDS or on MESH?

johannes

> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index 080b0ce..fe406f5 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -1553,7 +1553,8 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
>  	 *	  of these frames in other modes as well!
>  	 */
>  	if (sdata->vif.type !=3D NL80211_IFTYPE_STATION &&
> -	    sdata->vif.type !=3D NL80211_IFTYPE_ADHOC)
> +	    sdata->vif.type !=3D NL80211_IFTYPE_ADHOC &&
> +	    sdata->vif.type !=3D NL80211_IFTYPE_AP)
>  		return RX_CONTINUE;
> =20
>  	switch (mgmt->u.action.category) {
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=-UuwOHIOWkYstPLwKFLTe
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI7dVmAAoJEKVg1VMiehFYxNUQAJbQSW4NtlSpxJuZqjz4Hkop
wOYPvQ88JorIcE8u7tO/OfFsiHlD8+KrCJT+MwkSCjQHGBny+TlNK88sDLq2bHNN
whsUKDl4hENuG+opYNWAeVG3BFQo2E8LUy1sFrxypI6GbMhbWAG9a3xUxlPLjE7+
7ktmBJhiOWqb0TUgvv98tALWO0JVHxlyf+3sVOe0PrBQqAgYAuAlY8Xos53F+ioZ
VzSMmdTVzczRvsO+seZPpuIKLPyZQTebNtNztt5jFCd25EgK0iVjXVoffpeib8Vz
2Ezw4cs1yB99zgX0EWpa6MvdA3zivKQxDBnTec9giOVibSxEhnsl7y1KoX0uQi/1
tpT9zvLVWt3T+0oBgsGyi+e60CxoBQsQGF4bYMecmGXyQk7KDOOBaOuY7PMXjxIR
cA7dyfezyVWNITjIcH02p4y4/vfPy9bnMHN+a/pix0wN0/6clzpYqiee7yEHrKUv
jPpb1plhmRb3AHhMbqRYpq808e6shSBSdZKnA3Q+APs4uvZ/4PARn9yt6/BvV6DW
5PkFJyzjRxe6zm2A11/HytxPuNGNurE1hd0WVaiKGNONp89K2tIU2pyqCPrU3vgJ
G49152AoMnPtmrUBbSAUJvg9+H6DUP4PHwJX2fnqCB11DqSmeWIZkrqdpkACI5oF
Q8zBQUBT7MkXs0Vv+QMM
=S46h
-----END PGP SIGNATURE-----

--=-UuwOHIOWkYstPLwKFLTe--

