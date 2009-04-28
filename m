Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41468 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758672AbZD1VwA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Apr 2009 17:52:00 -0400
Subject: Re: wireless: remove some (bogus?) 'may be used uninitialized'
 warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-IyzBxnfpTryUIizBBxH0"
Date: Tue, 28 Apr 2009 23:51:29 +0200
Message-Id: <1240955489.593.11.camel@johannes.local> (sfid-20090428_235206_966773_8B5A5534)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-IyzBxnfpTryUIizBBxH0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

commit aa61eccbbd46faa89a7ebb06e642779a8fffa2c2
Author: John W. Linville <linville@tuxdriver.com>
Date:   Fri Apr 24 15:35:42 2009 -0400

    wireless: remove some (bogus?) 'may be used uninitialized' warnings
   =20
    net/mac80211/tx.c: In function =E2=80=98ieee80211_tx_h_select_key=E2=80=
=99:
    net/mac80211/tx.c:448: warning: =E2=80=98key=E2=80=99 may be used unini=
tialized in this function

This warning is totally _wrong_, and I would prefer you reverted this
commit because otherwise we may miss actually valid warnings when
editing those functions.

The fact that you get this warning is due to the, IMHO entirely stupid,
CONFIG_TRACE_BRANCH_PROFILING, which redefines if() as a macro. As one
would expect according to the GIGO principle [1], this causes the
compiler some problems. Can you turn that off in your config instead? :)

johannes

[1] http://en.wikipedia.org/wiki/Garbage_In,_Garbage_Out


--=-IyzBxnfpTryUIizBBxH0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ93peAAoJEKVg1VMiehFY4McQAKChk49dtxJ9n82wzTJEPeXt
uNGk5iLpXf4695wnCMzKe2WhqCLEx2y3T6UANogLxIHATFtJblPJDS0br9nfIYGX
PrptYchkJeim679m/CF3DUYINaMnsC9QFJOpDgPStt0/xtLOAzyXnA5mn+20FKyX
mKuW4f9a17rGzLQJdt3tuT8dSe9e5W3BkmplDK9noZgFJQREnOmsyfwVT8zC/RQo
Lbn+MKG71OEGgrt3rkgxqoUnKb+NeBNOxVVu7STEGQCvEYp5kE/esKpVOgT84B49
JxvMJcC3i4VABZFSHtHO3fhA063gGZMw93pJ7qyxaIDzFx6JHi+A5fuh+3S8VHnA
wCuOkTKkWXBxTkujmIqNikdEHA+DByhf44rbSljqeaxk14g7yflpdHARNGi9sV0t
rAPOFLTnnFMoLfS4JBJLFHKs8IL7S4scRUmJnFP93omg4lmAEigDSbDfwCtmrnrt
8Gpi+voMHjUWRg2jjEJ/o1wVKHXHXOCQKaPhZmEZ7JJofRn1WJ1IFbIXSfxl7Mb7
TAi2BAtxFv8Skw0DC0SRw/vs4Ww2SuTQe5Q2XeQhmTsmDdG3/x8cOYCAziBjnMzB
Mszje28YtzKMmlIOP5eykfXYdYlUFqoBFcdlkYyHgueqHVEhNQrS+xIbaYme79pa
pALnmFHGLyH/GBNCsvJV
=xonw
-----END PGP SIGNATURE-----

--=-IyzBxnfpTryUIizBBxH0--

