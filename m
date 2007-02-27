Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:42200 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752036AbXB0X0Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Feb 2007 18:26:25 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Helge Deller <deller@gmx.de>
Subject: Re: [PATCH] p54 various cleanups
Date: Tue, 27 Feb 2007 18:26:03 -0500
Cc: linux-wireless@vger.kernel.org
References: <200702272219.58919.deller@gmx.de>
In-Reply-To: <200702272219.58919.deller@gmx.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5560920.4FTdAhbx3Z";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200702271826.07149.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart5560920.4FTdAhbx3Z
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 27 February 2007 16:19, Helge Deller wrote:
> Patch below
> - uses PCI_DEVICE macro
> - adds a "const" to the p54_ops struct and
> - replaces "__attribute__ ((packed))" by the generic "__packed" keyword.
>
> Signed-off-by: Helge Deller <deller@gmx.de>
>
> PS: There are more possibilities to replace "__attribute__ ((packed))" by
> the "__packed". Is this wished ? If yes, I can send additional patches for
> the other subdirectories...
>
If you don't mind, please split each cleanup into a separate patch and do a=
ll=20
d80211 drivers at the same time. adm8211 can also use the PCI_DEVICE cleanu=
p,=20
and adm8211, rt2x00, rtl8187, and zd1211rw can also switch to a const=20
ieee80211_ops struct. I don't take patches for rt2x00 so you can either hav=
e=20
a patch with the adm8211/p54/zd1211rw ieee80211_ops cleanup and another wit=
h =20
the rt2x00 ieee80211_ops cleanup or you can make one big ieee80211_ops patc=
h=20
and let Linville apply that patch.

As for the __packed cleanup, I do not see any code in the kernel that uses=
=20
__packed, so I think it would be better if we dropped that for now.

Thanks,
=2DMichael Wu

--nextPart5560920.4FTdAhbx3Z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF5L4PT3Oqt9AH4aERAtosAKCl2hDCnZJVibW56VEWm/EDOVJgiwCeLCTc
TDySjptNKoYeNzvgzkdHF84=
=sokf
-----END PGP SIGNATURE-----

--nextPart5560920.4FTdAhbx3Z--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
