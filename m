Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:45032 "EHLO bues.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731306AbeGaWEy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 18:04:54 -0400
Date: Tue, 31 Jul 2018 22:15:09 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        b43-dev <b43-dev@lists.infradead.org>,
        Joe Perches <joe@perches.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>, linux-mips@linux-mips.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org
Subject: ssb: Remove SSB_WARN_ON, SSB_BUG_ON and SSB_DEBUG
Message-ID: <20180731221509.59c0a17a@wiggum> (sfid-20180731_222255_738181_BBFC961D)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/1Z0v/bLiQd+CEt=/Kp+.vzi"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/1Z0v/bLiQd+CEt=/Kp+.vzi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Use the standard WARN_ON instead.
If a small kernel is desired, WARN_ON can be disabled globally.

Also remove SSB_DEBUG. Besides WARN_ON it only adds a tiny debug check.
Include this check unconditionally.

Signed-off-by: Michael Buesch <m@bues.ch>
---

CC-ing Mips and PPC maintainers due to changes in defconfig



 arch/mips/configs/bcm47xx_defconfig |  1 -
 arch/powerpc/configs/wii_defconfig  |  1 -
 drivers/ssb/Kconfig                 |  9 -------
 drivers/ssb/driver_chipcommon.c     |  8 +++---
 drivers/ssb/driver_chipcommon_pmu.c | 10 ++++----
 drivers/ssb/driver_gpio.c           |  4 +--
 drivers/ssb/driver_pcicore.c        |  6 ++---
 drivers/ssb/embedded.c              | 10 ++++----
 drivers/ssb/host_soc.c              | 12 ++++-----
 drivers/ssb/main.c                  | 38 +++++++++++++----------------
 drivers/ssb/pci.c                   | 19 +++++----------
 drivers/ssb/pcmcia.c                | 14 +++++------
 drivers/ssb/scan.c                  |  4 +--
 drivers/ssb/sdio.c                  | 12 ++++-----
 drivers/ssb/ssb_private.h           |  9 -------
 include/linux/ssb/ssb.h             |  2 --
 16 files changed, 63 insertions(+), 96 deletions(-)

diff --git a/arch/mips/configs/bcm47xx_defconfig b/arch/mips/configs/bcm47x=
x_defconfig
index fad8e964f14c..ba800a892384 100644
--- a/arch/mips/configs/bcm47xx_defconfig
+++ b/arch/mips/configs/bcm47xx_defconfig
@@ -66,7 +66,6 @@ CONFIG_HW_RANDOM=3Dy
 CONFIG_GPIO_SYSFS=3Dy
 CONFIG_WATCHDOG=3Dy
 CONFIG_BCM47XX_WDT=3Dy
-CONFIG_SSB_DEBUG=3Dy
 CONFIG_SSB_DRIVER_GIGE=3Dy
 CONFIG_BCMA_DRIVER_GMAC_CMN=3Dy
 CONFIG_USB=3Dy
diff --git a/arch/powerpc/configs/wii_defconfig b/arch/powerpc/configs/wii_=
defconfig
index 10940533da71..f5c366b02828 100644
--- a/arch/powerpc/configs/wii_defconfig
+++ b/arch/powerpc/configs/wii_defconfig
@@ -78,7 +78,6 @@ CONFIG_GPIO_HLWD=3Dy
 CONFIG_POWER_RESET=3Dy
 CONFIG_POWER_RESET_GPIO=3Dy
 # CONFIG_HWMON is not set
-CONFIG_SSB_DEBUG=3Dy
 CONFIG_FB=3Dy
 # CONFIG_VGA_CONSOLE is not set
 CONFIG_FRAMEBUFFER_CONSOLE=3Dy
diff --git a/drivers/ssb/Kconfig b/drivers/ssb/Kconfig
index 6c438c819eb9..df30e1323252 100644
--- a/drivers/ssb/Kconfig
+++ b/drivers/ssb/Kconfig
@@ -89,15 +89,6 @@ config SSB_HOST_SOC
=20
 	  If unsure, say N
=20
-config SSB_DEBUG
-	bool "SSB debugging"
-	depends on SSB
-	help
-	  This turns on additional runtime checks and debugging
-	  messages. Turn this on for SSB troubleshooting.
-
-	  If unsure, say N
-
 config SSB_SERIAL
 	bool
 	depends on SSB
