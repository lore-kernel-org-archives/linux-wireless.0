Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793291880;
	b=Grf3LXTvrXIKlHPl97yYD6pFh3wimQW10C1ZOSkYgVhGYixsLOqVVJEKmM04iCpsiX1B
	 Nk3Y230MEaXZkorixCnrP13rMPHZg/sG7vVWCOQM50VGORy1MH6bsgswUUaOiOPKMUTmu
	 07DEY61vccbD6J473Zc/VlumfC2xIQ5mtsCNRe5Q8m5rjchhhZ0taF2yrye7fp2UVU5jJ
	 lu0d/xa+TnwPEB4dIrq4q48AmAnPRQ/5Wg4nRG7KajnwO3e5aWLtd1i5PFlG52eWZBD/2
	 UBxJTwztTsyQ12IfWIqUMEeq20Iaq7Vje1Npft6XH1qOjqsvtaPdVJNMwXXtC1QacgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793291880;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=zAG+0WSFA5WXD5miil2adZSlV6mL923L244kg/kLehA=;
	b=UASgi1cMxWSpuveYtoC573/mZmQ/HxYLfMjaWI8rp/ZJsfFtdkUQIVH4O2R7S27p5O+p
	 vEF4d3LBaZtMWwamUB4zRzW6FOh2hOvKfbNmWnedYG/cQKIptdzbKn3jW8OORzunLoGIL
	 O8O3i1+ZWrHKZ83E/LQuEASrIDd+4fFvBSvLWvgzmZhFBlgli5ERCxsOIAkmw9ZPEumyi
	 Thpp/YQpxmfWnefjwXM6Udc04EaNkGXJ8unC+EVU7y71yYia5ZE/9Uqm3jeyB3nGxmWlU
	 YM72rzPvCMfwXnX6Q0n9I/8GqPgM9Y9NQkiR8BMu1DMeco2MTTTq157Z1okJ96YzfzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=TOH6G7DA;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7164606A321
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 16:37:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B7164606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=TOH6G7DA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793291877;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zAG+0WSFA5WXD5miil2adZSlV6mL923L244kg/kLehA=;
	b=TOH6G7DAS0+ndGQXpWb+ncX9nGWmGEPiTh74r5AGcfHGOhnhX3PmTdPJZI6GN7Zz0cJ+Uw
	8GekRnQWVDtID447R4M0kqhbLTt+KzylBqy/aHwfJGYfPgraSq+mhYYHtde48H2/wO7LWK
	CT6LEvtLDNPlaQSkkPz5oBxOapCtmM0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-646-R8ynF9VIMbeTW0w4eCc8aw-1; Thu,
 29 Oct 2026 12:37:53 -0400
X-MC-Unique: R8ynF9VIMbeTW0w4eCc8aw-1
X-Mimecast-MFC-AGG-ID: R8ynF9VIMbeTW0w4eCc8aw_1793291870
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 557F0193FA9B;
	Thu, 29 Oct 2026 16:37:49 +0000 (UTC)
Received: from jtornosm-thinkpadp1gen7.rmtes.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0F8D81956088;
	Thu, 29 Oct 2026 16:37:44 +0000 (UTC)
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
Subject: [PATCH v3 3/8] PCI: add KVM MSI domain guest module
Date: Thu, 29 Oct 2026 17:37:08 +0100
Message-ID: <20261029163713.1366077-4-jtornosm@redhat.com>
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

Add a guest-side PCI MSI IRQ domain driver for KVM virtual machines
that intercepts MSI composition for devices whose firmware programs
MSI addresses directly into BAR registers.

The problem: Qualcomm WiFi devices (ath11k/ath12k) have embedded
firmware that programs MSI target addresses from values cached at
driver init time. In a VM with VFIO passthrough, the driver sees
the guest's virtual APIC address instead of the host's physical
IRTE address. When the firmware writes this guest address to BAR
registers, the resulting MSI goes to a stale or invalid IRTE,
causing DMAR faults.

