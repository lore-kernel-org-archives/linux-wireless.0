Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABB047D950
	for <linux-wireless@vger.kernel.org>; Tue,  9 Jun 2026 16:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781023038; cv=none; b=tbvVqOBbwNL5z/La3f9WExaIQ0EUxFooHOUkXRnmiXRO0/+IfyZgvNjzcB6rRG1oqdixIvnUwt9qpmiaL0YrDPYLECQ/m7IgUna3xSMYvVWPxiGHxEAYoGvw3U82aLRbtECH7fb6rra7uWmFDhqM9efeKrkV+fsmhfL7XbSrqbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781023038; c=relaxed/simple;
	bh=RB51zGeQICHGKMGUIcNIovONUOJ0k7n8f9vI3EMMXVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UgabFiFEJ7oryT65zzFx99EbNKy+bDy7qL7ZX6IwGR2ZQjDXlx5dA1O6fx73FymdF2BQXdlP28bBwyPLZdBVJkwTEyLFX+8znp1rW0uoRTj/UbJkYOQXzIQKZ87V7y7x3KW0y98Kp597DeTQIiETre1xgfSlAfr8X8aXNuykDgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=deq/Sj6x; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="deq/Sj6x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781023036;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BlJUbNpU0pTX5NWiNJbaiX2FROLLctIsfkxEzOcvkg8=;
	b=deq/Sj6xDbXyx9edsMb/w1j3H917kllhEYF3QXQJ6oav9EOmwExEiB72gGhSVDudl6JOel
	Qvqi5Tt6nMTB5JKt+gvzrp+KifcvTNY/bHhEZbc9L+PaOL0EfBdPnMTfFCjMVNct42k+Zq
	nkOCZRmKxRh8/RLgluZ5eHGrSgFFJWQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-424-FuDVg-dlNkCYHEmFdXSS1w-1; Tue,
 09 Jun 2026 12:37:09 -0400
X-MC-Unique: FuDVg-dlNkCYHEmFdXSS1w-1
X-Mimecast-MFC-AGG-ID: FuDVg-dlNkCYHEmFdXSS1w_1781023027
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D076219560BC;
	Tue,  9 Jun 2026 16:37:05 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.32.77])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8502C1800662;
	Tue,  9 Jun 2026 16:37:01 +0000 (UTC)
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
Subject: [PATCH v8 1/3] PCI: Add d3cold as general reset method
Date: Tue,  9 Jun 2026 18:36:47 +0200
Message-ID: <20260609163649.319755-2-jtornosm@redhat.com>
In-Reply-To: <20260609163649.319755-1-jtornosm@redhat.com>
References: <20260609163649.319755-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

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
v8: code unchanged from v7
v7: https://lore.kernel.org/all/20260603105853.326290-2-jtornosm@redhat.com/ 

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

