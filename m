Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 111C6C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 23:11:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDE38217D9
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 23:11:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbfCLXLK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 19:11:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:34564 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727032AbfCLXIP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 19:08:15 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2019 16:08:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,472,1544515200"; 
   d="scan'208";a="326744243"
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
        Xiaoyao Li <xiaoyao.li@linux.intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH v5 10/18] kvm/x86: Emulate MSR IA32_CORE_CAPABILITY
Date:   Tue, 12 Mar 2019 16:00:28 -0700
Message-Id: <1552431636-31511-11-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 2.5.0
In-Reply-To: <1552431636-31511-1-git-send-email-fenghua.yu@intel.com>
References: <1552431636-31511-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Xiaoyao Li <xiaoyao.li@linux.intel.com>

MSR IA32_CORE_CAPABILITY is a feature-enumerating MSR, bit 5 of which
reports the capability of enabling detection of split locks (will be
supported on future processors based on Tremont microarchitecture and
later).

CPUID.(EAX=7H,ECX=0):EDX[30] will enumerate the presence of the
IA32_CORE_CAPABILITY MSR.

Please check the latest Intel 64 and IA-32 Architectures Software
Developer's Manual for more detailed information on the MSR and
the split lock bit.

Since MSR_IA32_CORE_CAPABILITY is a feature-enumerating MSR, we can
emulate it in software regardless of host's capability. What we need to
do is to set the right value of it to report the capability of guest.

In this patch we just set the guest's core_capability as 0, because we
haven't added support of the features it indicates to guest. It's for
bisectability.

Signed-off-by: Xiaoyao Li <xiaoyao.li@linux.intel.com>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/cpuid.c            |  6 ++++++
 arch/x86/kvm/x86.c              | 24 ++++++++++++++++++++++++
 3 files changed, 32 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 180373360e34..2c53df4a5a2a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -570,6 +570,7 @@ struct kvm_vcpu_arch {
 	bool tpr_access_reporting;
 	u64 ia32_xss;
 	u64 microcode_version;
+	u64 core_capability;
 
 	/*
 	 * Paging state of the vcpu
@@ -1527,6 +1528,7 @@ int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_bitmap_low,
 		    unsigned long icr, int op_64_bit);
 
 u64 kvm_get_arch_capabilities(void);
+u64 kvm_get_core_capability(void);
 void kvm_define_shared_msr(unsigned index, u32 msr);
 int kvm_set_shared_msr(unsigned index, u64 val, u64 mask);
 
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index c07958b59f50..b7fb1822a1e5 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -505,6 +505,12 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 			 * if the host doesn't support it.
 			 */
 			entry->edx |= F(ARCH_CAPABILITIES);
+			/*
+			 * Since we emulate MSR IA32_CORE_CAPABILITY in
+			 * software, we can always enable it for guest
+			 * regardless of host's capability.
+			 */
+			entry->edx |= F(CORE_CAPABILITY);
 		} else {
 			entry->ebx = 0;
 			entry->ecx = 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 941f932373d0..e20cbb8c2b74 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1158,6 +1158,7 @@ static u32 emulated_msrs[] = {
 
 	MSR_IA32_TSC_ADJUST,
 	MSR_IA32_TSCDEADLINE,
+	MSR_IA32_CORE_CAPABILITY,
 	MSR_IA32_MISC_ENABLE,
 	MSR_IA32_MCG_STATUS,
 	MSR_IA32_MCG_CTL,
@@ -1197,6 +1198,7 @@ static u32 msr_based_features[] = {
 
 	MSR_F10H_DECFG,
 	MSR_IA32_UCODE_REV,
+	MSR_IA32_CORE_CAPABILITY,
 	MSR_IA32_ARCH_CAPABILITIES,
 };
 
@@ -1224,9 +1226,18 @@ u64 kvm_get_arch_capabilities(void)
 }
 EXPORT_SYMBOL_GPL(kvm_get_arch_capabilities);
 
+u64 kvm_get_core_capability(void)
+{
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_get_core_capability);
+
 static int kvm_get_msr_feature(struct kvm_msr_entry *msr)
 {
 	switch (msr->index) {
+	case MSR_IA32_CORE_CAPABILITY:
+		msr->data = kvm_get_core_capability();
+		break;
 	case MSR_IA32_ARCH_CAPABILITIES:
 		msr->data = kvm_get_arch_capabilities();
 		break;
@@ -2445,6 +2456,12 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_EFER:
 		return set_efer(vcpu, data);
+	case MSR_IA32_CORE_CAPABILITY:
+		if (!msr_info->host_initiated)
+			return 1;
+
+		vcpu->arch.core_capability = data;
+		break;
 	case MSR_K7_HWCR:
 		data &= ~(u64)0x40;	/* ignore flush filter disable */
 		data &= ~(u64)0x100;	/* ignore ignne emulation enable */
@@ -2750,6 +2767,12 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_TSC:
 		msr_info->data = kvm_scale_tsc(vcpu, rdtsc()) + vcpu->arch.tsc_offset;
 		break;
+	case MSR_IA32_CORE_CAPABILITY:
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_CORE_CAPABILITY))
+			return 1;
+		msr_info->data = vcpu->arch.core_capability;
+		break;
 	case MSR_MTRRcap:
 	case 0x200 ... 0x2ff:
 		return kvm_mtrr_get_msr(vcpu, msr_info->index, &msr_info->data);
@@ -8725,6 +8748,7 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 
 int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
 {
+	vcpu->arch.core_capability = kvm_get_core_capability();
 	vcpu->arch.msr_platform_info = MSR_PLATFORM_INFO_CPUID_FAULT;
 	kvm_vcpu_mtrr_init(vcpu);
 	vcpu_load(vcpu);
-- 
2.19.1

