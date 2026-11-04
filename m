Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.156.56
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793820658;
	b=Q1NE/wOnfzNFXCy3fz121ynw1KAY9+XADzczmqvSLNvXVi3HcZ46ykV3iICnzO6Kt2Pt
	 /LhPrVLnd5u8OYBZRweOz7BDj9v5A8TWGf/nbfrQ7qSIQPK7SdGg+lVjR18yeqf56OqPl
	 AsrNmlrsSyOUS90RG/3l5rgyArawiWw+QyAYntp1e/Q/yBpUZ0l2uZTO7CqBAKTNCGUdS
	 EfsTdR///5D2UFudUdxM5n+MvEhcHIrVTNKPcaUnVYMIQTAwUaoEU0E2gMMwjXavGpCNg
	 xPKpc6U8ED+DziAqfceDHTE2XjM23lSk3CjDo7PjZEAWZAOrdDUYRrAdAQx/98obgjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793820658;
	h=DMARC-Filter:Received:DKIM-Signature:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-CMAE-Envelope;
	bh=thk8Et7oR0sCp58Gp3S2j6PvK4lW5VTXKkZS+sjAgPM=;
	b=AAl2qszCRGmqGLdU4ynWsvxWferg7TS18YAVIBCm6LjaNJiVeUK26TRu8CHMwb8ADpbI
	 yTHszgEiNuUBwmz3RF3z5d7tj6jXx883AXv8SnTaVmkpeDW+fIg0FBuOTEI2KyCw2z2dm
	 LN33+s6wtdyo5zcCQ/8Xsoylv0h9lfMlqbd4oD694aQYeL+GFia0H6pkjC62qnfQaIAMm
	 m0JXzVl+cb3Ipc1yVOSLFMdSNCi8MXPR1V6Q7vQ7KMOwtLmPl2Co86xPgyJyYEs/v1oNG
	 WTbQLumaktTklhGub/VfJu/Ypraz15tRRHsljRFG9Oj7bk1qgJ2kio3wkTXAEtn5Gew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mythread.it;
	spf=pass smtp.mailfrom=mythread.it;
	dkim=pass header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=WYP7Zfc8;
	arc=none smtp.remote-ip=62.149.156.56
