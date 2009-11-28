Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40684 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbZK1PNy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Nov 2009 10:13:54 -0500
Subject: Re: [PATCH] mac80211: improved ieee80211_verify_alignment
From: Johannes Berg <johannes@sipsolutions.net>
To: Benoit Papillault <benoit.papillault@free.fr>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1259419649-1422-1-git-send-email-benoit.papillault@free.fr>
References: <1259419649-1422-1-git-send-email-benoit.papillault@free.fr>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-SeVh6YUD24BikAnblsY7"
Date: Sat, 28 Nov 2009 16:13:57 +0100
Message-ID: <1259421237.5428.28.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SeVh6YUD24BikAnblsY7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-11-28 at 15:47 +0100, Benoit Papillault wrote:
> From: Benoit PAPILLAULT <benoit.papillault@free.fr>
>=20
> ieee80211_verify_alignment has been improved to avoid small 802.11 frame =
(<2
> bytes) and skip checking for data alignment when there is no 802.11 data =
(when
> the frame length is less or egal to the header length)

None of this is necessary.

> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -386,10 +386,23 @@ static void ieee80211_verify_alignment(struct ieee8=
0211_rx_data *rx)
>  		      "unaligned packet at 0x%p\n", rx->skb->data))
>  		return;
> =20
> +	/* before using the hdr->frame_control field, we need to check that
> +	 * skb contains at least 2 bytes */
> +
> +	if (rx->skb->len < 2)
> +		return ;
> +

Frames shorter than 16 bytes never reach this point.

>  	if (!ieee80211_is_data_present(hdr->frame_control))
>  		return;
> =20
>  	hdrlen =3D ieee80211_hdrlen(hdr->frame_control);
> +
> +	/* before checking data alignment, we need to check that skb contains
> +	 * at least 1 byte of data */
> +
> +	if (rx->skb->len <=3D hdrlen)
> +		return;
> +

Even if this could happen it's not true -- we do not need a byte of data
to verify that it's aligned properly. After all, even the empty string
can be aligned -- we never actually dereference the data there.

johannes

--=-SeVh6YUD24BikAnblsY7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLET4yAAoJEODzc/N7+Qma5+IQALfgSIMmfmSuJSzSrWW3qrwX
kVQRxVLLGsPwldmXFJM/lO7CvL2Ca+D5rLaDbtrLZfT/fQVlqeZ2aOD7BMBQzm7y
GjbOiXwwiYlmB+x8HZwT/vQM4XD3ysKfbh6ESLToisALZha8Cne5xN+NCjJeEhcq
JCgXKCLCuLg5hS8e7dxV2IVAgQyw9c3tAx96eOIAzFfEsB7D2YhZf35swq74k2Dg
CNxfG4MpCuUrN+ce1Cwn6LbFNmyO0DNyGlvuKvANU4darVFEIa/uKd4oAmmPdC+P
okzNqVVqtAlLXNur+8jOJofv1WbyaUGegUK5SZG5WR0XdgOmFlGDvfESDWXxLZu5
sNMah4TV3r81OoQgMNMRpSrbtyqIyWooXTtdY/mDWLY5v5l3WBd7+Plsk9WebLQI
B8H84+2FD9ISZGGOC0qOYS+TyoLkyYxm5YE9Bk0FpJh8/tQEHjOTG90bxWjr5Zpb
tJyJSjMlQHtkHtEfuW4hN1xrbn17MKeZMFxYTU8aGonD9oFTI/AOZCSBUS+h1wg2
WzFo6jMFZb+mEFjaVxg01osDw+bHgxTnMT8SfF2i2mViNLhAXst/wv6gUckkFcJq
q6jtecN6AtG0eDbdQv51cNkVN0oHRfmiyxe26fJOSinRhbdEmV9lQC0nwBrdfG15
ZYT86kfXGmzIkdjINgro
=iE+3
-----END PGP SIGNATURE-----

--=-SeVh6YUD24BikAnblsY7--

