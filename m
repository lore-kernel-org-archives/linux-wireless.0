Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:47121 "EHLO
        mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750936AbdJBI5t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Oct 2017 04:57:49 -0400
Received: by mail-pf0-f169.google.com with SMTP id u12so2614785pfl.4
        for <linux-wireless@vger.kernel.org>; Mon, 02 Oct 2017 01:57:49 -0700 (PDT)
From: Daniel Drake <drake@endlessm.com>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-wireless@vger.kernel.org,
        ath9k-devel@qca.qualcomm.com, linux@endlessm.com
Subject: Re: [PATCH] PCI MSI: allow alignment restrictions on vector allocation
Date: Mon,  2 Oct 2017 16:57:32 +0800
Message-Id: <20171002085732.4039-1-drake@endlessm.com> (sfid-20171002_105621_532410_45EF5C0D)
In-Reply-To: <alpine.DEB.2.20.1709271555430.2027@nanos>
References: <alpine.DEB.2.20.1709271555430.2027@nanos>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Thomas,

Thanks a lot for looking at this.

On Wed, Sep 27, 2017 at 11:28 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> This code is gone in -next and replaced by a new vector allocator.
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/apic

Nice, thanks for cleaning that up!

> But the real question is how this is supposed to work with
>
>  - interrupt remapping

On another system, I have multiple devices using IR-PCI-MSI according
to /proc/interrupts, and lspci shows that a MSI Message Data value 0
is used for every single MSI-enabled device.

I don't know if that's just luck, but its a value that would work
fine for ath9k.

Unfortunately interrupt remapping is not available on the affected
Acer products though.
https://lists.linuxfoundation.org/pipermail/iommu/2017-August/023717.html

>  - non X86 machines

After checking out the new code and thinking this through a bit, I think
perhaps the only generic approach that would work is to make the
ath9k driver require a vector allocation that enables the entire block
of 4 MSI IRQs that the hardware supports (which is what Windows is doing).
This way the alignment requirement is automatically met and ath9k is
free to stamp all over the lower 2 bits of the MSI Message Data.

MSI_FLAG_MULTI_PCI_MSI is already supported by a couple of non-x86 drivers
and the interrupt remapping code, but it is not supported by the generic
pci_msi_controller, and the new vector allocator still rejects
X86_IRQ_ALLOC_CONTIGUOUS_VECTORS.

I will try to take a look at enabling this for the generic allocator,
unless you have any other ideas.

