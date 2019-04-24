Return-Path: <SRS0=48GF=S2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0BCCC282E1
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Apr 2019 19:42:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71B6E20652
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Apr 2019 19:42:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730344AbfDXTmm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Apr 2019 15:42:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:15202 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729841AbfDXTlo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Apr 2019 15:41:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Apr 2019 12:41:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,390,1549958400"; 
   d="scan'208";a="340454889"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by fmsmga005.fm.intel.com with ESMTP; 24 Apr 2019 12:41:40 -0700
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
Subject: [PATCH v8 08/15] x86/split_lock: Enumerate split lock detection on Icelake mobile processor
Date:   Wed, 24 Apr 2019 12:32:55 -0700
Message-Id: <1556134382-58814-9-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 2.5.0
In-Reply-To: <1556134382-58814-1-git-send-email-fenghua.yu@intel.com>
References: <1556134382-58814-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Icelake mobile processor can detect split lock operations although
the processor doesn't have MSR IA32_CORE_CAPABILITY and split lock
detection bit in the MSR. Set split lock detection feature bit
X86_FEATURE_SPLIT_LOCK_DETECT on the processor based on its
family/model/stepping.

In the future, a few other processors may also have the split lock
detection feature but don't have MSR IA32_CORE_CAPABILITY. The feature
will be enumerated on those processors once their family/model/stepping
information is released.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/kernel/cpu/intel.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 86a3a646e0ce..d7e676c2aebf 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -1038,8 +1038,18 @@ void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c)
 {
 	u64 ia32_core_cap = 0;
 
-	if (!cpu_has(c, X86_FEATURE_CORE_CAPABILITY))
+	if (!cpu_has(c, X86_FEATURE_CORE_CAPABILITY)) {
+		/*
+		 * The following processors have split lock detection feature.
+		 * But since they don't have MSR IA32_CORE_CAPABILITY, the
+		 * feature cannot be enumerated by the MSR. So enumerate the
+		 * feature by family/model/stepping.
+		 */
+		if (c->x86 == 6 && c->x86_model == INTEL_FAM6_ICELAKE_MOBILE)
+			set_split_lock_detect();
+
 		return;
+	}
 
 	/*
 	 * If MSR_IA32_CORE_CAPABILITY exists, enumerate features that are
-- 
2.19.1

