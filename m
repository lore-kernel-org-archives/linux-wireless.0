Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793291862;
	b=ANPmWkBB1m/ObtLKk5/ABf/SsM5vZjiB1E0YPSmn33572STxRGxnTjZgEZJ57NKV0CNW
	 GKWbEOUW5yNE6Wen1bIh9gwKXIScLkFrLj6O3Ag+YxCt/+kRxvSu1Xn0JG6yv/n5MfckW
	 yhVFh//h/VwCjBGmOCFIN640oLgdlMzDMVg9HDTfv0ODH+B4GAA9hbTwnnTeTcAsLScni
	 SS//sb4FFugGgwiamPNSXnEJoceoatqPmYlgipc03b5e34jVl26PcbxWrl4YI7SIdogz1
	 fTiD3yzdqb60m/e9/1U8ztzZMJw0ix3QxuREoiL+2WjGKBKVSBOKPNK8q15K/PbF6wA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793291862;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=EL2/HLZV7T4w8h6BrUAxNvEjpz/gOsDFSWb10I0z+sQ=;
	b=xXaAlXah+11ZFBKdPM4kK+NSpj+qUvddqNr2IRww28/vy0DSUt3EtZ0jFqG7Ydguzf8o
	 mpoBwbxAIgVZIgcORxouDipqkqlSyVIPvCxarjM/PHDO68giqQKRPewPU+IXhwez9+ONS
	 VA/lpmDc8wEuQ24M3gLblMFxSGYbNdFkgE7fhvGL07O2VUDdEvV7wHiFvCL1Efj332HAV
	 PACXosnOPEMmxj41ygcdaSxzAwQk+rq/8UVsFUmnIh5CMe7TtgnXdlqZZ2I/XPgME8JMm
	 s1Uk5lsbrD++yp8JYBe1FcIjZNdCGN3DjyVCB0vrcU7pO+CIjuUpsjxCdJU3QwLSxLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ExkecS0C;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83337606A31F
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 16:37:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 83337606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ExkecS0C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793291860;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EL2/HLZV7T4w8h6BrUAxNvEjpz/gOsDFSWb10I0z+sQ=;
	b=ExkecS0Cm0DltnU020k0EEOeHNfVP0NhCpK/G35j103fxNC2kKHErgNfV/aOBqePRdplNF
	AIoeBr2V9S3pGjTbRYnNptDR4om+2TigAgep9S+1kqZk/KrCwIISoey4kwenhO3nIOWSo9
	nntZddY8WH1j3wptqGt8jl2vM6vQe9c=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-271-U8TEP4GpNzm9BiNBv0dUfQ-1; Thu,
 29 Oct 2026 12:37:37 -0400
X-MC-Unique: U8TEP4GpNzm9BiNBv0dUfQ-1
X-Mimecast-MFC-AGG-ID: U8TEP4GpNzm9BiNBv0dUfQ_1793291854
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 12ADE195FDF4;
	Thu, 29 Oct 2026 16:37:34 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2A4BC1956088;
	Thu, 29 Oct 2026 16:37:28 +0000 (UTC)
From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
To: jgg@ziepe.ca,
	alex@shazbot.org,
	pbonzini@redhat.com,
	seanjc@google.com,
	bhelgaas@google.com,
	jjohnson@kernel.org
Cc: johannes@sipsolutions.net,
	mani@kernel.org,
	lpieralisi@kernel.org,
	kwilczynski@kernel.org,
	robh@kernel.org,
	vkuznets@redhat.com,
	kevin.tian@intel.com,
	linux-pci@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Subject: [PATCH v3 1/8] vfio: add helper to find PCI device by vendor/device ID
Date: Thu, 29 Oct 2026 17:37:06 +0100
Message-ID: <20261029163713.1366077-2-jtornosm@redhat.com>
In-Reply-To: <20261029163713.1366077-1-jtornosm@redhat.com>
References: <20261029163713.1366077-1-jtornosm@redhat.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Add vfio_file_find_pci_device() that searches for a PCI device with
the specified vendor/device ID within a VFIO group or device file. The
function walks the group device list to find a matching PCI device, or
checks the single device for a cdev-based file.

