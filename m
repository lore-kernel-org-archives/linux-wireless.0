Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD853C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 23:09:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6449213A2
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 23:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727425AbfCLXIS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 19:08:18 -0400
Received: from mga18.intel.com ([134.134.136.126]:65104 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727297AbfCLXIQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 19:08:16 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2019 16:08:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,472,1544515200"; 
   d="scan'208";a="326744249"
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
Subject: [PATCH v5 12/18] x86/split_lock: Enable #AC for split lock by default
Date:   Tue, 12 Mar 2019 16:00:30 -0700
Message-Id: <1552431636-31511-13-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 2.5.0
In-Reply-To: <1552431636-31511-1-git-send-email-fenghua.yu@intel.com>
References: <1552431636-31511-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Split locked access locks bus and degradates overall memory access
performance. When split lock detection feature is enumerated, we want to
enable the feature by default to find any split lock issue and then fix
the issue.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/kernel/cpu/intel.c | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 889390d51c17..561f7d50246a 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -31,6 +31,11 @@
 #include <asm/apic.h>
 #endif
 
+#define DISABLE_SPLIT_LOCK_DETECT 0
+#define ENABLE_SPLIT_LOCK_DETECT  1
+
+static int split_lock_detect_val;
+
 /*
  * Just in case our CPU detection goes bad, or you have a weird system,
  * allow a way to override the automatic disabling of MPX.
@@ -161,10 +166,35 @@ static bool bad_spectre_microcode(struct cpuinfo_x86 *c)
 	return false;
 }
 
+static u32 new_sp_test_ctl_val(u32 test_ctl_val)
+{
+	/* Change the split lock setting. */
+	if (split_lock_detect_val == DISABLE_SPLIT_LOCK_DETECT)
+		test_ctl_val &= ~TEST_CTL_ENABLE_SPLIT_LOCK_DETECT;
+	else
+		test_ctl_val |= TEST_CTL_ENABLE_SPLIT_LOCK_DETECT;
+
+	return test_ctl_val;
+}
+
+static void init_split_lock_detect(struct cpuinfo_x86 *c)
+{
+	if (cpu_has(c, X86_FEATURE_SPLIT_LOCK_DETECT)) {
+		u32 l, h;
+
+		rdmsr(MSR_TEST_CTL, l, h);
+		l = new_sp_test_ctl_val(l);
+		wrmsr(MSR_TEST_CTL, l, h);
+		pr_info_once("#AC for split lock is enabled\n");
+	}
+}
+
 static void early_init_intel(struct cpuinfo_x86 *c)
 {
 	u64 misc_enable;
 
+	init_split_lock_detect(c);
+
 	/* Unmask CPUID levels if masked: */
 	if (c->x86 > 6 || (c->x86 == 6 && c->x86_model >= 0xd)) {
 		if (msr_clear_bit(MSR_IA32_MISC_ENABLE,
@@ -1048,6 +1078,8 @@ void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c)
 	 */
 	rdmsrl(MSR_IA32_CORE_CAPABILITY, ia32_core_cap);
 
-	if (ia32_core_cap & CORE_CAP_SPLIT_LOCK_DETECT)
+	if (ia32_core_cap & CORE_CAP_SPLIT_LOCK_DETECT) {
 		setup_force_cpu_cap(X86_FEATURE_SPLIT_LOCK_DETECT);
+		split_lock_detect_val = 1;
+	}
 }
-- 
2.19.1

