Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48507 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab0LVTPH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 14:15:07 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/3] b43: N-PHY: add sub calls of band width setting
Date: Wed, 22 Dec 2010 14:11:31 -0500
Message-Id: <1293045092-12483-3-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1293045092-12483-1-git-send-email-linville@tuxdriver.com>
References: <1293045092-12483-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <zajec5@gmail.com>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/b43/b43.h        |    1 +
 drivers/net/wireless/b43/phy_common.c |  150 ++++++++++++++++++++++++++++++++-
 drivers/net/wireless/b43/phy_common.h |    7 ++
 3 files changed, 157 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index bd4cb75..2798a9e 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -57,6 +57,7 @@
 #define B43_MMIO_TSF_CFP_REP		0x188
 #define B43_MMIO_TSF_CFP_START		0x18C
 #define B43_MMIO_TSF_CFP_MAXDUR		0x190
+#define B43_MMIO_CLKCTL			0x1E0	/* clock control status */
 
 /* 32-bit DMA */
 #define B43_MMIO_DMA32_BASE0		0x200
diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
index 113b9f1..9b94cdc 100644
--- a/drivers/net/wireless/b43/phy_common.c
+++ b/drivers/net/wireless/b43/phy_common.c
@@ -483,10 +483,158 @@ struct b43_c32 b43_cordic(int theta)
 	return ret;
 }
 