This helper enables other subsystems (e.g. KVM PCI MSI domain) to
locate VFIO-owned PCI devices by their IDs without depending on VFIO
internals. The companion vfio_file_device() provides access to the
underlying vfio_device from a device file descriptor.

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
---
v3: new
v2: https://lore.kernel.org/all/20261011074514.515894-1-jtornosm@redhat.com/

 drivers/vfio/group.c     | 41 ++++++++++++++++++++++++++++++++++++++++
 drivers/vfio/vfio_main.c |  6 ++++++
 include/linux/vfio.h     | 10 ++++++++++
 3 files changed, 57 insertions(+)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index 185f359f75d3..0b6cf90edda3 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -10,6 +10,7 @@
  * Author: Tom Lyon, pugs@cisco.com
  */
 
+#include <linux/pci.h>
 #include <linux/vfio.h>
 #include <linux/iommufd.h>
 #include <linux/anon_inodes.h>
@@ -894,6 +895,46 @@ bool vfio_file_has_dev(struct file *file, struct vfio_device *device)
 }
 EXPORT_SYMBOL_GPL(vfio_file_has_dev);
 
+struct vfio_device *vfio_file_find_pci_device(struct file *file,
+					      u16 vendor, u16 device_id)
+{
+	struct vfio_group *group;
+	struct vfio_device *vdev;
+	struct vfio_device *ret = NULL;
+
+	group = vfio_group_from_file(file);
+	if (group) {
+		mutex_lock(&group->device_lock);
+		list_for_each_entry(vdev, &group->device_list, group_next) {
+			struct pci_dev *pdev;
+
+			if (!dev_is_pci(vdev->dev))
+				continue;
+
+			pdev = to_pci_dev(vdev->dev);
+			if (pdev->vendor == vendor &&
+			    pdev->device == device_id) {
+				ret = vdev;
+				break;
+			}
+		}
+		mutex_unlock(&group->device_lock);
+		return ret;
+	}
+
+	vdev = vfio_file_device(file);
+	if (vdev && dev_is_pci(vdev->dev)) {
+		struct pci_dev *pdev = to_pci_dev(vdev->dev);
+
+		if (pdev->vendor == vendor &&
+		    pdev->device == device_id)
+			return vdev;
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(vfio_file_find_pci_device);
+
 static char *vfio_devnode(const struct device *dev, umode_t *mode)
 {
 	return kasprintf(GFP_KERNEL, "vfio/%s", dev_name(dev));
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 4e5d738ccf4b..a83e5d805eac 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1551,6 +1551,12 @@ void vfio_file_set_kvm(struct file *vfio_file, struct file *kvm)
 }
 EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
 
+struct vfio_device *vfio_file_device(struct file *file)
+{
+	return vfio_device_from_file(file);
+}
+EXPORT_SYMBOL_GPL(vfio_file_device);
+
 /*
  * Sub-module support
  */
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 0cc91c6f96d2..a62fbf42458a 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -364,6 +364,8 @@ struct iommu_group *vfio_file_iommu_group(struct file *file);
 #if IS_ENABLED(CONFIG_VFIO_GROUP)
 bool vfio_file_is_group(struct file *file);
 bool vfio_file_has_dev(struct file *file, struct vfio_device *device);
+struct vfio_device *vfio_file_find_pci_device(struct file *file,
+					      u16 vendor, u16 device_id);
 #else
 static inline bool vfio_file_is_group(struct file *file)
 {
@@ -374,10 +376,18 @@ static inline bool vfio_file_has_dev(struct file *file, struct vfio_device *devi
 {
 	return false;
 }
+
+static inline struct vfio_device *vfio_file_find_pci_device(struct file *file,
+							    u16 vendor,
+							    u16 device_id)
+{
+	return NULL;
+}
 #endif
 bool vfio_file_is_valid(struct file *file);
 bool vfio_file_enforced_coherent(struct file *file);
 void vfio_file_set_kvm(struct file *vfio_file, struct file *kvm);
+struct vfio_device *vfio_file_device(struct file *file);
 
 #define VFIO_PIN_PAGES_MAX_ENTRIES	(PAGE_SIZE/sizeof(unsigned long))
 
-- 
2.56.0