Received: from smtpcmd0756.aruba.it (smtpcmd0756.aruba.it [62.149.156.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48B7606C5B7
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 19:30:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B48B7606C5B7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=WYP7Zfc8
Received: from [192.168.1.237] ([94.34.125.0])
	by Aruba SMTP with ESMTPSA
	id Ogh3xxDlIuuRMOgh5xJX8g; Wed, 04 Nov 2026 20:30:47 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1793820647; bh=B3rOI2mrs8HUMNPJ6C2kOcQaTPhdwO9rBw5N91nvoVw=;
	h=From:Date:Subject:MIME-Version:Content-Type:To;
	b=WYP7Zfc8F6KfFGp34uVDaEJy9ehGlYs4CxtVfAx0Wl5YJThQ64nWqyhft52bQ2cCB
	 2wJdbmEWq2kUDPkbybl+Ef767fQtv+6p6Z4YApCTumkoAi0ksmyZGBZj0fErEHvR3J
	 5qQfb6mUR1dOm9QptMMwJv0g77UJH9oLrLgIfRrN34V3jnKysAygmfsEwUCDg4olNO
	 BvSZBSPyc5sNNghYClD0M8Ye4/LtFLGrt1txh8F6DW/LHjWGIF0DuHGHD4WeMqetM7
	 alms2xRtXBbHoWUeY/ILPxx84yY0pBFcpAdkXQ03qBnUejH4FrTYkjwUwfsJajEUI5
	 5M7dTlsKNTBBA==
From: Alessio Ferri <alessio.ferri@mythread.it>
Date: Wed, 04 Nov 2026 20:30:47 +0100
Subject: [PATCH v4 4/5] bcma: add host driver for the BCM6362 integrated
 WLAN backplane
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261104-bcm6362-wlan-v4-4-f001f6d75dc3@mythread.it>
References: <20261104-bcm6362-wlan-v4-0-f001f6d75dc3@mythread.it>
In-Reply-To: <20261104-bcm6362-wlan-v4-0-f001f6d75dc3@mythread.it>
To: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>, 
 Philipp Zabel <p.zabel@pengutronix.de>, 
 Florian Fainelli <florian.fainelli@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Jonas Gorski <jonas.gorski@gmail.com>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org, 
 Alessio Ferri <alessio.ferri@mythread.it>
X-Mailer: b4 0.14.3
X-CMAE-Envelope: MS4xfBvkpWepbH7IU9x6gOlcj2XdseRrzIEwzb8aMq9Ie9uZi12I486TIMfZq51vhX63e5Jkoijj9q3DFpapXqB7SAE/cGbhf1JOjRdHXt1KHRrQjv4HvgX7
 a2bhn/2Mt7wiWjSdUPCUJoFsIh0SaMOOmifuPAAnzzPnBpkMCmKv68cj7qByu8X2F7+MAqabVLBdwah15tr9nPXAnZRjBmTNhv3+Q7NYFhYmMhwkYUnuMKsl
 iYt/pKbevs+YSC3tNq/R0Tgo1aY6Q2h47we/NOfJ5gGSitnGVZYyNhD8dNDHbN7UEe3t/onYdmSbeDZY+KBCFNWcc48pKnKBL5KXeiFQN18KgiD/OdOUgMAn
 30xmGiSOKg/k78firSUfV2VAyeg/UPaPMKk5/57Q51oFqZOUU5Vbiy4pxAoZIwUaFQTU4RbPC0Uy2KCJtOF7C4AkBdzd2sjPuUoRwBJwY4Vs+M/O0iVaylVY
 MUF6kkr0sxPe+2BDqQp3PpNJ9RmSBeDjsC2zoAL8Biw5V1A8fsY6mianKpCFbItWDiZvqPb3esRnpQ52TtOzF5+Av4EPNxA0evbhG8B235dxlbYgNJ0DAImg
 AogSxD7bUubk9Wenez8RMtlZ70BebuhviSzfHzmSnzi+bsKPf4zmDDLzUZ3hWpGVw0uVsN+5qa8hRIsxqA8UUpCkiPiIwzXQpt6ZPo4VJl/dZA==

The BCM6362 integrates a WLAN macro on a dedicated bcma backplane.
CFE leaves the macro clock gated and in reset, the backplane is
a big-endian peripheral, and none of the cores has a wrapper:
gating and reset of ChipCommon and of the 802.11 core go through
per-core control registers in a separate WLAN control block.

Add a host driver for it that:

  - maps the ChipCommon and WLAN control register blocks;
  - enables the clock, cycles the WLAN and WLAN UBUS resets and runs the
    macro enable sequence before bcma touches the backplane;
  - provides big-endian register and block I/O ops;
  - emulates BCMA_IOCTL, BCMA_IOST, BCMA_RESET_CTL and BCMA_RESET_ST
    on top of the per-core control registers. The PHY bits of
    BCMA_IOST report what b43 expect;
  - sets the big_endian and wrapperless bus flags before scanning.

The macro enable sequence comes from the bcm6362 platform setup
code.

As for the PCI and generic SoC hosts, the driver is linked into
bcma.ko and registered from bcma_modinit().

Add a MAINTAINERS entry for the driver and its binding.

The 802.11 core (rev 0x16) is handled by b43 once a SPROM is
available; on this SoC it is not stored on the chip and has to be
provided. In openwrt i use 6362-sprom plus fixups.

Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>
---
 MAINTAINERS                     |   7 +
 drivers/bcma/Kconfig            |  12 ++
 drivers/bcma/Makefile           |   1 +
 drivers/bcma/bcma_private.h     |  15 ++
 drivers/bcma/host_soc_bcm6362.c | 423 ++++++++++++++++++++++++++++++++++++++++
 drivers/bcma/main.c             |   6 +
 6 files changed, 464 insertions(+)

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
index 000000000000..e8400cb62448
--- /dev/null
+++ b/drivers/bcma/host_soc_bcm6362.c
@@ -0,0 +1,423 @@
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
+	struct reset_control_bulk_data resets[2];
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
+ * Macro enable sequence from the Broadcom board support code: with the
+ * clock forced on and the macro in soft reset, enable the 802.11 core
+ * clock with force gated clock set, then release the soft reset and the
+ * forces.
+ */
+static int bcma_host_soc_bcm6362_power_on(struct bcma_host_soc_bcm6362 *host)
+{
+	void __iomem *base = host->wlan_ctrl;
+	int err;
+
+	err = clk_prepare_enable(host->clk);
+	if (err) {
+		dev_err(host->bus.dev, "failed to enable clock: %d\n", err);
+		return err;
+	}
+	fsleep(10000);
+
+	err = reset_control_bulk_assert(ARRAY_SIZE(host->resets), host->resets);
+	if (err)
+		goto err_resets;
+	fsleep(1000);
+	err = reset_control_bulk_deassert(ARRAY_SIZE(host->resets), host->resets);
+	if (err)
+		goto err_resets;
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
+
+err_resets:
+	dev_err(host->bus.dev, "failed to cycle resets: %d\n", err);
+	clk_disable_unprepare(host->clk);
+	return err;
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
+	reset_control_bulk_assert(ARRAY_SIZE(host->resets), host->resets);
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
+	host->resets[0].id = "wlan";
+	host->resets[1].id = "wlan-ubus";
+	err = devm_reset_control_bulk_get_exclusive(dev, ARRAY_SIZE(host->resets),
+						    host->resets);
+	if (err)
+		return dev_err_probe(dev, err, "failed to get resets\n");
+
+	err = bcma_host_soc_bcm6362_power_on(host);
+	if (err)
+		return err;
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

