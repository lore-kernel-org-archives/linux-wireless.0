Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:34831 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753271AbXK0Es7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 23:48:59 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mm snapshot broken-out-2007-11-20-01-45 Build Fail - net/wireless driver
Date: Mon, 26 Nov 2007 23:52:09 -0500
Cc: Tony Breeds <tony@bakeyournoodle.com>,
	Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200711200953.lAK9qxjO030444@imap1.linux-foundation.org> <200711262331.21176.flamingice@sourmilk.net> <20071126203716.ebe62999.akpm@linux-foundation.org>
In-Reply-To: <20071126203716.ebe62999.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1877531.dyGU4aXVF4";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200711262352.24722.flamingice@sourmilk.net> (sfid-20071127_044907_944147_C8164C4F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1877531.dyGU4aXVF4
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 26 November 2007 23:37:16 Andrew Morton wrote:
> Why not?
>
> Having very long and specific identifiers duplicated in two drivers is a
> daft situation.  Unless they both drive the same hardware, which afaict
> they do not?
The radios and macs are very similar (radios could actually be the same, no=
t=20
sure), with modifications to run on whatever bus they're on. That's why I'm=
=20
going to be merging the rtl8180_rtl8225.c and rtl8187_rtl8225.c into a sing=
le=20
piece of code. Besides that, rtl8187 !=3D rtl8225 since rtl8187 is a mac an=
d=20
rtl8225 is a radio. Replacing rtl8225z2 with rtl8187 makes no sense but is=
=20
okay temporarily to fix build issues in -mm.

=2DMichael Wu

--nextPart1877531.dyGU4aXVF4
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHS6KIT3Oqt9AH4aERAjf3AJwP6qmAQ6SGeAqxySQkz6Em/kRZcACfQkmn
d0EkupvWTaRpF1mEf9w46M8=
=1Du+
-----END PGP SIGNATURE-----

--nextPart1877531.dyGU4aXVF4--
