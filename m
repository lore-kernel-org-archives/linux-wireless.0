Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:26000 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbbH0OOS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2015 10:14:18 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Rafal Milecki <zajec5@gmail.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH] brcmfmac: Reset PCIE devices after recognition.
Date: Thu, 27 Aug 2015 16:14:06 +0200
Message-ID: <1440684846-17214-1-git-send-email-arend@broadcom.com> (sfid-20150827_161422_653704_A7C4D71A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

When PCIE type devices are being FW reloaded without being properly
reset then the device ends up in a locked state, requiring the
device to be completely powered down. This patch adds a reset
through watchdog at the moment the device (cores) has been
recognized. This will solve warm reboot issues.

Cc: Rafal Milecki <zajec5@gmail.com>
Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
Hi Kalle,

One more patch (probably for 4.4) which has been tested by
Rafal. The post is mainly to make the patch publicly available
for him to use in OpenWrt.

Regards,
Arend
---
 drivers/net/wireless/brcm80211/brcmfmac/chip.c | 18 +++++++
 drivers/net/wireless/brcm80211/brcmfmac/chip.h |  1 +
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c | 66 ++++++++++++++++++--------
 3 files changed, 64 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
index 288f831..e3b8e23 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
@@ -101,6 +101,9 @@
 /* ARM Cortex M3 core, ID 0x82a */
 #define BCM4329_CORE_ARM_BASE		0x18002000
 
+/* Max possibly supported memory size (limited by IO mapped memory) */
+#define BRCMF_CHIP_MAX_MEMSIZE		(4 * 1024 * 1024)
+
 #define CORE_SB(base, field) \
 		(base + SBCONFIGOFF + offsetof(struct sbconfig, field))
 #define	SBCOREREV(sbidh) \
@@ -687,6 +690,12 @@ static int brcmf_chip_get_raminfo(struct brcmf_chip_priv *ci)
 		brcmf_err("RAM size is undetermined\n");
 		return -ENOMEM;
 	}
+
+	if (ci->pub.ramsize > BRCMF_CHIP_MAX_MEMSIZE) {
+		brcmf_err("RAM size is incorrect\n");
+		return -ENOMEM;
+	}
+
 	return 0;
 }
 
@@ -899,6 +908,15 @@ static int brcmf_chip_recognition(struct brcmf_chip_priv *ci)
 
 	/* assure chip is passive for core access */
 	brcmf_chip_set_passive(&ci->pub);
