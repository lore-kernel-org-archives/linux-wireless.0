Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40804 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452AbYIRPmF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 11:42:05 -0400
Subject: Re: [PATCH] iw: add kernel version checks for pending upstream
	kernel features
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1221748533-11000-1-git-send-email-linville@tuxdriver.com>
References: <>  <1221748533-11000-1-git-send-email-linville@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VYaPqO0DR+sSCotjmt0y"
Date: Thu, 18 Sep 2008 17:41:28 +0200
Message-Id: <1221752489.9262.81.camel@johannes.berg> (sfid-20080918_174208_970479_B8620014)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VYaPqO0DR+sSCotjmt0y
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-09-18 at 10:35 -0400, John W. Linville wrote:
> =20
> +/* This funcionality first appears "officially" in 2.6.28... */
> +#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,28)

This bites all developers of the tool. I'd use #ifdef
NL80211_ATTR_SUPPORTED_IFTYPES like Jouni did for a bunch of things but
I forgot to add
#define NL80211_ATTR_SUPPORTED_IFTYPES NL80211_ATTR_SUPPORTED_IFTYPES
to nl80211.h

On the other hand, I'm with Pavel in that it sucks if you have a tool
which your distro compiled against 2.6.27 and then suddenly you want to
upgrade your kernel to 2.6.28 and the features don't work...

I don't know. Tell me what to do. I don't really like shipping the
header file either but it may be the lesser of two evils?

johannes

--=-VYaPqO0DR+sSCotjmt0y
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI0nalAAoJEKVg1VMiehFYMPYQALrDW8EiIGbU2zAFFyFogaO9
HHnEQINHBtvUCKp7unwfRROnS5hCJx2/bH7Q0G8D+M07ENAKxUxm60tlQIYAQ18w
4v1uDdT4xrztegt2nXlCBBJioYAakM5x9Kzb2mfLW0PUglxNf3FPen0PBL+IuKTL
aOo0hO7jQLVXd2eEuf4/vhQMgBfKr8iL3OX4xtxxz3pBtJ6U2Y691xkaVplzir12
IRzTHi17Yx8hzYvFEdaXVQvROslI23dF7i5hQqghQuz4NuDigU6/isIyATn0Ma7v
ONkqK4lOe1utT9pN57T/OmEqVDbab1+9dVy+SPXVQXOwiyjlkQcnjCBnGCveIsga
FP0dhd7zxX/77f2JB4AFx2GrSlb+k6zSawyXFT2XyYvfYuNuhwZ8/F9xdXTa+026
WAFQy+HUP6XLv9U5AOWqEz4RDJYZcMjco6Nip50dBU+I+brrk7nHBhHj7zsOZOWS
B05fj7j8Ah3aYY2N+L2yLrT0vDhaa7ELZTSMIkzoqnvL8/Nu48Iy2yGFlSPMAKhd
BIizukrq+PQuVbvp2utQt441wBJiYIZvIDW+MuwIo65P6Ucb/I0HCTaKfPKBd0oa
gVcIGRYqNWeC1AFyI8nayeTNh0MQ3b3U0FQJRhDg+kSoN+7mKoPNhR7QfwQ8anQT
7VrlIjFjJ7JEYoxfrZCH
=9i+N
-----END PGP SIGNATURE-----

--=-VYaPqO0DR+sSCotjmt0y--

