Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58096 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbYI3KVJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2008 06:21:09 -0400
Subject: Re: [PATCH v2] mac80211: change rate control API to allow
	multi-rate retry
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <48E1F554.5030700@openwrt.org> (sfid-20080930_114621_415973_341ED20E)
References: <48E1F554.5030700@openwrt.org>
	 (sfid-20080930_114621_415973_341ED20E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mC9QSaDAIBzsJd5Y8R6L"
Date: Tue, 30 Sep 2008 12:21:03 +0200
Message-Id: <1222770063.7064.57.camel@johannes.berg> (sfid-20080930_122113_218574_E61FD639)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mC9QSaDAIBzsJd5Y8R6L
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-09-30 at 11:45 +0200, Felix Fietkau wrote:

> @@ -374,7 +374,7 @@
>  	struct queue_entry *entry =3D rt2x00queue_get_entry(queue, Q_INDEX);
>  	struct txentry_desc txdesc;
>  	struct skb_frame_desc *skbdesc;
> -	unsigned int iv_len =3D IEEE80211_SKB_CB(skb)->control.iv_len;
> +	unsigned int iv_len =3D IEEE80211_SKB_CB(skb)->control.hw_key->iv_len;

Won't that explode when hw_key is unset?

> --- a/net/mac80211/wep.c
> +++ b/net/mac80211/wep.c
> @@ -313,8 +313,8 @@
>  {
>         struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
> =20
> -       info->control.iv_len =3D WEP_IV_LEN;
> -       info->control.icv_len =3D WEP_ICV_LEN;
> +       info->control.hw_key->iv_len =3D WEP_IV_LEN;
> +       info->control.hw_key->icv_len =3D WEP_ICV_LEN;
> =20
>         if (!(tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)) {
>                 if (ieee80211_wep_encrypt(tx->local, skb, tx->key))

I don't think you should set this here, just set it when the key
algorithm is fixed initially, that way it's also already valid when the
key is put into hw accel.

johannes

--=-mC9QSaDAIBzsJd5Y8R6L
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI4f2MAAoJEKVg1VMiehFYniUP/jb2CqcTtbzHpG7sbZpMLFG0
upuntr9CcFFXXmbvRyX35odxbGeyxMmnzcOCDbnKDlgSCeAuidVqVOZbvymrkRIV
TkD/rw2SS6ayb2wzXkjuar5ouVq4HxmDOvf64Y9hgLCf192d3/AGSFnHZZ7w7K/G
VuoOlnKx8PeX3g6E6UU643uVi6+pJflUAI7etKXBpEs5XjfMZHonpO0BVFiGNdMR
lK7+uSzXboGdZbhq3kypKGvGpSv0qMwKJgVrcmzJCMU037KbzYTWy0NlkfL2yHaL
EMiBjXIVRe4iuffhL+dZ9VFZRxsJMR3EkAi+V0Wrp6nxNmflEB/qq/LXrZgz6OmT
lueG8irtJm1qquDkvrYjhhf0rUevLmVIorsAmYHZwqIdWXiq4Omr8t0ewcMuMUZz
KZAdXmYp9FyASj9mnyMLezYZh+OeZxIftDiVu88ob+ib7a33PcNyEj4PN9Nwp/yk
3Jfx+roT304rtpaCckeJ+x7mh5vBDxcH+MSG/pHSYXI9lPOmN+BcD5zl8oPEf8uu
MFJjtP/7S4madlfETx+hx+PMkhaKzkbcFkgM5PMTKmKWmsdwG1/eU4PS8YwoxqL9
N/PI3WM2dQWKE3M6jAQ0kYCmEH1AZjQ0n5IQB+Sv2kYHXbXtUjHi9NgOthHn0M1A
PmW/PYqD6tMBkCNfh0gH
=YsrE
-----END PGP SIGNATURE-----

--=-mC9QSaDAIBzsJd5Y8R6L--

