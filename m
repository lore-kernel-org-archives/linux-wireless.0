Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41871 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbYJNWAq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 18:00:46 -0400
Subject: Re: [PATCH] mac80211 fix regression introduced by "mac80211: free
	up 2 bytes in skb->cb"
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Stephen Blackheath <tramp.enshrine.stephen@blacksapphire.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ben Martel <benm@symmetric.co.nz>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <48F515D7.9030002@openwrt.org>
References: <48F416A3.3060205@blacksapphire.com>
	 <1223990364.10113.28.camel@johannes.berg>  <48F515D7.9030002@openwrt.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nSOLbyU/EMUqdq/VIdld"
Date: Wed, 15 Oct 2008 00:00:02 +0200
Message-Id: <1224021602.3027.17.camel@johannes.berg> (sfid-20081015_000049_116060_145040D1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nSOLbyU/EMUqdq/VIdld
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-14 at 23:57 +0200, Felix Fietkau wrote:
> The hw_key pointer is used (and obviously NULL) after skb->cb is
> memset to 0. This patch grabs the iv_len before the memset call.
>=20
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> Signed-off-by: Stephen Blackheath <tramp.enshrine.stephen@blacksapphire.c=
om>

Subject should be "rt2x00: " instead of "mac80211 ", but

Acked-by: Johannes Berg <johannes@sipsolutions.net>

>=20
> diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wire=
less/rt2x00/rt2x00queue.c
> index 1676ac4..451d410 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00queue.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
> @@ -374,7 +374,7 @@ int rt2x00queue_write_tx_frame(struct data_queue *que=
ue, struct sk_buff *skb)
>  	struct queue_entry *entry =3D rt2x00queue_get_entry(queue, Q_INDEX);
>  	struct txentry_desc txdesc;
>  	struct skb_frame_desc *skbdesc;
> -	unsigned int iv_len;
> +	unsigned int iv_len =3D 0;
> =20
>  	if (unlikely(rt2x00queue_full(queue)))
>  		return -EINVAL;
> @@ -395,6 +395,9 @@ int rt2x00queue_write_tx_frame(struct data_queue *que=
ue, struct sk_buff *skb)
>  	entry->skb =3D skb;
>  	rt2x00queue_create_tx_descriptor(entry, &txdesc);
> =20
> +	if (IEEE80211_SKB_CB(skb)->control.hw_key !=3D NULL)
> +		iv_len =3D IEEE80211_SKB_CB(skb)->control.hw_key->iv_len;
> +
>  	/*
>  	 * All information is retreived from the skb->cb array,
>  	 * now we should claim ownership of the driver part of that
> @@ -410,9 +413,7 @@ int rt2x00queue_write_tx_frame(struct data_queue *que=
ue, struct sk_buff *skb)
>  	 * the frame so we can provide it to the driver seperately.
>  	 */
>  	if (test_bit(ENTRY_TXD_ENCRYPT, &txdesc.flags) &&
> -	    !test_bit(ENTRY_TXD_ENCRYPT_IV, &txdesc.flags) &&
> -		(IEEE80211_SKB_CB(skb)->control.hw_key !=3D NULL)) {
> -		iv_len =3D IEEE80211_SKB_CB(skb)->control.hw_key->iv_len;
> +	    !test_bit(ENTRY_TXD_ENCRYPT_IV, &txdesc.flags)) {
>  		rt2x00crypto_tx_remove_iv(skb, iv_len);
>  	}
> =20
>=20

--=-nSOLbyU/EMUqdq/VIdld
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI9RZeAAoJEKVg1VMiehFYsOgQAKwtJyZ6XWi+XEEatM6XVh7x
g6jkubaFFhiILeiHP4FibJl+QYlOxzor/mgv2PGIkV8e5qkicatWFbVYtWprKvDQ
EOWR47JGD0e9ycpKTxUzLr1/2RBoPUSAqB/CnVw2PIwWxFPUCk2b8sfAUN2cQBXl
qV5O/B764pjp3treZrYC8qhJHHQTxoIY+VhozvKSRFTLBp77MkGdgFYfnRKsfrjS
m8ZtaOsaf8qKg3kK7LjIKd85UVSGDqKBV2zqQUh6eOJxUxflhiqI61kQrigOctm5
C5+sq/DZ+LPinbs2imuXlD49R0dm18DmCZwX2pNBLULI6g0W7dCTErG8LiIFtymh
lqdIUd61KhTGbqDwWPF9LXSa5CUxtVDm8NQ9YvkOUWFXoSYxhbRco2vd/Vi1we6j
opsBrqjb78wqD0g8ohE+nyty7VjJr1nqgXopfog0ebAL27oVUPMJBLDkggREluNf
3XGMf+4MeOeRKph2oV3Al6eK2qge6Hlw2Ka0pQY3ujJE8cx0f+EB8usQ2BiPkDHs
5/8OdPPzUI1fQczbtXBnmq8JzwNHCNfv4a699qnQmLyPAfRkbG/xNJKgbZpB1eT4
jAAockwJdf65RxHDPK4a11RZNoIXKWj1dzJLFlz8FqOtadv2tFeJ7fMV5qS2eyoE
LBiHEGahXQNaeJJ8dyR1
=HM5O
-----END PGP SIGNATURE-----

--=-nSOLbyU/EMUqdq/VIdld--

