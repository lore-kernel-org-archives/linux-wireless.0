Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56761 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231AbYFXKrv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 06:47:51 -0400
Subject: Re: [PATCH 3/4] mac80211: add last beacon time in scan list
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <1214303881-31525-4-git-send-email-tomas.winkler@intel.com>
References: <1214303881-31525-1-git-send-email-tomas.winkler@intel.com>
	 <1214303881-31525-2-git-send-email-tomas.winkler@intel.com>
	 <1214303881-31525-3-git-send-email-tomas.winkler@intel.com>
	 <1214303881-31525-4-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yoHkt+lvoblCf76gbkdj"
Date: Tue, 24 Jun 2008 12:47:13 +0200
Message-Id: <1214304433.8967.277.camel@johannes.berg> (sfid-20080624_124759_033411_0929CFEC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yoHkt+lvoblCf76gbkdj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-06-24 at 13:38 +0300, Tomas Winkler wrote:
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>=20
> This patch adds the interval between the scan results and the last time a
> beacon was received in the result of the scan.

Why do we need this?


> +			memset(&iwe, 0, sizeof(iwe));
> +			iwe.cmd =3D IWEVCUSTOM;
> +			sprintf(buf, " Last beacon: %dms ago",
> +				jiffies_to_msecs(jiffies - bss->last_update));

Is there no time_between() or something that accounts for wraparound?

johannes

--=-yoHkt+lvoblCf76gbkdj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIYNCtAAoJEKVg1VMiehFYpjsP/3DrZ0vWGRkmcZ6/pSM8U8zw
+8OwVmmSzwt9PUQ5WNtvDx4HTGUNQyz6VXTNQ//NEdbN5JVVIiB4jntwbSAP4tM+
m9noM5sPEWEwPAF1w+RD3338Op2dav2aBDbaEwkwqEAUbFXI1w0lOr6NDM1Uwib+
GzTz3Lvzj/RAori6Sdj8qYsG5yn20miNE2cJHRuF854WQ/32+s13nnH7onEtuOb6
ASzHTP1j4On/p7rxAKCcML6MWfCgZTJEg2ROKU7mrBtEmR9R7opfWRFH7fx75Xm+
wWpdJHhprOSBBuvAbrOSq9FiecGLgIDRhl1fQ7eo44Y+pHO9x5rDTm0b81NZA1Dk
Oo3JJfO3dgHjbQevH1TVTEJpf6Vs04tSg5Px9YCvQbTaUyH61Zr1KJ9k0jj14HgC
iMVOwM86vyqD4AVFKkWZouN9aevayiySPxrjT24J/09R5PtI1CtQJN0j0+lWRC3e
FQ6dK3au9spS5NB/TkowOkGKeUeINbnnhZ7O6LTMJyblLWpRaKGhZaV+fU8kRl26
S9RKsc/VkD9hdBNStb2ZMwM7TOxyaVWSznh9dEgqWblxy/H60H1riUH3BQjaJ1D5
uREbXBmGI0ngPdwJTyvO+shTvlwyWQuOo0zkc/vEHLOYuVjL66KTu+ZaWNPFcvZm
e4L5NFFfcGyJZa7tjYe7
=dCqb
-----END PGP SIGNATURE-----

--=-yoHkt+lvoblCf76gbkdj--

