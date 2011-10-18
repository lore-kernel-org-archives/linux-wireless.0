Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2275 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757520Ab1JRMD2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 08:03:28 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Alwin Beukers" <alwin@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 02/15] brcm80211: removed duplicate defines
Date: Tue, 18 Oct 2011 14:02:58 +0200
Message-ID: <1318939391-19495-3-git-send-email-arend@broadcom.com> (sfid-20111018_140341_676554_76B3ED71)
In-Reply-To: <1318939391-19495-1-git-send-email-arend@broadcom.com>
References: <1318939391-19495-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alwin Beukers <alwin@broadcom.com>

Removed defines from aiutils.h also present in soc.h.

Reported-by: Hauke Mehrtens <hauke@hauke-m.de>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.h  |   76 --------------------
 drivers/net/wireless/brcm80211/brcmsmac/dma.c      |    1 +
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |    1 +
 .../net/wireless/brcm80211/brcmsmac/phy/phy_n.c    |    1 +
 drivers/net/wireless/brcm80211/brcmsmac/pmu.c      |    1 +
 drivers/net/wireless/brcm80211/brcmsmac/srom.c     |    1 +
 drivers/net/wireless/brcm80211/include/soc.h       |   12 +++-
 7 files changed, 15 insertions(+), 78 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
index 106a742..b51d1e4 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
@@ -38,88 +38,12 @@
 /* PCIE Client Mode sb2pcitranslation2 (2 ZettaBytes), high 32 bits */
 #define SI_PCIE_DMA_H32		0x80000000
 
-/* core codes */
-#define	NODEV_CORE_ID		0x700	/* Invalid coreid */
-#define	CC_CORE_ID		0x800	/* chipcommon core */
-#define	ILINE20_CORE_ID		0x801	/* iline20 core */
-#define	SRAM_CORE_ID		0x802	/* sram core */
-#define	SDRAM_CORE_ID		0x803	/* sdram core */
-#define	PCI_CORE_ID		0x804	/* pci core */
-#define	MIPS_CORE_ID		0x805	/* mips core */
-#define	ENET_CORE_ID		0x806	/* enet mac core */
-#define	CODEC_CORE_ID		0x807	/* v90 codec core */
-#define	USB_CORE_ID		0x808	/* usb 1.1 host/device core */
-#define	ADSL_CORE_ID		0x809	/* ADSL core */
-#define	ILINE100_CORE_ID	0x80a	/* iline100 core */
-#define	IPSEC_CORE_ID		0x80b	/* ipsec core */
-#define	UTOPIA_CORE_ID		0x80c	/* utopia core */
-#define	PCMCIA_CORE_ID		0x80d	/* pcmcia core */
-#define	SOCRAM_CORE_ID		0x80e	/* internal memory core */
-#define	MEMC_CORE_ID		0x80f	/* memc sdram core */
-#define	OFDM_CORE_ID		0x810	/* OFDM phy core */
-#define	EXTIF_CORE_ID		0x811	/* external interface core */
-#define	D11_CORE_ID		0x812	/* 802.11 MAC core */
-#define	APHY_CORE_ID		0x813	/* 802.11a phy core */
-#define	BPHY_CORE_ID		0x814	/* 802.11b phy core */
-#define	GPHY_CORE_ID		0x815	/* 802.11g phy core */
-#define	MIPS33_CORE_ID		0x816	/* mips3302 core */
-#define	USB11H_CORE_ID		0x817	/* usb 1.1 host core */
-#define	USB11D_CORE_ID		0x818	/* usb 1.1 device core */
-#define	USB20H_CORE_ID		0x819	/* usb 2.0 host core */
-#define	USB20D_CORE_ID		0x81a	/* usb 2.0 device core */
-#define	SDIOH_CORE_ID		0x81b	/* sdio host core */
-#define	ROBO_CORE_ID		0x81c	/* roboswitch core */
-#define	ATA100_CORE_ID		0x81d	/* parallel ATA core */
-#define	SATAXOR_CORE_ID		0x81e	/* serial ATA & XOR DMA core */
-#define	GIGETH_CORE_ID		0x81f	/* gigabit ethernet core */
-#define	PCIE_CORE_ID		0x820	/* pci express core */
-#define	NPHY_CORE_ID		0x821	/* 802.11n 2x2 phy core */
-#define	SRAMC_CORE_ID		0x822	/* SRAM controller core */
-#define	MINIMAC_CORE_ID		0x823	/* MINI MAC/phy core */
-#define	ARM11_CORE_ID		0x824	/* ARM 1176 core */
-#define	ARM7S_CORE_ID		0x825	/* ARM7tdmi-s core */
-#define	LPPHY_CORE_ID		0x826	/* 802.11a/b/g phy core */
-#define	PMU_CORE_ID		0x827	/* PMU core */
-#define	SSNPHY_CORE_ID		0x828	/* 802.11n single-stream phy core */
-#define	SDIOD_CORE_ID		0x829	/* SDIO device core */
-#define	ARMCM3_CORE_ID		0x82a	/* ARM Cortex M3 core */
-#define	HTPHY_CORE_ID		0x82b	/* 802.11n 4x4 phy core */
-#define	MIPS74K_CORE_ID		0x82c	/* mips 74k core */
-#define	GMAC_CORE_ID		0x82d	/* Gigabit MAC core */
-#define	DMEMC_CORE_ID		0x82e	/* DDR1/2 memory controller core */
-#define	PCIERC_CORE_ID		0x82f	/* PCIE Root Complex core */
-#define	OCP_CORE_ID		0x830	/* OCP2OCP bridge core */
-#define	SC_CORE_ID		0x831	/* shared common core */
-#define	AHB_CORE_ID		0x832	/* OCP2AHB bridge core */
-#define	SPIH_CORE_ID		0x833	/* SPI host core */
-#define	I2S_CORE_ID		0x834	/* I2S core */
-#define	DMEMS_CORE_ID		0x835	/* SDR/DDR1 memory controller core */
-#define	DEF_SHIM_COMP		0x837	/* SHIM component in ubus/6362 */
-#define OOB_ROUTER_CORE_ID	0x367	/* OOB router core ID */
-#define	DEF_AI_COMP		0xfff	/* Default component, in ai chips it
-					 * maps all unused address ranges
-					 */
-
 /* chipcommon being the first core: */
 #define	SI_CC_IDX		0
 
 /* SOC Interconnect types (aka chip types) */
 #define	SOCI_AI			1
 
