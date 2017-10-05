Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:43273 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751270AbdJEEX3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Oct 2017 00:23:29 -0400
Received: by mail-pf0-f174.google.com with SMTP id d2so4166251pfh.0
        for <linux-wireless@vger.kernel.org>; Wed, 04 Oct 2017 21:23:29 -0700 (PDT)
From: Daniel Drake <drake@endlessm.com>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-wireless@vger.kernel.org,
        ath9k-devel@qca.qualcomm.com, linux@endlessm.com
Subject: Re: [PATCH] PCI MSI: allow alignment restrictions on vector allocation
Date: Thu,  5 Oct 2017 12:23:16 +0800
Message-Id: <20171005042316.12261-1-drake@endlessm.com> (sfid-20171005_062350_499739_02B35089)
In-Reply-To: <alpine.DEB.2.20.1710021540030.2185@nanos>
References: <alpine.DEB.2.20.1710021540030.2185@nanos>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 2, 2017 at 10:38 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> After checking out the new code and thinking this through a bit, I think
>> perhaps the only generic approach that would work is to make the
>> ath9k driver require a vector allocation that enables the entire block
>> of 4 MSI IRQs that the hardware supports (which is what Windows is doing).
>
> I wonder how Windows deals with the affinity problem for multi-MSI. Or does
> it just not allow to set it at all?

https://docs.microsoft.com/en-us/windows-hardware/drivers/kernel/interrupt-affinity-and-priority
Looks like IRQ affinity can only be set by registry or inf files. I assume
that means it is not dynamic and hence avoids the challenges related to
moving interrupts around at runtime.

> What's wrong with just using the legacy INTx emulation if you cannot
> allocate 4 MSI vectors?

The Legacy interrupt simply doesn't work for the wifi on at least 8 new Acer
laptop products based on Intel Apollo Lake.
Plus 4 Dell systems included in the patches in this thread:
https://lkml.org/lkml/2017/9/26/55
(the 2 which I can find specs for are also Apollo Lake)

We have tried taking the mini-PCIe wifi module out of one of the affected
Acer products and moved it to another computer, where it is working fine
with legacy interrupts. So this suggests that the wifi module itself is OK,
but we are facing a hardware limitation or BIOS limitation on the affected
products. In the Dell thread it says "Some platform(BIOS) blocks legacy
interrupts (INTx)".

If you have any suggestions for how we might solve this without getting into
the MSI mess then that would be much appreciated. If the BIOS blocks the
interrupts, can Linux unblock them?

Just for reference I'm attaching my latest attempt at enabling MULTI_PCI_MSI.
It would definitely need further work if we proceed here - so far I've
ignored the affinity considerations that you explained, and it's not
particularly clean.

I'll now have a look at polling for interrupts in the ath9k driver.

