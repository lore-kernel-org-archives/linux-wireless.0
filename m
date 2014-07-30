Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:30255 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbaG3LUP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2014 07:20:15 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 6/8] brcmfmac: Update pcie reset device routine.
Date: Wed, 30 Jul 2014 13:20:05 +0200
Message-ID: <1406719207-5126-7-git-send-email-arend@broadcom.com> (sfid-20140730_132024_535527_085F71F6)
In-Reply-To: <1406719207-5126-1-git-send-email-arend@broadcom.com>
References: <1406719207-5126-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

When a pcie device gets reset then the low power modes l1 and l2
should be temporarily disabled.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c | 49 ++++++++++++++++++++++----
 1 file changed, 42 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
index 89be96d..bc972c0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
@@ -168,6 +168,20 @@ enum brcmf_pcie_state {
 
 #define BRCMF_PCIE_MBDATA_TIMEOUT		2000
 
+#define BRCMF_PCIE_CFGREG_STATUS_CMD		0x4
+#define BRCMF_PCIE_CFGREG_PM_CSR		0x4C
+#define BRCMF_PCIE_CFGREG_MSI_CAP		0x58
+#define BRCMF_PCIE_CFGREG_MSI_ADDR_L		0x5C
+#define BRCMF_PCIE_CFGREG_MSI_ADDR_H		0x60
+#define BRCMF_PCIE_CFGREG_MSI_DATA		0x64
+#define BRCMF_PCIE_CFGREG_LINK_STATUS_CTRL	0xBC
+#define BRCMF_PCIE_CFGREG_LINK_STATUS_CTRL2	0xDC
+#define BRCMF_PCIE_CFGREG_RBAR_CTRL		0x228
+#define BRCMF_PCIE_CFGREG_PML1_SUB_CTRL1	0x248
+#define BRCMF_PCIE_CFGREG_REG_BAR2_CONFIG	0x4E0
+#define BRCMF_PCIE_CFGREG_REG_BAR3_CONFIG	0x4F4
+#define BRCMF_PCIE_LINK_STATUS_CTRL_ASPM_ENAB	3
+
 
 MODULE_FIRMWARE(BRCMF_PCIE_43602_FW_NAME);
 MODULE_FIRMWARE(BRCMF_PCIE_43602_NVRAM_NAME);
@@ -423,22 +437,43 @@ brcmf_pcie_select_core(struct brcmf_pciedev_info *devinfo, u16 coreid)
 }
 
 
-static void brcmf_pcie_detach(struct brcmf_pciedev_info *devinfo)
+static void brcmf_pcie_reset_device(struct brcmf_pciedev_info *devinfo)
 {
-	u16 cfg_offset[] = { 0x4,  0x4C, 0x58, 0x5C, 0x60, 0x64, 0xDC, 0x228,
-			     0x248,  0x4e0, 0x4f4 };
+	u16 cfg_offset[] = { BRCMF_PCIE_CFGREG_STATUS_CMD,
+			     BRCMF_PCIE_CFGREG_PM_CSR,
+			     BRCMF_PCIE_CFGREG_MSI_CAP,
+			     BRCMF_PCIE_CFGREG_MSI_ADDR_L,
+			     BRCMF_PCIE_CFGREG_MSI_ADDR_H,
+			     BRCMF_PCIE_CFGREG_MSI_DATA,
+			     BRCMF_PCIE_CFGREG_LINK_STATUS_CTRL2,
+			     BRCMF_PCIE_CFGREG_RBAR_CTRL,
+			     BRCMF_PCIE_CFGREG_PML1_SUB_CTRL1,
+			     BRCMF_PCIE_CFGREG_REG_BAR2_CONFIG,
+			     BRCMF_PCIE_CFGREG_REG_BAR3_CONFIG };
 	u32 i;
 	u32 val;
+	u32 lsc;
 
 	if (!devinfo->ci)
 		return;
 
-	brcmf_pcie_select_core(devinfo, BCMA_CORE_CHIPCOMMON);
-	WRITECC32(devinfo, watchdog, 0x4e0);
+	brcmf_pcie_select_core(devinfo, BCMA_CORE_PCIE2);
+	brcmf_pcie_write_reg32(devinfo, BRCMF_PCIE_PCIE2REG_CONFIGADDR,
+			       BRCMF_PCIE_CFGREG_LINK_STATUS_CTRL);
+	lsc = brcmf_pcie_read_reg32(devinfo, BRCMF_PCIE_PCIE2REG_CONFIGDATA);
+	val = lsc & (~BRCMF_PCIE_LINK_STATUS_CTRL_ASPM_ENAB);
+	brcmf_pcie_write_reg32(devinfo, BRCMF_PCIE_PCIE2REG_CONFIGDATA, val);
 
+	brcmf_pcie_select_core(devinfo, BCMA_CORE_CHIPCOMMON);
+	WRITECC32(devinfo, watchdog, 4);
 	msleep(100);
 
 	brcmf_pcie_select_core(devinfo, BCMA_CORE_PCIE2);
+	brcmf_pcie_write_reg32(devinfo, BRCMF_PCIE_PCIE2REG_CONFIGADDR,
+			       BRCMF_PCIE_CFGREG_LINK_STATUS_CTRL);
+	brcmf_pcie_write_reg32(devinfo, BRCMF_PCIE_PCIE2REG_CONFIGDATA, lsc);
+
+	brcmf_pcie_select_core(devinfo, BCMA_CORE_PCIE2);
 	for (i = 0; i < ARRAY_SIZE(cfg_offset); i++) {
 		brcmf_pcie_write_reg32(devinfo, BRCMF_PCIE_PCIE2REG_CONFIGADDR,
 				       cfg_offset[i]);
@@ -458,7 +493,7 @@ static void brcmf_pcie_attach(struct brcmf_pciedev_info *devinfo)
 
 	brcmf_pcie_select_core(devinfo, BCMA_CORE_PCIE2);
 	if (brcmf_pcie_read_reg32(devinfo, BRCMF_PCIE_PCIE2REG_INTMASK) != 0)
-		brcmf_pcie_detach(devinfo);
+		brcmf_pcie_reset_device(devinfo);
 	/* BAR1 window may not be sized properly */
 	brcmf_pcie_select_core(devinfo, BCMA_CORE_PCIE2);
 	brcmf_pcie_write_reg32(devinfo, BRCMF_PCIE_PCIE2REG_CONFIGADDR, 0x4e0);
@@ -1686,7 +1721,7 @@ brcmf_pcie_remove(struct pci_dev *pdev)
 	brcmf_pcie_release_irq(devinfo);
 	brcmf_pcie_release_scratchbuffers(devinfo);
 	brcmf_pcie_release_ringbuffers(devinfo);
-	brcmf_pcie_detach(devinfo);
+	brcmf_pcie_reset_device(devinfo);
 	brcmf_pcie_release_resource(devinfo);
 
 	if (devinfo->ci)
-- 
1.9.1

