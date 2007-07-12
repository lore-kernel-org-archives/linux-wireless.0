Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47307 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754506AbXGLSaA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2007 14:30:00 -0400
Date: Thu, 12 Jul 2007 11:27:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: mb@bu3sch.de
Cc: John Linville <linville@tuxdriver.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	linux-wireless@vger.kernel.org,
	Gary Zambrano <zambrano@broadcom.com>
Subject: Re: [patch 1/2] Merge the Sonics Silicon Backplane subsystem
Message-Id: <20070712112732.f7373a33.akpm@linux-foundation.org>
In-Reply-To: <20070712085744.604965000@bu3sch.de>
References: <20070712085432.528319000@bu3sch.de>
	<20070712085744.604965000@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 12 Jul 2007 10:54:33 +0200
mb@bu3sch.de wrote:

> This merges the SSB subsystem. SSB is a backplane bus subsystem needed
> for various Broadcom devices.

The patch generates 216 checkpatch warnings

> +	depends on EXPERIMENTAL
> +	help
> +	  Support for the Sonics Silicon Backplane bus
> +
> +	  The module will be called ssb
> +
> +	  If unsure, say M
> +
> +config SSB_PCIHOST
> +	bool "Support for SSB on PCI-bus host"
> +	depends on SSB && PCI
> +	default y
> +	help
> +	  Support for a Sonics Silicon Backplane on top
> +	  of a PCI device.
> +
> +	  If unsure, say Y
> +
> +config SSB_PCMCIAHOST
> +	bool "Support for SSB on PCMCIA-bus host"
> +	depends on SSB && PCMCIA
> +	help
> +	  Support for a Sonics Silicon Backplane on top
> +	  of a PCMCIA device.
> +
> +	  If unsure, say N
> +
> +config SSB_SILENT
> +	bool "No SSB kernel messages"
> +	depends on SSB
> +	help
> +	  This option turns off all Sonics Silicon Backplane printks.
> +	  Note that you won't be able to identify problems, once
> +	  messages are turned off.
> +	  This might only be desired for production kernels on
> +	  embedded devices to reduce the kernel size.

The fact that this is called "silent" rather than noisy makes me suspect
that you'd prefer that this option usually be enabled.  If so, perhaps a
`default y' is needed?

> +	  Say N
> +
> +config SSB_DEBUG
> +	bool "SSB debugging"
> +	depends on SSB && !SSB_SILENT
> +	help
> +	  This turns on additional runtime checks and debugging
> +	  messages. Turn this on for SSB troubleshooting.
> +
> +	  If unsure, say N

'default n', perhaps.

> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6/drivers/ssb/driver_chipcommon.c	2007-07-12 10:51:49.000000000 +0200
>
> ..
>
> +void ssb_chipco_set_clockmode(struct ssb_chipcommon *cc,
> +			      enum ssb_clkmode mode)
> +{
> +	struct ssb_device *ccdev = cc->dev;
> +	struct ssb_bus *bus;
> +	u32 tmp;

eek, a tmp.

> +	if (!ccdev)
> +		return;
> +	bus = ccdev->bus;
> +	/* chipcommon cores prior to rev6 don't support dynamic clock control */
> +	if (ccdev->id.revision < 6)
> +		return;
> +	/* chipcommon cores rev10 are a whole new ball game */
> +	if (ccdev->id.revision >= 10)
> +		return;
> +	if (!(cc->capabilities & SSB_CHIPCO_CAP_PCTL))
> +		return;
> +
> +	switch (mode) {
> +	case SSB_CLKMODE_SLOW:
> +		tmp = chipco_read32(cc, SSB_CHIPCO_SLOWCLKCTL);
> +		tmp |= SSB_CHIPCO_SLOWCLKCTL_FSLOW;
> +		chipco_write32(cc, SSB_CHIPCO_SLOWCLKCTL, tmp);

hm, ok, maybe the much-derided `tmp' is applicable here.

