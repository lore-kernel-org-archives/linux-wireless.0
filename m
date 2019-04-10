Return-Path: <SRS0=qAu2=SM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF890C10F14
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 05:07:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6A2A218FD
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 05:07:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbfDJFHY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Apr 2019 01:07:24 -0400
Received: from mga05.intel.com ([192.55.52.43]:19538 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726826AbfDJFHY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Apr 2019 01:07:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Apr 2019 22:07:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,332,1549958400"; 
   d="scan'208";a="222112098"
Received: from lxy-dell.sh.intel.com ([10.239.159.145])
  by orsmga001.jf.intel.com with ESMTP; 09 Apr 2019 22:07:19 -0700
Message-ID: <9b16b5c5379eb6b5352de26e56b8064a6b6f1aa7.camel@linux.intel.com>
Subject: Re: [PATCH v6 12/20] kvm/vmx: Emulate MSR TEST_CTL
From:   Xiaoyao Li <xiaoyao.li@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        H Peter Anvin <hpa@zytor.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org
Date:   Wed, 10 Apr 2019 13:03:59 +0800
In-Reply-To: <20190408174805.GJ25880@linux.intel.com>
References: <1554326526-172295-1-git-send-email-fenghua.yu@intel.com>
         <1554326526-172295-13-git-send-email-fenghua.yu@intel.com>
         <alpine.DEB.2.21.1904051400230.1802@nanos.tec.linutronix.de>
         <423f329a8e194d799c6c41470266a04a9f90bc84.camel@linux.intel.com>
         <20190408174805.GJ25880@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2019-04-08 at 10:48 -0700, Sean Christopherson wrote:
> On Mon, Apr 08, 2019 at 05:54:25PM +0800, Xiaoyao Li wrote:
> > On Fri, 2019-04-05 at 14:30 +0200, Thomas Gleixner wrote:
> > > On Wed, 3 Apr 2019, Fenghua Yu wrote:
> > > > @@ -1663,6 +1663,12 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu,
> > > > struct
> > > > msr_data *msr_info)
> > > >  	u32 index;
> > > >  
> > > >  	switch (msr_info->index) {
> > > > +	case MSR_TEST_CTL:
> > > > +		if (!msr_info->host_initiated &&
> > > > +		    !(vcpu->arch.core_capability &
> > > > CORE_CAP_SPLIT_LOCK_DETECT))
> > > 
> > > Errm? If the MSR_TEST_CTL is exposed to the guest via CPUID then the
> > > rdmsr() in the guest is not supposed to fail just because
> > > CORE_CAP_SPLIT_LOCK_DETECT is not set.
> > 
> > you're right.
> > 
> > > vmx->msr_test_ctl holds the proper value, which is either 0 or
> > > CORE_CAP_SPLIT_LOCK_DETECT until more bits are supported.
> > > 
> > > So the chek needs to be guest_cpuid_has(X86_FEATURE_CORE_CAPABILITY).
> > 
> > I don't think so. There is no dependecy between
> > guest_cpuid_has(X86_FEATURE_CORE_CAPABILITY) and MSR_TEST_CTL.
> > guest_cpuid_has(X86_FEATURE_CORE_CAPABILITY) only indicates that guest has
> > MSR
> > CORE_CAPABILITY.
> > 
> > Due to the fact that MSR_TEST_CTL is emulated with vmx->msr_test_ctl. I
> > think it
> > 's ok to always let userspace or guest to read MSR_TEST_CTL, it just returns
> > the
> > emulated value. Like you said, " vmx->msr_test_ctl holds the proper value,
> > which
> > is either 0 or CORE_CAP_SPLIT_LOCK_DETECT until more bits are supported."
> 
> Assuming the next version implements "vmx->msr_test_ctl_mask", KVM should
> inject #GP if the guest attempts RDMSR(MSR_TEST_CTL) and the mask is zero.
> It stands to reason that a kernel can only reasonably assume the MSR exists
> if the (virtual) CPU supports at least one feature enabled via MSR_TEST_CTL.

It makes sense to me. Thanks for your reminder.
Will apply it in next version.

