Return-Path: <SRS0=48GF=S2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D560BC282E1
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Apr 2019 19:43:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A353520652
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Apr 2019 19:43:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390101AbfDXTm5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Apr 2019 15:42:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:15196 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729833AbfDXTln (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Apr 2019 15:41:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Apr 2019 12:41:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,390,1549958400"; 
   d="scan'208";a="340454895"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by fmsmga005.fm.intel.com with ESMTP; 24 Apr 2019 12:41:40 -0700
From:   Fenghua Yu <fenghua.yu@intel.com>
To:     "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Ashok Raj" <ashok.raj@intel.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Ravi V Shankar" <ravi.v.shankar@intel.com>,
        "Xiaoyao Li " <xiaoyao.li@intel.com>,
        "Christopherson Sean J" <sean.j.christopherson@intel.com>,
        "Kalle Valo" <kvalo@codeaurora.org>,
        "Michael Chan" <michael.chan@broadcom.com>
Cc:     "linux-kernel" <linux-kernel@vger.kernel.org>,
        "x86" <x86@kernel.org>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH v8 10/15] x86/split_lock: Handle #AC exception for split lock
Date:   Wed, 24 Apr 2019 12:32:57 -0700
Message-Id: <1556134382-58814-11-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 2.5.0
In-Reply-To: <1556134382-58814-1-git-send-email-fenghua.yu@intel.com>
References: <1556134382-58814-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

There may be different considerations on how to handle #AC for split lock,
e.g. how to handle system hang caused by split lock issue in firmware,
how to emulate faulting instruction, etc. We use a simple method to
handle user and kernel split lock and may extend the method in the future.

When #AC exception for split lock is triggered from user process, the
process is killed by SIGBUS. To execute the process properly, a user
application developer needs to fix the split lock issue.

When #AC exception for split lock is triggered from a kernel instruction,
disable split lock detection on local CPU and warn the split lock issue.
After the exception, the faulting instruction will be executed and kernel
execution continues. Split lock detection is only disabled on the local
CPU, not globally. It will be re-enabled if the CPU is offline and then
online or through sysfs interface.

A kernel/driver developer should check the warning, which contains helpful
faulting address, context, and callstack info, and fix the split lock
issues. Then further split lock issues may be captured and fixed.

After bit 29 in MSR_TEST_CTL is set to 1 in kernel, firmware inherits
the setting when firmware is executed in S4, S5, run time services, SMI,
etc. If there is a split lock operation in firmware, it will triggers
#AC and may hang the system depending on how firmware handles the #AC.
It's up to a firmware developer to fix split lock issues in firmware.

MSR TEST_CTL value is cached in per CPU msr_test_ctl_cache which will be
used in virtualization to avoid costly MSR read.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/include/asm/cpu.h  |  3 +++
 arch/x86/kernel/cpu/intel.c | 24 ++++++++++++++++++++++++
 arch/x86/kernel/traps.c     | 31 ++++++++++++++++++++++++++++++-
 3 files changed, 57 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index 4e03f53fc079..5706461eb60f 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -42,7 +42,10 @@ unsigned int x86_model(unsigned int sig);
 unsigned int x86_stepping(unsigned int sig);
 #ifdef CONFIG_CPU_SUP_INTEL
 void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c);
+DECLARE_PER_CPU(u64, msr_test_ctl_cache);
+void handle_split_lock_kernel_mode(void);
 #else
 static inline void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c) {}
+static inline void handle_split_lock_kernel_mode(void) {}
 #endif
 #endif /* _ASM_X86_CPU_H */
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index d7e676c2aebf..2cc69217ca7c 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -31,6 +31,9 @@
 #include <asm/apic.h>
 #endif
 
