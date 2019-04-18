Return-Path: <SRS0=x8ok=SU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 936A0C282DD
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 01:36:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EBB62183E
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 01:36:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387860AbfDRBgs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 21:36:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:1866 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729331AbfDRBgs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 21:36:48 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Apr 2019 18:36:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,364,1549958400"; 
   d="scan'208";a="162874869"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by fmsmga004.fm.intel.com with ESMTP; 17 Apr 2019 18:36:47 -0700
Date:   Wed, 17 Apr 2019 18:28:49 -0700
From:   Fenghua Yu <fenghua.yu@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
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
Message-ID: <20190418012848.GC18776@romley-ivt3.sc.intel.com>
References: <1555536851-17462-1-git-send-email-fenghua.yu@intel.com>
 <1555536851-17462-11-git-send-email-fenghua.yu@intel.com>
 <alpine.DEB.2.21.1904180009200.3174@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1904180009200.3174@nanos.tec.linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Apr 18, 2019 at 12:14:12AM +0200, Thomas Gleixner wrote:
> On Wed, 17 Apr 2019, Fenghua Yu wrote:
> 
> > MSR TEST_CTL (0x33) value is cached in per CPU variable msr_test_ctl_cache.
> 
> It _is_ cached? How so?
> 
> > The cached value will be used in virutalization to avoid costly MSR read.
> > 
> > Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> > Signed-off-by: Xiaoyao Li <xiaoyao.li@linux.intel.com>
> 
> That SOB chain is bogus.
> 
> > ---
> >  arch/x86/include/asm/cpu.h  | 1 +
> >  arch/x86/kernel/cpu/intel.c | 3 +++
> >  2 files changed, 4 insertions(+)
> > 
> > diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
> > index 4e03f53fc079..cd7493f20234 100644
> > --- a/arch/x86/include/asm/cpu.h
> > +++ b/arch/x86/include/asm/cpu.h
> > @@ -40,6 +40,7 @@ int mwait_usable(const struct cpuinfo_x86 *);
> >  unsigned int x86_family(unsigned int sig);
> >  unsigned int x86_model(unsigned int sig);
> >  unsigned int x86_stepping(unsigned int sig);
> > +DECLARE_PER_CPU(u64, msr_test_ctl_cache);
> >  #ifdef CONFIG_CPU_SUP_INTEL
> >  void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c);
> >  #else
> > diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> > index 62f61a961eb6..997d683d3c27 100644
> > --- a/arch/x86/kernel/cpu/intel.c
> > +++ b/arch/x86/kernel/cpu/intel.c
> > @@ -31,6 +31,9 @@
> >  #include <asm/apic.h>
> >  #endif
> >  
> > +DEFINE_PER_CPU(u64, msr_test_ctl_cache);
> > +EXPORT_PER_CPU_SYMBOL_GPL(msr_test_ctl_cache);
> 
> Contrary to things like cpufeatures or MSR bits, it's pretty useless to
> have a separate patch for this. Please fold this into the place which
> actualy uses it.

Can I fold this patch into the KVM patch 0013 which first uses (reads) the
variable? But the variable will be set in later patches when enabling split
lock feature (patch 0014) and when enabling/disabling split lock feature
(patch 0015).

Is this a right sequence to fit the variable in the patch set?

Thanks.

-Fenghua
