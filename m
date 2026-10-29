Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793291868;
	b=sNmuiWIg7lsdTrkgQQX6AWA94Udlz4KmAZVOUAKQw31r0zvx4Faxob5BQO1iWU70uBOr
	 fbrpDktgLZg4j/5M42Hzt3+irAIXv0uVay5oRnsUJAbTU6ATfsJ36G9aTiBxZvqv/YX6n
	 FdSZW5C597mluHNBO2nr2k//8uWjJA+nNAmh8YUVllzSSjy1HZvee0kDIJpY/kHP9tUon
	 YtRx0TizuNuED7PWis7thzTl7mpEoMQYjb6iT7sRNbhd2TXyFMZge8NhTEHVTAfagM/Vx
	 3awIJ8BIgrdUooD6R8Ifq38vficW35YsbLFu6ql8Y8hpa6YJwcf3SxikNNo1yvTx+sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793291868;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=UPYTek6wuZR3RFTVbmpzV/dpdd/bHHoy5BiG4jXXPbk=;
	b=HtSiLvv0H3m6Nql5ylkfhWMUWa7Gbo/NauyM2mNaiPlurq/FdnjngYAN6V8BZYw167L6
	 ONyU0uSyITQ+BsEUVhQK48Nj9eHXMweUiNYheTutNQjNXEm2H7Kx8cD1l21PWhND9PzGn
	 J3Z2NDpMvzAj0Nw/rptCrCcrAUR8NJV/Uh2jqQYLAZnlUywWhphspFNiGVLnqkS7hxWrW
	 xuOHKdi1H2WgMbkO3uSfshoi7XSkknR8V9PxHcetfEUNL90HooClI1RbG8Fd1zDafiTOb
	 OxCaF6fB0oK6RnwIbuDCmg03Q2/04AZ6lCJvqsYGdzdlvcyQkS+ff1UydM/i9AS/jvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Y6yT1TC6;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16FAE606A327
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 16:37:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 16FAE606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Y6yT1TC6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793291867;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UPYTek6wuZR3RFTVbmpzV/dpdd/bHHoy5BiG4jXXPbk=;
	b=Y6yT1TC6RcHx3+II/3Txol3kfN6JFqPFEL/chnwYZ800oUmMoxHlyi7jlefDRL1m+ihdML
	UwOpIIV3frzsVJwQ4nGUpHUPD8F9UrwMl5B49+/JTn/J7+FHrWCCYgITPFBhHV6L5Ixyh5
	OpXRUKfKj2rSGGFQE2f9RJEx+gzl9dU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-65-Pg7fpbxHOSyRPKo45j9n-w-1; Thu,
 29 Oct 2026 12:37:43 -0400
X-MC-Unique: Pg7fpbxHOSyRPKo45j9n-w-1
X-Mimecast-MFC-AGG-ID: Pg7fpbxHOSyRPKo45j9n-w_1793291861
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D0EA21944F00;
	Thu, 29 Oct 2026 16:37:40 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 70AA81955F01;
	Thu, 29 Oct 2026 16:37:36 +0000 (UTC)
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
Subject: [PATCH v3 2/8] KVM: add PCI MSI hypercall for VFIO passthrough
Date: Thu, 29 Oct 2026 17:37:07 +0100
Message-ID: <20261029163713.1366077-3-jtornosm@redhat.com>
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

Some PCI devices (e.g. Qualcomm WiFi adapters) have firmware that
programs MSI addresses directly into device BAR registers, bypassing
the standard PCI config MSI path. When these devices are passed
through to VMs via VFIO, the firmware programs the guest virtual MSI
address instead of the host physical IRTE address, causing DMAR faults
and non-functional interrupts.

Add a KVM hypercall (KVM_HC_PCI_MSI_ALLOC) that allows a guest to
request the host's physical MSI address/data for a VFIO-assigned PCI
device. The hypercall is dispatched from the x86 hypercall handler to
a VFIO backend that:

1. Finds the host PCI device matching the guest's vendor:device ID
   using vfio_file_find_pci_device() (introduced in a previous patch)
2. Reads the host MSI address/data from the device's msi_desc or
   by walking the IRQ domain compose chain
3. Returns the result to the guest via a GPA response buffer

