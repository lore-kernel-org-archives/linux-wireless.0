Return-Path: <SRS0=EMXR=RQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18E9BC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 08:15:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD38E2147C
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 08:15:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727172AbfCMIP1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Mar 2019 04:15:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47612 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725820AbfCMIP0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Mar 2019 04:15:26 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B1CD131028C4;
        Wed, 13 Mar 2019 08:15:25 +0000 (UTC)
Received: from [10.36.112.43] (ovpn-112-43.ams2.redhat.com [10.36.112.43])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5ECC117B64;
        Wed, 13 Mar 2019 08:15:21 +0000 (UTC)
Subject: Re: [PATCH v5 10/18] kvm/x86: Emulate MSR IA32_CORE_CAPABILITY
To:     Fenghua Yu <fenghua.yu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, H Peter Anvin <hpa@zytor.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Ravi V Shankar <ravi.v.shankar@intel.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Xiaoyao Li <xiaoyao.li@linux.intel.com>
References: <1552431636-31511-1-git-send-email-fenghua.yu@intel.com>
 <1552431636-31511-11-git-send-email-fenghua.yu@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=pbonzini@redhat.com; prefer-encrypt=mutual; keydata=
 mQHhBFRCcBIBDqDGsz4K0zZun3jh+U6Z9wNGLKQ0kSFyjN38gMqU1SfP+TUNQepFHb/Gc0E2
 CxXPkIBTvYY+ZPkoTh5xF9oS1jqI8iRLzouzF8yXs3QjQIZ2SfuCxSVwlV65jotcjD2FTN04
 hVopm9llFijNZpVIOGUTqzM4U55sdsCcZUluWM6x4HSOdw5F5Utxfp1wOjD/v92Lrax0hjiX
 DResHSt48q+8FrZzY+AUbkUS+Jm34qjswdrgsC5uxeVcLkBgWLmov2kMaMROT0YmFY6A3m1S
 P/kXmHDXxhe23gKb3dgwxUTpENDBGcfEzrzilWueOeUWiOcWuFOed/C3SyijBx3Av/lbCsHU
 Vx6pMycNTdzU1BuAroB+Y3mNEuW56Yd44jlInzG2UOwt9XjjdKkJZ1g0P9dwptwLEgTEd3Fo
 UdhAQyRXGYO8oROiuh+RZ1lXp6AQ4ZjoyH8WLfTLf5g1EKCTc4C1sy1vQSdzIRu3rBIjAvnC
 tGZADei1IExLqB3uzXKzZ1BZ+Z8hnt2og9hb7H0y8diYfEk2w3R7wEr+Ehk5NQsT2MPI2QBd
 wEv1/Aj1DgUHZAHzG1QN9S8wNWQ6K9DqHZTBnI1hUlkp22zCSHK/6FwUCuYp1zcAEQEAAbQj
 UGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT6JAg0EEwECACMFAlRCcBICGwMH
 CwkIBwMCAQYVCAIJCgsEFgIDAQIeAQIXgAAKCRB+FRAMzTZpsbceDp9IIN6BIA0Ol7MoB15E
 11kRz/ewzryFY54tQlMnd4xxfH8MTQ/mm9I482YoSwPMdcWFAKnUX6Yo30tbLiNB8hzaHeRj
 jx12K+ptqYbg+cevgOtbLAlL9kNgLLcsGqC2829jBCUTVeMSZDrzS97ole/YEez2qFpPnTV0
 VrRWClWVfYh+JfzpXmgyhbkuwUxNFk421s4Ajp3d8nPPFUGgBG5HOxzkAm7xb1cjAuJ+oi/K
 CHfkuN+fLZl/u3E/fw7vvOESApLU5o0icVXeakfSz0LsygEnekDbxPnE5af/9FEkXJD5EoYG
 SEahaEtgNrR4qsyxyAGYgZlS70vkSSYJ+iT2rrwEiDlo31MzRo6Ba2FfHBSJ7lcYdPT7bbk9
 AO3hlNMhNdUhoQv7M5HsnqZ6unvSHOKmReNaS9egAGdRN0/GPDWr9wroyJ65ZNQsHl9nXBqE
 AukZNr5oJO5vxrYiAuuTSd6UI/xFkjtkzltG3mw5ao2bBpk/V/YuePrJsnPFHG7NhizrxttB
 nTuOSCMo45pfHQ+XYd5K1+Cv/NzZFNWscm5htJ0HznY+oOsZvHTyGz3v91pn51dkRYN0otqr
 bQ4tlFFuVjArBZcapSIe6NV8C4cEiSS5AQ0EVEJxcwEIAK+nUrsUz3aP2aBjIrX3a1+C+39R
 nctpNIPcJjFJ/8WafRiwcEuLjbvJ/4kyM6K7pWUIQftl1P8Woxwb5nqL7zEFHh5I+hKS3haO
 5pgco//V0tWBGMKinjqntpd4U4Dl299dMBZ4rRbPvmI8rr63sCENxTnHhTECyHdGFpqSzWzy
 97rH68uqMpxbUeggVwYkYihZNd8xt1+lf7GWYNEO/QV8ar/qbRPG6PEfiPPHQd/sldGYavmd
 //o6TQLSJsvJyJDt7KxulnNT8Q2X/OdEuVQsRT5glLaSAeVAABcLAEnNgmCIGkX7TnQF8a6w
 gHGrZIR9ZCoKvDxAr7RP6mPeS9sAEQEAAYkDEgQYAQIACQUCVEJxcwIbAgEpCRB+FRAMzTZp
 scBdIAQZAQIABgUCVEJxcwAKCRC/+9JfeMeug/SlCACl7QjRnwHo/VzENWD9G2VpUOd9eRnS
 DZGQmPo6Mp3Wy8vL7snGFBfRseT9BevXBSkxvtOnUUV2YbyLmolAODqUGzUI8ViF339poOYN
 i6Ffek0E19IMQ5+CilqJJ2d5ZvRfaq70LA/Ly9jmIwwX4auvXrWl99/2wCkqnWZI+PAepkcX
 JRD4KY2fsvRi64/aoQmcxTiyyR7q3/52Sqd4EdMfj0niYJV0Xb9nt8G57Dp9v3Ox5JeWZKXS
 krFqy1qyEIypIrqcMbtXM7LSmiQ8aJRM4ZHYbvgjChJKR4PsKNQZQlMWGUJO4nVFSkrixc9R
 Z49uIqQK3b3ENB1QkcdMg9cxsB0Onih8zR+Wp1uDZXnz1ekto+EivLQLqvTjCCwLxxJafwKI
 bqhQ+hGR9jF34EFur5eWt9jJGloEPVv0GgQflQaE+rRGe+3f5ZDgRe5Y/EJVNhBhKcafcbP8
 MzmLRh3UDnYDwaeguYmxuSlMdjFL96YfhRBXs8tUw6SO9jtCgBvoOIBDCxxAJjShY4KIvEpK
 b2hSNr8KxzelKKlSXMtB1bbHbQxiQcerAipYiChUHq1raFc3V0eOyCXK205rLtknJHhM5pfG
 6taABGAMvJgm/MrVILIxvBuERj1FRgcgoXtiBmLEJSb7akcrRlqe3MoPTntSTNvNzAJmfWhd
 SvP0G1WDLolqvX0OtKMppI91AWVu72f1kolJg43wbaKpRJg1GMkKEI3H+jrrlTBrNl/8e20m
 TElPRDKzPiowmXeZqFSS1A6Azv0TJoo9as+lWF+P4zCXt40+Zhh5hdHO38EV7vFAVG3iuay6
 7ToF8Uy7tgc3mdH98WQSmHcn/H5PFYk3xTP3KHB7b0FZPdFPQXBZb9+tJeZBi9gMqcjMch+Y
 R8dmTcQRQX14bm5nXlBF7VpSOPZMR392LY7wzAvRdhz7aeIUkdO7VelaspFk2nT7wOj1Y6uL
 nRxQlLkBDQRUQnHuAQgAx4dxXO6/Zun0eVYOnr5GRl76+2UrAAemVv9Yfn2PbDIbxXqLff7o
 yVJIkw4WdhQIIvvtu5zH24iYjmdfbg8iWpP7NqxUQRUZJEWbx2CRwkMHtOmzQiQ2tSLjKh/c
 HeyFH68xjeLcinR7jXMrHQK+UCEw6jqi1oeZzGvfmxarUmS0uRuffAb589AJW50kkQK9VD/9
 QC2FJISSUDnRC0PawGSZDXhmvITJMdD4TjYrePYhSY4uuIV02v028TVAaYbIhxvDY0hUQE4r
 8ZbGRLn52bEzaIPgl1p/adKfeOUeMReg/CkyzQpmyB1TSk8lDMxQzCYHXAzwnGi8WU9iuE1P
 0wARAQABiQHzBBgBAgAJBQJUQnHuAhsMAAoJEH4VEAzNNmmxp1EOoJy0uZggJm7gZKeJ7iUp
 eX4eqUtqelUw6gU2daz2hE/jsxsTbC/w5piHmk1H1VWDKEM4bQBTuiJ0bfo55SWsUNN+c9hh
 IX+Y8LEe22izK3w7mRpvGcg+/ZRG4DEMHLP6JVsv5GMpoYwYOmHnplOzCXHvmdlW0i6SrMsB
 Dl9rw4AtIa6bRwWLim1lQ6EM3PWifPrWSUPrPcw4OLSwFk0CPqC4HYv/7ZnASVkR5EERFF3+
 6iaaVi5OgBd81F1TCvCX2BEyIDRZLJNvX3TOd5FEN+lIrl26xecz876SvcOb5SL5SKg9/rCB
 ufdPSjojkGFWGziHiFaYhbuI2E+NfWLJtd+ZvWAAV+O0d8vFFSvriy9enJ8kxJwhC0ECbSKF
 Y+W1eTIhMD3aeAKY90drozWEyHhENf4l/V+Ja5vOnW+gCDQkGt2Y1lJAPPSIqZKvHzGShdh8
 DduC0U3xYkfbGAUvbxeepjgzp0uEnBXfPTy09JGpgWbg0w91GyfT/ujKaGd4vxG2Ei+MMNDm
 S1SMx7wu0evvQ5kT9NPzyq8R2GIhVSiAd2jioGuTjX6AZCFv3ToO53DliFMkVTecLptsXaes
 uUHgL9dKIfvpm+rNXRn9wAwGjk0X/A==
