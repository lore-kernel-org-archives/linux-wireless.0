Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D51247C0FE
	for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2026 07:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789629438; cv=none; b=E36uVgWgQz75DH2liaSFtEm1vUe4Q09qTnmzadoVAH+4ZVWq7WctkziEjqZgn7Qzggnnw1YIqkAa7Ym2z91UaoyMrjDs8+yQP2x5Ofv3S3oywJ67wO5V7nM0wplqqAdfX5+0cPzKIw51Enen2Wy+DR5j/MAal8FJP2fMIMCzNDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789629438; c=relaxed/simple;
	bh=PlRSYbApRP7BB8CpjSuyJQ4So5MGzQ36VGzNk+6i7IE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZPgbsuglCDQYiw/RbGTHwraHFgCheAspFIvG9RJe5rQpj6DIpk9QIwmWAu71zzUgjLyJsgNi9p2h705tauwJiHNWTVsoERRnR0rQw8pbPd/0GBJ7KzlBHVHCPIaVVFEc4uEwaf5KMlvv+0WTqjg8EkUxECISoBiM/gWIm6V7mas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CmZZZPVt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CmZZZPVt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789629435;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6oVowQPD2pzOvsnV2vQtmoDtP9e65GcjkY+VkNiJx7c=;
	b=CmZZZPVtYSdaNrcqBffZk0QqGP8oztgwoYiayX6LIPX65OgbamWjG1DcYpevXoQryFFSPO
	grzW3q9nhprJVVFNBU+JGde6GOp5oxtVGJfm7zVjFhjYDPpmkU7ONpy4tohDPTxDPQiV3H
	d43uBbyspabK9VQWS/Hc/u49xVJDkvk=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-348-60u2YI-APXKyemquFbe4Cg-1; Thu,
 17 Sep 2026 03:17:10 -0400
X-MC-Unique: 60u2YI-APXKyemquFbe4Cg-1
X-Mimecast-MFC-AGG-ID: 60u2YI-APXKyemquFbe4Cg_1789629428
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 44EE9195DE7A;
	Thu, 17 Sep 2026 07:17:08 +0000 (UTC)
Received: from fedora.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AA97E427;
	Thu, 17 Sep 2026 07:17:04 +0000 (UTC)
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
Subject: [PATCH v14 1/2] PCI: Add device-specific reset for Qualcomm SDX62/SDX65 modems
Date: Thu, 17 Sep 2026 09:16:50 +0200
Message-ID: <20260917071651.14174-2-jtornosm@redhat.com>
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

Qualcomm SDX62/SDX65 5G modems (17cb:0308) lack working reset methods for
VFIO passthrough scenarios. These devices have no FLR capability, advertise
NoSoftRst+ (blocking PM reset), and have broken bus reset (addressed by
quirk_no_bus_reset, merged for v7.2).

VFIO attempts to reset devices on every reassignment. Without a proper
reset capability, these devices never successfully initialize even on first
VM assignment.

Add a device-specific reset method using BAR-space hardware reset registers
that exist in these devices.

SDX62/SDX65 modem devices use MHI SoC reset via BAR0 (sequence from MHI
driver: mhi_soc_reset(), mhi_pci_reset_prepare()):
- Write reset request to offset 0xb0
- Wait 2 seconds for reset completion

This is a true hardware reset mechanism (not power management or firmware
error recovery), providing proper device reset for VFIO scenarios.

Testing shows stable operation over 109 VM crash/reset cycles. Device-
specific reset is position #1 in the reset hierarchy, so these Qualcomm
devices will use hardware reset as their primary reset method.

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
---
v14: Address Bjorn Helgaas feedback:
  - Split WLAN and modem resets into two separate patches
  - No code changes from v13, only patch split and commit message
    clarification (Mani's Reviewed-by retained)
v13: https://lore.kernel.org/all/20260915223634.GA878346@bhelgaas/

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

