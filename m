Return-Path: <SRS0=qAu2=SM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 231E1C10F11
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 06:31:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E61552084B
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 06:31:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727552AbfDJGbr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Apr 2019 02:31:47 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:57740 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726056AbfDJGbr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Apr 2019 02:31:47 -0400
Received: from 135.red-80-26-73.staticip.rima-tde.net ([80.26.73.135] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hE6lg-0007QM-Pa; Wed, 10 Apr 2019 08:31:32 +0200
Date:   Wed, 10 Apr 2019 08:31:31 +0200 (CEST)
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
Subject: Re: [PATCH v6 13/20] x86/split_lock: Enable split lock detection by
 default
In-Reply-To: <20190410000229.GA209676@romley-ivt3.sc.intel.com>
Message-ID: <alpine.DEB.2.21.1904100827530.2020@nanos.tec.linutronix.de>
References: <1554326526-172295-1-git-send-email-fenghua.yu@intel.com> <1554326526-172295-14-git-send-email-fenghua.yu@intel.com> <alpine.DEB.2.21.1904041932500.1802@nanos.tec.linutronix.de> <20190410000229.GA209676@romley-ivt3.sc.intel.com>
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

On Tue, 9 Apr 2019, Fenghua Yu wrote:
> On Thu, Apr 04, 2019 at 08:07:57PM +0200, Thomas Gleixner wrote:
> > On Wed, 3 Apr 2019, Fenghua Yu wrote:
> > >  static void early_init_intel(struct cpuinfo_x86 *c)
> > >  {
> > >  	u64 misc_enable;
> > >  
> > > +	init_split_lock_detect(c);
> > 
> > so we have in early boot:
> > 
> > 	early_cpu_init()
> > 	  early_identify_cpu()
> > 	    this_cpu->c_early_init(c)
> > 	      early_init_intel() {
> > 	        init_split_lock_detect();
> > 	      }	
> >             ....
> >             cpu_set_core_cap_bits(c)
> > 	       set(FEATURE_SPLIT_LOCK)
> > 
> > I don't have to understand how init_split_lock_detect() will magically see
> > the feature bit which gets set afterwards, right? 
> 
> early_init_intel() is called twice on the boot CPU. Besides it's called
> in earl_cpu_init(), it's also called in:
> 	identify_boot_cpu()
> 		identify_cpu()
> 			init_intel()
> 				early_init_intel()
> 					init_split_lock_detect();
> 
> It's true that init_split_lock_detect() doesn't see the feature bit when
> it's called for the first time in early_cpu_init(). But it sees the feature
> bit when it's called for the second time in identify_boot_cpu().

That's hideous, really. 

> So is init_split_lock_detect() in the right place?

You're not seriously asking that?

It's obviously not the right place. We are not placing calls at random
points just because they happen to work by chance.

Thanks,

	tglx
