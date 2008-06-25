Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:32962 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbYFYQNB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 12:13:01 -0400
Subject: Re: [PATCH 3/4 V2] mac80211: add last beacon time in scan list
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: Tomas Winkler <tomas.winkler@intel.com>, linville@tuxdriver.com,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <1214409527.5881.21.camel@dv>
References: <1214396229-18782-1-git-send-email-tomas.winkler@intel.com>
	 <1214409527.5881.21.camel@dv>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-I181tmP9zExVqN7DQL1V"
Date: Wed, 25 Jun 2008 18:12:16 +0200
Message-Id: <1214410337.21847.33.camel@johannes.berg> (sfid-20080625_181305_974128_14ED243E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-I181tmP9zExVqN7DQL1V
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-06-25 at 11:58 -0400, Pavel Roskin wrote:

> > +			unsigned long mid_range =3D (-1) / 2 + 1;
>=20
> What is that?  I guess that's where Riemann's zeta function has its
> non-trivial roots :-)

The Pavel hypothesis: "The Riemann hypothesis is correct when calculated
in 32-bit integers" is obviously wrong ;)

> > +			time_diff =3D jiffies - bss->last_update > mid_range ?
> > +				jiffies - bss->last_update :
> > +				bss->last_update - jiffies;
>=20
> That's pretty hairy.  Do we really lack a function to calculate time
> difference?

Actually, come to think of it, isn't just doing the difference as in teh
original patch correct in 32-bit unsigned integers? It'll wrap around a
bit but that's ok, no?

johannes

--=-I181tmP9zExVqN7DQL1V
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIYm5cAAoJEKVg1VMiehFYd1MQAKJJnFvf9RBh8kKYb99N3Va+
yxKsWvAacn/lTVEcweZTBjGuCAhB5HcQl6FJFauBK8rEYijDzvke0XSvz9H+ONMq
u/NWOWY2SOKT50e6gELodg5a9sOrJflgxzZovxjGybv7zxmddofnvU/ry2u5/4Oj
y9lNmpUdhA5sXIDTtB/nItBgGyjwnftn9v1H8lDxcI5Bkcf5scx0nvqkwzH0vo7Y
/hufDGFNiH1UxoyttqoSyJNqJY/b8dKMqGuJJr09avlUsoXjG9m06OzvhWC5OYQl
p8xqlAXMi/BRUDFEB5xG7Z7s0m1iaBq9skm5f4L7pshKtNOaOw9dF4QNaN+4zXq9
27CNHku845j2FGujWGCmE3zyr7/fjTzbqk518MLNNcH8c8AzwtMFFx8Zs5DwrV/a
EhhEI3VCmWOrV4/+HIJoxI2mEihenKbyaKcLR9on7e6A6VbYPIIMzNv/RNOsH574
sLhO9DIuZZuFn0z/NJa6o2fDw/b+QICAwzMEhbJEyrZm/bZbxihtof+b5zOCVYy8
e8nhX+H09a+yhUqG1RM+kcUVigyrJ6KUYrrcipqhvOuwHh729KwAJgz+4DugWbPO
zEGvhJhBeN1CufUDOqX+2WX7sZWmQSZh+ceSmaBpjUS4r/5XWDvdjlXlhV0CTJb/
tWFtFI31lzZyQYsHdzt5
=gi2d
-----END PGP SIGNATURE-----

--=-I181tmP9zExVqN7DQL1V--

