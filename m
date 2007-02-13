Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:50276 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750843AbXBMTnr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Feb 2007 14:43:47 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: network manager vs. missing firmware
Date: Tue, 13 Feb 2007 14:43:12 -0500
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
References: <1171392106.10344.100.camel@johannes.berg> <1171394598.5329.31.camel@localhost.localdomain> <1171395459.10344.123.camel@johannes.berg>
In-Reply-To: <1171395459.10344.123.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1621064.O5IAZpzz1u";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200702131443.16553.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1621064.O5IAZpzz1u
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 13 February 2007 14:37, Johannes Berg wrote:
> > So this isn't really consistent.  I'm unclear as to why the ipw cards
> > need it on init rather than on dev open, but hey, why make things
> > easier?
>
> When is ->init() called anyway? Isn't it when you register the netdev so
> it would be on probe?
>
Yes, ipw2200 does it on probe... but I know it can be pushed off to open. I=
've=20
done it. However.. I think intersil cards really need firmware to read the=
=20
eeprom. prism54 currently sets a fake MAC address so they can push it off t=
o=20
open, but I think this is wrong.

=2DMichael Wu

--nextPart1621064.O5IAZpzz1u
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF0hTUT3Oqt9AH4aERAjKWAKC4ja0Pq5WZMAmn2yTiUcg3CqO3CQCeL3R0
0g6LDD7BTMExL6uou3dckK0=
=yw05
-----END PGP SIGNATURE-----

--nextPart1621064.O5IAZpzz1u--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
