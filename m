Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56168 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758660AbYKVRSa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Nov 2008 12:18:30 -0500
Subject: Re: ieee80211_wep_encrypt_data_fix_unaligned_access.patch
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivan Kuten <ivan.kuten@promwad.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <eaf88bcfcb5b61c24cf1b8b682c5ff3c@promwad.com> (sfid-20081121_234653_121082_4B762D50)
References: <eaf88bcfcb5b61c24cf1b8b682c5ff3c@promwad.com>
	 (sfid-20081121_234653_121082_4B762D50)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-iwc3mSEiwBBcW3/I6aS6"
Date: Sat, 22 Nov 2008 18:18:26 +0100
Message-Id: <1227374306.3599.12.camel@johannes.berg> (sfid-20081122_181834_907517_E055A678)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-iwc3mSEiwBBcW3/I6aS6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-11-22 at 00:46 +0200, Ivan Kuten wrote:

> -       icv =3D (__le32 *)(data + data_len);
> -       *icv =3D cpu_to_le32(~crc32_le(~0, data, data_len));
> +       icv =3D cpu_to_le32(~crc32_le(~0, data, data_len));
> +       put_unaligned(icv, (__le32 *)(data + data_len));

Aren't you putting a pointer now??

johannes

--=-iwc3mSEiwBBcW3/I6aS6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJKD7eAAoJEKVg1VMiehFYfGgQAMU2krulUOfzzmh3b24wlyTI
+LE3GCgpem/LMPzjLYmm6ElbwPCoCPCQS0WLTnXFaskJU36DArU4NGlYGcMgkZMI
TNgDkbVHX/5U70GsUIpwqF5vNMSdsvHi8EuzWKnF1sSp8fN5yFXDWB8dDbDhgmA6
hAMck4AQZiA8WcuX57RBMFFH23urCZXZrGK2PLXC7LG8AkYENRHsE6mLeCpst/Lt
zs+48j7nxwslTORABNDGqCnGKA/NCvIcYEqThiCj7pVB6i57k7tUOB2gfs3n0bZ9
QV3IR/MIlOBjYDP2OYMxk6UWO6OljLdFS+MEcXEYBYJVdI2mrtMzwsla6FkFe98a
6wwZ4BYHpJ8+eg+5NquhKOBRTkC9O/wU9wb5sjsoj6GNgsFfhdnA4OA45dCjitK9
zN/9fpcPr1k1I8DY//lpOCIDEV0ZTDE5eAdoDLXMkYp1H/DGlVp5e3DCXkNDdxZ+
YQ2x11XJsTr4EIEClQCp9vL4som7FldIDa1+sbJGl+GJoOI3ldhvMIs8BXV5lsYe
rJF9tXhB7wcGvQVytbdIvmTUgp3bQJvNW2cHMGrhrsBJRZg124zh8aMJsdy7EvKC
pDyMyd7q79wnB+N9eMvx1pdt99tHhtNOC9b61x3vlK7q0FlEegCgE9fwXJcpdmQ6
mX72iFN6ol6r0pfaL4rB
=IYke
-----END PGP SIGNATURE-----

--=-iwc3mSEiwBBcW3/I6aS6--

