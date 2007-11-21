Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54345 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297AbXKUQMk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2007 11:12:40 -0500
Subject: Re: [PATCH 1/1] mac80211: restructuring data Rx handlers
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com
In-Reply-To: <11956348193070-git-send-email-ron.rindjunsky@intel.com>
References: <11956348193070-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4cWZSgEjBMj4sLbfZxck"
Date: Wed, 21 Nov 2007 17:14:00 +0100
Message-Id: <1195661640.12000.52.camel@johannes.berg> (sfid-20071121_161243_680056_CDFE2A99)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4cWZSgEjBMj4sLbfZxck
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

After seeing the corresponding a-msdu patch here are a few more
questions.

> +static ieee80211_txrx_result
> +ieee80211_rx_h_data(struct ieee80211_txrx_data *rx)
> +{
> +	struct net_device *dev =3D rx->dev;
> +	struct ieee80211_local *local =3D rx->local;
> +	u16 fc;
> +	int err;
> +	struct sk_buff *skb, *skb2;
> +	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> +
> +	fc =3D rx->fc;
> +	if (unlikely((fc & IEEE80211_FCTL_FTYPE) !=3D IEEE80211_FTYPE_DATA))
> +		return TXRX_CONTINUE;
> +
> +	err =3D ieee80211_data_to_8023(rx);
> +	if (unlikely(err))
> +		return TXRX_DROP;
> +
> +	if ((ieee80211_drop_802_1x_pae(rx, sizeof(struct ethhdr))) ||
> +	    (ieee80211_drop_unencrypted(rx, sizeof(struct ethhdr))))
> +		return TXRX_DROP;

I like this.

> +	skb =3D rx->skb;
> +	skb->dev =3D dev;
>  	skb2 =3D NULL;
> =20
>  	dev->stats.rx_packets++;

Ok so the stuff that comes after this until the ned of the function is
responsible for delivering the packet. Maybe that should be split out
from the function too into something like ieee80211_deliver_skb()? In
the A-MSDU code you've had to basically copy all this code into the loop
as far as I can tell, something which I'd like to avoid very much.

johannes

--=-4cWZSgEjBMj4sLbfZxck
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0RZR6Vg1VMiehFYAQK+AQ//cx7T2AkSSVANOvxRiPVdhm+GrRBdZQjV
g3TLcec9lUEvODjrb80kaZfcjFLdLmOFqXMjC8rWh7Ij1+kqMDkQz804EHxNLLzj
bglxDV06E57i3ztd6R3LUuyQphl+w+SS3XW8zctlnTnPYjLmug08Nfwev5Zh9Y1G
QJxzqsyZAb3x6vcX6ku+/JnYu2FvkcXsJ4KYsBXej1A9d1DcAFJsLiaJz1fY4DJY
tHQ+p3HYuQiN3RLh99bQYiFpoaOLUIYTSK0On7ubZA74MwyF45+O/QuKMt67KcAc
4p2hBqrgWrFnPnmoylz5E/TZghP5QHsaIikb2bDNKUI2uz/B1ax20CKzbh6kk2lY
NSY9KJDDb+qikt8NwGOJiWvO3OaWTOCWLtjnWmihq9KPqZ325hGONb/Wm+1Xy4Zd
iU2YGh1pdUxXpyZI8u1Djf/UW50eyH706hQVw4SnhKwls/JI0jlx6diui/dEuEhL
m0SpSIE4oGiVBbndxFoRhSiKTOWGMp74HA10Zn1lBwwDkkWEFsBG3tBJiyK7f+fo
PXzPeCroV5OKPt79fQNlid0qyfOHG2t8wNapCYZRyyKZG6qAPGRHVN7xlSZjTKtw
bbU/fh+Q4FVWsSrhMNCz85OXWZNq2RPHaWg5RxMbWJQQoAdpPh6WilipVSlQF9xR
JMU/x/BFtUg=
=14kF
-----END PGP SIGNATURE-----

--=-4cWZSgEjBMj4sLbfZxck--

