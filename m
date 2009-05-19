Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39821 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbZESOvt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 10:51:49 -0400
Subject: Re: [PATCH 6/7] mac80211: PS processing for every Beacon with our
 AID in TIM
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090519140236.866613677@atheros.com>
References: <20090519140137.708996030@atheros.com>
	 <20090519140236.866613677@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-9BCxvoYr0b5BeQkQ7uNL"
Date: Tue, 19 May 2009 16:51:11 +0200
Message-Id: <1242744671.4797.25.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9BCxvoYr0b5BeQkQ7uNL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-05-19 at 17:01 +0300, Jouni Malinen wrote:
> plain text document attachment
> (mac80211-pspoll-on-every-beacon-tim.patch)
> If the AP includes our AID in the TIM IE, we need to process the
> Beacon frame as far as PS is concerned (send PS-Poll or nullfunc data
> with PM=3D0). The previous code skipped this in cases where the CRC
> value did not change and it would not change if the AP continues
> including our AID in the TIM..
>=20
> There is no need to count the crc32 value for directed_tim with this
> change, so we can remove that part. In order not to change the order
> of operations (i.e., update WMM parameters prior to sending PS-Poll),
> the CRC match is checked twice as only after the PS processing step,
> the rest of the function is skipped if nothing changed in the Beacon.
>=20
> Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

Makes sense, thanks.

johannes

--=-9BCxvoYr0b5BeQkQ7uNL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKEsdaAAoJEODzc/N7+QmaysMP/1O4hQutQQqVrk1ZQtDRXVrK
uIylZaw/VxEozSNYZ/ZmD4GOOAbJD8FqDz55bPSlGnhw0V2FnGKiz45IEDYHtHTq
LaF2sWl2ZgssQkQ1bnAnXt+gzDargVtFfgMbE/dyWXOQFDNyVHtviq8y+ELwRLCv
gPthbfkwQaZe05JRZWQqSmPikGwDTf+S1sph5kokD4ytisW92ltxC4Kg2z7Ps9nM
4h9GGC7EQJWUZbGguyQrsNeSZ/a+Cm+RbkSd4k8ycbkZldL9KoafIafRNqBHU8DE
bw0qBQ/0yUfnJNUqPxQG/yIyBBNvfpjLtZgU+8rXfI9vcuSrvhoUNn+MfIPG2Y2Q
lTQuh6bf7d8pkxZXQE4DlsRp512cD/l7WwZmR4dlz9TfBnZYK0VbOEJK/cCAtZKI
joV+RJuuT9+d2bOG0q6uX3zqTrbfA5lNkJLcnFlxJMUZcy4Q3GTYs2v3C4bxuGfV
+cBVfSC+S2XvdwvPU07DH6kbFWtMw0M7+++MpHVahdFuJPys/Hlyis1T72xfIZzy
wAZTlamZP0LvESvf8Dc4RMRMGQdp4uEXysHjpEM2RPQsULSkJcbMywXSaaQAxaoG
c7ClJ52gz77tx/+Rjw4jn3nbz/aMdcfFokuGj9G9v8aP7MQ3W06cPSKgP33ym7J4
7zokPnOVW7Rqi4E6/XOr
=E2ln
-----END PGP SIGNATURE-----

--=-9BCxvoYr0b5BeQkQ7uNL--