> +		break;
> +	case SSB_CLKMODE_FAST:
> +		ssb_pci_xtal(bus, SSB_GPIO_XTAL, 1); /* Force crystal on */
> +		tmp = chipco_read32(cc, SSB_CHIPCO_SLOWCLKCTL);
> +		tmp &= ~SSB_CHIPCO_SLOWCLKCTL_FSLOW;
> +		tmp |= SSB_CHIPCO_SLOWCLKCTL_IPLL;
> +		chipco_write32(cc, SSB_CHIPCO_SLOWCLKCTL, tmp);
> +		break;
> +	case SSB_CLKMODE_DYNAMIC:
> +		tmp = chipco_read32(cc, SSB_CHIPCO_SLOWCLKCTL);
> +		tmp &= ~SSB_CHIPCO_SLOWCLKCTL_FSLOW;
> +		tmp &= ~SSB_CHIPCO_SLOWCLKCTL_IPLL;
> +		tmp &= ~SSB_CHIPCO_SLOWCLKCTL_ENXTAL;
> +		if ((tmp & SSB_CHIPCO_SLOWCLKCTL_SRC) != SSB_CHIPCO_SLOWCLKCTL_SRC_XTAL)
> +			tmp |= SSB_CHIPCO_SLOWCLKCTL_ENXTAL;
> +		chipco_write32(cc, SSB_CHIPCO_SLOWCLKCTL, tmp);
> +
> +		/* for dynamic control, we have to release our xtal_pu "force on" */
> +		if (tmp & SSB_CHIPCO_SLOWCLKCTL_ENXTAL)
> +			ssb_pci_xtal(bus, SSB_GPIO_XTAL, 0);
> +		break;
> +	default:
> +		assert(0);

whaaa?  Kernel code would use BUG(), please.

> +	}
> +}
> +
> +/* Get the Slow Clock Source */
> +static int chipco_pctl_get_slowclksrc(struct ssb_chipcommon *cc)
> +{
> +	struct ssb_bus *bus = cc->dev->bus;
> +	u32 tmp = 0;

This initialisation is here only to kill a bogus gcc warning.  It should at
least have been commented to indicate this sad fact.  Better would be to
use uninitialized_var() which has the seme effect and is self-documenting,
may be centrally disabled or altered, may be grepped for, etc.


> +	if (cc->dev->id.revision < 6) {
> +		if (bus->bustype == SSB_BUSTYPE_SSB ||
> +		    bus->bustype == SSB_BUSTYPE_PCMCIA)
> +			return SSB_CHIPCO_CLKSRC_XTALOS;
> +		if (bus->bustype == SSB_BUSTYPE_PCI) {
> +			pci_read_config_dword(bus->host_pci, SSB_GPIO_OUT, &tmp);
> +			if (tmp & 0x10)
> +				return SSB_CHIPCO_CLKSRC_PCI;
> +			return SSB_CHIPCO_CLKSRC_XTALOS;
> +		}
> +	}
> +	if (cc->dev->id.revision < 10) {
> +		tmp = chipco_read32(cc, SSB_CHIPCO_SLOWCLKCTL);
> +		tmp &= 0x7;
> +		if (tmp == 0)
> +			return SSB_CHIPCO_CLKSRC_LOPWROS;
> +		if (tmp == 1)
> +			return SSB_CHIPCO_CLKSRC_XTALOS;
> +		if (tmp == 2)
> +			return SSB_CHIPCO_CLKSRC_PCI;
> +	}
> +
> +	return SSB_CHIPCO_CLKSRC_XTALOS;
> +}
>
> ...
>
> +		assert(0);

etc.

> +		limit = 0;
> +	}
> +	limit /= divisor;
> +
> +	return limit;
> +}
>
> ...
>
> +static void calc_fast_powerup_delay(struct ssb_chipcommon *cc)
> +{
> +	struct ssb_bus *bus = cc->dev->bus;
> +	int minfreq;
> +	unsigned int tmp;
> +	u32 pll_on_delay;
> +
> +	if (bus->bustype != SSB_BUSTYPE_PCI)
> +		return;
> +	if (!(cc->capabilities & SSB_CHIPCO_CAP_PCTL))
> +		return;
> +
> +	minfreq = chipco_pctl_clockfreqlimit(cc, 0);
> +	pll_on_delay = chipco_read32(cc, SSB_CHIPCO_PLLONDELAY);
> +	tmp = (((pll_on_delay + 2) * 1000000) + (minfreq - 1)) / minfreq;
> +	assert((tmp & ~0xFFFF) == 0);
> +
> +	cc->fast_pwrup_delay = tmp;
> +}
> +
> +void ssb_chipcommon_init(struct ssb_chipcommon *cc)
> +{
> +	if (!cc->dev)
> +		return; /* We don't have a ChipCommon */
> +	chipco_powercontrol_init(cc);
> +	ssb_chipco_set_clockmode(cc, SSB_CLKMODE_FAST);
> +	calc_fast_powerup_delay(cc);
> +}
> +
> +void ssb_chipco_suspend(struct ssb_chipcommon *cc, pm_message_t state)
> +{
> +	if (!cc->dev)
> +		return;
> +	ssb_chipco_set_clockmode(cc, SSB_CLKMODE_SLOW);
> +}