diff --git a/drivers/ssb/driver_chipcommon.c b/drivers/ssb/driver_chipcommo=
n.c
index 48050c6fd847..99a4656d113d 100644
--- a/drivers/ssb/driver_chipcommon.c
+++ b/drivers/ssb/driver_chipcommon.c
@@ -56,7 +56,7 @@ void ssb_chipco_set_clockmode(struct ssb_chipcommon *cc,
=20
 	if (cc->capabilities & SSB_CHIPCO_CAP_PMU)
 		return; /* PMU controls clockmode, separated function needed */
-	SSB_WARN_ON(ccdev->id.revision >=3D 20);
+	WARN_ON(ccdev->id.revision >=3D 20);
=20
 	/* chipcommon cores prior to rev6 don't support dynamic clock control */
 	if (ccdev->id.revision < 6)
@@ -111,7 +111,7 @@ void ssb_chipco_set_clockmode(struct ssb_chipcommon *cc,
 		}
 		break;
 	default:
-		SSB_WARN_ON(1);
+		WARN_ON(1);
 	}
 }
=20
@@ -164,7 +164,7 @@ static int chipco_pctl_clockfreqlimit(struct ssb_chipco=
mmon *cc, int get_max)
 			divisor =3D 32;
 			break;
 		default:
-			SSB_WARN_ON(1);
+			WARN_ON(1);
 		}
 	} else if (cc->dev->id.revision < 10) {
 		switch (clocksrc) {
@@ -277,7 +277,7 @@ static void calc_fast_powerup_delay(struct ssb_chipcomm=
on *cc)
 	minfreq =3D chipco_pctl_clockfreqlimit(cc, 0);
 	pll_on_delay =3D chipco_read32(cc, SSB_CHIPCO_PLLONDELAY);
 	tmp =3D (((pll_on_delay + 2) * 1000000) + (minfreq - 1)) / minfreq;
-	SSB_WARN_ON(tmp & ~0xFFFF);
+	WARN_ON(tmp & ~0xFFFF);
=20
 	cc->fast_pwrup_delay =3D tmp;
 }
diff --git a/drivers/ssb/driver_chipcommon_pmu.c b/drivers/ssb/driver_chipc=
ommon_pmu.c
index e28682a53cdf..0f60e90ded26 100644
--- a/drivers/ssb/driver_chipcommon_pmu.c
+++ b/drivers/ssb/driver_chipcommon_pmu.c
@@ -128,7 +128,7 @@ static void ssb_pmu0_pllinit_r0(struct ssb_chipcommon *=
cc,
 			      ~(1 << SSB_PMURES_5354_BB_PLL_PU));
 		break;
 	default:
-		SSB_WARN_ON(1);
+		WARN_ON(1);
 	}
 	for (i =3D 1500; i; i--) {
 		tmp =3D chipco_read32(cc, SSB_CHIPCO_CLKCTLST);
@@ -265,7 +265,7 @@ static void ssb_pmu1_pllinit_r0(struct ssb_chipcommon *=
cc,
 		buffer_strength =3D 0x222222;
 		break;
 	default:
-		SSB_WARN_ON(1);
+		WARN_ON(1);
 	}
 	for (i =3D 1500; i; i--) {
 		tmp =3D chipco_read32(cc, SSB_CHIPCO_CLKCTLST);
@@ -501,7 +501,7 @@ static void ssb_pmu_resources_init(struct ssb_chipcommo=
n *cc)
 					      ~(depend_tab[i].depend));
 				break;
 			default:
-				SSB_WARN_ON(1);
+				WARN_ON(1);
 			}
 		}
 	}
@@ -568,12 +568,12 @@ void ssb_pmu_set_ldo_voltage(struct ssb_chipcommon *c=
c,
 			mask =3D 0x3F;
 			break;
 		default:
-			SSB_WARN_ON(1);
+			WARN_ON(1);
 			return;
 		}
 		break;
 	case 0x4312:
-		if (SSB_WARN_ON(id !=3D LDO_PAREF))
+		if (WARN_ON(id !=3D LDO_PAREF))
 			return;
 		addr =3D 0;
 		shift =3D 21;
diff --git a/drivers/ssb/driver_gpio.c b/drivers/ssb/driver_gpio.c
index 6ce4abf7d473..e809dae4c470 100644
--- a/drivers/ssb/driver_gpio.c
+++ b/drivers/ssb/driver_gpio.c
@@ -461,7 +461,7 @@ int ssb_gpio_init(struct ssb_bus *bus)
 	else if (ssb_extif_available(&bus->extif))
 		return ssb_gpio_extif_init(bus);
 	else