+
+	/* Call bus specific reset function now. Cores have been determined
+	 * but further access may require a chip specific reset at this point.
+	 */
+	if (ci->ops->reset) {
+		ci->ops->reset(ci->ctx, &ci->pub);
+		brcmf_chip_set_passive(&ci->pub);
+	}
+
 	return brcmf_chip_get_raminfo(ci);
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/chip.h b/drivers/net/wireless/brcm80211/brcmfmac/chip.h
index 60dcb38..f6b5fee 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/chip.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/chip.h
@@ -73,6 +73,7 @@ struct brcmf_buscore_ops {
 	u32 (*read32)(void *ctx, u32 addr);
 	void (*write32)(void *ctx, u32 addr, u32 value);
 	int (*prepare)(void *ctx);
+	int (*reset)(void *ctx, struct brcmf_chip *chip);
 	int (*setup)(void *ctx, struct brcmf_chip *chip);
 	void (*activate)(void *ctx, struct brcmf_chip *chip, u32 rstvec);
 };
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
index 3a98c43..373fe8d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
@@ -74,6 +74,8 @@ enum brcmf_pcie_state {
 #define BRCMF_PCIE_REG_INTMASK			0x94
 #define BRCMF_PCIE_REG_SBMBX			0x98
 
+#define BRCMF_PCIE_REG_LINK_STATUS_CTRL		0xBC
+
 #define BRCMF_PCIE_PCIE2REG_INTMASK		0x24
 #define BRCMF_PCIE_PCIE2REG_MAILBOXINT		0x48
 #define BRCMF_PCIE_PCIE2REG_MAILBOXMASK		0x4C
@@ -466,6 +468,7 @@ brcmf_pcie_select_core(struct brcmf_pciedev_info *devinfo, u16 coreid)
 
 static void brcmf_pcie_reset_device(struct brcmf_pciedev_info *devinfo)
 {
+	struct brcmf_core *core;
 	u16 cfg_offset[] = { BRCMF_PCIE_CFGREG_STATUS_CMD,
 			     BRCMF_PCIE_CFGREG_PM_CSR,
 			     BRCMF_PCIE_CFGREG_MSI_CAP,
@@ -484,32 +487,38 @@ static void brcmf_pcie_reset_device(struct brcmf_pciedev_info *devinfo)
 	if (!devinfo->ci)
 		return;
 
+	/* Disable ASPM */
 	brcmf_pcie_select_core(devinfo, BCMA_CORE_PCIE2);
-	brcmf_pcie_write_reg32(devinfo, BRCMF_PCIE_PCIE2REG_CONFIGADDR,
-			       BRCMF_PCIE_CFGREG_LINK_STATUS_CTRL);
-	lsc = brcmf_pcie_read_reg32(devinfo, BRCMF_PCIE_PCIE2REG_CONFIGDATA);
+	pci_read_config_dword(devinfo->pdev, BRCMF_PCIE_REG_LINK_STATUS_CTRL,
+			      &lsc);
 	val = lsc & (~BRCMF_PCIE_LINK_STATUS_CTRL_ASPM_ENAB);
-	brcmf_pcie_write_reg32(devinfo, BRCMF_PCIE_PCIE2REG_CONFIGDATA, val);
+	pci_write_config_dword(devinfo->pdev, BRCMF_PCIE_REG_LINK_STATUS_CTRL,
+			       val);
 
+	/* Watchdog reset */
 	brcmf_pcie_select_core(devinfo, BCMA_CORE_CHIPCOMMON);
 	WRITECC32(devinfo, watchdog, 4);
 	msleep(100);
 
+	/* Restore ASPM */
 	brcmf_pcie_select_core(devinfo, BCMA_CORE_PCIE2);
-	brcmf_pcie_write_reg32(devinfo, BRCMF_PCIE_PCIE2REG_CONFIGADDR,
-			       BRCMF_PCIE_CFGREG_LINK_STATUS_CTRL);
-	brcmf_pcie_write_reg32(devinfo, BRCMF_PCIE_PCIE2REG_CONFIGDATA, lsc);
-
-	brcmf_pcie_select_core(devinfo, BCMA_CORE_PCIE2);
-	for (i = 0; i < ARRAY_SIZE(cfg_offset); i++) {
-		brcmf_pcie_write_reg32(devinfo, BRCMF_PCIE_PCIE2REG_CONFIGADDR,
-				       cfg_offset[i]);
-		val = brcmf_pcie_read_reg32(devinfo,
-					    BRCMF_PCIE_PCIE2REG_CONFIGDATA);
-		brcmf_dbg(PCIE, "config offset 0x%04x, value 0x%04x\n",
-			  cfg_offset[i], val);
-		brcmf_pcie_write_reg32(devinfo, BRCMF_PCIE_PCIE2REG_CONFIGDATA,
-				       val);
+	pci_write_config_dword(devinfo->pdev, BRCMF_PCIE_REG_LINK_STATUS_CTRL,
+			       lsc);
+
+	core = brcmf_chip_get_core(devinfo->ci, BCMA_CORE_PCIE2);
+	if (core->rev <= 13) {
+		for (i = 0; i < ARRAY_SIZE(cfg_offset); i++) {
+			brcmf_pcie_write_reg32(devinfo,
+					       BRCMF_PCIE_PCIE2REG_CONFIGADDR,
+					       cfg_offset[i]);
+			val = brcmf_pcie_read_reg32(devinfo,
+				BRCMF_PCIE_PCIE2REG_CONFIGDATA);
+			brcmf_dbg(PCIE, "config offset 0x%04x, value 0x%04x\n",
+				  cfg_offset[i], val);
+			brcmf_pcie_write_reg32(devinfo,
+					       BRCMF_PCIE_PCIE2REG_CONFIGDATA,
+					       val);
+		}
 	}
 }
 
@@ -519,8 +528,6 @@ static void brcmf_pcie_attach(struct brcmf_pciedev_info *devinfo)
 	u32 config;
 
 	brcmf_pcie_select_core(devinfo, BCMA_CORE_PCIE2);
-	if (brcmf_pcie_read_reg32(devinfo, BRCMF_PCIE_PCIE2REG_INTMASK) != 0)
-		brcmf_pcie_reset_device(devinfo);
 	/* BAR1 window may not be sized properly */
 	brcmf_pcie_select_core(devinfo, BCMA_CORE_PCIE2);
 	brcmf_pcie_write_reg32(devinfo, BRCMF_PCIE_PCIE2REG_CONFIGADDR, 0x4e0);
@@ -1633,6 +1640,23 @@ static int brcmf_pcie_buscoreprep(void *ctx)
 }
 
 
+static int brcmf_pcie_buscore_reset(void *ctx, struct brcmf_chip *chip)
+{
+	struct brcmf_pciedev_info *devinfo = (struct brcmf_pciedev_info *)ctx;
+	u32 val;
+
+	devinfo->ci = chip;
+	brcmf_pcie_reset_device(devinfo);
+
+	val = brcmf_pcie_read_reg32(devinfo, BRCMF_PCIE_PCIE2REG_MAILBOXINT);
+	if (val != 0xffffffff)
+		brcmf_pcie_write_reg32(devinfo, BRCMF_PCIE_PCIE2REG_MAILBOXINT,
+				       val);
+
+	return 0;
+}
+
+
 static void brcmf_pcie_buscore_activate(void *ctx, struct brcmf_chip *chip,
 					u32 rstvec)
 {
@@ -1644,6 +1668,7 @@ static void brcmf_pcie_buscore_activate(void *ctx, struct brcmf_chip *chip,
 
 static const struct brcmf_buscore_ops brcmf_pcie_buscore_ops = {
 	.prepare = brcmf_pcie_buscoreprep,
+	.reset = brcmf_pcie_buscore_reset,
 	.activate = brcmf_pcie_buscore_activate,
 	.read32 = brcmf_pcie_buscore_read32,
 	.write32 = brcmf_pcie_buscore_write32,
@@ -1811,7 +1836,6 @@ brcmf_pcie_remove(struct pci_dev *pdev)
 		brcmf_pcie_intr_disable(devinfo);
 
 	brcmf_detach(&pdev->dev);
-	brcmf_pcie_reset_device(devinfo);
 
 	kfree(bus->bus_priv.pcie);
 	kfree(bus->msgbuf->flowrings);
-- 
1.9.1

