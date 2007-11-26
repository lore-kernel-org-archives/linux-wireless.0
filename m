Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41839 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbXKZQfZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 11:35:25 -0500
Subject: Re: [PATCH 06/15] mac80211: adding 802.11n essential A-MSDU Rx
	capability
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com
In-Reply-To: <119608649124-git-send-email-ron.rindjunsky@intel.com>
References: <11960864823402-git-send-email-ron.rindjunsky@intel.com>
	 <119608649124-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-pTTpitcUGKUYMoAUeeNw"
Date: Mon, 26 Nov 2007 17:35:19 +0100
Message-Id: <1196094919.4149.303.camel@johannes.berg> (sfid-20071126_163527_655158_64DFDB15)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-pTTpitcUGKUYMoAUeeNw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2007-11-26 at 16:14 +0200, Ron Rindjunsky wrote:
> This patch adds the ability to receive and handle A-MSDU frames.
>=20
> Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

Thanks for your patience on this. I have another question that is
identical in the other code and that we should, if necessary, fix in a
separate patch to fix both instances of this:


> +		payload =3D frame->data;
> +		ethertype =3D (payload[6] << 8) | payload[7];
> +
> +		if (likely((compare_ether_addr(payload, rfc1042_header) =3D=3D 0 &&
[...]
> +		} else {
> +			memcpy(skb_push(frame, sizeof(__be16)), &len,
> +				sizeof(__be16));
> +			memcpy(skb_push(frame, ETH_ALEN), src, ETH_ALEN);
> +			memcpy(skb_push(frame, ETH_ALEN), dst, ETH_ALEN);

Here, as well as in the regular data frame handler, we push the length
of the frame into the ethernet header. Later then, eth_type_trans() will
load up the skb->protocol field. The thing I'm not entirely sure about
is this: We can have frames longer than 1536 bytes, but only if the
length is smaller than 1536 does eth_type_trans() assume that it's a
length, if we have a frame longer won't it go wrong? I haven't quite
managed to wrap my head around the rules for wrapping data into an
802.11 frame nor in an 802.3 setting so this may be totally incorrect.

johannes

--=-pTTpitcUGKUYMoAUeeNw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0r1xqVg1VMiehFYAQLSsRAAlOaUmAawdaskFWlPiKAqEhmX02vO/iSC
FLzfETU5Y8C0pI5OWl3lGel0huWqS7GOMHdvrsTdYIrkoYaxUKPGc9OJycn7ZuU6
thhmFXQXl5buMYwfJv7XDAPMDalWnOVOmyPSvRxKE0gsCBltet8rAzIhBL49gmRV
V1far2dpO5W7qaaUc3VRT5NGs/CMvx9QpI25eBFz2MOafupK6aph7eCqFayITFZ5
P2u4c/rIaXsZZOTO7DTJPdZ2HAHVeCbiXjxwnPqSP5ifMA1uo/OIwcymJl3Mee4V
1aoKPN0kZO0u5HaAmOIAzW6ZQtKI3dHgq4BX2GBjDtxvyLpiWnTDd+EuhYrGfyf2
ef8oFr3SPLVI/17CJSfY8B1KNlqQZRjK/GVNxWqOuyMfDgr/yAN9M2/ZEZTXWg4W
5yfe8g0Z/mZWIpJqlZD7stPz6vlph0Oh3rPmjNu43/KQzTwVEyikvWg2ZRr5I1AR
HozA4tYX+Z01f+fjbCijkOwaK1d7sqIuJ35hkIn2i5u1AxVBm6HETNVnHEwBF1LB
gENiKJwWB7lH2ZITokB9Bmsrlj6H6LKC5gs96u4h1oiQN120Jti1kQFUQb2rE680
WLYXmy6kxtK8uA9YIYt09IfwoI3NVOe75ep7YheqpNhQ0Wmixs0Z4nMoYeA3KxQe
Dccy5PoV7Pc=
=8NMk
-----END PGP SIGNATURE-----

--=-pTTpitcUGKUYMoAUeeNw--