In the mean time, at least for reference, below is an updated version
of the previous patch based on the new allocator and incorporating
your feedback. (It's still rather ugly though)

> I doubt that this can be made generic enough to make it work all over the
> place. Tell Acer/Foxconn to fix their stupid firmware.

We're also working on this approach ever since the problematic models
first appeared months ago, but since these products are in mass production,
I think ultimately we are going to need a Linux workaround.

---
 arch/x86/include/asm/hw_irq.h |  1 +
 arch/x86/kernel/apic/msi.c    |  2 ++
 arch/x86/kernel/apic/vector.c | 14 +++++++++++---
 include/linux/irq.h           |  6 +++---
 include/linux/pci.h           |  1 +
 kernel/irq/matrix.c           | 22 ++++++++++++++--------
 6 files changed, 32 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 661540a93072..9e5e1bb62121 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -79,6 +79,7 @@ struct irq_alloc_info {
 		struct {
 			struct pci_dev	*msi_dev;
 			irq_hw_number_t	msi_hwirq;
+			unsigned int vector_align;
 		};
 #endif
 #ifdef	CONFIG_X86_IO_APIC
diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index 5b6dd1a85ec4..9b5277309c29 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -111,6 +111,8 @@ int pci_msi_prepare(struct irq_domain *domain, struct device *dev, int nvec,
 		arg->flags |= X86_IRQ_ALLOC_CONTIGUOUS_VECTORS;
 	}
 
+	arg->vector_align = pdev->align_msi_vector;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(pci_msi_prepare);
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index 6789e286def9..e85f19c09c34 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -31,6 +31,7 @@ struct apic_chip_data {
 	unsigned int		cpu;
 	unsigned int		prev_cpu;
 	unsigned int		irq;
+	unsigned int		vector_align;
 	struct hlist_node	clist;
 	unsigned int		move_in_progress	: 1,
 				is_managed		: 1,
@@ -171,7 +172,8 @@ static int reserve_managed_vector(struct irq_data *irqd)
 
 	raw_spin_lock_irqsave(&vector_lock, flags);
 	apicd->is_managed = true;
-	ret = irq_matrix_reserve_managed(vector_matrix, affmsk);
+	ret = irq_matrix_reserve_managed(vector_matrix, affmsk,
+					 apicd->vector_align);
 	raw_spin_unlock_irqrestore(&vector_lock, flags);
 	trace_vector_reserve_managed(irqd->irq, ret);
 	return ret;
@@ -215,7 +217,8 @@ static int allocate_vector(struct irq_data *irqd, const struct cpumask *dest)
 	if (vector && cpu_online(cpu) && cpumask_test_cpu(cpu, dest))
 		return 0;
 
-	vector = irq_matrix_alloc(vector_matrix, dest, resvd, &cpu);
+	vector = irq_matrix_alloc(vector_matrix, dest, resvd, &cpu,
+				  apicd->vector_align);
 	if (vector > 0)
 		apic_update_vector(irqd, vector, cpu);
 	trace_vector_alloc(irqd->irq, vector, resvd, vector);
@@ -299,7 +302,8 @@ assign_managed_vector(struct irq_data *irqd, const struct cpumask *dest)
 	/* set_affinity might call here for nothing */
 	if (apicd->vector && cpumask_test_cpu(apicd->cpu, vector_searchmask))
 		return 0;
-	vector = irq_matrix_alloc_managed(vector_matrix, cpu);
+	vector = irq_matrix_alloc_managed(vector_matrix, cpu,
+					  apicd->vector_align);
 	trace_vector_alloc_managed(irqd->irq, vector, vector);
 	if (vector < 0)
 		return vector;
@@ -511,6 +515,10 @@ static int x86_vector_alloc_irqs(struct irq_domain *domain, unsigned int virq,
 			goto error;
 		}
 
+		if (info->type == X86_IRQ_ALLOC_TYPE_MSI
+				|| info->type == X86_IRQ_ALLOC_TYPE_MSIX)
+			apicd->vector_align = info->vector_align;
+
 		apicd->irq = virq + i;
 		irqd->chip = &lapic_controller;
 		irqd->chip_data = apicd;
diff --git a/include/linux/irq.h b/include/linux/irq.h
index fda8da7c45e7..a8c249df5b1e 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -1120,13 +1120,13 @@ struct irq_matrix *irq_alloc_matrix(unsigned int matrix_bits,
 void irq_matrix_online(struct irq_matrix *m);
 void irq_matrix_offline(struct irq_matrix *m);
 void irq_matrix_assign_system(struct irq_matrix *m, unsigned int bit, bool replace);
-int irq_matrix_reserve_managed(struct irq_matrix *m, const struct cpumask *msk);
+int irq_matrix_reserve_managed(struct irq_matrix *m, const struct cpumask *msk, unsigned int align);
 void irq_matrix_remove_managed(struct irq_matrix *m, const struct cpumask *msk);
-int irq_matrix_alloc_managed(struct irq_matrix *m, unsigned int cpu);
+int irq_matrix_alloc_managed(struct irq_matrix *m, unsigned int cpu, unsigned int align);
 void irq_matrix_reserve(struct irq_matrix *m);
 void irq_matrix_remove_reserved(struct irq_matrix *m);
 int irq_matrix_alloc(struct irq_matrix *m, const struct cpumask *msk,
-		     bool reserved, unsigned int *mapped_cpu);
+		     bool reserved, unsigned int *mapped_cpu, unsigned int align);
 void irq_matrix_free(struct irq_matrix *m, unsigned int cpu,
 		     unsigned int bit, bool managed);
 void irq_matrix_assign(struct irq_matrix *m, unsigned int bit);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index f68c58a93dd0..e7408c133115 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -419,6 +419,7 @@ struct pci_dev {
 #endif
 #ifdef CONFIG_PCI_MSI
 	const struct attribute_group **msi_irq_groups;
+	unsigned int align_msi_vector;
 #endif
 	struct pci_vpd *vpd;
 #ifdef CONFIG_PCI_ATS
diff --git a/kernel/irq/matrix.c b/kernel/irq/matrix.c
index a3cbbc8191c5..d904819820a8 100644
--- a/kernel/irq/matrix.c
+++ b/kernel/irq/matrix.c
@@ -106,14 +106,17 @@ void irq_matrix_offline(struct irq_matrix *m)
 }
 
 static unsigned int matrix_alloc_area(struct irq_matrix *m, struct cpumap *cm,
-				      unsigned int num, bool managed)
+				      unsigned int num, bool managed, unsigned int align)
 {
 	unsigned int area, start = m->alloc_start;
 	unsigned int end = m->alloc_end;
 
+	if (align > 0)
+		align--;
+
 	bitmap_or(m->scratch_map, cm->managed_map, m->system_map, end);
 	bitmap_or(m->scratch_map, m->scratch_map, cm->alloc_map, end);
-	area = bitmap_find_next_zero_area(m->scratch_map, end, start, num, 0);
+	area = bitmap_find_next_zero_area(m->scratch_map, end, start, num, align);
 	if (area >= end)
 		return area;
 	if (managed)
@@ -163,7 +166,7 @@ void irq_matrix_assign_system(struct irq_matrix *m, unsigned int bit,
  * on all CPUs in @msk, but it's not guaranteed that the bits are at the
  * same offset on all CPUs
  */
-int irq_matrix_reserve_managed(struct irq_matrix *m, const struct cpumask *msk)
+int irq_matrix_reserve_managed(struct irq_matrix *m, const struct cpumask *msk, unsigned int align)
 {
 	unsigned int cpu, failed_cpu;
 
@@ -171,7 +174,7 @@ int irq_matrix_reserve_managed(struct irq_matrix *m, const struct cpumask *msk)
 		struct cpumap *cm = per_cpu_ptr(m->maps, cpu);
 		unsigned int bit;
 
-		bit = matrix_alloc_area(m, cm, 1, true);
+		bit = matrix_alloc_area(m, cm, 1, true, align);
 		if (bit >= m->alloc_end)
 			goto cleanup;
 		cm->managed++;
@@ -238,14 +241,17 @@ void irq_matrix_remove_managed(struct irq_matrix *m, const struct cpumask *msk)
  * @m:		Matrix pointer
  * @cpu:	On which CPU the interrupt should be allocated
  */
-int irq_matrix_alloc_managed(struct irq_matrix *m, unsigned int cpu)
+int irq_matrix_alloc_managed(struct irq_matrix *m, unsigned int cpu, unsigned int align)
 {
 	struct cpumap *cm = per_cpu_ptr(m->maps, cpu);
 	unsigned int bit, end = m->alloc_end;
 
+	if (align > 0)
+		align--;
+
 	/* Get managed bit which are not allocated */
 	bitmap_andnot(m->scratch_map, cm->managed_map, cm->alloc_map, end);
-	bit = find_first_bit(m->scratch_map, end);
+	bit = bitmap_find_next_zero_area(m->scratch_map, end, 0, 1, align);
 	if (bit >= end)
 		return -ENOSPC;
 	set_bit(bit, cm->alloc_map);
@@ -319,7 +325,7 @@ void irq_matrix_remove_reserved(struct irq_matrix *m)
  * @mapped_cpu: Pointer to store the CPU for which the irq was allocated
  */
 int irq_matrix_alloc(struct irq_matrix *m, const struct cpumask *msk,
-		     bool reserved, unsigned int *mapped_cpu)
+		     bool reserved, unsigned int *mapped_cpu, unsigned int align)
 {
 	unsigned int cpu;
 
@@ -330,7 +336,7 @@ int irq_matrix_alloc(struct irq_matrix *m, const struct cpumask *msk,
 		if (!cm->online)
 			continue;
 
-		bit = matrix_alloc_area(m, cm, 1, false);
+		bit = matrix_alloc_area(m, cm, 1, false, align);
 		if (bit < m->alloc_end) {
 			cm->allocated++;
 			cm->available--;
-- 
2.11.0