Should this stuff be inside #ifdef CONFIG_PM?

> +void ssb_chipco_resume(struct ssb_chipcommon *cc)
> +{
> +	if (!cc->dev)
> +		return;
> +	chipco_powercontrol_init(cc);
> +	ssb_chipco_set_clockmode(cc, SSB_CLKMODE_FAST);
> +}
> +
> 
> ...
>
> +#endif /* CONFIG_SSB_SERIAL */
> Index: linux-2.6/drivers/ssb/driver_mipscore.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6/drivers/ssb/driver_mipscore.c	2007-07-12 10:51:49.000000000 +0200
> @@ -0,0 +1,258 @@
> +/*
> + * Sonics Silicon Backplane
> + * Broadcom MIPS core driver
> + *
> + * Copyright 2005, Broadcom Corporation
> + * Copyright 2006, 2007, Michael Buesch <mb@bu3sch.de>
> + *
> + * Licensed under the GNU/GPL. See COPYING for details.
> + */
> +
> +#include <linux/ssb/ssb.h>
> +
> +#include <linux/serial.h>
> +#include <linux/serial_core.h>
> +#include <linux/serial_reg.h>
> +#include <asm/time.h>
> +
> +#include "ssb_private.h"
> +
> +
> +static inline u32 mips_read32(struct ssb_mipscore *mcore,
> +			      u16 offset)
> +{
> +	return ssb_read32(mcore->dev, offset);
> +}

hm, this doesn't seem like a well-chosen name for a driver-private function.

I guess it's OK given that it's in a .c file.

> ...
>
> +static void ssb_pcicore_init_hostmode(struct ssb_pcicore *pc)
> +{
> +	u32 val;
> +
> +	if (extpci_core) {
> +		WARN_ON(1);
> +		return;
> +	}

fyi, one could do

	if (WARN_ON(extpci_core))
		return;

here.

> +	extpci_core = pc;
> +
> +	ssb_dprintk(KERN_INFO PFX "PCIcore in host mode found\n");
> +	/* Reset devices on the external PCI bus */
> +	val = SSB_PCICORE_CTL_RST_OE;
> +	val |= SSB_PCICORE_CTL_CLK_OE;
> +	pcicore_write32(pc, SSB_PCICORE_CTL, val);
> +	val |= SSB_PCICORE_CTL_CLK; /* Clock on */
> +	pcicore_write32(pc, SSB_PCICORE_CTL, val);
> +	udelay(150);
> +	val |= SSB_PCICORE_CTL_RST; /* Deassert RST# */
> +	pcicore_write32(pc, SSB_PCICORE_CTL, val);
> +	udelay(1);
> +
> +	//TODO cardbus mode
> +
> +	/* 64MB I/O window */
> +	pcicore_write32(pc, SSB_PCICORE_SBTOPCI0,
> +			SSB_PCICORE_SBTOPCI_IO);
> +	/* 64MB config space */
> +	pcicore_write32(pc, SSB_PCICORE_SBTOPCI1,
> +			SSB_PCICORE_SBTOPCI_CFG0);
> +	/* 1GB memory window */
> +	pcicore_write32(pc, SSB_PCICORE_SBTOPCI2,
> +			SSB_PCICORE_SBTOPCI_MEM | SSB_PCI_DMA);
> +
> +	/* Enable PCI bridge BAR0 prefetch and burst */
> +	val = PCI_COMMAND_MASTER | PCI_COMMAND_MEMORY;
> +	ssb_extpci_write_config(pc, 0, 0, 0, PCI_COMMAND, &val, 2);
> +	/* Clear error conditions */
> +	val = 0;
> +	ssb_extpci_write_config(pc, 0, 0, 0, PCI_STATUS, &val, 2);
> +
> +	/* Enable PCI interrupts */
> +	pcicore_write32(pc, SSB_PCICORE_IMASK,
> +			SSB_PCICORE_IMASK_INTA);
> +
> +	/* Ok, ready to run, register it to the system.
> +	 * The following needs change, if we want to port hostmode
> +	 * to non-MIPS platform. */
> +	set_io_port_base((unsigned long)ioremap_nocache(SSB_PCI_MEM, 0x04000000));
> +	register_pci_controller(&ssb_pcicore_controller);
> +}
> +
> +static int pcicore_is_in_hostmode(struct ssb_pcicore *pc)
> +{
> +	struct ssb_bus *bus = pc->dev->bus;
> +	u16 chipid_top;
> +	u32 tmp;
> +
> +	chipid_top = (bus->chip_id & 0xFF00);
> +	if (chipid_top != 0x4700 &&
> +	    chipid_top != 0x5300)
> +		return 0;
> +
> +	if (bus->sprom.r1.boardflags_lo & SSB_PCICORE_BFL_NOPCI)
> +		return 0;
> +
> +	/* The 200-pin BCM4712 package does not bond out PCI. Even when
> +	 * PCI is bonded out, some boards may leave the pins floating. */
> +	if (bus->chip_id == 0x4712) {
> +		if (bus->chip_package == SSB_CHIPPACK_BCM4712S)
> +			return 0;
> +		if (bus->chip_package == SSB_CHIPPACK_BCM4712M)
> +			return 0;
> +	}
> +	if (bus->chip_id == 0x5350)
> +		return 0;
> +
> +	return !mips_busprobe(tmp, (u32 *) (bus->mmio + (pc->dev->core_index * SSB_CORE_SIZE)));
> +}

