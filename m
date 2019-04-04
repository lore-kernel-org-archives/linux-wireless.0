Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD71CC10F0C
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 19:30:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9F3E206C0
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 19:30:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730370AbfDDTau (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 15:30:50 -0400
Received: from mga06.intel.com ([134.134.136.31]:43341 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727398AbfDDTau (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 15:30:50 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Apr 2019 12:30:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,309,1549958400"; 
   d="scan'208";a="140047806"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by orsmga003.jf.intel.com with ESMTP; 04 Apr 2019 12:30:46 -0700
Date:   Thu, 4 Apr 2019 12:23:07 -0700
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
Message-ID: <20190404192306.GA178488@romley-ivt3.sc.intel.com>
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
> > A split locked access locks bus and degrades overall memory access
> > performance. When split lock detection feature is enumerated, enable
> > the feature by default to find any split lock issue and then fix
> > the issue.
> 
> Enabling the feature allows to find the issues, but does not automagically
> fix them. Come on.

Ok. I will remove the "and then fix the issue".

> 
> > +#define DISABLE_SPLIT_LOCK_DETECT 0
> > +#define ENABLE_SPLIT_LOCK_DETECT  1
> 
> If those defines have a value at all, please start with the facility not
> with functionality, i.e. AC_SPLIT_LOCK_ENABLE....

OK.

> 
> > +
> > +static DEFINE_MUTEX(split_lock_detect_mutex);
> > +static int split_lock_detect_val;
> 
> detect_val? What value is that?

According to previous discussions, I was told to call this split lock feature
as "split lock detection" instead of "#AC for split lock". So I use
"split_lock_detect..." in variable names or function names, call feature flag
as "split_lock_detect", and call the feature as "split lock detection" in
descriptions.

If you don't agree to name feature as "split lock detection", I can change
variable names/function names/feature flag/descriptions etc back to previous
names "ac_split_lock...", "#AC for split lock", etc.

The variable split_lock_detect_val is either 0 or 1. It stores current
enable/disable status of split lock detection feature. By default it's
one after the feature is enumerated. Then sysadmin can change it to 0 or 1
to enable or disable the feature during run time.

> Its supposed to hold those magic defines
> above. So something like
> 
> static unsigned int ac_split_lock_enable;

If you agree to name the split lock feature as "split lock detection" feature,
can I change this variable to static unsigned int split_lock_detect_enable?

> >  /*
> >   * Just in case our CPU detection goes bad, or you have a weird system,
> >   * allow a way to override the automatic disabling of MPX.
> > @@ -161,10 +167,45 @@ static bool bad_spectre_microcode(struct cpuinfo_x86 *c)
> >  	return false;
> >  }
> >  
> > +static u32 new_sp_test_ctl_val(u32 test_ctl_val)
> > +{
> > +	/* Change the split lock setting. */
> > +	if (READ_ONCE(split_lock_detect_val) == DISABLE_SPLIT_LOCK_DETECT)
> 
> That READ_ONCE() is required because?

Ok. Will remove READ_ONCE().

> 
> > +		test_ctl_val &= ~TEST_CTL_ENABLE_SPLIT_LOCK_DETECT;
> > +	else
> > +		test_ctl_val |= TEST_CTL_ENABLE_SPLIT_LOCK_DETECT;
> > +
> > +	return test_ctl_val;
> > +}
> 
> Aside of that do we really need a misnomed function which replaces the
> simple inline code at the call site:
> 
> 	rdmsr(l, h)
> 	l &= ~TEST_CTL_ENABLE_SPLIT_LOCK_DETECT;
> 	l |= ac_split_lock_enable << TEST_CTL_ENABLE_SPLIT_LOCK_DETECT_SHIFT;
> 	wrmrs(...)
> 
> or the even more simple
> 
> 	if (ac_split_lock_enable)
> 		msr_set_bit(...)
> 	else
> 		msr_clear_nit(...)
> 
> Hmm?

The function new_sp_test_ctrl_val() will be called twice: here when
initializing split lock detection and in split_lock_detect_store()
when enabling/disabling the feature through the sysfs interface in
patch 0014.

So can I still keep this function and name it as get_new_test_ctrl_val()?

> 
> > +
> > +static inline void show_split_lock_detection_info(void)
> > +{
> > +	if (READ_ONCE(split_lock_detect_val))
> 
> That READ_ONCE() is required because?

Ok. Will remove READ_ONCE().

> 
> > +		pr_info_once("x86/split_lock: split lock detection enabled\n");
> > +	else
> > +		pr_info_once("x86/split_lock: split lock detection disabled\n");
> 
> pr_fmt exists for a reason and having 'split lock' repeated several times
> in the same line is not making it more readable.

Ok. I will change the string to "x86/split_lock_detection: enabled\n",
is it ok?

> 
> 
> > +
> >  	/* Unmask CPUID levels if masked: */
> >  	if (c->x86 > 6 || (c->x86 == 6 && c->x86_model >= 0xd)) {
> >  		if (msr_clear_bit(MSR_IA32_MISC_ENABLE,
> > @@ -1032,6 +1073,7 @@ cpu_dev_register(intel_cpu_dev);
> >  static void __init set_split_lock_detect(void)
> >  {
> >  	setup_force_cpu_cap(X86_FEATURE_SPLIT_LOCK_DETECT);
> > +	split_lock_detect_val = 1;
> 
> Oh well. You add defines on top of the file and then you don't use them.

Will fix this.

Thanks.

-Fenghua
