Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:41494 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756662AbcCaTKd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2016 15:10:33 -0400
Date: Thu, 31 Mar 2016 21:09:36 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Lukas Wunner <lukas@wunner.de>
Cc: linux-pci@vger.kernel.org, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH] PCI: Add Broadcom 4331 reset quirk to prevent IRQ storm
Message-ID: <20160331210936.6b195135@wiggum> (sfid-20160331_211037_044224_ADBCB1A2)
In-Reply-To: <E1akxli-00030z-Jz@bombadil.infradead.org>
References: <E1akxli-00030z-Jz@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/_xYEW=6KCZST_Ps4z+y3D02"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/_xYEW=6KCZST_Ps4z+y3D02
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 29 Mar 2016 19:41:30 +0200
Lukas Wunner <lukas@wunner.de> wrote:

> +static void quirk_apple_b43_reset(struct pci_dev *dev)
> +{
> +	void __iomem *mmio;
> +
> +	if (!dmi_match(DMI_BOARD_VENDOR, "Apple Inc.") || !dev->bus->self ||
> +	    pci_pcie_type(dev->bus->self) !=3D PCI_EXP_TYPE_ROOT_PORT)
> +		return;
> +
> +	mmio =3D pci_iomap(dev, 0, 0);
> +	if (!mmio) {
> +		pr_err("b43 quirk: Cannot iomap device, IRQ storm ahead\n");
> +		return;
> +	}
> +	iowrite32(BCMA_RESET_CTL_RESET,
> +		  mmio + (1 * BCMA_CORE_SIZE) + BCMA_RESET_CTL);
> +	pci_iounmap(dev, mmio);
> +}
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_BROADCOM, 0x4331, quirk_apple_b43_=
reset);

Looks good, as long as the wireless core is always guaranteed to be
the second core on that PCI device.

--=20
Michael

--Sig_/_xYEW=6KCZST_Ps4z+y3D02
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJW/XXwAAoJEPUyvh2QjYsOSY0P/RcRZmmRUggMrGRKGl4Vh9Q0
cYq+ij/D5n8F/ro7Vev4k/b1Bv+Qw5Q0U/yVoep5NRco3Xj6YKLrw+GdoQNE8Ks1
zCWPufKHCL6nn1r8aN0NFtGa3ICI1mDoMKcEuJE41m58KJmsaz+oEPH2MXBQEaq6
ljPX6EWIIV2fLv4PUwb+/vPmJwn0GtU28tTdKh7dncAjHRh4E57Dsd55kCwhqAm5
85AWXf1e0O4DHFwdAGa+jPMIk+XVpLZQw2kFh3YQFbDCvow0L1OoIrbnaXLyruhX
SaxKJ3PLNvurLe6vsl71tbq/COHHkFKJb3OvlDle+QEIUdHXZCZsqodKoBfrbojl
zdjn31echMj97Dt+HqgH1xC+WVEq8LSEvsJZEDWOk/3JaslDSHPAlEi8DhrMOpwZ
XnLRu84yNifpDWCtlLjsEanqL12tJ3oCZxeIL78JgbLZUwgq3tQ9JYphdFIOzyqh
mSA9E5hQhu9srkG27u25rlWVfLqZOKZIGGBZF2Z8AWM7gn1WA0gIQkDEH5zb5csG
5q+Z/hRb7UA/2bldr7SkoQguZE1LCl5EmoMTAowiMLtOXu8j4JEUKNc937DQwsEU
x63XWwFXEWl6R2GdYQ+z0Daj7BAtRofshsuua4snwEZFhogs5htiq4CDQl8S6588
Qu/zRGuizNHbZXKZ1Kg8
=oJbH
-----END PGP SIGNATURE-----

--Sig_/_xYEW=6KCZST_Ps4z+y3D02--
