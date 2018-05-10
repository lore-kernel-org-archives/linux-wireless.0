Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:55234 "EHLO bues.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756679AbeEJLJy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 May 2018 07:09:54 -0400
Date: Thu, 10 May 2018 13:09:12 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Matt Redfearn <matt.redfearn@mips.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        =?UTF-8?B?UmFmYcWCIE1pxYJl?= =?UTF-8?B?Y2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: Regression caused by commit 882164a4a928
Message-ID: <20180510130912.72738106@wiggum> (sfid-20180510_131009_543538_11C45FAF)
In-Reply-To: <af1f604a-21e0-e7ff-f526-9d2aec184389@mips.com>
References: <7bbc067a-c412-3d2e-174a-abc31b46e246@lwfinger.net>
        <372d149c-c34c-56a0-4e1a-5ab2c1e16e73@mips.com>
        <20180509182756.6f36cc05@wiggum>
        <af1f604a-21e0-e7ff-f526-9d2aec184389@mips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/87YtzGCidlbcr1x5uZFlufW"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/87YtzGCidlbcr1x5uZFlufW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 10 May 2018 11:24:12 +0100
Matt Redfearn <matt.redfearn@mips.com> wrote:

> > Could you please try this?
> >=20
> > config SSB_DRIVER_PCICORE_POSSIBLE
> > 	depends on SSB_PCIHOST
> >=20
> > config SSB_PCICORE_HOSTMODE
> > 	depends on SSB_DRIVER_PCICORE && SSB_DRIVER_MIPS && (SSB =3D y) && PCI=
_DRIVERS_LEGACY
> >=20
> >=20
> > The affected API pcibios_enable_device() and register_pci_controller()
> > is only used in HOSTMODE. So I think it makes sense to make HOSTMODE
> > depend on SSB=3Dy and PCI_DRIVERS_LEGACY.
> >=20
> > PCICore itself does not use the API, if hostmode is disabled.
> >  =20
>=20
> Sure - I've tested the patch:
>=20
> --- a/drivers/ssb/Kconfig
> +++ b/drivers/ssb/Kconfig
> @@ -117,7 +117,7 @@ config SSB_SERIAL
>=20
>   config SSB_DRIVER_PCICORE_POSSIBLE
>          bool
> -       depends on SSB_PCIHOST && SSB =3D y
> +       depends on SSB_PCIHOST
>          default y
>=20
>   config SSB_DRIVER_PCICORE
> @@ -131,7 +131,7 @@ config SSB_DRIVER_PCICORE
>=20
>   config SSB_PCICORE_HOSTMODE
>          bool "Hostmode support for SSB PCI core"
> -       depends on SSB_DRIVER_PCICORE && SSB_DRIVER_MIPS
> +       depends on SSB_DRIVER_PCICORE && SSB_DRIVER_MIPS && (SSB =3D y) &=
&=20
> PCI_DRIVERS_LEGACY
>          help
>            PCIcore hostmode operation (external PCI bus).
>=20
>=20
> And this seems to work for MIPS, we don't get the build error from=20
> building the SSB module under nec_markeins allmodconfig, and=20
> SSB_PCICORE_HOSTMODE=3Dy for bcm47xx allmodconfig, which selects SSB=3Dy.
>=20
> So this looks like a good fix for MIPS, at least.
>=20
> Tested-by: Matt Redfearn <matt.redfearn@mips.com>


Thanks.
Could you please submit it?
You can add my Acked-by.

--=20
Michael

--Sig_/87YtzGCidlbcr1x5uZFlufW
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAlr0KFgACgkQ9TK+HZCN
iw5y9A/7BABuNQ+CSpVQqNzuzLUqhvdOpfkSad3mH2cmbEWwNPgeZB8GIQJUUR3l
PRbZMQJhGg0nBwJJLsrP/qXXCoX50y/XLhrrJLCPIt7KCPCKbjnR5M2Zgw0aRrTm
imoKQVf3ZDjvc/32NJ0yantApp6L9yEzICCAhGPN76g1V9jNM5I7u7Pw/dHG6w0E
nZB2EBlrSQZiYgIrK9OwebF2qfIj5J+sJQg32EJoDVjr+PB/TC3t96+REGX4+Bty
/FhVN9a6HNFN0Yld4Fv0LJtyynyMkKmkl+Es040R8GuS0d3weVtD0lIUYJIHhbkG
ww5N00DeiK6e5hL+j1hQclNgkYSBChDkFtUQNxaOXjBSzDP8QdI4qO9BlnWHF8ez
VXrR1I2pX5n4s2+iwaidGHA+VNaKzuxF27jQKQLjzL4BpUdfhbUx5Rue4/InGUzw
8nJCkK8NXt/1yEGZK1XXhU/w80B5ncqZjRd9dtdVaeukGpvBPOdaYqgqHlPfEC7n
Ljsgg7W5EO2RqSd4pjwERkHnoaF3J70qtPF/AcQEmXxo8EflMEoAMoJSgoFxeFy5
R5S6Ydp/jbR731GwfXHEimSnQmTKQuX7hrWTMGzGWj37mPQLUUbmtScu4bh9oBnW
tYxlKQQoUjXmBNqNdHJ2HeV+1Vo3PUmnBo8lKxa9R6d7zjr0hRo=
=Nsfv
-----END PGP SIGNATURE-----

--Sig_/87YtzGCidlbcr1x5uZFlufW--
