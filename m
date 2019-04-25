Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 275A2C282E3
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 06:07:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E825720811
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 06:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1556172447;
	bh=tgSDoVir5vFcmTapauqQMWq5W42gOTfcncrud85+FH8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=CivYAELr8njh8MGX/lgzQM7CAtM1cjFIxEA6buSJQgPojaEZ5LVEuRMfAZnf/DxvG
	 IxAl9nvCAYW8r5ammNqaM7eWkVWC3JLrwXn43aYmKHFTGzlx9Ia4svxDAaBsEVGa+8
	 Y4NT1uiBMwqgxKITVz2EVAQJOpp90QPnxekAckDM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729471AbfDYGHV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 02:07:21 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53152 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727119AbfDYGHV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 02:07:21 -0400
Received: by mail-wm1-f66.google.com with SMTP id j13so7676040wmh.2;
        Wed, 24 Apr 2019 23:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TjBr1NfdwuGVc1XPZioyKxewNiib7C5TjSHGdyk9F6o=;
        b=gCsxsW3YDxw+OG/aASNs8EbsSzkGN0n1AsVozSQcH74hh9QwVyEKvMYojrLS8/v0wZ
         0Y5LoN8XhcSbIssqG7a8006vsJQ+zPZL1G3YOWUT/MJw3g0/uDRWH7VxGj/SMKBjQL8n
         e8yoOT1LFKnp2pLzlHngv0nFkvZDe8gpOKIWbPllkPpY4a07huFle3oVdk/WE+w0uAD+
         cpUOQzb5mGK5WrSnUH3VbFyzFFXYKNGa2OZEzg/xu6ksicKI1/tB6j9/wKCWK7lZhlZR
         2eL1jXW82TSzSRb5/ltwud9JyorB3spZdrDYmtBusgMElpLiceuxJz/tlDucs2IeTb+k
         EtIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=TjBr1NfdwuGVc1XPZioyKxewNiib7C5TjSHGdyk9F6o=;
        b=KaLm/WKN4TtaLaUCNJNNSfSZ4kqBxrAuLv5JD+R/xW08W/+GVijcygmKJpi7fJSoDj
         UHYdhReYqP8k8rcnIB5rujuj0wFfqUTVEyiYEl9II0vkO8giqoay0t0UP6okiF8l60x1
         m7k6KUh6puipFqLc5JUL4H/jYHsmYidj6Sv8GFdlUzohlX+tDCabulkegiA5Kn3DSKeb
         uosSDD0MXsvkgl1gufFSKdG3jiilzqbEJb1UEY/qmzgFiowTBLvFzonvbR8RfnOZ8oa3
         W9MGL2cRZ8KvSks8MEpTn9xCmcndRrAQigptXb5i6Ap0gZllKMa8KLegWBUF54LCVwoF
         6a9w==
X-Gm-Message-State: APjAAAUS5s5M2MXok1drba2Zg4jqrPCvO2hgYFFTyww3OWwKSx00IkCR
        I4EaYIusUMbkuzYX15lCwP4IiRS6
X-Google-Smtp-Source: APXvYqxvNPBuV6ipNLYL6lT0STCjGyruVZmlqyOUbnIMN0pZlxToKW7CB9qqxNoAzNcjB42kh3NxuA==
X-Received: by 2002:a1c:c910:: with SMTP id f16mr1722142wmb.118.1556172438427;
        Wed, 24 Apr 2019 23:07:18 -0700 (PDT)
Received: from gmail.com (2E8B0CD5.catv.pool.telekom.hu. [46.139.12.213])
        by smtp.gmail.com with ESMTPSA id 204sm25587124wmc.1.2019.04.24.23.07.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 24 Apr 2019 23:07:17 -0700 (PDT)
Date:   Thu, 25 Apr 2019 08:07:15 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     Fenghua Yu <fenghua.yu@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
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
Subject: Re: [PATCH v8 10/15] x86/split_lock: Handle #AC exception for split
 lock
