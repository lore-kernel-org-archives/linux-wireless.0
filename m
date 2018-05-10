Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:55288 "EHLO bues.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934002AbeEJLSE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 May 2018 07:18:04 -0400
Date: Thu, 10 May 2018 13:17:25 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Larry Finger <larry.finger@lwfinger.net>,
        Matt Redfearn <matt.redfearn@mips.com>,
        linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH 4.17 2/2] ssb: make SSB_PCICORE_HOSTMODE depend on SSB =
 y
Message-ID: <20180510131725.111079af@wiggum> (sfid-20180510_131818_237981_CDE774D3)
In-Reply-To: <20180510111401.1161-2-zajec5@gmail.com>
References: <20180510111401.1161-1-zajec5@gmail.com>
        <20180510111401.1161-2-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/LYuvGXWFcxeqfuoTvE+Dq9Z"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/LYuvGXWFcxeqfuoTvE+Dq9Z
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 10 May 2018 13:14:01 +0200
Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:

> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>=20
> SSB_PCICORE_HOSTMODE protects MIPS specific code that calls not exported
> symbols pcibios_enable_device and register_pci_controller. This code is
> supposed to be compiled only with ssb builtin.
>=20
> This fixes:
> ERROR: "pcibios_enable_device" [drivers/ssb/ssb.ko] undefined!
> ERROR: "register_pci_controller" [drivers/ssb/ssb.ko] undefined!
> make[1]: *** [scripts/Makefile.modpost:92: __modpost] Error 1
>=20
> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
> ---
>  drivers/ssb/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/ssb/Kconfig b/drivers/ssb/Kconfig
> index b3f5cae98ea6..c574dd210500 100644
> --- a/drivers/ssb/Kconfig
> +++ b/drivers/ssb/Kconfig
> @@ -131,7 +131,7 @@ config SSB_DRIVER_PCICORE
> =20
>  config SSB_PCICORE_HOSTMODE
>  	bool "Hostmode support for SSB PCI core"
> -	depends on SSB_DRIVER_PCICORE && SSB_DRIVER_MIPS
> +	depends on SSB_DRIVER_PCICORE && SSB_DRIVER_MIPS && SSB =3D y
>  	help
>  	  PCIcore hostmode operation (external PCI bus).
> =20


I think we also need to depend on PCI_DRIVERS_LEGACY.
See the other patch that floats around.


--=20
Michael

--Sig_/LYuvGXWFcxeqfuoTvE+Dq9Z
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAlr0KkUACgkQ9TK+HZCN
iw4BBhAAviGJSH9TbTZSY9GOTaJP0+3qnkZT4qi8G0RjCNzr/Gsi/GdSwl6IlUx2
0rgqPrVqfHmZs9MPgs5X+ApYTK0aX0B4OpQLuWh1ddLHJNwIVtOfegP5u73V/f9Z
JkUSX0d6bb2MLJmUDh/yH+Aqajgmj3/DXx/surIMx1WWU7k0/YLL9N4c71HMfaDc
0So0nwGB7B84ZHnqAeExB1l0nZqsvPZ8Jlmbcm95x0Prxp+ZXAz/ZE9NfR7MlfTO
hmv3nfNnp3ZEuUOujOuK0RbmI3TXsG/En6AMIMP85RaVclokwzJBeqUl/02Vtp5C
feW2YXrZrp105FmIpDVlP/XD/TNs72QQ3CoDEXIu9sNa2QM2VPeXTguZ1Q1GVosr
Z34+FQo2BZQEsxlmuoz8YCZjKrC/lAuH4rrV8s2oEBoZ2VOM3zxOoPbr0x73k6E4
I/PDtKHNCnydgywIvm1oL9obBbC1euINCpflrSNefvFZ8PUBvhsUU0QYwAdomFtJ
Wu4DHUD9SrZJ8oKsuFwmXu7HbMqpuqkkwWIJwfuh0AVW4dPSciQ0hm/KU+Ff4ah5
YpRTksfCQTdg8PAS5QN3tMTB8jlVKr6g9F87bhSwHmvBgnlfmIGrfxbCE8Z8SvsP
cwXHotMt1kLn+abYjk+d3sXvV7cbXocFNFi1foxvHUePyHskKWs=
=Kkq3
-----END PGP SIGNATURE-----

--Sig_/LYuvGXWFcxeqfuoTvE+Dq9Z--