+/* http://bcm-v4.sipsolutions.net/802.11/NcClkCtlCc */
+static bool b43_no_check_clock_control_chip_common(struct b43_wldev *dev,
+								u32 mode)
+{
+	/* TODO: this is temporary hack */
+	return (mode == 0);
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/ClkCtlCc */
+static bool b43_clock_control_chip_common(struct b43_wldev *dev, u32 mode)
+{
+	struct ssb_bus *bus = dev->dev->bus;
+	u16 chip_id = bus->chip_id;
+	u16 chip_rev = bus->chip_rev;
+	/* TODO: specs distinguish PCI and PCIe */
+	bool pci = (bus->bustype == SSB_BUSTYPE_PCI);
+
+	if (dev->dev->id.revision < 6)
+		return false;
+	if (pci && ((chip_id == 0x4311 && chip_rev < 2) ||
+		    (pci && chip_id == 0x4321) ||
+		    (pci && chip_id == 0x4716)))
+		return (mode == 0);
+	return b43_no_check_clock_control_chip_common(dev, mode);
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/BmacWaitForWake */
+static void b43_phy_bmac_wait_for_wake(struct b43_wldev *dev)
+{
+	u8 core_rev = dev->dev->bus->pcicore.dev->id.revision;
+	u16 tmp, i;
+
+	if (core_rev == 4) {
+		udelay(5);
+		return;
+	}
+
+	if (dev->phy.type == B43_PHYTYPE_G && core_rev == 5)
+		udelay(2000);
+	else
+		udelay(40);
+
+	for (i = 0; i < 1500; i++) {
+		tmp = b43_shm_read16(dev, B43_SHM_SHARED,
+					B43_SHM_SH_UCODESTAT);
+		if (tmp == B43_SHM_SH_UCODESTAT_SLEEP) {
+			i = 0;
+			break;
+		}
+		udelay(10);
+	}
+	if (i)
+		b43err(dev->wl, "ucode wake up timeout\n");
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/MctrlWrite */
+static void b43_phy_mac_control_write(struct b43_wldev *dev)
+{
+	u32 tmp = dev->phy.maccontrol;
+	if (dev->phy.wake_override)
+		tmp |= B43_MACCTL_AWAKE;
+	if (dev->phy.mute_override)
+		tmp &= ~B43_MACCTL_AP;
+	tmp |= B43_MACCTL_INFRA;
+	b43_write32(dev, B43_MMIO_MACCTL, tmp);
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/UcodeWakeOverrideSet */
+static void b43_ucode_wake_override_set(struct b43_wldev *dev, u32 override)
+{
+	dev->phy.wake_override |= override;
+	if (dev->phy.wake_override || dev->phy.maccontrol & B43_MACCTL_AWAKE)
+		return;
+	b43_phy_mac_control_write(dev);
+	b43_phy_bmac_wait_for_wake(dev);
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/UcodeWakeOverrideClear */
+static void b43_ucode_wake_override_clear(struct b43_wldev *dev, u32 override)
+{
+	dev->phy.wake_override &= ~override;
+	if (dev->phy.wake_override != (dev->phy.maccontrol & B43_MACCTL_AWAKE))
+		return;
+	b43_phy_mac_control_write(dev);
+}
+
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/ClkCtlClk */
 static void b43_clock_control(struct b43_wldev *dev, u32 mode)
 {
-	/* TODO */
+	struct b43_phy *phy = &dev->phy;
+	struct ssb_bus *bus = dev->dev->bus;
+	u8 core_rev = bus->pcicore.dev->id.revision;
+	u16 i;
+	u32 clkctl;
+	bool wakeup;
+
+	if (bus->chipco.capabilities & SSB_CHIPCO_CAP_PMU) { /* PMU Present */
+		B43_WARN_ON(core_rev < 20);
+		if (phy->clk) {
+			bool tmp = (bus->chipco.pmu.rev == 0 &&
+				(b43_read32(dev, B43_MMIO_CLKCTL) & 0x12));
+
+			if (mode == 0) {
+				clkctl = b43_read32(dev, B43_MMIO_CLKCTL);
+				clkctl |= 0x2;
+				b43_write32(dev, B43_MMIO_CLKCTL, clkctl);
+				udelay(33);
+			}
+
+			if (mode == 0 || tmp) {
+				for (i = 0; i < 1500; i++) {
+					clkctl = b43_read32(dev, B43_MMIO_CLKCTL);
+					if ((clkctl & 0x20000) == 0) {
+						i = 0;
+						break;
+					}
+					udelay(10);
+				}
+				if (i)
+					b43err(dev->wl, "clock timeout\n");
+			}
+
+			if (mode != 0 && tmp) {
+				clkctl = b43_read32(dev, B43_MMIO_CLKCTL);
+				clkctl &= ~0x2;
+				b43_write32(dev, B43_MMIO_CLKCTL, clkctl);
+			}
+		}
+		phy->forcefastclk = (mode == 0);
+	} else {
+		B43_WARN_ON(core_rev >= 20);
+
+		wakeup = (core_rev < 9);
+		if (phy->up && wakeup)
+			b43_ucode_wake_override_set(dev, 1);
+
+		phy->forcefastclk = b43_clock_control_chip_common(dev, mode);
+		if (core_rev < 11) {
+			if (phy->forcefastclk)
+				; /* TODO: b43_mhf(dev, 0, 0x400, 0x400, 3); */
+			else
+				; /* TODO: b43_mhf(dev, 0, 0x400, 0, 3); */
+		}
+
+		if (phy->forcefastclk)
+			phy->wake_override |= 0x10;
+		else
+			phy->wake_override &= ~0x10;
+
+		if (phy->up && wakeup)
+			b43_ucode_wake_override_clear(dev, 1);
+	}
 }
 
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/BmacBwSet */
diff --git a/drivers/net/wireless/b43/phy_common.h b/drivers/net/wireless/b43/phy_common.h
index 2dd04cf..000c503 100644
--- a/drivers/net/wireless/b43/phy_common.h
+++ b/drivers/net/wireless/b43/phy_common.h
@@ -269,8 +269,15 @@ struct b43_phy {
 	atomic_t txerr_cnt;
 
 	/* Clock */
+	u32 clk;
 	bool forcefastclk;
 
+	bool up;
+	u32 maccontrol;
+
+	u32 wake_override;
+	u32 mute_override;
+
 #ifdef CONFIG_B43_DEBUG
 	/* PHY registers locked (w.r.t. firmware) */
 	bool phy_locked;
-- 
1.7.3.3

