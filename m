Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5E65C43218
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 20:08:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDE212077C
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 20:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1556222921;
	bh=uzSczh8XzmC2XLg0vK0G6uTfGy4q7m3vjPON3NW3GgQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=0rw3EppydJAwKLe/0p0KECC06n+JI24m+snaltfG5m8JBHfG2JZh77ELYs66Dxo9F
	 /z+zrK/hQ/qyhkOsD+IL374Q/yymKYZaTp1qsgXmRfZOBFH4/OwXHm3+DYl+QtzUeV
	 tLfcd8gi/AJ7/lOH3PoDXzu/ivZ4vfDj5s8QKsec=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730936AbfDYUIf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 16:08:35 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33833 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbfDYUIf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 16:08:35 -0400
Received: by mail-wr1-f65.google.com with SMTP id c6so1136256wrm.1;
        Thu, 25 Apr 2019 13:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WBnbVFANFIfD9f8rrLhwUFeR1tMxNsCqSPdIILY9NWg=;
        b=rAuZ+O4bIVhfGqTxMc3jl0Qwr9A62srmw34E3gaQBZINRzZfKKHKHgbbhZ5G/0hVjf
         aTGD0h9+fOLlGjsiKJKbqYZ1Cx2dRJTmQfVDClS18LGHWKA4NQh9UOliw4wm2v7C/mzG
         RmTPbWliVa21SF0Cq1rLJy7vJMwk41yGWah6PBcMgm/TrpSwsKjcy1C1FYl21zpGs4Q+
         ot4e1a5fVrom9Za7boz1sIFrI5wjV2K10E+ZU0I8k/NyIsGFoHNBs09b8ehZFb90Iyqp
         BNIZ9GRWoYZ4H7Z17c7U00Wp1x6ufMbjyfZGatdwGlMkjsej7lYTP+Kow31jFjLuL2QF
         qMIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=WBnbVFANFIfD9f8rrLhwUFeR1tMxNsCqSPdIILY9NWg=;
        b=oBLL08T0oLSmWBo03AZLEnFojyOwUi3S9gogiFKN0iiI0MF73f7G96MDXpRQLJ5coG
         EdihoA9BxY2S4t/k0ywpYiRr5ugL+zLdnfKgRJKmyebKndQhSL7F/LP5mf8AO/MljMPA
         P1HTA6HY7F4adPYfT6uJwuvX5ZNjk7ZKp/H+YrmxBaxmpNh0dH6SCkZosg9IELG+fa7B
         0MpceX0ApmA01+pIqR7Qkf5tEnwKNnJrjskiGz/5NdvBAmwUhStK3WtwNFKYzeysHWu+
         ZvyFlUZuh6D071T74lxpevBGAHstvmPBfR8Jzza79Lqy2sKjzQjy4qi3MH7VMjM9Lg42
         1f7g==
X-Gm-Message-State: APjAAAX4mwwvc+l6hc6LHjqu19r53mUng4PUOVKiFOPrN+9kI3lsJiJd
        CXgIg+rom921uUUz1uy4wfw=
X-Google-Smtp-Source: APXvYqyuWAz9nsWqrH+TMWwynP28WEQ2xkRxPt3lbCn576nJu+ycxBbXNR4Druxvz6IAyjujsXqdNg==
X-Received: by 2002:a5d:4111:: with SMTP id l17mr7407742wrp.242.1556222913401;
        Thu, 25 Apr 2019 13:08:33 -0700 (PDT)
Received: from gmail.com (2E8B0CD5.catv.pool.telekom.hu. [46.139.12.213])
        by smtp.gmail.com with ESMTPSA id y125sm34321470wmc.39.2019.04.25.13.08.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Apr 2019 13:08:32 -0700 (PDT)