---
 arch/x86/kernel/apic/msi.c    |  3 +-
 arch/x86/kernel/apic/vector.c | 75 ++++++++++++++++++++++++++++++++-----------
 include/linux/irq.h           |  3 +-
 kernel/irq/matrix.c           | 23 +++++++------
 4 files changed, 74 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index 5b6dd1a85ec4..c57b6a7b9317 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -129,7 +129,8 @@ static struct msi_domain_ops pci_msi_domain_ops = {
 
 static struct msi_domain_info pci_msi_domain_info = {
 	.flags		= MSI_FLAG_USE_DEF_DOM_OPS | MSI_FLAG_USE_DEF_CHIP_OPS |
-			  MSI_FLAG_PCI_MSIX | MSI_FLAG_MUST_REACTIVATE,
+			  MSI_FLAG_PCI_MSIX | MSI_FLAG_MUST_REACTIVATE |
+			  MSI_FLAG_MULTI_PCI_MSI,
 	.ops		= &pci_msi_domain_ops,
 	.chip		= &pci_msi_controller,
 	.handler	= handle_edge_irq,
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index 6789e286def9..2926fd92ea1c 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -35,7 +35,8 @@ struct apic_chip_data {
 	unsigned int		move_in_progress	: 1,
 				is_managed		: 1,
 				can_reserve		: 1,
-				has_reserved		: 1;
+				has_reserved		: 1,
+				contig_allocation	: 1;
 };
 
 struct irq_domain *x86_vector_domain;
@@ -198,7 +199,8 @@ static int reserve_irq_vector(struct irq_data *irqd)
 	return 0;
 }
 
-static int allocate_vector(struct irq_data *irqd, const struct cpumask *dest)
+static int allocate_vector(struct irq_data *irqd, const struct cpumask *dest,
+			   unsigned int num, unsigned int align_mask)
 {
 	struct apic_chip_data *apicd = apic_chip_data(irqd);
 	bool resvd = apicd->has_reserved;
@@ -215,18 +217,21 @@ static int allocate_vector(struct irq_data *irqd, const struct cpumask *dest)
 	if (vector && cpu_online(cpu) && cpumask_test_cpu(cpu, dest))
 		return 0;
 
-	vector = irq_matrix_alloc(vector_matrix, dest, resvd, &cpu);
+	vector = irq_matrix_alloc(vector_matrix, dest, resvd, &cpu,
+				  num, align_mask);
 	if (vector > 0)
 		apic_update_vector(irqd, vector, cpu);
+
 	trace_vector_alloc(irqd->irq, vector, resvd, vector);
 	return vector;
 }
 
 static int assign_vector_locked(struct irq_data *irqd,
-				const struct cpumask *dest)
+				const struct cpumask *dest,
+				unsigned int num, unsigned int align_mask)
 {
 	struct apic_chip_data *apicd = apic_chip_data(irqd);
-	int vector = allocate_vector(irqd, dest);
+	int vector = allocate_vector(irqd, dest, num, align_mask);
 
 	if (vector < 0)
 		return vector;
@@ -235,14 +240,15 @@ static int assign_vector_locked(struct irq_data *irqd,
 	return 0;
 }
 
-static int assign_irq_vector(struct irq_data *irqd, const struct cpumask *dest)
+static int assign_irq_vector(struct irq_data *irqd, const struct cpumask *dest,
+			     unsigned int num, unsigned int align_mask)
 {
 	unsigned long flags;
 	int ret;
 
 	raw_spin_lock_irqsave(&vector_lock, flags);
 	cpumask_and(vector_searchmask, dest, cpu_online_mask);
-	ret = assign_vector_locked(irqd, vector_searchmask);
+	ret = assign_vector_locked(irqd, vector_searchmask, num, align_mask);
 	raw_spin_unlock_irqrestore(&vector_lock, flags);
 	return ret;
 }
@@ -257,18 +263,18 @@ static int assign_irq_vector_any_locked(struct irq_data *irqd)
 		goto all;
 	/* Try the intersection of @affmsk and node mask */
 	cpumask_and(vector_searchmask, cpumask_of_node(node), affmsk);
-	if (!assign_vector_locked(irqd, vector_searchmask))
+	if (!assign_vector_locked(irqd, vector_searchmask, 1, 0))
 		return 0;
 	/* Try the node mask */
-	if (!assign_vector_locked(irqd, cpumask_of_node(node)))
+	if (!assign_vector_locked(irqd, cpumask_of_node(node), 1, 0))
 		return 0;
 all:
 	/* Try the full affinity mask */
 	cpumask_and(vector_searchmask, affmsk, cpu_online_mask);
-	if (!assign_vector_locked(irqd, vector_searchmask))
+	if (!assign_vector_locked(irqd, vector_searchmask, 1, 0))
 		return 0;
 	/* Try the full online mask */
-	return assign_vector_locked(irqd, cpu_online_mask);
+	return assign_vector_locked(irqd, cpu_online_mask, 1, 0);
 }
 
 static int
@@ -277,7 +283,7 @@ assign_irq_vector_policy(struct irq_data *irqd, struct irq_alloc_info *info)
 	if (irqd_affinity_is_managed(irqd))
 		return reserve_managed_vector(irqd);
 	if (info->mask)