What's the situation with 64-bit stuff here?

> +	assert(dev);

BUG_ON, please.

> +int ssb_pcicore_dev_irqvecs_enable(struct ssb_pcicore *pc,
> +				   struct ssb_device *dev)
> +{
> +	struct ssb_device *pdev = pc->dev;
> +	struct ssb_bus *bus;
> +	int err = 0;
> +	u32 tmp;
> +
> +	might_sleep();

If you say so.  It doesn't _look_ like it sleeps?

> +	if (!pdev)
> +		goto out;
> +	bus = pdev->bus;
> +
> +	/* Enable interrupts for this device. */
> +	if (bus->host_pci &&
> +	    ((pdev->id.revision >= 6) || (pdev->id.coreid == SSB_DEV_PCIE))) {
> +		u32 coremask;
> +
> +		/* Calculate the "coremask" for the device. */
> +		coremask = (1 << dev->core_index);
> +
> +		err = pci_read_config_dword(bus->host_pci, SSB_PCI_IRQMASK, &tmp);
> +		if (err)
> +			goto out;
> +		tmp |= coremask << 8;
> +		err = pci_write_config_dword(bus->host_pci, SSB_PCI_IRQMASK, tmp);
> +		if (err)
> +			goto out;
> +	} else {
> +		u32 intvec;
> +
> +		intvec = ssb_read32(pdev, SSB_INTVEC);
> +		tmp = ssb_read32(dev, SSB_TPSFLAG);
> +		tmp &= SSB_TPSFLAG_BPFLAG;
> +		intvec |= tmp;
> +		ssb_write32(pdev, SSB_INTVEC, intvec);
> +	}
> +
> +	/* Setup PCIcore operation. */
> +	if (pc->setup_done)
> +		goto out;
> +	if (pdev->id.coreid == SSB_DEV_PCI) {
> +		tmp = pcicore_read32(pc, SSB_PCICORE_SBTOPCI2);
> +		tmp |= SSB_PCICORE_SBTOPCI_PREF;
> +		tmp |= SSB_PCICORE_SBTOPCI_BURST;
> +		pcicore_write32(pc, SSB_PCICORE_SBTOPCI2, tmp);
> +
> +		if (pdev->id.revision < 5) {
> +			tmp = ssb_read32(pdev, SSB_IMCFGLO);
> +			tmp &= ~SSB_IMCFGLO_SERTO;
> +			tmp |= 2;
> +			tmp &= ~SSB_IMCFGLO_REQTO;
> +			tmp |= 3 << SSB_IMCFGLO_REQTO_SHIFT;
> +			ssb_write32(pdev, SSB_IMCFGLO, tmp);
> +			ssb_commit_settings(bus);
> +		} else if (pdev->id.revision >= 11) {
> +			tmp = pcicore_read32(pc, SSB_PCICORE_SBTOPCI2);
> +			tmp |= SSB_PCICORE_SBTOPCI_MRM;
> +			pcicore_write32(pc, SSB_PCICORE_SBTOPCI2, tmp);
> +		}
> +	} else {
> +		assert(pdev->id.coreid == SSB_DEV_PCIE);
> +		//TODO: Better make defines for all these magic PCIE values.
> +		if ((pdev->id.revision == 0) || (pdev->id.revision == 1)) {
> +			/* TLP Workaround register. */
> +			tmp = ssb_pcie_read(pc, 0x4);
> +			tmp |= 0x8;
> +			ssb_pcie_write(pc, 0x4, tmp);
> +		}
> +		if (pdev->id.revision == 0) {
> +			const u8 serdes_rx_device = 0x1F;
> +
> +			ssb_pcie_mdio_write(pc, serdes_rx_device,
> +					    2 /* Timer */, 0x8128);
> +			ssb_pcie_mdio_write(pc, serdes_rx_device,
> +					    6 /* CDR */, 0x0100);
> +			ssb_pcie_mdio_write(pc, serdes_rx_device,
> +					    7 /* CDR BW */, 0x1466);
> +		} else if (pdev->id.revision == 1) {
> +			/* DLLP Link Control register. */
> +			tmp = ssb_pcie_read(pc, 0x100);
> +			tmp |= 0x40;
> +			ssb_pcie_write(pc, 0x100, tmp);
> +		}
> +	}
> +	pc->setup_done = 1;
> +out:
> +	return err;
> +}
>
> ...
>
> +
> +#include "ssb_private.h"
> +
> +#include <linux/delay.h>
> +#include <linux/ssb/ssb.h>
> +#include <linux/ssb/ssb_regs.h>
> +
> +#ifdef CONFIG_SSB_PCIHOST
> +# include <linux/pci.h>
> +#endif

