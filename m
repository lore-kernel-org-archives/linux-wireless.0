Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17E533D6FA
	for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 07:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791704760; cv=none; b=HXr/axZKqayocMknIBhd69PEQyIsYGawlkjJXBj4Hyhd/z3aI7+ImlmaMRUBGdXXBy+ckyteeJleYopD1gu7/3T3/n2ECzM4e0gFeggU0sRtoffNTrWE+yUjBZ7NfwOGn7Vz+WKEezCHj2Ms1g+5B/MUptcgQBKDuknOQ51XvOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791704760; c=relaxed/simple;
	bh=Rvx0glxR01vyPXuUq4vlgVDA6P+3QqDXcr3kmn+zy8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AUbruAgUUHecUeWcWHx4FD5CoDr/xiwmyO+THa3ikMrvvZp3n1Qm9hTR0wW13wboqLwRwuzr4pXzZmX3CBmN419wpkr1ihd8NTY4LZC2L1jsgH+ULZExCdO41MXy8r6fOlKeLIMkUoDrF7hWBOMm8HwwoDM4cQ0mCNKuUphgZRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BCsgIK5G; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BCsgIK5G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791704756;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OT1uBiGJb0Uz+Vw2AGupIo/4tVgoQ4/x9ct7X4+cwds=;
	b=BCsgIK5GEDwdSydIXjKDo3xiE683H0SBNVDCTPBBBcrGkvu2L1as3eLEMFg5MyhkGsB73g
	LDxMA1fu3xw/+vBGTtBe1JrgSogr0KOvjZYgT1Q8N7vAltJM1yA7CKJFrVQs+vMQWLzFW0
	/6AE0MK6auNnSYXSL5qzTRNXpBxNQUE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-689-G450DBpZPKWZCEtu8fQbgA-1; Sun,
 11 Oct 2026 07:45:52 +0000
X-MC-Unique: G450DBpZPKWZCEtu8fQbgA-1
X-Mimecast-MFC-AGG-ID: G450DBpZPKWZCEtu8fQbgA_1791704750
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 284D61954ADE;
	Sun, 11 Oct 2026 07:45:50 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6B32F1956041;
	Sun, 11 Oct 2026 07:45:45 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: jgg@ziepe.ca,
	alex@shazbot.org,
	bhelgaas@google.com,
	jjohnson@kernel.org
Cc: johannes@sipsolutions.net,
	mani@kernel.org,
	yishaih@nvidia.com,
	skolothumtho@nvidia.com,
	kevin.tian@intel.com,
	linux-pci@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Subject: [PATCH v2 3/7] vfio/pci: Add qcom-vfio-pci variant driver
Date: Sun, 11 Oct 2026 09:45:10 +0200
Message-ID: <20261011074514.515894-4-jtornosm@redhat.com>
In-Reply-To: <20261011074514.515894-1-jtornosm@redhat.com>
References: <20261011074514.515894-1-jtornosm@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Add VFIO variant driver for Qualcomm PCIe devices that require
MSI address passthrough for VM operation.

Qualcomm ath11k and ath12k WiFi devices have embedded interrupt
controllers that require physical host MSI addresses programmed to
device registers. In VMs, the driver only sees virtualized guest
addresses, causing firmware initialization to fail.

This variant driver:
1. Caches physical host MSI values after allocation
2. Writes them to extended config space with magic signature "QMSI"
3. VM drivers discover and use these values automatically

The driver follows the VFIO variant driver pattern used by mlx5-vfio-pci
and nvgrace-gpu, providing device-specific quirks within the kernel
without requiring QEMU modifications.

Note: the VM must have IOMMU interrupt remapping and caching mode
enabled so that MSI writes from the device using cached host physical
addresses are properly routed through the IOMMU interrupt remapping
table to the VM.

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
---
v2: Address Sashiko comments:
    - Fix TOCTOU: pre-fetch SET_IRQS header before core ioctl to avoid
      double-fetch race from re-reading userspace after ioctl completes
    - Fix stale MSI cache on VM reboot: add close_device wrapper to reset
      cached MSI state when device is closed, ensuring fresh MSI values
      are captured on next VM attachment
