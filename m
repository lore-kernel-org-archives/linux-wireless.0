Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 815CEC43219
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 19:47:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A83C206BF
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 19:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1556221645;
	bh=rbgSt1Z/AZYaF31m0DDwCoq42ppzgpseqxIMx2mDntk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Lwo6qDZ2oAS5/EfffsRQwfeUx/vthDwCiUEK61r1m6AYg/Ee5WsbaiDxwH1KGf0tW
	 JyANsdKiW/Do9i5LF30PQcwQakZAwEXCxDzW6q4uhft7n7rgQLXCnnoSKBGsuteaDR
	 UFEy8Y7ZMqfAWduBdRTrkaaJRKW3QXvudgXIKV3A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387547AbfDYTrT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 15:47:19 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41659 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726086AbfDYTrT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 15:47:19 -0400
Received: by mail-wr1-f65.google.com with SMTP id c12so998010wrt.8;
        Thu, 25 Apr 2019 12:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ydDrHuDhZXJBmgP1xmnm9CGqwfa2HZ/by3+G5Gc/qz8=;
        b=FQdjsNNesEsS+R16FOsavmXeWEvpkdaR8uvYQPZhi5Fguc4QyUht7xG4qkcysn0ZTC
         E1MYLGYj+P8Cvu5r472c5/ZuiCA0SpOSjrMwUzIsBHG3eYdLYiwhhv0eaToYzInEs7dn
         JWPvAvLHCEaBR71XfJluuTyaBqYC60oYg+ZDILBDt2AwHQcMqPHLkgSVEk8aPEdoj+AA
         E1UdAGKxpV+HAIePZ89lsNl85sTx6fGsSexiJ4sswSboxg9Lg8pkwuaP0B+jJa1QmwUp
         e+s8J2wRJo4kMW79Fh2CrH9WzevN+RGZlxJl15hj1HUhnDqKA1XpyXNnLRG6ihZHWWaV
         g+XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=ydDrHuDhZXJBmgP1xmnm9CGqwfa2HZ/by3+G5Gc/qz8=;
        b=KAtyW51e3fW2sMDnEXNkEHx4jZqINP808RAmapxvXcZANziFj2Hzs5AqYFwcQ+b3Ct
         ts3Bm0Cf715lZmPa5hhzjsmxHrapIlW7Iooi4BcywFZm2sMnVFX9Hb4soEAxTG1dkmJ6
         0VdBL9qdMXNWeA+AtaQwB1QWQe28OWmnoid4soPgABM8gBGCMb+Zhd+sut0VIp/+x3Up
         6gj3HlpKAs1uol05i5pFmG0MVhN72GXFcef8AEo66k54pKYIAzuDrphKNL4NC362uKet
         jhRVJSuyGYQGPseIprEWEGz4BdxEvyki9cpSwWDRBdGSwxQ2XqzvtCY5Ihk43BGqeZRw
         Tgfg==
X-Gm-Message-State: APjAAAW1vuoaCHwcfz7RsB4//ua4/y+yNjJeZCFGjgfJQOq0n4A1T03I
        +IxD1+7z0qD9CH33GaKdz1g=
X-Google-Smtp-Source: APXvYqwh0niotys+kP44J79XSppHEpypwWfa7yKREdp/DHiSyfVh9/akqrFbPU64RzOVHr4z7vnDfQ==
X-Received: by 2002:adf:dc83:: with SMTP id r3mr8453910wrj.179.1556221637279;
        Thu, 25 Apr 2019 12:47:17 -0700 (PDT)
Received: from gmail.com (2E8B0CD5.catv.pool.telekom.hu. [46.139.12.213])
        by smtp.gmail.com with ESMTPSA id l21sm18779718wme.4.2019.04.25.12.47.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Apr 2019 12:47:16 -0700 (PDT)
Date:   Thu, 25 Apr 2019 21:47:14 +0200
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
Message-ID: <20190425194714.GA58719@gmail.com>
References: <1556134382-58814-1-git-send-email-fenghua.yu@intel.com>
 <1556134382-58814-6-git-send-email-fenghua.yu@intel.com>
 <20190425054511.GA40105@gmail.com>
 <20190425190148.GA64477@romley-ivt3.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190425190148.GA64477@romley-ivt3.sc.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


* Fenghua Yu <fenghua.yu@intel.com> wrote:

> On Thu, Apr 25, 2019 at 07:45:11AM +0200, Ingo Molnar wrote:
> > 
> > * Fenghua Yu <fenghua.yu@intel.com> wrote:
> > 
> > > A new MSR_IA32_CORE_CAPABILITY (0xcf) is defined. Each bit in the MSR
> > > enumerates a model specific feature. Currently bit 5 enumerates split
> > > lock detection. When bit 5 is 1, split lock detection is supported.
> > > When the bit is 0, split lock detection is not supported.
> > > 
> > > Please check the latest Intel 64 and IA-32 Architectures Software
> > > Developer's Manual for more detailed information on the MSR and the
> > > split lock detection bit.
> > > 
> > > Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> > > ---
> > >  arch/x86/include/asm/msr-index.h | 3 +++
> > >  1 file changed, 3 insertions(+)
> > > 
> > > diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> > > index ca5bc0eacb95..f65ef6f783d2 100644
> > > --- a/arch/x86/include/asm/msr-index.h
> > > +++ b/arch/x86/include/asm/msr-index.h
> > > @@ -59,6 +59,9 @@
> > >  #define MSR_PLATFORM_INFO_CPUID_FAULT_BIT	31
> > >  #define MSR_PLATFORM_INFO_CPUID_FAULT		BIT_ULL(MSR_PLATFORM_INFO_CPUID_FAULT_BIT)
> > >  
> > > +#define MSR_IA32_CORE_CAPABILITY	0x000000cf
> > > +#define CORE_CAP_SPLIT_LOCK_DETECT	BIT(5)     /* Detect split lock */
> > 
> > Please don't put comments into definitions.
> 
> I'll remove the comment and change definitions of the MSR and the split lock
> detection bit as following:
> 
> +#define MSR_IA32_CORE_CAPABILITY                       0x000000cf
> +#define MSR_IA32_CORE_CAPABILITY_SPLIT_LOCK_DETECT_BIT 5
> +#define MSR_IA32_CORE_CAPABILITY_SPLIT_LOCK_DETECT     BIT(MSR_IA32_CORE_CAPABILITY_SPLIT_LOCK_DETECT_BIT)
> 
> Are these right changes?

I suspect it could be shortened to CORE_CAP as you (partly) did it 
originally.

Thanks,

	Ingo
