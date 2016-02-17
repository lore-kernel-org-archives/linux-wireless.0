Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 5520-maca-inet1-outside.broadcom.com ([216.31.211.11]:32795
	"EHLO mail-irv-18.broadcom.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161111AbcBQK11 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2016 05:27:27 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 11/21] brcmfmac: remove pcie gen1 support
Date: Wed, 17 Feb 2016 11:27:00 +0100
Message-Id: <1455704830-10088-12-git-send-email-arend@broadcom.com> (sfid-20160217_112835_442054_8FEDFB49)
In-Reply-To: <1455704830-10088-1-git-send-email-arend@broadcom.com>
References: <1455704830-10088-1-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

The PCIE bus driver supports older gen1 (v1) chips, but there is no
actual device which is using this older pcie core which is supported
by brcmfmac. Remove all gen1 related code.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    | 135 +++------------------
 1 file changed, 20 insertions(+), 115 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 3cb32b7..1866b66 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -100,9 +100,6 @@ static struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
 #define BRCMF_PCIE_PCIE2REG_CONFIGDATA		0x124
 #define BRCMF_PCIE_PCIE2REG_H2D_MAILBOX		0x140
 
-#define BRCMF_PCIE_GENREV1			1
-#define BRCMF_PCIE_GENREV2			2
-
 #define BRCMF_PCIE2_INTA			0x01
 #define BRCMF_PCIE2_INTB			0x02
 
@@ -257,9 +254,7 @@ struct brcmf_pciedev_info {
 	u32 ram_size;
 	struct brcmf_chip *ci;
 	u32 coreid;
-	u32 generic_corerev;
 	struct brcmf_pcie_shared_info shared;
-	void (*ringbell)(struct brcmf_pciedev_info *devinfo);
 	wait_queue_head_t mbdata_resp_wait;
 	bool mbdata_completed;
 	bool irq_allocated;
@@ -746,68 +741,22 @@ static void brcmf_pcie_bus_console_read(struct brcmf_pciedev_info *devinfo)
 }
 
 
-static __used void brcmf_pcie_ringbell_v1(struct brcmf_pciedev_info *devinfo)
-{
-	u32 reg_value;
-
-	brcmf_dbg(PCIE, "RING !\n");
-	reg_value = brcmf_pcie_read_reg32(devinfo,
-					  BRCMF_PCIE_PCIE2REG_MAILBOXINT);
-	reg_value |= BRCMF_PCIE2_INTB;
-	brcmf_pcie_write_reg32(devinfo, BRCMF_PCIE_PCIE2REG_MAILBOXINT,
-			       reg_value);
-}
-
-
-static void brcmf_pcie_ringbell_v2(struct brcmf_pciedev_info *devinfo)
-{
-	brcmf_dbg(PCIE, "RING !\n");
-	/* Any arbitrary value will do, lets use 1 */
-	brcmf_pcie_write_reg32(devinfo, BRCMF_PCIE_PCIE2REG_H2D_MAILBOX, 1);
-}
-
-
 static void brcmf_pcie_intr_disable(struct brcmf_pciedev_info *devinfo)
 {
-	if (devinfo->generic_corerev == BRCMF_PCIE_GENREV1)
-		pci_write_config_dword(devinfo->pdev, BRCMF_PCIE_REG_INTMASK,
-				       0);
-	else
-		brcmf_pcie_write_reg32(devinfo, BRCMF_PCIE_PCIE2REG_MAILBOXMASK,
-				       0);
+	brcmf_pcie_write_reg32(devinfo, BRCMF_PCIE_PCIE2REG_MAILBOXMASK, 0);
 }
 
 
 static void brcmf_pcie_intr_enable(struct brcmf_pciedev_info *devinfo)
 {
-	if (devinfo->generic_corerev == BRCMF_PCIE_GENREV1)
-		pci_write_config_dword(devinfo->pdev, BRCMF_PCIE_REG_INTMASK,
-				       BRCMF_PCIE_INT_DEF);
-	else
-		brcmf_pcie_write_reg32(devinfo, BRCMF_PCIE_PCIE2REG_MAILBOXMASK,
-				       BRCMF_PCIE_MB_INT_D2H_DB |
-				       BRCMF_PCIE_MB_INT_FN0_0 |
-				       BRCMF_PCIE_MB_INT_FN0_1);
+	brcmf_pcie_write_reg32(devinfo, BRCMF_PCIE_PCIE2REG_MAILBOXMASK,
+			       BRCMF_PCIE_MB_INT_D2H_DB |
+			       BRCMF_PCIE_MB_INT_FN0_0 |
+			       BRCMF_PCIE_MB_INT_FN0_1);
 }
 
 
-static irqreturn_t brcmf_pcie_quick_check_isr_v1(int irq, void *arg)
-{
-	struct brcmf_pciedev_info *devinfo = (struct brcmf_pciedev_info *)arg;
-	u32 status;
-
-	status = 0;
-	pci_read_config_dword(devinfo->pdev, BRCMF_PCIE_REG_INTSTATUS, &status);
-	if (status) {
-		brcmf_pcie_intr_disable(devinfo);
-		brcmf_dbg(PCIE, "Enter\n");
-		return IRQ_WAKE_THREAD;
-	}
-	return IRQ_NONE;
-}
-
-
-static irqreturn_t brcmf_pcie_quick_check_isr_v2(int irq, void *arg)
+static irqreturn_t brcmf_pcie_quick_check_isr(int irq, void *arg)
 {
 	struct brcmf_pciedev_info *devinfo = (struct brcmf_pciedev_info *)arg;
 
@@ -820,29 +769,7 @@ static irqreturn_t brcmf_pcie_quick_check_isr_v2(int irq, void *arg)
 }
 
 
-static irqreturn_t brcmf_pcie_isr_thread_v1(int irq, void *arg)
-{
-	struct brcmf_pciedev_info *devinfo = (struct brcmf_pciedev_info *)arg;
-	const struct pci_dev *pdev = devinfo->pdev;
-	u32 status;
-
-	devinfo->in_irq = true;
-	status = 0;
-	pci_read_config_dword(pdev, BRCMF_PCIE_REG_INTSTATUS, &status);
-	brcmf_dbg(PCIE, "Enter %x\n", status);
-	if (status) {
-		pci_write_config_dword(pdev, BRCMF_PCIE_REG_INTSTATUS, status);
-		if (devinfo->state == BRCMFMAC_PCIE_STATE_UP)
-			brcmf_proto_msgbuf_rx_trigger(&devinfo->pdev->dev);
-	}
-	if (devinfo->state == BRCMFMAC_PCIE_STATE_UP)
-		brcmf_pcie_intr_enable(devinfo);
-	devinfo->in_irq = false;
-	return IRQ_HANDLED;
-}
-
-
-static irqreturn_t brcmf_pcie_isr_thread_v2(int irq, void *arg)
+static irqreturn_t brcmf_pcie_isr_thread(int irq, void *arg)
 {
 	struct brcmf_pciedev_info *devinfo = (struct brcmf_pciedev_info *)arg;
 	u32 status;
@@ -879,28 +806,14 @@ static int brcmf_pcie_request_irq(struct brcmf_pciedev_info *devinfo)
 	brcmf_pcie_intr_disable(devinfo);
 
 	brcmf_dbg(PCIE, "Enter\n");
-	/* is it a v1 or v2 implementation */
+
 	pci_enable_msi(pdev);
-	if (devinfo->generic_corerev == BRCMF_PCIE_GENREV1) {
-		if (request_threaded_irq(pdev->irq,
-					 brcmf_pcie_quick_check_isr_v1,
-					 brcmf_pcie_isr_thread_v1,
-					 IRQF_SHARED, "brcmf_pcie_intr",
-					 devinfo)) {
-			pci_disable_msi(pdev);
-			brcmf_err("Failed to request IRQ %d\n", pdev->irq);
-			return -EIO;
-		}
-	} else {
-		if (request_threaded_irq(pdev->irq,
-					 brcmf_pcie_quick_check_isr_v2,
-					 brcmf_pcie_isr_thread_v2,
-					 IRQF_SHARED, "brcmf_pcie_intr",
-					 devinfo)) {
-			pci_disable_msi(pdev);
-			brcmf_err("Failed to request IRQ %d\n", pdev->irq);
-			return -EIO;
-		}
+	if (request_threaded_irq(pdev->irq, brcmf_pcie_quick_check_isr,
+				 brcmf_pcie_isr_thread, IRQF_SHARED,
+				 "brcmf_pcie_intr", devinfo)) {
+		pci_disable_msi(pdev);
+		brcmf_err("Failed to request IRQ %d\n", pdev->irq);
+		return -EIO;
 	}
 	devinfo->irq_allocated = true;
 	return 0;
@@ -931,16 +844,9 @@ static void brcmf_pcie_release_irq(struct brcmf_pciedev_info *devinfo)
 	if (devinfo->in_irq)
 		brcmf_err("Still in IRQ (processing) !!!\n");
 
-	if (devinfo->generic_corerev == BRCMF_PCIE_GENREV1) {
-		status = 0;
-		pci_read_config_dword(pdev, BRCMF_PCIE_REG_INTSTATUS, &status);
-		pci_write_config_dword(pdev, BRCMF_PCIE_REG_INTSTATUS, status);
-	} else {
-		status = brcmf_pcie_read_reg32(devinfo,
-					       BRCMF_PCIE_PCIE2REG_MAILBOXINT);
-		brcmf_pcie_write_reg32(devinfo, BRCMF_PCIE_PCIE2REG_MAILBOXINT,
-				       status);
-	}
+	status = brcmf_pcie_read_reg32(devinfo, BRCMF_PCIE_PCIE2REG_MAILBOXINT);
+	brcmf_pcie_write_reg32(devinfo, BRCMF_PCIE_PCIE2REG_MAILBOXINT, status);
+
 	devinfo->irq_allocated = false;
 }
 
@@ -989,7 +895,9 @@ static int brcmf_pcie_ring_mb_ring_bell(void *ctx)
 	if (devinfo->state != BRCMFMAC_PCIE_STATE_UP)
 		return -EIO;
 
-	devinfo->ringbell(devinfo);
+	brcmf_dbg(PCIE, "RING !\n");
+	/* Any arbitrary value will do, lets use 1 */
+	brcmf_pcie_write_reg32(devinfo, BRCMF_PCIE_PCIE2REG_H2D_MAILBOX, 1);
 
 	return 0;
 }
@@ -1503,9 +1411,6 @@ static int brcmf_pcie_download_fw_nvram(struct brcmf_pciedev_info *devinfo,
 	u32 address;
 	u32 resetintr;
 
-	devinfo->ringbell = brcmf_pcie_ringbell_v2;
-	devinfo->generic_corerev = BRCMF_PCIE_GENREV2;
-
 	brcmf_dbg(PCIE, "Halt ARM.\n");
 	err = brcmf_pcie_enter_download_state(devinfo);
 	if (err)
-- 
1.9.1

