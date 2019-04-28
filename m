Return-Path: <SRS0=6X5c=S6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DA57C43219
	for <linux-wireless@archiver.kernel.org>; Sun, 28 Apr 2019 07:10:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5676D20881
	for <linux-wireless@archiver.kernel.org>; Sun, 28 Apr 2019 07:10:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfD1HJy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 28 Apr 2019 03:09:54 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:38543 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbfD1HJx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 28 Apr 2019 03:09:53 -0400
Received: from p5de0b374.dip0.t-ipconnect.de ([93.224.179.116] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hKdwK-0006lx-VI; Sun, 28 Apr 2019 09:09:33 +0200
Date:   Sun, 28 Apr 2019 09:09:24 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Xiaoyao Li <xiaoyao.li@linux.intel.com>
cc:     Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, H Peter Anvin <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        Christopherson Sean J <sean.j.christopherson@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Michael Chan <michael.chan@broadcom.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v8 12/15] kvm/vmx: Emulate MSR TEST_CTL
In-Reply-To: <7395908840acfbf806146f5f20d3509342771a19.camel@linux.intel.com>
Message-ID: <alpine.DEB.2.21.1904280903520.1757@nanos.tec.linutronix.de>
References: <1556134382-58814-1-git-send-email-fenghua.yu@intel.com>  <1556134382-58814-13-git-send-email-fenghua.yu@intel.com>  <alpine.DEB.2.21.1904250931020.1762@nanos.tec.linutronix.de> <7395908840acfbf806146f5f20d3509342771a19.camel@linux.intel.com>
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

On Sat, 27 Apr 2019, Xiaoyao Li wrote:
> On Thu, 2019-04-25 at 09:42 +0200, Thomas Gleixner wrote:
> > On Wed, 24 Apr 2019, Fenghua Yu wrote:
> > >  
> > > +static void atomic_switch_msr_test_ctl(struct vcpu_vmx *vmx)
> > > +{
> > > +	u64 host_msr_test_ctl;
> > > +
> > > +	if (!boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT))
> > > +		return;
> > 
> > Again: MSR_TST_CTL is not only about LOCK_DETECT. Check the control mask.
> > 
> > > +	host_msr_test_ctl = this_cpu_read(msr_test_ctl_cache);
> > > +
> > > +	if (host_msr_test_ctl == vmx->msr_test_ctl) {
> > 
> > This still assumes that the only bit which can be set in the MSR is that
> > lock detect bit.
> > 
> > > +		clear_atomic_switch_msr(vmx, MSR_TEST_CTL);
> > > +	} else {
> > > +		add_atomic_switch_msr(vmx, MSR_TEST_CTL, vmx->msr_test_ctl,
> > > +				      host_msr_test_ctl, false);
> > 
> > So what happens here is that if any other bit is set on the host, VMENTER
> > will happily clear it.
> 
> There are two bits of MSR TEST_CTL defined in Intel SDM now, which is bit
> 29 and bit 31. Bit 31 is not used in kernel, and here we only need to
> switch bit 29 between host and guest.  So should I also change the name
> to atomic_switch_split_lock_detect() to indicate that we only switch bit
> 29?

No. Just because we ony use the split lock bit now, there is no
jusification to name everything splitlock. This is going to have renamed
when yet another bit is added in the future. The MSR is exposed to the
guest and the restriction of bits happens to be splitlock today.

> >      guest = (host & ~vmx->test_ctl_mask) | vmx->test_ctl;
> > 
> > That preserves any bits which are not exposed to the guest.
> > 
> > But the way more interesting question is why are you exposing the MSR and
> > the bit to the guest at all if the host has split lock detection enabled?
> > 
> > That does not make any sense as you basically allow the guest to switch it
> > off and then launch a slowdown attack. If the host has it enabled, then a
> > guest has to be treated like any other process and the #AC trap has to be
> > caught by the hypervisor which then kills the guest.
> > 
> > Only if the host has split lock detection disabled, then you can expose it
> > and allow the guest to turn it on and handle it on its own.
> 
> Indeed, if we use split lock detection for protection purpose, when host
> has it enabled we should directly pass it to guest and forbid guest from
> disabling it.  And only when host disables split lock detection, we can
> expose it and allow the guest to turn it on.
?
> If it is used for protection purpose, then it should follow what you said and
> this feature needs to be disabled by default. Because there are split lock
> issues in old/current kernels and BIOS. That will cause the existing guest
> booting failure and killed due to those split lock.

Rightfully so.

> If it is only used for debug purpose, I think it might be OK to enable this
> feature by default and make it indepedent between host and guest?

No. It does not make sense.

> So I think how to handle this feature between host and guest depends on how we
> use it? Once you give me a decision, I will follow it in next version.

As I said: The host kernel makes the decision.

If the host kernel has it enabled then the guest is not allowed to change
it. If the guest triggers an #AC it will be killed.

If the host kernel has it disabled then the guest can enable it for it's
own purposes.

Thanks,

	tglx
