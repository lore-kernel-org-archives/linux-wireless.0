Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53101 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbYFOIag (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jun 2008 04:30:36 -0400
Subject: Re: [PATCH 4/4] b43legacy: use frame control helpers
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1213511620.11544.34.camel@brick> (sfid-20080615_083347_209837_62B07409)
References: <1213511620.11544.34.camel@brick>
	 (sfid-20080615_083347_209837_62B07409)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CsnQ6uFbjpYfArl9oiTP"
Date: Sun, 15 Jun 2008 10:30:21 +0200
Message-Id: <1213518621.17545.0.camel@johannes.berg> (sfid-20080615_103103_043320_0A8153DF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CsnQ6uFbjpYfArl9oiTP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> @@ -499,11 +499,11 @@ void b43legacy_rx(struct b43legacy_wldev *dev,
> =20
>  		if (dev->key[keyidx].algorithm !=3D B43legacy_SEC_ALGO_NONE) {
>  			/* Remove PROTECTED flag to mark it as decrypted. */
> -			B43legacy_WARN_ON(!(fctl & IEEE80211_FCTL_PROTECTED));
> -			fctl &=3D ~IEEE80211_FCTL_PROTECTED;
> -			wlhdr->frame_control =3D cpu_to_le16(fctl);
> +			B43legacy_WARN_ON(!ieee80211_has_protected(fctl));
> +			fctl &=3D ~cpu_to_le16(IEEE80211_FCTL_PROTECTED);
> +			wlhdr->frame_control =3D fctl;
> =20
> -			wlhdr_len =3D ieee80211_get_hdrlen(fctl);
> +			wlhdr_len =3D ieee80211_hdrlen(fctl);
>  			if (unlikely(skb->len < (wlhdr_len + 3))) {
>  				b43legacydbg(dev->wl, "RX: Packet size"
>  					     " underrun3\n");

All this crypto code in b43legacy is totally bogus anyway, just kick it
out :)

johannes

--=-CsnQ6uFbjpYfArl9oiTP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIVNMYAAoJEKVg1VMiehFYsv4P/14s3v7BtJZ03YYCLDq/MVmb
JqUKBFBAmD21eLiUVS8ArZy8OKd+eZ05ifFP9UETbhpryEhHblbsXVARntIPu9kW
S3jhDj2UOZztALyBQlFONZW22jxgVWMNsk6U8/D4/x2xxTBXnzTr5N+z5f2Yl/lY
bm+FlOSuRXk3UcKyyC4Zs6B/O1DS6S4+GXMz8cFPi1xOPsi5EmgRP4l7hDyyKbtd
G6nWy6c4GDTooAi5RogZOEuMhXQsUt3tSyTm1SbwaAqz83QZuaQUOkC3HUoLl85Y
koBekScrut9GsZFETIMxFmOIUcDoiiHbyeo/l/WSOP66RlIJhgimwf7EzdQj0XC7
G0I9VvVyFH6+XA4lvqNVZCeKHwn1lOAV8rZCOi/16M3e8Op7H/89osVxAP6c1kux
TLJvcUKayrz2GYG1KmnrKCrAfUKC48cbSu3x2spu8lqgPdhKQBjdRdNwqEpM18S4
rLB3GSizpehzPt5o/ekCrBBczjBqrJ1ftWGL/vs5ArYwj17Fx/G/BPSSjYnueICn
rRZSiSJ/oEnVbnddsv+KgpAgfQHY245Lq+Y5bYAAwDZMErDUBstiZDLNRGIgkRSe
qarhFTSGL9YB2YQyCytxVLSK+Ub0xx63Q4Qy8StvWIQmuK0HbUR+g07SR+JtHvAj
k6Ngmd5Rt7RqnOLZksXq
=3rOU
-----END PGP SIGNATURE-----

--=-CsnQ6uFbjpYfArl9oiTP--