The VFIO handler is connected to the KVM instance via a function
pointer (pci_msi_alloc) in struct kvm, set when the VFIO device is
created and cleared on release. This avoids a hard dependency between
KVM and VFIO subsystems.

When MSI is not yet enabled by QEMU, or the IRQ vector is not
configured, the handler returns success with a zeroed response,
allowing the guest to poll until the host MSI is ready.

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
---
v3: new
v2: https://lore.kernel.org/all/20261011074514.515894-1-jtornosm@redhat.com/

 arch/x86/kvm/x86.c            | 39 ++++++++++++++
 include/linux/kvm_host.h      |  3 ++
 include/uapi/linux/kvm_para.h |  1 +
 virt/kvm/vfio.c               | 97 +++++++++++++++++++++++++++++++++++
 virt/kvm/vfio.h               |  8 +++
 5 files changed, 148 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 32563a91fba9..2f0cae07f978 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -86,6 +86,7 @@
 #include <asm/sgx.h>
 #include <asm/virt.h>
 
+#include <linux/msi.h>
 #include <clocksource/hyperv_timer.h>
 
 #define CREATE_TRACE_POINTS
@@ -7490,6 +7491,44 @@ int ____kvm_emulate_hypercall(struct kvm_vcpu *vcpu, int cpl,
 		vcpu->arch.complete_userspace_io = complete_hypercall;
 		return 0;
 	}
+	case KVM_HC_PCI_MSI_ALLOC: {
+		struct msi_msg msg = {};
+		struct {
+			u32 address_lo;
+			u32 address_hi;
+			u32 data;
+			u32 reserved;
+		} resp;
+
+		if (vcpu->kvm->pci_msi_alloc == NULL) {
+			ret = -KVM_ENOSYS;
+			break;
+		}
+
+		/*
+		 * a0 = PCI vendor:device (vendor << 16 | device)
+		 * a1 = MSI vector index
+		 * a2 = GPA of response buffer
+		 */
+		ret = vcpu->kvm->pci_msi_alloc(vcpu->kvm, a0, a1, &msg);
+		if (ret) {
+			ret = -KVM_EINVAL;
+			break;
+		}
+
+		resp.address_lo = msg.address_lo;
+		resp.address_hi = msg.address_hi;
+		resp.data = msg.data;
+		resp.reserved = 0;
+
+		if (kvm_write_guest(vcpu->kvm, a2, &resp, sizeof(resp))) {
+			ret = -KVM_EFAULT;
+			break;
+		}
+
+		ret = 0;
+		break;
+	}
 	default:
 		ret = -KVM_ENOSYS;
 		break;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e7fc94e2910a..4921810e9f3f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -871,6 +871,9 @@ struct kvm {
 	struct xarray mem_attr_array;
 #endif
 	char stats_id[KVM_STATS_NAME_SIZE];
+
+	int (*pci_msi_alloc)(struct kvm *kvm, u32 devid,
+			     unsigned int vector, struct msi_msg *msg);
 };
 
 #define kvm_err(fmt, ...) \
diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
index 960c7e93d1a9..3c7ca359faa6 100644
--- a/include/uapi/linux/kvm_para.h
+++ b/include/uapi/linux/kvm_para.h
@@ -30,6 +30,7 @@
 #define KVM_HC_SEND_IPI		10
 #define KVM_HC_SCHED_YIELD		11
 #define KVM_HC_MAP_GPA_RANGE		12
+#define KVM_HC_PCI_MSI_ALLOC		13
 
 /*
  * hypercalls use architecture specific
diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 19548a430942..60356173e69f 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -11,7 +11,10 @@
 #include <linux/kvm_host.h>
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/irq.h>
+#include <linux/msi.h>
 #include <linux/mutex.h>
+#include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 #include <linux/vfio.h>
@@ -315,6 +318,8 @@ static void kvm_vfio_release(struct kvm_device *dev)
 
 	kvm_vfio_update_coherency(dev);
 
+	dev->kvm->pci_msi_alloc = NULL;
+
 	kfree(kv);
 	kfree(dev); /* alloc by kvm_ioctl_create_device, free by .release */
 }
