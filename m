Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F9CCC43219
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 06:00:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45E35206E0
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 06:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1556258423;
	bh=XwVkAeBflMUjAt+dKBxND8OqrDbucl9vUib9UY4pjac=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=fOdh7M2mZR+yOIj36JYQvlrjN30HmL2Ak3TL1tQlT1LNS3W8bN+Y7q2sgewPXgC9m
	 P/XF/jj/LZ2Lwsu0VE8PVoMvkMsNKJPHizx9AwhNFa2KvPUPMz1SeiTLldKXN+sTNY
	 2bouq9mPiWyH0cIQPqI9W0pDfdvY+z5Hi6D0qDRo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbfDZGAR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 02:00:17 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55630 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727346AbfDZGAQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 02:00:16 -0400
Received: by mail-wm1-f68.google.com with SMTP id o25so2198744wmf.5;
        Thu, 25 Apr 2019 23:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xG06JOJH6aQLNft6haZRC3MGK6N0PVzv1voVXNfMTvc=;
        b=Yd63ou6cXbKRz4amh22WBpCSJKQZlACjg2tXHXVW7Y40Q3JFCDVY8bkHcnN8rnr4a/
         M+fBXQSFZaHYLVkaxQ39g29lPtIlMMTMg5LDsMmU+T2QUbmxg+L5NTA3kapjEesPcbjG
         4g2jY24bMC+w6997jcB7xlZVp5s4hlHVJ1aFXn3vCJyHDXkHWYpRp2xXamtch6S0MAmA
         w/EusqN05FTRCG/S5wUDFUPdZBIjsD4yXdv4j8opiKUIzFZ1bILfEskAOkyMTRuxjfTy
         d8x4vBOPlYf9XLmQcHYLs1HBZoemTu+eM/EES3Pn0dFVBXQa5JJu1h6oGvOoWkrt/WGr
         8oyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=xG06JOJH6aQLNft6haZRC3MGK6N0PVzv1voVXNfMTvc=;
        b=m6wT2tN/22JazqLccqlGzB2+v3xnUC4O0WNBfbK4I4P4GYSMXSm2EG7GKqsBdQ5Py3
         K4AoHYtvX4SGM7+CUgvk04Ia7JAS8w1vDXJtEpygAXchJ92kjZNzUOlMBT+3eoJmTsRf
         C32yhy2iA8E76i06yz0ag2VWBQLwEwjWP/ppTe5FFspASUWl/DLM/juUsI5zXT262Vhq
         TxXkHJ7bb61FB6XfH87hAz6+r6g7mwbQkeU2QPxdB1W9fTvLMN7gA0XflXjOf4sUS/aQ
         HbRwHFUUHrAUS8b8ylntVowFcm/bfAW2cbXuwcUe9+aJGXfYed/O3//9FK+jBmhT74Y2
         rMcw==
X-Gm-Message-State: APjAAAU9Ox39+LD7UfR7hwj1j1OJPhvZmLzrjJg4UZJ+f6M7B+tx8iH9
        yHaNJzPo0D95ESnva2pc/JU=
X-Google-Smtp-Source: APXvYqx1h0fGs/p5JDZCopdJAAThg0TMzLOzvf7ttpgeeXPyWG6k4MPouwa1UX3571OZfTdqtBokUg==
X-Received: by 2002:a7b:c115:: with SMTP id w21mr6174946wmi.55.1556258413393;
        Thu, 25 Apr 2019 23:00:13 -0700 (PDT)
Received: from gmail.com (2E8B0CD5.catv.pool.telekom.hu. [46.139.12.213])
        by smtp.gmail.com with ESMTPSA id n1sm17595815wmc.19.2019.04.25.23.00.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Apr 2019 23:00:12 -0700 (PDT)
Date:   Fri, 26 Apr 2019 08:00:10 +0200
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
Subject: Re: [PATCH v8 05/15] x86/msr-index: Define MSR_IA32_CORE_CAPABILITY
 and split lock detection bit
Message-ID: <20190426060010.GB122831@gmail.com>
References: <1556134382-58814-1-git-send-email-fenghua.yu@intel.com>
 <1556134382-58814-6-git-send-email-fenghua.yu@intel.com>
 <20190425054511.GA40105@gmail.com>
 <20190425190148.GA64477@romley-ivt3.sc.intel.com>
 <20190425194714.GA58719@gmail.com>
 <20190425195154.GC64477@romley-ivt3.sc.intel.com>
 <20190425200830.GD58719@gmail.com>
 <20190425202226.GD64477@romley-ivt3.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190425202226.GD64477@romley-ivt3.sc.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