Message-ID: <20190425060715.GB40105@gmail.com>
References: <1556134382-58814-1-git-send-email-fenghua.yu@intel.com>
 <1556134382-58814-11-git-send-email-fenghua.yu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1556134382-58814-11-git-send-email-fenghua.yu@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


* Fenghua Yu <fenghua.yu@intel.com> wrote:

> There may be different considerations on how to handle #AC for split lock,
> e.g. how to handle system hang caused by split lock issue in firmware,
> how to emulate faulting instruction, etc. We use a simple method to
> handle user and kernel split lock and may extend the method in the future.
> 
> When #AC exception for split lock is triggered from user process, the
> process is killed by SIGBUS. To execute the process properly, a user
> application developer needs to fix the split lock issue.
> 
> When #AC exception for split lock is triggered from a kernel instruction,
> disable split lock detection on local CPU and warn the split lock issue.
> After the exception, the faulting instruction will be executed and kernel
> execution continues. Split lock detection is only disabled on the local
> CPU, not globally. It will be re-enabled if the CPU is offline and then
> online or through sysfs interface.
> 
> A kernel/driver developer should check the warning, which contains helpful
> faulting address, context, and callstack info, and fix the split lock
> issues. Then further split lock issues may be captured and fixed.
> 
> After bit 29 in MSR_TEST_CTL is set to 1 in kernel, firmware inherits
> the setting when firmware is executed in S4, S5, run time services, SMI,
> etc. If there is a split lock operation in firmware, it will triggers
> #AC and may hang the system depending on how firmware handles the #AC.
> It's up to a firmware developer to fix split lock issues in firmware.
> 
> MSR TEST_CTL value is cached in per CPU msr_test_ctl_cache which will be
> used in virtualization to avoid costly MSR read.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  arch/x86/include/asm/cpu.h  |  3 +++
>  arch/x86/kernel/cpu/intel.c | 24 ++++++++++++++++++++++++
>  arch/x86/kernel/traps.c     | 31 ++++++++++++++++++++++++++++++-
>  3 files changed, 57 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
> index 4e03f53fc079..5706461eb60f 100644
> --- a/arch/x86/include/asm/cpu.h
> +++ b/arch/x86/include/asm/cpu.h
> @@ -42,7 +42,10 @@ unsigned int x86_model(unsigned int sig);
>  unsigned int x86_stepping(unsigned int sig);
>  #ifdef CONFIG_CPU_SUP_INTEL
>  void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c);
> +DECLARE_PER_CPU(u64, msr_test_ctl_cache);
> +void handle_split_lock_kernel_mode(void);
>  #else
>  static inline void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c) {}
> +static inline void handle_split_lock_kernel_mode(void) {}
>  #endif
>  #endif /* _ASM_X86_CPU_H */
> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> index d7e676c2aebf..2cc69217ca7c 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -31,6 +31,9 @@
>  #include <asm/apic.h>
>  #endif
>  
> +DEFINE_PER_CPU(u64, msr_test_ctl_cache);
> +EXPORT_PER_CPU_SYMBOL_GPL(msr_test_ctl_cache);
> +
>  /*
>   * Just in case our CPU detection goes bad, or you have a weird system,
>   * allow a way to override the automatic disabling of MPX.
> @@ -654,6 +657,17 @@ static void init_intel_misc_features(struct cpuinfo_x86 *c)
>  	wrmsrl(MSR_MISC_FEATURES_ENABLES, msr);
>  }
>  
> +static void init_split_lock_detect(struct cpuinfo_x86 *c)
> +{
> +	if (cpu_has(c, X86_FEATURE_SPLIT_LOCK_DETECT)) {
> +		u64 test_ctl_val;
> +
> +		/* Cache MSR TEST_CTL */
> +		rdmsrl(MSR_TEST_CTL, test_ctl_val);
> +		this_cpu_write(msr_test_ctl_cache, test_ctl_val);
> +	}
> +}
> +
>  static void init_intel(struct cpuinfo_x86 *c)
>  {
>  	early_init_intel(c);
> @@ -766,6 +780,8 @@ static void init_intel(struct cpuinfo_x86 *c)
>  	init_intel_energy_perf(c);
>  
>  	init_intel_misc_features(c);
> +
> +	init_split_lock_detect(c);
>  }
>  
>  #ifdef CONFIG_X86_32
> @@ -1060,3 +1076,11 @@ void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c)
>  	if (ia32_core_cap & CORE_CAP_SPLIT_LOCK_DETECT)
>  		set_split_lock_detect();
>  }
> +
> +void handle_split_lock_kernel_mode(void)
> +{
> +	/* Warn and disable split lock detection on this CPU */
> +	msr_clear_bit(MSR_TEST_CTL, TEST_CTL_SPLIT_LOCK_DETECT_SHIFT);
> +	this_cpu_and(msr_test_ctl_cache, ~TEST_CTL_SPLIT_LOCK_DETECT);
> +	WARN_ONCE(1, "split lock operation detected\n");

Please name this more descriptively, such as x86_split_lock_disable() or 
so.

Also, please reorganize the split lock detection namespace to be less 
idiosynchratic, use a common x86_split_lock_ prefix and organize the new 
namespace around that:

    x86_split_lock_init()          // was: init_split_lock_detect
    x86_split_lock_enable()        // was: set_split_lock_detect
    x86_split_lock_disable()       // was: handle_split_lock_kernel_mode
    etc.

> +dotraplinkage void do_alignment_check(struct pt_regs *regs, long error_code)
> +{
> +	unsigned int trapnr = X86_TRAP_AC;
> +	char str[] = "alignment check";
> +	int signr = SIGBUS;
> +
> +	RCU_LOCKDEP_WARN(!rcu_is_watching(), "entry code didn't wake RCU");
> +
> +	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr) ==
> +		       NOTIFY_STOP)

