Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E717C282E1
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 07:50:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5BFBF217D7
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 07:50:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728125AbfDYHuc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 03:50:32 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:56722 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728089AbfDYHub (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 03:50:31 -0400
Received: from p5de0b374.dip0.t-ipconnect.de ([93.224.179.116] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hJZ9B-0007Ip-WE; Thu, 25 Apr 2019 09:50:22 +0200
Date:   Thu, 25 Apr 2019 09:50:20 +0200 (CEST)
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
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v8 13/15] x86/split_lock: Enable split lock detection by
 default
In-Reply-To: <1556134382-58814-14-git-send-email-fenghua.yu@intel.com>
Message-ID: <alpine.DEB.2.21.1904250943160.1762@nanos.tec.linutronix.de>
References: <1556134382-58814-1-git-send-email-fenghua.yu@intel.com> <1556134382-58814-14-git-send-email-fenghua.yu@intel.com>
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

On Wed, 24 Apr 2019, Fenghua Yu wrote:
>  
> +static void split_lock_update_msr(void)
> +{
> +	/* Enable split lock detection */
> +	msr_set_bit(MSR_TEST_CTL, TEST_CTL_SPLIT_LOCK_DETECT_SHIFT);
> +	this_cpu_or(msr_test_ctl_cache, TEST_CTL_SPLIT_LOCK_DETECT);

I'm pretty sure, that I told you to utilize the cache proper. Again:

> > Nothing in this file initializes msr_test_ctl_cache explicitely. Register
> > caching always requires to read the register and store it in the cache
> > before doing anything with it. Nothing guarantees that all bits in that MSR
> > are 0 by default forever.
> >
> > And once you do that _before_ calling split_lock_update_msr() then you can
> > spare the RMW in that function.

So you managed to fix the initializaiton part, but then you still do a
pointless RMW.

Thanks,

	tglx
