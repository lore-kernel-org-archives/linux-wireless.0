Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:51707 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755840Ab2CFV7z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 16:59:55 -0500
Date: Tue, 6 Mar 2012 22:59:42 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Hauke Mehrtens <hauke@hauke-m.de>, b43-dev@lists.infradead.org,
	larry.finger@lwfinger.net, florian@openwrt.org
Subject: Re: [RFT][PATCH] b43: fix logic in GPIO configuration
Message-ID: <20120306225942.6a115221@milhouse> (sfid-20120306_225959_326179_D419482A)
In-Reply-To: <1331071898-3651-1-git-send-email-zajec5@gmail.com>
References: <1331071898-3651-1-git-send-email-zajec5@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/mR5=gJtrz92IRRDpVKqTzVK"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/mR5=gJtrz92IRRDpVKqTzVK
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue,  6 Mar 2012 23:11:38 +0100
Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:

> By using reverted mask we were taking over pins we were not supporsed to
> touch. After fixing this workaround for BCM5354 should not be needed
> anymore.
>=20
> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com>
> ---
>  drivers/net/wireless/b43/main.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/m=
ain.c
> index 1d633f3..8a89885 100644
> --- a/drivers/net/wireless/b43/main.c
> +++ b/drivers/net/wireless/b43/main.c
> @@ -2706,8 +2706,6 @@ static int b43_gpio_init(struct b43_wldev *dev)
>  		mask |=3D 0x0060;
>  		set |=3D 0x0060;
>  	}
> -	if (dev->dev->chip_id =3D=3D 0x5354)
> -		set &=3D 0xff02;
>  	if (0 /* FIXME: conditional unknown */ ) {
>  		b43_write16(dev, B43_MMIO_GPIO_MASK,
>  			    b43_read16(dev, B43_MMIO_GPIO_MASK)
> @@ -2730,7 +2728,7 @@ static int b43_gpio_init(struct b43_wldev *dev)
>  	case B43_BUS_BCMA:
>  		bcma_cc_write32(&dev->dev->bdev->bus->drv_cc, BCMA_CC_GPIOCTL,
>  				(bcma_cc_read32(&dev->dev->bdev->bus->drv_cc,
> -					BCMA_CC_GPIOCTL) & mask) | set);
> +					BCMA_CC_GPIOCTL) & ~mask) | set);
>  		break;
>  #endif
>  #ifdef CONFIG_B43_SSB
> @@ -2739,7 +2737,7 @@ static int b43_gpio_init(struct b43_wldev *dev)
>  		if (gpiodev)
>  			ssb_write32(gpiodev, B43_GPIO_CONTROL,
>  				    (ssb_read32(gpiodev, B43_GPIO_CONTROL)
> -				    & mask) | set);
> +				    & ~mask) | set);
>  		break;
>  #endif
>  	}

This patch makes sense. Can you also check b43legacy? I guess it has the sa=
me problem.

And while we're at it, you could also remove these two lines:

2737         if (dev->dev->core_rev >=3D 2)
2738                 mask |=3D 0x0010; /* FIXME: This is redundant. */

because core_rev is always >=3D 2 in b43 and as the FIXME says the bit is a=
lready set.


Also, take a look at b43_gpio_cleanup() (in b43 and b43legacy).
It always forces all bits to zero. This clearly is wrong, too. It is suppos=
ed to
revert the changes done in the b43 GPIO setup. It seems too complicated to
fixup the code to actually do this, though. I think we should simply get ri=
d of
b43_gpio_cleanup() completely and simply leave the GPIOs as-is. No kittens
will be hurt by doing so; so it's ok.

--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--Sig_/mR5=gJtrz92IRRDpVKqTzVK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPVojOAAoJEPUyvh2QjYsODycP/Ap+sRN+KlBcUKB/tsAGbCdZ
NLOidjbjw141BeXaE1qbpiyb5HUPyHol3NKxjSlvesC32umLsW92gwyOaBmcWCkf
UYELECBxSlQaCP7RgHqZTesw2tp+LnMfJniZ6pF08ILSMr1N07/ZQSEzDPDuT+io
jyzjipFYitNlY1fW/XTpGkLHkKOiwzjYg/5s4bqylbBvAAi+gSyiFhbWZxwJUeNl
uqMogt2UjADlcTX4mZWgWsWmdy823savOtjKut1p0iS+4lVKWiqU6gxW4hCK1Mzg
njxF0ubAqO1u4pPS9rz7nGCdrQ03zTtprRdruwTORRNldoyMz+l+SNgEjfAwclfR
rF/AYFB3lHowIgpFrOfIkLSFAish+DWmVxkx06+qN6Q1Szf1eHLmNb7JccqTTOHu
uQsASDgrvq1aoVm7PCHw0XslbFaEcc/Q+qkT8i9Eo6ZwrcC9m0uKCG4GRx2aJOIV
nt5BGtbeTMtLlQoM8H3V5qH2Pu8bfxMR5YgFvnJIk842lydwBiiRzNWpxzrJVrue
rcZtMHyR0C82s4eBYhtEIlwR8jwmRRwNRLd5K5W7iP1XzpnnoUcSZcyhB3INrDKB
pim17THpVT1fAenyoLQVoMRUhpHuDfEOjcWR9vmUU/RM4fbJGknJuQ2CK3sTI+UW
hNncUOg2joEodaaESxwB
=LTXS
-----END PGP SIGNATURE-----

--Sig_/mR5=gJtrz92IRRDpVKqTzVK--
