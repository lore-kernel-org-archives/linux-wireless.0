Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0D78C43219
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 19:10:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BAFA206A3
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 19:10:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbfDYTJ7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 15:09:59 -0400
Received: from mga04.intel.com ([192.55.52.120]:50488 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726065AbfDYTJ7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 15:09:59 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Apr 2019 12:09:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,394,1549958400"; 
   d="scan'208";a="165095414"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by fmsmga004.fm.intel.com with ESMTP; 25 Apr 2019 12:09:58 -0700
Date:   Thu, 25 Apr 2019 12:01:48 -0700
From:   Fenghua Yu <fenghua.yu@intel.com>
To:     Ingo Molnar <mingo@kernel.org>
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
Subject: Re: [PATCH v8 05/15] x86/msr-index: Define MSR_IA32_CORE_CAPABILITY
 and split lock detection bit
Message-ID: <20190425190148.GA64477@romley-ivt3.sc.intel.com>
References: <1556134382-58814-1-git-send-email-fenghua.yu@intel.com>
 <1556134382-58814-6-git-send-email-fenghua.yu@intel.com>
 <20190425054511.GA40105@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190425054511.GA40105@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Apr 25, 2019 at 07:45:11AM +0200, Ingo Molnar wrote:
> 
> * Fenghua Yu <fenghua.yu@intel.com> wrote:
> 
> > A new MSR_IA32_CORE_CAPABILITY (0xcf) is defined. Each bit in the MSR
> > enumerates a model specific feature. Currently bit 5 enumerates split
> > lock detection. When bit 5 is 1, split lock detection is supported.
> > When the bit is 0, split lock detection is not supported.
> > 
> > Please check the latest Intel 64 and IA-32 Architectures Software
> > Developer's Manual for more detailed information on the MSR and the
> > split lock detection bit.
> > 
> > Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> > ---
> >  arch/x86/include/asm/msr-index.h | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> > index ca5bc0eacb95..f65ef6f783d2 100644
> > --- a/arch/x86/include/asm/msr-index.h
> > +++ b/arch/x86/include/asm/msr-index.h
> > @@ -59,6 +59,9 @@
> >  #define MSR_PLATFORM_INFO_CPUID_FAULT_BIT	31
> >  #define MSR_PLATFORM_INFO_CPUID_FAULT		BIT_ULL(MSR_PLATFORM_INFO_CPUID_FAULT_BIT)
> >  
> > +#define MSR_IA32_CORE_CAPABILITY	0x000000cf
> > +#define CORE_CAP_SPLIT_LOCK_DETECT	BIT(5)     /* Detect split lock */
> 
> Please don't put comments into definitions.

I'll remove the comment and change definitions of the MSR and the split lock
detection bit as following:

+#define MSR_IA32_CORE_CAPABILITY                       0x000000cf
+#define MSR_IA32_CORE_CAPABILITY_SPLIT_LOCK_DETECT_BIT 5
+#define MSR_IA32_CORE_CAPABILITY_SPLIT_LOCK_DETECT     BIT(MSR_IA32_CORE_CAPABILITY_SPLIT_LOCK_DETECT_BIT)

Are these right changes?

Thanks.

-Fenghua
