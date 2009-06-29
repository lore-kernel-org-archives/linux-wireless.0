Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38068 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299AbZF2IXd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jun 2009 04:23:33 -0400
Subject: Re: [PATCH] wireless: Compare ethernet addresses by unaligned safe
 way
From: Johannes Berg <johannes@sipsolutions.net>
To: ivan.kuten@promwad.com
Cc: linux-wireless@vger.kernel.org,
	Yauhen Kharuzhy <yauhen.kharuzhy@promwad.com>
In-Reply-To: <4A475F82.9040007@promwad.com>
References: <1245149672-18063-1-git-send-email-yauhen.kharuzhy@promwad.com>
	 <1245150895.8623.3.camel@johannes.local>  <4A475F82.9040007@promwad.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-q6iWv6ZJmSVIN2Wgm871"
Date: Mon, 29 Jun 2009 10:23:28 +0200
Message-Id: <1246263808.5947.4.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-q6iWv6ZJmSVIN2Wgm871
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-06-28 at 15:18 +0300, Ivan Kuten wrote:
> Hello,
>=20
> In net/wireless/scan.c : cfg80211_wext_siwscan there seems also unaligned=
 allocations
> for creq->ssids and creq->channels. Should it be something like that?
>=20
> Modified: trunk/uClinux-dist-2008R1-RC8/compat-wireless-2009-06-11/net/wi=
reless/scan.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> --- trunk/uClinux-dist-2008R1-RC8/compat-wireless-2009-06-11/net/wireless=
/scan.c (original)
> +++ trunk/uClinux-dist-2008R1-RC8/compat-wireless-2009-06-11/net/wireless=
/scan.c Fri Jun 26 14:00:52 2009
> @@ -619,7 +619,7 @@
>  		if (wiphy->bands[band])
>  			n_channels +=3D wiphy->bands[band]->n_channels;
>=20
> -	creq =3D kzalloc(sizeof(*creq) + sizeof(struct cfg80211_ssid) +
> +	creq =3D kzalloc(roundup(sizeof(*creq), 4) + roundup(sizeof(struct cfg8=
0211_ssid), 4) +
>  		       n_channels * sizeof(void *),
>  		       GFP_ATOMIC);

Also, that should be sizeof(void *) instead of "4".

johannes

--=-q6iWv6ZJmSVIN2Wgm871
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKSHn9AAoJEODzc/N7+QmasUoP/iVM1Odub8xVq5aWvFutZwMp
bj0N9C3TlnDaOYjseVt7wi/4EeWc0fXTn377RzLr4zW20eYwOfhrIIuqCLzGSTMr
LUXRX/dj5b9IQRw0WFJrW8CqP8zNZA+pnK3CfFT4l2GNsy+MuSkhYlT4ZVMAlske
0/3dRIxzPK5NMLjn8tYoyQS0vGHQQqgEfsFZH2/tq776lUESSjNItjVeR9wnaja2
ZMSlCNCgfDn3lXE8kjpUr9oc2qjaOXM66XJt+7k8f0GLa07SRtxx1Y7zSIvNKBry
zE3/NSWHjpUjvNTfE4O7dVMWGTemx09aMiwv+l8m8huAfPMqQReqZ4/4paO1jcoz
FvRv3/DHDw51RQlvEQelvkvdYNzR6kNQ8j5Mscg7+9EKxdoh8H/cRPr0Cv39aFxs
taaVKz4hU4CqzTIvkT6MlqYp9W9IOraNjo8+jf9MsZuo+u6ZzfBbDe7K+T4rOY4L
M1ZIfefFsUX2ajawRB/carkU24H4I9I4Pcqf3cMNHF+IzIBzrRxI8EMYfiRZ9ZiY
ZKSa94S5SLFGEk3uBTjWIonheL/mLba8/GjmHmAmQyaWCXwfvNudSLqbBCt5Iyjf
H6jD07pPXy+J2l8/+8gH0FVSn6NHgh2FtvJzdqJHFnSC6nfO1z4iLJ4sQ6M5QdCr
wc7fLKwS8sb5nZGnBDl5
=bM6g
-----END PGP SIGNATURE-----

--=-q6iWv6ZJmSVIN2Wgm871--

