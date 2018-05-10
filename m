Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:55328 "EHLO bues.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935115AbeEJL0k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 May 2018 07:26:40 -0400
Date: Thu, 10 May 2018 13:26:12 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Larry Finger <larry.finger@lwfinger.net>,
        Matt Redfearn <matt.redfearn@mips.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH 4.17 2/2] ssb: make SSB_PCICORE_HOSTMODE depend on SSB =
 y
Message-ID: <20180510132612.25c8c20e@wiggum> (sfid-20180510_132654_059680_3B0F49B9)
In-Reply-To: <CACna6ryWUCnrw9w4yhfiNXFHy1hFjVV-BqH07i7DQqxq8FtjMw@mail.gmail.com>
References: <20180510111401.1161-1-zajec5@gmail.com>
 <20180510111401.1161-2-zajec5@gmail.com>
 <20180510131725.111079af@wiggum>
 <CACna6ryWUCnrw9w4yhfiNXFHy1hFjVV-BqH07i7DQqxq8FtjMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/PyILieRqIXwLZLz+e2YE=TJ"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/PyILieRqIXwLZLz+e2YE=TJ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 10 May 2018 13:20:01 +0200
Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:

> On 10 May 2018 at 13:17, Michael B=C3=BCsch <m@bues.ch> wrote:
> > On Thu, 10 May 2018 13:14:01 +0200
> > Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:
> > =20
> >> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
> >>
> >> SSB_PCICORE_HOSTMODE protects MIPS specific code that calls not export=
ed
> >> symbols pcibios_enable_device and register_pci_controller. This code is
> >> supposed to be compiled only with ssb builtin.
> >>
> >> This fixes:
> >> ERROR: "pcibios_enable_device" [drivers/ssb/ssb.ko] undefined!
> >> ERROR: "register_pci_controller" [drivers/ssb/ssb.ko] undefined!
> >> make[1]: *** [scripts/Makefile.modpost:92: __modpost] Error 1
> >>
> >> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
> >> ---
> >>  drivers/ssb/Kconfig | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/ssb/Kconfig b/drivers/ssb/Kconfig
> >> index b3f5cae98ea6..c574dd210500 100644
> >> --- a/drivers/ssb/Kconfig
> >> +++ b/drivers/ssb/Kconfig
> >> @@ -131,7 +131,7 @@ config SSB_DRIVER_PCICORE
> >>
> >>  config SSB_PCICORE_HOSTMODE
> >>       bool "Hostmode support for SSB PCI core"
> >> -     depends on SSB_DRIVER_PCICORE && SSB_DRIVER_MIPS
> >> +     depends on SSB_DRIVER_PCICORE && SSB_DRIVER_MIPS && SSB =3D y
> >>       help
> >>         PCIcore hostmode operation (external PCI bus).
> >> =20
> >
> >
> > I think we also need to depend on PCI_DRIVERS_LEGACY.
> > See the other patch that floats around. =20
>=20
> I believe it's already handled by SSB_PCIHOST_POSSIBLE's dependency on
> PCI_DRIVERS_LEGACY.


That dependency seems to be wrong there.
Was it added among some other "let's just unbreak some random
build" change as well?

SSB_PCIHOST enables support for SSB on top of PCI. (Which is 99% of it
uses). I don't see how this uses the legacy API.

SSB_PCICORE_HOSTMODE enables PCI on top of SSB. Which is a MIPS corner
case. This uses the legacy MIPS API to register a PCI bus.

--=20
Michael

--Sig_/PyILieRqIXwLZLz+e2YE=TJ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAlr0LFQACgkQ9TK+HZCN
iw4fBxAA4MbuyoXLlqcFbKPsL+DurCb+P7y3aGUoeQL5ZqtYmX38xRXV3jPaPYBG
4olkODEzw3IP3KweXuBzP6Vc1EtfdAqV42hjJyp5EyEHbabCAA6EjqvAg0O/UuVi
aA/PHZ4cX/Kr8us/9ctrZOhvb1qXaLwybNWViBoarQTnsS9x2mwVHdIEeXpjLBVB
v6MKyqIX3OiFCHj0lmoiGM5zMCI+A1u769oFr4htVUywxCdKvfaiYc2o5ug9+rjw
eoLMAdG+ZJTU3GUYVmt9/Dr9eReXASwWz0nd7K3ztV6xMKJFqxoeVtUkQwRnKxAJ
HuGqcJRYYG4+V58owBEgaufNU1MJVXo88zoVlQ4/CPxkkKDyW4WiyRGmw0Zf6Z9G
M6p2jyO4uKxV3w2uQLQHgzMnLFGsCVW7rvcVYK1xv2mO2bKEwGi/oCIhmOM3058L
Esvv9NuueKyM0ddPGD7YXgCfwOdOg5PkGnWsh/WnurOgxzIolhLFEnILDa8iia2Y
Mmrd+Wnaxdw+prakwITuGgymSaCxnQcCd0h8OdqgZZqDUqyvlBqTGOyECgT8CUhX
mM/QNyYNJHiaQ3gEpcfw7G7LEinjqZkCFkIoPC+hhgr5pmFekHpR+nq3Q13DCGWc
eyooKarmcJn7bbgSBYeuzbdmV/KhEW0AKzigCIRjlVkcUqwhE0o=
=d7ZQ
-----END PGP SIGNATURE-----

--Sig_/PyILieRqIXwLZLz+e2YE=TJ--
