Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59457 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbXLQRmX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 12:42:23 -0500
Subject: Re: [patch 1/9] mac80211: Clean up rate selection code
From: Johannes Berg <johannes@sipsolutions.net>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20071217012549.932807027@gmx.de>> (sfid-20071217_012727_837272_3B5270C7)
References: <20071217012517.882216322@gmx.de> >
	  <20071217012549.932807027@gmx.de>> (sfid-20071217_012727_837272_3B5270C7)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-c0pkfmUcx+IgRNuI8wcT"
Date: Mon, 17 Dec 2007 12:46:59 +0100
Message-Id: <1197892019.4885.16.camel@johannes.berg> (sfid-20071217_174227_605508_076C74EB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-c0pkfmUcx+IgRNuI8wcT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Looks good, minor comment below.

> +void rate_control_get_rate(struct net_device *dev,
> +			   struct ieee80211_hw_mode *mode, struct sk_buff *skb,
> +			   struct rate_selection *sel)

> +	fc =3D le16_to_cpu(hdr->frame_control);
> +	if ((fc & IEEE80211_FCTL_FTYPE) !=3D IEEE80211_FTYPE_DATA ||
> +	    (hdr->addr1[0] & 0x01))

Please use is_multicast_ether_addr()

> +	/* If a forced rate is in effect, select it. */
> +	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> +	if (sdata->bss && sdata->bss->force_unicast_rateidx > -1)
> +		sel->rate =3D &mode->rates[sdata->bss->force_unicast_rateidx];
> +
> +	/* If we haven't found the rate yet, ask the rate control algo. */
> +	if (!sel->rate)
> +		ref->ops->get_rate(ref->priv, dev, mode, skb, sel);

Maybe after this we should insert

	if (unlikely(!sel->rate)) {
		WARN_ON(1);
		sel->rate =3D rate_lowest(...);
	}

Not sure though.

johannes

--=-c0pkfmUcx+IgRNuI8wcT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2ZhsqVg1VMiehFYAQIPNA/+KeTX1TQXSuq5Hb5Ds5Ltn4NEShfDXRbb
vyQe+uqdpsBlhhcBz4c0yfuabQOrz6ThW99UfwjPexhS6llRElHmTDmw+aWd9Mnm
MwK/NVFPruqMSOEzrJ4uuzpq6J9YxTLpBtCn7Wt4VylBrGyR1pZ0GALhC+DLZWmF
EKjIt0dPUbrghyLgteQteM4sFljas8iC7924G/ZHnud+PhAzB0o21XYQBmFQChm5
5mRNLzC4lDzQdYRwTWO+4SRXCYUFDiN0jF8MuKJKhKKw/K1g0YUwRH5y49eCfPyF
BuafVqJvuh5N/WbidSZYr6LfO6q92mIcm4O3dioYLB7h/XTmHJJvMd1kbleN6j4M
ZVijlhI7qTFbIXCliVXlHHX3giYJTEJhecG3Ve5p90s/l/a8/3sjPh0Psgc3JkKK
yuyS68xTlN9la51/SJv1UZGTvHOFv9+G5ojztDxmVfmzGT1+HkbydTh6fdXGtGF1
WsHFbDtlVF/MEdUOOk/jrZiW3MDjfYbOgv9WZQXE1raATOq5cgFqYu8LWSjxXfjj
XRg6zWv46aBBSHTuZZ17EbIlPQD/R7mktFc6Q4vR/befeKxIVPN2tugmNPGqjDac
DM5gfeilORzUgRZpHSyP+vPquscZDMLUBQAn1S5l4MoRi/5Vmq5eLHskTHVSgIkl
I0gkhbFohm0=
=IdjD
-----END PGP SIGNATURE-----

--=-c0pkfmUcx+IgRNuI8wcT--

