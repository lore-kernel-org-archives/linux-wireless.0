Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48034 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbYLLWjW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 17:39:22 -0500
Subject: Re: [RFC 2/3] mac80211: Make use of the new F_TX_NOACK and
	F_TX_NOSEQ Radiotap TX flags
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <69e28c910812121432n6e84de41s94a887110051a1dd@mail.gmail.com> (sfid-20081212_233241_155436_BE5AE965)
References: <69e28c910812121432n6e84de41s94a887110051a1dd@mail.gmail.com>
	 (sfid-20081212_233241_155436_BE5AE965)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yW9VbhgvGaGs9pA/+XiI"
Date: Fri, 12 Dec 2008 23:39:18 +0100
Message-Id: <1229121558.3565.6.camel@johannes.berg> (sfid-20081212_233925_296359_DEA0CE5E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yW9VbhgvGaGs9pA/+XiI
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-12-12 at 23:32 +0100, Stefanik G=C3=A1bor wrote:
> Honor the 2 new flags in the "TX Flags" Radiotap field, introduced in
> the previous commit.
>=20
> Signed-off-by: G=C3=A1bor Stefanik <netrolller.3d@gmail.com>
>=20
> ---
>=20
> Patch also available as an attachment in case Gmail decides to damage it.
>=20
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index 155a204..141099a 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -143,6 +143,8 @@ typedef unsigned __bitwise__ ieee80211_tx_result;
>  #define IEEE80211_TX_FRAGMENTED		BIT(0)
>  #define IEEE80211_TX_UNICAST		BIT(1)
>  #define IEEE80211_TX_PS_BUFFERED	BIT(2)
> +#define IEEE80211_TX_MON_NO_SEQ		BIT(3)
> +#define IEEE80211_TX_MON_NO_ACK		BIT(4)

You don't need that, you can directly modify info.

johannes

--=-yW9VbhgvGaGs9pA/+XiI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJQugTAAoJEKVg1VMiehFYjYsP/3MLKSMDNeZkG7OHY19giIO1
xLyy2USGiuD6DI0cEQWNMlu0zxgAaJprVm9Fj5jFXLgI+mYfVxhOuRicAk67F1LO
3Pqr5zvKbYhOMpVsBoT8q4rct+vZNqom+fPD01nnfiJAmX/WNEVRWxr3+LMCiGzS
Q3z83K3ec2IyPWdSkxnGqREUjWZ9i7jUpNix1KnQeFm9f+HLzQQXWw2RxaPRNpeP
foIDgWL1UGpOrFS2nIZJBpO0zCU21Oo/ReJc2zl32V9+dQllKZ69VZIPIJdJwo2y
H7G8kBQcTW67JoxE6qPlS3yIzMrNaFq01xW7UK3fncfd7pNTh2Xb0i6DRbrMhmWG
IcembiNZvsSUQGVgHp44z+7mDWi7m7/M7QHSHlFk21LaRkSFS3O2i5pbbyhPNOp0
C79dOhjC661kw/ggGOgNfpH0phLFPHgBAvReTxN5gr/fyIkAuoLbPc6rgh+uI4WC
J2CXOBRghhVfE15+LG953WKCIv0JxEJZkGRvvktf/J4tukuxkfFueDZRW5RmXLxN
bZG0LmaEiBqgKX+5i1HZmzyDInTzmxMJi2HnDbWMFKWHkx3tbz79386R1PMJy9XZ
1Ggyt+O8hbKvK9vvIcUu+fQMSjJhNeZOtCUAtKImkei0bMYAcI87pIG4KmrYOWGy
VJ4FOvQxDFf7buswvcv2
=P2dF
-----END PGP SIGNATURE-----

--=-yW9VbhgvGaGs9pA/+XiI--