The solution: This module creates a custom MSI parent IRQ domain
(modeled on pci-hyperv.c) that interposes between the PCI MSI layer
and the platform's existing MSI domain. It provides two exported
functions for use by device drivers:

  - kvm_pci_msi_wait_ready(): Polls a KVM hypercall
    (KVM_HC_PCI_MSI_ALLOC, introduced in a previous patch) until the
    host returns non-zero MSI address/data. Caches the result in
    per-vector chip_data and updates msi_desc->msg for the base
    vector.

  - kvm_pci_msi_get_address(): Returns cached host MSI address/data
    previously obtained by wait_ready. Allows drivers that read MSI
    addresses on-the-fly (like ath12k) to get the host values without
    another hypercall.

On baremetal (no KVM), kvm_para_available() returns false and
wait_ready returns 0 immediately, so drivers guarded with
IS_ENABLED(CONFIG_PCI_KVM_MSI_DOMAIN) have zero overhead.

The compose callback is maintained for completeness: if the MSI
framework recomposes after wait_ready has populated the cache, the
cached host values are returned instead of the guest virtual address.

The module matches devices by PCI ID table, attaches the custom MSI
domain before driver probe via bus notifier, and requires the
pci-kvm-msi module to load before the wireless drivers via
MODULE_SOFTDEP in the driver patches.

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
---
v3: new
v2: https://lore.kernel.org/all/20261011074514.515894-1-jtornosm@redhat.com/

 drivers/pci/controller/Kconfig       |  12 +
 drivers/pci/controller/Makefile      |   1 +
 drivers/pci/controller/pci-kvm-msi.c | 437 +++++++++++++++++++++++++++
 include/linux/pci-kvm-msi.h          |  13 +
 4 files changed, 463 insertions(+)
 create mode 100644 drivers/pci/controller/pci-kvm-msi.c
 create mode 100644 include/linux/pci-kvm-msi.h

diff --git a/drivers/pci/controller/Kconfig b/drivers/pci/controller/Kconfig
index d246bbe37948..cdf65d1c2674 100644
--- a/drivers/pci/controller/Kconfig
+++ b/drivers/pci/controller/Kconfig
@@ -248,6 +248,18 @@ config PCI_HYPERV_INTERFACE
 	  drivers to have a common interface with the Hyper-V PCI frontend
 	  driver.
 
+config PCI_KVM_MSI_DOMAIN
+	tristate "KVM PCI passthrough MSI domain"
+	depends on X86_64 && KVM_GUEST && PCI_MSI
+	select IRQ_MSI_LIB
+	help
+	  Provides physical MSI address/data to PCI devices in KVM guests
+	  that need them for firmware-managed interrupts. Required for
+	  passthrough of devices like Qualcomm WiFi where firmware programs
+	  MSI addresses directly.
+
+	  If unsure, say N.
+
 config PCI_TEGRA
 	tristate "NVIDIA Tegra PCIe controller"
 	depends on ARCH_TEGRA || COMPILE_TEST
diff --git a/drivers/pci/controller/Makefile b/drivers/pci/controller/Makefile
index d478743b5142..4f10edae0f92 100644
--- a/drivers/pci/controller/Makefile
+++ b/drivers/pci/controller/Makefile
@@ -4,6 +4,7 @@ obj-$(CONFIG_PCI_FTPCI100) += pci-ftpci100.o
 obj-$(CONFIG_PCI_IXP4XX) += pci-ixp4xx.o
 obj-$(CONFIG_PCI_HYPERV) += pci-hyperv.o
 obj-$(CONFIG_PCI_HYPERV_INTERFACE) += pci-hyperv-intf.o
+obj-$(CONFIG_PCI_KVM_MSI_DOMAIN) += pci-kvm-msi.o
 obj-$(CONFIG_PCI_MVEBU) += pci-mvebu.o
 obj-$(CONFIG_PCI_AARDVARK) += pci-aardvark.o
 obj-$(CONFIG_PCI_TEGRA) += pci-tegra.o
