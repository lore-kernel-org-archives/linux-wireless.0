Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBA9FC4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 21:33:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A3452082C
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 21:33:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbfDCVdt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 17:33:49 -0400
Received: from mga05.intel.com ([192.55.52.43]:37312 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbfDCVaS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 17:30:18 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Apr 2019 14:30:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,306,1549958400"; 
   d="scan'208";a="334754286"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by fmsmga005.fm.intel.com with ESMTP; 03 Apr 2019 14:30:13 -0700
From:   Fenghua Yu <fenghua.yu@intel.com>
To:     "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Ashok Raj" <ashok.raj@intel.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Kalle Valo" <kvalo@codeaurora.org>,
        "Xiaoyao Li " <xiaoyao.li@intel.com>,
        "Michael Chan" <michael.chan@broadcom.com>,
        "Ravi V Shankar" <ravi.v.shankar@intel.com>
Cc:     "linux-kernel" <linux-kernel@vger.kernel.org>,
        "x86" <x86@kernel.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH v6 19/20] x86/clearcpuid: Clear CPUID bit in CPUID faulting
Date:   Wed,  3 Apr 2019 14:22:05 -0700
Message-Id: <1554326526-172295-20-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 2.5.0
In-Reply-To: <1554326526-172295-1-git-send-email-fenghua.yu@intel.com>
References: <1554326526-172295-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

After kernel clears a CPUID bit through clearcpuid or other kernel options,
CPUID instruction executed from user space should see the same value for
the bit. The CPUID faulting handler returns the cleared bit to user.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/include/asm/cpufeature.h |  4 +++
 arch/x86/kernel/cpu/common.c      |  2 ++
 arch/x86/kernel/cpu/cpuid-deps.c  | 52 ++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/intel.c       | 56 +++++++++++++++++++++++++++++--
 arch/x86/kernel/cpu/scattered.c   | 17 ++++++++++
 arch/x86/kernel/process.c         |  3 ++
 arch/x86/kernel/traps.c           | 11 ++++++
 7 files changed, 142 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 823c4ab82e12..53875fd13f5a 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -228,5 +228,9 @@ static __always_inline __pure bool _static_cpu_has(u16 bit)
 #define CPU_FEATURE_TYPEVAL		boot_cpu_data.x86_vendor, boot_cpu_data.x86, \
 					boot_cpu_data.x86_model
 
+extern int cpuid_fault;
+u32 scattered_cpuid_mask(u32 leaf, u32 count, enum cpuid_regs_idx reg);
+u32 cpuid_cap_mask(u32 leaf, u32 count, enum cpuid_regs_idx reg);
+
 #endif /* defined(__KERNEL__) && !defined(__ASSEMBLY__) */
 #endif /* _ASM_X86_CPUFEATURE_H */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index e1d41405c27b..020597bca252 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1503,6 +1503,8 @@ void print_cpu_info(struct cpuinfo_x86 *c)
 		pr_cont(")\n");
 }
 
