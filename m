Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72BEFC10F0C
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 17:32:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 440C820820
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 17:32:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729251AbfDDRcR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 13:32:17 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:46114 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727562AbfDDRcR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 13:32:17 -0400
Received: from p5492e2fc.dip0.t-ipconnect.de ([84.146.226.252] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hC6DY-00074s-FU; Thu, 04 Apr 2019 19:32:00 +0200
Date:   Thu, 4 Apr 2019 19:31:59 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Fenghua Yu <fenghua.yu@intel.com>
cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
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
In-Reply-To: <1554326526-172295-11-git-send-email-fenghua.yu@intel.com>
Message-ID: <alpine.DEB.2.21.1904041921460.1802@nanos.tec.linutronix.de>
References: <1554326526-172295-1-git-send-email-fenghua.yu@intel.com> <1554326526-172295-11-git-send-email-fenghua.yu@intel.com>
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

On Wed, 3 Apr 2019, Fenghua Yu wrote:
> +dotraplinkage void do_alignment_check(struct pt_regs *regs, long error_code)
> +{
> +	unsigned int trapnr = X86_TRAP_AC;
> +	char str[] = "alignment check";
> +	int signr = SIGBUS;
> +
> +	RCU_LOCKDEP_WARN(!rcu_is_watching(), "entry code didn't wake RCU");
> +
> +	/*
> +	 * WARN*()s end up here; fix them up before we call the
> +	 * notifier chain.
> +	 */

How exactly is WARN*() ending up here?

> +	if (!user_mode(regs) && fixup_bug(regs, trapnr))

And that fixup_bug() check does what?

int fixup_bug(struct pt_regs *regs, int trapnr)
{
 	if (trapnr != X86_TRAP_UD)
                return 0;

Copy and paste from do_error_trap() ....

> +		return;
> +
> +	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr) ==
> +		       NOTIFY_STOP)
> +		return;
> +
> +	cond_local_irq_enable(regs);
> +	if (!user_mode(regs) &&
> +	    static_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT)) {
> +		/*
> +		 * Only split lock can generate #AC from kernel at this point.
> +		 * Warn and disable split lock detection on this CPU. The
> +		 * faulting instruction will be executed without generating
> +		 * another #AC fault. User needs to check the warning and
> +		 * fix the split lock issue in the faulting instruction.

  "User needs to check the warning and fix the issue ..."

I'm looking forward to all the fixes from Joe Users.

Please remove that sentence. It's useless. Users report warnings if at all
and the kernel developers who actually look at them surely don't need an
advice like that.

Thanks,

	tglx