This ifdef guard is probably a bad idea.  pci.h should be OK with or
without CONFIG_SSB_PCIHOST and making the inclusion conditional serves to
add more combinations which can cause compile failures.

> +#ifdef CONFIG_SSB_PCMCIAHOST
> +# include <pcmcia/cs_types.h>
> +# include <pcmcia/cs.h>
> +# include <pcmcia/cistpl.h>
> +# include <pcmcia/ds.h>
> +#endif

Maybe here too.

> +static int ssb_device_resume(struct device *dev)
> +{
> +	struct ssb_device *ssb_dev = dev_to_ssb_dev(dev);
> +	struct ssb_driver *ssb_drv;
> +	struct ssb_bus *bus;
> +	int err = 0;
> +
> +	bus = ssb_dev->bus;
> +	if (bus->suspend_cnt == bus->nr_devices) {
> +		err = ssb_bus_resume(bus);
> +		if (err)
> +			return err;
> +	}
> +	bus->suspend_cnt--;
> +	if (dev->driver) {
> +		ssb_drv = drv_to_ssb_drv(dev->driver);
> +		if (ssb_drv && ssb_drv->resume)
> +			err = ssb_drv->resume(ssb_dev);
> +		if (err)
> +			goto out;
> +	}
> +out:
> +	return err;
> +}
> +
> +static void ssb_bus_suspend(struct ssb_bus *bus, pm_message_t state)
> +{
> +	ssb_chipco_suspend(&bus->chipco, state);
> +	ssb_pci_xtal(bus, SSB_GPIO_XTAL | SSB_GPIO_PLL, 0);
> +
> +	/* Reset HW state information in memory, so that HW is
> +	 * completely reinitialized on resume. */
> +	bus->mapped_device = NULL;
> +#ifdef CONFIG_SSB_DRIVER_PCICORE
> +	bus->pcicore.setup_done = 0;
> +#endif
> +}

