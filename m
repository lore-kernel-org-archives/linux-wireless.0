Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46737 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757275AbZJHJxF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2009 05:53:05 -0400
Subject: Re: NULL pointer deref at wext ioctl (Re: [PATCH] compat-2.6:
 adding  ethtool.h to compat-2.6.31.h)
From: Johannes Berg <johannes@sipsolutions.net>
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <3ace41890910072328n1460ee34v1fe7ca9b78eb646f@mail.gmail.com>
References: <3ace41890910071216y69b8bc9la67b8f0ce5890cd8@mail.gmail.com>
	 <3ace41890910071228i786d4097w69dc7a3dfeb64afe@mail.gmail.com>
	 <1254952886.3713.4.camel@johannes.local>
	 <3ace41890910072328n1460ee34v1fe7ca9b78eb646f@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-xIuoaleRks4nkyK10FwA"
Date: Thu, 08 Oct 2009 11:51:54 +0200
Message-Id: <1254995514.3713.22.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xIuoaleRks4nkyK10FwA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-10-08 at 07:28 +0100, Hin-Tak Leung wrote:

> It looks like it is the 2nd of thes two lines around
> /usr/src/debug/kernel-2.6.30/linux-2.6.30.x86_64/net/wireless/wext.c:448
>  which resulted in the null pointer dereference:
>=20
> if (index < dev->wireless_handlers->num_private)
>               return dev->wireless_handlers->private[index];

Ok, that's odd. Is it possible that somehow cfg80211 is picking up an
#ifdef'ed copy of "struct iw_handler_def", and thus the struct it is
defining is simply too small? You can figure that out with debug info,
presumably, but I'm not entirely sure how. Actually maybe nm would tell
you too, if you look for cfg80211_wext_handler.

What I mean is this -- cfg80211 defines cfg80211_wext_handler:

const struct iw_handler_def cfg80211_wext_handler
	.num_standard
	.standard
	.get_wireless_stats

but the core expects
	.num_standard
	.standard
	.num_private
	.num_private_args
	.private
	.private_args
	.get_wireless_stats

as such .num_private ends up non-zero because it's shadowed
by .get_wireles_stats.

johannes

--=-xIuoaleRks4nkyK10FwA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKzbY3AAoJEODzc/N7+QmaQYsQALcqEJjH0AwXXaimrGz0Y3mR
lejKBGG0bFHHWeOFW8iPnRmKP5zvNDUEZMormErwcG/M44vybC82D/PKXH8VQyoo
lqkVZoRUbbwedgWfnM8uIJC2ZgT43LdW5ikbhW5bQlm50fUhGyDNJiaogLSv+Qwu
EI6bme1RcDxt0/X5JTCQX4HVRx7yPYALN+ZMBKCCPynXQsWfxjZf6UYMw8zQfE6O
XVMGhD6rLDFpAtJmQZ+CCyCPZ2oFPQ5ENfAwaHS0D/ns0LLSTWaK2OIYfzDNVpI7
JzRRp/VAUIv+qyXzhTVjuHJ7nzqwHtoNgpsgDY+lc3Dr3nnNb8DErYGBBHI7uONa
jfi2kqpyrDN/Z/q9ofXmwfc3ERSzGrH0HAzETMpodKMb/CTy9CcXQlX8O/nha3ew
QeF1QV4OcFF9rYC0OV+H2Hw/vsFjQcwFGMeRaXxRKTGgdVdjdJPkjXsm/TzfM4lf
NvJs5kf8nM2uorlIZtFezf/3h4NdWBW4zofL23PkEa3dQ0BI/xPVlvFdLUXM+xI3
Ymfl1MbM8RgS+bDDcv6Sl9CAgLv3wL7ggAqHJhAR27LMHJEKubFL2tRKrqbQAaTj
+E/zz/GmiKWWeAo44DLs9Qiz+NFNMwNlY8zHB/wNQKd5hh86erF0vJiHyyXbHXT+
dLxbgv+PZ3yFR0/Lgz7y
=+OHL
-----END PGP SIGNATURE-----

--=-xIuoaleRks4nkyK10FwA--

