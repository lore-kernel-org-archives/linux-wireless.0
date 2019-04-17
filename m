Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D256C282DC
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 22:42:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5856F20693
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 22:42:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387761AbfDQWmP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 18:42:15 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:59701 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbfDQWmP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 18:42:15 -0400
Received: from pd9ef12d2.dip0.t-ipconnect.de ([217.239.18.210] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hGtFZ-0007Zs-6t; Thu, 18 Apr 2019 00:41:53 +0200
Date:   Thu, 18 Apr 2019 00:41:52 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Fenghua Yu <fenghua.yu@intel.com>
cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        H Peter Anvin <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Christopherson Sean J <sean.j.christopherson@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Michael Chan <michael.chan@broadcom.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v7 14/21] x86/split_lock: Enable split lock detection by
 default
In-Reply-To: <1555536851-17462-15-git-send-email-fenghua.yu@intel.com>
Message-ID: <alpine.DEB.2.21.1904180019390.3174@nanos.tec.linutronix.de>
References: <1555536851-17462-1-git-send-email-fenghua.yu@intel.com> <1555536851-17462-15-git-send-email-fenghua.yu@intel.com>
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

On Wed, 17 Apr 2019, Fenghua Yu wrote:

> A split locked access locks bus and degrades overall memory access
> performance. When split lock detection feature is enumerated, enable
> the feature by default to find any split lock issue.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  arch/x86/kernel/cpu/intel.c | 34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> index 997d683d3c27..6a692d215bef 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -34,6 +34,8 @@
>  DEFINE_PER_CPU(u64, msr_test_ctl_cache);
>  EXPORT_PER_CPU_SYMBOL_GPL(msr_test_ctl_cache);
>  
> +static bool split_lock_detect_enable;
> +
>  /*
>   * Just in case our CPU detection goes bad, or you have a weird system,
>   * allow a way to override the automatic disabling of MPX.
> @@ -164,6 +166,23 @@ static bool bad_spectre_microcode(struct cpuinfo_x86 *c)
>  	return false;
>  }
>  
> +static void split_lock_update_msr(void *__unused)
> +{
> +	if (split_lock_detect_enable) {
> +		msr_set_bit(MSR_TEST_CTL, TEST_CTL_SPLIT_LOCK_DETECT_SHIFT);
> +		this_cpu_or(msr_test_ctl_cache, TEST_CTL_SPLIT_LOCK_DETECT);
> +	} else {
> +		msr_clear_bit(MSR_TEST_CTL, TEST_CTL_SPLIT_LOCK_DETECT_SHIFT);
> +		this_cpu_and(msr_test_ctl_cache, ~TEST_CTL_SPLIT_LOCK_DETECT);
> +	}

Nothing in this file initializes msr_test_ctl_cache explicitely. Register
caching always requires to read the register and store it in the cache
before doing anything with it. Nothing guarantees that all bits in that MSR
are 0 by default forever.

And once you do that _before_ calling split_lock_update_msr() then you can
spare the RMW in that function.

> +static void init_split_lock_detect(struct cpuinfo_x86 *c)
> +{
> +	if (cpu_has(c, X86_FEATURE_SPLIT_LOCK_DETECT))
> +		split_lock_update_msr(NULL);
> +}
> +
>  static void early_init_intel(struct cpuinfo_x86 *c)
>  {
>  	u64 misc_enable;
> @@ -661,6 +680,8 @@ static void init_intel(struct cpuinfo_x86 *c)
>  {
>  	early_init_intel(c);
>  
> +	init_split_lock_detect(c);

Sigh. Why needs this to be squeezed in the middle of the whole enumeration
stuff? Just because....

init_intel_misc_features() is called at the end and it does also MSR
caching etc. So down there is the right place.

> +
>  	intel_workarounds(c);
>  
>  	/*
> @@ -1032,9 +1053,22 @@ static const struct cpu_dev intel_cpu_dev = {
>  
>  cpu_dev_register(intel_cpu_dev);
>  
> +#undef pr_fmt
> +#define pr_fmt(fmt) "x86/split lock detection: " fmt
> +
> +static void show_split_lock_detection_info(void)
> +{
> +	if (split_lock_detect_enable)
> +		pr_info("enabled\n");
> +	else
> +		pr_info("disabled\n");

This function is truly useful. The else path is never invoked. See the call
site below.

> +}
> +
>  static void __init set_split_lock_detect(void)
>  {
>  	setup_force_cpu_cap(X86_FEATURE_SPLIT_LOCK_DETECT);
> +	split_lock_detect_enable = true;
> +	show_split_lock_detection_info();
>  }

Oh well.

Thanks,

	tglx
