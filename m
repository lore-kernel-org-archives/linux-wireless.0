Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFA91C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 23:09:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3EE0206BA
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 23:09:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727750AbfCLXJu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 19:09:50 -0400
Received: from mga18.intel.com ([134.134.136.126]:65104 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727357AbfCLXIR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 19:08:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2019 16:08:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,472,1544515200"; 
   d="scan'208";a="326744259"
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
Subject: [PATCH v5 15/18] x86/clearcpuid: Support feature flag string in kernel option clearcpuid
Date:   Tue, 12 Mar 2019 16:00:33 -0700
Message-Id: <1552431636-31511-16-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 2.5.0
In-Reply-To: <1552431636-31511-1-git-send-email-fenghua.yu@intel.com>
References: <1552431636-31511-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The kernel option clearcpuid currently only takes feature bit which
can be changed from kernel to kernel.

Extend clearcpuid to use cap flag string, which is defined in
x86_cap_flags[] and won't be changed from kernel to kernel.
And user can easily get the cap flag string from /proc/cpuinfo.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/include/asm/cpufeature.h |  1 +
 arch/x86/kernel/cpu/cpuid-deps.c  | 26 ++++++++++++++++++++++++++
 arch/x86/kernel/fpu/init.c        |  3 ++-
 3 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index ce95b8cbd229..6792088525e3 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -132,6 +132,7 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
 
 extern void setup_clear_cpu_cap(unsigned int bit);
 extern void clear_cpu_cap(struct cpuinfo_x86 *c, unsigned int bit);
+bool find_cpu_cap(char *cap_flag, unsigned int *pfeature);
 
 #define setup_force_cpu_cap(bit) do { \
 	set_cpu_cap(&boot_cpu_data, bit);	\
diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
index 3d633f67fbd7..1a71434f7b46 100644
--- a/arch/x86/kernel/cpu/cpuid-deps.c
+++ b/arch/x86/kernel/cpu/cpuid-deps.c
@@ -120,3 +120,29 @@ void setup_clear_cpu_cap(unsigned int feature)
 {
 	do_clear_cpu_cap(NULL, feature);
 }
+
+/**
+ * find_cpu_cap - Given a cap flag string, find its corresponding feature bit.
+ * @cap_flag:	cap flag string as defined in x86_cap_flags[]
+ * @pfeature:	feature bit
+ *
+ * Return: true if the feature is found. false if not found
+ */
+bool find_cpu_cap(char *cap_flag, unsigned int *pfeature)
+{
+#ifdef CONFIG_X86_FEATURE_NAMES
+	unsigned int feature;
+
+	for (feature = 0; feature < NCAPINTS * 32; feature++) {
+		if (!x86_cap_flags[feature])
+			continue;
+
+		if (strcmp(cap_flag, x86_cap_flags[feature]) == 0) {
+			*pfeature = feature;
+
+			return true;
+		}
+	}
+#endif
+	return false;
+}
diff --git a/arch/x86/kernel/fpu/init.c b/arch/x86/kernel/fpu/init.c
index 88bbba7ee96a..99b895eea166 100644
--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -256,7 +256,8 @@ static void __init clear_cpuid(void)
 		/* Chang command line range for next search. */
 		cmdline_size = option_pos - boot_command_line + 1;
 		argptr = arg;
-		if (get_option(&argptr, &bit) &&
+		/* cpu cap can be specified by either feature bit or string */
+		if ((get_option(&argptr, &bit) || find_cpu_cap(arg, &bit)) &&
 		    bit >= 0 && bit < NCAPINTS * 32)
 			setup_clear_cpu_cap(bit);
 	}
-- 
2.19.1

