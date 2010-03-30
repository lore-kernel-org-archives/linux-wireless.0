Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:42410 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab0C3Rxx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 13:53:53 -0400
Received: by ewy20 with SMTP id 20so1516937ewy.1
        for <linux-wireless@vger.kernel.org>; Tue, 30 Mar 2010 10:53:51 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [RFC][PATCH][WIP] b43: N-PHY: set band width
Date: Tue, 30 Mar 2010 19:54:17 +0200
Message-Id: <1269971657-4663-1-git-send-email-zajec5@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
I've problem with deciding how to keep some data needed by band width setting
code. Generally these band width-related routines are considered "common", to
be used by more than just N-PHY. So probably the most /correct/ way should be
to add some variables like maccontrol, wake_override, clk and other to struct
b43_phy which is shared between all PHYs. However we would not use these vars
in anything except N-PHY, so we would just waste users memory.

Could you help me decide correct way to handle this?
---
 drivers/net/wireless/b43/b43.h        |    1 +
 drivers/net/wireless/b43/phy_common.c |  186 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/b43/phy_common.h |    7 ++
 drivers/net/wireless/b43/phy_n.c      |    4 +-
 drivers/net/wireless/b43/phy_n.h      |    1 +
 5 files changed, 197 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 3a003e6..d75926f 100644
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
index 8f7d7ef..f46135f 100644
--- a/drivers/net/wireless/b43/phy_common.c
+++ b/drivers/net/wireless/b43/phy_common.c
@@ -466,3 +466,189 @@ struct b43_c32 b43_cordic(int theta)
 
 	return ret;
 }
