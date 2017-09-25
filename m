Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f47.google.com ([74.125.83.47]:43137 "EHLO
        mail-pg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752428AbdIYEMI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Sep 2017 00:12:08 -0400
Received: by mail-pg0-f47.google.com with SMTP id u18so3329232pgo.0
        for <linux-wireless@vger.kernel.org>; Sun, 24 Sep 2017 21:12:08 -0700 (PDT)
From: Daniel Drake <drake@endlessm.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-pci@vger.kernel.org, x86@kernel.org,
        linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        linux@endlessm.com
Subject: [PATCH] PCI MSI: allow alignment restrictions on vector allocation
Date: Mon, 25 Sep 2017 12:11:53 +0800
Message-Id: <20170925041153.26574-1-drake@endlessm.com> (sfid-20170925_061404_218709_6A0E2E91)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k hardware claims to support up to 4 MSI vectors, and when run in
that configuration, it would be allowed to modify the lower bits of the
MSI Message Data when generating interrupts in order to signal which
of the 4 vectors the interrupt is being raised on.

Linux's PCI-MSI irqchip only supports a single MSI vector for each
device, and it tells the device this, but the device appears to assume
it is working with 4, as it will unset the lower 2 bits of Message Data
presumably to indicate that it is an IRQ for the first of 4 possible
vectors.

Linux will then receive an interrupt on the wrong vector, so the
ath9k interrupt handler will not be invoked.

To work around this, introduce a mechanism where the vector assignment
algorithm can be restricted to only a subset of available vector numbers
based on a bitmap.

As a user of this bitmap, introduce a pci_dev.align_msi_vector flag which
can be used to state that MSI vector numbers must be aligned to a specific
amount. If we 4-align the ath9k MSI vector then the lower bits will
already be 0 and hence the device will not modify the Message Data away
from its original value.

This is needed in order to support the wifi card in at least 8 new Acer
consumer laptop models which come with the Foxconn NFA335 WiFi module.
Legacy interrupts do not work on that module, so MSI support is required.

Signed-off-by: Daniel Drake <drake@endlessm.com>

https://phabricator.endlessm.com/T16988
---
 arch/x86/include/asm/hw_irq.h |  1 +
 arch/x86/kernel/apic/msi.c    | 15 +++++++++++++++
 arch/x86/kernel/apic/vector.c | 32 +++++++++++++++++++++++++-------
 include/linux/pci.h           |  2 ++
 4 files changed, 43 insertions(+), 7 deletions(-)

This solves the issue described here:
https://marc.info/?l=linux-pci&m=150238260826803&w=2

If this approach looks good I'll follow up with the ath9k patch
to enable MSI interrupts.

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 6dfe366a8804..7f35178586a1 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -77,6 +77,7 @@ struct irq_alloc_info {
 		struct {
 			struct pci_dev	*msi_dev;
 			irq_hw_number_t	msi_hwirq;
+			DECLARE_BITMAP(allowed_vectors, NR_VECTORS);
 		};
 #endif
 #ifdef	CONFIG_X86_IO_APIC
diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index 9b18be764422..80067873cfd5 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -111,6 +111,21 @@ int pci_msi_prepare(struct irq_domain *domain, struct device *dev, int nvec,
 		arg->flags |= X86_IRQ_ALLOC_CONTIGUOUS_VECTORS;
 	}
 
+	if (pdev->align_msi_vector) {
+		/* We have specific alignment requirements on the vector
+		 * number used by the device. Set up a bitmap that restricts
+		 * the vector selection accordingly.
+		 */
+		int i = pdev->align_msi_vector;
+
+		set_bit(0, arg->allowed_vectors);
+		for (; i < NR_VECTORS; i += pdev->align_msi_vector)
+			set_bit(i, arg->allowed_vectors);
+	} else {
+		/* No specific alignment requirements so allow all vectors. */
+		bitmap_fill(arg->allowed_vectors, NR_VECTORS);
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(pci_msi_prepare);
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index 88c214e75a6b..64ddac198c25 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -104,7 +104,8 @@ static void free_apic_chip_data(struct apic_chip_data *data)
 
 static int __assign_irq_vector(int irq, struct apic_chip_data *d,
 			       const struct cpumask *mask,
-			       struct irq_data *irqdata)
+			       struct irq_data *irqdata,
+			       unsigned long *allowed_vectors)
 {
 	/*
 	 * NOTE! The local APIC isn't very good at handling
@@ -178,6 +179,9 @@ static int __assign_irq_vector(int irq, struct apic_chip_data *d,
 		if (test_bit(vector, used_vectors))
 			goto next;
 
+		if (allowed_vectors && !test_bit(vector, allowed_vectors))
+			goto next;
+
 		for_each_cpu(new_cpu, vector_searchmask) {
 			if (!IS_ERR_OR_NULL(per_cpu(vector_irq, new_cpu)[vector]))
 				goto next;
@@ -234,13 +238,14 @@ static int __assign_irq_vector(int irq, struct apic_chip_data *d,
 
 static int assign_irq_vector(int irq, struct apic_chip_data *data,
 			     const struct cpumask *mask,
-			     struct irq_data *irqdata)
+			     struct irq_data *irqdata,
+			     unsigned long *allowed_vectors)
 {
 	int err;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&vector_lock, flags);
-	err = __assign_irq_vector(irq, data, mask, irqdata);
+	err = __assign_irq_vector(irq, data, mask, irqdata, allowed_vectors);
 	raw_spin_unlock_irqrestore(&vector_lock, flags);
 	return err;
 }
@@ -250,12 +255,25 @@ static int assign_irq_vector_policy(int irq, int node,
 				    struct irq_alloc_info *info,
 				    struct irq_data *irqdata)
 {
+	unsigned long *allowed_vectors = NULL;
+
+	/* Some MSI interrupts have restrictions on which vector numbers
+	 * can be used.
+	 */
+	if (info &&
+		(info->type == X86_IRQ_ALLOC_TYPE_MSI ||
+		 info->type == X86_IRQ_ALLOC_TYPE_MSIX))
+		allowed_vectors = info->allowed_vectors;
+
 	if (info && info->mask)
-		return assign_irq_vector(irq, data, info->mask, irqdata);
+		return assign_irq_vector(irq, data, info->mask, irqdata,
+					 allowed_vectors);
 	if (node != NUMA_NO_NODE &&
-	    assign_irq_vector(irq, data, cpumask_of_node(node), irqdata) == 0)
+	    assign_irq_vector(irq, data, cpumask_of_node(node), irqdata,
+			      allowed_vectors) == 0)
 		return 0;
-	return assign_irq_vector(irq, data, apic->target_cpus(), irqdata);
+	return assign_irq_vector(irq, data, apic->target_cpus(), irqdata,
+				 allowed_vectors);
 }
 
 static void clear_irq_vector(int irq, struct apic_chip_data *data)
@@ -549,7 +567,7 @@ static int apic_set_affinity(struct irq_data *irq_data,
 	if (!cpumask_intersects(dest, cpu_online_mask))
 		return -EINVAL;
 
-	err = assign_irq_vector(irq, data, dest, irq_data);
+	err = assign_irq_vector(irq, data, dest, irq_data, NULL);
 	return err ? err : IRQ_SET_MASK_OK;
 }
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index f68c58a93dd0..7755450be02d 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -419,6 +419,8 @@ struct pci_dev {
 #endif
 #ifdef CONFIG_PCI_MSI
 	const struct attribute_group **msi_irq_groups;
+	int align_msi_vector;	/* device requires MSI vector numbers aligned
+				 * by this amount */
 #endif
 	struct pci_vpd *vpd;
 #ifdef CONFIG_PCI_ATS
-- 
2.11.0
