Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35607C282CE
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 09:57:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F193D20883
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 09:57:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbfDHJ5v (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 05:57:51 -0400
Received: from mga12.intel.com ([192.55.52.136]:46538 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725857AbfDHJ5u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 05:57:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Apr 2019 02:57:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,324,1549958400"; 
   d="scan'208";a="289670252"
Received: from lxy-dell.sh.intel.com ([10.239.159.145])
  by orsmga004.jf.intel.com with ESMTP; 08 Apr 2019 02:57:46 -0700
Message-ID: <423f329a8e194d799c6c41470266a04a9f90bc84.camel@linux.intel.com>
Subject: Re: [PATCH v6 12/20] kvm/vmx: Emulate MSR TEST_CTL
From:   Xiaoyao Li <xiaoyao.li@linux.intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        H Peter Anvin <hpa@zytor.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org
Date:   Mon, 08 Apr 2019 17:54:25 +0800
In-Reply-To: <alpine.DEB.2.21.1904051400230.1802@nanos.tec.linutronix.de>
References: <1554326526-172295-1-git-send-email-fenghua.yu@intel.com>
         <1554326526-172295-13-git-send-email-fenghua.yu@intel.com>
         <alpine.DEB.2.21.1904051400230.1802@nanos.tec.linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi, Thomas,

On Fri, 2019-04-05 at 14:30 +0200, Thomas Gleixner wrote:
> On Wed, 3 Apr 2019, Fenghua Yu wrote:
> > @@ -1663,6 +1663,12 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct
> > msr_data *msr_info)
> >  	u32 index;
> >  
> >  	switch (msr_info->index) {
> > +	case MSR_TEST_CTL:
> > +		if (!msr_info->host_initiated &&
> > +		    !(vcpu->arch.core_capability & CORE_CAP_SPLIT_LOCK_DETECT))
> 
> Errm? If the MSR_TEST_CTL is exposed to the guest via CPUID then the
> rdmsr() in the guest is not supposed to fail just because
> CORE_CAP_SPLIT_LOCK_DETECT is not set.

you're right.

> vmx->msr_test_ctl holds the proper value, which is either 0 or
> CORE_CAP_SPLIT_LOCK_DETECT until more bits are supported.
> 
> So the chek needs to be guest_cpuid_has(X86_FEATURE_CORE_CAPABILITY).

I don't think so. There is no dependecy between
guest_cpuid_has(X86_FEATURE_CORE_CAPABILITY) and MSR_TEST_CTL.
guest_cpuid_has(X86_FEATURE_CORE_CAPABILITY) only indicates that guest has MSR
CORE_CAPABILITY.

Due to the fact that MSR_TEST_CTL is emulated with vmx->msr_test_ctl. I think it
's ok to always let userspace or guest to read MSR_TEST_CTL, it just returns the
emulated value. Like you said, " vmx->msr_test_ctl holds the proper value, which
is either 0 or CORE_CAP_SPLIT_LOCK_DETECT until more bits are supported." 

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
> 
> Again, this wants to be a check for the availability of the MSR in the
> guest cpuid and not to the CORE_CAP_SPLIT_LOCK_DETECT magic bit.
> 
> > +
> > +		if (data & ~TEST_CTL_ENABLE_SPLIT_LOCK_DETECT)
> > +			return 1;
> 
> and this one wants to be:
> 
> 		if (data & vmx->msr_test_ctl_mask)
> 
> so additional bits can be enabled later on at exactly one point in the
> code, i.e. during vm init.

Again, in wrmsr handler, since MSR_TEST_CTL is emulated, it can be considered
that guest always has this MSR. It just needs to return 1 when reserved bits are
set. 

Using vmx->msr_test_ctl_mask is a good idea. I will use it in next version. 

> > +		vmx->msr_test_ctl = data;
> > +		break;
> >  
> > +static void atomic_switch_msr_test_ctl(struct vcpu_vmx *vmx)
> > +{
> > +	u64 host_msr_test_ctl;
> > +
> > +	/* if TEST_CTL MSR doesn't exist on the hardware, do nothing */
> > +	if (rdmsrl_safe(MSR_TEST_CTL, &host_msr_test_ctl))
> > +		return;
> 
> Yikes. So on hosts which do not have MSR_TEST_CTL this takes a fault on
> every VM enter. The host knows whether it has this MSR or not.
> 
> Even if it exists there is no point to do the rdmsr on every vmenter. The
> value should be cached per cpu. It only changes when:
> 
>       1) #AC triggers in kernel space
> 
>       2) The sysfs knob is flipped
> 
> #1 It happens either _BEFORE_ or _AFTER_ atomic_switch_msr_test_ctl().  In
>    both cases the cached value is correct in atomic_switch_msr_test_ctl().
>    
>    If it happens _AFTER_ atomic_switch_msr_test_ctl() then the VMEXIT will
>    restore the enabled bit, but there is nothing you can do about that.
> 
> #2 CANNOT happen in the context of vcpu_run().
> 
> So this wants to be:
> 
>    host_msr_test_ctl = this_cpu_read(msr_test_ctl_cache);

You're right and thanks for your advice. 
I will take it in next version.

> > +	if (host_msr_test_ctl == vmx->msr_test_ctl)
> > +		clear_atomic_switch_msr(vmx, MSR_TEST_CTL);
> > +	else
> > +		add_atomic_switch_msr(vmx, MSR_TEST_CTL, vmx->msr_test_ctl,
> > +				      host_msr_test_ctl, false);
> > +}
> > +
> >  u64 kvm_get_core_capability(void)
> >  {
> > -	return 0;
> > +	u64 data;
> > +
> > +	rdmsrl_safe(MSR_IA32_CORE_CAPABILITY, &data);
> 
>   	if (!boot_cpu_has(X86_FEATURE_CORE_CAPABILITY))
> 		return 0;
> 
> > +	/* mask non-virtualizable functions */
> > +	data &= CORE_CAP_SPLIT_LOCK_DETECT;
> 
> Why?
> 
> > +	/*
> > +	 * There will be a list of FMS values that have split lock detection
> > +	 * but lack the CORE CAPABILITY MSR. In this case, set
> > +	 * CORE_CAP_SPLIT_LOCK_DETECT since we emulate MSR CORE_CAPABILITY.
> 
> That's completely wrong. X86_FEATURE_SPLIT_LOCK_DETECT is set when the
> capability is enumerated in CPUID or it's set via the FMS quirk.
> 
> So:
> 	data = 0;
> > +	if (boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT))
> > +		data |= CORE_CAP_SPLIT_LOCK_DETECT;
> > +
> > +	return data;
> 
> is absolutely sufficient.

Right, X86_FEATURE_SPLIT_LOCK_DETECT is set in 2 situation:

	#1 the capability is enumerated by CORE_CAP_SPLIT_LOCK_DETECT (bit 5 of
MSR_IA32_CORE_CAPABILITY)
	
	#2 via FMS list, in which those processors have split lock detection
feature but don't have MSR_IA32_CORE_CAPABILITY.

There two pathes work well for host, accurately for real FMS.
However, when it comes to virtualization, we can emulate a different FMS of
guest from host.

Considering the following case:

The host cpu is ICELAKE_MOBILE, which doesn't have X86_FEATURE_CORE_CAPABILITY
but has X86_FEATURE_SPLIT_LOCK_DETECT. 
If we run a guest with cpu model, Skylake. It will hidden the feature
X86_FEATURE_SPLIT_LOCK_DETECT from guest, since guest's MSR_IA32_CORE_CAPABILITY
reports zero, and FMS of guest doesn't match the list.

In this way, it failed to expose the X86_FEATURE_SPLIT_LOCK_DETECT to guest.

Since MSR_IA32_CORE_CAPBILITY is emulated in software for guest. We can enforce
using #1 to report X86_FEATURE_SPLIT_LOCK_DETECT of guest, thus guest can get
rid of the limitation of the FMS list.
 

> Thanks,
> 
> 	tglx

