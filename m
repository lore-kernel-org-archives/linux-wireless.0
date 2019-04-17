Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB8F0C282DA
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 21:44:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A52042184B
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 21:44:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387831AbfDQVn4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 17:43:56 -0400
Received: from mga12.intel.com ([192.55.52.136]:20171 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387579AbfDQVm0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 17:42:26 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Apr 2019 14:42:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,363,1549958400"; 
   d="scan'208";a="224441196"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by orsmga001.jf.intel.com with ESMTP; 17 Apr 2019 14:42:25 -0700
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
Subject: [PATCH v7 14/21] x86/split_lock: Enable split lock detection by default
Date:   Wed, 17 Apr 2019 14:34:04 -0700
Message-Id: <1555536851-17462-15-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 2.5.0
In-Reply-To: <1555536851-17462-1-git-send-email-fenghua.yu@intel.com>
References: <1555536851-17462-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

A split locked access locks bus and degrades overall memory access
performance. When split lock detection feature is enumerated, enable
the feature by default to find any split lock issue.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/kernel/cpu/intel.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 997d683d3c27..6a692d215bef 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -34,6 +34,8 @@
 DEFINE_PER_CPU(u64, msr_test_ctl_cache);
 EXPORT_PER_CPU_SYMBOL_GPL(msr_test_ctl_cache);
 
+static bool split_lock_detect_enable;
+
 /*
  * Just in case our CPU detection goes bad, or you have a weird system,
  * allow a way to override the automatic disabling of MPX.
@@ -164,6 +166,23 @@ static bool bad_spectre_microcode(struct cpuinfo_x86 *c)
 	return false;
 }
 
+static void split_lock_update_msr(void *__unused)
+{
+	if (split_lock_detect_enable) {
+		msr_set_bit(MSR_TEST_CTL, TEST_CTL_SPLIT_LOCK_DETECT_SHIFT);
+		this_cpu_or(msr_test_ctl_cache, TEST_CTL_SPLIT_LOCK_DETECT);
+	} else {
+		msr_clear_bit(MSR_TEST_CTL, TEST_CTL_SPLIT_LOCK_DETECT_SHIFT);
+		this_cpu_and(msr_test_ctl_cache, ~TEST_CTL_SPLIT_LOCK_DETECT);
+	}
+}
+
+static void init_split_lock_detect(struct cpuinfo_x86 *c)
+{
+	if (cpu_has(c, X86_FEATURE_SPLIT_LOCK_DETECT))
+		split_lock_update_msr(NULL);
+}
+
 static void early_init_intel(struct cpuinfo_x86 *c)
 {
 	u64 misc_enable;
@@ -661,6 +680,8 @@ static void init_intel(struct cpuinfo_x86 *c)
 {
 	early_init_intel(c);
 
+	init_split_lock_detect(c);
+
 	intel_workarounds(c);
 
 	/*
@@ -1032,9 +1053,22 @@ static const struct cpu_dev intel_cpu_dev = {
 
 cpu_dev_register(intel_cpu_dev);
 
+#undef pr_fmt
+#define pr_fmt(fmt) "x86/split lock detection: " fmt
+
+static void show_split_lock_detection_info(void)
+{
+	if (split_lock_detect_enable)
+		pr_info("enabled\n");
+	else
+		pr_info("disabled\n");
+}
+
 static void __init set_split_lock_detect(void)
 {
 	setup_force_cpu_cap(X86_FEATURE_SPLIT_LOCK_DETECT);
+	split_lock_detect_enable = true;
+	show_split_lock_detection_info();
 }
 
 void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c)
-- 
2.19.1

