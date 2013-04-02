Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:55770 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760162Ab3DBN5g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Apr 2013 09:57:36 -0400
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	Stable <stable@vger.kernel.org>
Subject: [PATCH V2] ssb: implement spurious tone avoidance
Date: Tue,  2 Apr 2013 15:57:26 +0200
Message-Id: <1364911046-5732-1-git-send-email-zajec5@gmail.com> (sfid-20130402_155740_565444_3CA73591)
In-Reply-To: <1364487482-14642-1-git-send-email-zajec5@gmail.com>
References: <1364487482-14642-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

And make use of it in b43. This fixes a regression introduced with
49d55cef5b1925a5c1efb6aaddaa40fc7c693335
b43: N-PHY: implement spurious tone avoidance
This commit made BCM4322 use only MCS 0 on channel 13, which of course
resulted in performance drop (down to 0.7Mb/s).

Reported-by: Stefan Brüns <stefan.bruens@rwth-aachen.de>
Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Cc: Stable <stable@vger.kernel.org>
---
V2: use ssb_printk instead of non-existing ssb_err
    add BCM43222 case to don't flood dmesg on this chipset

Support for BCM43222 wasn't implemented in this patch, because I don't
own that hardware and I don't dare to send not tested code for "fix" and
stable. I'll implement this in separated patch that will be send for
next tree.

This patch was tested with BCM4322 using wireless git tree (not
wireless-testing!), I've also applied and tested it using kernels 3.4.38
and 3.8.5.
---
 drivers/net/wireless/b43/phy_n.c          |    3 ++-
 drivers/ssb/driver_chipcommon_pmu.c       |   29 +++++++++++++++++++++++++++++
 include/linux/ssb/ssb_driver_chipcommon.h |    2 ++
 3 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index e8486c1..b70f220 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -5165,7 +5165,8 @@ static void b43_nphy_pmu_spur_avoid(struct b43_wldev *dev, bool avoid)
 #endif
 #ifdef CONFIG_B43_SSB
 	case B43_BUS_SSB:
-		/* FIXME */
+		ssb_pmu_spuravoid_pllupdate(&dev->dev->sdev->bus->chipco,
+					    avoid);
 		break;
 #endif
 	}
diff --git a/drivers/ssb/driver_chipcommon_pmu.c b/drivers/ssb/driver_chipcommon_pmu.c
index 4c0f6d8..7b0bce9 100644
--- a/drivers/ssb/driver_chipcommon_pmu.c
+++ b/drivers/ssb/driver_chipcommon_pmu.c
@@ -675,3 +675,32 @@ u32 ssb_pmu_get_controlclock(struct ssb_chipcommon *cc)
 		return 0;
 	}
 }
+
+void ssb_pmu_spuravoid_pllupdate(struct ssb_chipcommon *cc, int spuravoid)
+{
+	u32 pmu_ctl = 0;
+
+	switch (cc->dev->bus->chip_id) {
+	case 0x4322:
+		ssb_chipco_pll_write(cc, SSB_PMU1_PLLCTL0, 0x11100070);
+		ssb_chipco_pll_write(cc, SSB_PMU1_PLLCTL1, 0x1014140a);
+		ssb_chipco_pll_write(cc, SSB_PMU1_PLLCTL5, 0x88888854);
+		if (spuravoid == 1)
+			ssb_chipco_pll_write(cc, SSB_PMU1_PLLCTL2, 0x05201828);
+		else
+			ssb_chipco_pll_write(cc, SSB_PMU1_PLLCTL2, 0x05001828);
+		pmu_ctl = SSB_CHIPCO_PMU_CTL_PLL_UPD;
+		break;
+	case 43222:
+		/* TODO: BCM43222 requires updating PLLs too */
+		return;
+	default:
+		ssb_printk(KERN_ERR PFX
+			   "Unknown spuravoidance settings for chip 0x%04X, not changing PLL\n",
+			   cc->dev->bus->chip_id);
+		return;
+	}
+
+	chipco_set32(cc, SSB_CHIPCO_PMU_CTL, pmu_ctl);
+}
+EXPORT_SYMBOL_GPL(ssb_pmu_spuravoid_pllupdate);
diff --git a/include/linux/ssb/ssb_driver_chipcommon.h b/include/linux/ssb/ssb_driver_chipcommon.h
index 9e492be..6fcfe99 100644
--- a/include/linux/ssb/ssb_driver_chipcommon.h
+++ b/include/linux/ssb/ssb_driver_chipcommon.h
@@ -219,6 +219,7 @@
 #define SSB_CHIPCO_PMU_CTL			0x0600 /* PMU control */
 #define  SSB_CHIPCO_PMU_CTL_ILP_DIV		0xFFFF0000 /* ILP div mask */
 #define  SSB_CHIPCO_PMU_CTL_ILP_DIV_SHIFT	16
+#define  SSB_CHIPCO_PMU_CTL_PLL_UPD		0x00000400
 #define  SSB_CHIPCO_PMU_CTL_NOILPONW		0x00000200 /* No ILP on wait */
 #define  SSB_CHIPCO_PMU_CTL_HTREQEN		0x00000100 /* HT req enable */
 #define  SSB_CHIPCO_PMU_CTL_ALPREQEN		0x00000080 /* ALP req enable */
@@ -667,5 +668,6 @@ enum ssb_pmu_ldo_volt_id {
 void ssb_pmu_set_ldo_voltage(struct ssb_chipcommon *cc,
 			     enum ssb_pmu_ldo_volt_id id, u32 voltage);
 void ssb_pmu_set_ldo_paref(struct ssb_chipcommon *cc, bool on);
+void ssb_pmu_spuravoid_pllupdate(struct ssb_chipcommon *cc, int spuravoid);
 
 #endif /* LINUX_SSB_CHIPCO_H_ */
-- 
1.7.10.4

