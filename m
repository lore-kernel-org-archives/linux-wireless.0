Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58879 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469AbYDAMA0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 08:00:26 -0400
Subject: Re: [PATCH] mac80211: use recent multicast table for all mesh
	multicast frames, not only broadcast
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <47f189af.09038e0a.2eb1.ffffb304@mx.google.com> (sfid-20080401_020242_031816_0B005E21)
References: <47f189af.09038e0a.2eb1.ffffb304@mx.google.com>
	 (sfid-20080401_020242_031816_0B005E21)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FVsDQM/oBlYwG1JEeSqM"
Date: Tue, 01 Apr 2008 14:00:22 +0200
Message-Id: <1207051222.5143.52.camel@johannes.berg> (sfid-20080401_130031_822336_C9B59A37)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FVsDQM/oBlYwG1JEeSqM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Seems appropriate but I haven't checked the spec.

On Mon, 2008-03-31 at 15:33 -0700, Luis Carlos Cobo wrote:
> Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
> ---
>  net/mac80211/rx.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index d9c6ed5..0ac6db5 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -433,7 +433,7 @@ ieee80211_rx_mesh_check(struct ieee80211_rx_data *rx)
>  		}
> =20
>  	 } else if ((rx->fc & IEEE80211_FCTL_FTYPE) =3D=3D IEEE80211_FTYPE_DATA=
 &&
> -		    is_broadcast_ether_addr(hdr->addr1) &&
> +		    is_multicast_ether_addr(hdr->addr1) &&
>  		    mesh_rmc_check(hdr->addr4, msh_h_get(hdr, hdrlen), rx->dev))
>  		return RX_DROP_MONITOR;
>  #undef msh_h_get

--=-FVsDQM/oBlYwG1JEeSqM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/Ij1KVg1VMiehFYAQKEKRAAxW6Lav0CJ9qxUKbuBMtwal2ukN3Km4K3
OCo5gJWMo9GsHXtANsH4uglQtkv9Rgm9qTscgpfLqf3LOa158x7spCtncu7aQ0mn
abtcqNBNi9TqXLN/mvXxElQRxVWIi8Aq3t88jpedHs5ik8NaEJ+Pe/cEOsRdFXt8
cW3TncZFA+wh6mheD38cAtxH5IrxXMPHBrU7Wzhq1GOdVFWLkWXzeLhnCfn9CeUp
kDK12fLWEpB9gc0vijzpCP2rszDLkg//bNqZOksYsa4kE5NNVAWfuw2lg8ySfiuN
kUw0MkbbM8DBdheT1IwSyZmUUCjGKMxZjMeAb6Fpf9tg9JqyA5cIrysAyTnODK4E
Xw1Nk7mUYDruRS+OtjWAi1o/G2lJpBIU2Y7fAQtENyIo29a/RSZu9tA2VurabXka
+Bf2h00AxqO+BUt9dm/D4Yo4DrHtP4JP1cOEtQZDbR9WtScYdRj0Z0Ki9gLUnPDz
EHWLt6lc9SYGEaVLINwlZ2pUsmRJdKo+gkMEpLKCiETn8d0EhJKiFiwsz+U5fgYe
SQQYP67AUFugcBUybY463tQGArSgui9EIQsHZT7Wlt2p9JZKsJ0AF981ZJFIZQef
b74JWSONhQDPUDDxRW3RfbgtTDkd3TTtCQfV0CHAFZ4xASKWyefG4Cxb9/VT3L0h
8qePQdIO8Xs=
=LnQd
-----END PGP SIGNATURE-----

--=-FVsDQM/oBlYwG1JEeSqM--

