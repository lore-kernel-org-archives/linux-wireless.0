Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52121 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503AbXK2Its (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2007 03:49:48 -0500
Subject: Re: [PATCH 1/2] mac80211: set interface MAC address after driver's
	start() is called
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1196300047-6201-1-git-send-email-yi.zhu@intel.com> (sfid-20071129_013615_457152_DDE3939F)
References: <1196300047-6201-1-git-send-email-yi.zhu@intel.com>
	 (sfid-20071129_013615_457152_DDE3939F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VOfBoNsQdeMONhlklrWa"
Date: Thu, 29 Nov 2007 09:49:34 +0100
Message-Id: <1196326174.6058.173.camel@johannes.berg> (sfid-20071129_084953_021074_8CC2CCD4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VOfBoNsQdeMONhlklrWa
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Thu, 2007-11-29 at 09:34 +0800, Zhu Yi wrote:
> The patch enables mac80211 to set interface MAC address after the
> interface is UP. This is useful for wireless drivers load their firmware
> in the mac80211 interface start() callback (called when interface UP).
> Because for kernel built-in (vs. module) network drivers, they are
> initialized in a very early stage (even before hard disk is ready). So
> loading firmwares in the device pci_probe time is not a good idea. Some
> devices for example iwlwifi cannot get MAC address without firmware being
> loaded first.
>=20
> It also sets mac80211 dev->validate_addr to NULL so that we don't need to
> have a MAC address in the dev->open time.

This cannot possibly work We do a lot of MAC address sanity checking at
_open() time *before* the place where you inserted the MAC address copy.

Deferring MAC address setting to open() time is also *very* bad for the
user experience because they no longer have the guarantee the the MAC
address they see is the one that will be used when the interface is
brought up.

johannes

--=-VOfBoNsQdeMONhlklrWa
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR059HKVg1VMiehFYAQKh+Q//ewrH2c4NBPUgG4HlO04QVm1Q5Vtb+alY
V6j54aXZ2JywVGYgcMAn4PrJJ6/Z1yCUTMCNyDr+qm9M+mq0fo1mR5Wsth9f7xUf
fQv6K+giP92Gie4KNEbMlXG85ZwdrO/SWq+xMrqELIKYKyV2WhblI2a64gDfIJjQ
1xxaH1wlPcAI6uOINPQIx0W44NU7LdkO0CwOyQeYVuMlE5V6ANLoisK4VQI9DRYS
qEoWBNLRGQOWBI+tfR/Wy65aC/kD6QrfBhekXFhYSH269GivGyfIk0RprWinUILI
iCVfbSFTy8tgbXwXU1fGqMe6L3cnTIpRKAbkfMMu+EXqx8Pzox7FQKarHuvKsI9j
NpchxL7VxGTfoCaUxZOSPhHzaTgJ5p8BgOlcZzdzNIC05b2niwrdyrVO+0eVLv3P
8BxIdpYGP6V34pAjkLBigEu3dJePxMjPxJcQKS7AURvgTFCLDNXMSUafUquhXnYu
ZUsdKpQLdX6Qcs/QnUiwVmyF851/0rSKTR3tQwGXTlLbPuuUn3Ghd8hZwazySdcG
IDhXdmbsO/Oke9XpCUv9lXfQErnXw7kcOPOOyO13MfJmp4Zocd+iSXpgXeoG8tG5
Oyospe7rnZbs0gGsfUGc/JuwwRAIT9qb+IcquVcS2B1MHW+g1aHt1ZuJTyMLf1l4
kl09Agq0gAI=
=MtVj
-----END PGP SIGNATURE-----

--=-VOfBoNsQdeMONhlklrWa--

