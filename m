Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34092 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759221AbZEMKu2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 06:50:28 -0400
Subject: Re: [RFT v9] rfkill: rewrite
From: Johannes Berg <johannes@sipsolutions.net>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <9b2b86520905120709v4bd00e1eo4da26e6c5f75c4ba@mail.gmail.com>
References: <1242030669.6930.10.camel@johannes.local>
	 <9b2b86520905120709v4bd00e1eo4da26e6c5f75c4ba@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-zue64EGGvH4Lx7wYLnQH"
Date: Wed, 13 May 2009 12:49:56 +0200
Message-Id: <1242211796.29288.7.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zue64EGGvH4Lx7wYLnQH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-05-12 at 15:09 +0100, Alan Jenkins wrote:

> I tested on todays wireless-testing, aka v2.6.30-rc5-23297-gbf2c6a3.
> Somehow, it triggers an OOPS
>=20
> Function: req_reg_info_regd
> Process: modprobe
>=20
> Call trace:
> wiphy_apply_custom_regulatory
> ath5k_regd_init
> ath5k_reg_notifier
> ath5k_pci_probe
> ...
>=20
> Photo: <http://picasaweb.google.com/sourcejedi.lkml/Screenshots#533493685=
7267342674>
>=20
> The kernel then hangs later on in the boot process.  It responds to
> SysRq, but does not echo normal keypresses.  SysRq+P shows that the
> kernel is in the idle task.  I left it for three minutes, but I didn't
> get any trace from the hung task detector or soft lockup detector.
>=20
> At first I thought it must be a problem with wireless-testing.
> However, it went away when I eventually tried un-applying the rfkill
> rewrite patch.

Confusing, but I think the stacktrace is just bogus. Can you recompile
your kernel with CONFIG_FRAME_POINTER please?

johannes

--=-zue64EGGvH4Lx7wYLnQH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKCqXMAAoJEODzc/N7+Qmar0IP/RVU12XrTb9godggpXMAxBBo
borPkX0VCn4e2W4U51bjlPlVNS6BhXY3DdHOjpDcC8bRmm+FJxaJEgr483CNZckT
PnPk96QgdCwv0YdM8LAGQt4xOQvfslbKHFQaORmZ/EpQ5Io6E80vCODoHGJFQ1PP
lKAmL3EJcKUwPySi7kn8f6HlV4wX5P+twB8k7UwkROdwY2hhmnrz0B78aEi+m6lr
Y29nSrT7j4g64Ta1Qwe8DDQQ39M0KZdNLNnjMkSzozpLpmq9rVPUfMQD7kTfGrIz
arEhlvAXLSBzC4lu548Jm27RMIz0HvDBkR/xUH9TuP0EYMrTAGMIOzBoEuRRBi2b
0SGsaWHR7xD1QYKuOxYEPJ1t1Jh93nylxi54GiBRm8VXreWL+0SSzyMdJbv8dahp
tEqchu3YtQWq2E+Qt3XAe36gJqX3t3XLiPdvqjngJv4ko71qCzn3P4F/nr2wMyE1
Lch5e/7SvaLj1D+qy0dbFyUeKt15fqkU06goxn6wBqqHnq2j/dAuLvXULyb+odoj
XmNnE/A8Mp1q3y6TDetCqlNs8keUT3QEt3ALVBXzZCnyd3cdRUuafNbRo5U8HttZ
DvNXhD7oMKi32EGPq20yOHAzImBK7tYehQUjbERONbtMy59+Tbpcsn0bKwhUzicZ
SYADytacJ3/1tj0jP/CJ
=loKa
-----END PGP SIGNATURE-----

--=-zue64EGGvH4Lx7wYLnQH--