diff --git a/drivers/pci/controller/pci-kvm-msi.c b/drivers/pci/controller/pci-kvm-msi.c
new file mode 100644
index 000000000000..e2b0a4114aa8
--- /dev/null
+++ b/drivers/pci/controller/pci-kvm-msi.c
@@ -0,0 +1,437 @@
+// SPDX-License-Identifier: GPL-2.0-only
+// SPDX-FileCopyrightText: Copyright Red Hat
+/*
+ * KVM PCI MSI domain driver
+ *
+ * Provides physical MSI address/data to PCI devices in KVM guests that
+ * need them for firmware-managed interrupts (e.g., Qualcomm WiFi devices
+ * where firmware programs MSI addresses directly).
+ *
+ * Modeled on pci-hyperv.c MSI domain. Instead of VMbus messages, uses
+ * KVM hypercalls to request physical MSI addresses from the host.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/pci.h>
+#include <linux/pci-kvm-msi.h>
+#include <linux/pci_ids.h>
+#include <linux/msi.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <linux/kvm_para.h>
+#include <linux/irqchip/irq-msi-lib.h>
+#include <asm/hw_irq.h>
+#include <asm/pgtable_types.h>
+
+struct kvm_msi_response {
+	u32 address_lo;
+	u32 address_hi;
+	u32 data;
+	u32 reserved;
+};
+
+struct kvm_msi_irq_data {
+	struct msi_msg msg;
+	u32 devid;
+	unsigned int vector;
+	bool cached;
+};
+
+#define KVM_MSI_POLL_INTERVAL_MS	10
+
+static struct irq_domain *kvm_msi_domain;
+
+struct kvm_msi_ctx {
+	struct pci_dev *pdev;
+	struct irq_domain *domain;
+	u32 devid;
+	unsigned int first_virq;
+	unsigned int nr_irqs;
+};
+
+static struct kvm_msi_ctx kvm_msi_ctx;
+
+int kvm_pci_msi_wait_ready(struct pci_dev *pdev, unsigned long timeout_ms)
+{
+	struct kvm_msi_response resp = {};
+	struct kvm_msi_irq_data *kvm_data;
+	unsigned int max_retries;
+	struct irq_data *irqd;
+	struct msi_desc *desc;
+	unsigned int retries;
+	long hret;
+	int i;
+
+	if (!kvm_para_available())
+		return 0;
+
+	if (!kvm_msi_domain)
+		return 0;
+
+	if (!pdev || !kvm_msi_ctx.pdev || kvm_msi_ctx.pdev != pdev)
+		return 0;
+
+	max_retries = timeout_ms / KVM_MSI_POLL_INTERVAL_MS;
+	if (!max_retries)
+		max_retries = 1;
+
+	for (retries = 0; retries < max_retries; retries++) {
+		memset(&resp, 0, sizeof(resp));
+		hret = kvm_hypercall3(KVM_HC_PCI_MSI_ALLOC,
+				      kvm_msi_ctx.devid, 0,
+				      slow_virt_to_phys(&resp));
+
+		if (hret == 0 && resp.address_lo != 0)
+			goto ready;
+
+		msleep(KVM_MSI_POLL_INTERVAL_MS);
+	}
+
+	pr_err("kvm-pci-msi: %s wait timed out after %lu ms\n",
+	       pci_name(pdev), timeout_ms);
+	return -ETIMEDOUT;
+
+ready:
+	pr_info("kvm-pci-msi: %s host addr=%08x:%08x data=%08x\n",
+		pci_name(pdev), resp.address_hi, resp.address_lo,
+		resp.data);
+
+	for (i = 0; i < kvm_msi_ctx.nr_irqs; i++) {
+		irqd = irq_domain_get_irq_data(kvm_msi_ctx.domain,
+						kvm_msi_ctx.first_virq + i);
+		if (!irqd)
+			continue;
+		kvm_data = irqd->chip_data;
+		if (!kvm_data)
+			continue;
+
+		kvm_data->msg.address_lo = resp.address_lo;
+		kvm_data->msg.address_hi = resp.address_hi;
+		kvm_data->msg.data = resp.data + i;
+		kvm_data->cached = true;
+	}
+
+	desc = irq_get_msi_desc(pdev->irq);
+	if (desc) {
+		desc->msg.address_lo = resp.address_lo;
+		desc->msg.address_hi = resp.address_hi;
+		desc->msg.data = resp.data;
+	}
+
+	return 1;
+}
+EXPORT_SYMBOL_GPL(kvm_pci_msi_wait_ready);
+
+int kvm_pci_msi_get_address(struct pci_dev *pdev, u32 *addr_lo, u32 *addr_hi,
+			     u32 *data)
+{
+	struct kvm_msi_irq_data *kvm_data;
+	struct irq_data *irqd;
+
+	if (!kvm_msi_domain)
+		return 0;
+
+	if (!pdev || !kvm_msi_ctx.pdev || kvm_msi_ctx.pdev != pdev)
+		return 0;
+
+	irqd = irq_domain_get_irq_data(kvm_msi_ctx.domain,
+					kvm_msi_ctx.first_virq);
+	if (!irqd)
+		return 0;
+
+	kvm_data = irqd->chip_data;
+	if (!kvm_data || !kvm_data->cached)
+		return 0;
+
+	*addr_lo = kvm_data->msg.address_lo;
+	*addr_hi = kvm_data->msg.address_hi;
+	if (data)
+		*data = kvm_data->msg.data;
+
+	return 1;
+}
+EXPORT_SYMBOL_GPL(kvm_pci_msi_get_address);
+
+static void kvm_parent_compose_msi_msg(struct irq_data *data,
+				       struct msi_msg *msg)
+{
+	struct irq_data *pos;
+
+	for (pos = data->parent_data; pos; pos = pos->parent_data) {
+		if (pos->chip && pos->chip->irq_compose_msi_msg) {
+			pos->chip->irq_compose_msi_msg(pos, msg);
+			return;
+		}
+	}
+	memset(msg, 0, sizeof(*msg));
+}
+
+static void kvm_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
+{
+	struct kvm_msi_irq_data *kvm_data = data->chip_data;
+
+	if (kvm_data && kvm_data->cached) {
+		*msg = kvm_data->msg;
+		return;
+	}
+
+	kvm_parent_compose_msi_msg(data, msg);
+}
+
+static struct irq_chip kvm_msi_irq_chip = {
+	.name			= "KVM-MSI",
+	.irq_compose_msi_msg	= kvm_compose_msi_msg,
+	.irq_set_affinity	= irq_chip_set_affinity_parent,
+	.irq_ack		= irq_chip_ack_parent,
+};
+
+static int kvm_pcie_domain_alloc(struct irq_domain *d, unsigned int virq,
+				 unsigned int nr_irqs, void *arg)
+{
+	struct irq_alloc_info *info = arg;
+	struct kvm_msi_irq_data *kvm_data;
+	struct msi_desc *desc;
+	struct pci_dev *pdev;
+	u32 devid;
+	int ret;
+	int i;
+
+	ret = irq_domain_alloc_irqs_parent(d, virq, nr_irqs, arg);
+	if (ret < 0)
+		return ret;
+
+	desc = info->desc;
+	if (!desc || !desc->dev || !dev_is_pci(desc->dev)) {
+		ret = -EINVAL;
+		goto err_free_parent;
+	}
+
+	pdev = to_pci_dev(desc->dev);
+	devid = ((u32)pdev->vendor << 16) | pdev->device;
+
+	for (i = 0; i < nr_irqs; i++) {
+		kvm_data = kzalloc_obj(*kvm_data);
+		if (!kvm_data) {
+			ret = -ENOMEM;
+			goto err_free_data;
+		}
+
+		kvm_data->devid = devid;
+		kvm_data->vector = desc->msi_index + i;
+
+		irq_domain_set_info(d, virq + i, virq + i,
+				    &kvm_msi_irq_chip, kvm_data,
+				    handle_edge_irq, NULL, "KVM-MSI");
+	}
+
+	kvm_msi_ctx.pdev = pdev;
+	kvm_msi_ctx.devid = devid;
+	kvm_msi_ctx.first_virq = virq;
+	kvm_msi_ctx.nr_irqs = nr_irqs;
+	kvm_msi_ctx.domain = d;
+
+	return 0;
+
+err_free_data:
+	for (i--; i >= 0; i--) {
+		kvm_data = irq_data_get_irq_chip_data(
+				irq_domain_get_irq_data(d, virq + i));
+		kfree(kvm_data);
+	}
+err_free_parent:
+	irq_domain_free_irqs_parent(d, virq, nr_irqs);
+	return ret;
+}
+
+static void kvm_pcie_domain_free(struct irq_domain *d, unsigned int virq,
+				 unsigned int nr_irqs)
+{
+	struct kvm_msi_irq_data *kvm_data;
+	int i;
+
+	if (kvm_msi_ctx.first_virq == virq) {
+		kvm_msi_ctx.pdev = NULL;
+		kvm_msi_ctx.nr_irqs = 0;
+	}
+
+	for (i = 0; i < nr_irqs; i++) {
+		kvm_data = irq_data_get_irq_chip_data(
+				irq_domain_get_irq_data(d, virq + i));
+		kfree(kvm_data);
+	}
+	irq_domain_free_irqs_top(d, virq, nr_irqs);
+}
+
+static const struct irq_domain_ops kvm_pcie_domain_ops = {
+	.alloc	= kvm_pcie_domain_alloc,
+	.free	= kvm_pcie_domain_free,
+};
+
+static bool kvm_pcie_init_dev_msi_info(struct device *dev,
+				       struct irq_domain *domain,
+				       struct irq_domain *real_parent,
+				       struct msi_domain_info *info)
+{
+	struct irq_chip *chip = info->chip;
+
+	if (!msi_lib_init_dev_msi_info(dev, domain, real_parent, info)) {
+		pr_err("kvm-pci-msi: msi_lib_init_dev_msi_info failed for %s\n",
+		       dev_name(dev));
+		return false;
+	}
+
+	info->ops->msi_prepare = pci_msi_prepare;
+
+	chip->irq_set_affinity = irq_chip_set_affinity_parent;
+	chip->irq_retrigger = irq_chip_retrigger_hierarchy;
+	chip->flags |= IRQCHIP_MOVE_DEFERRED;
+
+	return true;
+}
+
+static const struct msi_parent_ops kvm_pcie_msi_parent_ops = {
+	.required_flags		= MSI_FLAG_USE_DEF_DOM_OPS |
+				  MSI_FLAG_USE_DEF_CHIP_OPS,
+	.supported_flags	= MSI_GENERIC_FLAGS_MASK |
+				  MSI_FLAG_PCI_MSIX,
+	.bus_select_token	= DOMAIN_BUS_PCI_MSI,
+	.chip_flags		= MSI_CHIP_FLAG_SET_ACK,
+	.init_dev_msi_info	= kvm_pcie_init_dev_msi_info,
+};
+
+static int kvm_msi_create_domain(struct pci_dev *ref_dev)
+{
+	struct irq_domain *parent;
+	struct irq_domain_info info = {
+		.ops		= &kvm_pcie_domain_ops,
+	};
+
+	parent = dev_get_msi_domain(&ref_dev->dev);
+	if (!parent)
+		parent = dev_get_msi_domain(&ref_dev->bus->dev);
+	if (!parent) {
+		dev_err(&ref_dev->dev, "no MSI domain found for parent\n");
+		return -ENODEV;
+	}
+
+	info.parent = parent;
+	info.fwnode = irq_domain_alloc_named_fwnode("KVM-PCI-MSI");
+	if (!info.fwnode)
+		return -ENOMEM;
+
+	kvm_msi_domain = msi_create_parent_irq_domain(&info,
+						       &kvm_pcie_msi_parent_ops);
+	if (!kvm_msi_domain) {
+		pr_err("kvm-pci-msi: failed to create MSI domain\n");
+		irq_domain_free_fwnode(info.fwnode);
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static const struct pci_device_id kvm_msi_devids[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_QCOM, 0x1103) },	/* WCN6855 */
+	{ PCI_DEVICE(PCI_VENDOR_ID_QCOM, 0x1107) },	/* WCN7850 */
+	{ }
+};
+
+static void kvm_msi_attach_device(struct pci_dev *pdev)
+{
+	if (pdev->driver) {
+		dev_warn(&pdev->dev,
+			 "kvm-pci-msi: driver already bound (%s), unbind/rebind needed\n",
+			 pdev->driver->name);
+		return;
+	}
+
+	dev_info(&pdev->dev,
+		 "kvm-pci-msi: attaching KVM MSI domain [%04x:%04x]\n",
+		 pdev->vendor, pdev->device);
+	dev_set_msi_domain(&pdev->dev, kvm_msi_domain);
+}
+
+static int kvm_msi_bus_notify(struct notifier_block *nb, unsigned long action,
+			      void *data)
+{
+	struct pci_dev *pdev;
+
+	if (action != BUS_NOTIFY_ADD_DEVICE)
+		return NOTIFY_DONE;
+
+	pdev = to_pci_dev(data);
+	if (!pci_match_id(kvm_msi_devids, pdev))
+		return NOTIFY_DONE;
+
+	if (!kvm_msi_domain)
+		return NOTIFY_DONE;
+
+	kvm_msi_attach_device(pdev);
+	return NOTIFY_OK;
+}
+
+static struct notifier_block kvm_msi_nb = {
+	.notifier_call = kvm_msi_bus_notify,
+};
+
+static int __init kvm_pci_msi_init(void)
+{
+	struct pci_dev *pdev = NULL;
+	struct pci_dev *first = NULL;
+	int ret;
+
+	if (!kvm_para_available())
+		return -ENODEV;
+
+	for_each_pci_dev(pdev) {
+		if (pci_match_id(kvm_msi_devids, pdev)) {
+			first = pdev;
+			break;
+		}
+	}
+
+	if (!first) {
+		pr_info("kvm-pci-msi: no matching devices found\n");
+		return -ENODEV;
+	}
+
+	ret = kvm_msi_create_domain(first);
+	pci_dev_put(first);
+	if (ret)
+		return ret;
+
+	pdev = NULL;
+	for_each_pci_dev(pdev) {
+		if (pci_match_id(kvm_msi_devids, pdev))
+			kvm_msi_attach_device(pdev);
+	}
+
+	bus_register_notifier(&pci_bus_type, &kvm_msi_nb);
+
+	pr_info("kvm-pci-msi: ready, domain created for %zu device types\n",
+		ARRAY_SIZE(kvm_msi_devids) - 1);
+	return 0;
+}
+
+static void __exit kvm_pci_msi_exit(void)
+{
+	struct fwnode_handle *fwnode;
+
+	bus_unregister_notifier(&pci_bus_type, &kvm_msi_nb);
+
+	if (kvm_msi_domain) {
+		fwnode = kvm_msi_domain->fwnode;
+		irq_domain_remove(kvm_msi_domain);
+		irq_domain_free_fwnode(fwnode);
+		kvm_msi_domain = NULL;
+	}
+}
+
+module_init(kvm_pci_msi_init);
+module_exit(kvm_pci_msi_exit);
+
+MODULE_DESCRIPTION("KVM PCI MSI passthrough domain driver");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Jose Ignacio Tornos Martinez <jtornosm@redhat.com>");
diff --git a/include/linux/pci-kvm-msi.h b/include/linux/pci-kvm-msi.h
new file mode 100644
index 000000000000..cc615e913a3b
--- /dev/null
+++ b/include/linux/pci-kvm-msi.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* SPDX-FileCopyrightText: Copyright Red Hat */
+
+#ifndef _LINUX_PCI_KVM_MSI_H
+#define _LINUX_PCI_KVM_MSI_H
+
+#include <linux/pci.h>
+
+int kvm_pci_msi_wait_ready(struct pci_dev *pdev, unsigned long timeout_ms);
+int kvm_pci_msi_get_address(struct pci_dev *pdev, u32 *addr_lo, u32 *addr_hi,
+			     u32 *data);
+
+#endif /* _LINUX_PCI_KVM_MSI_H */
-- 
2.56.0

