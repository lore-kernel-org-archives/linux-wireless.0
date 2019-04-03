Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51F03C4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 21:30:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 232892082C
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 21:30:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbfDCVaW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 17:30:22 -0400
Received: from mga05.intel.com ([192.55.52.43]:37332 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726790AbfDCVaV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 17:30:21 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Apr 2019 14:30:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,306,1549958400"; 
   d="scan'208";a="334754249"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by fmsmga005.fm.intel.com with ESMTP; 03 Apr 2019 14:30:11 -0700
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
Subject: [PATCH v6 10/20] x86/split_lock: Handle #AC exception for split lock
Date:   Wed,  3 Apr 2019 14:21:56 -0700
Message-Id: <1554326526-172295-11-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 2.5.0
In-Reply-To: <1554326526-172295-1-git-send-email-fenghua.yu@intel.com>
References: <1554326526-172295-1-git-send-email-fenghua.yu@intel.com>
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

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/kernel/traps.c | 43 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index d26f9e9c3d83..0ac992bfa287 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -61,6 +61,7 @@
 #include <asm/mpx.h>
 #include <asm/vm86.h>
 #include <asm/umip.h>
+#include <asm/cpu.h>
 
 #ifdef CONFIG_X86_64
 #include <asm/x86_init.h>
@@ -293,9 +294,49 @@ DO_ERROR(X86_TRAP_OLD_MF, SIGFPE,           0, NULL, "coprocessor segment overru
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
+	/*
+	 * WARN*()s end up here; fix them up before we call the
+	 * notifier chain.
+	 */
+	if (!user_mode(regs) && fixup_bug(regs, trapnr))
+		return;
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
+		 * another #AC fault. User needs to check the warning and
+		 * fix the split lock issue in the faulting instruction.
+		 */
+		msr_clear_bit(MSR_TEST_CTL,
+			      TEST_CTL_ENABLE_SPLIT_LOCK_DETECT_SHIFT);
+		WARN_ONCE(1, "split lock operation detected\n");
+
+		return;
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

