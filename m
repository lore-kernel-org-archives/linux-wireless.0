Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:61953 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab2FNGbg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 02:31:36 -0400
Date: Thu, 14 Jun 2012 08:31:20 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Wei Ni <wni@nvidia.com>, Mursalin Akon <makon@nvidia.com>,
	"'linux-mmc@vger.kernel.org'" <linux-mmc@vger.kernel.org>,
	"devicetree-discuss@lists.ozlabs.org"
	<devicetree-discuss@lists.ozlabs.org>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	"'linux-wireless@vger.kernel.org'" <linux-wireless@vger.kernel.org>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
	Rakesh Kumar <krakesh@nvidia.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Where to power on the wifi device before loading the driver.
Message-ID: <20120614063120.GA20167@avionic-0098.mockup.avionic-design.de> (sfid-20120614_083141_306880_B5551626)
References: <6B4D417B830BC44B8026029FD256F7F1C377BFFE88@HKMAIL01.nvidia.com>
 <4FD90352.9090606@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
In-Reply-To: <4FD90352.9090606@wwwdotorg.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 13, 2012 at 03:17:06PM -0600, Stephen Warren wrote:
> On 06/13/2012 04:40 AM, Wei Ni wrote:
> > Hi, all
> > I'm working on the tegra30 wifi upstream issue.
> >=20
> > The tegra30 board (Cardhu) use Broadcom 4329 as wifi device, and use br=
cmfmac as the wifi driver.
> >=20
> > In the brcmfmac init routine, it call sdio_register_driver() to registe=
r driver, if the wifi device is powered on, then the mmc driver will enumer=
ate it, and call the probe callback routine.
> >=20
> > On the Cardhu, the wifi's power is controlled by two gpios (power-gpio =
and reset-gpio), the default state is power-off. So we need to power on it =
before calling sdio_register_driver(), if not, the mmc driver can't enumera=
te it, and will not call the probe routine.
> > This power on sequence is:=20
> > set power-gpio to 1 ;
> > mdelay(100) ;
> > set reset-gpio to 1 ;
> > mdelay(200);
> >=20
> > My question is where to power on the wifi. We may have three places to =
power on it:
> > 1. power on it in the brcmfmac driver before calling sdio_register_driv=
er(). But I think this power sequence is special for tegra30 cardhu, it's n=
ot good to add it in the generic wifi driver, because different board may u=
se the different way to power on the wifi.
> > 2. power on it in the mmc driver. In our tegra SD driver, it has power-=
gpios property, which allow the slot to be powered. But this power is for m=
mc slot, could we add this wifi power sequence in the tegra SD driver?
> > 3. hard-coded into DT. Set these gpios in the DT, something like pinmux=
 settings, but in this way, it's not good to put the mdelay() value in the =
DT.
> >=20
> > I have no good idea for it, does anyone has suggestion?
>=20
> The core of the issue is that:
>=20
> * Tegra30 support is via device tree.
> * We have an SDIO bus, and the WiFi device attached to that bus is
> enumerable.
> * Since the WiFi device is enumerable, no node exists in the DT to
> represent it.
> * However, the driver for the WiFi device needs certain information,
> such as the reset GPIO ID and perhaps power GPIO.

PCI devices are also enumerable and yet they can be matched up with nodes in
the device tree. Perhaps something similar could be added for the SDIO bus?

Thierry

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAk/ZhTgACgkQZ+BJyKLjJp88uQCgkjDTLq4PyPRa8IqlfJDbJHdP
sHoAoK8a2JRjCjNc+RDMQbODI5Fbnhcx
=xT51
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
