Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DAE3C4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 21:30:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71A782082C
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 21:30:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbfDCVav (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 17:30:51 -0400
Received: from mga05.intel.com ([192.55.52.43]:37332 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726805AbfDCVaW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 17:30:22 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Apr 2019 14:30:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,306,1549958400"; 
   d="scan'208";a="334754263"
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
Subject: [PATCH v6 13/20] x86/split_lock: Enable split lock detection by default
Date:   Wed,  3 Apr 2019 14:21:59 -0700
Message-Id: <1554326526-172295-14-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 2.5.0
In-Reply-To: <1554326526-172295-1-git-send-email-fenghua.yu@intel.com>
References: <1554326526-172295-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

A split locked access locks bus and degrades overall memory access
performance. When split lock detection feature is enumerated, enable
the feature by default to find any split lock issue and then fix
the issue.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/kernel/cpu/intel.c | 42 +++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 7f6943af35dc..ae3e327d5e35 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -31,6 +31,12 @@
 #include <asm/apic.h>
 #endif
 
+#define DISABLE_SPLIT_LOCK_DETECT 0
+#define ENABLE_SPLIT_LOCK_DETECT  1
+
+static DEFINE_MUTEX(split_lock_detect_mutex);
+static int split_lock_detect_val;
+
 /*
  * Just in case our CPU detection goes bad, or you have a weird system,
  * allow a way to override the automatic disabling of MPX.
@@ -161,10 +167,45 @@ static bool bad_spectre_microcode(struct cpuinfo_x86 *c)
 	return false;
 }
 
+static u32 new_sp_test_ctl_val(u32 test_ctl_val)
+{
+	/* Change the split lock setting. */
+	if (READ_ONCE(split_lock_detect_val) == DISABLE_SPLIT_LOCK_DETECT)
+		test_ctl_val &= ~TEST_CTL_ENABLE_SPLIT_LOCK_DETECT;
+	else
+		test_ctl_val |= TEST_CTL_ENABLE_SPLIT_LOCK_DETECT;
+
+	return test_ctl_val;
+}
+
+static inline void show_split_lock_detection_info(void)
+{
+	if (READ_ONCE(split_lock_detect_val))
+		pr_info_once("x86/split_lock: split lock detection enabled\n");
+	else
+		pr_info_once("x86/split_lock: split lock detection disabled\n");
+}
+
+static void init_split_lock_detect(struct cpuinfo_x86 *c)
+{
+	if (cpu_has(c, X86_FEATURE_SPLIT_LOCK_DETECT)) {
+		u32 l, h;
+
+		mutex_lock(&split_lock_detect_mutex);
+		rdmsr(MSR_TEST_CTL, l, h);
+		l = new_sp_test_ctl_val(l);
+		wrmsr(MSR_TEST_CTL, l, h);
+		show_split_lock_detection_info();
+		mutex_unlock(&split_lock_detect_mutex);
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
@@ -1032,6 +1073,7 @@ cpu_dev_register(intel_cpu_dev);
 static void __init set_split_lock_detect(void)
 {
 	setup_force_cpu_cap(X86_FEATURE_SPLIT_LOCK_DETECT);
+	split_lock_detect_val = 1;
 }
 
 void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c)
-- 
2.19.1