-		return assign_irq_vector(irqd, info->mask);
+		return assign_irq_vector(irqd, info->mask, 1, 0);
 	/*
 	 * Make only a global reservation with no guarantee. A real vector
 	 * is associated at activation time.
@@ -353,6 +359,9 @@ static void x86_vector_deactivate(struct irq_domain *dom, struct irq_data *irqd)
 	if (apicd->has_reserved)
 		return;
 
+	if (apicd->contig_allocation)
+		return;
+
 	raw_spin_lock_irqsave(&vector_lock, flags);
 	clear_irq_vector(irqd);
 	if (apicd->can_reserve)
@@ -411,6 +420,9 @@ static int x86_vector_activate(struct irq_domain *dom, struct irq_data *irqd,
 	if (!apicd->can_reserve && !apicd->is_managed)
 		return 0;
 
+	if (apicd->contig_allocation)
+		return 0;
+
 	raw_spin_lock_irqsave(&vector_lock, flags);
 	if (early || irqd_is_managed_and_shutdown(irqd))
 		vector_assign_managed_shutdown(irqd);
@@ -489,16 +501,25 @@ static int x86_vector_alloc_irqs(struct irq_domain *domain, unsigned int virq,
 				 unsigned int nr_irqs, void *arg)
 {
 	struct irq_alloc_info *info = arg;
-	struct apic_chip_data *apicd;
+	struct apic_chip_data *apicd, *first_apicd;
 	struct irq_data *irqd;
 	int i, err, node;
+	bool contig_allocation = false;
+	unsigned int align_mask = 0;
 
 	if (disable_apic)
 		return -ENXIO;
 
-	/* Currently vector allocator can't guarantee contiguous allocations */
-	if ((info->flags & X86_IRQ_ALLOC_CONTIGUOUS_VECTORS) && nr_irqs > 1)
-		return -ENOSYS;
+	if ((info->flags & X86_IRQ_ALLOC_CONTIGUOUS_VECTORS) && nr_irqs > 1) {
+		contig_allocation = true;
+
+		if (info->type == X86_IRQ_ALLOC_TYPE_MSI) {
+			/* Contiguous allocations must be aligned for MSI */
+			align_mask = 1 << fls(nr_irqs - 1);
+			/* Convert from align requirement to align mask */
+			align_mask--;
+		}
+	}
 
 	for (i = 0; i < nr_irqs; i++) {
 		irqd = irq_domain_get_irq_data(domain, virq + i);
@@ -512,6 +533,7 @@ static int x86_vector_alloc_irqs(struct irq_domain *domain, unsigned int virq,
 		}
 
 		apicd->irq = virq + i;
+		apicd->contig_allocation = contig_allocation;
 		irqd->chip = &lapic_controller;
 		irqd->chip_data = apicd;
 		irqd->hwirq = virq + i;
@@ -528,7 +550,24 @@ static int x86_vector_alloc_irqs(struct irq_domain *domain, unsigned int virq,
 				continue;
 		}
 
-		err = assign_irq_vector_policy(irqd, info);
+		if (contig_allocation) {
+			/* Automatically activate */
+			if (i == 0) {
+				first_apicd = apicd;
+				err = assign_irq_vector(irqd, cpu_online_mask,
+							nr_irqs, align_mask);
+			} else {
+				apic_update_vector(irqd,
+						   first_apicd->vector + i,
+						   first_apicd->cpu);
+				apic_update_irq_cfg(irqd,
+						    first_apicd->vector + i,
+						    first_apicd->cpu);
+				err = 0;
+			}
+		} else {
+			err = assign_irq_vector_policy(irqd, info);
+		}
 		trace_vector_setup(virq + i, false, err);
 		if (err)
 			goto error;
@@ -733,7 +772,7 @@ static int apic_set_affinity(struct irq_data *irqd,
 	if (irqd_affinity_is_managed(irqd))
 		err = assign_managed_vector(irqd, vector_searchmask);
 	else
-		err = assign_vector_locked(irqd, vector_searchmask);
+		err = assign_vector_locked(irqd, vector_searchmask, 1, 0);
 	raw_spin_unlock(&vector_lock);
 	return err ? err : IRQ_SET_MASK_OK;
 }
diff --git a/include/linux/irq.h b/include/linux/irq.h
index fda8da7c45e7..2cb5c3a9c96f 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -1126,7 +1126,8 @@ int irq_matrix_alloc_managed(struct irq_matrix *m, unsigned int cpu);
 void irq_matrix_reserve(struct irq_matrix *m);
 void irq_matrix_remove_reserved(struct irq_matrix *m);
 int irq_matrix_alloc(struct irq_matrix *m, const struct cpumask *msk,
-		     bool reserved, unsigned int *mapped_cpu);
+		     bool reserved, unsigned int *mapped_cpu, unsigned int num,
+		     unsigned int align_mask);
 void irq_matrix_free(struct irq_matrix *m, unsigned int cpu,
 		     unsigned int bit, bool managed);
 void irq_matrix_assign(struct irq_matrix *m, unsigned int bit);
