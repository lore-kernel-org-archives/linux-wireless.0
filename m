Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52706 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767546AbXDFIL4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Apr 2007 04:11:56 -0400
Subject: Re: [PATCH] mac80211: Add radiotap support
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org,
	Andy Green <andy@warmcat.com>
In-Reply-To: <200704060048.51524.flamingice@sourmilk.net>
References: <200704060048.51524.flamingice@sourmilk.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HZ1S+MYIAhKGcmLGxFmN"
Date: Fri, 06 Apr 2007 10:11:14 +0200
Message-Id: <1175847074.3489.56.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HZ1S+MYIAhKGcmLGxFmN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-04-06 at 00:48 -0400, Michael Wu wrote:

> @@ -3756,6 +3802,12 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struc=
t sk_buff *skb,
>  	struct ieee80211_txrx_data rx;
>  	u16 type;
>  	int multicast;
> +	int radiotap_len =3D 0;
> +
> +	if (status->flag & RX_FLAG_RADIOTAP) {
> +		radiotap_len =3D ieee80211_get_radiotap_len(skb);
> +		skb_pull(skb, radiotap_len);
> +	}
> =20
>  	hdr =3D (struct ieee80211_hdr *) skb->data;
>  	memset(&rx, 0, sizeof(rx));
> @@ -3792,6 +3844,7 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct=
 sk_buff *skb,
>  		goto end;
>  	skb =3D rx.skb;
> =20
> +	skb_push(skb, radiotap_len);

I don't like this trick. It's so non-obvious. And inbetween, the only
thing we ever use is skb->data (once, to get hdr assigned) and skb->len
(which we could also load into a local variable.

> @@ -3800,7 +3853,7 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct=
 sk_buff *skb,
>  	} else {
>  		struct ieee80211_sub_if_data *prev =3D NULL;
>  		struct sk_buff *skb_new;
> -		u8 *bssid =3D ieee80211_get_bssid(hdr, skb->len);
> +		u8 *bssid =3D ieee80211_get_bssid(hdr, skb->len - radiotap_len);

and here you still need to do the subtraction. If you had the local
variable, then you could just write frame_len or something.

johannes

--=-HZ1S+MYIAhKGcmLGxFmN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGFgCi/ETPhpq3jKURAt8zAJ489jkM+SbyltM1Tv2pKj8uC048sACdEkOd
AeXX37tEZy6GYQfo1Ga0xQQ=
=Gxdy
-----END PGP SIGNATURE-----

--=-HZ1S+MYIAhKGcmLGxFmN--