v1: https://lore.kernel.org/all/20260930140833.576941-4-jtornosm@redhat.com/ 

 drivers/vfio/pci/Kconfig              |   2 +
 drivers/vfio/pci/Makefile             |   2 +
 drivers/vfio/pci/qcom/Kconfig         |  22 ++
 drivers/vfio/pci/qcom/Makefile        |   3 +
 drivers/vfio/pci/qcom/main.c          | 285 ++++++++++++++++++++++++++
 drivers/vfio/pci/qcom/msi_quirk.c     | 163 ++++++++++++++++
 drivers/vfio/pci/qcom/qcom_vfio_pci.h |  36 ++++
 7 files changed, 513 insertions(+)
 create mode 100644 drivers/vfio/pci/qcom/Kconfig
 create mode 100644 drivers/vfio/pci/qcom/Makefile
 create mode 100644 drivers/vfio/pci/qcom/main.c
 create mode 100644 drivers/vfio/pci/qcom/msi_quirk.c
 create mode 100644 drivers/vfio/pci/qcom/qcom_vfio_pci.h

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 296bf01e185e..237a29443bf5 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -72,6 +72,8 @@ source "drivers/vfio/pci/nvgrace-gpu/Kconfig"
 
 source "drivers/vfio/pci/qat/Kconfig"
 
+source "drivers/vfio/pci/qcom/Kconfig"
+
 source "drivers/vfio/pci/xe/Kconfig"
 
 endmenu
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index 6138f1bf241d..63db19102850 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -23,4 +23,6 @@ obj-$(CONFIG_NVGRACE_GPU_VFIO_PCI) += nvgrace-gpu/
 
 obj-$(CONFIG_QAT_VFIO_PCI) += qat/
 
+obj-$(CONFIG_QCOM_VFIO_PCI) += qcom/
+
 obj-$(CONFIG_XE_VFIO_PCI) += xe/
