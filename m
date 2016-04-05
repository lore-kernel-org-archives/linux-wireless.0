Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:51532 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752112AbcDETuT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 15:50:19 -0400
Date: Tue, 5 Apr 2016 21:49:45 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Lukas Wunner <lukas@wunner.de>, linux-pci@vger.kernel.org,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] PCI: Add Broadcom 4331 reset quirk to prevent IRQ storm
Message-ID: <20160405214945.1214e13b@wiggum> (sfid-20160405_215021_555508_9F97F1DC)
In-Reply-To: <20160405194015.GC15353@localhost>
References: <811539524df8b5ed7e2817c1c3e3e08560c97964.1459275517.git.lukas@wunner.de>
	<20160405194015.GC15353@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/fO4VeQPYDcfvPGNxmbx=/bP"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/fO4VeQPYDcfvPGNxmbx=/bP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 5 Apr 2016 14:40:15 -0500
Bjorn Helgaas <helgaas@kernel.org> wrote:

> [+cc Matthew]
>=20
> Hi Lukas,
>=20
> On Tue, Mar 29, 2016 at 08:20:30PM +0200, Lukas Wunner wrote:
> > Broadcom 4331 wireless cards built into Apple Macs unleash an IRQ storm
> > on boot until they are reset, causing spurious interrupts if the IRQ is
> > shared. Apparently the EFI bootloader enables the device and does not
> > disable it before passing control to the OS. The bootloader contains a
> > driver for the wireless card which allows it to phone home to Cupertino.
> > This is used for Internet Recovery (download and install OS X images)
> > and probably also for Back to My Mac (remote access, RFC 6281) and to
> > discover stolen hardware.
> >=20
> > The issue is most pronounced on 2011 and 2012 MacBook Pros where the IRQ
> > is shared with 3 other devices (Light Ridge Thunderbolt controller, SDXC
> > reader, HDA card on discrete GPU). As soon as an interrupt handler is
> > installed for one of these devices, the ensuing storm of spurious IRQs
> > causes the kernel to disable the IRQ and switch to polling. This lasts
> > until the b43 driver loads and resets the device.
> >=20
> > Loading the b43 driver first is not always an option, in particular with
> > the Light Ridge Thunderbolt controller: The PCI hotplug IRQ handler gets
> > installed early on because it is built in, unlike b43 which is usually
> > a module.
> >=20
> > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=3D79301
> > Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=3D895951
> > Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=3D1009819
> > Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=3D1149632
> > Tested-by: Lukas Wunner <lukas@wunner.de> [MacBookPro9,1]
> > Signed-off-by: Lukas Wunner <lukas@wunner.de>
> > ---
> >  drivers/bcma/bcma_private.h |  2 --
> >  drivers/pci/quirks.c        | 27 +++++++++++++++++++++++++++
> >  include/linux/bcma/bcma.h   |  1 +
> >  3 files changed, 28 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
> > index eda0909..f642c42 100644
> > --- a/drivers/bcma/bcma_private.h
> > +++ b/drivers/bcma/bcma_private.h
> > @@ -8,8 +8,6 @@
> >  #include <linux/bcma/bcma.h>
> >  #include <linux/delay.h>
> > =20
> > -#define BCMA_CORE_SIZE		0x1000
> > -
> >  #define bcma_err(bus, fmt, ...) \
> >  	pr_err("bus%d: " fmt, (bus)->num, ##__VA_ARGS__)
> >  #define bcma_warn(bus, fmt, ...) \
> > diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> > index 8e67802..d4fb5ee 100644
> > --- a/drivers/pci/quirks.c
> > +++ b/drivers/pci/quirks.c
> > @@ -25,6 +25,8 @@
> >  #include <linux/sched.h>
> >  #include <linux/ktime.h>
> >  #include <linux/mm.h>
> > +#include <linux/bcma/bcma.h>
> > +#include <linux/bcma/bcma_regs.h>
> >  #include <asm/dma.h>	/* isa_dma_bridge_buggy */
> >  #include "pci.h"
> > =20
> > @@ -3282,6 +3284,31 @@ DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_INT=
EL, 0x156d,
> >  			       quirk_apple_wait_for_thunderbolt);
> >  #endif
> > =20
> > +/*
> > + * Broadcom 4331 wireless cards built into Apple Macs unleash an IRQ s=
torm
> > + * on boot until they are reset, causing spurious interrupts if the IR=
Q is
> > + * shared. Apparently the EFI bootloader enables the device to phone h=
ome
> > + * to Cupertino and does not disable it before passing control to the =
OS.
> > + */
> > +static void quirk_apple_b43_reset(struct pci_dev *dev)
> > +{
> > +	void __iomem *mmio;
> > +
> > +	if (!dmi_match(DMI_BOARD_VENDOR, "Apple Inc.") || !dev->bus->self ||
> > +	    pci_pcie_type(dev->bus->self) !=3D PCI_EXP_TYPE_ROOT_PORT)
> > +		return;
> > +
> > +	mmio =3D pci_iomap(dev, 0, 0);
> > +	if (!mmio) {
> > +		pr_err("b43 quirk: Cannot iomap device, IRQ storm ahead\n");
> > +		return;
> > +	}
> > +	iowrite32(BCMA_RESET_CTL_RESET,
> > +		  mmio + (1 * BCMA_CORE_SIZE) + BCMA_RESET_CTL);
> > +	pci_iounmap(dev, mmio); =20
>=20
> https://bugzilla.kernel.org/show_bug.cgi?id=3D111781 and
> https://mjg59.dreamwidth.org/11235.html describe a sort of similar
> issue, but with DMA.  An interrupt from the device is probably to
> signal a DMA completion, but these problem reports only mention the
> "IRQ nobody cared" issue; I don't see anything about memory
> corruption.
>=20
> If this resets the device, I guess that should prevent future DMA as
> well as future interrupts.  Would pci_reset_function() do the same
> thing in a more generic way?
>=20
> I'm a little bit hesitant to put a quirk like this in Linux because
> it's only a 90% solution.  If the only problem is the interrupts, it's
> probably OK since a few extra interrupts doesn't hurt anything.  But
> if there is also DMA that might corrupt something, a 90% solution just
> makes it harder to debug for the remaining 10%.

This was already discussed in this thread.

It is not a 90% solution. It fixes the IRQ issue. It is not supposed to
fix the DMA issue. And it can't. It does mitigate it a tiny bit though.

--=20
Michael

--Sig_/fO4VeQPYDcfvPGNxmbx=/bP
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXBBbZAAoJEPUyvh2QjYsOBAcP/RXw9pkTKfHakA5e/bI6AqH+
+wvuQHLjG9FzHImMxYsHexuIsXytv8zatgU+lYD8DdtgdvLUm8K8mD31Y9txDrrK
jzAbLYBYnGpCvPbqKQ3OLyNeFr6cGv6cd9KdB6F6OTOhZJjPLW0HegyN8YXMAQkm
wNRbYguw/ZNh51Kv3hc3P1SVeuQSEfLBGGQNMXH9kLa/8Arx0blM9b2sbKCUztlJ
Lu6FKraXLNxQcIu9D1D42/Y6HWlGVfkW1ddorL7ta8oEI2WpUZ9UbOFAOOmL/aXY
r5TPd2NUIAM2ziEv5thcOF6TqnivmTpx16F1E1EPbs0NGNI4Kq2pVtVx5eebYEs9
INBzrBuilsIVjcKP0AvLh6ttu1Rm4yPyseS0Re2pI6TNxDtxFb06uraIThignKA0
NhVNGyIgA5QRKZ1nwR2/1IaBTZeQLah3SkrHzDjtfytc1K83KOse9bh6gpsx46qv
p/6TX62UKJX/uWoNn0UAmSEn/kk1WF2gMbNBNnTSmq5h9TJ6fPskTZMwa2myHotN
U7HAmCDTD+K4Slrhlx9LIlUGxE/6uCVUnZ5w/sLbGgFk8/SyaEOiwJAGejUFk4JN
v5Du/h63UFNmY+EtdW+q2I2liZ4hGf8dJlpXqxvAjoJXwvjQjhvHSx7cp/MrB9sK
S+01n0MLCQ9sKFfDbZNl
=Mj4p
-----END PGP SIGNATURE-----

--Sig_/fO4VeQPYDcfvPGNxmbx=/bP--
