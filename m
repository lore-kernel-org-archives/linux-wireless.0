Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44B33C4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 21:33:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 147392082C
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 21:33:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbfDCVdi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 17:33:38 -0400
Received: from mga05.intel.com ([192.55.52.43]:37323 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726206AbfDCVaS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 17:30:18 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Apr 2019 14:30:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,306,1549958400"; 
   d="scan'208";a="334754281"
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
Subject: [PATCH v6 18/20] x86/clearcpuid: Apply cleared feature bits that are forced set before
Date:   Wed,  3 Apr 2019 14:22:04 -0700
Message-Id: <1554326526-172295-19-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 2.5.0
In-Reply-To: <1554326526-172295-1-git-send-email-fenghua.yu@intel.com>
References: <1554326526-172295-1-git-send-email-fenghua.yu@intel.com>
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
index bbdd69dd4f5f..e1d41405c27b 100644
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

