Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89908C43219
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 19:56:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A18E8205ED
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 19:56:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388017AbfDYT4V (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 15:56:21 -0400
Received: from mga17.intel.com ([192.55.52.151]:4911 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729259AbfDYT4V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 15:56:21 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Apr 2019 12:56:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,394,1549958400"; 
   d="scan'208";a="226726529"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by orsmga001.jf.intel.com with ESMTP; 25 Apr 2019 12:56:19 -0700
Date:   Thu, 25 Apr 2019 12:48:09 -0700
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
Subject: Re: [PATCH v8 09/15] x86/split_lock: Define MSR TEST_CTL register
Message-ID: <20190425194808.GB64477@romley-ivt3.sc.intel.com>
References: <1556134382-58814-1-git-send-email-fenghua.yu@intel.com>
 <1556134382-58814-10-git-send-email-fenghua.yu@intel.com>
 <20190425062126.GC40105@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190425062126.GC40105@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Apr 25, 2019 at 08:21:26AM +0200, Ingo Molnar wrote:
> 
> * Fenghua Yu <fenghua.yu@intel.com> wrote:
> 
> > Setting bit 29 in MSR TEST_CTL (0x33) enables split lock detection and
> > clearing the bit disables split lock detection.
> > 
> > Define the MSR and the bit. The definitions will be used in enabling or
> > disabling split lock detection.
> > 
> > Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> > ---
> >  arch/x86/include/asm/msr-index.h | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> > index f65ef6f783d2..296eeb761ab6 100644
> > --- a/arch/x86/include/asm/msr-index.h
> > +++ b/arch/x86/include/asm/msr-index.h
> > @@ -39,6 +39,10 @@
> >  
> >  /* Intel MSRs. Some also available on other CPUs */
> >  
> > +#define MSR_TEST_CTL				0x00000033
> > +#define TEST_CTL_SPLIT_LOCK_DETECT_SHIFT	29
> > +#define TEST_CTL_SPLIT_LOCK_DETECT		BIT(29)
> 
> Three problems:
> 
>  - Is MSR_TEST_CTL is not really a canonical MSR name... A quick look at 
>    msr-index reveals the prevailing nomenclature:
> 
>      dagon:~/tip> git grep -h 'define MSR' arch/x86/include/asm/msr-index.h | cut -d_ -f1-2 | sort -n | uniq -c | sort -n | tail -10
>        8 #define MSR_K8
>        8 #define MSR_MTRRfix4K
>       12 #define MSR_CORE
>       13 #define MSR_IDT
>       14 #define MSR_K7
>       16 #define MSR_PKG
>       19 #define MSR_F15H
>       33 #define MSR_AMD64
>       83 #define MSR_P4
>      163 #define MSR_IA32
> 
>    I.e. this shouldn't this be something like MSR_IA32_TEST_CTL - or this 
>    the name the Intel SDM uses? (I haven't checked.)

TEST_CTL is the MSR's exact name shown in Table 2-14 in the latest SDM.
https://software.intel.com/en-us/download/intel-64-and-ia-32-architectures-sdm-combined-volumes-1-2a-2b-2c-2d-3a-3b-3c-3d-and-4

So can I still use MSR_TEST_CTL here?

> 
>  - The canonical way to define MSR capabilities is to use the MSR's name 
>    as a prefix. I.e.:
> 
>         MSR_TEST_CTL
>         MSR_TEST_CTL_SPLIT_LOCK_DETECT_BIT
>         MSR_TEST_CTL_SPLIT_LOCK_DETECT
>         etc.
> 
>    Instead of the random mixture of MSR_ prefixed and non-prefixed 
>    MSR_TEST_CTL, TEST_CTL_SPLIT_LOCK_DETECT_SHIFT and 
>    TEST_CTL_SPLIT_LOCK_DETECT names.
> 
>  - Finally, this is not how we define bits - the _SHIFT postfix is actively
>    confusing as we usually denote _SHIFT values with something that is 
>    used in a bit-shift operation, which this isn't. Instead the proper 
>    scheme is to postfix the bit number with _BIT and the mask with _MASK, 
>    i.e. something like:
> 
>      #define MSR_TEST_CTL				0x00000033
>      #define MSR_TEST_CTL_SPLIT_LOCK_DETECT_BIT		29
>      #define MSR_TEST_CTL_SPLIT_LOCK_DETECT		BIT(MSR_TEST_CTL_SPLIT_LOCK_DETECT_BIT)
> 
> Note how this cleans up actual usage:
> 
> +       msr_set_bit(MSR_TEST_CTL, TEST_CTL_SPLIT_LOCK_DETECT_SHIFT);
> +       this_cpu_or(msr_test_ctl_cache, TEST_CTL_SPLIT_LOCK_DETECT);
> 
> -       msr_set_bit(MSR_TEST_CTL, MSR_TEST_CTL_SPLIT_LOCK_DETECT_BIT);
> -       this_cpu_or(msr_test_ctl_cache, MSR_TEST_CTL_SPLIT_LOCK_DETECT);
> 
> Frankly, this kind of disorganized code in a v8 submission is *really* 
> disappointing, it's not like it's hard to look up these patterns and 
> practices in existing code...

OK. Will change the bit and mask definitions.

Thanks.

-Fenghua
