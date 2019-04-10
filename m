Return-Path: <SRS0=qAu2=SM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9FC3C10F0E
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 00:10:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97BDF21741
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 00:10:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbfDJAKU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 20:10:20 -0400
Received: from mga06.intel.com ([134.134.136.31]:24875 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726592AbfDJAKU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 20:10:20 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Apr 2019 17:10:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,331,1549958400"; 
   d="scan'208";a="130020630"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by orsmga007.jf.intel.com with ESMTP; 09 Apr 2019 17:10:18 -0700
Date:   Tue, 9 Apr 2019 17:02:31 -0700
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
Subject: Re: [PATCH v6 13/20] x86/split_lock: Enable split lock detection by
 default
Message-ID: <20190410000229.GA209676@romley-ivt3.sc.intel.com>
References: <1554326526-172295-1-git-send-email-fenghua.yu@intel.com>
 <1554326526-172295-14-git-send-email-fenghua.yu@intel.com>
 <alpine.DEB.2.21.1904041932500.1802@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1904041932500.1802@nanos.tec.linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Apr 04, 2019 at 08:07:57PM +0200, Thomas Gleixner wrote:
> On Wed, 3 Apr 2019, Fenghua Yu wrote:
> 
> > +static void init_split_lock_detect(struct cpuinfo_x86 *c)
> > +{
> > +	if (cpu_has(c, X86_FEATURE_SPLIT_LOCK_DETECT)) {
> > +		u32 l, h;
> > +
> > +		mutex_lock(&split_lock_detect_mutex);
> > +		rdmsr(MSR_TEST_CTL, l, h);
> > +		l = new_sp_test_ctl_val(l);
> > +		wrmsr(MSR_TEST_CTL, l, h);
> > +		show_split_lock_detection_info();
> > +		mutex_unlock(&split_lock_detect_mutex);
> > +	}
> > +}
> > +
> >  static void early_init_intel(struct cpuinfo_x86 *c)
> >  {
> >  	u64 misc_enable;
> >  
> > +	init_split_lock_detect(c);
> 
> so we have in early boot:
> 
> 	early_cpu_init()
> 	  early_identify_cpu()
> 	    this_cpu->c_early_init(c)
> 	      early_init_intel() {
> 	        init_split_lock_detect();
> 	      }	
>             ....
>             cpu_set_core_cap_bits(c)
> 	       set(FEATURE_SPLIT_LOCK)
> 
> I don't have to understand how init_split_lock_detect() will magically see
> the feature bit which gets set afterwards, right? 

early_init_intel() is called twice on the boot CPU. Besides it's called
in earl_cpu_init(), it's also called in:
	identify_boot_cpu()
		identify_cpu()
			init_intel()
				early_init_intel()
					init_split_lock_detect();

It's true that init_split_lock_detect() doesn't see the feature bit when
it's called for the first time in early_cpu_init(). But it sees the feature
bit when it's called for the second time in identify_boot_cpu().

So is init_split_lock_detect() in the right place?

Thanks.

-Fenghua
