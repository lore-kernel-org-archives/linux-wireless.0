Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:43316 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965712AbXDGT1u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Apr 2007 15:27:50 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: andy@warmcat.com
Subject: Re: [PATCH 3/7] mac80211: Radiotap rx to use fallback rate calc if ieee80211_get_rate fails
Date: Sat, 7 Apr 2007 15:25:26 -0400
Cc: linux-wireless@vger.kernel.org
References: <20070407105058.762762192@warmcat.com> <20070407105138.693035816@warmcat.com>
In-Reply-To: <20070407105138.693035816@warmcat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2393539.kL2IsuGOYP";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704071525.30640.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2393539.kL2IsuGOYP
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 07 April 2007 06:51, andy@warmcat.com wrote:
> Michael Wu's radiotap rx code gave me a rate of 0 on zd1211rw-mac80211,
> perhaps because no interface to the physical device was associated.  Added
> some fallback code so that if the rate could not be computed by
> ieee80211_get_rate it uses Michael's original method (which always worked
> for me).
I know about this problem. The rate reporting in zd1211rw-mac80211 was alwa=
ys=20
wrong and needs to be fixed there, or the mac80211 interface should modifie=
d=20
to remove the assumption that TX hw rate =3D=3D RX hw rate. In either case,=
 this=20
is the wrong way to fix this issue.

=2DMichael Wu

--nextPart2393539.kL2IsuGOYP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGF/AqT3Oqt9AH4aERAvBXAKCG0hZyeqpwdUqVs0IGZ3yjO0TuZACeLmEd
k8tbXaNsZu8WiR8rCoEZ2kI=
=u69M
-----END PGP SIGNATURE-----

--nextPart2393539.kL2IsuGOYP--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
