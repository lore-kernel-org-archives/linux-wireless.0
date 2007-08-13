Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:22547 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S937588AbXHMURO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 16:17:14 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: Recent linux-wireless git changes have broken my prism54pci card
Date: Mon, 13 Aug 2007 13:14:54 -0700
Cc: linux-wireless@vger.kernel.org, Chr <chunkeey@web.de>
References: <46BFF10B.1090307@hhs.nl> <200708130058.47778.flamingice@sourmilk.net> <46C0474B.2000206@hhs.nl>
In-Reply-To: <46C0474B.2000206@hhs.nl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1391944.W6IOcDRWWU";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200708131314.59141.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1391944.W6IOcDRWWU
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 13 August 2007 04:58, Hans de Goede wrote:
> Okay, I still had copies of various git revisions of prism54common.c and =
=2Eh
> (aka the culprits) on my laptop. I've run some tests again to make sure I
> had the right revisions in mind for the breakage (which I had). I've
> attached 2 patches:
> diff: with this reversed my speed increases 10x and more importantly when
> fully loading the link (using scp from a local non wireless ethernet
> machine) it no longer looses the connection in a couple of seconds
>
Hm, I guess either these changes were wrong or exposed some bugs. Can you=20
check what sort of tx rates are being reported in iwconfig before and after=
=20
that change?

> diff2, when I do not reverse this one, it still associates, but it no
> longer receives / or transmits packages. (no dhcp, no ping when manually
> assigning IP's, etc).
>
Not sure.. this patch generally helped things on my hardware. Christian=20
Lamparter might have an idea.

Thanks,
=2DMichael Wu

--nextPart1391944.W6IOcDRWWU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGwLvDT3Oqt9AH4aERAnqpAKDAfa/WFkbjMA/zD3tF7E4uphdrEQCdF8ZQ
dGOn8kZokdEHZldH/qbZ6PY=
=H/K1
-----END PGP SIGNATURE-----

--nextPart1391944.W6IOcDRWWU--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
