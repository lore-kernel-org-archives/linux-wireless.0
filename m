Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262B5480954
	for <linux-wireless@vger.kernel.org>; Wed,  3 Jun 2026 10:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780484354; cv=none; b=LaqeibOL4ozxhKBuFDB7GY6K/ztKbpHznT7RTv3RCrexadUadyD45jmsI9xWkW0gTWwhMlWNJlHNFimu42wsj23xSCjtpIpPNS+rE+oztjDlZF1AFAJQ4wr4kHgjtdgAswPIY0W4xbRj9enWC931jWCPqzAKv5teK8s0nd89RUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780484354; c=relaxed/simple;
	bh=RadFh23ud+KvHW20pp0ITIVLEOO8Z0qKB3NGPVnZe0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p1slM9z0i+YzqxFmN/NozLtlHdujyE5CEFaUe0bhrFzQjks5A6S6cfCpV4VWFEsbHXKpl6TsDuUTKd1G+Mds/+2K07DNOy4kF+3dkcFy7PAXc6SWV0F7TB+nx7spAlbUvSik2oDuUTqzhy+jQiiebUC7e3yUe5Siq6wKebyT6EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O2o78irN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O2o78irN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780484352;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MlHHmXXtMTPA6InDjEzesUmGq1UhVpcGPnFopg8WJtk=;
	b=O2o78irNgyBwMiHxlUFgkntENsYLcH5/bHlTzMwBAe4snQrnx7UXegwSrNH9SDM/WZW7mq
	b7RCn0jAb7PoufDCDkjdKgJPtOczJpmxlKU+Lw3Ci3MDaJG2AI7RDFvGdKb69yiP+BPA5r
	5LxfpaVE1YLIFB4xpcSn1ZgRcqD03Ts=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-92-0zbKSMSLNBCOhcSCqBwn4w-1; Wed,
 03 Jun 2026 06:59:11 -0400
X-MC-Unique: 0zbKSMSLNBCOhcSCqBwn4w-1
X-Mimecast-MFC-AGG-ID: 0zbKSMSLNBCOhcSCqBwn4w_1780484349
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DCF7A18002C1;
	Wed,  3 Jun 2026 10:59:08 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.48.81])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BEACE1956095;
	Wed,  3 Jun 2026 10:59:04 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: bhelgaas@google.com,
	alex@shazbot.org
Cc: jjohnson@kernel.org,
	mani@kernel.org,
	linux-pci@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	mhi@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Subject: [PATCH v7 1/3] PCI: Add d3cold as general reset method
Date: Wed,  3 Jun 2026 12:58:51 +0200
Message-ID: <20260603105853.326290-2-jtornosm@redhat.com>
In-Reply-To: <20260603105853.326290-1-jtornosm@redhat.com>
References: <20260603105853.326290-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Add D3cold power cycle as a general PCI reset method for single-function
devices on platforms with ACPI _PR3 power resources. This provides true
power cycle reset capability when the platform can physically cut power
to the device.

The implementation strictly requires _PR3 to be present - the platform
must be able to control device power. This ensures d3cold only attempts
true power cycling, not falling back to D3hot transitions.

D3cold reset is placed at the end of the reset hierarchy since it requires
specific platform support and should be tried after standard methods.

Reset hierarchy with this change:
1. device_specific
2. acpi
3. flr
4. af_flr
5. pm (D3hot via config space, checks NoSoftRst)
6. bus (SBR)
7. cxl_bus
8. d3cold (NEW - true power cycle, requires _PR3)

This benefits:
- Platforms with _PR3 support
- Single-function devices needing true power cycle
- VFIO passthrough scenarios where FLR/PM unavailable

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
---
v7: code unchanged from v6
v6: https://lore.kernel.org/all/20260602160024.1171949-2-jtornosm@redhat.com/

 drivers/pci/pci.c   | 50 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h |  2 +-
 2 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 8f7cfcc00090..096868f80cd4 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -4491,6 +4491,55 @@ static int pci_pm_reset(struct pci_dev *dev, bool probe)
 	return ret;
 }
 
+/**
+ * pci_d3cold_reset - Put device into D3cold and back to D0 for reset
+ * @dev: PCI device to reset
+ * @probe: if true, check if D3cold reset is supported; if false, perform reset
+ *
+ * Reset the device by transitioning through D3cold (actual power removal via
+ * platform power control) and back to D0. This requires ACPI _PR3 power
+ * resources to be present - the platform must be able to physically cut power
+ * to the device.
+ *
+ * Only available for single-function devices to avoid affecting other
+ * functions in multi-function devices.
+ *
+ * Returns 0 if device can be/was reset this way, -ENOTTY if not supported,
+ * or other negative error code on failure.
+ */
+static int pci_d3cold_reset(struct pci_dev *dev, bool probe)
+{
+	int ret;
+
+	if (dev->multifunction)
+		return -ENOTTY;
+
+	if (!pci_pr3_present(dev))
+		return -ENOTTY;
+
+	if (probe)
+		return 0;
+
+	if (dev->current_state != PCI_D0)
+		return -EINVAL;
+
+	ret = pci_dev_reset_iommu_prepare(dev);
+	if (ret) {
+		pci_err(dev, "failed to stop IOMMU for a PCI reset: %d\n", ret);
+		return ret;
+	}
+
+	ret = pci_set_power_state(dev, PCI_D3cold);
+	if (ret)
+		goto done;
+
+	ret = pci_set_power_state(dev, PCI_D0);
+
+done:
+	pci_dev_reset_iommu_done(dev);
+	return ret;
+}
+
 /**
  * pcie_wait_for_link_status - Wait for link status change
  * @pdev: Device whose link to wait for.
@@ -5065,6 +5114,7 @@ const struct pci_reset_fn_method pci_reset_fn_methods[] = {
 	{ pci_pm_reset, .name = "pm" },
 	{ pci_reset_bus_function, .name = "bus" },
 	{ cxl_reset_bus_function, .name = "cxl_bus" },
+	{ pci_d3cold_reset, .name = "d3cold" },
 };
 
 /**
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 2c4454583c11..1ca7b880ead7 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -51,7 +51,7 @@
 			       PCI_STATUS_PARITY)
 
 /* Number of reset methods used in pci_reset_fn_methods array in pci.c */
-#define PCI_NUM_RESET_METHODS 8
+#define PCI_NUM_RESET_METHODS 9
 
 #define PCI_RESET_PROBE		true
 #define PCI_RESET_DO_RESET	false
-- 
2.54.0