+
+/* http://bcm-v4.sipsolutions.net/802.11/Mhf */
+void b43_mhf(struct b43_wldev *dev, u8 idx, u16 sel, u16 val, u8 band)
+{
+	; /* TODO */
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/NcClkCtlCc */
+static bool b43_no_check_clock_control_chip_common(struct b43_wldev *dev, u32 mode)
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
+	struct b43_phy_n *nphy = dev->phy.n;
+
+	u32 tmp = nphy->maccontrol;
+	if (nphy->wake_override)
+		tmp |= B43_MACCTL_AWAKE;
+	if (nphy->mute_override)
+		tmp &= ~B43_MACCTL_AP;
+	tmp |= B43_MACCTL_INFRA;
+	b43_write32(dev, B43_MMIO_MACCTL, tmp);
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/UcodeWakeOverrideSet */
+static void b43_ucode_wake_override_set(struct b43_wldev *dev, u32 override)
+{
+	struct b43_phy_n *nphy = dev->phy.n;
+
+	nphy->wake_override |= override;
+	if (nphy->wake_override || maccontrol & B43_MACCTL_AWAKE)
+		return;
+	b43_phy_mac_control_write(dev);
+	b43_phy_bmac_wait_for_wake(dev);
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/UcodeWakeOverrideClear */
+static void b43_ucode_wake_override_clear(struct b43_wldev *dev, u32 override)
+{
+	struct b43_phy_n *nphy = dev->phy.n;
+
+	nphy->wake_override &= ~override;
+	if (nphy->wake_override != nphy->maccontrol & B43_MACCTL_AWAKE)
+		return;
+	b43_phy_mac_control_write(dev);
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/ClkCtlClk */
+static void b43_clock_control(struct b43_wldev *dev, u32 mode)
+{
+	struct ssb_bus *bus = dev->dev->bus;
+	struct b43_phy_n *nphy = dev->phy.n;
+	u8 core_rev = bus->pcicore.dev->id.revision;
+	u16 i;
+	u32 clkctl;
+	bool wakeup;
+
+	if (bus->chipco.capabilities & SSB_CHIPCO_CAP_PMU) { /* PMU Present */
+		B43_WARN_ON(core_rev < 20);
+		if (nphy->clk) {
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
+		nphy->forcefastclk = (mode == 0);
+	} else {
+		B43_WARN_ON(core_rev >= 20);
+
+		wakeup = (core_rev < 9);
+		if (nphy->up && wakeup)
+			b43_ucode_wake_override_set(dev, 1);
+
+		nphy->forcefastclk = b43_clock_control_chip_common(dev, mode);
+		if (core_rev < 11) {
+			if (nphy->forcefastclk)
+				b43_mhf(dev, 0, 0x400, 0x400, 3);
+			else
+				b43_mhf(dev, 0, 0x400, 0, 3);
+		}
+		if (core_rev > 4 && nphy->forcefastclk && nphy->clk) {
+			if (nphy->forcefastclk)
+				nphy->wake_override |= 0x10;
+			else
+				nphy->wake_override &= ~0x10;
+		}
+
+		if (nphy->up && wakeup)
+			b43_ucode_wake_override_clear(dev, 1);
+	}
+}
+
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/BmacBwSet */
+void b43_bmac_set_b_width(struct b43_wldev *dev, u8 b_width)
+{
+	struct b43_phy_n *nphy = dev->phy.n;
+	bool fast;
+
+	/* Generally it is common routine, but we use it only for N-PHY now */
+	B43_WARN_ON(dev->phy.type != B43_PHYTYPE_N);
+
+	fast = nphy->forcefastclk;
+	if (!fast)
+		b43_clock_control(dev, 0);
+	nphy->b_width = b_width;
+	b43_read32(dev, B43_MMIO_MACCTL); /* flush writes */
+	/* TODO: Call PHY BMAC Reset */
+	dev->phy.ops->init(dev);
+	if (fast)
+		b43_clock_control(dev, 2);
+}
diff --git a/drivers/net/wireless/b43/phy_common.h b/drivers/net/wireless/b43/phy_common.h
index bd480b4..215fb05 100644
--- a/drivers/net/wireless/b43/phy_common.h
+++ b/drivers/net/wireless/b43/phy_common.h
@@ -429,4 +429,11 @@ void b43_phyop_switch_analog_generic(struct b43_wldev *dev, bool on);
 
 struct b43_c32 b43_cordic(int theta);
 
+void b43_mhf(struct b43_wldev *dev, u8 idx, u16 sel, u16 val, u8 band);
+
+/**
+ * b43_bmac_set_b_width - Set band width
+ */
+void b43_bmac_set_b_width(struct b43_wldev *dev, u8 b_width);
+
 #endif /* LINUX_B43_PHY_COMMON_H_ */
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 1ae232c..b19922d 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -1096,7 +1096,7 @@ static void b43_nphy_workarounds(struct b43_wldev *dev)
 
 		if (dev->phy.rev < 2) {
 			if (b43_phy_read(dev, B43_NPHY_RXCTL) & 0x2)
-				; /*TODO: b43_mhf(dev, 2, 0x0010, 0x0010, 3);*/
+				b43_mhf(dev, 2, 0x0010, 0x0010, 3);
 		} else if (dev->phy.rev == 2) {
 			b43_phy_write(dev, B43_NPHY_CRSCHECK2, 0);
 			b43_phy_write(dev, B43_NPHY_CRSCHECK3, 0);
@@ -3356,7 +3356,7 @@ static int b43_nphy_set_chanspec(struct b43_wldev *dev,
 	nphy->radio_chanspec = chanspec;
 
 	if (chanspec.b_width != nphy->b_width)
-		; /* TODO: BMAC BW Set (chanspec.b_width) */
+		b43_bmac_set_b_width(chanspec.b_width);
 
 	/* TODO: use defines */
 	if (chanspec.b_width == 3) {
diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43/phy_n.h
index 8b6d570..1ec768e 100644
--- a/drivers/net/wireless/b43/phy_n.h
+++ b/drivers/net/wireless/b43/phy_n.h
@@ -987,6 +987,7 @@ struct b43_phy_n {
 	u8 b_width;
 	struct b43_chanspec radio_chanspec;
 
+	bool forcefastclk;
 	bool gain_boost;
 	bool elna_gain_config;
 	bool band5g_pwrgain;
-- 
1.6.4.2

