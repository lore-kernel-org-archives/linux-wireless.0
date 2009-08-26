Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:60864 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbZHZSvb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 14:51:31 -0400
Received: by bwz19 with SMTP id 19so359406bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2009 11:51:32 -0700 (PDT)
From: =?utf-8?q?G=C3=A1bor=20Stefanik?= <netrolller.3d@gmail.com>
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Mark Huijgen <mark@huijgen.tk>
Cc: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] ssb: Implement PMU LDO control and use it in b43
Date: Wed, 26 Aug 2009 20:51:26 +0200
Message-Id: <1251312686-32067-3-git-send-email-netrolller.3d@gmail.com>
In-Reply-To: <1251312686-32067-2-git-send-email-netrolller.3d@gmail.com>
References: <1251312686-32067-1-git-send-email-netrolller.3d@gmail.com>
 <1251312686-32067-2-git-send-email-netrolller.3d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement the "PMU LDO set voltage" and "PMU LDO PA ref enable"
functions, and use them during LP-PHY baseband init in b43.

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
 drivers/net/wireless/b43/phy_lp.c         |   10 +--
 drivers/ssb/driver_chipcommon_pmu.c       |   94 +++++++++++++++++++++++++++++
 include/linux/ssb/ssb_driver_chipcommon.h |   10 +++
 3 files changed, 107 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index 1a57d33..80f245c 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -234,19 +234,15 @@ static void lpphy_baseband_rev0_1_init(struct b43_wldev *dev)
 	if ((bus->sprom.boardflags_lo & B43_BFL_FEM) &&
 	   ((b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) ||
 	   (bus->sprom.boardflags_hi & B43_BFH_PAREF))) {
-		/* TODO:
-		 * Set the LDO voltage to 0x0028 - FIXME: What is this?
-		 * Call sb_pmu_set_ldo_voltage with 4 and the LDO voltage
-		 *      as arguments
-		 * Call sb_pmu_paref_ldo_enable with argument TRUE
-		 */
+		ssb_pmu_set_ldo_voltage(&bus->chipco, LDO_PAREF, 0x28);
+		ssb_pmu_set_ldo_paref(&bus->chipco, true);
 		if (dev->phy.rev == 0) {
 			b43_phy_maskset(dev, B43_LPPHY_LP_RF_SIGNAL_LUT,
 					0xFFCF, 0x0010);
 		}
 		b43_lptab_write(dev, B43_LPTAB16(11, 7), 60);
 	} else {
-		//TODO: Call ssb_pmu_paref_ldo_enable with argument FALSE
+		ssb_pmu_set_ldo_paref(&bus->chipco, false);
 		b43_phy_maskset(dev, B43_LPPHY_LP_RF_SIGNAL_LUT,
 				0xFFCF, 0x0020);
 		b43_lptab_write(dev, B43_LPTAB16(11, 7), 100);
diff --git a/drivers/ssb/driver_chipcommon_pmu.c b/drivers/ssb/driver_chipcommon_pmu.c
index 4aaddee..64abd11 100644
--- a/drivers/ssb/driver_chipcommon_pmu.c
+++ b/drivers/ssb/driver_chipcommon_pmu.c
@@ -28,6 +28,21 @@ static void ssb_chipco_pll_write(struct ssb_chipcommon *cc,
 	chipco_write32(cc, SSB_CHIPCO_PLLCTL_DATA, value);
 }
 
+static void ssb_chipco_regctl_maskset(struct ssb_chipcommon *cc,
+				   u32 offset, u32 mask, u32 set)
+{
+	u32 value;
+
+	chipco_read32(cc, SSB_CHIPCO_REGCTL_ADDR);
+	chipco_write32(cc, SSB_CHIPCO_REGCTL_ADDR, offset);
+	chipco_read32(cc, SSB_CHIPCO_REGCTL_ADDR);
+	value = chipco_read32(cc, SSB_CHIPCO_REGCTL_DATA);
+	value &= mask;
+	value |= set;
+	chipco_write32(cc, SSB_CHIPCO_REGCTL_DATA, value);
+	chipco_read32(cc, SSB_CHIPCO_REGCTL_DATA);
+}
+
 struct pmu0_plltab_entry {
 	u16 freq;	/* Crystal frequency in kHz.*/
 	u8 xf;		/* Crystal frequency value for PMU control */
@@ -506,3 +521,82 @@ void ssb_pmu_init(struct ssb_chipcommon *cc)
 	ssb_pmu_pll_init(cc);
 	ssb_pmu_resources_init(cc);
 }
+
+void ssb_pmu_set_ldo_voltage(struct ssb_chipcommon *cc,
+			     enum ssb_pmu_ldo_volt_id id, u32 voltage)
+{
+	struct ssb_bus *bus = cc->dev->bus;
+	u32 addr, shift, mask;
+
+	switch (bus->chip_id) {
+	case 0x4328:
+	case 0x5354:
+		switch (id) {
+		case LDO_VOLT1:
+			addr = 2;
+			shift = 25;
+			mask = 0xF;
+			break;
+		case LDO_VOLT2:
+			addr = 3;
+			shift = 1;
+			mask = 0xF;
+			break;
+		case LDO_VOLT3:
+			addr = 3;
+			shift = 9;
+			mask = 0xF;
+			break;
+		case LDO_PAREF:
+			addr = 3;
+			shift = 17;
+			mask = 0x3F;
+			break;
+		default:
+			SSB_WARN_ON(1);
+			return;
+		}
+		break;
+	case 0x4312:
+		if (SSB_WARN_ON(id != LDO_PAREF))
+			return;
+		addr = 0;
+		shift = 21;
+		mask = 0x3F;
+		break;
+	default:
+		return;
+	}
+
+	ssb_chipco_regctl_maskset(cc, addr, ~(mask << shift),
+				  (voltage & mask) << shift);
+}
+
+void ssb_pmu_set_ldo_paref(struct ssb_chipcommon *cc, bool on)
+{
+	struct ssb_bus *bus = cc->dev->bus;
+	int ldo;
+
+	switch (bus->chip_id) {
+	case 0x4312:
+		ldo = SSB_PMURES_4312_PA_REF_LDO;
+		break;
+	case 0x4328:
+		ldo = SSB_PMURES_4328_PA_REF_LDO;
+		break;
+	case 0x5354:
+		ldo = SSB_PMURES_5354_PA_REF_LDO;
+		break;
+	default:
+		return;
+	}
+
+	if (on)
+		chipco_set32(cc, SSB_CHIPCO_PMU_MINRES_MSK, 1 << ldo);
+	else
+		chipco_mask32(cc, SSB_CHIPCO_PMU_MINRES_MSK, ~(1 << ldo));
+	chipco_read32(cc, SSB_CHIPCO_PMU_MINRES_MSK); //SPEC FIXME found via mmiotrace - dummy read?
+}
+
+EXPORT_SYMBOL(ssb_pmu_set_ldo_voltage);
+EXPORT_SYMBOL(ssb_pmu_set_ldo_paref);
diff --git a/include/linux/ssb/ssb_driver_chipcommon.h b/include/linux/ssb/ssb_driver_chipcommon.h
index d3b1d18..4e27acf 100644
--- a/include/linux/ssb/ssb_driver_chipcommon.h
+++ b/include/linux/ssb/ssb_driver_chipcommon.h
@@ -629,5 +629,15 @@ extern int ssb_chipco_serial_init(struct ssb_chipcommon *cc,
 /* PMU support */
 extern void ssb_pmu_init(struct ssb_chipcommon *cc);
 
+enum ssb_pmu_ldo_volt_id {
+	LDO_PAREF = 0,
+	LDO_VOLT1,
+	LDO_VOLT2,
+	LDO_VOLT3,
+};
+
+void ssb_pmu_set_ldo_voltage(struct ssb_chipcommon *cc,
+			     enum ssb_pmu_ldo_volt_id id, u32 voltage);
+void ssb_pmu_set_ldo_paref(struct ssb_chipcommon *cc, bool on);
 
 #endif /* LINUX_SSB_CHIPCO_H_ */
-- 
1.5.6

