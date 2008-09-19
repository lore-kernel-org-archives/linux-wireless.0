Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:10863 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbYISL6F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2008 07:58:05 -0400
Received: by fg-out-1718.google.com with SMTP id 19so541638fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 19 Sep 2008 04:58:02 -0700 (PDT)
Date: Fri, 19 Sep 2008 15:57:58 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>,
	Suresh Siddha <suresh.b.siddha@intel.com>
Cc: LWML <linux-wireless@vger.kernel.org>,
	"Maciej W. Rozycki" <macro@linux-mips.org>
Subject: [PATCH -tip/master] x86: io-apic - interrupt remapping fix
Message-ID: <20080919115758.GD7222@lenovo> (sfid-20080919_135810_966871_A18CC967)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Interrupt remapping could lead to NULL dereference in case of
kzalloc failed and memory leak in other way. So fix the
both cases.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Ingo, the patch is on top of applied one.

If I remember correctly Suresh was involved in
this - so I think he could take a look and review
the patch (please).

Index: linux-2.6.git/arch/x86/kernel/apic.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic.c	2008-09-19 12:12:54.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/apic.c	2008-09-19 13:57:04.000000000 +0400
@@ -1360,7 +1360,12 @@ void enable_IR_x2apic(void)
 
 	local_irq_save(flags);
 	mask_8259A();
-	save_mask_IO_APIC_setup();
+
+	ret = save_mask_IO_APIC_setup();
+	if (ret) {
+		printk(KERN_INFO "Saving IO-APIC state failed: %d\n", ret);
+		goto end;
+	}
 
 	ret = enable_intr_remapping(1);
 
@@ -1370,14 +1375,15 @@ void enable_IR_x2apic(void)
 	}
 
 	if (ret)
-		goto end;
+		goto end_restore;
 
 	if (!x2apic) {
 		x2apic = 1;
 		apic_ops = &x2apic_ops;
 		enable_x2apic();
 	}
-end:
+
+end_restore:
 	if (ret)
 		/*
 		 * IR enabling failed
@@ -1386,6 +1392,7 @@ end:
 	else
 		reinit_intr_remapped_IO_APIC(x2apic_preenabled);
 
+end:
 	unmask_8259A();
 	local_irq_restore(flags);
 
Index: linux-2.6.git/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/io_apic.c	2008-09-19 12:12:54.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/io_apic.c	2008-09-19 13:33:01.000000000 +0400
@@ -831,7 +831,7 @@ int save_mask_IO_APIC_setup(void)
 			kzalloc(sizeof(struct IO_APIC_route_entry) *
 				nr_ioapic_registers[apic], GFP_KERNEL);
 		if (!early_ioapic_entries[apic])
-			return -ENOMEM;
+			goto nomem;
 	}
 
 	for (apic = 0; apic < nr_ioapics; apic++)
@@ -845,7 +845,17 @@ int save_mask_IO_APIC_setup(void)
 				ioapic_write_entry(apic, pin, entry);
 			}
 		}
+
 	return 0;
+
+nomem:
+	for (; apic > 0; apic--)
+		kfree(early_ioapic_entries[apic]);
+	kfree(early_ioapic_entries[apic]);
+	memset(early_ioapic_entries, 0,
+		ARRAY_SIZE(early_ioapic_entries));
+
+	return -ENOMEM;
 }
 
 void restore_IO_APIC_setup(void)
@@ -853,12 +863,13 @@ void restore_IO_APIC_setup(void)
 	int apic, pin;
 
 	for (apic = 0; apic < nr_ioapics; apic++) {
-		/* FIXME: it should be handled at allocation time --cvg */
 		if (!early_ioapic_entries[apic])
 			break;
 		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++)
 			ioapic_write_entry(apic, pin,
 					   early_ioapic_entries[apic][pin]);
+		kfree(early_ioapic_entries[apic]);
+		early_ioapic_entries[apic] = NULL;
 	}
 }
 
