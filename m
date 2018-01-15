Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933304AbeAOKXn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 05:23:43 -0500
Date: Mon, 15 Jan 2018 10:23:37 +0000
From: James Hogan <jhogan@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Redfearn <matt.redfearn@imgtec.com>,
        Paul Burton <paul.burton@mips.com>
Subject: Re: [PATCH] bcma: Fix 'allmodconfig' and BCMA builds on MIPS targets
Message-ID: <20180115102336.GC29126@saruman> (sfid-20180115_112358_940983_BF7FB67C)
References: <1515965642-16259-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ncSAzJYg3Aa9+CRW"
In-Reply-To: <1515965642-16259-1-git-send-email-linux@roeck-us.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--ncSAzJYg3Aa9+CRW
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 14, 2018 at 01:34:02PM -0800, Guenter Roeck wrote:
> Mips builds with BCMA host mode enabled fail in mainline and -next
> with:
>=20
> In file included from include/linux/bcma/bcma.h:10:0,
>                  from drivers/bcma/bcma_private.h:9,
> 		 from drivers/bcma/main.c:8:
> include/linux/bcma/bcma_driver_pci.h:218:24: error:
> 	field 'pci_controller' has incomplete type
>=20
> Bisect points to commit d41e6858ba58c ("MIPS: Kconfig: Set default MIPS
> system type as generic") as the culprit. Analysis shows that the commmit
> changes PCI configuration and enables PCI_DRIVERS_GENERIC. This in turn
> disables PCI_DRIVERS_LEGACY. 'struct pci_controller' is, however, only
> defined if PCI_DRIVERS_LEGACY is enabled.
>=20
> Ultimately that means that BCMA_DRIVER_PCI_HOSTMODE depends on
> PCI_DRIVERS_LEGACY. Add the missing dependency.
>=20
> Fixes: d41e6858ba58c ("MIPS: Kconfig: Set default MIPS system type as ...=
")

Well, technically I think commit c5611df96804 ("MIPS: PCI: Introduce
CONFIG_PCI_DRIVERS_LEGACY") is to blame (Cc'ing paul), and the first bad
commit would be commit eed0eabd12ef ("MIPS: generic: Introduce generic
DT-based board support") which selects PCI_DRIVERS_GENERIC and is the
only platform to do so. Both commits were first in v4.9-rc1 and I can
reproduce this problem at that latter commit with the appropriate
configuration.

But yes clearly the mentioned commit does also expose that existing
problem more widely and to the default allmodconfig, and it looks like a
reasonable approach for now, so if some mention of the other two commits
is added:

Reviewed-by: James Hogan <jhogan@kernel.org>

Having it in 4.15 would be great.

Cheers
James

> Cc: Matt Redfearn <matt.redfearn@imgtec.com>
> Cc: James Hogan <jhogan@kernel.org>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> I am aware that this problem has been reported several times. I have
> not been able to find a fix, but I may have missed it. If so, my
> apologies for the noise.
>=20
> Also note that this is not the only fix required; commit d41e6858ba58c,
> as simple as it looks like, does a pretty good job messing up
> "mips:allmodconfig" builds.
>=20
>  drivers/bcma/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
> index 02d78f6cecbb..ba8acca036df 100644
> --- a/drivers/bcma/Kconfig
> +++ b/drivers/bcma/Kconfig
> @@ -55,7 +55,7 @@ config BCMA_DRIVER_PCI
> =20
>  config BCMA_DRIVER_PCI_HOSTMODE
>  	bool "Driver for PCI core working in hostmode"
> -	depends on MIPS && BCMA_DRIVER_PCI
> +	depends on MIPS && BCMA_DRIVER_PCI && PCI_DRIVERS_LEGACY
>  	help
>  	  PCI core hostmode operation (external PCI bus).
> =20
> --=20
> 2.7.4
>=20

--ncSAzJYg3Aa9+CRW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEd80NauSabkiESfLYbAtpk944dnoFAlpcgSgACgkQbAtpk944
dnrQyA/+PVQnFEJuzptXlNh9jyXZZTC0HO91QVDjPAENkm/uHNtN8Fa/qG9eJm+g
gY8ttKaIe1gT3oa8SpORFi2FoFHs1HFr01MCbGpVWkeA+s8tq1Pr4TVZWRS1rnTC
sRDI5rT5nADi99V389qMXbKxtCh8tknrZAPrvgiraRMPYHvOhHcuvRG8muUb1kBl
gaUJEMzNF2TWhCJ5SkxzkkOgOJ0CHoVptLiZSHob9QhFYHIxy6/aj7mtnIuulu/3
syzzuvilzS4paJDL+KMnxlIjShzjw90WvdolKnSRABl1Zf2P/foH27vtwlEDt60z
9W+nhmFOmmfAdNECByypFp44UilEHRKOZMP5JLD1GOlo0EutRrmrQfw03RYiYlos
twlICyr9kao9rI+N5phNBdb/O/V/okGg+0MkVjrVxlxGFFWS5r+jRk+DInMv5B0d
GuWO6Bz+8gj1qH7oFs3+5eYRBGzuBwFG1Cv8kg2x+eSlr2OeGXPJ+IQ9dfpx1lO3
AkxgjHNtdhZqYj7+CT3FbG/iRfElTj4zsAOOl3vEDhQNq1cHi0n7W2JrjMspQse3
wfzIxINZ98rpHDfS8xTFxebPsSvP5zMEt4KdeTZxWZZR7T/Aj744BpGCJ+/rmbak
b4V5XKewIJHSXf0KgYxqlSVgjyb4P2YmxKG4qDhJadJbTtfsY+A=
=DaOU
-----END PGP SIGNATURE-----

--ncSAzJYg3Aa9+CRW--
