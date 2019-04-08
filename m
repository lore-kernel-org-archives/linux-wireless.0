Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84F59C282CE
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 08:58:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 519A820870
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 08:58:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfDHI5l (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 04:57:41 -0400
Received: from mga17.intel.com ([192.55.52.151]:29201 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726396AbfDHI5l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 04:57:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Apr 2019 01:57:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,324,1549958400"; 
   d="scan'208";a="148960797"
Received: from lxy-dell.sh.intel.com ([10.239.159.145])
  by orsmga002.jf.intel.com with ESMTP; 08 Apr 2019 01:57:37 -0700
Message-ID: <d3fbb9a41a7989c19ddeb536e86cfef92c16fc49.camel@linux.intel.com>
Subject: Re: [PATCH v6 12/20] kvm/vmx: Emulate MSR TEST_CTL
From:   Xiaoyao Li <xiaoyao.li@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        H Peter Anvin <hpa@zytor.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org
Date:   Mon, 08 Apr 2019 16:54:15 +0800
In-Reply-To: <20190404144402.GA9911@linux.intel.com>
References: <1554326526-172295-1-git-send-email-fenghua.yu@intel.com>
         <1554326526-172295-13-git-send-email-fenghua.yu@intel.com>
         <20190404144402.GA9911@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2019-04-04 at 07:44 -0700, Sean Christopherson wrote:
> On Wed, Apr 03, 2019 at 02:21:58PM -0700, Fenghua Yu wrote:
> > From: Xiaoyao Li <xiaoyao.li@linux.intel.com>
> > 
> > A control bit (bit 29) in TEST_CTL MSR 0x33 will be introduced in
> > future x86 processors. When bit 29 is set, the processor causes #AC
> > exception for split locked accesses at all CPL.
> > 
> > Please check the latest Intel 64 and IA-32 Architectures Software
> > Developer's Manual for more detailed information on the MSR and
> > the split lock bit.
> > 
> > This patch emulate MSR TEST_CTL with vmx->msr_test_ctl and does the
> > following:
> > 1. As MSR TEST_CTL of guest is emulated, enable the related bits
> > in CORE_CAPABILITY to corretly report this feature to guest.
> 
> s/corretly/correctly

will correct it. thanks.

> > 
> > 2. Differentiate MSR TEST_CTL between host and guest.
> > 
> > Signed-off-by: Xiaoyao Li <xiaoyao.li@linux.intel.com>
> > Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> > Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 35 +++++++++++++++++++++++++++++++++++
> >  arch/x86/kvm/vmx/vmx.h |  1 +
> >  arch/x86/kvm/x86.c     | 17 ++++++++++++++++-
> >  3 files changed, 52 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index ab432a930ae8..309ccf593f0d 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -1663,6 +1663,12 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct
> > msr_data *msr_info)
> >  	u32 index;
> >  
> >  	switch (msr_info->index) {
> > +	case MSR_TEST_CTL:
> > +		if (!msr_info->host_initiated &&
> > +		    !(vcpu->arch.core_capability & CORE_CAP_SPLIT_LOCK_DETECT))
> > +			return 1;
> > +		msr_info->data = vmx->msr_test_ctl;
> > +		break;
> >  #ifdef CONFIG_X86_64
> >  	case MSR_FS_BASE:
> >  		msr_info->data = vmcs_readl(GUEST_FS_BASE);
> > @@ -1797,6 +1803,14 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct
> > msr_data *msr_info)
> >  	u32 index;
> >  
> >  	switch (msr_index) {
> > +	case MSR_TEST_CTL:
> > +		if (!(vcpu->arch.core_capability & CORE_CAP_SPLIT_LOCK_DETECT))
> > +			return 1;
> > +
> > +		if (data & ~TEST_CTL_ENABLE_SPLIT_LOCK_DETECT)
> > +			return 1;
> > +		vmx->msr_test_ctl = data;
> > +		break;
> >  	case MSR_EFER:
> >  		ret = kvm_set_msr_common(vcpu, msr_info);
> >  		break;
> > @@ -4077,6 +4091,9 @@ static void vmx_vcpu_setup(struct vcpu_vmx *vmx)
> >  		++vmx->nmsrs;
> >  	}
> >  
> > +	/* disable AC split lock by default */
> > +	vmx->msr_test_ctl = 0;
> > +
> >  	vm_exit_controls_init(vmx, vmx_vmexit_ctrl());
> >  
> >  	/* 22.2.1, 20.8.1 */
> > @@ -4114,6 +4131,7 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool
> > init_event)
> >  
> >  	vmx->rmode.vm86_active = 0;
> >  	vmx->spec_ctrl = 0;
> > +	vmx->msr_test_ctl = 0;
> >  
> >  	vcpu->arch.microcode_version = 0x100000000ULL;
> >  	vmx->vcpu.arch.regs[VCPU_REGS_RDX] = get_rdx_init_val();
> > @@ -6313,6 +6331,21 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx
> > *vmx)
> >  					msrs[i].host, false);
> >  }
> >  
> > +static void atomic_switch_msr_test_ctl(struct vcpu_vmx *vmx)
> > +{
> > +	u64 host_msr_test_ctl;
> > +
> > +	/* if TEST_CTL MSR doesn't exist on the hardware, do nothing */
> > +	if (rdmsrl_safe(MSR_TEST_CTL, &host_msr_test_ctl))
> > +		return;
> 
> This adds a RDMSR on every VM-Enter, and a fault on CPUs that don't
> support MSR_TEST_CTL.  Ideally the kernel would cache MSR_TEST_CTL and
> expose a helper that returns a boolean to indicate the existence of the
> MSRs along with the current value.  Racing with split_lock_detect_store()
> is ok since this code runs with interrupts disabled, i.e. will block
> split_lock_detect_store() until after VM-Exit.
> 
> Paolo, can you weigh in with your thoughts?  I'm surprised you acked
> this patch given your earlier comment:
> 
> https://patchwork.kernel.org/patch/10413779/#21892723

In v4 patchset, it checks boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT) first in
atomic_switch_msr_test_ctl().

