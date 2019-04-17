Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0865C282DA
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 21:44:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCB8B21871
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 21:44:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387818AbfDQVnz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 17:43:55 -0400
Received: from mga12.intel.com ([192.55.52.136]:20166 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387565AbfDQVm0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 17:42:26 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Apr 2019 14:42:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,363,1549958400"; 
   d="scan'208";a="224441193"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by orsmga001.jf.intel.com with ESMTP; 17 Apr 2019 14:42:24 -0700
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
        Xiaoyao Li <xiaoyao.li@linux.intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH v7 13/21] kvm/vmx: Emulate MSR TEST_CTL
Date:   Wed, 17 Apr 2019 14:34:03 -0700
Message-Id: <1555536851-17462-14-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 2.5.0
In-Reply-To: <1555536851-17462-1-git-send-email-fenghua.yu@intel.com>
References: <1555536851-17462-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Xiaoyao Li <xiaoyao.li@linux.intel.com>

A control bit (bit 29) in TEST_CTL MSR 0x33 will be introduced in
future x86 processors. When bit 29 is set, the processor causes #AC
exception for split locked accesses at all CPL.

Please check the latest Intel 64 and IA-32 Architectures Software
Developer's Manual for more detailed information on the MSR and
the split lock bit.

This patch emulates MSR TEST_CTL with vmx->msr_test_ctl and does the
following:
1. As MSR TEST_CTL of guest is emulated, enable the related bit
in CORE_CAPABILITY to correctly report this feature to guest.

2. Differentiate MSR TEST_CTL between host and guest.

Signed-off-by: Xiaoyao Li <xiaoyao.li@linux.intel.com>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h |  2 ++
 arch/x86/kvm/x86.c     | 19 ++++++++++++++++++-
 3 files changed, 62 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b4e7d645275a..bbb9859350b5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1663,6 +1663,11 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	u32 index;
 
 	switch (msr_info->index) {
+	case MSR_TEST_CTL:
+		if (!vmx->msr_test_ctl_mask)
+			return 1;
+		msr_info->data = vmx->msr_test_ctl;
+		break;
 #ifdef CONFIG_X86_64
 	case MSR_FS_BASE:
 		msr_info->data = vmcs_readl(GUEST_FS_BASE);
@@ -1797,6 +1802,12 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	u32 index;
 
 	switch (msr_index) {
+	case MSR_TEST_CTL:
+		if (!vmx->msr_test_ctl_mask ||
+		    (data & vmx->msr_test_ctl_mask) != data)
+			return 1;
+		vmx->msr_test_ctl = data;
+		break;
 	case MSR_EFER:
 		ret = kvm_set_msr_common(vcpu, msr_info);
 		break;
@@ -4106,6 +4117,16 @@ static void vmx_vcpu_setup(struct vcpu_vmx *vmx)
 	}
 }
 
+static u64 vmx_get_msr_test_ctl_mask(struct kvm_vcpu *vcpu)
+{
+	u64 mask = 0;
+
+	if (vcpu->arch.core_capability & CORE_CAP_SPLIT_LOCK_DETECT)
+		mask |= TEST_CTL_SPLIT_LOCK_DETECT;
+
+	return mask;
+}
+
 static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -4114,6 +4135,8 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 	vmx->rmode.vm86_active = 0;
 	vmx->spec_ctrl = 0;
+	vmx->msr_test_ctl = 0;
+	vmx->msr_test_ctl_mask = vmx_get_msr_test_ctl_mask(vcpu);
 
 	vcpu->arch.microcode_version = 0x100000000ULL;
 	vmx->vcpu.arch.regs[VCPU_REGS_RDX] = get_rdx_init_val();
@@ -6313,6 +6336,23 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
 					msrs[i].host, false);
 }
 
+static void atomic_switch_msr_test_ctl(struct vcpu_vmx *vmx)
+{
+	u64 host_msr_test_ctl;
+
+	if (!boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT))
+		return;
+
+	host_msr_test_ctl = this_cpu_read(msr_test_ctl_cache);
+
+	if (host_msr_test_ctl == vmx->msr_test_ctl) {
+		clear_atomic_switch_msr(vmx, MSR_TEST_CTL);
+	} else {
+		add_atomic_switch_msr(vmx, MSR_TEST_CTL, vmx->msr_test_ctl,
+				      host_msr_test_ctl, false);
+	}
+}
+
 static void vmx_arm_hv_timer(struct vcpu_vmx *vmx, u32 val)
 {
 	vmcs_write32(VMX_PREEMPTION_TIMER_VALUE, val);
@@ -6421,6 +6461,8 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	atomic_switch_perf_msrs(vmx);
 
+	atomic_switch_msr_test_ctl(vmx);
+
 	vmx_update_hv_timer(vcpu);
 
 	/*
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index f879529906b4..8690a1295548 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -190,6 +190,8 @@ struct vcpu_vmx {
 	u64		      msr_guest_kernel_gs_base;
 #endif
 
+	u64		      msr_test_ctl;
+	u64		      msr_test_ctl_mask;
 	u64		      spec_ctrl;
 
 	u32 vm_entry_controls_shadow;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e88be97d47b9..60aaf75d0fe5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1231,7 +1231,24 @@ EXPORT_SYMBOL_GPL(kvm_get_arch_capabilities);
 
 static u64 kvm_get_core_capability(void)
 {
-	return 0;
+	u64 data = 0;
+
+	if (boot_cpu_has(X86_FEATURE_CORE_CAPABILITY)) {
+		rdmsrl(MSR_IA32_CORE_CAPABILITY, data);
+
+		/* mask non-virtualizable functions */
+		data &= CORE_CAP_SPLIT_LOCK_DETECT;
+	} else if (boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT)) {
+		/*
+		 * There will be a list of FMS values that have split lock
+		 * detection but lack the CORE CAPABILITY MSR. In this case,
+		 * set CORE_CAP_SPLIT_LOCK_DETECT since we emulate
+		 * MSR CORE_CAPABILITY.
+		 */
+		data |= CORE_CAP_SPLIT_LOCK_DETECT;
+	}
+
+	return data;
 }
 
 static int kvm_get_msr_feature(struct kvm_msr_entry *msr)
-- 
2.19.1