Date:   Thu, 25 Apr 2019 22:08:30 +0200
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
Message-ID: <20190425200830.GD58719@gmail.com>
References: <1556134382-58814-1-git-send-email-fenghua.yu@intel.com>
 <1556134382-58814-6-git-send-email-fenghua.yu@intel.com>
 <20190425054511.GA40105@gmail.com>
 <20190425190148.GA64477@romley-ivt3.sc.intel.com>
 <20190425194714.GA58719@gmail.com>
 <20190425195154.GC64477@romley-ivt3.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190425195154.GC64477@romley-ivt3.sc.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


* Fenghua Yu <fenghua.yu@intel.com> wrote:

> On Thu, Apr 25, 2019 at 09:47:14PM +0200, Ingo Molnar wrote:
> > 
> > * Fenghua Yu <fenghua.yu@intel.com> wrote:
> > 
> > > On Thu, Apr 25, 2019 at 07:45:11AM +0200, Ingo Molnar wrote:
> > > > 
> > > > * Fenghua Yu <fenghua.yu@intel.com> wrote:
> > > > 
> > > > > A new MSR_IA32_CORE_CAPABILITY (0xcf) is defined. Each bit in the MSR
> > > > > enumerates a model specific feature. Currently bit 5 enumerates split
> > > > > lock detection. When bit 5 is 1, split lock detection is supported.
> > > > > When the bit is 0, split lock detection is not supported.
> > > > > 
> > > > > Please check the latest Intel 64 and IA-32 Architectures Software
> > > > > Developer's Manual for more detailed information on the MSR and the
> > > > > split lock detection bit.
> > > > > 
> > > > > Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> > > > > ---
> > > > >  arch/x86/include/asm/msr-index.h | 3 +++
> > > > >  1 file changed, 3 insertions(+)
> > > > > 
> > > > > diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> > > > > index ca5bc0eacb95..f65ef6f783d2 100644
> > > > > --- a/arch/x86/include/asm/msr-index.h
> > > > > +++ b/arch/x86/include/asm/msr-index.h
> > > > > @@ -59,6 +59,9 @@
> > > > >  #define MSR_PLATFORM_INFO_CPUID_FAULT_BIT	31
> > > > >  #define MSR_PLATFORM_INFO_CPUID_FAULT		BIT_ULL(MSR_PLATFORM_INFO_CPUID_FAULT_BIT)
> > > > >  
> > > > > +#define MSR_IA32_CORE_CAPABILITY	0x000000cf
> > > > > +#define CORE_CAP_SPLIT_LOCK_DETECT	BIT(5)     /* Detect split lock */
> > > > 
> > > > Please don't put comments into definitions.
> > > 
> > > I'll remove the comment and change definitions of the MSR and the split lock
> > > detection bit as following:
> > > 
> > > +#define MSR_IA32_CORE_CAPABILITY                       0x000000cf
> > > +#define MSR_IA32_CORE_CAPABILITY_SPLIT_LOCK_DETECT_BIT 5
> > > +#define MSR_IA32_CORE_CAPABILITY_SPLIT_LOCK_DETECT     BIT(MSR_IA32_CORE_CAPABILITY_SPLIT_LOCK_DETECT_BIT)
> > > 
> > > Are these right changes?
> > 
> > I suspect it could be shortened to CORE_CAP as you (partly) did it 
> > originally.
> 
> IA32_CORE_CAPABILITY is the MSR's exact name in the latest SDM (in Table 2-14):
> https://software.intel.com/en-us/download/intel-64-and-ia-32-architectures-sdm-combined-volumes-1-2a-2b-2c-2d-3a-3b-3c-3d-and-4
> 
> So can I define the MSR and the bits as follows?
> 
> +#define MSR_IA32_CORE_CAP                       0x000000cf
> +#define MSR_IA32_CORE_CAP_SPLIT_LOCK_DETECT_BIT 5
> +#define MSR_IA32_CORE_CAP_SPLIT_LOCK_DETECT     BIT(MSR_IA32_CORE_CAP_SPLIT_LOCK_DETECT_BIT)

Yeah, I suppose that looks OK.

Thanks,

	Ingo