+int cpuid_fault;
+
 /*
  * clearcpuid= was already parsed in fpu__init_parse_early_param.
  * But we need to keep a dummy __setup around otherwise it would
diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
index 1a71434f7b46..d42aa4fa3021 100644
--- a/arch/x86/kernel/cpu/cpuid-deps.c
+++ b/arch/x86/kernel/cpu/cpuid-deps.c
@@ -113,9 +113,61 @@ static void do_clear_cpu_cap(struct cpuinfo_x86 *c, unsigned int feature)
 
 void clear_cpu_cap(struct cpuinfo_x86 *c, unsigned int feature)
 {
+	if (boot_cpu_has(feature))
+		cpuid_fault = 1;
 	do_clear_cpu_cap(c, feature);
 }
 
+u32 cpuid_cap_mask(u32 leaf, u32 count, enum cpuid_regs_idx reg)
+{
+	switch (leaf) {
+	case 0x1:
+		if (reg == CPUID_EDX)
+			return ~cpu_caps_cleared[CPUID_1_EDX];
+		if (reg == CPUID_ECX)
+			return ~cpu_caps_cleared[CPUID_1_ECX];
+		break;
+
+	case 0x6:
+		if (reg == CPUID_EAX)
+			return ~cpu_caps_cleared[CPUID_6_EAX];
+		break;
+
+	case 0x7:
+		if (reg == CPUID_EDX)
+			return ~cpu_caps_cleared[CPUID_7_EDX];
+		if (reg == CPUID_ECX)
+			return ~cpu_caps_cleared[CPUID_7_ECX];
+		if (reg == CPUID_EBX && count == 0)
+			return ~cpu_caps_cleared[CPUID_7_0_EBX];
+		break;
+
+	case 0xD:
+		if (reg == CPUID_EAX)
+			return ~cpu_caps_cleared[CPUID_D_1_EAX];
+		break;
+
+	case 0xF:
+		if (reg == CPUID_EDX) {
+			if (count == 0)
+				return ~cpu_caps_cleared[CPUID_F_0_EDX];
+			if (count == 1)
+				return ~cpu_caps_cleared[CPUID_F_0_EDX];
+		}
+		break;
+
+	case 0x80000007:
+		if (reg == CPUID_EDX) {
+			if (test_bit(X86_FEATURE_CONSTANT_TSC,
+				     (unsigned long *)cpu_caps_cleared))
+				return ~(1 << 8);
+		}
+		break;
+	}
+
+	return scattered_cpuid_mask(leaf, count, reg);
+}
+
 void setup_clear_cpu_cap(unsigned int feature)
 {
 	do_clear_cpu_cap(NULL, feature);
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 166033fa8423..aa1cfcc81323 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -19,6 +19,9 @@
 #include <asm/microcode_intel.h>
 #include <asm/hwcap2.h>
 #include <asm/elf.h>
+#include <asm/insn.h>
+#include <asm/insn-eval.h>
+#include <asm/inat.h>
 
 #ifdef CONFIG_X86_64
 #include <linux/topology.h>
@@ -667,13 +670,60 @@ static void intel_bsp_resume(struct cpuinfo_x86 *c)
 	init_intel_energy_perf(c);
 }
 
+bool fixup_cpuid_exception(struct pt_regs *regs)
+{
+	unsigned int leaf, count, eax, ebx, ecx, edx;
+	unsigned long seg_base = 0;
+	unsigned char buf[2];
+	int not_copied;
+
+	if (!cpuid_fault)
+		return false;
+
+	if (test_thread_flag(TIF_NOCPUID))
+		return false;
+
+	if (!user_64bit_mode(regs))
+		seg_base = insn_get_seg_base(regs, INAT_SEG_REG_CS);
+
+	if (seg_base == -1L)
+		return false;
+
+	not_copied = copy_from_user(buf, (void __user *)(seg_base + regs->ip),
+				    sizeof(buf));
+	if (not_copied)
+		return false;
+
+	if (buf[0] != 0x0F || buf[1] != 0xA2) /* CPUID - OF A2 */
+		return false;
+
+	leaf = regs->ax;
+	count = regs->cx;
+
+	cpuid_count(leaf, count, &eax, &ebx, &ecx, &edx);
+
+	regs->ip += 2;
+	regs->ax = eax & cpuid_cap_mask(leaf, count, CPUID_EAX);
+	regs->bx = ebx & cpuid_cap_mask(leaf, count, CPUID_EBX);
+	regs->cx = ecx & cpuid_cap_mask(leaf, count, CPUID_ECX);
+	regs->dx = edx & cpuid_cap_mask(leaf, count, CPUID_EDX);
+
+	return true;
+}
+
 static void init_cpuid_fault(struct cpuinfo_x86 *c)
 {
 	u64 msr;
 
-	if (!rdmsrl_safe(MSR_PLATFORM_INFO, &msr)) {
-		if (msr & MSR_PLATFORM_INFO_CPUID_FAULT)
-			set_cpu_cap(c, X86_FEATURE_CPUID_FAULT);
+	if (rdmsrl_safe(MSR_PLATFORM_INFO, &msr))
+		return;
+
+	if (msr & MSR_PLATFORM_INFO_CPUID_FAULT) {
+		set_cpu_cap(c, X86_FEATURE_CPUID_FAULT);
+		if (cpuid_fault) {
+			this_cpu_or(msr_misc_features_shadow,
+				    MSR_MISC_FEATURES_ENABLES_CPUID_FAULT);
+		}
 	}
 }
 
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 94aa1c72ca98..353756c27096 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -62,3 +62,20 @@ void init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 			set_cpu_cap(c, cb->feature);
 	}
 }
+
+u32 scattered_cpuid_mask(u32 leaf, u32 count, enum cpuid_regs_idx reg)
+{
+	const struct cpuid_bit *cb;
+	u32 mask = ~0U;
+
+	for (cb = cpuid_bits; cb->feature; cb++) {
+		if (cb->level == leaf && cb->sub_leaf == count &&
+		    cb->reg == reg) {
+			if (test_bit(cb->feature,
+				     (unsigned long *)cpu_caps_cleared))
+				mask &= ~BIT(cb->bit);
+		}
+	}
+
+	return mask;
+}
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 58ac7be52c7a..2b1dfd7ae65d 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -196,6 +196,9 @@ static void set_cpuid_faulting(bool on)
 {
 	u64 msrval;
 
+	if (cpuid_fault)
+		return;
+
 	msrval = this_cpu_read(msr_misc_features_shadow);
 	msrval &= ~MSR_MISC_FEATURES_ENABLES_CPUID_FAULT;
 	msrval |= (on << MSR_MISC_FEATURES_ENABLES_CPUID_FAULT_BIT);
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 0ac992bfa287..d887da1e8050 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -559,6 +559,12 @@ dotraplinkage void do_bounds(struct pt_regs *regs, long error_code)
 	do_trap(X86_TRAP_BR, SIGSEGV, "bounds", regs, error_code, 0, NULL);
 }
 
+#ifdef CONFIG_CPU_SUP_INTEL
+extern bool fixup_cpuid_exception(struct pt_regs *regs);
+#else
+static inline bool fixup_cpuid_exception(struct pt_regs *regs) { return false; }
+#endif
+
 dotraplinkage void
 do_general_protection(struct pt_regs *regs, long error_code)
 {
@@ -573,6 +579,11 @@ do_general_protection(struct pt_regs *regs, long error_code)
 			return;
 	}
 
+	if (static_cpu_has(X86_FEATURE_CPUID_FAULT)) {
+		if (user_mode(regs) && fixup_cpuid_exception(regs))
+			return;
+	}
+
 	if (v8086_mode(regs)) {
 		local_irq_enable();
 		handle_vm86_fault((struct kernel_vm86_regs *) regs, error_code);
-- 
2.19.1

