Return-Path: <SRS0=x8ok=SU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B5CFC10F0B
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 06:32:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4AB03214DA
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 06:32:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388112AbfDRGcJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Apr 2019 02:32:09 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:60415 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388011AbfDRGcJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Apr 2019 02:32:09 -0400
Received: from pd9ef12d2.dip0.t-ipconnect.de ([217.239.18.210] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hH0aQ-0006tR-2u; Thu, 18 Apr 2019 08:31:54 +0200
Date:   Thu, 18 Apr 2019 08:31:52 +0200 (CEST)
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
Subject: Re: [PATCH v7 10/21] x86/split_lock: Define per CPU variable to
 cache MSR TEST_CTL
In-Reply-To: <20190418012848.GC18776@romley-ivt3.sc.intel.com>
Message-ID: <alpine.DEB.2.21.1904180827440.3174@nanos.tec.linutronix.de>
References: <1555536851-17462-1-git-send-email-fenghua.yu@intel.com> <1555536851-17462-11-git-send-email-fenghua.yu@intel.com> <alpine.DEB.2.21.1904180009200.3174@nanos.tec.linutronix.de> <20190418012848.GC18776@romley-ivt3.sc.intel.com>
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

On Wed, 17 Apr 2019, Fenghua Yu wrote:
> On Thu, Apr 18, 2019 at 12:14:12AM +0200, Thomas Gleixner wrote:
> > On Wed, 17 Apr 2019, Fenghua Yu wrote:
> > > +DEFINE_PER_CPU(u64, msr_test_ctl_cache);
> > > +EXPORT_PER_CPU_SYMBOL_GPL(msr_test_ctl_cache);
> > 
> > Contrary to things like cpufeatures or MSR bits, it's pretty useless to
> > have a separate patch for this. Please fold this into the place which
> > actualy uses it.
> 
> Can I fold this patch into the KVM patch 0013 which first uses (reads) the
> variable? But the variable will be set in later patches when enabling split
> lock feature (patch 0014) and when enabling/disabling split lock feature
> (patch 0015).
> 
> Is this a right sequence to fit the variable in the patch set?

As I said in the other reply, you are assuming that the content of that MSR
is 0. Which might be true now, but is that true in a year from now?

So you really want to at least initialize the variable by reading the MSR
_before_ you make use of it in KVM.

Thanks,

	tglx
