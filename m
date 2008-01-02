Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56133 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbYABItD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2008 03:49:03 -0500
Subject: Re: Strange mac80211 oops
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Daniel Drake <dsd@gentoo.org>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <200712291724.23726.mb@bu3sch.de>
References: <200712242237.28913.mb@bu3sch.de> <47764C5A.7060109@gentoo.org>
	 <1198936128.4172.41.camel@johannes.berg>  <200712291724.23726.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-q79yZeXu0Q9rdz059uJg"
Date: Wed, 02 Jan 2008 09:48:51 +0100
Message-Id: <1199263731.4172.66.camel@johannes.berg> (sfid-20080102_084908_285928_06762952)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-q79yZeXu0Q9rdz059uJg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Sat, 2007-12-29 at 17:24 +0100, Michael Buesch wrote:
> This patch fixes RX packet alignment issues in the zd1211rw driver.
> This is based on a patch by Johannes Berg.
>=20
> Signed-off-by: Michael Buesch <mb@bu3sch.de>

Looks good to me, I guess you tested it.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> Index: wireless-2.6/drivers/net/wireless/zd1211rw/zd_mac.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-2.6.orig/drivers/net/wireless/zd1211rw/zd_mac.c	2007-12-29 1=
7:14:41.000000000 +0100
> +++ wireless-2.6/drivers/net/wireless/zd1211rw/zd_mac.c	2007-12-29 17:15:=
00.000000000 +0100
> @@ -623,6 +623,8 @@ int zd_mac_rx(struct ieee80211_hw *hw, c
>  	const struct rx_status *status;
>  	struct sk_buff *skb;
>  	int bad_frame =3D 0;
> +	u16 fc;
> +	bool is_qos, is_4addr, need_padding;
> =20
>  	if (length < ZD_PLCP_HEADER_SIZE + 10 /* IEEE80211_1ADDR_LEN */ +
>  	             FCS_LEN + sizeof(struct rx_status))
> @@ -674,9 +676,22 @@ int zd_mac_rx(struct ieee80211_hw *hw, c
>  			&& !mac->pass_ctrl)
>  		return 0;
> =20
> -	skb =3D dev_alloc_skb(length);
> +	fc =3D le16_to_cpu(*((__le16 *) buffer));
> +
> +	is_qos =3D ((fc & IEEE80211_FCTL_FTYPE) =3D=3D IEEE80211_FTYPE_DATA) &&
> +		 ((fc & IEEE80211_FCTL_STYPE) =3D=3D IEEE80211_STYPE_QOS_DATA);
> +	is_4addr =3D (fc & (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) =3D=
=3D
> +		   (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS);
> +	need_padding =3D is_qos ^ is_4addr;
> +
> +	skb =3D dev_alloc_skb(length + (need_padding ? 2 : 0));
>  	if (skb =3D=3D NULL)
>  		return -ENOMEM;
> +	if (need_padding) {
> +		/* Make sure the the payload data is 4 byte aligned. */
> +		skb_reserve(skb, 2);
> +	}
> +
>  	memcpy(skb_put(skb, length), buffer, length);
> =20
>  	ieee80211_rx_irqsafe(hw, skb, &stats);
>=20

--=-q79yZeXu0Q9rdz059uJg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR3tP8qVg1VMiehFYAQK8/RAAirKyNY2Nlf4R3jQaj1WN2AUtitwAuIq5
j/FZLWxMS0iWr66JIujd49LcSoTTs1zOTTkn5Avj5ys90yzecz9tFh1230DB1+nu
wAdWVln1lXKm1EMc5uv4gv6PyFTM8SJd+7JcACsN23n7r2y+sbZ0Y8VqzfVQ88kQ
opHur+xiPnrnQDtqa8TRYulff/lgM3OaQq6roYtgaSotc5iUkds4z/OWB4Yokr6K
8rVOFUGD2V02bmaWCDbUdEvGyP37FGTt8L3yW+CFEdpulNfhCnjSlBwX+2y8U3ca
Lb32tdDY3gFvcdUmi3K+mYJ31emmN+wmSj2lIbnXx2Txvw2Imd95fIosAYwtvbKE
m5Rv2L3gPnc/5Q6lZNB1+DO/KYem1eNnybDBMXCClVEx79eyDiEksi052Hn3ebq1
1xr0A5z+8Jd4pJGMsmbC1/RouOiK22UTJJQ/2CrmvJJzB2YoqTSrqiGLXYgxbTiD
8Ff9yAEE5K5Pshd3exySGwNtYtAMTWJn0ohAe10UGmnU8xRZquF9qOjV5RtStSTe
pKt54Wd03otVBf2jgK9r40bBaUhCOAlEkwewsRnuKRmVGMbnPb1S4hBzMhK0wNnS
BpTCaAZfeTFWZ3/7t+tQyqScx3T/7iz2zSreWld06RnH23pdYkQ2TpJS8+0yrhtw
KSj4nhLLvmo=
=DFrl
-----END PGP SIGNATURE-----

--=-q79yZeXu0Q9rdz059uJg--

