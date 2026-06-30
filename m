Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9BD2393DCA
	for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2026 06:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782802713; cv=none; b=rCDaLNvzSNbe4P1g3546H6SHb6BUkmAz0UiaozMnX4+2ahIoatFyVNO1sQd7uH9PT+T+St+ywWtbHg6hO7fLbhrelVcQc0fZ7Lrd8Hxxak99n4hHsgQre8rZyscpCt2E/6MozAhRDjTc57v05c7nPOmrHtdGH8aOBSrDUgYixrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782802713; c=relaxed/simple;
	bh=O/RmpcJPhoXSXmdQPfuDXbLyqT8UOzjEC89MYWn2aSU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KS6hyYhng7lWmb6n0UvX0XjSB9xM3jFCMT3sbg6ax/61IdOOR/ioNyDXw1WCcF1pa+J9fkwesY49ORHvXuTTMbJTcMgZCGROe5ykkGA+Uyd8hpwtaiwsLKO1ZsK0N4uXHMIhEVDwMzVaaoTYIcTf31qRqYzpMIY/PXRD6RDPVbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XP0yZ9E9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XP0yZ9E9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782802710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IfvcY9uq6uLwM8t+kLexGrbIDeUDtwGI75Ilk2oh1y4=;
	b=XP0yZ9E92dMIsH/2LnCCn0NmXGfDADcF6b/RN/FOBS6o9mNc2YyEhUc49OLvCxqSu5fvjT
	iela/ozKHi3m4ekQDUYwQ/DA5FomqQAHDopeB0gUZKp4Cfp+jpFnghhfwXRplvEFenoQgs
	LEhRz67pCGQFn/OmIdq72BLI82LCDA8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-612--7tlt8gNONKNQD7xg7TLfQ-1; Tue,
 30 Jun 2026 02:58:27 -0400
X-MC-Unique: -7tlt8gNONKNQD7xg7TLfQ-1
X-Mimecast-MFC-AGG-ID: -7tlt8gNONKNQD7xg7TLfQ_1782802705
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 597D41856A55;
	Tue, 30 Jun 2026 06:58:25 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.48.35])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 478CE180059E;
	Tue, 30 Jun 2026 06:58:21 +0000 (UTC)
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
Subject: [PATCH v12] PCI: Add device-specific reset for Qualcomm devices
Date: Tue, 30 Jun 2026 08:58:15 +0200
Message-ID: <20260630065815.199693-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

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
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
---
v12: Address Manivannan Sadhasivam feedback:
  - Use WLAN instead of WiFi (Qualcomm's preferred terminology)
  - Fix link recovery check: use !PCI_POSSIBLE_ERROR(val) instead of
    val != PCI_ERROR_RESPONSE (fixes type promotion bug)
v11: https://lore.kernel.org/all/20260626055023.197470-1-jtornosm@redhat.com/

 drivers/pci/quirks.c | 117 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 117 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 431c021d7414..0de606366200 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4240,6 +4240,120 @@ static int reset_hinic_vf_dev(struct pci_dev *pdev, bool probe)
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
+	bool link_recovered = false;
+	unsigned long timeout;
+	void __iomem *bar;
+	u32 val;
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
+	val = ioread32(bar + QUALCOMM_WLAN_PCIE_SOC_GLOBAL_RESET);
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
+	timeout = jiffies + msecs_to_jiffies(5000);
+	while (time_before(jiffies, timeout)) {
+		val = ioread32(bar + QUALCOMM_WLAN_PCIE_SOC_GLOBAL_RESET);
+		if (!PCI_POSSIBLE_ERROR(val)) {
+			link_recovered = true;
+			break;
+		}
+		msleep(20);
+	}
+
+	if (!link_recovered) {
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
+	return link_recovered ? 0 : -ETIMEDOUT;
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
@@ -4255,6 +4369,9 @@ static const struct pci_dev_reset_methods pci_dev_reset_methods[] = {
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

