Received: from smtpdh17-2.aruba.it (smtpdh17-2.aruba.it [62.149.155.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB0D468C23
	for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 22:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.155.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791758924; cv=none; b=Bj+lPP0Uw4Vqq+mXEopwanZmLOLaFD2vN9KbVZuDpaqRgFN3bIFn7Z3cR1+lkoEiPJ7xsNmKKWMTijLemQtniBjnC3CF4SkeT3Lc9tLiOf378NHoLwvmzbIeCXlzdsSlPeE5MlfE4oRJL9uFKHur3oIB83sQTfzY/3D/vw3LzwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791758924; c=relaxed/simple;
	bh=I9UsmOcVuO8xBW52wg/3LOUuvGjR1sfzAcNarK5MMW0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=IoRSlC2VnlM9mZ+VTdenr8ZZ63dmtO135A0tCScObZ60VhAIUNcMeCMJ7x28unpjYgxjQQA0228hiGLHd1vevrz8+9okleDB0fRV+4tr0VxXyNdVT4pNRGvZaEaIbMg58W4H1ngH9trkfcyAsuw4SWSj//sNrsbq9QxbNAH52OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it; spf=pass smtp.mailfrom=mythread.it; dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b=RVGO5X++; arc=none smtp.client-ip=62.149.155.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b="RVGO5X++"
Received: from [192.168.1.237] ([94.34.125.0])
	by Aruba SMTP with ESMTPSA
	id G2INxu7ww76R9G2IOxOszD; Mon, 12 Oct 2026 00:45:32 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1791758732; bh=I9UsmOcVuO8xBW52wg/3LOUuvGjR1sfzAcNarK5MMW0=;
	h=From:Date:Subject:MIME-Version:Content-Type:To;
	b=RVGO5X++S71hLL3VL4K1N2RZbQC7a2JSuOhEzcyPTjrSsjh/n85aiNu+6jGlnOtNk
	 B6Y9h7/wYyfNOLGA12nvANpDhDLImpDJ+Q3Y6P2zHKFSf7m810wxGbpCsnuTzbbGLZ
	 wuSH9o4QPeIfi0R3+gD/ev9qhp5SwybDEuua3jC3xue90vM5hqfD4RcQ3ru378R8J9
	 EopkLBBqeEvzSgnpXjq4/PrhHWNrytWq1XBU7pq2hcvCcSjibCJsb2zLm2SN4tfkOw
	 tVUS2E46zon8Wj1hL02JZ56BGN4rUMQBWFiXuAfJILTxdkCXa+C8r1lKR7HNomlsWD
	 Wv7MOq0BzXd+A==
From: Alessio Ferri <alessio.ferri@mythread.it>
Date: Mon, 12 Oct 2026 00:45:28 +0200
Subject: [PATCH v2 4/5] bcma: add host driver for the BCM6362 integrated
 WLAN backplane
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-bcm6362-wlan-v2-4-4752da7e0982@mythread.it>
References: <20261012-bcm6362-wlan-v2-0-4752da7e0982@mythread.it>
In-Reply-To: <20261012-bcm6362-wlan-v2-0-4752da7e0982@mythread.it>
To: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>, 
 Philipp Zabel <p.zabel@pengutronix.de>, 
 Florian Fainelli <florian.fainelli@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org, 
 Alessio Ferri <alessio.ferri@mythread.it>
X-Mailer: b4 0.14.3
X-CMAE-Envelope: MS4xfP2cNQoSpltEWhkdtWFlmY8vumarz2zBu0G4omizKhl/O1KMs3UROV8wnvfzf9jv66Hka1krNUOchSfVMILfwtz6Xyn3OtJB1FE5YrbbRlYsWbF+UDpA
 aK6Q7XygWRAnrqECHPqKuP+8DC/fVu0/qNNcxJiUhnJRs/5DHC/IlY3+qHvzhRXqLsHs4iLXSxtFxqWUxNZlW4siVByqrbo9Ta/K5KicF9ePdxd+XygdmIBg
 Ho9aP2hKw/UWbH3TgWwS8Uoo7WiNmWG8bRg94CjIvDwxJw8n5rkpdyLID7xWVssf8EmoA6ctW0GTVcHQxb4sBTx9PBoSw2b6EmSQRKNZ4LxEHmCeMMu46v49
 0UOz52wxPZ3qGZrMZo8gDH+PqqxiftVRtbx1yEXQbfFM2xxe9eD5lCxBjLO0lqVbuNsff5G9YPD8PCQKw+74pgwbLTc2BCNaDkhJN8CbRDup1S46QVgSon9y
 uWWou51+3rMjTLqi3oBuv0UctdEv3aqG9uKPLPEVW+/PNyZMZaj1/WxZWXi/7ho7PlER+kE3AYzUFsJathJK+ybAafotwJ99IbBQJwafZnnFtKWabKCkOgeI
 wBpE+zxFRnF863MiU7IPwxzsoj4d6BQLkh5fnYGC2uEez+3OneAKIqHkbxOTqzkamgA=

The BCM6362 integrates a WLAN macro on a dedicated bcma backplane.
CFE leaves the macro clock gated and in reset, the backplane is
a big-endian peripheral, and none of the cores has a wrapper:
gating and reset of ChipCommon and of the 802.11 core go through
per-core control registers in a separate WLAN control block.

Add a host driver for it that:

  - maps the ChipCommon and WLAN control register blocks;
  - enables the clock, cycles the WLAN and WLAN UBUS resets and runs the
    macro enable sequence of the vendor driver before bcma touches
    the backplane;
  - provides big-endian register and block I/O ops;
  - emulates BCMA_IOCTL, BCMA_IOST, BCMA_RESET_CTL and BCMA_RESET_ST
    on top of the per-core control registers. The PHY bits of
    BCMA_IOST report what b43 needs to hear;
  - sets the big_endian and wrapperless bus flags before scanning.

As for the PCI and generic SoC hosts, the driver is linked into
bcma.ko and registered from bcma_modinit().

Add a MAINTAINERS entry for the driver and its binding.

The 802.11 core (rev 0x16) is handled by b43 once a SPROM is
available; on this SoC it is not stored on the chip and has to be
provided. In openwrt i use 6362-sprom plus fixups.

Assisted-by: LLM sparse
Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>
---
 MAINTAINERS                     |   7 +
 drivers/bcma/Kconfig            |  12 ++
 drivers/bcma/Makefile           |   1 +
 drivers/bcma/bcma_private.h     |  15 ++
 drivers/bcma/host_soc_bcm6362.c | 418 ++++++++++++++++++++++++++++++++++++++++
 drivers/bcma/main.c             |   6 +
 6 files changed, 459 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index f53047aa8d3c..00d964829db5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5235,6 +5235,13 @@ S:	Maintained
 F:	arch/arm/boot/dts/broadcom/bcm47189*
 F:	arch/arm/boot/dts/broadcom/bcm53573*
 
+BROADCOM BCM6362 WLAN BCMA HOST DRIVER
+M:	Alessio Ferri <alessio.ferri@mythread.it>
+L:	linux-wireless@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/bus/brcm,bcm6362-wlan-bus-axi.yaml
+F:	drivers/bcma/host_soc_bcm6362.c
+
 BROADCOM BCM63XX/BCM33XX UDC DRIVER
 M:	Kevin Cernekee <cernekee@gmail.com>
 L:	linux-usb@vger.kernel.org
diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
index b9558ff20830..ef0c461bdf90 100644
--- a/drivers/bcma/Kconfig
+++ b/drivers/bcma/Kconfig
@@ -38,6 +38,18 @@ config BCMA_HOST_SOC
 
 	  If unsure, say N
 
+config BCMA_HOST_SOC_BCM6362
+	bool "Support for the BCM6362 integrated WLAN backplane"
+	depends on BMIPS_GENERIC || COMPILE_TEST
+	depends on OF
+	help
+	  Host driver for the bcma backplane of the WLAN macro
+	  integrated in the Broadcom BCM6362 SoC. It powers the macro on
+	  and lets bcma enumerate the backplane, so that the 802.11 core
+	  can be driven by b43.
+
+	  If unsure, say N
+
 config BCMA_DRIVER_PCI
 	bool "BCMA Broadcom PCI core driver"
 	depends on PCI
diff --git a/drivers/bcma/Makefile b/drivers/bcma/Makefile
index f8c37de35da2..3ff93990ecbb 100644
--- a/drivers/bcma/Makefile
+++ b/drivers/bcma/Makefile
@@ -13,6 +13,7 @@ bcma-$(CONFIG_BCMA_DRIVER_GMAC_CMN)	+= driver_gmac_cmn.o
 bcma-$(CONFIG_BCMA_DRIVER_GPIO)		+= driver_gpio.o
 bcma-$(CONFIG_BCMA_HOST_PCI)		+= host_pci.o
 bcma-$(CONFIG_BCMA_HOST_SOC)		+= host_soc.o
+bcma-$(CONFIG_BCMA_HOST_SOC_BCM6362)	+= host_soc_bcm6362.o
 obj-$(CONFIG_BCMA)			+= bcma.o
 
 ccflags-$(CONFIG_BCMA_DEBUG)		:= -DDEBUG
diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index 6eded32d1aac..931a0ca0aea3 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -118,6 +118,21 @@ static inline void __exit bcma_host_soc_unregister_driver(void)
 }
 #endif /* CONFIG_BCMA_HOST_SOC && CONFIG_OF */
 
+/* host_soc_bcm6362.c */
+#ifdef CONFIG_BCMA_HOST_SOC_BCM6362
+int __init bcma_host_soc_bcm6362_register_driver(void);
+void __exit bcma_host_soc_bcm6362_unregister_driver(void);
+#else
+static inline int __init bcma_host_soc_bcm6362_register_driver(void)
+{
+	return 0;
+}
+
+static inline void __exit bcma_host_soc_bcm6362_unregister_driver(void)
+{
+}
+#endif /* CONFIG_BCMA_HOST_SOC_BCM6362 */
+
 /* driver_pci.c */
 #ifdef CONFIG_BCMA_DRIVER_PCI
 u32 bcma_pcie_read(struct bcma_drv_pci *pc, u32 address);
diff --git a/drivers/bcma/host_soc_bcm6362.c b/drivers/bcma/host_soc_bcm6362.c
new file mode 100644
index 000000000000..524f7bddd65f
--- /dev/null
+++ b/drivers/bcma/host_soc_bcm6362.c
@@ -0,0 +1,418 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Broadcom BCM6362 integrated WLAN backplane host driver
+ *
+ * The backplane is a big-endian peripheral. Its cores have no DMP
+ * wrappers: the agent registers of ChipCommon and of the 802.11 core
+ * are emulated on top of the per-core control registers of the WLAN
+ * control block.
+ */
+
+#include <linux/bits.h>
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/reset.h>
+#include <linux/slab.h>
+
+#include <linux/bcma/bcma.h>
+
+#include "bcma_private.h"
+
+#define BCM6362_WLAN_MISC			0x00
+#define  BCM6362_WLAN_MISC_FORCE_CLK_ON		BIT(2)
+#define  BCM6362_WLAN_MISC_MACRO_DISABLE	BIT(1)
+#define  BCM6362_WLAN_MISC_MACRO_SOFT_RESET	BIT(0)
+#define BCM6362_WLAN_CC_CONTROL			0x08
+#define BCM6362_WLAN_MAC_CONTROL		0x10
+#define BCM6362_WLAN_CC_ID_A			0x18
+#define BCM6362_WLAN_MAC_ID_A			0x24
+
+/*
+ * Per-core control register layout: BCMA_IOCTL in the low 16 bits,
+ * BCMA_RESET_CTL_RESET in bit 16.
+ */
+#define BCM6362_WLAN_CTL_IOCTL			GENMASK(15, 0)
+#define BCM6362_WLAN_CTL_RESET			BIT(16)
+
+#define BCM6362_WLAN_IOST_2G_PHY		BIT(0)
+#define BCM6362_WLAN_IOST_5G_PHY		BIT(1)
+
+struct bcma_host_soc_bcm6362 {
+	struct bcma_bus		bus;
+	void __iomem		*wlan_ctrl;
+	struct clk		*clk;
+	struct reset_control	*rst_wlan;
+	struct reset_control	*rst_wlan_ubus;
+};
+
+static struct bcma_host_soc_bcm6362 *to_bcm6362(struct bcma_bus *bus)
+{
+	return container_of(bus, struct bcma_host_soc_bcm6362, bus);
+}
+
+static u8 bcma_host_soc_bcm6362_read8(struct bcma_device *core, u16 offset)
+{
+	return readb(core->io_addr + offset);
+}
+
+static u16 bcma_host_soc_bcm6362_read16(struct bcma_device *core, u16 offset)
+{
+	return ioread16be(core->io_addr + offset);
+}
+
+static u32 bcma_host_soc_bcm6362_read32(struct bcma_device *core, u16 offset)
+{
+	return ioread32be(core->io_addr + offset);
+}
+
+static void bcma_host_soc_bcm6362_write8(struct bcma_device *core, u16 offset,
+					 u8 value)
+{
+	writeb(value, core->io_addr + offset);
+}
+
+static void bcma_host_soc_bcm6362_write16(struct bcma_device *core, u16 offset,
+					  u16 value)
+{
+	iowrite16be(value, core->io_addr + offset);
+}
+
+static void bcma_host_soc_bcm6362_write32(struct bcma_device *core, u16 offset,
+					  u32 value)
+{
+	iowrite32be(value, core->io_addr + offset);
+}
+
+#ifdef CONFIG_BCMA_BLOCKIO
+/* Buffers are kept in bus byte order, so copy them without swapping. */
+static void bcma_host_soc_bcm6362_block_read(struct bcma_device *core,
+					     void *buffer, size_t count,
+					     u16 offset, u8 reg_width)
+{
+	void __iomem *addr = core->io_addr + offset;
+
+	switch (reg_width) {
+	case sizeof(u8): {
+		u8 *buf = buffer;
+
+		while (count) {
+			*buf = __raw_readb(addr);
+			buf++;
+			count--;
+		}
+		break;
+	}
+	case sizeof(u16): {
+		__be16 *buf = buffer;
+
+		WARN_ON(count & 1);
+		while (count) {
+			*buf = (__force __be16)__raw_readw(addr);
+			buf++;
+			count -= 2;
+		}
+		break;
+	}
+	case sizeof(u32): {
+		__be32 *buf = buffer;
+
+		WARN_ON(count & 3);
+		while (count) {
+			*buf = (__force __be32)__raw_readl(addr);
+			buf++;
+			count -= 4;
+		}
+		break;
+	}
+	default:
+		WARN_ON(1);
+	}
+}
+
+static void bcma_host_soc_bcm6362_block_write(struct bcma_device *core,
+					      const void *buffer, size_t count,
+					      u16 offset, u8 reg_width)
+{
+	void __iomem *addr = core->io_addr + offset;
+
+	switch (reg_width) {
+	case sizeof(u8): {
+		const u8 *buf = buffer;
+
+		while (count) {
+			__raw_writeb(*buf, addr);
+			buf++;
+			count--;
+		}
+		break;
+	}
+	case sizeof(u16): {
+		const __be16 *buf = buffer;
+
+		WARN_ON(count & 1);
+		while (count) {
+			__raw_writew((__force u16)*buf, addr);
+			buf++;
+			count -= 2;
+		}
+		break;
+	}
+	case sizeof(u32): {
+		const __be32 *buf = buffer;
+
+		WARN_ON(count & 3);
+		while (count) {
+			__raw_writel((__force u32)*buf, addr);
+			buf++;
+			count -= 4;
+		}
+		break;
+	}
+	default:
+		WARN_ON(1);
+	}
+}
+#endif /* CONFIG_BCMA_BLOCKIO */
+
+static void __iomem *bcma_host_soc_bcm6362_ctl_reg(struct bcma_device *core)
+{
+	struct bcma_host_soc_bcm6362 *host = to_bcm6362(core->bus);
+
+	switch (core->id.id) {
+	case BCMA_CORE_CHIPCOMMON:
+		return host->wlan_ctrl + BCM6362_WLAN_CC_CONTROL;
+	case BCMA_CORE_80211:
+		return host->wlan_ctrl + BCM6362_WLAN_MAC_CONTROL;
+	default:
+		return NULL;
+	}
+}
+
+static u32 bcma_host_soc_bcm6362_aread32(struct bcma_device *core, u16 offset)
+{
+	void __iomem *ctl = bcma_host_soc_bcm6362_ctl_reg(core);
+
+	switch (offset) {
+	case BCMA_IOCTL:
+		if (!ctl)
+			return BCMA_IOCTL_CLK;
+		return ioread32be(ctl) & BCM6362_WLAN_CTL_IOCTL;
+	case BCMA_IOST:
+		/*
+		 * The core bits of MacStatus do not reflect the PHY while
+		 * the 802.11 core is held in reset, so report what the
+		 * macro supports: a dual-band PHY and 64-bit DMA. The bands
+		 * actually usable depend on the board antennas.
+		 */
+		if (core->id.id == BCMA_CORE_80211)
+			return BCM6362_WLAN_IOST_2G_PHY |
+			       BCM6362_WLAN_IOST_5G_PHY | BCMA_IOST_DMA64;
+		return 0;
+	case BCMA_RESET_CTL:
+		if (ctl && (ioread32be(ctl) & BCM6362_WLAN_CTL_RESET))
+			return BCMA_RESET_CTL_RESET;
+		return 0;
+	case BCMA_RESET_ST:
+		return 0;
+	default:
+		dev_warn_once(core->bus->dev,
+			      "core 0x%03x: unhandled agent read at 0x%03x\n",
+			      core->id.id, offset);
+		return 0;
+	}
+}
+
+static void bcma_host_soc_bcm6362_awrite32(struct bcma_device *core, u16 offset,
+					   u32 value)
+{
+	void __iomem *ctl = bcma_host_soc_bcm6362_ctl_reg(core);
+	u32 val;
+
+	if (!ctl)
+		goto unhandled;
+
+	switch (offset) {
+	case BCMA_IOCTL:
+		val = ioread32be(ctl) & BCM6362_WLAN_CTL_RESET;
+		val |= value & BCM6362_WLAN_CTL_IOCTL;
+		iowrite32be(val, ctl);
+		return;
+	case BCMA_RESET_CTL:
+		val = ioread32be(ctl);
+		if (value & BCMA_RESET_CTL_RESET)
+			val |= BCM6362_WLAN_CTL_RESET;
+		else
+			val &= ~BCM6362_WLAN_CTL_RESET;
+		iowrite32be(val, ctl);
+		return;
+	}
+
+unhandled:
+	dev_warn_once(core->bus->dev,
+		      "core 0x%03x: unhandled agent write 0x%08x at 0x%03x\n",
+		      core->id.id, value, offset);
+}
+
+static const struct bcma_host_ops bcma_host_soc_bcm6362_ops = {
+	.read8		= bcma_host_soc_bcm6362_read8,
+	.read16		= bcma_host_soc_bcm6362_read16,
+	.read32		= bcma_host_soc_bcm6362_read32,
+	.write8		= bcma_host_soc_bcm6362_write8,
+	.write16	= bcma_host_soc_bcm6362_write16,
+	.write32	= bcma_host_soc_bcm6362_write32,
+#ifdef CONFIG_BCMA_BLOCKIO
+	.block_read	= bcma_host_soc_bcm6362_block_read,
+	.block_write	= bcma_host_soc_bcm6362_block_write,
+#endif
+	.aread32	= bcma_host_soc_bcm6362_aread32,
+	.awrite32	= bcma_host_soc_bcm6362_awrite32,
+};
+
+/*
+ * Macro enable sequence from the vendor driver: with the clock forced
+ * on and the macro in soft reset, enable the 802.11 core clock with
+ * force gated clock set, then release the soft reset and the forces.
+ */
+static int bcma_host_soc_bcm6362_power_on(struct bcma_host_soc_bcm6362 *host)
+{
+	void __iomem *base = host->wlan_ctrl;
+	int err;
+
+	err = clk_prepare_enable(host->clk);
+	if (err)
+		return err;
+	fsleep(10000);
+
+	reset_control_assert(host->rst_wlan_ubus);
+	reset_control_assert(host->rst_wlan);
+	fsleep(1000);
+	reset_control_deassert(host->rst_wlan_ubus);
+	reset_control_deassert(host->rst_wlan);
+	fsleep(1000);
+
+	iowrite32be(BCM6362_WLAN_MISC_FORCE_CLK_ON |
+		    BCM6362_WLAN_MISC_MACRO_SOFT_RESET,
+		    base + BCM6362_WLAN_MISC);
+	fsleep(1000);
+
+	iowrite32be(BCMA_IOCTL_FGC | BCMA_IOCTL_CLK,
+		    base + BCM6362_WLAN_MAC_CONTROL);
+	iowrite32be(BCM6362_WLAN_MISC_FORCE_CLK_ON, base + BCM6362_WLAN_MISC);
+	iowrite32be(0, base + BCM6362_WLAN_MISC);
+	iowrite32be(BCMA_IOCTL_CLK, base + BCM6362_WLAN_MAC_CONTROL);
+
+	dev_dbg(host->bus.dev, "CC ID A 0x%08x, MAC ID A 0x%08x\n",
+		ioread32be(base + BCM6362_WLAN_CC_ID_A),
+		ioread32be(base + BCM6362_WLAN_MAC_ID_A));
+
+	return 0;
+}
+
+static void bcma_host_soc_bcm6362_power_off(struct bcma_host_soc_bcm6362 *host)
+{
+	void __iomem *base = host->wlan_ctrl;
+
+	iowrite32be(0, base + BCM6362_WLAN_MAC_CONTROL);
+	iowrite32be(BCM6362_WLAN_MISC_MACRO_DISABLE |
+		    BCM6362_WLAN_MISC_MACRO_SOFT_RESET,
+		    base + BCM6362_WLAN_MISC);
+	reset_control_assert(host->rst_wlan);
+	reset_control_assert(host->rst_wlan_ubus);
+	clk_disable_unprepare(host->clk);
+}
+
+static int bcma_host_soc_bcm6362_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct bcma_host_soc_bcm6362 *host;
+	struct bcma_bus *bus;
+	int err;
+
+	host = devm_kzalloc(dev, sizeof(*host), GFP_KERNEL);
+	if (!host)
+		return -ENOMEM;
+
+	bus = &host->bus;
+	bus->dev = dev;
+
+	bus->mmio = devm_platform_ioremap_resource_byname(pdev, "chipcommon");
+	if (IS_ERR(bus->mmio))
+		return PTR_ERR(bus->mmio);
+
+	host->wlan_ctrl = devm_platform_ioremap_resource_byname(pdev, "wlan-ctrl");
+	if (IS_ERR(host->wlan_ctrl))
+		return PTR_ERR(host->wlan_ctrl);
+
+	host->clk = devm_clk_get(dev, NULL);
+	if (IS_ERR(host->clk))
+		return dev_err_probe(dev, PTR_ERR(host->clk),
+				     "failed to get clock\n");
+
+	host->rst_wlan = devm_reset_control_get_exclusive(dev, "wlan");
+	if (IS_ERR(host->rst_wlan))
+		return dev_err_probe(dev, PTR_ERR(host->rst_wlan),
+				     "failed to get wlan reset\n");
+
+	host->rst_wlan_ubus = devm_reset_control_get_exclusive(dev, "wlan-ubus");
+	if (IS_ERR(host->rst_wlan_ubus))
+		return dev_err_probe(dev, PTR_ERR(host->rst_wlan_ubus),
+				     "failed to get wlan-ubus reset\n");
+
+	err = bcma_host_soc_bcm6362_power_on(host);
+	if (err)
+		return dev_err_probe(dev, err, "failed to enable clock\n");
+
+	bus->hosttype = BCMA_HOSTTYPE_SOC;
+	bus->ops = &bcma_host_soc_bcm6362_ops;
+	bus->big_endian = true;
+	bus->wrapperless = true;
+
+	bcma_init_bus(bus);
+
+	err = bcma_bus_register(bus);
+	if (err) {
+		bcma_host_soc_bcm6362_power_off(host);
+		return err;
+	}
+
+	platform_set_drvdata(pdev, host);
+
+	return 0;
+}
+
+static void bcma_host_soc_bcm6362_remove(struct platform_device *pdev)
+{
+	struct bcma_host_soc_bcm6362 *host = platform_get_drvdata(pdev);
+
+	bcma_bus_unregister(&host->bus);
+	bcma_host_soc_bcm6362_power_off(host);
+}
+
+static const struct of_device_id bcma_host_soc_bcm6362_of_match[] = {
+	{ .compatible = "brcm,bcm6362-wlan-bus-axi" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, bcma_host_soc_bcm6362_of_match);
+
+static struct platform_driver bcma_host_soc_bcm6362_driver = {
+	.driver = {
+		.name = "bcma-host-soc-bcm6362",
+		.of_match_table = bcma_host_soc_bcm6362_of_match,
+	},
+	.probe		= bcma_host_soc_bcm6362_probe,
+	.remove		= bcma_host_soc_bcm6362_remove,
+};
+
+int __init bcma_host_soc_bcm6362_register_driver(void)
+{
+	return platform_driver_register(&bcma_host_soc_bcm6362_driver);
+}
+
+void __exit bcma_host_soc_bcm6362_unregister_driver(void)
+{
+	platform_driver_unregister(&bcma_host_soc_bcm6362_driver);
+}
diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 72f045e6ed51..4ccc9fb98f61 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -682,6 +682,11 @@ static int __init bcma_modinit(void)
 		pr_err("SoC host initialization failed\n");
 		err = 0;
 	}
+	err = bcma_host_soc_bcm6362_register_driver();
+	if (err) {
+		pr_err("BCM6362 WLAN host initialization failed\n");
+		err = 0;
+	}
 #ifdef CONFIG_BCMA_HOST_PCI
 	err = bcma_host_pci_init();
 	if (err) {
@@ -699,6 +704,7 @@ static void __exit bcma_modexit(void)
 #ifdef CONFIG_BCMA_HOST_PCI
 	bcma_host_pci_exit();
 #endif
+	bcma_host_soc_bcm6362_unregister_driver();
 	bcma_host_soc_unregister_driver();
 	bus_unregister(&bcma_bus_type);
 }

-- 
2.56.0

