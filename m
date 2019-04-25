Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 168EAC10F03
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 06:21:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAF25217FA
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 06:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1556173297;
	bh=KzsvbSXtAZglpSiDkrawF7Fgm7iL1cJUnwlavfuuukE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=B4CpEURhnOJgLz48gcazh7PZASLMbNSMPqh1FyAmyJlnMYeOsb0D7kTJCmuXnfyoy
	 BKVswV4Fdcgs1tWMBLhd8TN3Q+ZDArBfER86oD0DhDZJzxWhUCq26WfWYA9CUO7VAM
	 jOS9ZjMBR+dwMrOtYKDvydP/LOoDLPKsNISqScjo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729541AbfDYGVc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 02:21:32 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45889 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbfDYGVc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 02:21:32 -0400
Received: by mail-wr1-f67.google.com with SMTP id s15so28501894wra.12;
        Wed, 24 Apr 2019 23:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=m1pgCWwdqyKknkvAF6L18eDp6l+cHvclRUpF4alMIQ8=;
        b=sq+n4RvUQfMkHKkvmbvcgayveNf0gikTUAwNyo3QwzL28LMMerFXkHtNVDkIFlCtCv
         VKx+pUOnLZ3+kwlKbd0SCzsIUQT/7NU5tzhH9PGlG0Ef00lB3lQzPE53CrzZesmZnxin
         SO4uvXQB6Pn0GdjUprGo/6srOedDddRyDuLxYRJlN6mA2uWjdXq5ghreRpXsJ9CVHUwB
         lSw3lKWwKLwY755Q50Lu2n6Twz+MvfFgOimXhvEh9ptaEj0AiV9GE2AWBDmZShuJmy5N
         1hjGJfTAPM+fj1hSuD0h96u0qHZqa/rW8sKx3lLWmjKay3zG/n8dCN4bj1IZtWHYJwKi
         A+TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=m1pgCWwdqyKknkvAF6L18eDp6l+cHvclRUpF4alMIQ8=;
        b=nuOGhbemwvPxTp6OCe/7xBUGPTrelerpSjoN0S19ZdxkvfhoiKvaeLvMo4iqDEDNLA
         x8D4art+LSjrOLlb+CeUTzLwm0P4Q/EIQ9IeKFOx01cCVwCjiYRHcsK8jDJjqWFB4W2K
         89ntyfIpGmlhYmB6sjPK+zv/YiSAtAxTCL27TaxszBZIJ4/0f5jd549hJXSCt1qPj7hu
         FJjAztO3P1ZmaUbrBt8ENaWBq5+JuavfauWH0EgL475rBrbJvJOu2P8FGFunn1+qOb7S
         DEsG4g+mhjktr/oRZgVTGFK8Ms9aUjIRUs2i55yw8rsk3o24FziFSqJ+e9kUApzF0XwG
         eKsw==
X-Gm-Message-State: APjAAAW3kFJApQtW9ax0yL9rYVUydL8WL5Ulk71sWTdcH7LhDLTpwQxn
        oG2QlihQYZqlhyXSxj4m84w=
X-Google-Smtp-Source: APXvYqykn3Y2vZe4/tStgGa9wNbHWAH22+vzkdT8zFMp5ejn62iMa5ZEzClCuRFxrP0yEVO1smILZQ==
X-Received: by 2002:a5d:4a4f:: with SMTP id v15mr23278639wrs.5.1556173290027;
        Wed, 24 Apr 2019 23:21:30 -0700 (PDT)
Received: from gmail.com (2E8B0CD5.catv.pool.telekom.hu. [46.139.12.213])
        by smtp.gmail.com with ESMTPSA id x192sm33789071wmf.48.2019.04.24.23.21.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 24 Apr 2019 23:21:29 -0700 (PDT)
Date:   Thu, 25 Apr 2019 08:21:26 +0200
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
Subject: Re: [PATCH v8 09/15] x86/split_lock: Define MSR TEST_CTL register
Message-ID: <20190425062126.GC40105@gmail.com>
References: <1556134382-58814-1-git-send-email-fenghua.yu@intel.com>
 <1556134382-58814-10-git-send-email-fenghua.yu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1556134382-58814-10-git-send-email-fenghua.yu@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


* Fenghua Yu <fenghua.yu@intel.com> wrote:

> Setting bit 29 in MSR TEST_CTL (0x33) enables split lock detection and
> clearing the bit disables split lock detection.
> 
> Define the MSR and the bit. The definitions will be used in enabling or
> disabling split lock detection.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  arch/x86/include/asm/msr-index.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index f65ef6f783d2..296eeb761ab6 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -39,6 +39,10 @@
>  
>  /* Intel MSRs. Some also available on other CPUs */
>  
> +#define MSR_TEST_CTL				0x00000033
> +#define TEST_CTL_SPLIT_LOCK_DETECT_SHIFT	29
> +#define TEST_CTL_SPLIT_LOCK_DETECT		BIT(29)

Three problems:

 - Is MSR_TEST_CTL is not really a canonical MSR name... A quick look at 
   msr-index reveals the prevailing nomenclature:

     dagon:~/tip> git grep -h 'define MSR' arch/x86/include/asm/msr-index.h | cut -d_ -f1-2 | sort -n | uniq -c | sort -n | tail -10
       8 #define MSR_K8
       8 #define MSR_MTRRfix4K
      12 #define MSR_CORE
      13 #define MSR_IDT
      14 #define MSR_K7
      16 #define MSR_PKG
      19 #define MSR_F15H
      33 #define MSR_AMD64
      83 #define MSR_P4
     163 #define MSR_IA32

   I.e. this shouldn't this be something like MSR_IA32_TEST_CTL - or this 
   the name the Intel SDM uses? (I haven't checked.)

 - The canonical way to define MSR capabilities is to use the MSR's name 
   as a prefix. I.e.:

        MSR_TEST_CTL
        MSR_TEST_CTL_SPLIT_LOCK_DETECT_BIT
        MSR_TEST_CTL_SPLIT_LOCK_DETECT
        etc.

   Instead of the random mixture of MSR_ prefixed and non-prefixed 
   MSR_TEST_CTL, TEST_CTL_SPLIT_LOCK_DETECT_SHIFT and 
   TEST_CTL_SPLIT_LOCK_DETECT names.

 - Finally, this is not how we define bits - the _SHIFT postfix is actively
   confusing as we usually denote _SHIFT values with something that is 
   used in a bit-shift operation, which this isn't. Instead the proper 
   scheme is to postfix the bit number with _BIT and the mask with _MASK, 
   i.e. something like:

     #define MSR_TEST_CTL				0x00000033
     #define MSR_TEST_CTL_SPLIT_LOCK_DETECT_BIT		29
     #define MSR_TEST_CTL_SPLIT_LOCK_DETECT		BIT(MSR_TEST_CTL_SPLIT_LOCK_DETECT_BIT)

Note how this cleans up actual usage:

+       msr_set_bit(MSR_TEST_CTL, TEST_CTL_SPLIT_LOCK_DETECT_SHIFT);
+       this_cpu_or(msr_test_ctl_cache, TEST_CTL_SPLIT_LOCK_DETECT);

-       msr_set_bit(MSR_TEST_CTL, MSR_TEST_CTL_SPLIT_LOCK_DETECT_BIT);
-       this_cpu_or(msr_test_ctl_cache, MSR_TEST_CTL_SPLIT_LOCK_DETECT);

Frankly, this kind of disorganized code in a v8 submission is *really* 
disappointing, it's not like it's hard to look up these patterns and 
practices in existing code...

Sigh.

Thanks,

	Ingo
