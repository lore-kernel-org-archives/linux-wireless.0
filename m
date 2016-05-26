Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:46880 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805AbcEZMnL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 May 2016 08:43:11 -0400
Date: Thu, 26 May 2016 14:42:46 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Lukas Wunner <lukas@wunner.de>
Cc: linux-wlan-client-support-list@broadcom.com, 1332647@gmail.com,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: BCM4331 reset leads to wl lockup
Message-ID: <20160526144246.217bfff1@wiggum> (sfid-20160526_144315_379703_EE6BED01)
In-Reply-To: <20160526121210.GA7006@wunner.de>
References: <20160526121210.GA7006@wunner.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/TWVmWVhI2Pm7U=xn1he35pF"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/TWVmWVhI2Pm7U=xn1he35pF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 26 May 2016 14:12:10 +0200
Lukas Wunner <lukas@wunner.de> wrote:

> +	mmio =3D early_ioremap(addr, BCM4331_MMIO_SIZE);
> +	if (!mmio) {
> +		pr_err("Cannot iomap Apple AirPort card\n");
> +		return;
> +	}
> +	pr_info("Resetting Apple AirPort card\n");
> +	iowrite32(BCMA_RESET_CTL_RESET,
> +		  mmio + (1 * BCMA_CORE_SIZE) + BCMA_RESET_CTL);
> +	early_iounmap(mmio, BCM4331_MMIO_SIZE);

Just writing that bit is not the correct reset procedure.
So it might cause problems depending on how wl does the core reset
later.

Please try this:
- wait for BCMA_RESET_ST to be 0
- set reset bit
- flush
- wait 1us
- reset reset bit
- flush
- wait 10us

See bcma_core_disable()

--=20
Michael

--Sig_/TWVmWVhI2Pm7U=xn1he35pF
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXRu9GAAoJEPUyvh2QjYsOBuwP/2kjGvJhBSyljFeVVUacQm16
8Nv3oAZ9wtDXbHwZ8ySfBUWTLR8YispfbIrgG2kYkoR9WSLSSIwurHfevDky3iQf
nsi3Tr8a1v4sHEr9TrbhN5LzNax5rZBOj+M4UpclSQ1TbNLv7wcVvzpMiIAuS3Xu
Y8SOtUkTeGZEIskJD0txTfbMpezMpQYPwxBEMYSodNoAQs5zXSlXlSJUmaXkp1jq
gr+2DHKM3rg6y7ZSEmVNs8QYSt9Dm7o40bkV60xJX7rtQDxZvpq2jaijub+RljIP
+WEcbG5i1AQCnY9fYMkn9jH7fh2g6vtw9Nyy9EeKbeAZ++PJ/Zll6Ys0NQW6NZsZ
fS3no2IGlaFRkuqvrSzsU6+G1Nt7L6DRvwLP/nQ5/2CJK0q9/xHdTPQdkYdws30x
215X+90ac18gBUdphtk98bE3vrl6efI2qqUoSXN9he34WdXlIzB3MdCOMqaJcwVk
/+RpRkMpsVD/5fXmfM7BfQgwxnhtzf1CzwS2xFqCQKfZOhNgSK1XBWxL6rBbB7qn
tmNiAAoP1mmtk2RpY7ieZTYCKA+UlI6imYKgTyUDYscjNSTVDodujssU4qcJF8zy
y8bvjuym1H5H57K8NGYiTuYdMye47XVN5CV8gR6XH8mM9sRd62ZTWWB0Dx35bayx
cB9V/xbYoZfo/QHhFJsC
=PD+U
-----END PGP SIGNATURE-----

--Sig_/TWVmWVhI2Pm7U=xn1he35pF--
