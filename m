Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802FA47C10A
	for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2026 07:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789629440; cv=none; b=WQxFx+bmRiDKfgBp26kS/7Q7hIXjCmtjlAVnwh0ay7IrnogoNFwSGxb2XwpgSQn+NkIfJnItBSlI14ozILfzTiys4reK5S+cyFAy/XVlVu/eW2r6EP5w3diy1vq3DN+4dCKok1fS1nt/Xs9w3QqI9GOMHF+x4j/3Cj7ZvBgaZhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789629440; c=relaxed/simple;
	bh=1aukcFfxP2xTPSo+V1VZA1XnEXHGrzpAEL7nHmU/G2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eLDeZoDErDVCByV5Jl4PbTxl2aSAxEcxtlqDvz9g66og4Okurkf+QroQZGYzv0chHFkCJ0FMFEDzDMWAtV2bj6ej7iCrZGmAf+lgKD0UFkL0CtdvL6gIWyY0xSPyKBE0te+D7/kKahZ7z1kuWng+J6P1iyArwEukmoosuLBSZOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Pah4tLmU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Pah4tLmU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789629437;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vPdusZxTyj8mitpC+u9jyzHi6BGB6YoFEK0SAz87ojo=;
	b=Pah4tLmUGLRjmUj/w7/CHN4qg38uX+B55+oQirC1QvEsLpvGg5x6PFl4f/tLO1yiyDqNbO
	iKbsEgr+UIxCcaeKKr+ws+V/byOcE38ZbhmG9uLQL6pBTHGlYrzzlAWiRqYVJK+2DX7lWy
	OE2L/nA8U26CU2s43HRcTRP5HJnht6I=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-81-OWl_W37vPJGlJSfexxtjow-1; Thu,
 17 Sep 2026 03:17:14 -0400
X-MC-Unique: OWl_W37vPJGlJSfexxtjow-1
X-Mimecast-MFC-AGG-ID: OWl_W37vPJGlJSfexxtjow_1789629432
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6AF7F1956049;
	Thu, 17 Sep 2026 07:17:12 +0000 (UTC)
Received: from fedora.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AAD37427;
	Thu, 17 Sep 2026 07:17:09 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: bhelgaas@google.com,
	alex@shazbot.org,
	mani@kernel.org
Cc: jjohnson@kernel.org,
	linux-pci@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	mhi@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Subject: [PATCH v14 2/2] PCI: Add device-specific reset for Qualcomm WCN6855/WCN7850 WLAN
Date: Thu, 17 Sep 2026 09:16:51 +0200
Message-ID: <20260917071651.14174-3-jtornosm@redhat.com>
In-Reply-To: <20260917071651.14174-1-jtornosm@redhat.com>
References: <20260917071651.14174-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

Qualcomm WCN6855 (17cb:1103) and WCN7850 (17cb:1107) WLAN devices lack
working reset methods for VFIO passthrough scenarios. These devices have no
FLR capability, advertise NoSoftRst+ (blocking PM reset), and have broken
bus reset (addressed by quirk_no_bus_reset, merged for v7.2).

VFIO attempts to reset devices on every reassignment. Without a working
reset method, the attempt fails. On clean VM shutdown, the guest driver
properly deinitializes the device via .shutdown/.remove callbacks, leaving
it in a usable state despite the failed reset. However, on unclean VM
termination (crash, force-off), the guest driver callbacks are not
triggered, the device remains in an undefined state (DMA active, interrupts
enabled, etc.), and without a working reset it cannot be reused.

Add a device-specific reset method using BAR-space hardware reset registers
that exist in these devices.

WCN6855/WCN7850 WLAN devices use SoC global reset via BAR0 (sequence from
ath11k/ath12k driver: ath11k_pci_soc_global_reset(), ath11k_pci_sw_reset(),
ath11k_mhi_set_mhictrl_reset()):
- Write/clear reset bit at offset 0x3008
- Wait for PCIe link recovery (up to 5 seconds)
- Clear MHI controller SYSERR status at offset 0x38

This is a true hardware reset mechanism (not power management or firmware
error recovery), providing proper device reset for VFIO scenarios.

Testing shows stable operation over 100+ VM crash/reset cycles, compared
to previous approaches that failed after ~30 cycles. Device-specific reset
is position #1 in the reset hierarchy, so these Qualcomm devices will use
hardware reset as their primary reset method.

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
---
v14: Address Bjorn Helgaas feedback:
  - Split WLAN and modem resets into two separate patches
  - Clarify commit message: VFIO resets on every reassignment, clean
    shutdown leaves device in usable state via driver callbacks, but
    unclean termination is where the lack of reset is critical
  - No code changes from v13, only patch split and commit message
    clarification (Mani's Reviewed-by retained)
v13: https://lore.kernel.org/all/20260915223634.GA878346@bhelgaas/

 drivers/pci/quirks.c | 76 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index e72af7d2c775..e800dd517614 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -22,6 +22,7 @@
 #include <linux/isa-dma.h> /* isa_dma_bridge_buggy */
 #include <linux/init.h>
 #include <linux/iommu.h>
+#include <linux/iopoll.h>
 #include <linux/delay.h>
 #include <linux/acpi.h>
 #include <linux/dmi.h>
@@ -4230,6 +4231,79 @@ static int reset_hinic_vf_dev(struct pci_dev *pdev, bool probe)
 	return 0;
 }
 