Please do not break lines mid-line when it does absolutely nothing to 
improve readablity. Just ignore checkpatch.

> +	cond_local_irq_enable(regs);
> +	if (!user_mode(regs) &&
> +	    static_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT)) {

Ditto - in fact this doesn't even violate the col80 rule ...

> +		/*
> +		 * Only split lock can generate #AC from kernel at this point.
> +		 * Warn and disable split lock detection on this CPU. The
> +		 * faulting instruction will be executed without generating
> +		 * another #AC fault.
> +		 */

How about explaining all this more clearly:

> +		/*
> +		 * Only split locks can generate #AC from kernel mode.
> +              *
> +		 * The split-lock detection feature is a one-shot
> +              * debugging facility, so we disable it immediately and 
> +              * print a warning.
> +              *
> +              * This also solves the instruction restart problem: we 
> +              * return the faulting instruction right after this it 
> +              * will be executed without generating another #AC fault
> +              * and getting into an infinite loop, instead it will
> +              * continue without side effects to the interrupted
> +              * execution conext.
> +              *
> +              * Split-lock detection will remain disabled permanently
> +              * after this, until the next reboot.
> +		 */

?

Also, AFAICS this code will disable split-lock detection only on the 
current CPU - all the other 4,096 CPUs hitting this same lock at the 
exact same time will happily continue spamming the kernel log as they 
encounter the same split lock, correct?

While the warning itself uses WARN_ONCE(), that and the underlying 
BUGFLAG_ONCE mechanism is not an atomic facility.

Instead, please add an explicit, global split_lock_debug bit that the 
first CPU hitting it disables, and only that CPU is allowed to print a 
single warning. All other CPUs just disable split-lock debugging silently 
and continue.

This also solves the race if the split-lock #AC fault is re-triggered by 
NMI of perf context interrupting one split-lock warning execution while 
the original WARN_ON() is executing.

Thanks,

	Ingo
