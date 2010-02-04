Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48166 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757081Ab0BDLpL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 06:45:11 -0500
Subject: Re: [PATCH 2/5] b43: N-PHY: load generated samples
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1265282592-25491-2-git-send-email-zajec5@gmail.com>
References: <1265282592-25491-1-git-send-email-zajec5@gmail.com>
	 <1265282592-25491-2-git-send-email-zajec5@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-SCOpol1XVnRKGLVLHa5o"
Date: Thu, 04 Feb 2010 12:45:06 +0100
Message-ID: <1265283906.29119.108.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SCOpol1XVnRKGLVLHa5o
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-02-04 at 12:23 +0100, Rafa=C5=82 Mi=C5=82ecki wrote:

> +	u32 *data;
> +
> +	data =3D kzalloc(len * sizeof(u32), GFP_KERNEL);
> +
> +	if (nphy->hang_avoid)
> +		b43_nphy_stay_in_carrier_search(dev, 1);
> +
> +	for (i =3D 0; i < len; i++) {
> +		data[i] =3D (samples[i].i & 0x3FF << 10);

Humm. Allocations can fail, you know :)

johannes

--=-SCOpol1XVnRKGLVLHa5o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLarM+AAoJEODzc/N7+Qma8t4QALBpsfZL0NLQGWf6Q4StiA18
Lp6oEjUonRtbjJZLi01ZJG70snu7r16YCZg9FNPHHM2X/U7WDPuswev5JUlasnSv
wG+aJkbAxISWm4DHYK4stsw+PLxa5KEZzm/1Bk06ZFnfJvqjmVEKOsnXy3b0Lhp4
v5XqKIFQi1paoqu3Fh+vK6ICQWQSG8jeO2hgJuvfAN7AKU0XXspdlOb857WGKr4X
KoepJKod4Umxp8DxXdj9jMEJ6ZJH9Ut2/PSQjrxKCsqs+L/9UM4NOUgWn7IeCX0s
ZBKc2MBDJsv8w2+1tfy9zf2D+Gzb7CkzmMhdmEgKwARRIFMi91WGTDYY7MnCzY9T
DG30iD++fOAytqUJmwPFg1F4wxfKnZhLi5D180w93gjAi2m+x03y3fwr2uZk+JNk
9TKvGbXyKZArnaD23U3buTc06K769rhqS+cZyb+AQ3Q6rZhJ0+Lz+alTpBer3jEZ
zUYXl64Y7/0/lrfX2sUYrthmpK0eqPaXrvEdfqt9kQngg+DOAzaoAkUjp3XoPUGq
QK7a+vf1BzzHIIi62ytDovUJnsaKH7HWJCwHAqR6Rd+TNRrME0igsszzXOdvcx6d
ZtTRS2hEK0FKBaa/p72Nj4eJiBmGvhn4JdYtWbeaNaEFnyq9czC7mjxD1yRJmc1b
2G/qpTi9n8kLCS9Ke5HK
=wNOX
-----END PGP SIGNATURE-----

--=-SCOpol1XVnRKGLVLHa5o--