* Fenghua Yu <fenghua.yu@intel.com> wrote:

> On Thu, Apr 25, 2019 at 10:08:30PM +0200, Ingo Molnar wrote:
> > 
> > * Fenghua Yu <fenghua.yu@intel.com> wrote:
> > 
> > > On Thu, Apr 25, 2019 at 09:47:14PM +0200, Ingo Molnar wrote:
> > > > 
> > > > * Fenghua Yu <fenghua.yu@intel.com> wrote:
> > > > 
> > > > > On Thu, Apr 25, 2019 at 07:45:11AM +0200, Ingo Molnar wrote:
> > > > > > 
> > > > > > * Fenghua Yu <fenghua.yu@intel.com> wrote:
> > > > > > 
> > > > > > > A new MSR_IA32_CORE_CAPABILITY (0xcf) is defined. Each bit in the MSR
> > > > > > > enumerates a model specific feature. Currently bit 5 enumerates split
> > > > > > > lock detection. When bit 5 is 1, split lock detection is supported.
> > > > > > > When the bit is 0, split lock detection is not supported.
> > > > > > > 
> > > > > > > Please check the latest Intel 64 and IA-32 Architectures Software
> > > > > > > Developer's Manual for more detailed information on the MSR and the
> > > > > > > split lock detection bit.
> > > > > > > 
> > > > > > > Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> > > > > > > ---
> > > > > > >  arch/x86/include/asm/msr-index.h | 3 +++
> > > > > > >  1 file changed, 3 insertions(+)
> > > > > > > 
> > > > > > > diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> > > > > > > index ca5bc0eacb95..f65ef6f783d2 100644
> > > > > > > --- a/arch/x86/include/asm/msr-index.h
> > > > > > > +++ b/arch/x86/include/asm/msr-index.h
> > > > > > > @@ -59,6 +59,9 @@
> > > > > > >  #define MSR_PLATFORM_INFO_CPUID_FAULT_BIT	31
> > > > > > >  #define MSR_PLATFORM_INFO_CPUID_FAULT		BIT_ULL(MSR_PLATFORM_INFO_CPUID_FAULT_BIT)
> > > > > > >  
> > > > > > > +#define MSR_IA32_CORE_CAPABILITY	0x000000cf
> > > > > > > +#define CORE_CAP_SPLIT_LOCK_DETECT	BIT(5)     /* Detect split lock */
> > > > > > 
> > > > > > Please don't put comments into definitions.
> > > > > 
> > > > > I'll remove the comment and change definitions of the MSR and the split lock
> > > > > detection bit as following:
> > > > > 
> > > > > +#define MSR_IA32_CORE_CAPABILITY                       0x000000cf
> > > > > +#define MSR_IA32_CORE_CAPABILITY_SPLIT_LOCK_DETECT_BIT 5
> > > > > +#define MSR_IA32_CORE_CAPABILITY_SPLIT_LOCK_DETECT     BIT(MSR_IA32_CORE_CAPABILITY_SPLIT_LOCK_DETECT_BIT)
> > > > > 
> > > > > Are these right changes?
> > > > 
> > > > I suspect it could be shortened to CORE_CAP as you (partly) did it 
> > > > originally.
> > > 
> > > IA32_CORE_CAPABILITY is the MSR's exact name in the latest SDM (in Table 2-14):
> > > https://software.intel.com/en-us/download/intel-64-and-ia-32-architectures-sdm-combined-volumes-1-2a-2b-2c-2d-3a-3b-3c-3d-and-4
> > > 
> > > So can I define the MSR and the bits as follows?
> > > 
> > > +#define MSR_IA32_CORE_CAP                       0x000000cf
> > > +#define MSR_IA32_CORE_CAP_SPLIT_LOCK_DETECT_BIT 5
> > > +#define MSR_IA32_CORE_CAP_SPLIT_LOCK_DETECT     BIT(MSR_IA32_CORE_CAP_SPLIT_LOCK_DETECT_BIT)
> > 
> > Yeah, I suppose that looks OK.
> 
> Should I also change the feature definition 'X86_FEATURE_CORE_CAPABILITY' to
> 'X86_FEATURE_CORE_CAP' in cpufeatures.h in patch #0006 to match the
> MSR definition here? Or should I still keep the current feature definition?
> 
> Thanks.

Hm, no, for CPU features it's good to follow the vendor convention.

So I guess the long-form CPU_CAPABILITY for all of these is the best 
after all.

Thanks,

	Ingo