+#define QUALCOMM_WLAN_PCIE_SOC_GLOBAL_RESET	0x3008
+#define QUALCOMM_WLAN_PCIE_SOC_GLOBAL_RESET_V	BIT(0)
+#define QUALCOMM_WLAN_MHICTRL			0x38
+#define QUALCOMM_WLAN_MHICTRL_RESET_MASK	0x2
+
+/*
+ * Qualcomm WLAN device-specific reset using SoC global reset via BAR0
+ * registers.
+ */
+static int reset_qualcomm_wlan(struct pci_dev *pdev, bool probe)
+{
+	void __iomem *bar;
+	u32 val;
+	u16 cmd;
+	int ret;
+
+	if (probe)
+		return 0;
+
+	if (pdev->current_state != PCI_D0)
+		return -EINVAL;
+
+	pci_read_config_word(pdev, PCI_COMMAND, &cmd);
+	pci_write_config_word(pdev, PCI_COMMAND, cmd | PCI_COMMAND_MEMORY);
+
+	bar = pci_iomap(pdev, 0, 0);
+	if (!bar) {
+		pci_write_config_word(pdev, PCI_COMMAND, cmd);
+		return -ENODEV;
+	}
+
+	val = ioread32(bar + QUALCOMM_WLAN_PCIE_SOC_GLOBAL_RESET);
+	if (PCI_POSSIBLE_ERROR(val)) {
+		ret = -ENODEV;
+		goto out_restore;
+	}
+	val |= QUALCOMM_WLAN_PCIE_SOC_GLOBAL_RESET_V;
+	iowrite32(val, bar + QUALCOMM_WLAN_PCIE_SOC_GLOBAL_RESET);
+	ioread32(bar + QUALCOMM_WLAN_PCIE_SOC_GLOBAL_RESET);
+
+	msleep(10);
+
+	val &= ~QUALCOMM_WLAN_PCIE_SOC_GLOBAL_RESET_V;
+	iowrite32(val, bar + QUALCOMM_WLAN_PCIE_SOC_GLOBAL_RESET);
+	ioread32(bar + QUALCOMM_WLAN_PCIE_SOC_GLOBAL_RESET);
+
+	msleep(10);
+
+	ret = read_poll_timeout(ioread32, val,
+				!PCI_POSSIBLE_ERROR(val),
+				20 * USEC_PER_MSEC,
+				5 * USEC_PER_SEC, false,
+				bar + QUALCOMM_WLAN_PCIE_SOC_GLOBAL_RESET);
+	if (ret) {
+		pci_err(pdev, "PCIe link failed to recover after reset\n");
+		goto out_restore;
+	}
+
+	/* After SOC_GLOBAL_RESET, MHISTATUS may still have SYSERR bit set
+	 * and thus need to set MHICTRL_RESET to clear SYSERR.
+	 */
+	iowrite32(QUALCOMM_WLAN_MHICTRL_RESET_MASK, bar + QUALCOMM_WLAN_MHICTRL);
+	ioread32(bar + QUALCOMM_WLAN_MHICTRL);
+
+	msleep(10);
+
+out_restore:
+	pci_iounmap(pdev, bar);
+	pci_write_config_word(pdev, PCI_COMMAND, cmd);
+
+	return ret;
+}
+
 #define MHI_SOC_RESET_REQ_OFFSET		0xb0
 #define MHI_SOC_RESET_REQ			BIT(0)
 
@@ -4285,6 +4359,8 @@ static const struct pci_dev_reset_methods pci_dev_reset_methods[] = {
 	{ PCI_VENDOR_ID_HUAWEI, PCI_DEVICE_ID_HINIC_VF,
 		reset_hinic_vf_dev },
 	{ PCI_VENDOR_ID_QCOM, 0x0308, reset_qualcomm_modem }, /* SDX62/SDX65 modems */
+	{ PCI_VENDOR_ID_QCOM, 0x1103, reset_qualcomm_wlan },  /* WCN6855 WLAN */
+	{ PCI_VENDOR_ID_QCOM, 0x1107, reset_qualcomm_wlan },  /* WCN7850 WLAN */
 	{ 0 }
 };
 
-- 
2.54.0

