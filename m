Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53303 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755742Ab2FNMMh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 08:12:37 -0400
Date: Thu, 14 Jun 2012 13:12:34 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Wei Ni <wni@nvidia.com>,
	Mursalin Akon <makon@nvidia.com>,
	"'linux-mmc@vger.kernel.org'" <linux-mmc@vger.kernel.org>,
	"devicetree-discuss@lists.ozlabs.org"
	<devicetree-discuss@lists.ozlabs.org>,
	"'linux-wireless@vger.kernel.org'" <linux-wireless@vger.kernel.org>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
	Rakesh Kumar <krakesh@nvidia.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Where to power on the wifi device before loading the driver.
Message-ID: <20120614121234.GC3913@opensource.wolfsonmicro.com> (sfid-20120614_141242_157793_CCA3AE63)
References: <6B4D417B830BC44B8026029FD256F7F1C377BFFE88@HKMAIL01.nvidia.com>
 <4FD90352.9090606@wwwdotorg.org>
 <20120614063120.GA20167@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NU0Ex4SbNnrxsi6C"
In-Reply-To: <20120614063120.GA20167@avionic-0098.mockup.avionic-design.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--NU0Ex4SbNnrxsi6C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 14, 2012 at 08:31:20AM +0200, Thierry Reding wrote:
> On Wed, Jun 13, 2012 at 03:17:06PM -0600, Stephen Warren wrote:

> > The core of the issue is that:

> > * Tegra30 support is via device tree.
> > * We have an SDIO bus, and the WiFi device attached to that bus is
> > enumerable.
> > * Since the WiFi device is enumerable, no node exists in the DT to
> > represent it.
> > * However, the driver for the WiFi device needs certain information,
> > such as the reset GPIO ID and perhaps power GPIO.

> PCI devices are also enumerable and yet they can be matched up with nodes in
> the device tree. Perhaps something similar could be added for the SDIO bus?

This seems to make the most sense - pushing this through the regulator
API is just a bodge.

--NU0Ex4SbNnrxsi6C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP2dRnAAoJEBus8iNuMP3dZv8P/iRUNp/d1E9ekU/9muMqEHqN
YuYrh5eoSB+n/Z5L3NhfNHooqJ4AGlxLKKaBYy1vuuonCvmzQzPhmVsR3EIjPqWS
AGcNnmcg/Kwxw9JNiIpglRxBK6WLUyxN2ru9gll9y7/rDi5ghFwL/Y/Wjg4NqFaJ
E8CqUraBHvWM0KFlOakj0Ho54/tLY5tQ1jjubIX6PJ2dTgEYObEoGPe6wdvd30dZ
6MUgfZ5mpevjnCYk8s+Y1DGSkztlsbiMhMRU/op4cDlojCBg4Q1WzwgiLmq8RCEq
1da0m6RpJEByMVmoT9lVa6iWweOV6iLnah9xTFIPS6dm6J/rNXkRu9TPDlkf1pK7
MjyHLTjLNGYqjpAnqKbcYBsRcVjagIggxK96KqecFGMUxL8Sj4I/eG04Qug5SDfL
xRQFXhyCpTkTDgg99nRw0gadt+FOI5VHXxO4fYQuiImO1eN2D7r76pVMC0qDjffv
wDZjckI7UHqDsYZSNzv+gfWmwVTHT8NfuEhY0az7bxIyZ+1vbNgBd++Apyyu30XC
5d+IG1BBLTmszZSkVMu52skbe7jg1cRcn6KQTsRDz+bJ2u50imPk8axdF2iPeL7Y
6CDdxWFooC/lXfCHIUSp03ncdUSLCWY9KAiBw0r54S450wp7Xb+k8UvWq2HO1ql6
H0xwR/e7wiWw8QuvBrIt
=2m8d
-----END PGP SIGNATURE-----

--NU0Ex4SbNnrxsi6C--