No #ifdef CONFIG_PMs here?

>
> ...
>
> +#define is_early_boot()		(ssb_bustype.name == NULL)
> +
> +static void ssb_buses_lock(void)
> +{
> +	if (!is_early_boot())
> +		mutex_lock(&buses_mutex);
> +}
> +
> +static void ssb_buses_unlock(void)
> +{
> +	if (!is_early_boot())
> +		mutex_unlock(&buses_mutex);
> +}

The is_early_boot() stuff looks hacky.  It surely needs a comment to
explain to the reader what is going on.  Because it is *very* hard to work
out what this is here for otherwise.

> +static int ssb_fetch_invariants(struct ssb_bus *bus,
> +				int (*get_invariants)(struct ssb_bus *bus,
> +						      struct ssb_init_invariants *iv))

fyi, this declaration-of-a-pointer-to-a-function thing is the one place
where kernel code _will_ define a typedef merely to save typing.

> +{
> +	struct ssb_init_invariants iv;
> +	int err;
> +
> +	memset(&iv, 0, sizeof(iv));
> +	err = get_invariants(bus, &iv);
> +	if (err)
> +		goto out;
> +	memcpy(&bus->boardinfo, &iv.boardinfo, sizeof(iv.boardinfo));
> +	memcpy(&bus->sprom, &iv.sprom, sizeof(iv.sprom));
> +out:
> +	return err;
> +}
> +
>
> ...
>
> +
> +static inline u8 ssb_crc8(u8 crc, u8 data)
> +{
> +	/* Polynomial:   x^8 + x^7 + x^6 + x^4 + x^2 + 1   */
> +	static const u8 t[] = {
> +		0x00, 0xF7, 0xB9, 0x4E, 0x25, 0xD2, 0x9C, 0x6B,
> +		0x4A, 0xBD, 0xF3, 0x04, 0x6F, 0x98, 0xD6, 0x21,
> +		0x94, 0x63, 0x2D, 0xDA, 0xB1, 0x46, 0x08, 0xFF,
> +		0xDE, 0x29, 0x67, 0x90, 0xFB, 0x0C, 0x42, 0xB5,
> +		0x7F, 0x88, 0xC6, 0x31, 0x5A, 0xAD, 0xE3, 0x14,
> +		0x35, 0xC2, 0x8C, 0x7B, 0x10, 0xE7, 0xA9, 0x5E,
> +		0xEB, 0x1C, 0x52, 0xA5, 0xCE, 0x39, 0x77, 0x80,
> +		0xA1, 0x56, 0x18, 0xEF, 0x84, 0x73, 0x3D, 0xCA,
> +		0xFE, 0x09, 0x47, 0xB0, 0xDB, 0x2C, 0x62, 0x95,
> +		0xB4, 0x43, 0x0D, 0xFA, 0x91, 0x66, 0x28, 0xDF,
> +		0x6A, 0x9D, 0xD3, 0x24, 0x4F, 0xB8, 0xF6, 0x01,
> +		0x20, 0xD7, 0x99, 0x6E, 0x05, 0xF2, 0xBC, 0x4B,
> +		0x81, 0x76, 0x38, 0xCF, 0xA4, 0x53, 0x1D, 0xEA,
> +		0xCB, 0x3C, 0x72, 0x85, 0xEE, 0x19, 0x57, 0xA0,
> +		0x15, 0xE2, 0xAC, 0x5B, 0x30, 0xC7, 0x89, 0x7E,
> +		0x5F, 0xA8, 0xE6, 0x11, 0x7A, 0x8D, 0xC3, 0x34,
> +		0xAB, 0x5C, 0x12, 0xE5, 0x8E, 0x79, 0x37, 0xC0,
> +		0xE1, 0x16, 0x58, 0xAF, 0xC4, 0x33, 0x7D, 0x8A,
> +		0x3F, 0xC8, 0x86, 0x71, 0x1A, 0xED, 0xA3, 0x54,
> +		0x75, 0x82, 0xCC, 0x3B, 0x50, 0xA7, 0xE9, 0x1E,
> +		0xD4, 0x23, 0x6D, 0x9A, 0xF1, 0x06, 0x48, 0xBF,
> +		0x9E, 0x69, 0x27, 0xD0, 0xBB, 0x4C, 0x02, 0xF5,
> +		0x40, 0xB7, 0xF9, 0x0E, 0x65, 0x92, 0xDC, 0x2B,
> +		0x0A, 0xFD, 0xB3, 0x44, 0x2F, 0xD8, 0x96, 0x61,
> +		0x55, 0xA2, 0xEC, 0x1B, 0x70, 0x87, 0xC9, 0x3E,
> +		0x1F, 0xE8, 0xA6, 0x51, 0x3A, 0xCD, 0x83, 0x74,
> +		0xC1, 0x36, 0x78, 0x8F, 0xE4, 0x13, 0x5D, 0xAA,
> +		0x8B, 0x7C, 0x32, 0xC5, 0xAE, 0x59, 0x17, 0xE0,
> +		0x2A, 0xDD, 0x93, 0x64, 0x0F, 0xF8, 0xB6, 0x41,
> +		0x60, 0x97, 0xD9, 0x2E, 0x45, 0xB2, 0xFC, 0x0B,
> +		0xBE, 0x49, 0x07, 0xF0, 0x9B, 0x6C, 0x22, 0xD5,
> +		0xF4, 0x03, 0x4D, 0xBA, 0xD1, 0x26, 0x68, 0x9F,
> +	};
> +	return t[crc ^ data];
> +}