-		SSB_WARN_ON(1);
+		WARN_ON(1);
=20
 	return -1;
 }
@@ -473,7 +473,7 @@ int ssb_gpio_unregister(struct ssb_bus *bus)
 		gpiochip_remove(&bus->gpio);
 		return 0;
 	} else {
-		SSB_WARN_ON(1);
+		WARN_ON(1);
 	}
=20
 	return -1;
diff --git a/drivers/ssb/driver_pcicore.c b/drivers/ssb/driver_pcicore.c
index ae80b3171523..6a5622e0ded5 100644
--- a/drivers/ssb/driver_pcicore.c
+++ b/drivers/ssb/driver_pcicore.c
@@ -115,7 +115,7 @@ static int ssb_extpci_read_config(struct ssb_pcicore *p=
c,
 	u32 addr, val;
 	void __iomem *mmio;
=20
-	SSB_WARN_ON(!pc->hostmode);
+	WARN_ON(!pc->hostmode);
 	if (unlikely(len !=3D 1 && len !=3D 2 && len !=3D 4))
 		goto out;
 	addr =3D get_cfgspace_addr(pc, bus, dev, func, off);
@@ -161,7 +161,7 @@ static int ssb_extpci_write_config(struct ssb_pcicore *=
pc,
 	u32 addr, val =3D 0;
 	void __iomem *mmio;
=20
-	SSB_WARN_ON(!pc->hostmode);
+	WARN_ON(!pc->hostmode);
 	if (unlikely(len !=3D 1 && len !=3D 2 && len !=3D 4))
 		goto out;
 	addr =3D get_cfgspace_addr(pc, bus, dev, func, off);
@@ -702,7 +702,7 @@ int ssb_pcicore_dev_irqvecs_enable(struct ssb_pcicore *=
pc,
 		/* Calculate the "coremask" for the device. */
 		coremask =3D (1 << dev->core_index);
=20
-		SSB_WARN_ON(bus->bustype !=3D SSB_BUSTYPE_PCI);
+		WARN_ON(bus->bustype !=3D SSB_BUSTYPE_PCI);
 		err =3D pci_read_config_dword(bus->host_pci, SSB_PCI_IRQMASK, &tmp);
 		if (err)
 			goto out;
diff --git a/drivers/ssb/embedded.c b/drivers/ssb/embedded.c
index c39ddf8988c1..8254ed25e063 100644
--- a/drivers/ssb/embedded.c
+++ b/drivers/ssb/embedded.c
@@ -77,7 +77,7 @@ u32 ssb_gpio_in(struct ssb_bus *bus, u32 mask)
 	else if (ssb_extif_available(&bus->extif))
 		res =3D ssb_extif_gpio_in(&bus->extif, mask);
 	else
-		SSB_WARN_ON(1);
+		WARN_ON(1);
 	spin_unlock_irqrestore(&bus->gpio_lock, flags);
=20
 	return res;
@@ -95,7 +95,7 @@ u32 ssb_gpio_out(struct ssb_bus *bus, u32 mask, u32 value)
 	else if (ssb_extif_available(&bus->extif))
 		res =3D ssb_extif_gpio_out(&bus->extif, mask, value);
 	else
-		SSB_WARN_ON(1);
+		WARN_ON(1);
 	spin_unlock_irqrestore(&bus->gpio_lock, flags);
=20
 	return res;
@@ -113,7 +113,7 @@ u32 ssb_gpio_outen(struct ssb_bus *bus, u32 mask, u32 v=
alue)
 	else if (ssb_extif_available(&bus->extif))
 		res =3D ssb_extif_gpio_outen(&bus->extif, mask, value);
 	else
-		SSB_WARN_ON(1);
+		WARN_ON(1);
 	spin_unlock_irqrestore(&bus->gpio_lock, flags);
=20
 	return res;
@@ -145,7 +145,7 @@ u32 ssb_gpio_intmask(struct ssb_bus *bus, u32 mask, u32=
 value)
 	else if (ssb_extif_available(&bus->extif))
 		res =3D ssb_extif_gpio_intmask(&bus->extif, mask, value);
 	else
-		SSB_WARN_ON(1);
+		WARN_ON(1);
 	spin_unlock_irqrestore(&bus->gpio_lock, flags);
=20
 	return res;
@@ -163,7 +163,7 @@ u32 ssb_gpio_polarity(struct ssb_bus *bus, u32 mask, u3=
2 value)
 	else if (ssb_extif_available(&bus->extif))
 		res =3D ssb_extif_gpio_polarity(&bus->extif, mask, value);
 	else
-		SSB_WARN_ON(1);
+		WARN_ON(1);
 	spin_unlock_irqrestore(&bus->gpio_lock, flags);
=20
 	return res;
diff --git a/drivers/ssb/host_soc.c b/drivers/ssb/host_soc.c
index eadaedf466f6..3b438480515c 100644
--- a/drivers/ssb/host_soc.c
+++ b/drivers/ssb/host_soc.c
@@ -61,7 +61,7 @@ static void ssb_host_soc_block_read(struct ssb_device *de=
v, void *buffer,
 	case sizeof(u16): {
 		__le16 *buf =3D buffer;
=20
-		SSB_WARN_ON(count & 1);
+		WARN_ON(count & 1);
 		while (count) {
 			*buf =3D (__force __le16)__raw_readw(addr);
 			buf++;
@@ -72,7 +72,7 @@ static void ssb_host_soc_block_read(struct ssb_device *de=
v, void *buffer,
 	case sizeof(u32): {
 		__le32 *buf =3D buffer;
=20
-		SSB_WARN_ON(count & 3);
+		WARN_ON(count & 3);
 		while (count) {
 			*buf =3D (__force __le32)__raw_readl(addr);
 			buf++;
@@ -81,7 +81,7 @@ static void ssb_host_soc_block_read(struct ssb_device *de=
v, void *buffer,
 		break;
 	}
 	default:
-		SSB_WARN_ON(1);
+		WARN_ON(1);
 	}
 }
 #endif /* CONFIG_SSB_BLOCKIO */
@@ -134,7 +134,7 @@ static void ssb_host_soc_block_write(struct ssb_device =
*dev, const void *buffer,
 	case sizeof(u16): {
 		const __le16 *buf =3D buffer;
=20
-		SSB_WARN_ON(count & 1);
+		WARN_ON(count & 1);
 		while (count) {
 			__raw_writew((__force u16)(*buf), addr);
 			buf++;
@@ -145,7 +145,7 @@ static void ssb_host_soc_block_write(struct ssb_device =
*dev, const void *buffer,
 	case sizeof(u32): {
 		const __le32 *buf =3D buffer;
=20
-		SSB_WARN_ON(count & 3);
+		WARN_ON(count & 3);
 		while (count) {
 			__raw_writel((__force u32)(*buf), addr);
 			buf++;
@@ -154,7 +154,7 @@ static void ssb_host_soc_block_write(struct ssb_device =
*dev, const void *buffer,
 		break;
 	}
 	default:
-		SSB_WARN_ON(1);
+		WARN_ON(1);
 	}
 }
 #endif /* CONFIG_SSB_BLOCKIO */
diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index 9da56d2fdbd3..0a26984acb2c 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -209,7 +209,7 @@ int ssb_devices_freeze(struct ssb_bus *bus, struct ssb_=
freeze_context *ctx)
=20
 	memset(ctx, 0, sizeof(*ctx));
 	ctx->bus =3D bus;
-	SSB_WARN_ON(bus->nr_devices > ARRAY_SIZE(ctx->device_frozen));
+	WARN_ON(bus->nr_devices > ARRAY_SIZE(ctx->device_frozen));
=20
 	for (i =3D 0; i < bus->nr_devices; i++) {
 		sdev =3D ssb_device_get(&bus->devices[i]);
@@ -220,7 +220,7 @@ int ssb_devices_freeze(struct ssb_bus *bus, struct ssb_=
freeze_context *ctx)
 			continue;
 		}
 		sdrv =3D drv_to_ssb_drv(sdev->dev->driver);
-		if (SSB_WARN_ON(!sdrv->remove))
+		if (WARN_ON(!sdrv->remove))
 			continue;
 		sdrv->remove(sdev);
 		ctx->device_frozen[i] =3D 1;
@@ -248,10 +248,10 @@ int ssb_devices_thaw(struct ssb_freeze_context *ctx)
 			continue;
 		sdev =3D &bus->devices[i];
=20
-		if (SSB_WARN_ON(!sdev->dev || !sdev->dev->driver))
+		if (WARN_ON(!sdev->dev || !sdev->dev->driver))
 			continue;
 		sdrv =3D drv_to_ssb_drv(sdev->dev->driver);
-		if (SSB_WARN_ON(!sdrv || !sdrv->probe))
+		if (WARN_ON(!sdrv || !sdrv->probe))
 			continue;
=20
 		err =3D sdrv->probe(sdev, &sdev->id);
@@ -861,13 +861,13 @@ u32 ssb_calc_clock_rate(u32 plltype, u32 n, u32 m)
 	case SSB_PLLTYPE_2: /* 48Mhz, 4 dividers */
 		n1 +=3D SSB_CHIPCO_CLK_T2_BIAS;
 		n2 +=3D SSB_CHIPCO_CLK_T2_BIAS;
-		SSB_WARN_ON(!((n1 >=3D 2) && (n1 <=3D 7)));
-		SSB_WARN_ON(!((n2 >=3D 5) && (n2 <=3D 23)));
+		WARN_ON(!((n1 >=3D 2) && (n1 <=3D 7)));
+		WARN_ON(!((n2 >=3D 5) && (n2 <=3D 23)));
 		break;
 	case SSB_PLLTYPE_5: /* 25Mhz, 4 dividers */
 		return 100000000;
 	default:
-		SSB_WARN_ON(1);
+		WARN_ON(1);
 	}
=20
 	switch (plltype) {
@@ -916,9 +916,9 @@ u32 ssb_calc_clock_rate(u32 plltype, u32 n, u32 m)
 		m1 +=3D SSB_CHIPCO_CLK_T2_BIAS;
 		m2 +=3D SSB_CHIPCO_CLK_T2M2_BIAS;
 		m3 +=3D SSB_CHIPCO_CLK_T2_BIAS;
-		SSB_WARN_ON(!((m1 >=3D 2) && (m1 <=3D 7)));
-		SSB_WARN_ON(!((m2 >=3D 3) && (m2 <=3D 10)));
-		SSB_WARN_ON(!((m3 >=3D 2) && (m3 <=3D 7)));
+		WARN_ON(!((m1 >=3D 2) && (m1 <=3D 7)));
+		WARN_ON(!((m2 >=3D 3) && (m2 <=3D 10)));
+		WARN_ON(!((m3 >=3D 2) && (m3 <=3D 7)));
=20
 		if (!(mc & SSB_CHIPCO_CLK_T2MC_M1BYP))
 			clock /=3D m1;
@@ -928,7 +928,7 @@ u32 ssb_calc_clock_rate(u32 plltype, u32 n, u32 m)
 			clock /=3D m3;
 		return clock;
 	default:
-		SSB_WARN_ON(1);
+		WARN_ON(1);
 	}
 	return 0;
 }
@@ -1169,9 +1169,7 @@ int ssb_bus_may_powerdown(struct ssb_bus *bus)
 	if (err)
 		goto error;
 out:
-#ifdef CONFIG_SSB_DEBUG
 	bus->powered_up =3D 0;
-#endif
 	return err;
 error:
 	pr_err("Bus powerdown failed\n");
@@ -1188,9 +1186,7 @@ int ssb_bus_powerup(struct ssb_bus *bus, bool dynamic=
_pctl)
 	if (err)
 		goto error;
=20
-#ifdef CONFIG_SSB_DEBUG
 	bus->powered_up =3D 1;
-#endif
=20
 	mode =3D dynamic_pctl ? SSB_CLKMODE_DYNAMIC : SSB_CLKMODE_FAST;
 	ssb_chipco_set_clockmode(&bus->chipco, mode);
@@ -1242,15 +1238,15 @@ u32 ssb_admatch_base(u32 adm)
 		base =3D (adm & SSB_ADM_BASE0);
 		break;
 	case SSB_ADM_TYPE1:
-		SSB_WARN_ON(adm & SSB_ADM_NEG); /* unsupported */
+		WARN_ON(adm & SSB_ADM_NEG); /* unsupported */
 		base =3D (adm & SSB_ADM_BASE1);
 		break;
 	case SSB_ADM_TYPE2:
-		SSB_WARN_ON(adm & SSB_ADM_NEG); /* unsupported */
+		WARN_ON(adm & SSB_ADM_NEG); /* unsupported */
 		base =3D (adm & SSB_ADM_BASE2);
 		break;
 	default:
-		SSB_WARN_ON(1);
+		WARN_ON(1);
 	}
=20
 	return base;
@@ -1266,15 +1262,15 @@ u32 ssb_admatch_size(u32 adm)
 		size =3D ((adm & SSB_ADM_SZ0) >> SSB_ADM_SZ0_SHIFT);
 		break;
 	case SSB_ADM_TYPE1:
-		SSB_WARN_ON(adm & SSB_ADM_NEG); /* unsupported */
+		WARN_ON(adm & SSB_ADM_NEG); /* unsupported */
 		size =3D ((adm & SSB_ADM_SZ1) >> SSB_ADM_SZ1_SHIFT);
 		break;
 	case SSB_ADM_TYPE2:
-		SSB_WARN_ON(adm & SSB_ADM_NEG); /* unsupported */
+		WARN_ON(adm & SSB_ADM_NEG); /* unsupported */
 		size =3D ((adm & SSB_ADM_SZ2) >> SSB_ADM_SZ2_SHIFT);
 		break;
 	default:
-		SSB_WARN_ON(1);
+		WARN_ON(1);
 	}
 	size =3D (1 << (size + 1));
=20
diff --git a/drivers/ssb/pci.c b/drivers/ssb/pci.c
index ad4308529eba..84807a9b4b13 100644
--- a/drivers/ssb/pci.c
+++ b/drivers/ssb/pci.c
@@ -946,7 +946,6 @@ int ssb_pci_get_invariants(struct ssb_bus *bus,
 	return err;
 }
=20
-#ifdef CONFIG_SSB_DEBUG
 static int ssb_pci_assert_buspower(struct ssb_bus *bus)
 {
 	if (likely(bus->powered_up))
@@ -960,12 +959,6 @@ static int ssb_pci_assert_buspower(struct ssb_bus *bus)
=20
 	return -ENODEV;
 }
-#else /* DEBUG */
-static inline int ssb_pci_assert_buspower(struct ssb_bus *bus)
-{
-	return 0;
-}
-#endif /* DEBUG */
=20
 static u8 ssb_pci_read8(struct ssb_device *dev, u16 offset)
 {
@@ -1024,15 +1017,15 @@ static void ssb_pci_block_read(struct ssb_device *d=
ev, void *buffer,
 		ioread8_rep(addr, buffer, count);
 		break;
 	case sizeof(u16):
-		SSB_WARN_ON(count & 1);
+		WARN_ON(count & 1);
 		ioread16_rep(addr, buffer, count >> 1);
 		break;
 	case sizeof(u32):
-		SSB_WARN_ON(count & 3);
+		WARN_ON(count & 3);
 		ioread32_rep(addr, buffer, count >> 2);
 		break;
 	default:
-		SSB_WARN_ON(1);
+		WARN_ON(1);
 	}
=20
 	return;
@@ -1098,15 +1091,15 @@ static void ssb_pci_block_write(struct ssb_device *=
dev, const void *buffer,
 		iowrite8_rep(addr, buffer, count);
 		break;
 	case sizeof(u16):
-		SSB_WARN_ON(count & 1);
+		WARN_ON(count & 1);
 		iowrite16_rep(addr, buffer, count >> 1);
 		break;
 	case sizeof(u32):
-		SSB_WARN_ON(count & 3);
+		WARN_ON(count & 3);
 		iowrite32_rep(addr, buffer, count >> 2);
 		break;
 	default:
-		SSB_WARN_ON(1);
+		WARN_ON(1);
 	}
 }
 #endif /* CONFIG_SSB_BLOCKIO */
diff --git a/drivers/ssb/pcmcia.c b/drivers/ssb/pcmcia.c
index 20f63cc88e70..567013f8a8be 100644
--- a/drivers/ssb/pcmcia.c
+++ b/drivers/ssb/pcmcia.c
@@ -169,7 +169,7 @@ int ssb_pcmcia_switch_segment(struct ssb_bus *bus, u8 s=
eg)
 	int err;
 	u8 val;
=20
-	SSB_WARN_ON((seg !=3D 0) && (seg !=3D 1));
+	WARN_ON((seg !=3D 0) && (seg !=3D 1));
 	while (1) {
 		err =3D ssb_pcmcia_cfg_write(bus, SSB_PCMCIA_MEMSEG, seg);
 		if (err)
@@ -299,7 +299,7 @@ static void ssb_pcmcia_block_read(struct ssb_device *de=
v, void *buffer,
 	case sizeof(u16): {
 		__le16 *buf =3D buffer;
=20
-		SSB_WARN_ON(count & 1);
+		WARN_ON(count & 1);
 		while (count) {
 			*buf =3D (__force __le16)__raw_readw(addr);
 			buf++;
@@ -310,7 +310,7 @@ static void ssb_pcmcia_block_read(struct ssb_device *de=
v, void *buffer,
 	case sizeof(u32): {
 		__le16 *buf =3D buffer;
=20
-		SSB_WARN_ON(count & 3);
+		WARN_ON(count & 3);
 		while (count) {
 			*buf =3D (__force __le16)__raw_readw(addr);
 			buf++;
@@ -321,7 +321,7 @@ static void ssb_pcmcia_block_read(struct ssb_device *de=
v, void *buffer,
 		break;
 	}
 	default:
-		SSB_WARN_ON(1);
+		WARN_ON(1);
 	}
 unlock:
 	spin_unlock_irqrestore(&bus->bar_lock, flags);
@@ -399,7 +399,7 @@ static void ssb_pcmcia_block_write(struct ssb_device *d=
ev, const void *buffer,
 	case sizeof(u16): {
 		const __le16 *buf =3D buffer;
=20
-		SSB_WARN_ON(count & 1);
+		WARN_ON(count & 1);
 		while (count) {
 			__raw_writew((__force u16)(*buf), addr);
 			buf++;
@@ -410,7 +410,7 @@ static void ssb_pcmcia_block_write(struct ssb_device *d=
ev, const void *buffer,
 	case sizeof(u32): {
 		const __le16 *buf =3D buffer;
=20
-		SSB_WARN_ON(count & 3);
+		WARN_ON(count & 3);
 		while (count) {
 			__raw_writew((__force u16)(*buf), addr);
 			buf++;
@@ -421,7 +421,7 @@ static void ssb_pcmcia_block_write(struct ssb_device *d=
ev, const void *buffer,
 		break;
 	}
 	default:
-		SSB_WARN_ON(1);
+		WARN_ON(1);
 	}
 unlock:
 	mmiowb();
diff --git a/drivers/ssb/scan.c b/drivers/ssb/scan.c
index 71fbb4b3eb6a..6ceee98ed6ff 100644
--- a/drivers/ssb/scan.c
+++ b/drivers/ssb/scan.c
@@ -210,7 +210,7 @@ void ssb_iounmap(struct ssb_bus *bus)
 #ifdef CONFIG_SSB_PCIHOST
 		pci_iounmap(bus->host_pci, bus->mmio);
 #else
-		SSB_BUG_ON(1); /* Can't reach this code. */
+		WARN_ON(1); /* Can't reach this code. */
 #endif
 		break;
 	case SSB_BUSTYPE_SDIO:
@@ -236,7 +236,7 @@ static void __iomem *ssb_ioremap(struct ssb_bus *bus,
 #ifdef CONFIG_SSB_PCIHOST
 		mmio =3D pci_iomap(bus->host_pci, 0, ~0UL);
 #else
-		SSB_BUG_ON(1); /* Can't reach this code. */
+		WARN_ON(1); /* Can't reach this code. */
 #endif
 		break;
 	case SSB_BUSTYPE_SDIO:
diff --git a/drivers/ssb/sdio.c b/drivers/ssb/sdio.c
index 1aedc5fbb62f..7fe0afb42234 100644
--- a/drivers/ssb/sdio.c
+++ b/drivers/ssb/sdio.c
@@ -316,18 +316,18 @@ static void ssb_sdio_block_read(struct ssb_device *de=
v, void *buffer,
 		break;
 	}
 	case sizeof(u16): {
-		SSB_WARN_ON(count & 1);
+		WARN_ON(count & 1);
 		error =3D sdio_readsb(bus->host_sdio, buffer, offset, count);
 		break;
 	}
 	case sizeof(u32): {
-		SSB_WARN_ON(count & 3);
+		WARN_ON(count & 3);
 		offset |=3D SBSDIO_SB_ACCESS_2_4B_FLAG;	/* 32 bit data access */
 		error =3D sdio_readsb(bus->host_sdio, buffer, offset, count);
 		break;
 	}
 	default:
-		SSB_WARN_ON(1);
+		WARN_ON(1);
 	}
 	if (!error)
 		goto out;
@@ -423,18 +423,18 @@ static void ssb_sdio_block_write(struct ssb_device *d=
ev, const void *buffer,
 				     (void *)buffer, count);
 		break;
 	case sizeof(u16):
-		SSB_WARN_ON(count & 1);
+		WARN_ON(count & 1);
 		error =3D sdio_writesb(bus->host_sdio, offset,
 				     (void *)buffer, count);
 		break;
 	case sizeof(u32):
-		SSB_WARN_ON(count & 3);
+		WARN_ON(count & 3);
 		offset |=3D SBSDIO_SB_ACCESS_2_4B_FLAG;	/* 32 bit data access */
 		error =3D sdio_writesb(bus->host_sdio, offset,
 				     (void *)buffer, count);
 		break;
 	default:
-		SSB_WARN_ON(1);
+		WARN_ON(1);
 	}
 	if (!error)
 		goto out;
diff --git a/drivers/ssb/ssb_private.h b/drivers/ssb/ssb_private.h
index 885e278c4487..5f31bdfbe77f 100644
--- a/drivers/ssb/ssb_private.h
+++ b/drivers/ssb/ssb_private.h
@@ -9,15 +9,6 @@
 #include <linux/types.h>
 #include <linux/bcm47xx_wdt.h>
=20
-#ifdef CONFIG_SSB_DEBUG
-# define SSB_WARN_ON(x)		WARN_ON(x)
-# define SSB_BUG_ON(x)		BUG_ON(x)
-#else
-static inline int __ssb_do_nothing(int x) { return x; }
-# define SSB_WARN_ON(x)		__ssb_do_nothing(unlikely(!!(x)))
-# define SSB_BUG_ON(x)		__ssb_do_nothing(unlikely(!!(x)))
-#endif
-
=20
 /* pci.c */
 #ifdef CONFIG_SSB_PCIHOST
diff --git a/include/linux/ssb/ssb.h b/include/linux/ssb/ssb.h
index 3b43655cabe6..0d5a2691e7e9 100644
--- a/include/linux/ssb/ssb.h
+++ b/include/linux/ssb/ssb.h
@@ -499,11 +499,9 @@ struct ssb_bus {
=20
 	/* Internal-only stuff follows. Do not touch. */
 	struct list_head list;
-#ifdef CONFIG_SSB_DEBUG
 	/* Is the bus already powered up? */
 	bool powered_up;
 	int power_warn_count;
-#endif /* DEBUG */
 };
=20
 enum ssb_quirks {
--=20
2.18.0




--=20
Michael

--Sig_/1Z0v/bLiQd+CEt=/Kp+.vzi
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAltgw00ACgkQ9TK+HZCN
iw5OEg//U7c12X/gIT1VpEx9AlAlli68OJ3g0z9UaHXI8cQikY1YzVxFtP4ZHOXP
yoB9Rn52b3JORs57AL3eNxMfU0BhkmMvgspixjm9egvJ1XSi9Hru3Njj+DcU8oBn
xipPKNR+Movj06/fyKuTMm/FWjiHKIS7WhO0qrcrM24IulfohOL4nZI31Nqvok5p
4GS//YEVEpoc1NfATPBdqRsRdPrJr4efishZXoo6+tWjyC00V17Frd0eHynBZIdF
DSPzgjGi5Ubdggih+jdewoRB7TEW5Csb9NdXjawcdf3a4uvkeAaPpZtjjlcLdQDc
aZNcXMLqg6D+6D7Ii+xP9VLQK474g0s7ufGWcNB5l1GQbcDwJpd8wLyYqYHu/nQ7
G3Qa4Of3jayif+VrNL5rO4C7rWAF+UxcOFQRqBqYeC+vVIJzhT3imVuOFIjbxhr2
X8qxzwrPns506q1EdaOj/+9K34flmq96UQTN4TpkCEoc2DikCdcJa+Bc+Ka0Iwii
43W2a/zVAtpI5CanIYb9DziToSe79Xr3HLy1RqPSKEla7TmPkTik5jV2yvP0Qg9l
ReepcJQ4DnQO12ssgl8/Q9jhvh7yKMgKJF7fmJui4SuP+WtL39amWGyG9xsA3KM2
STuu72PeTV+//r/TfSqQrfNUCF/f8yCJ3X7NMw7J3xsPQorJE38=
=aJAx
-----END PGP SIGNATURE-----

--Sig_/1Z0v/bLiQd+CEt=/Kp+.vzi--
