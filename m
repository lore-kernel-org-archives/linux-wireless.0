Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:63142 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S967344AbXEHAEF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2007 20:04:05 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2] Add rtl8187 wireless driver
Date: Mon, 7 May 2007 20:03:24 -0400
Cc: jeff@garzik.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	andrea.merello@gmail.com
References: <200705071022.11711.flamingice@sourmilk.net> <200705071917.25414.flamingice@sourmilk.net> <20070507.162518.35013789.davem@davemloft.net>
In-Reply-To: <20070507.162518.35013789.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1562274.oebPpi6ZBI";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200705072003.29448.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1562274.oebPpi6ZBI
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 07 May 2007 19:25, David Miller wrote:
> I know this sounds trite, but when merging and researching up to 450
> patches at a time like I have to, this stuff starts to matter.
>
> Please put things as high in the directory hierachy as possible and
> when you can put the entire driver into a single source file do so.
>
Sure. I generally prefer that too, but all the drivers I put in wireless-de=
v=20
were put in separate directories because I didn't want to break the pattern.

> The only significant argument you present is the code sharing one for
> the radio stuff, but that isn't realized yet and you can certainly
> split the code out once you make that sharing a reality.
Having different modules for different radio chips really isn't the point o=
f=20
keeping it in a separate file. (in fact, rtl8187_rtl8225.c actually contain=
s=20
support for two versions of the rtl8225 radio) It's just that=20
rtl8187_rtl8225.c is basically a bunch of numbers with a bit of glue code t=
o=20
send them to the hardware. Not much is missed if you decide not to look at=
=20
how the radio tuning works, and I like to avoid looking at that code if I=20
can. It's also consistent with how the (unreleased) rtl8180 driver works,=20
which really does have support for different radios in different files.

But of course, we can just make an exception for rtl8187. Would merging the=
=20
files together make that much of a difference for you?

=2DMichael Wu

--nextPart1562274.oebPpi6ZBI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGP75RT3Oqt9AH4aERArWhAKDIrPlqESQGRu1liJUy71aLRXlsfQCguNLG
gCDrRTO/dxU5G92aSk5dAiA=
=/gYw
-----END PGP SIGNATURE-----

--nextPart1562274.oebPpi6ZBI--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