Message-ID: <8745fcf9-7b4b-733a-0517-5873a403cf76@redhat.com>
Date:   Wed, 13 Mar 2019 09:15:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1552431636-31511-11-git-send-email-fenghua.yu@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Wed, 13 Mar 2019 08:15:25 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 13/03/19 00:00, Fenghua Yu wrote:
> From: Xiaoyao Li <xiaoyao.li@linux.intel.com>
> 
> MSR IA32_CORE_CAPABILITY is a feature-enumerating MSR, bit 5 of which
> reports the capability of enabling detection of split locks (will be
> supported on future processors based on Tremont microarchitecture and
> later).
> 
> CPUID.(EAX=7H,ECX=0):EDX[30] will enumerate the presence of the
> IA32_CORE_CAPABILITY MSR.
> 
> Please check the latest Intel 64 and IA-32 Architectures Software
> Developer's Manual for more detailed information on the MSR and
> the split lock bit.
> 
> Since MSR_IA32_CORE_CAPABILITY is a feature-enumerating MSR, we can
> emulate it in software regardless of host's capability. What we need to
> do is to set the right value of it to report the capability of guest.
> 
> In this patch we just set the guest's core_capability as 0, because we
> haven't added support of the features it indicates to guest. It's for
> bisectability.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@linux.intel.com>
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/cpuid.c            |  6 ++++++
>  arch/x86/kvm/x86.c              | 24 ++++++++++++++++++++++++
>  3 files changed, 32 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 180373360e34..2c53df4a5a2a 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -570,6 +570,7 @@ struct kvm_vcpu_arch {
>  	bool tpr_access_reporting;
>  	u64 ia32_xss;
>  	u64 microcode_version;
> +	u64 core_capability;
>  
>  	/*
>  	 * Paging state of the vcpu
> @@ -1527,6 +1528,7 @@ int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_bitmap_low,
>  		    unsigned long icr, int op_64_bit);
>  
>  u64 kvm_get_arch_capabilities(void);
> +u64 kvm_get_core_capability(void);
>  void kvm_define_shared_msr(unsigned index, u32 msr);
>  int kvm_set_shared_msr(unsigned index, u64 val, u64 mask);
>  
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index c07958b59f50..b7fb1822a1e5 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -505,6 +505,12 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
>  			 * if the host doesn't support it.
>  			 */
>  			entry->edx |= F(ARCH_CAPABILITIES);
> +			/*
> +			 * Since we emulate MSR IA32_CORE_CAPABILITY in
> +			 * software, we can always enable it for guest
> +			 * regardless of host's capability.
> +			 */
> +			entry->edx |= F(CORE_CAPABILITY);
>  		} else {
>  			entry->ebx = 0;
>  			entry->ecx = 0;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 941f932373d0..e20cbb8c2b74 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1158,6 +1158,7 @@ static u32 emulated_msrs[] = {
>  
>  	MSR_IA32_TSC_ADJUST,
>  	MSR_IA32_TSCDEADLINE,
> +	MSR_IA32_CORE_CAPABILITY,
>  	MSR_IA32_MISC_ENABLE,
>  	MSR_IA32_MCG_STATUS,
>  	MSR_IA32_MCG_CTL,
> @@ -1197,6 +1198,7 @@ static u32 msr_based_features[] = {
>  
>  	MSR_F10H_DECFG,
>  	MSR_IA32_UCODE_REV,
> +	MSR_IA32_CORE_CAPABILITY,
>  	MSR_IA32_ARCH_CAPABILITIES,
>  };
>  
> @@ -1224,9 +1226,18 @@ u64 kvm_get_arch_capabilities(void)
>  }
>  EXPORT_SYMBOL_GPL(kvm_get_arch_capabilities);
>  
> +u64 kvm_get_core_capability(void)
> +{
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(kvm_get_core_capability);
> +
>  static int kvm_get_msr_feature(struct kvm_msr_entry *msr)
>  {
>  	switch (msr->index) {
> +	case MSR_IA32_CORE_CAPABILITY:
> +		msr->data = kvm_get_core_capability();
> +		break;
>  	case MSR_IA32_ARCH_CAPABILITIES:
>  		msr->data = kvm_get_arch_capabilities();
>  		break;
> @@ -2445,6 +2456,12 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		break;
>  	case MSR_EFER:
>  		return set_efer(vcpu, data);
> +	case MSR_IA32_CORE_CAPABILITY:
> +		if (!msr_info->host_initiated)
> +			return 1;
> +
> +		vcpu->arch.core_capability = data;
> +		break;
>  	case MSR_K7_HWCR:
>  		data &= ~(u64)0x40;	/* ignore flush filter disable */
>  		data &= ~(u64)0x100;	/* ignore ignne emulation enable */
> @@ -2750,6 +2767,12 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	case MSR_IA32_TSC:
>  		msr_info->data = kvm_scale_tsc(vcpu, rdtsc()) + vcpu->arch.tsc_offset;
>  		break;
> +	case MSR_IA32_CORE_CAPABILITY:
> +		if (!msr_info->host_initiated &&
> +		    !guest_cpuid_has(vcpu, X86_FEATURE_CORE_CAPABILITY))
> +			return 1;
> +		msr_info->data = vcpu->arch.core_capability;
> +		break;
>  	case MSR_MTRRcap:
>  	case 0x200 ... 0x2ff:
>  		return kvm_mtrr_get_msr(vcpu, msr_info->index, &msr_info->data);
> @@ -8725,6 +8748,7 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
>  
>  int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
>  {
> +	vcpu->arch.core_capability = kvm_get_core_capability();
>  	vcpu->arch.msr_platform_info = MSR_PLATFORM_INFO_CPUID_FAULT;
>  	kvm_vcpu_mtrr_init(vcpu);
>  	vcpu_load(vcpu);
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
