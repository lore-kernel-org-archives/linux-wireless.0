Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:37986 "EHLO bues.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934914AbeEIQ3l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 12:29:41 -0400
Date: Wed, 9 May 2018 18:27:56 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Matt Redfearn <matt.redfearn@mips.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        =?UTF-8?B?UmFmYcWCIE1pxYJl?= =?UTF-8?B?Y2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Regression caused by commit 882164a4a928
Message-ID: <20180509182756.6f36cc05@wiggum> (sfid-20180509_182956_454979_D6D31763)
In-Reply-To: <372d149c-c34c-56a0-4e1a-5ab2c1e16e73@mips.com>
References: <7bbc067a-c412-3d2e-174a-abc31b46e246@lwfinger.net>
        <372d149c-c34c-56a0-4e1a-5ab2c1e16e73@mips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/J1WK1fb.oUu4_Zwymfp9gqq"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/J1WK1fb.oUu4_Zwymfp9gqq
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 9 May 2018 13:55:43 +0100
Matt Redfearn <matt.redfearn@mips.com> wrote:

> Hi Larry
>=20
> On 07/05/18 16:44, Larry Finger wrote:
> > Matt,
> >=20
> > Although commit 882164a4a928 ("ssb: Prevent build of PCI host features=
=20
> > in module") appeared to be harmless, it leads to complete failure of=20
> > drivers b43. and b43legacy, and likely affects b44 as well. The problem=
=20
> > is that CONFIG_SSB_PCIHOST is undefined, which prevents the compilation=
=20
> > of the code that controls the PCI cores of the device. See=20
> > https://bugzilla.redhat.com/show_bug.cgi?id=3D1572349 for details. =20
>=20
> Sorry for the breakage :-/
>=20
> >=20
> > As the underlying errors ("pcibios_enable_device" undefined, and=20
> > "register_pci_controller" undefined) do not appear on the architectures=
=20
> > that I have tested (x86_64, x86, and ppc), I suspect something in the=20
> > arch-specific code for your setup (MIPS?). As I have no idea on how to=
=20
> > fix that problem, would the following patch work for you?
> >=20
> > diff --git a/drivers/ssb/Kconfig b/drivers/ssb/Kconfig
> > index 9371651d8017..3743533c8057 100644
> > --- a/drivers/ssb/Kconfig
> > +++ b/drivers/ssb/Kconfig
> > @@ -117,7 +117,7 @@ config SSB_SERIAL
> >=20
> >  =C2=A0config SSB_DRIVER_PCICORE_POSSIBLE
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 depends on SSB_PCIHOST && SSB =3D=
 y
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 depends on SSB_PCIHOST && (SSB =
=3D y || !MIPS)
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 default y
> >=20
> >  =C2=A0config SSB_DRIVER_PCICORE =20
>=20
> I believe that the problem stems from these drivers being used for some=20
> wireless AP functionality built into some MIPS based SoCs. The Kconfig=20
> rules sort out building this additional functionality when configured=20
> for MIPS (in a round about sort of way), but it allowed it even when SSB=
=20
> is a module, leading to build failures. My patch was intended to prevent=
=20
> that.
>=20
> There was a similar issue in the same Kconfig file, introduced by=20
> c5611df96804 and fixed by a9e6d44ddecc. It was fixed the same way as you=
=20
> suggest. I've tested the above patch and it does work for MIPS=20
> (preventing the PCICORE being built into the module).
>=20
> Tested-by: Matt Redfearn <matt.redfearn@mips.com>


Could you please try this?

config SSB_DRIVER_PCICORE_POSSIBLE
	depends on SSB_PCIHOST

config SSB_PCICORE_HOSTMODE
	depends on SSB_DRIVER_PCICORE && SSB_DRIVER_MIPS && (SSB =3D y) && PCI_DRI=
VERS_LEGACY


The affected API pcibios_enable_device() and register_pci_controller()
is only used in HOSTMODE. So I think it makes sense to make HOSTMODE
depend on SSB=3Dy and PCI_DRIVERS_LEGACY.

PCICore itself does not use the API, if hostmode is disabled.

--=20
Michael

--Sig_/J1WK1fb.oUu4_Zwymfp9gqq
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAlrzIYwACgkQ9TK+HZCN
iw6zzRAAgYc6Piwo4UWmkEWzoAMnu/5X3HX1DoYkSAIvMnGokm/Gi27JkFRap9HW
syIze0IFGCOTTb9Z0LIiZfrpn4m4vjSrCaNCmBBXdexfhLIDWfjy5sDv76rhAffj
h6orCkbOWBoJ2Bpz/tnSYAhD+HO2kDLV9UmgHdhaUnZRGl8ciPcsJggpyNQa7+rd
gsupykZvm459wdx380Dptmu3fdKlu7HAXEwWUNGOOzg4U9+Er3Zyb29+GyPkO1uI
ueN3T2NlB77LgfziPiGyFw+0EqzUaWlvS1gAXapZVsx8S9FgO1WDhHe3bBJHE30F
eoJNAJxJFKOyTjWNxppAJICEePxXr889jogTKWkxBJYxn/mRINCV1mNJ/dZS3AQm
yIg1gfegntvV9vhw9uLAc0+tX/FDTs5ibkCm8S+PJcRd/s153qfA5eaqccChFpOO
+d2dbbyxTG5TnxO3wdM0v3LsoaZYai0vbRaKApoLADeqpkoSlCYEbaLcEY2W+kKr
6xzGis2FjeXzSuSjdExvezkBsTKdDmQlpLGLNTpRoDFJIboPrP0WXTMVnO1ZXQUu
KrsAFyda5Xzld8dz1J4pDzYksu4vPTetuJeyvcMtReq2U+3CMjoRHR1k49qetQeG
6ITHKhpQXynmVmlDAwLN2PbQfDHhkP/Zif50rl2K75nc2TNO/Ks=
=tofR
-----END PGP SIGNATURE-----

--Sig_/J1WK1fb.oUu4_Zwymfp9gqq--