-/* Common core control flags */
-#define	SICF_BIST_EN		0x8000
-#define	SICF_PME_EN		0x4000
-#define	SICF_CORE_BITS		0x3ffc
-#define	SICF_FGC		0x0002
-#define	SICF_CLOCK_EN		0x0001
-
-/* Common core status flags */
-#define	SISF_BIST_DONE		0x8000
-#define	SISF_BIST_ERROR		0x4000
-#define	SISF_GATED_CLK		0x2000
-#define	SISF_DMA64		0x1000
-#define	SISF_CORE_BITS		0x0fff
-
 /* A register that is common to all cores to
  * communicate w/PMU regarding clock control.
  */
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/dma.c b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
index b56a302..08960ce 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/dma.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
@@ -22,6 +22,7 @@
 #include <aiutils.h>
 #include "types.h"
 #include "dma.h"
+#include "soc.h"
 
 /*
  * DMA hardware requires each descriptor ring to be 8kB aligned, and fit within
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 77261ea..84f32b6 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -30,6 +30,7 @@
 #include "mac80211_if.h"
 #include "ucode_loader.h"
 #include "main.h"
+#include "soc.h"
 
 /*
  * Indication for txflowcontrol that all priority bits in
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
index cd19c2f..db612f8 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
@@ -29,6 +29,7 @@
 #include "phy_radio.h"
 #include "phyreg_n.h"
 #include "phytbl_n.h"
+#include "soc.h"
 
 #define READ_RADIO_REG2(pi, radio_type, jspace, core, reg_name)	\
 	read_radio_reg(pi, radio_type##_##jspace##_##reg_name |	\
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pmu.c b/drivers/net/wireless/brcm80211/brcmsmac/pmu.c
index 3b36e3a..12ba575 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pmu.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pmu.c
@@ -23,6 +23,7 @@
 #include "pub.h"
 #include "aiutils.h"
 #include "pmu.h"
+#include "soc.h"
 
 /*
  * external LPO crystal frequency
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/srom.c b/drivers/net/wireless/brcm80211/brcmsmac/srom.c
index 99f7910..b52b0d2 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/srom.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/srom.c
@@ -28,6 +28,7 @@
 #include "aiutils.h"
 #include "otp.h"
 #include "srom.h"
+#include "soc.h"
 
 /*
  * SROM CRC8 polynomial value:
diff --git a/drivers/net/wireless/brcm80211/include/soc.h b/drivers/net/wireless/brcm80211/include/soc.h
index 4fcb956..4e9b7e4 100644
--- a/drivers/net/wireless/brcm80211/include/soc.h
+++ b/drivers/net/wireless/brcm80211/include/soc.h
@@ -77,8 +77,9 @@
 #define	DMEMS_CORE_ID		0x835	/* SDR/DDR1 memory controller core */
 #define	DEF_SHIM_COMP		0x837	/* SHIM component in ubus/6362 */
 #define OOB_ROUTER_CORE_ID	0x367	/* OOB router core ID */
-/* Default component, in ai chips it maps all unused address ranges */
-#define	DEF_AI_COMP		0xfff
+#define	DEF_AI_COMP		0xfff	/* Default component, in ai chips it
+					 * maps all unused address ranges
+					 */
 
 /* Common core control flags */
 #define	SICF_BIST_EN		0x8000
@@ -87,4 +88,11 @@
 #define	SICF_FGC		0x0002
 #define	SICF_CLOCK_EN		0x0001
 
+/* Common core status flags */
+#define	SISF_BIST_DONE		0x8000
+#define	SISF_BIST_ERROR		0x4000
+#define	SISF_GATED_CLK		0x2000
+#define	SISF_DMA64		0x1000
+#define	SISF_CORE_BITS		0x0fff
+
 #endif				/* _BRCM_SOC_H */
-- 
1.7.4.1


