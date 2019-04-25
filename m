Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 418A1C282E1
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 05:45:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1134D214AE
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 05:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1556171123;
	bh=V+b/so+sZsVXPKQeDtpqs6sSPOg8/aM7G0jRwTbNdz8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=EzR6mCiYUJJMNciZR1xnsYE5AVQUihuu2r1lwYQBT0mIGDFpJ0FPUvQ4h2yqTcVWP
	 k9zfVsOsJyB+1AxCDSH4RINyaxoAWfoWytUe2H1YYhkFFla4PCGEApzgqIKeooGARL
	 dndw1phMSz7Qpl8mIBmOVt7St7GI/kgA6x/ilSlk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729260AbfDYFpR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 01:45:17 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55580 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729142AbfDYFpQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 01:45:16 -0400
Received: by mail-wm1-f65.google.com with SMTP id o25so7529663wmf.5;
        Wed, 24 Apr 2019 22:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9uqPrEQds0aNv6yEhiL8/SAPurZ/yreHvYYE50OdvHc=;
        b=maRasgHGI5S/05fW8nfwWtbnJSfcK9QRa6angxc9KH52v0ZK3VJ7Ap6O/BkBIh9DbD
         BoMkZDpSWecCvM9tAehQo6zgdxmA6V6Oru4uIj/sdx+AaJFC6p/7F65Cadh2NnBBpjj5
         3eFwaAUucsT2sYBXx6h/LE4y4X+SSGotaUYbAUI3SUFuqGtQ4471UwpS5IAw8m6f8RHG
         ZU3fCYKfGElNGcQSGE0wVvFirY3Rr4gLaf262tBDszkxtL55oc8frK+AT/DOadwz/8Qg
         6pMLhQZG1V7mTkQ60wc/EA76r17J0IuNywrIISKUP610U+ME99s/0SqLIU+cW7Iay4yq
         cHMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=9uqPrEQds0aNv6yEhiL8/SAPurZ/yreHvYYE50OdvHc=;
        b=IRkswcwiS1yTh7sfljQ8u17fQ3gWR106q+GNOyS91gdH8gsCcECLybzGZ2o76IVqgo
         N4P+BcmkAbKtiGHAkS2z+f09LJe45D7KPX/hE1ujXgJolzrvfSLBE4J/AZB3IA1z8ot+
         6QLVKuAh2oHeULDNvku5K+buad1pQpErnncrAUqdkpTdKanVZd49SQpETXuyEy9MX2f3
         m8798+RRACpw/gSUy4paaCYgvg1XhjBT7iWgPM5Keg/7n7S4dh3GBfx0AFlf98EfwpKZ
         ebEN/tBYjXow0KWrVFeLZzbMrTf2Gn7HbPCglHaR24RZJgTX+jTpKohWdQmvk+4VqIOD
         LZKQ==
X-Gm-Message-State: APjAAAVp4stimZMcqxtTyHJcyu5xuKoDlHZfz8ay/CG6geUSWxKe0PAr
        bF5jWx4EeCjiEdVP8cFkDrw=
X-Google-Smtp-Source: APXvYqzGLahICBotJhHu7lXO3DMHu7rDywtX7C0MIT+nuc7I1SFuiY8RqtTIRe5eVbCMRq/MHGVndQ==
X-Received: by 2002:a7b:c408:: with SMTP id k8mr1991798wmi.69.1556171114208;
        Wed, 24 Apr 2019 22:45:14 -0700 (PDT)
Received: from gmail.com (2E8B0CD5.catv.pool.telekom.hu. [46.139.12.213])
        by smtp.gmail.com with ESMTPSA id z74sm31904242wmc.2.2019.04.24.22.45.12
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 24 Apr 2019 22:45:13 -0700 (PDT)
Date:   Thu, 25 Apr 2019 07:45:11 +0200
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
Message-ID: <20190425054511.GA40105@gmail.com>
References: <1556134382-58814-1-git-send-email-fenghua.yu@intel.com>
 <1556134382-58814-6-git-send-email-fenghua.yu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1556134382-58814-6-git-send-email-fenghua.yu@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


* Fenghua Yu <fenghua.yu@intel.com> wrote:

> A new MSR_IA32_CORE_CAPABILITY (0xcf) is defined. Each bit in the MSR
> enumerates a model specific feature. Currently bit 5 enumerates split
> lock detection. When bit 5 is 1, split lock detection is supported.
> When the bit is 0, split lock detection is not supported.
> 
> Please check the latest Intel 64 and IA-32 Architectures Software
> Developer's Manual for more detailed information on the MSR and the
> split lock detection bit.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  arch/x86/include/asm/msr-index.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index ca5bc0eacb95..f65ef6f783d2 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -59,6 +59,9 @@
>  #define MSR_PLATFORM_INFO_CPUID_FAULT_BIT	31
>  #define MSR_PLATFORM_INFO_CPUID_FAULT		BIT_ULL(MSR_PLATFORM_INFO_CPUID_FAULT_BIT)
>  
> +#define MSR_IA32_CORE_CAPABILITY	0x000000cf
> +#define CORE_CAP_SPLIT_LOCK_DETECT	BIT(5)     /* Detect split lock */

Please don't put comments into definitions.

Thanks,

	Ingo
