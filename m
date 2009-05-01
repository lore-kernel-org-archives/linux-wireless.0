Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from chilli.pcug.org.au ([203.10.76.44]:46012 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070AbZEAFVt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 May 2009 01:21:49 -0400
Date: Fri, 1 May 2009 15:21:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: linux-next: driver-core tree build warning
Message-Id: <20090501152144.500e619a.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__1_May_2009_15_21_44_+1000_euLN=A._odtSICqo"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Signature=_Fri__1_May_2009_15_21_44_+1000_euLN=A._odtSICqo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next build (x86_64 allmodconfig) produced these warnings:

drivers/net/wireless/ipw2x00/ipw2100.c: In function 'show_cfg':
drivers/net/wireless/ipw2x00/ipw2100.c:3491: warning: passing argument 1 of=
 'dev_get_drvdata' from incompatible pointer type
include/linux/device.h:457: note: expected 'const struct device *' but argu=
ment is of type 'struct device **'
drivers/net/wireless/ipw2x00/ipw2100.c: In function 'show_status':
drivers/net/wireless/ipw2x00/ipw2100.c:3500: warning: passing argument 1 of=
 'dev_get_drvdata' from incompatible pointer type
include/linux/device.h:457: note: expected 'const struct device *' but argu=
ment is of type 'struct device **'
drivers/net/wireless/ipw2x00/ipw2100.c: In function 'show_capability':
drivers/net/wireless/ipw2x00/ipw2100.c:3509: warning: passing argument 1 of=
 'dev_get_drvdata' from incompatible pointer type
include/linux/device.h:457: note: expected 'const struct device *' but argu=
ment is of type 'struct device **'
drivers/net/wireless/ipw2x00/ipw2100.c: In function 'show_rf_kill':
drivers/net/wireless/ipw2x00/ipw2100.c:4227: warning: passing argument 1 of=
 'dev_get_drvdata' from incompatible pointer type
include/linux/device.h:457: note: expected 'const struct device *' but argu=
ment is of type 'struct device **'

Introduced by commit 73119f5e60e3b16577e99e2f035039bed0d2dcca ("Wireless:
remove driver_data direct access of struct device").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__1_May_2009_15_21_44_+1000_euLN=A._odtSICqo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkn6hugACgkQjjKRsyhoI8yLuQCgmlYPYwARXT6GDx6Y/KRTtN2O
WdkAn198M+rgYZ4PwVce8elkD2aLt8Zw
=1NqE
-----END PGP SIGNATURE-----

--Signature=_Fri__1_May_2009_15_21_44_+1000_euLN=A._odtSICqo--
