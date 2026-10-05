Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D7D47CA71
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 10:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791197705; cv=none; b=hssysdRS+/jBY49fwvAEIVKvxPtNSu+fjFH3tE6Yn06H37R/tVfM5JL7hVfvmNTtlg59KzFNlY+9RL1zMLITkR8Wl0Kd0QPYRSVVo7UhfzCBwXqWQBBmI/B6X6LCItjS3RE61TdMviJcTyuG4OGDqwO4fd03ahNy58tnX/uIkm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791197705; c=relaxed/simple;
	bh=od1UJ0jb5KsOvoKRkADeqS01/nDsVG6KedXeLWdWlUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nTV/bSs/ucO1cmloQ09fmjE5KFcsAVRQxCcPK65lP8vzJ4kav437VnMBWYtz7wfv++HJKpyGbAd1KgYpMFBf51rIwenAW7SgTjna0oHDhHtR4sR0pE+aq0nZxdZJloDNdN9kDKp7dWePglHWSEIYiygSMyjxeuWPr2d3hgZmNAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bsrrG8Rp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bsrrG8Rp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791197702;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/+fZ4tkxAhsRlZKdZeMrprE3kIM5heVV5x1LvJR9F+0=;
	b=bsrrG8RpdwpI8cqzvIkykUTeeze8HE5soNwrScuOeoxzgDDl/kjV6z5lpxf8QCt44Z6g+9
	AswSFkgEBlqxfBYDAjaZnO8h+N7ghL93Z3lKaRTtCw/BniIT8S+yKLwq1EpaZ3Un91VXty
	e2UFguO/CRirVWwpBQRbV8hGUN7VfsM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-3-yDCbDQ_zOPO44zyDm5S0tw-1; Mon,
 05 Oct 2026 06:54:58 -0400
X-MC-Unique: yDCbDQ_zOPO44zyDm5S0tw-1
X-Mimecast-MFC-AGG-ID: yDCbDQ_zOPO44zyDm5S0tw_1791197696
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 97E8B19540F2;
	Mon,  5 Oct 2026 10:54:56 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B0A641800446;
	Mon,  5 Oct 2026 10:54:53 +0000 (UTC)
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
Subject: [PATCH v15 2/2] PCI: Add device-specific reset for Qualcomm WCN6855/WCN7850 WLAN
Date: Mon,  5 Oct 2026 12:54:36 +0200
Message-ID: <20261005105436.83962-3-jtornosm@redhat.com>
In-Reply-To: <20261005105436.83962-1-jtornosm@redhat.com>
References: <20261005105436.83962-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Qualcomm WCN6855 (17cb:1103) and WCN7850 (17cb:1107) WLAN devices lack
working reset methods for VFIO passthrough scenarios. These devices have no
FLR capability, advertise NoSoftRst+ (blocking PM reset), and have broken
bus reset.

Standard reset methods were already disabled for these devices by commit
6a4f64c3a3ad ("PCI: Avoid SBR for Qualcomm WCN6855/WCN7850 WiFi,
SDX62/SDX65 modems") because they were not working (quirk_no_bus_reset).

Resets of this device always failed prior to this commit, so VFIO on
the host could not enforce isolation between successive passthrough
users.

If a guest driver deinitialized the device, it may have been functional
if passed through to a subsequent guest, despite the lack of isolation.
Otherwise the device may have been left in an undefined state (e.g., DMA
and interrupts active) and unusable.

Add a device-specific reset method using BAR-space hardware reset
registers that exist in these devices.

WCN6855/WCN7850 WLAN devices use SoC global reset via BAR0 (sequence from
ath11k/ath12k driver: ath11k_pci_soc_global_reset(), ath11k_pci_sw_reset(),
ath11k_mhi_set_mhictrl_reset()):
- Write/clear reset bit at offset 0x3008
- Wait for PCIe link recovery (up to 5 seconds)
- Clear MHI controller SYSERR status at offset 0x38

These are true hardware reset mechanisms (not power management or firmware
error recovery), providing proper device reset for VFIO scenarios.

Testing shows stable operation over 100+ VM crash/reset cycles, compared
to previous approaches that failed after ~30 cycles. Device-specific reset
is position #1 in the reset hierarchy, so these Qualcomm devices will use
hardware reset as their primary reset method.

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Acked-by: Alex Williamson <alex@shazbot.org>
---
v15: Address Bjorn Helgaas feedback:
  - Explain the relationship with 6a4f64c3a3ad ("PCI: Avoid SBR for Qualcomm
    WCN6855/WCN7850 WiFi, SDX62/SDX65 modems") and previous status.
  - Emphasize isolation.
  - No code changes from v14, only commit message clarification (Mani's
    Reviewed-by and Alex's Acked-by retained)
v14: https://lore.kernel.org/all/20260917071651.14174-3-jtornosm@redhat.com/

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

