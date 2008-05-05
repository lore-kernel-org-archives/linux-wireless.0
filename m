Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44621 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbYEEXhN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2008 19:37:13 -0400
Subject: Re: [RFC v2] mac80211: assign needed_headroom/tailroom for netdevs
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: tomasw@gmail.com, linville@tuxdriver.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080505.160328.203996832.davem@davemloft.net>
References: <1209972139.3655.9.camel@johannes.berg>
	 <1ba2fa240805050727r2060b0b4x3a9b3240647b66b1@mail.gmail.com>
	 <1210000923.8245.26.camel@johannes.berg>
	 <20080505.160328.203996832.davem@davemloft.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZMvnsLKNlz2K9NuY/S0s"
Date: Tue, 06 May 2008 01:36:31 +0200
Message-Id: <1210030591.8012.41.camel@johannes.berg> (sfid-20080506_013634_014040_FA6D0185)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZMvnsLKNlz2K9NuY/S0s
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-05-05 at 16:03 -0700, David Miller wrote:

> @@ -255,11 +255,12 @@ struct sk_buff *__netdev_alloc_skb(struct net_devic=
e *dev,
>  		unsigned int length, gfp_t gfp_mask)
>  {
>  	int node =3D dev->dev.parent ? dev_to_node(dev->dev.parent) : -1;
> +	unsigned int extra =3D dev->rx_alloc_extra + NET_SKB_PAD;
>  	struct sk_buff *skb;
> =20
> -	skb =3D __alloc_skb(length + NET_SKB_PAD, gfp_mask, 0, node);
> +	skb =3D __alloc_skb(length + extra, gfp_mask, 0, node);
>  	if (likely(skb)) {
> -		skb_reserve(skb, NET_SKB_PAD);
> +		skb_reserve(skb, extra);

Come to think of it, if you want to bridge two wireless AP-mode devices
with different headroom .... Nah.

four-byte multiple isn't quite right though, but I'm not sure what would
be, probably multiple of NET_SKB_PAD?

johannes

--=-ZMvnsLKNlz2K9NuY/S0s
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASB+Z/qVg1VMiehFYAQIksA//XiWdAjaJpqfBMmJBaAst9rEU7Gwssah9
Oi/dtqYO7VKD5bHdQQQSDeglq4H7moUfdm9210pZz5h8psykHVrEBVhQmA9F/fHn
FTm9FecBTu/JKY6xrg1B0+0gajSxcgEEUTuh3He6gKq69QHqduTkitSX/TSB73Up
cYRon7lg3IAf62R83v+WAAp7o3PFUPM9hf914cbGdpi+WjGbu+iuPZtLmEMIzJIX
HiVyb9oHcEBwAcLTrDRo2PVcjv5rzJMCBw2SBaLQhYSo5L1DRDibySB8ibuliFgz
JasRjKNMqjtlbLXfdx0qMSyP+LKPjx5Lyl84mn0yDokMNLw/YXup61Zi6ajGje+O
ae379f8FSLEY/00PJlTa+CKNRr6lJEefZhkpXH3Czo33AfdrPrAl72mMGrwOqjHz
sGZDAeog+bFUMVLK9qZIFxNPbWrgAdb2vKlqUwwe5kqYFZnSNGaw8MID1jO1siNK
X3hjDM1ReMZc+OwfFKyjD6t+0Ftkct77sz0muIERpajPfoG2tZGeu7C6SmzeeO+w
q2ik0+Msv2iyq0CRXy5hBBkNEc/Iuj1qJPfrOfCorbeL0EpX5AwZAsBmAsOcf2hW
lx2g3bX+KAT+oBv54Aik84ZN/2LThkkPnedSt6Ld2QA7Q2Q4dYT0mKWTeyZ6JhE5
CKvEmsyMzuw=
=MDQl
-----END PGP SIGNATURE-----

--=-ZMvnsLKNlz2K9NuY/S0s--