In v5 patchset, considering that there is another bit (bit 31) in MSR_TEST_CTL,
and !boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT) cannot guarantee there is no
MSR_TEST_CTL in hardware. So I changed it to rdmsrl_safe() in v5.
It's my fault that I didn't point it out in the changelog in v5 patchset.

Considering the overhead of rdmsr every VMENTRY. I will use a percpu variable
msr_test_ctl_cache based on Thomas's comment to cache the value of host's
MSR_TEST_CTL.

> > +
> > +	if (host_msr_test_ctl == vmx->msr_test_ctl)
> > +		clear_atomic_switch_msr(vmx, MSR_TEST_CTL);
> > +	else
> > +		add_atomic_switch_msr(vmx, MSR_TEST_CTL, vmx->msr_test_ctl,
> > +				      host_msr_test_ctl, false);
> > +}
> > +
> >  static void vmx_arm_hv_timer(struct vcpu_vmx *vmx, u32 val)
> >  {
> >  	vmcs_write32(VMX_PREEMPTION_TIMER_VALUE, val);
> > @@ -6419,6 +6452,8 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
> >  
> >  	atomic_switch_perf_msrs(vmx);
> >  
> > +	atomic_switch_msr_test_ctl(vmx);
> > +
> >  	vmx_update_hv_timer(vcpu);
> >  
> >  	/*
> > diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> > index a1e00d0a2482..6091a8b9de74 100644
> > --- a/arch/x86/kvm/vmx/vmx.h
> > +++ b/arch/x86/kvm/vmx/vmx.h
> > @@ -190,6 +190,7 @@ struct vcpu_vmx {
> >  	u64		      msr_guest_kernel_gs_base;
> >  #endif
> >  
> > +	u64		      msr_test_ctl;
> >  	u64		      spec_ctrl;
> >  
> >  	u32 vm_entry_controls_shadow;
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 4459115eb0ec..e93c2f620cdb 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -1229,7 +1229,22 @@ EXPORT_SYMBOL_GPL(kvm_get_arch_capabilities);
> >  
> >  u64 kvm_get_core_capability(void)
> >  {
> > -	return 0;
> > +	u64 data;
> > +
> > +	rdmsrl_safe(MSR_IA32_CORE_CAPABILITY, &data);
> > +
> > +	/* mask non-virtualizable functions */
> > +	data &= CORE_CAP_SPLIT_LOCK_DETECT;
> > +
> > +	/*
> > +	 * There will be a list of FMS values that have split lock detection
> > +	 * but lack the CORE CAPABILITY MSR. In this case, set
> > +	 * CORE_CAP_SPLIT_LOCK_DETECT since we emulate MSR CORE_CAPABILITY.
> > +	 */
> > +	if (boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT))
> > +		data |= CORE_CAP_SPLIT_LOCK_DETECT;
> > +
> > +	return data;
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_get_core_capability);
> >  
> > -- 
> > 2.19.1
> > 

