Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BF01C282DA
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 22:14:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 754EC21850
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 22:14:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387488AbfDQWOZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 18:14:25 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:59554 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728237AbfDQWOZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 18:14:25 -0400
Received: from pd9ef12d2.dip0.t-ipconnect.de ([217.239.18.210] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hGson-000799-Dr; Thu, 18 Apr 2019 00:14:13 +0200
Date:   Thu, 18 Apr 2019 00:14:12 +0200 (CEST)
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
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@linux.intel.com>
Subject: Re: [PATCH v7 10/21] x86/split_lock: Define per CPU variable to
 cache MSR TEST_CTL
In-Reply-To: <1555536851-17462-11-git-send-email-fenghua.yu@intel.com>
Message-ID: <alpine.DEB.2.21.1904180009200.3174@nanos.tec.linutronix.de>
References: <1555536851-17462-1-git-send-email-fenghua.yu@intel.com> <1555536851-17462-11-git-send-email-fenghua.yu@intel.com>
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

> MSR TEST_CTL (0x33) value is cached in per CPU variable msr_test_ctl_cache.

It _is_ cached? How so?

> The cached value will be used in virutalization to avoid costly MSR read.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@linux.intel.com>

That SOB chain is bogus.

> ---
>  arch/x86/include/asm/cpu.h  | 1 +
>  arch/x86/kernel/cpu/intel.c | 3 +++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
> index 4e03f53fc079..cd7493f20234 100644
> --- a/arch/x86/include/asm/cpu.h
> +++ b/arch/x86/include/asm/cpu.h
> @@ -40,6 +40,7 @@ int mwait_usable(const struct cpuinfo_x86 *);
>  unsigned int x86_family(unsigned int sig);
>  unsigned int x86_model(unsigned int sig);
>  unsigned int x86_stepping(unsigned int sig);
> +DECLARE_PER_CPU(u64, msr_test_ctl_cache);
>  #ifdef CONFIG_CPU_SUP_INTEL
>  void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c);
>  #else
> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> index 62f61a961eb6..997d683d3c27 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -31,6 +31,9 @@
>  #include <asm/apic.h>
>  #endif
>  
> +DEFINE_PER_CPU(u64, msr_test_ctl_cache);
> +EXPORT_PER_CPU_SYMBOL_GPL(msr_test_ctl_cache);

Contrary to things like cpufeatures or MSR bits, it's pretty useless to
have a separate patch for this. Please fold this into the place which
actualy uses it.

Thanks,

	tglx