diff --git a/kernel/irq/matrix.c b/kernel/irq/matrix.c
index a3cbbc8191c5..b5c4f054a650 100644
--- a/kernel/irq/matrix.c
+++ b/kernel/irq/matrix.c
@@ -106,14 +106,16 @@ void irq_matrix_offline(struct irq_matrix *m)
 }
 
 static unsigned int matrix_alloc_area(struct irq_matrix *m, struct cpumap *cm,
-				      unsigned int num, bool managed)
+				      unsigned int num, bool managed,
+				      unsigned int align_mask)
 {
 	unsigned int area, start = m->alloc_start;
 	unsigned int end = m->alloc_end;
 
 	bitmap_or(m->scratch_map, cm->managed_map, m->system_map, end);
 	bitmap_or(m->scratch_map, m->scratch_map, cm->alloc_map, end);
-	area = bitmap_find_next_zero_area(m->scratch_map, end, start, num, 0);
+	area = bitmap_find_next_zero_area(m->scratch_map, end, start, num,
+					  align_mask);
 	if (area >= end)
 		return area;
 	if (managed)
@@ -171,7 +173,7 @@ int irq_matrix_reserve_managed(struct irq_matrix *m, const struct cpumask *msk)
 		struct cpumap *cm = per_cpu_ptr(m->maps, cpu);
 		unsigned int bit;
 
-		bit = matrix_alloc_area(m, cm, 1, true);
+		bit = matrix_alloc_area(m, cm, 1, true, 0);
 		if (bit >= m->alloc_end)
 			goto cleanup;
 		cm->managed++;
@@ -319,7 +321,8 @@ void irq_matrix_remove_reserved(struct irq_matrix *m)
  * @mapped_cpu: Pointer to store the CPU for which the irq was allocated
  */
 int irq_matrix_alloc(struct irq_matrix *m, const struct cpumask *msk,
-		     bool reserved, unsigned int *mapped_cpu)
+		     bool reserved, unsigned int *mapped_cpu,
+		     unsigned int num, unsigned int align_mask)
 {
 	unsigned int cpu;
 
@@ -330,14 +333,14 @@ int irq_matrix_alloc(struct irq_matrix *m, const struct cpumask *msk,
 		if (!cm->online)
 			continue;
 
-		bit = matrix_alloc_area(m, cm, 1, false);
+		bit = matrix_alloc_area(m, cm, num, false, align_mask);
 		if (bit < m->alloc_end) {
-			cm->allocated++;
-			cm->available--;
-			m->total_allocated++;
-			m->global_available--;
+			cm->allocated += num;
+			cm->available -= num;
+			m->total_allocated += num;
+			m->global_available -= num;
 			if (reserved)
-				m->global_reserved--;
+				m->global_reserved -= num;
 			*mapped_cpu = cpu;
 			trace_irq_matrix_alloc(bit, cpu, m, cm);
 			return bit;
-- 
2.11.0
