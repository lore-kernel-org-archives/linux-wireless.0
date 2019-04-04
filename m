Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC2FCC4360F
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 22:57:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6D6F2177E
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 22:57:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730517AbfDDW4z (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 18:56:55 -0400
Received: from mga14.intel.com ([192.55.52.115]:55973 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729009AbfDDW4y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 18:56:54 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Apr 2019 15:56:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,309,1549958400"; 
   d="scan'208";a="128734818"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by orsmga007.jf.intel.com with ESMTP; 04 Apr 2019 15:56:53 -0700
Date:   Thu, 4 Apr 2019 15:49:13 -0700
From:   Fenghua Yu <fenghua.yu@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        H Peter Anvin <hpa@zytor.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v6 10/20] x86/split_lock: Handle #AC exception for split
 lock
Message-ID: <20190404224913.GB178488@romley-ivt3.sc.intel.com>
References: <1554326526-172295-1-git-send-email-fenghua.yu@intel.com>
 <1554326526-172295-11-git-send-email-fenghua.yu@intel.com>
 <alpine.DEB.2.21.1904041921460.1802@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1904041921460.1802@nanos.tec.linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Apr 04, 2019 at 07:31:59PM +0200, Thomas Gleixner wrote:
> On Wed, 3 Apr 2019, Fenghua Yu wrote:
> > +dotraplinkage void do_alignment_check(struct pt_regs *regs, long error_code)
> > +{
> > +	unsigned int trapnr = X86_TRAP_AC;
> > +	char str[] = "alignment check";
> > +	int signr = SIGBUS;
> > +
> > +	RCU_LOCKDEP_WARN(!rcu_is_watching(), "entry code didn't wake RCU");
> > +
> > +	/*
> > +	 * WARN*()s end up here; fix them up before we call the
> > +	 * notifier chain.
> > +	 */
> 
> How exactly is WARN*() ending up here?
> 
> > +	if (!user_mode(regs) && fixup_bug(regs, trapnr))
> 
> And that fixup_bug() check does what?
> 
> int fixup_bug(struct pt_regs *regs, int trapnr)
> {
>  	if (trapnr != X86_TRAP_UD)
>                 return 0;
> 
> Copy and paste from do_error_trap() ....

As you can see, do_alignment_check() is copied from do_error_trap().
But seems this part of code is irrelevant to #AC handler.

So I will remove the "if (!user_mode(regs) && fixup_bug(regs, trapnr))"
and surrounding code, right?

> 
> > +		return;
> > +
> > +	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr) ==
> > +		       NOTIFY_STOP)
> > +		return;
> > +
> > +	cond_local_irq_enable(regs);
> > +	if (!user_mode(regs) &&
> > +	    static_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT)) {
> > +		/*
> > +		 * Only split lock can generate #AC from kernel at this point.
> > +		 * Warn and disable split lock detection on this CPU. The
> > +		 * faulting instruction will be executed without generating
> > +		 * another #AC fault. User needs to check the warning and
> > +		 * fix the split lock issue in the faulting instruction.
> 
>   "User needs to check the warning and fix the issue ..."
> 
> I'm looking forward to all the fixes from Joe Users.
> 
> Please remove that sentence. It's useless. Users report warnings if at all
> and the kernel developers who actually look at them surely don't need an
> advice like that.

Sure. Will do this.

Thanks.

-Fenghua