hm, the static-table-in-an-inline is a bit funny-looking.  One assumes that
gcc has the brains to not generate two copies of the table.

Is this crc function so specific to ssb that a move to lib/crc<something>.c
is inappropriate?

> +static inline int do_select_core(struct ssb_bus *bus,
> +				 struct ssb_device *dev,
> +				 u16 *offset)
> +{
> +	int err;
> +	u8 need_seg = (*offset >= 0x800) ? 1 : 0;
> +
> +	if (unlikely(dev != bus->mapped_device)) {
> +		err = ssb_pcmcia_switch_core(bus, dev);
> +		if (unlikely(err))
> +			return err;
> +	}
> +	if (unlikely(need_seg != bus->mapped_pcmcia_seg)) {
> +		err = ssb_pcmcia_switch_segment(bus, need_seg);
> +		if (unlikely(err))
> +			return err;
> +	}
> +	if (need_seg == 1)
> +		*offset -= 0x800;
> +
> +	return 0;
> +}

This should be uninlined.

> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6/drivers/ssb/ssb_private.h	2007-07-12 10:51:49.000000000 +0200
> @@ -0,0 +1,137 @@
> +#ifndef LINUX_SSB_PRIVATE_H_
> +#define LINUX_SSB_PRIVATE_H_
> +
> +#include <linux/ssb/ssb.h>
> +#include <linux/types.h>
> +#include <asm/io.h>
> +
> +
> +#define PFX	"ssb: "
> +
> +#ifdef CONFIG_SSB_SILENT
> +# define ssb_printk(fmt, x...)	do { /* nothing */ } while (0)
> +#else
> +# define ssb_printk		printk
> +#endif /* CONFIG_SSB_SILENT */
> +
> +/* dprintk: Debugging printk; vanishes for non-debug compilation */
> +#ifdef CONFIG_SSB_DEBUG
> +# define ssb_dprintk(fmt, x...)	ssb_printk(fmt ,##x)
> +#else
> +# define ssb_dprintk(fmt, x...)	do { /* nothing */ } while (0)
> +#endif
> +
> +/* printkl: Rate limited printk */
> +#define ssb_printkl(fmt, x...)	do {		\
> +	if (printk_ratelimit())			\
> +		ssb_printk(fmt ,##x);		\
> +				} while (0)
> +
> +/* dprintkl: Rate limited debugging printk */
> +#ifdef CONFIG_SSB_DEBUG
> +# define ssb_dprintkl			ssb_printkl
> +#else
> +# define ssb_dprintkl(fmt, x...)	do { /* nothing */ } while (0)
> +#endif

It continues to drive me wild how every driver has to go and implement its
own debug infrastructure.

> +#define assert(cond)	do {						\
> +	if (unlikely(!(cond))) {					\
> +		ssb_dprintk(KERN_ERR PFX "BUG: Assertion failed (%s) "	\
> +			    "at: %s:%d:%s()\n",				\
> +			    #cond, __FILE__, __LINE__, __func__);	\
> +	}								\
> +		       } while (0)

