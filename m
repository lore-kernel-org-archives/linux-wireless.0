Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0B12C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 23:08:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3E3E213A2
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 23:08:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbfCLXIv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 19:08:51 -0400
Received: from mga18.intel.com ([134.134.136.126]:65107 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727359AbfCLXIZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 19:08:25 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2019 16:08:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,472,1544515200"; 
   d="scan'208";a="326744262"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by fmsmga006.fm.intel.com with ESMTP; 12 Mar 2019 16:08:14 -0700
From:   Fenghua Yu <fenghua.yu@intel.com>
To:     "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "H Peter Anvin" <hpa@zytor.com>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Ashok Raj" <ashok.raj@intel.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Xiaoyao Li " <xiaoyao.li@intel.com>,
        "Michael Chan" <michael.chan@broadcom.com>,
        "Ravi V Shankar" <ravi.v.shankar@intel.com>
Cc:     "linux-kernel" <linux-kernel@vger.kernel.org>,
        "x86" <x86@kernel.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH v5 16/18] x86/clearcpuid: Apply cleared feature bits that are forced set before
Date:   Tue, 12 Mar 2019 16:00:34 -0700
Message-Id: <1552431636-31511-17-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 2.5.0
In-Reply-To: <1552431636-31511-1-git-send-email-fenghua.yu@intel.com>
References: <1552431636-31511-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Some CPU feature bits are forced set and stored in cpuinfo_x86 before
handling clearcpuid options. To clear those bits from cpuinfo_x86,
apply_forced_cap() is called after handling the options.

Please note, apply_forced_cap() is called twice on boot CPU. But this code
is simple and there is no functionality issue.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/include/asm/cpu.h   | 2 ++
 arch/x86/kernel/cpu/common.c | 5 +++--
 arch/x86/kernel/fpu/init.c   | 2 ++
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index 4e03f53fc079..bfa5ac6b7502 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -26,6 +26,8 @@ struct x86_cpu {
 	struct cpu cpu;
 };
 
+void apply_forced_caps(struct cpuinfo_x86 *c);
+
 #ifdef CONFIG_HOTPLUG_CPU
 extern int arch_register_cpu(int num);
 extern void arch_unregister_cpu(int);
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 16b091bb62bd..546f92aa61ca 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -758,13 +758,14 @@ void cpu_detect(struct cpuinfo_x86 *c)
 	}
 }
 
-static void apply_forced_caps(struct cpuinfo_x86 *c)
+void apply_forced_caps(struct cpuinfo_x86 *c)
 {
 	int i;
 
 	for (i = 0; i < NCAPINTS + NBUGINTS; i++) {
-		c->x86_capability[i] &= ~cpu_caps_cleared[i];
+		/* Bits may be cleared after they are set. */
 		c->x86_capability[i] |= cpu_caps_set[i];
+		c->x86_capability[i] &= ~cpu_caps_cleared[i];
 	}
 }
 
diff --git a/arch/x86/kernel/fpu/init.c b/arch/x86/kernel/fpu/init.c
index 99b895eea166..9c2801b605e3 100644
--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -5,6 +5,7 @@
 #include <asm/tlbflush.h>
 #include <asm/setup.h>
 #include <asm/cmdline.h>
+#include <asm/cpu.h>
 
 #include <linux/sched.h>
 #include <linux/sched/task.h>
@@ -261,6 +262,7 @@ static void __init clear_cpuid(void)
 		    bit >= 0 && bit < NCAPINTS * 32)
 			setup_clear_cpu_cap(bit);
 	}
+	apply_forced_caps(&boot_cpu_data);
 }
 
 /*
-- 
2.19.1

