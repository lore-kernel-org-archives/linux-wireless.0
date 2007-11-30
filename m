Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44929 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760319AbXK3Ljf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2007 06:39:35 -0500
Subject: Re: [PATCH] iwlwifi: delay firmware loading from pci_probe to
	network interface open
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Tomas Winkler <tomasw@gmail.com>
In-Reply-To: <1196327913-24715-1-git-send-email-yi.zhu@intel.com> (sfid-20071129_091923_560748_F8C6F138)
References: <1196327913-24715-1-git-send-email-yi.zhu@intel.com>
	 (sfid-20071129_091923_560748_F8C6F138)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nhzLImX3jhDp1zLmnvtG"
Date: Fri, 30 Nov 2007 12:37:43 +0100
Message-Id: <1196422663.6058.181.camel@johannes.berg> (sfid-20071130_113937_969837_6D6B21C3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nhzLImX3jhDp1zLmnvtG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Thu, 2007-11-29 at 17:18 +0800, Zhu Yi wrote:
> Tomas pointed my assertion "iwlwifi cannot get MAC address without
> firmware being loaded first" is not true. Here is a updated patch to
> get iwlwifi device MAC address from EEPROM before firmware being
> loaded. With this function, I don't need the mac80211 change for "set
> interface MAC address after driver's start() is called".

Nice :)

> BTW, I also pci_enable_device() and pci_disable_device() in the
> driver's start() and stop() handler. Hope it will make the device
> consume less power when the interface is not up.

You should probably double-check this with the hardware guys. With
Broadcom hardware we've seen it consume *more* power if we don't at
least enable the device and turn off things on the device itself.

johannes

--=-nhzLImX3jhDp1zLmnvtG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0/2B6Vg1VMiehFYAQI2cRAAkCUVBfxg5d6WWASmmvNvVMZ4vCGXoSdo
pG/KKtFTIhbctd0gwnixH2WeAh50fCDceog0KwDWoEFbNMk6vgkom9HyA4MC5Hqv
ZUkNQoXDoEPx1lRFXWi10ZR2aMMYIOMIdr+0kpyR4SAsN+0FuZRzwT7FMP08QfLQ
Np4r35DLzYKtBuXnEyx0nrxXkaNjNdMYTfGN07heSZF086wyf/4z6jixDpRFOlB4
/Z3WRp5AZNcHVJxla8Q6vfuMgZrlwDno8G8Pkq9iUDIn7BDRmxn779wCaRQ35wPH
xBktVkFxQRSssWq7+1/fRz3xIkP/Mt/PkXL/b8/UC4GIFP7Ns9QZOVGLBZLOF5Xr
U9HfIdNLJm5ra5u6IsftBi5mFg16u9o6EZUQNYvAFBxMbfT0JFqtm+r7eeoHHJKC
dpG6wUCjgHij0jkE1gwTMmGEo117IUToFd5Hw3RsEZ2HBC65D+9SenqwbQz4/Krl
CGSJ69iep98opKPwK0CnHhWf408VCeEp/ss5BVRbI1WBesIo0mrlW806Ywx5Bu8p
jmX/S/LC4ThraNkXOs8CoLeBhp+JfNslz7nhVslVHzNQaLWcFu0BLVb8bXIXN55g
wMYJOoMCTYBBcTMN2yo1TKrQ6NkwSAo2gSR7yV8lVGdU24LfCNsikCDfTWT++oCg
6xBAptLoXZ4=
=I7jD
-----END PGP SIGNATURE-----

--=-nhzLImX3jhDp1zLmnvtG--

