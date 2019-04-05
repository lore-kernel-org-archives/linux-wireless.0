Return-Path: <SRS0=iN42=SH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F178C4360F
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Apr 2019 12:31:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 185F72186A
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Apr 2019 12:31:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730554AbfDEMbM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Apr 2019 08:31:12 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:48087 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730329AbfDEMbM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Apr 2019 08:31:12 -0400
Received: from p5492e2fc.dip0.t-ipconnect.de ([84.146.226.252] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hCNzl-0000uO-Gy; Fri, 05 Apr 2019 14:30:57 +0200
Date:   Fri, 5 Apr 2019 14:30:56 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Fenghua Yu <fenghua.yu@intel.com>
cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        H Peter Anvin <hpa@zytor.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@linux.intel.com>
Subject: Re: [PATCH v6 12/20] kvm/vmx: Emulate MSR TEST_CTL
In-Reply-To: <1554326526-172295-13-git-send-email-fenghua.yu@intel.com>
Message-ID: <alpine.DEB.2.21.1904051400230.1802@nanos.tec.linutronix.de>
References: <1554326526-172295-1-git-send-email-fenghua.yu@intel.com> <1554326526-172295-13-git-send-email-fenghua.yu@intel.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 3 Apr 2019, Fenghua Yu wrote:
> @@ -1663,6 +1663,12 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	u32 index;
>  
>  	switch (msr_info->index) {
> +	case MSR_TEST_CTL:
> +		if (!msr_info->host_initiated &&
> +		    !(vcpu->arch.core_capability & CORE_CAP_SPLIT_LOCK_DETECT))

Errm? If the MSR_TEST_CTL is exposed to the guest via CPUID then the
rdmsr() in the guest is not supposed to fail just because
CORE_CAP_SPLIT_LOCK_DETECT is not set.

vmx->msr_test_ctl holds the proper value, which is either 0 or
CORE_CAP_SPLIT_LOCK_DETECT until more bits are supported.

So the chek needs to be guest_cpuid_has(X86_FEATURE_CORE_CAPABILITY).

> +			return 1;
> +		msr_info->data = vmx->msr_test_ctl;
> +		break;
>  #ifdef CONFIG_X86_64
>  	case MSR_FS_BASE:
>  		msr_info->data = vmcs_readl(GUEST_FS_BASE);
> @@ -1797,6 +1803,14 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	u32 index;
>  
>  	switch (msr_index) {
> +	case MSR_TEST_CTL:
> +		if (!(vcpu->arch.core_capability & CORE_CAP_SPLIT_LOCK_DETECT))
> +			return 1;

Again, this wants to be a check for the availability of the MSR in the
guest cpuid and not to the CORE_CAP_SPLIT_LOCK_DETECT magic bit.

> +
> +		if (data & ~TEST_CTL_ENABLE_SPLIT_LOCK_DETECT)
> +			return 1;

and this one wants to be:

		if (data & vmx->msr_test_ctl_mask)

so additional bits can be enabled later on at exactly one point in the
code, i.e. during vm init.

> +		vmx->msr_test_ctl = data;
> +		break;
>  
> +static void atomic_switch_msr_test_ctl(struct vcpu_vmx *vmx)
> +{
> +	u64 host_msr_test_ctl;
> +
> +	/* if TEST_CTL MSR doesn't exist on the hardware, do nothing */
> +	if (rdmsrl_safe(MSR_TEST_CTL, &host_msr_test_ctl))
> +		return;

Yikes. So on hosts which do not have MSR_TEST_CTL this takes a fault on
every VM enter. The host knows whether it has this MSR or not.

Even if it exists there is no point to do the rdmsr on every vmenter. The
value should be cached per cpu. It only changes when:

      1) #AC triggers in kernel space

      2) The sysfs knob is flipped

#1 It happens either _BEFORE_ or _AFTER_ atomic_switch_msr_test_ctl().  In
   both cases the cached value is correct in atomic_switch_msr_test_ctl().
   
   If it happens _AFTER_ atomic_switch_msr_test_ctl() then the VMEXIT will
   restore the enabled bit, but there is nothing you can do about that.

#2 CANNOT happen in the context of vcpu_run().

So this wants to be:

   host_msr_test_ctl = this_cpu_read(msr_test_ctl_cache);

> +	if (host_msr_test_ctl == vmx->msr_test_ctl)
> +		clear_atomic_switch_msr(vmx, MSR_TEST_CTL);
> +	else
> +		add_atomic_switch_msr(vmx, MSR_TEST_CTL, vmx->msr_test_ctl,
> +				      host_msr_test_ctl, false);
> +}
> +

>  u64 kvm_get_core_capability(void)
>  {
> -	return 0;
> +	u64 data;
> +
> +	rdmsrl_safe(MSR_IA32_CORE_CAPABILITY, &data);

  	if (!boot_cpu_has(X86_FEATURE_CORE_CAPABILITY))
		return 0;

> +	/* mask non-virtualizable functions */
> +	data &= CORE_CAP_SPLIT_LOCK_DETECT;

Why?

> +	/*
> +	 * There will be a list of FMS values that have split lock detection
> +	 * but lack the CORE CAPABILITY MSR. In this case, set
> +	 * CORE_CAP_SPLIT_LOCK_DETECT since we emulate MSR CORE_CAPABILITY.

That's completely wrong. X86_FEATURE_SPLIT_LOCK_DETECT is set when the
capability is enumerated in CPUID or it's set via the FMS quirk.

So:
	data = 0;
> +	if (boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT))
> +		data |= CORE_CAP_SPLIT_LOCK_DETECT;
> +
> +	return data;

is absolutely sufficient.

Thanks,

	tglx
