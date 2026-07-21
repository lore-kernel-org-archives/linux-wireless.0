Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 332BE441616
	for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2026 08:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784621611; cv=none; b=B9d447q5RCk/VTx1sLlfZBfvk6nAss7Sxwu8FMh15BvBuZ6wxWN3qqk99KU3Z8bg9V+ak7jUorYXsF4fhTYa4AjGG9vxAFmlCgcJKCusxqpypOM+JmlDTebGLIbLyD8qM5+9jfJlgSFyVtNUHPBP04qgPQs9U2KRUC0UZ3FfDPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784621611; c=relaxed/simple;
	bh=okiV2lgU63vpPMUGj570DhVjS0AbVKX8tHA2pdYZkoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=G9MhUPm9+hdxXlpSK8z9MYS85pAEVcHVUzjAchNPaKy8JmLrXmV3j8Oo2LVSYthVdALuei1/BorTHSlWe5mLQ5lqPKPxfLK4exK/sAz1yH4YUIt8zLyW/mUzalrk6R8G5b7wLpXyzyxkYu84iKeS6FQMCeQxRyg3S+yh81MknL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QM7s1aUl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QM7s1aUl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784621595;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=PK82L8THiWroAM1HPt8oRK7uxjYuYOO7+GgX16DnT3s=;
	b=QM7s1aUlUsdxLVYsB/vq2eGP4h3tKALTNRcBccjHNkWXviWA7kj8klgCF63cNv9nXIRxvm
	cBF1eiJxIlkeUdTouB5/+t4YJNoc6QBHXqyI2VpQ8fCb1NvmUqWYsfCMPs3ElJniIDlZ7E
	XR5VVPup8xdU8TmQyHQO5/s3VTZP55s=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-202-EPuHpqaqN2-PDPOFbCqpvw-1; Tue,
 21 Jul 2026 04:13:12 -0400
X-MC-Unique: EPuHpqaqN2-PDPOFbCqpvw-1
X-Mimecast-MFC-AGG-ID: EPuHpqaqN2-PDPOFbCqpvw_1784621591
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CD7F7180A9A4;
	Tue, 21 Jul 2026 08:13:09 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.48.59])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5BF4C1954231;
	Tue, 21 Jul 2026 08:13:04 +0000 (UTC)
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
Subject: [PATCH v13] PCI: Add device-specific reset for Qualcomm devices
Date: Tue, 21 Jul 2026 10:13:01 +0200
Message-ID: <20260721081301.205374-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Some Qualcomm PCIe devices (WCN6855/WCN7850 WLAN cards, SDX62/SDX65 modems)
lack working reset methods for VFIO passthrough scenarios. These devices
have no FLR capability, advertise NoSoftRst+ (blocking PM reset), and have
broken bus reset.

The problem manifests in VFIO passthrough scenarios:

- WCN6855 (17cb:1103) and WCN7850 (17cb:1107) WLAN devices:
  Normal VM operation works fine, including clean shutdown/reboot.
  However, when the VM terminates uncleanly (crash, force-off), VFIO
  attempts to reset the device before it can be assigned to another VM.
  Without a working reset method, the device remains in an undefined state,
  preventing reuse.

- SDX62/SDX65 (17cb:0308) 5G modems: Never successfully initialize even
  on first VM assignment without proper reset capability.

Add device-specific reset methods using BAR-space hardware reset registers
that exist in these devices:

- WCN6855/WCN7850 WLAN devices use SoC global reset via BAR0 (sequence from
  ath11k/ath12k driver: ath11k_pci_soc_global_reset(), ath11k_pci_sw_reset(),
  ath11k_mhi_set_mhictrl_reset()):
  - Write/clear reset bit at offset 0x3008
  - Wait for PCIe link recovery (up to 5 seconds)
  - Clear MHI controller SYSERR status at offset 0x38

- SDX62/SDX65 modem devices use MHI SoC reset via BAR0 (sequence from MHI
  driver: mhi_soc_reset(), mhi_pci_reset_prepare()):
  - Write reset request to offset 0xb0
  - Wait 2 seconds for reset completion

These are true hardware reset mechanisms (not power management or firmware
error recovery), providing proper device reset for VFIO scenarios.

Testing was performed on desktop platforms with M.2 WLAN and modem cards
using M.2-to-PCIe adapters, including extensive force-reset cycling to
verify stability.

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
---
v13: Address Alex Williamson feedback:
  - Validate initial ioread32() with PCI_POSSIBLE_ERROR() before
    read-modify-write to avoid writing error response back to device
    on platforms with APEI/GHES error escalation
  - Replace time_before()/msleep() polling loop with read_poll_timeout()
    for robustness against scheduling delays and code simplification
v12: https://lore.kernel.org/all/20260630065815.199693-1-jtornosm@redhat.com/

 drivers/pci/quirks.c | 116 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 116 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 431c021d7414..bd1e0742052e 100644
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
@@ -4240,6 +4241,118 @@ static int reset_hinic_vf_dev(struct pci_dev *pdev, bool probe)
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
+#define MHI_SOC_RESET_REQ_OFFSET		0xb0
+#define MHI_SOC_RESET_REQ			BIT(0)
+
+/*
+ * Qualcomm modem device-specific reset using MHI SoC reset via BAR0
+ * register.
+ */
+static int reset_qualcomm_modem(struct pci_dev *pdev, bool probe)
+{
+	void __iomem *bar;
+	u16 cmd;
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
+	iowrite32(MHI_SOC_RESET_REQ, bar + MHI_SOC_RESET_REQ_OFFSET);
+	ioread32(bar + MHI_SOC_RESET_REQ_OFFSET);
+
+	/* Be sure device reset has been executed */
+	msleep(2000);
+
+	pci_iounmap(pdev, bar);
+	pci_write_config_word(pdev, PCI_COMMAND, cmd);
+
+	return 0;
+}
+
 static const struct pci_dev_reset_methods pci_dev_reset_methods[] = {
 	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82599_SFP_VF,
 		 reset_intel_82599_sfp_virtfn },
@@ -4255,6 +4368,9 @@ static const struct pci_dev_reset_methods pci_dev_reset_methods[] = {
 		reset_chelsio_generic_dev },
 	{ PCI_VENDOR_ID_HUAWEI, PCI_DEVICE_ID_HINIC_VF,
 		reset_hinic_vf_dev },
+	{ PCI_VENDOR_ID_QCOM, 0x0308, reset_qualcomm_modem }, /* SDX62/SDX65 modems */
+	{ PCI_VENDOR_ID_QCOM, 0x1103, reset_qualcomm_wlan },  /* WCN6855 WLAN */
+	{ PCI_VENDOR_ID_QCOM, 0x1107, reset_qualcomm_wlan },  /* WCN7850 WLAN */
 	{ 0 }
 };
 
-- 
2.54.0

