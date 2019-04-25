Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7387C282E3
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 07:42:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4B91217D7
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 07:42:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbfDYHmS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 03:42:18 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:56675 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbfDYHmS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 03:42:18 -0400
Received: from p5de0b374.dip0.t-ipconnect.de ([93.224.179.116] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hJZ1B-00075o-PK; Thu, 25 Apr 2019 09:42:05 +0200
Date:   Thu, 25 Apr 2019 09:42:04 +0200 (CEST)
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
Subject: Re: [PATCH v8 12/15] kvm/vmx: Emulate MSR TEST_CTL
In-Reply-To: <1556134382-58814-13-git-send-email-fenghua.yu@intel.com>
Message-ID: <alpine.DEB.2.21.1904250931020.1762@nanos.tec.linutronix.de>
References: <1556134382-58814-1-git-send-email-fenghua.yu@intel.com> <1556134382-58814-13-git-send-email-fenghua.yu@intel.com>
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
> +static void atomic_switch_msr_test_ctl(struct vcpu_vmx *vmx)
> +{
> +	u64 host_msr_test_ctl;
> +
> +	if (!boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT))
> +		return;

Again: MSR_TST_CTL is not only about LOCK_DETECT. Check the control mask.

> +	host_msr_test_ctl = this_cpu_read(msr_test_ctl_cache);
> +
> +	if (host_msr_test_ctl == vmx->msr_test_ctl) {

This still assumes that the only bit which can be set in the MSR is that
lock detect bit.

> +		clear_atomic_switch_msr(vmx, MSR_TEST_CTL);
> +	} else {
> +		add_atomic_switch_msr(vmx, MSR_TEST_CTL, vmx->msr_test_ctl,
> +				      host_msr_test_ctl, false);

So what happens here is that if any other bit is set on the host, VMENTER
will happily clear it.

     guest = (host & ~vmx->test_ctl_mask) | vmx->test_ctl;

That preserves any bits which are not exposed to the guest.

But the way more interesting question is why are you exposing the MSR and
the bit to the guest at all if the host has split lock detection enabled?

That does not make any sense as you basically allow the guest to switch it
off and then launch a slowdown attack. If the host has it enabled, then a
guest has to be treated like any other process and the #AC trap has to be
caught by the hypervisor which then kills the guest.

Only if the host has split lock detection disabled, then you can expose it
and allow the guest to turn it on and handle it on its own.

Thanks,

	tglx


