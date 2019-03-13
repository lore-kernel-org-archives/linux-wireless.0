Return-Path: <SRS0=EMXR=RQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4408C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 00:57:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A0722063F
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 00:57:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbfCMA5E (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 20:57:04 -0400
Received: from mga12.intel.com ([192.55.52.136]:44646 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726269AbfCMA5E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 20:57:04 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2019 17:57:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,472,1544515200"; 
   d="scan'208";a="122166454"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by orsmga007.jf.intel.com with ESMTP; 12 Mar 2019 17:57:02 -0700
Date:   Tue, 12 Mar 2019 17:49:56 -0700
From:   Fenghua Yu <fenghua.yu@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, H Peter Anvin <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v5 09/18] x86/split_lock: Handle #AC exception for split
 lock
Message-ID: <20190313004955.GA31710@romley-ivt3.sc.intel.com>
References: <1552431636-31511-1-git-send-email-fenghua.yu@intel.com>
 <1552431636-31511-10-git-send-email-fenghua.yu@intel.com>
 <5c76062a-e088-fdb3-09e2-7e4423d820a1@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c76062a-e088-fdb3-09e2-7e4423d820a1@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Mar 12, 2019 at 04:51:22PM -0700, Dave Hansen wrote:
> On 3/12/19 4:00 PM, Fenghua Yu wrote:
> I don't see any feature checking here.  Don't we need to see if this MSR
> is supported?
> 
> Shouldn't the code here on systems that don't support split lock
> disabling be the same as on CONFIG_CPU_SUP_INTEL=n systems?

You are right. Is the following #AC handler code better?

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index d26f9e9c3d83..5296021509c7 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -61,6 +61,7 @@
 #include <asm/mpx.h>
 #include <asm/vm86.h>
 #include <asm/umip.h>
+#include <asm/cpu.h>
 
 #ifdef CONFIG_X86_64
 #include <asm/x86_init.h>
@@ -293,7 +294,37 @@ DO_ERROR(X86_TRAP_OLD_MF, SIGFPE,           0, NULL, "coprocessor segment overru
 DO_ERROR(X86_TRAP_TS,     SIGSEGV,          0, NULL, "invalid TSS",         invalid_TSS)
 DO_ERROR(X86_TRAP_NP,     SIGBUS,           0, NULL, "segment not present", segment_not_present)
 DO_ERROR(X86_TRAP_SS,     SIGBUS,           0, NULL, "stack segment",       stack_segment)
-DO_ERROR(X86_TRAP_AC,     SIGBUS,  BUS_ADRALN, NULL, "alignment check",     alignment_check)
+dotraplinkage void do_alignment_check(struct pt_regs *regs, long error_code)
+{
+	unsigned int trapnr = X86_TRAP_AC;
+	char str[] = "alignment check";
+	int signr = SIGBUS;
+
+	RCU_LOCKDEP_WARN(!rcu_is_watching(), "entry code didn't wake RCU");
+
+	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr) !=
+			NOTIFY_STOP) {
+		cond_local_irq_enable(regs);
+		if (!user_mode(regs)) {
+			if (!this_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT))
+				return;
+
+			/*
+			 * Only split lock can generate #AC from kernel. Warn
+			 * and disable #AC for split lock on current CPU.
+			 */
+			msr_clear_bit(MSR_TEST_CTL,
+				      TEST_CTL_ENABLE_SPLIT_LOCK_DETECT_SHIFT);
+			WARN_ONCE(1, "A split lock issue is detected.\n");
+
+
+			return;
+		}
+		/* Handle #AC generated from user code. */
+		do_trap(X86_TRAP_AC, SIGBUS, "alignment check", regs,
+			error_code, BUS_ADRALN, NULL);
+	}
+}
 #undef IP
 
 #ifdef CONFIG_VMAP_STACK