@@ -349,6 +354,98 @@ static int kvm_vfio_create(struct kvm_device *dev, u32 type)
 	mutex_init(&kv->lock);
 
 	dev->private = kv;
+	dev->kvm->pci_msi_alloc = kvm_vfio_pci_msi_alloc;
+
+	return 0;
+}
+
+/**
+ * kvm_vfio_pci_msi_alloc - Get physical MSI address/data for a VFIO device
+ * @kvm: the VM instance
+ * @devid: PCI vendor:device packed as (vendor << 16 | device)
+ * @vector: MSI vector index
+ * @msg: output MSI message (address + data)
+ *
+ * Walks VFIO files attached to this VM, uses vfio_file_find_pci_device()
+ * to find the PCI device matching the given vendor:device ID, and returns
+ * the host's physical MSI address/data for the requested vector.
+ *
+ * Returns 0 on success, negative errno on failure.
+ */
+int kvm_vfio_pci_msi_alloc(struct kvm *kvm, u32 devid,
+			     unsigned int vector, struct msi_msg *msg)
+{
+	struct kvm_vfio_file *kvf;
+	struct kvm_vfio *kv = NULL;
+	struct vfio_device *vdev;
+	struct kvm_device *dev;
+	struct msi_desc *desc;
+	struct irq_data *irqd;
+	struct pci_dev *pdev;
+	u16 vendor = devid >> 16;
+	u16 device = devid & 0xffff;
+	int irq;
+
+	scoped_guard(mutex, &kvm->lock) {
+		list_for_each_entry(dev, &kvm->devices, vm_node) {
+			if (dev->ops == &kvm_vfio_ops) {
+				kv = dev->private;
+				break;
+			}
+		}
+	}
+
+	if (!kv)
+		return -ENODEV;
+
+	guard(mutex)(&kv->lock);
+
+	vdev = NULL;
+	list_for_each_entry(kvf, &kv->file_list, node) {
+		vdev = vfio_file_find_pci_device(kvf->file, vendor, device);
+		if (vdev)
+			break;
+	}
+
+	if (!vdev)
+		return -ENODEV;
+
+	pdev = to_pci_dev(vdev->dev);
+
+	if (!pdev->msi_enabled && !pdev->msix_enabled) {
+		memset(msg, 0, sizeof(*msg));
+		return 0;
+	}
+
+	irq = pci_irq_vector(pdev, vector);
+	if (irq <= 0) {
+		memset(msg, 0, sizeof(*msg));
+		return 0;
+	}
+
+	irqd = irq_get_irq_data(irq);
+	if (!irqd) {
+		memset(msg, 0, sizeof(*msg));
+		return 0;
+	}
+
+	desc = irq_get_msi_desc(irq);
+	if (desc) {
+		*msg = desc->msg;
+	} else {
+		struct irq_data *pos;
+
+		for (pos = irqd; pos; pos = pos->parent_data) {
+			if (pos->chip && pos->chip->irq_compose_msi_msg) {
+				pos->chip->irq_compose_msi_msg(pos, msg);
+				break;
+			}
+		}
+		if (!pos) {
+			memset(msg, 0, sizeof(*msg));
+			return 0;
+		}
+	}
 
 	return 0;
 }
diff --git a/virt/kvm/vfio.h b/virt/kvm/vfio.h
index e130a4a03530..c2237ca9ff38 100644
--- a/virt/kvm/vfio.h
+++ b/virt/kvm/vfio.h
@@ -5,6 +5,8 @@
 #ifdef CONFIG_KVM_VFIO
 int kvm_vfio_ops_init(void);
 void kvm_vfio_ops_exit(void);
+int kvm_vfio_pci_msi_alloc(struct kvm *kvm, u32 devid,
+			     unsigned int vector, struct msi_msg *msg);
 #else
 static inline int kvm_vfio_ops_init(void)
 {
@@ -13,6 +15,12 @@ static inline int kvm_vfio_ops_init(void)
 static inline void kvm_vfio_ops_exit(void)
 {
 }
+static inline int kvm_vfio_pci_msi_alloc(struct kvm *kvm, u32 devid,
+					   unsigned int vector,
+					   struct msi_msg *msg)
+{
+	return -ENODEV;
+}
 #endif
 
 #endif
-- 
2.56.0