+DEFINE_PER_CPU(u64, msr_test_ctl_cache);
+EXPORT_PER_CPU_SYMBOL_GPL(msr_test_ctl_cache);
+
 /*
  * Just in case our CPU detection goes bad, or you have a weird system,
  * allow a way to override the automatic disabling of MPX.
@@ -654,6 +657,17 @@ static void init_intel_misc_features(struct cpuinfo_x86 *c)
 	wrmsrl(MSR_MISC_FEATURES_ENABLES, msr);
 }
 
+static void init_split_lock_detect(struct cpuinfo_x86 *c)
+{
+	if (cpu_has(c, X86_FEATURE_SPLIT_LOCK_DETECT)) {
+		u64 test_ctl_val;
+
+		/* Cache MSR TEST_CTL */
+		rdmsrl(MSR_TEST_CTL, test_ctl_val);
+		this_cpu_write(msr_test_ctl_cache, test_ctl_val);
+	}
+}
+
 static void init_intel(struct cpuinfo_x86 *c)
 {
 	early_init_intel(c);
@@ -766,6 +780,8 @@ static void init_intel(struct cpuinfo_x86 *c)
 	init_intel_energy_perf(c);
 
 	init_intel_misc_features(c);
+
+	init_split_lock_detect(c);
 }
 
 #ifdef CONFIG_X86_32
@@ -1060,3 +1076,11 @@ void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c)
 	if (ia32_core_cap & CORE_CAP_SPLIT_LOCK_DETECT)
 		set_split_lock_detect();
 }
+
+void handle_split_lock_kernel_mode(void)
+{
+	/* Warn and disable split lock detection on this CPU */
+	msr_clear_bit(MSR_TEST_CTL, TEST_CTL_SPLIT_LOCK_DETECT_SHIFT);
+	this_cpu_and(msr_test_ctl_cache, ~TEST_CTL_SPLIT_LOCK_DETECT);
+	WARN_ONCE(1, "split lock operation detected\n");
+}
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index d26f9e9c3d83..db6b18311dbc 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -61,6 +61,7 @@
 #include <asm/mpx.h>
 #include <asm/vm86.h>
 #include <asm/umip.h>
+#include <asm/cpu.h>
 
 #ifdef CONFIG_X86_64
 #include <asm/x86_init.h>
@@ -293,9 +294,37 @@ DO_ERROR(X86_TRAP_OLD_MF, SIGFPE,           0, NULL, "coprocessor segment overru
 DO_ERROR(X86_TRAP_TS,     SIGSEGV,          0, NULL, "invalid TSS",         invalid_TSS)
 DO_ERROR(X86_TRAP_NP,     SIGBUS,           0, NULL, "segment not present", segment_not_present)
 DO_ERROR(X86_TRAP_SS,     SIGBUS,           0, NULL, "stack segment",       stack_segment)
-DO_ERROR(X86_TRAP_AC,     SIGBUS,  BUS_ADRALN, NULL, "alignment check",     alignment_check)
 #undef IP
 
+dotraplinkage void do_alignment_check(struct pt_regs *regs, long error_code)
+{
+	unsigned int trapnr = X86_TRAP_AC;
+	char str[] = "alignment check";
+	int signr = SIGBUS;
+
+	RCU_LOCKDEP_WARN(!rcu_is_watching(), "entry code didn't wake RCU");
+
+	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr) ==
+		       NOTIFY_STOP)
+		return;
+
+	cond_local_irq_enable(regs);
+	if (!user_mode(regs) &&
+	    static_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT)) {
+		/*
+		 * Only split lock can generate #AC from kernel at this point.
+		 * Warn and disable split lock detection on this CPU. The
+		 * faulting instruction will be executed without generating
+		 * another #AC fault.
+		 */
+		return handle_split_lock_kernel_mode();
+	}
+
+	/* Handle #AC generated in any other cases. */
+	do_trap(X86_TRAP_AC, SIGBUS, "alignment check", regs,
+		error_code, BUS_ADRALN, NULL);
+}
+
 #ifdef CONFIG_VMAP_STACK
 __visible void __noreturn handle_stack_overflow(const char *message,
 						struct pt_regs *regs,
-- 
2.19.1