Odd.  One would normally expect an assert() to terminate execution in some
fashion if it fails.  In-kernel that means BUG.  But this assert() just
whines and continues.

So this guy should be renamed.  ssb_check_true() or someething like that.

> +#ifdef CONFIG_SSB_PCIHOST
> +extern int ssb_devices_freeze(struct ssb_bus *bus);
> +extern int ssb_devices_thaw(struct ssb_bus *bus);
> +extern struct ssb_bus * ssb_pci_dev_to_bus(struct pci_dev *pdev);
> +#endif /* CONFIG_SSB_PCIHOST */

Often we don't bother putting the ifdef guards around declarations like
this.  If you remove them and later make a mistake, you'll find out at
link-time rather than compile-time, which is a loss.  But the gain is
nicer-looking code, and code gets read 10000 times more often than it gets
written.

> +
> +#endif /* LINUX_SSB_PRIVATE_H_ */
> Index: linux-2.6/include/linux/ssb/ssb.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6/include/linux/ssb/ssb.h	2007-07-12 10:51:49.000000000 +0200
> @@ -0,0 +1,422 @@
> +#ifndef LINUX_SSB_H_
> +#define LINUX_SSB_H_
> +#ifdef __KERNEL__

This header file is exported to userspace?  But I see no update to
include/linux/ssb/Kconfig.  Does it all pass `make headers_check'?  Does
`make headers_install' work correctly?

> +#include <linux/device.h>
> +#include <linux/list.h>
> +#include <linux/types.h>
> +#include <linux/spinlock.h>
> +#ifdef CONFIG_SSB_PCIHOST
> +# include <linux/pci.h>
> +#endif

might-be-unneeded ifdefs

> +	/* Lock for core and segment switching. */
> +	spinlock_t bar_lock;
> +
> +	/* The bus this backplane is running on. */
> +	enum ssb_bustype bustype;
> +	/* Pointer to the PCI bus (only valid if bustype == SSB_BUSTYPE_PCI). */
> +	struct pci_dev *host_pci;
> +	/* Pointer to the PCMCIA device (only if bustype == SSB_BUSTYPE_PCMCIA). */
> +	struct pcmcia_device *host_pcmcia;
> +
> +#ifdef CONFIG_SSB_PCIHOST
> +	struct mutex pci_sprom_mutex;
> +#endif
> +
> +	/* ID information about the Chip. */
> +	u16 chip_id;
> +	u16 chip_rev;
> +	u8 chip_package;
> +
> +	/* List of devices (cores) on the backplane. */
> +	struct ssb_device devices[SSB_MAX_NR_CORES];
> +	u8 nr_devices;
> +
> +	/* Reference count. Number of suspended devices. */
> +	u8 suspend_cnt;
> +
> +	/* Software ID number for this bus. */
> +	unsigned int busnumber;
> +
> +	/* The ChipCommon device (if available). */
> +	struct ssb_chipcommon chipco;
> +	/* The PCI-core device (if available). */
> +	struct ssb_pcicore pcicore;
> +	/* The MIPS-core device (if available). */
> +	struct ssb_mipscore mipscore;
> +	/* The EXTif-core device (if available). */
> +	struct ssb_extif extif;
> +
> +	/* The following structure elements are not available in early
> +	 * SSB initialization. Though, they are available for regular
> +	 * registered drivers at any stage. So be careful when
> +	 * using them in the ssb core code. */
> +
> +	/* ID information about the PCB. */
> +	struct ssb_boardinfo boardinfo;
> +	/* Contents of the SPROM. */
> +	struct ssb_sprom sprom;
> +
> +	/* Internal. */
> +	struct list_head list;
> +};

Those are useful comments.

> +#endif /* __KERNEL__ */
> +#endif /* LINUX_SSB_H_ */

OK, it wasn't exported to userspace.  Maybe the #ifdef __KERNEL__ wasn't
needed at all?



Overall: nice-looking and (modulo the above comments) quite idiomatic
kernel code.  But the low level of commenting would make it pretty tough
for anyone else to do significant maintenance work against it, I expect. 
This is also a kernel idiom :(
