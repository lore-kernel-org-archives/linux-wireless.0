Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55128 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758300Ab3HBJdZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Aug 2013 05:33:25 -0400
Message-ID: <1375435965.24371.27.camel@deadeye.wl.decadent.org.uk> (sfid-20130802_113329_034396_ACF9C309)
Subject: Re: [PATCH 3.11] nl80211: fix another nl80211_fam.attrbuf race
From: Ben Hutchings <ben@decadent.org.uk>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Date: Fri, 02 Aug 2013 11:32:45 +0200
In-Reply-To: <1375216722-31194-1-git-send-email-johannes@sipsolutions.net>
References: <1375211931.2664.21.camel@deadeye.wl.decadent.org.uk>
	 <1375216722-31194-1-git-send-email-johannes@sipsolutions.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-HfBjoBw5FMSD6hYHgPx6"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HfBjoBw5FMSD6hYHgPx6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-07-30 at 22:38 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>=20
> This is similar to the race Linus had reported, but in this case
> it's an older bug: nl80211_prepare_wdev_dump() uses the wiphy
> index in cb->args[0] as it is and thus parses the message over
> and over again instead of just once because 0 is the first valid
> wiphy index. Similar code in nl80211_testmode_dump() correctly
> offsets the wiphy_index by 1, do that here as well.
>=20
> Cc: stable@vger.kernel.org
> Reported-by: Ben Hutchings <ben@decadent.org.uk>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[...]

With this patch applied, I haven't seen another crash after another day
and a bit in the same wifi environment.

Ben.

--=20
Ben Hutchings
This sentence contradicts itself - no actually it doesn't.

--=-HfBjoBw5FMSD6hYHgPx6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUft8vee/yOyVhhEJAQp89g//S7C4rf+MW5TLWHOpocGLXQTRRgi0P8LR
INYWqMXGkruLXZq2vLLiCPA0APaSEZSALitcXg8LKGj4hnbQBfoP1j4mfsP6I3EQ
Ynlz4anwWgM+mrwS6tzkFYCmyeJ4SuRr6p8VCgB/efx66X8OYVBKsbXeCSFAPRb2
6VrUrpLu+ud0hGe7BJCedrcyKUJtK3sanNezvkfNbpF+rYTQhs/HOXykZ+uwFwT3
LM01P+oS71F8tp2UtjbYyj7b10yT8N88cYJmBkQaPuDIKQaUS6lq9EJjTKrYuGul
AlAe8TNxO1lnDdi9yRQ8o+sH0PUBxu0bfo564mwTudZK6txFjF2GeCo0CA+hjHJ3
7betY6z/Hq28UQuLMmEAuzz/M+qcOqQ3tHag4a/fmJbzTkFzs5146QQ56+3OlJIR
IcOJTG7Dn51u9HSSONoz6TXwiwoqOOPLK+YUdBzTgiaiHj47ncwU6C+Ol/Mtvlkk
xz1WHzD5vWbHrl+JLXD7vUy6LiHGBtQz0YT1MF81tmdlCA1wYMnKXe3lixDmlAhj
EpZxq8RZ07qCrQOF6oZ6eKNVwPtoHwqmq0qReaa1Y9fuV5+MdlB1jHcxq7pysRtw
NO65xRbypi9hKj+VuHrAX/3C2n64zqqj4eyAoYI1+ihelM6/uGWhqc4f6xN2wMwD
utbvMxvs5Eo=
=vk3f
-----END PGP SIGNATURE-----

--=-HfBjoBw5FMSD6hYHgPx6--
