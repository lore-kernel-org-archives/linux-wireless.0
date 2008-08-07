Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48496 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366AbYHGN2b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 09:28:31 -0400
Subject: Re: [PATCH] p54: Fix regression due to commit b19fa1f
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>, chunkeey@web.de,
	linux-wireless@vger.kernel.org
In-Reply-To: <489af6ed.hkTX0XTOTIkENssK%Larry.Finger@lwfinger.net> (sfid-20080807_152154_878184_54C32769)
References: <489af6ed.hkTX0XTOTIkENssK%Larry.Finger@lwfinger.net>
	 (sfid-20080807_152154_878184_54C32769)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NyJaAOnI4dZy/NRTn275"
Date: Thu, 07 Aug 2008 15:27:51 +0200
Message-Id: <1218115671.23048.174.camel@johannes.berg> (sfid-20080807_152851_423491_7C4AEC23)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NyJaAOnI4dZy/NRTn275
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-08-07 at 08:21 -0500, Larry Finger wrote:
> From: Christian Lamparter <chunkeey@web.de>
>=20
> For p54pci and p54usb, skb_get_queue_mapping does not work correctly for
> multiple queues.
>=20
> Signed-off-by: Christian Lamparter <chunkeey@web.de>
> Acked by: Larry Finger <Larry.Finger@lwfinger.net>
> CC: stable@kernel.org
> ---
>=20
> Index: wireless-testing/drivers/net/wireless/p54/p54common.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-testing.orig/drivers/net/wireless/p54/p54common.c
> +++ wireless-testing/drivers/net/wireless/p54/p54common.c
> @@ -413,12 +413,12 @@ static void p54_rx_frame_sent(struct iee
>  			last_addr =3D range->end_addr;
>  			__skb_unlink(entry, &priv->tx_queue);
>  			memset(&info->status, 0, sizeof(info->status));
> -			priv->tx_stats[skb_get_queue_mapping(skb)].len--;
>  			entry_hdr =3D (struct p54_control_hdr *) entry->data;
>  			entry_data =3D (struct p54_tx_control_allocdata *) entry_hdr->data;
>  			if ((entry_hdr->magic1 & cpu_to_le16(0x4000)) !=3D 0)
>  				pad =3D entry_data->align[0];
> =20
> +			priv->tx_stats[le32_to_cpu(entry_data->frame_type - 4)].len--;

Sorry for not catching this earlier, but this looks wrong, the -4 surely
should be outside the endian conversion?

johannes

--=-NyJaAOnI4dZy/NRTn275
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJImvhTAAoJEKVg1VMiehFYOIcQAKoGBWxclM4aoyDwLCagSjGe
m13TvRUihLJnA7KWidIc0S7aFgaWHAQzI8wqb5y+8uSpbWe9YL/QsBCBLhd29iJ2
PXfW6Sq4pnAXdKdJxPSY5bX8k3yzhSHgvg7UiJfFzKPAmLgvcKm4RPSYWuII38AI
BvDCKkwe53nUkXZmK0/rkSb6wbBLWnyqmjJ6maWfI8yKT9PkwEoz5TtbkwnF+Pm1
+xu4yK41VOLNBZkJvsrl4HVwvkn8Ir7OwAIv2F5wgqygt+tmi81MrN8G8cRMjMmh
IH+PTms8c5RL2M4AGpN/rBpcJ6RwelhWe3UiZw8YapHxNockywB1xHPMotMcUTCw
EQFaRTXR5p11iBUMrW0t1PgqvS1OE+gXxPcZgx9OddZpCq4JvIX/S/sPapBKjCzO
ANAj3RdhsE+Ou+bYdmDN2NwiWpm80jtVr8lggk+4SGX4I1Rw3AqFnLGR+KBlFqbb
6cg/kl6o8U6xwinKYxU7WKaQ30E1e58sV8HKV3Vo/sQFPAOw884Gju/Hl3xDp/sz
CagEeoadnsq7EAlf7NK3W+KxcdbtUZqS5u+YDLIiaHSJTYfZmGrX5sH/walKXpRn
0J1pYhq7bZ7FWoVinZyDVU1gml1B1mQGixTRvvIBGb9quOvP5VJYlx1T04k5twql
oNRtQI6HoQcHM+uQ+xxf
=bIrG
-----END PGP SIGNATURE-----

--=-NyJaAOnI4dZy/NRTn275--

