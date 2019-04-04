Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EBB5C4360F
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 18:08:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A0AD206C0
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 18:08:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729421AbfDDSIO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 14:08:14 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:46170 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbfDDSIO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 14:08:14 -0400
Received: from p5492e2fc.dip0.t-ipconnect.de ([84.146.226.252] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hC6mM-0007Uw-DV; Thu, 04 Apr 2019 20:07:58 +0200
Date:   Thu, 4 Apr 2019 20:07:57 +0200 (CEST)
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
        netdev@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v6 13/20] x86/split_lock: Enable split lock detection by
 default
In-Reply-To: <1554326526-172295-14-git-send-email-fenghua.yu@intel.com>
Message-ID: <alpine.DEB.2.21.1904041932500.1802@nanos.tec.linutronix.de>
References: <1554326526-172295-1-git-send-email-fenghua.yu@intel.com> <1554326526-172295-14-git-send-email-fenghua.yu@intel.com>
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

> A split locked access locks bus and degrades overall memory access
> performance. When split lock detection feature is enumerated, enable
> the feature by default to find any split lock issue and then fix
> the issue.

Enabling the feature allows to find the issues, but does not automagically
fix them. Come on.

> +#define DISABLE_SPLIT_LOCK_DETECT 0
> +#define ENABLE_SPLIT_LOCK_DETECT  1

If those defines have a value at all, please start with the facility not
with functionality, i.e. AC_SPLIT_LOCK_ENABLE....

> +
> +static DEFINE_MUTEX(split_lock_detect_mutex);
> +static int split_lock_detect_val;

detect_val? What value is that? Its supposed to hold those magic defines
above. So something like

static unsigned int ac_split_lock_enable;

>  /*
>   * Just in case our CPU detection goes bad, or you have a weird system,
>   * allow a way to override the automatic disabling of MPX.
> @@ -161,10 +167,45 @@ static bool bad_spectre_microcode(struct cpuinfo_x86 *c)
>  	return false;
>  }
>  
> +static u32 new_sp_test_ctl_val(u32 test_ctl_val)
> +{
> +	/* Change the split lock setting. */
> +	if (READ_ONCE(split_lock_detect_val) == DISABLE_SPLIT_LOCK_DETECT)

That READ_ONCE() is required because?

> +		test_ctl_val &= ~TEST_CTL_ENABLE_SPLIT_LOCK_DETECT;
> +	else
> +		test_ctl_val |= TEST_CTL_ENABLE_SPLIT_LOCK_DETECT;
> +
> +	return test_ctl_val;
> +}

Aside of that do we really need a misnomed function which replaces the
simple inline code at the call site:

	rdmsr(l, h)
	l &= ~TEST_CTL_ENABLE_SPLIT_LOCK_DETECT;
	l |= ac_split_lock_enable << TEST_CTL_ENABLE_SPLIT_LOCK_DETECT_SHIFT;
	wrmrs(...)

or the even more simple

	if (ac_split_lock_enable)
		msr_set_bit(...)
	else
		msr_clear_nit(...)

Hmm?

> +
> +static inline void show_split_lock_detection_info(void)
> +{
> +	if (READ_ONCE(split_lock_detect_val))

That READ_ONCE() is required because?

> +		pr_info_once("x86/split_lock: split lock detection enabled\n");
> +	else
> +		pr_info_once("x86/split_lock: split lock detection disabled\n");

pr_fmt exists for a reason and having 'split lock' repeated several times
in the same line is not making it more readable.

> +}
> +
> +static void init_split_lock_detect(struct cpuinfo_x86 *c)
> +{
> +	if (cpu_has(c, X86_FEATURE_SPLIT_LOCK_DETECT)) {
> +		u32 l, h;
> +
> +		mutex_lock(&split_lock_detect_mutex);
> +		rdmsr(MSR_TEST_CTL, l, h);
> +		l = new_sp_test_ctl_val(l);
> +		wrmsr(MSR_TEST_CTL, l, h);
> +		show_split_lock_detection_info();
> +		mutex_unlock(&split_lock_detect_mutex);
> +	}
> +}
> +
>  static void early_init_intel(struct cpuinfo_x86 *c)
>  {
>  	u64 misc_enable;
>  
> +	init_split_lock_detect(c);

so we have in early boot:

	early_cpu_init()
	  early_identify_cpu()
	    this_cpu->c_early_init(c)
	      early_init_intel() {
	        init_split_lock_detect();
	      }	
            ....
            cpu_set_core_cap_bits(c)
	       set(FEATURE_SPLIT_LOCK)

I don't have to understand how init_split_lock_detect() will magically see
the feature bit which gets set afterwards, right? 


> +
>  	/* Unmask CPUID levels if masked: */
>  	if (c->x86 > 6 || (c->x86 == 6 && c->x86_model >= 0xd)) {
>  		if (msr_clear_bit(MSR_IA32_MISC_ENABLE,
> @@ -1032,6 +1073,7 @@ cpu_dev_register(intel_cpu_dev);
>  static void __init set_split_lock_detect(void)
>  {
>  	setup_force_cpu_cap(X86_FEATURE_SPLIT_LOCK_DETECT);
> +	split_lock_detect_val = 1;

Oh well. You add defines on top of the file and then you don't use them.

Thanks,

	tglx
