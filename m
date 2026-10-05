Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E495B478E25
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 10:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791197701; cv=none; b=dAhxJJRsPZiUCe//jaKXtPbEaINnXdnPPAzweWLbMWLPSF7KMSGT1p6F8Jkwh4IhqVh9sLjnIFAu6ajxOafEcii5Qz5OWH0UV0rT/o0yuVkM+YlMR7MutjkVtzV0lr3HL8hTFiAAa+Ka+Jl6i9uWOk1hnpZ1iWLSIB+p3QGgIgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791197701; c=relaxed/simple;
	bh=EbKBZD+D7TuOoHbqhGucCdP4PawsV8Bj6zk13c8GiBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QUBPptaz9zWHBkC3JZGcwMKkxiDTODMSd3ql3QaJ6RIwXBX/oC89g6VtFAdL1btnNbqcklKvMsMsxXV6lwJ9tp7RsYc90mrc12e8NncDMmNS+6hmr7X11oaRU8ORdKopY8sCNMzx9j4Z8T1qEmBV1ptx4+ZLDNM3bTNT8/DOFc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Bqymxma+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bqymxma+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791197698;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X9ybfkjjQyEBOnKyW7ywsxv+01LedkQkjdz2/XCnQyA=;
	b=Bqymxma+x2/a2k2x5nP7AQ4jCFyrgfbhLQBK0VPMGs0OSgh0JHlVf4IwVcTQtAirYvyGjK
	/AP5EbvpTdcQMMguLvAMAs3KGieEFeWvl6o2mt9C/a4z7q+kpVhOrXdoIablt7RsmT31yf
	h43HqBHYuE+sadLozYSJP6TrFAX1zSY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-594-0fQc6ZMxMuKEoHzXhDfGmw-1; Mon,
 05 Oct 2026 06:54:53 -0400
X-MC-Unique: 0fQc6ZMxMuKEoHzXhDfGmw-1
X-Mimecast-MFC-AGG-ID: 0fQc6ZMxMuKEoHzXhDfGmw_1791197691
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AF876182A128;
	Mon,  5 Oct 2026 10:54:51 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 549501800446;
	Mon,  5 Oct 2026 10:54:48 +0000 (UTC)
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
Subject: [PATCH v15 1/2] PCI: Add device-specific reset for Qualcomm SDX62/SDX65 modems
Date: Mon,  5 Oct 2026 12:54:35 +0200
Message-ID: <20261005105436.83962-2-jtornosm@redhat.com>
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

Qualcomm SDX62/SDX65 5G modems (17cb:0308) lack working reset methods for
VFIO passthrough scenarios. These devices have no FLR capability, advertise
NoSoftRst+ (blocking PM reset), and have broken bus reset.

Standard reset methods were already disabled for these devices by commit
6a4f64c3a3ad ("PCI: Avoid SBR for Qualcomm WCN6855/WCN7850 WiFi,
SDX62/SDX65 modems") because they were not working (quirk_no_bus_reset).

VFIO attempts to reset devices on every reassignment. Without a proper
reset capability, these devices never successfully initialize even on first
VM assignment.

Add a device-specific reset method using BAR-space hardware reset registers
that exist in these devices.

SDX62/SDX65 modem devices use MHI SoC reset via BAR0 (sequence from MHI
driver: mhi_soc_reset(), mhi_pci_reset_prepare()):
- Write reset request to offset 0xb0
- Wait 2 seconds for reset completion

These are true hardware reset mechanisms (not power management or firmware
error recovery), providing proper device reset for VFIO scenarios, allowing
to enforce isolation between successive passthrough users.

Testing shows stable operation over 109 VM crash/reset cycles. Device-
specific reset is position #1 in the reset hierarchy, so these Qualcomm
devices will use hardware reset as their primary reset method.

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Acked-by: Alex Williamson <alex@shazbot.org>
---
v15: Address Bjorn Helgaas feedback:
    - Explain the relationship with 6a4f64c3a3ad ("PCI: Avoid SBR for Qualcomm
    WCN6855/WCN7850 WiFi, SDX62/SDX65 modems") and previous status.
    - No code changes from v14, only commit message clarification (Mani's
    Reviewed-by and Alex's Acked-by retained)
v14: https://lore.kernel.org/all/20260917071651.14174-2-jtornosm@redhat.com/

 drivers/pci/quirks.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index de9bbccda21f..e72af7d2c775 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4230,6 +4230,45 @@ static int reset_hinic_vf_dev(struct pci_dev *pdev, bool probe)
 	return 0;
 }
 
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
@@ -4245,6 +4284,7 @@ static const struct pci_dev_reset_methods pci_dev_reset_methods[] = {
 		reset_chelsio_generic_dev },
 	{ PCI_VENDOR_ID_HUAWEI, PCI_DEVICE_ID_HINIC_VF,
 		reset_hinic_vf_dev },
+	{ PCI_VENDOR_ID_QCOM, 0x0308, reset_qualcomm_modem }, /* SDX62/SDX65 modems */
 	{ 0 }
 };
 
-- 
2.54.0

