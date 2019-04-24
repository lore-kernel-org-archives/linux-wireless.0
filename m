Return-Path: <SRS0=48GF=S2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 814B9C282E1
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Apr 2019 19:42:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5250220652
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Apr 2019 19:42:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389880AbfDXTmL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Apr 2019 15:42:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:15202 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389390AbfDXTlo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Apr 2019 15:41:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Apr 2019 12:41:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,390,1549958400"; 
   d="scan'208";a="340454905"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by fmsmga005.fm.intel.com with ESMTP; 24 Apr 2019 12:41:41 -0700
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
Subject: [PATCH v8 13/15] x86/split_lock: Enable split lock detection by default
Date:   Wed, 24 Apr 2019 12:33:00 -0700
Message-Id: <1556134382-58814-14-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 2.5.0
In-Reply-To: <1556134382-58814-1-git-send-email-fenghua.yu@intel.com>
References: <1556134382-58814-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

A split locked access locks bus and degrades overall memory access
performance. When split lock detection feature is enumerated, enable
the feature by default by writing 1 to bit 29 in MSR TEST_CTL to find
any split lock issue.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/kernel/cpu/intel.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 2cc69217ca7c..28cc6891ba48 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -657,6 +657,13 @@ static void init_intel_misc_features(struct cpuinfo_x86 *c)
 	wrmsrl(MSR_MISC_FEATURES_ENABLES, msr);
 }
 
+static void split_lock_update_msr(void)
+{
+	/* Enable split lock detection */
+	msr_set_bit(MSR_TEST_CTL, TEST_CTL_SPLIT_LOCK_DETECT_SHIFT);
+	this_cpu_or(msr_test_ctl_cache, TEST_CTL_SPLIT_LOCK_DETECT);
+}
+
 static void init_split_lock_detect(struct cpuinfo_x86 *c)
 {
 	if (cpu_has(c, X86_FEATURE_SPLIT_LOCK_DETECT)) {
@@ -665,6 +672,8 @@ static void init_split_lock_detect(struct cpuinfo_x86 *c)
 		/* Cache MSR TEST_CTL */
 		rdmsrl(MSR_TEST_CTL, test_ctl_val);
 		this_cpu_write(msr_test_ctl_cache, test_ctl_val);
+
+		split_lock_update_msr();
 	}
 }
 
@@ -1045,9 +1054,13 @@ static const struct cpu_dev intel_cpu_dev = {
 
 cpu_dev_register(intel_cpu_dev);
 
+#undef pr_fmt
+#define pr_fmt(fmt) "x86/split lock detection: " fmt
+
 static void __init set_split_lock_detect(void)
 {
 	setup_force_cpu_cap(X86_FEATURE_SPLIT_LOCK_DETECT);
+	pr_info("enabled\n");
 }
 
 void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c)
-- 
2.19.1