diff --git a/drivers/vfio/pci/qcom/Kconfig b/drivers/vfio/pci/qcom/Kconfig
new file mode 100644
index 000000000000..8e4c170d01a0
--- /dev/null
+++ b/drivers/vfio/pci/qcom/Kconfig
@@ -0,0 +1,22 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config QCOM_VFIO_PCI
+	tristate "VFIO support for Qualcomm PCI devices"
+	depends on PCI
+	select VFIO_PCI_CORE
+	help
+	  This provides VFIO support for Qualcomm PCI devices with device-specific
+	  quirks. Currently supports:
+	  - Qualcomm ath11k WiFi (Device ID 0x1103)
+	  - Qualcomm ath12k WiFi (Device ID 0x1107)
+
+	  These devices require special handling for MSI address/data passthrough
+	  when used with VFIO. The firmware expects physical host MSI addresses
+	  rather than guest IOVA addresses.
+
+	  The VM must have IOMMU interrupt remapping and caching mode enabled.
+	  For example, with libvirt/QEMU on Intel, add to the domain XML:
+	    <iommu model="intel">
+	      <driver intremap="on" caching_mode="on"/>
+	    </iommu>
+
+	  If you don't know what to do here, say N.
diff --git a/drivers/vfio/pci/qcom/Makefile b/drivers/vfio/pci/qcom/Makefile
new file mode 100644
index 000000000000..dc48d87d1ef6
--- /dev/null
+++ b/drivers/vfio/pci/qcom/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_QCOM_VFIO_PCI) += qcom-vfio-pci.o
+qcom-vfio-pci-y := main.o msi_quirk.o
diff --git a/drivers/vfio/pci/qcom/main.c b/drivers/vfio/pci/qcom/main.c
new file mode 100644
index 000000000000..0abfdd5faf80
--- /dev/null
+++ b/drivers/vfio/pci/qcom/main.c
@@ -0,0 +1,285 @@
+// SPDX-License-Identifier: GPL-2.0-only
+// SPDX-FileCopyrightText: Copyright Red Hat
+
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/stddef.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+#include <linux/vfio.h>
+#include <linux/vfio_pci_core.h>
+#include <uapi/linux/vfio.h>
+
+#include "qcom_vfio_pci.h"
+
+static struct qcom_vfio_pci_device *to_qcom_vdev(struct vfio_pci_core_device *vdev)
+{
+	return container_of(vdev, struct qcom_vfio_pci_device, vdev);
+}
+
+/*
+ * Intercept config space read operations to return cached host MSI values.
+ * Call core VFIO if not intercepted.
+ */
+static ssize_t qcom_vfio_pci_read(struct vfio_device *core_vdev, char __user *buf,
+				  size_t count, loff_t *ppos)
+{
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+	struct qcom_vfio_pci_device *qdev = to_qcom_vdev(vdev);
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+	loff_t offset = *ppos & VFIO_PCI_OFFSET_MASK;
+	ssize_t ret;
+
+	if (index == VFIO_PCI_CONFIG_REGION_INDEX) {
+		ret = qcom_vfio_pci_config_rw(qdev, buf, count, offset, false);
+		if (ret != -ENOTTY) {
+			if (ret > 0)
+				*ppos += ret;
+			return ret;
+		}
+	}
+
+	return vfio_pci_core_read(core_vdev, buf, count, ppos);
+}
+
+static int qcom_vfio_pci_init_dev(struct vfio_device *core_vdev)
+{
+	struct qcom_vfio_pci_device *qdev =
+		container_of(core_vdev, struct qcom_vfio_pci_device, vdev.vdev);
+	struct pci_dev *pdev = to_pci_dev(core_vdev->dev);
+	int ret;
+
+	ret = vfio_pci_core_init_dev(core_vdev);
+	if (ret)
+		return ret;
+
+	qdev->msi_offset = qcom_vfio_find_msi_offset(pdev);
+	if (!qdev->msi_offset) {
+		pci_err(pdev, "No free space in extended config for MSI quirk\n");
+		pci_err(pdev, "qcom-vfio-pci cannot function without MSI passthrough, failing probe\n");
+		vfio_pci_core_release_dev(core_vdev);
+		return -ENODEV;
+	}
+	pci_info(pdev, "MSI passthrough quirk using offset 0x%x\n", qdev->msi_offset);
+
+	qdev->msi_cached = false;
+	qdev->msi_addr_lo = 0;
+	qdev->msi_addr_hi = 0;
+	qdev->msi_data = 0;
+
+	return 0;
+}
+
+static const struct vfio_pci_device_ops qcom_vfio_pci_device_ops = {
+	/* No device-specific operations needed */
+};
+
+static int qcom_vfio_pci_open_device(struct vfio_device *core_vdev)
+{
+	struct qcom_vfio_pci_device *qdev =
+		container_of(core_vdev, struct qcom_vfio_pci_device, vdev.vdev);
+	struct vfio_pci_core_device *vdev = &qdev->vdev;
+	int ret;
+
+	ret = vfio_pci_core_enable(vdev);
+	if (ret)
+		return ret;
+
+	vfio_pci_core_finish_enable(vdev);
+	return 0;
+}
+
+static void qcom_vfio_pci_close_device(struct vfio_device *core_vdev)
+{
+	struct qcom_vfio_pci_device *qdev =
+		container_of(core_vdev, struct qcom_vfio_pci_device, vdev.vdev);
+
+	qdev->msi_cached = false;
+	qdev->msi_addr_lo = 0;
+	qdev->msi_addr_hi = 0;
+	qdev->msi_data = 0;
+
+	vfio_pci_core_close_device(core_vdev);
+}
+
+/*
+ * Wrap ioctl to intercept MSI allocation and cache host MSI values.
+ * This is called after QEMU allocates MSI via VFIO_DEVICE_SET_IRQS.
+ */
+static long qcom_vfio_pci_ioctl(struct vfio_device *core_vdev,
+				unsigned int cmd, unsigned long arg)
+{
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+	struct qcom_vfio_pci_device *qdev = to_qcom_vdev(vdev);
+	bool is_msi_trigger = false;
+	struct vfio_irq_set hdr;
+	long ret;
+
+	/*
+	 * Pre-fetch SET_IRQS header to avoid TOCTOU from
+	 * re-reading userspace after the core ioctl completes.
+	 */
+	if (cmd == VFIO_DEVICE_SET_IRQS) {
+		unsigned long minsz = offsetofend(struct vfio_irq_set, count);
+
+		if (!copy_from_user(&hdr, (void __user *)arg, minsz)) {
+			is_msi_trigger = (hdr.index == VFIO_PCI_MSI_IRQ_INDEX &&
+					  (hdr.flags & VFIO_IRQ_SET_ACTION_TRIGGER));
+			if (is_msi_trigger)
+				pci_dbg(qdev->vdev.pdev,
+					"SET_IRQS: idx=%u flags=0x%x start=%u count=%u\n",
+					hdr.index, hdr.flags, hdr.start, hdr.count);
+		}
+	}
+
+	ret = vfio_pci_core_ioctl(core_vdev, cmd, arg);
+
+	if (ret == 0 && is_msi_trigger && !qdev->msi_cached)
+		qcom_cache_and_write_msi(qdev);
+
+	return ret;
+}
+
+static const struct vfio_device_ops qcom_vfio_pci_ops = {
+	.name		= "qcom-vfio-pci",
+	.init		= qcom_vfio_pci_init_dev,
+	.release	= vfio_pci_core_release_dev,
+	.open_device	= qcom_vfio_pci_open_device,
+	.close_device	= qcom_vfio_pci_close_device,
+	.ioctl		= qcom_vfio_pci_ioctl,
+	.get_region_info_caps = vfio_pci_ioctl_get_region_info,
+	.device_feature	= vfio_pci_core_ioctl_feature,
+	.read		= qcom_vfio_pci_read,
+	.write		= vfio_pci_core_write,
+	.mmap		= vfio_pci_core_mmap,
+	.request	= vfio_pci_core_request,
+	.match		= vfio_pci_core_match,
+	.match_token_uuid = vfio_pci_core_match_token_uuid,
+	.bind_iommufd	= vfio_iommufd_physical_bind,
+	.unbind_iommufd	= vfio_iommufd_physical_unbind,
+	.attach_ioas	= vfio_iommufd_physical_attach_ioas,
+	.detach_ioas	= vfio_iommufd_physical_detach_ioas,
+};
+
+static int qcom_vfio_pci_probe(struct pci_dev *pdev,
+			       const struct pci_device_id *id)
+{
+	struct qcom_vfio_pci_device *qdev;
+	int ret;
+
+	qdev = vfio_alloc_device(qcom_vfio_pci_device, vdev.vdev,
+				 &pdev->dev, &qcom_vfio_pci_ops);
+	if (IS_ERR(qdev))
+		return PTR_ERR(qdev);
+
+	dev_set_drvdata(&pdev->dev, &qdev->vdev);
+	qdev->vdev.pci_ops = &qcom_vfio_pci_device_ops;
+	ret = vfio_pci_core_register_device(&qdev->vdev);
+	if (ret)
+		goto out_put_vdev;
+
+	return 0;
+
+out_put_vdev:
+	vfio_put_device(&qdev->vdev.vdev);
+	return ret;
+}
+
+static void qcom_vfio_pci_remove(struct pci_dev *pdev)
+{
+	struct vfio_pci_core_device *vdev = dev_get_drvdata(&pdev->dev);
+	struct qcom_vfio_pci_device *qdev = to_qcom_vdev(vdev);
+
+	vfio_pci_core_unregister_device(&qdev->vdev);
+	vfio_put_device(&qdev->vdev.vdev);
+}
+
+static const struct pci_device_id qcom_vfio_pci_table[] = {
+	/* Qualcomm ath11k WiFi */
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_QCOM, 0x1103) },
+	/* Qualcomm ath12k WiFi */
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_QCOM, 0x1107) },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(pci, qcom_vfio_pci_table);
+
+static struct pci_driver qcom_vfio_pci_driver = {
+	.name			= "qcom-vfio-pci",
+	.id_table		= qcom_vfio_pci_table,
+	.probe			= qcom_vfio_pci_probe,
+	.remove			= qcom_vfio_pci_remove,
+	.driver_managed_dma	= true,
+};
+
+static char ids[1024] __initdata;
+module_param_string(ids, ids, sizeof(ids), 0);
+MODULE_PARM_DESC(ids, "Initial PCI IDs to add to the driver, format is \"vendor:device[:subvendor[:subdevice[:class[:class_mask]]]]\" and multiple comma separated entries can be specified");
+
+static void __init qcom_vfio_pci_fill_ids(void)
+{
+	char *p, *id;
+	int rc;
+
+	if (ids[0] == '\0')
+		return;
+
+	p = ids;
+	while ((id = strsep(&p, ","))) {
+		unsigned int vendor, device, subvendor = PCI_ANY_ID,
+			subdevice = PCI_ANY_ID, class = 0, class_mask = 0;
+		int fields;
+
+		if (!strlen(id))
+			continue;
+
+		fields = sscanf(id, "%x:%x:%x:%x:%x:%x",
+				&vendor, &device, &subvendor, &subdevice,
+				&class, &class_mask);
+
+		if (fields < 2) {
+			pr_warn("qcom-vfio-pci: invalid id string \"%s\"\n", id);
+			continue;
+		}
+
+		rc = pci_add_dynid(&qcom_vfio_pci_driver, vendor, device,
+				   subvendor, subdevice, class, class_mask, 0);
+		if (rc)
+			pr_warn("qcom-vfio-pci: failed to add dynamic id [%04x:%04x[%04x:%04x]] class %#08x/%08x (%d)\n",
+				vendor, device, subvendor, subdevice,
+				class, class_mask, rc);
+		else
+			pr_info("qcom-vfio-pci: add [%04x:%04x[%04x:%04x]] class %#08x/%08x\n",
+				vendor, device, subvendor, subdevice,
+				class, class_mask);
+	}
+}
+
+static int __init qcom_vfio_pci_init(void)
+{
+	int ret;
+
+	ret = pci_register_driver(&qcom_vfio_pci_driver);
+	if (ret)
+		return ret;
+
+	qcom_vfio_pci_fill_ids();
+
+	return 0;
+}
+
+static void __exit qcom_vfio_pci_exit(void)
+{
+	pci_unregister_driver(&qcom_vfio_pci_driver);
+}
+
+module_init(qcom_vfio_pci_init);
+module_exit(qcom_vfio_pci_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jose Ignacio Tornos Martinez <jtornosm@redhat.com>");
+MODULE_DESCRIPTION("Qualcomm VFIO PCI - Device-Specific VFIO PCI driver for Qualcomm devices");
diff --git a/drivers/vfio/pci/qcom/msi_quirk.c b/drivers/vfio/pci/qcom/msi_quirk.c
new file mode 100644
index 000000000000..583673d699d5
--- /dev/null
+++ b/drivers/vfio/pci/qcom/msi_quirk.c
@@ -0,0 +1,163 @@
+// SPDX-License-Identifier: GPL-2.0-only
+// SPDX-FileCopyrightText: Copyright Red Hat
+
+#include <linux/kernel.h>
+#include <linux/msi.h>
+#include <linux/pci.h>
+#include <linux/uaccess.h>
+#include <linux/vfio_pci_core.h>
+
+#include "qcom_vfio_pci.h"
+
+/**
+ * qcom_cache_and_write_msi - Cache host MSI address and data
+ * @qdev: Qualcomm VFIO device
+ *
+ * Called after QEMU allocates MSI via SET_IRQS ioctl to cache the physical
+ * host MSI addresses that will be returned to the VM driver.
+ */
+void qcom_cache_and_write_msi(struct qcom_vfio_pci_device *qdev)
+{
+	struct pci_dev *pdev = qdev->vdev.pdev;
+	struct device *dev = &pdev->dev;
+	struct msi_desc *desc;
+	u32 addr_lo, addr_hi;
+	u16 data;
+
+	if (qdev->msi_cached)
+		return;
+
+	if (!qdev->msi_offset)
+		return;
+
+	__msi_lock_descs(dev);
+	desc = msi_first_desc(dev, MSI_DESC_ASSOCIATED);
+	if (!desc) {
+		__msi_unlock_descs(dev);
+		pci_warn(pdev, "MSI descriptor not found\n");
+		return;
+	}
+
+	addr_lo = desc->msg.address_lo;
+	addr_hi = desc->msg.address_hi;
+	data = desc->msg.data;
+	__msi_unlock_descs(dev);
+
+	pci_dbg(pdev, "MSI descriptor - addr_lo=0x%x addr_hi=0x%x data=0x%x\n",
+		 addr_lo, addr_hi, data);
+
+	/*
+	 * Validate: address must be valid. Data can be 0 with interrupt remapping.
+	 * When Intel VT-d interrupt remapping is enabled, the MSI data field
+	 * contains an index into the interrupt remapping table, which can be 0.
+	 * We cache it anyway since that's what the VM driver will program.
+	 */
+	if (!addr_lo) {
+		pci_warn(pdev, "MSI address invalid, skipping cache\n");
+		return;
+	}
+	qdev->msi_addr_lo = addr_lo;
+	qdev->msi_addr_hi = addr_hi;
+	qdev->msi_data = data;
+	qdev->msi_cached = true;
+
+	pci_write_config_dword(pdev, qdev->msi_offset + QCOM_VFIO_MSI_MAGIC_OFFSET,
+			       QCOM_VFIO_MSI_MAGIC);
+	pci_write_config_dword(pdev, qdev->msi_offset + QCOM_VFIO_MSI_ADDR_LO_OFFSET,
+			       qdev->msi_addr_lo);
+	pci_write_config_dword(pdev, qdev->msi_offset + QCOM_VFIO_MSI_ADDR_HI_OFFSET,
+			       qdev->msi_addr_hi);
+	pci_write_config_word(pdev, qdev->msi_offset + QCOM_VFIO_MSI_DATA_OFFSET,
+			      qdev->msi_data);
+
+	pci_info(pdev, "Qualcomm WiFi MSI cached at offset 0x%x - addr_lo=0x%x addr_hi=0x%x data=0x%x (magic=QMSI)\n",
+		 qdev->msi_offset, qdev->msi_addr_lo, qdev->msi_addr_hi, qdev->msi_data);
+}
+
+/**
+ * qcom_intercept_msi_read - Intercept MSI config reads and return cached values
+ * @qdev: Qualcomm VFIO device
+ * @pos: Config space offset
+ * @buf: User buffer
+ * @count: Read size
+ *
+ * Returns: Number of bytes read, or negative error
+ */
+static ssize_t qcom_intercept_msi_read(struct qcom_vfio_pci_device *qdev,
+				       loff_t pos, char __user *buf, size_t count)
+{
+	u32 tmp_val = 0;
+	int msi_magic, msi_addr_lo, msi_addr_hi, msi_data;
+
+	if (!qdev->msi_offset)
+		return -ENOTTY;
+
+	msi_magic = qdev->msi_offset + QCOM_VFIO_MSI_MAGIC_OFFSET;
+	msi_addr_lo = qdev->msi_offset + QCOM_VFIO_MSI_ADDR_LO_OFFSET;
+	msi_addr_hi = qdev->msi_offset + QCOM_VFIO_MSI_ADDR_HI_OFFSET;
+	msi_data = qdev->msi_offset + QCOM_VFIO_MSI_DATA_OFFSET;
+
+	if (pos == msi_magic && count == sizeof(u32)) {
+		if (qdev->msi_cached) {
+			tmp_val = QCOM_VFIO_MSI_MAGIC;
+			pci_dbg(qdev->vdev.pdev, "Intercepting MAGIC read at 0x%llx, returning 0x%x (QMSI)\n",
+				 pos, tmp_val);
+		} else {
+			return -ENOTTY;
+		}
+	} else if (qdev->msi_cached) {
+		if (pos == msi_addr_lo && count == sizeof(u32)) {
+			tmp_val = qdev->msi_addr_lo;
+			pci_dbg(qdev->vdev.pdev, "Intercepting ADDR_LO read at 0x%llx, returning 0x%x\n",
+				 pos, tmp_val);
+		} else if (pos == msi_addr_hi && count == sizeof(u32)) {
+			tmp_val = qdev->msi_addr_hi;
+			pci_dbg(qdev->vdev.pdev, "Intercepting ADDR_HI read at 0x%llx, returning 0x%x\n",
+				 pos, tmp_val);
+		} else if (pos == msi_data && count == sizeof(u16)) {
+			tmp_val = qdev->msi_data;
+			pci_dbg(qdev->vdev.pdev, "Intercepting MSI_DATA read at 0x%llx, returning 0x%x\n",
+				 pos, tmp_val);
+		} else {
+			return -ENOTTY;
+		}
+	} else {
+		return -ENOTTY;
+	}
+
+	if (copy_to_user(buf, &tmp_val, count))
+		return -EFAULT;
+
+	return count;
+}
+
+/**
+ * qcom_vfio_pci_config_rw - Config space read/write with MSI interception
+ * @qdev: Qualcomm VFIO device
+ * @buf: User buffer
+ * @count: Size
+ * @offset: Config space offset (0-0xFFF)
+ * @iswrite: true for write, false for read
+ *
+ * Returns: Number of bytes transferred, or -ENOTTY if not intercepted
+ */
+ssize_t qcom_vfio_pci_config_rw(struct qcom_vfio_pci_device *qdev,
+				char __user *buf, size_t count,
+				loff_t offset, bool iswrite)
+{
+	int msi_range_start, msi_range_end;
+
+	if (iswrite)
+		return -ENOTTY;
+
+	if (!qdev->msi_offset)
+		return -ENOTTY;
+
+	msi_range_start = qdev->msi_offset;
+	msi_range_end = qdev->msi_offset + QCOM_VFIO_MSI_SPACE_SIZE;
+
+	if (offset >= msi_range_start && offset < msi_range_end)
+		return qcom_intercept_msi_read(qdev, offset, buf, count);
+
+	return -ENOTTY;
+}
diff --git a/drivers/vfio/pci/qcom/qcom_vfio_pci.h b/drivers/vfio/pci/qcom/qcom_vfio_pci.h
new file mode 100644
index 000000000000..de37fd94b74b
--- /dev/null
+++ b/drivers/vfio/pci/qcom/qcom_vfio_pci.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* SPDX-FileCopyrightText: Copyright Red Hat */
+
+#ifndef _QCOM_VFIO_PCI_H_
+#define _QCOM_VFIO_PCI_H_
+
+#include <linux/vfio_pci_core.h>
+#include <linux/qcom_vfio.h>
+
+/**
+ * struct qcom_vfio_pci_device - Qualcomm VFIO PCI device with quirks
+ * @vdev: Core VFIO PCI device
+ * @msi_offset: Base offset in extended config for MSI passthrough (0 if disabled)
+ * @msi_cached: Whether host MSI address/data has been cached
+ * @msi_addr_lo: Cached host MSI address (low 32 bits)
+ * @msi_addr_hi: Cached host MSI address (high 32 bits)
+ * @msi_data: Cached host MSI data value
+ */
+struct qcom_vfio_pci_device {
+	struct vfio_pci_core_device vdev;
+
+	/* MSI quirk state */
+	int msi_offset;
+	bool msi_cached;
+	u32 msi_addr_lo;
+	u32 msi_addr_hi;
+	u16 msi_data;
+};
+
+/* MSI quirk functions */
+ssize_t qcom_vfio_pci_config_rw(struct qcom_vfio_pci_device *qdev,
+				char __user *buf, size_t count,
+				loff_t offset, bool iswrite);
+void qcom_cache_and_write_msi(struct qcom_vfio_pci_device *qdev);
+
+#endif /* _QCOM_VFIO_PCI_H_ */
-- 
2.54.0

