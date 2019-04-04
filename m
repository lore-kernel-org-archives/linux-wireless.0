Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 913F0C4360F
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 19:45:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7046A2082E
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 19:45:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730445AbfDDTpK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 15:45:10 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:46332 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730416AbfDDTpK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 15:45:10 -0400
Received: from p5492e2fc.dip0.t-ipconnect.de ([84.146.226.252] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hC8ID-0000dE-Qs; Thu, 04 Apr 2019 21:44:58 +0200
Date:   Thu, 4 Apr 2019 21:44:56 +0200 (CEST)
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
In-Reply-To: <20190404192306.GA178488@romley-ivt3.sc.intel.com>
Message-ID: <alpine.DEB.2.21.1904042135160.1802@nanos.tec.linutronix.de>
References: <1554326526-172295-1-git-send-email-fenghua.yu@intel.com> <1554326526-172295-14-git-send-email-fenghua.yu@intel.com> <alpine.DEB.2.21.1904041932500.1802@nanos.tec.linutronix.de> <20190404192306.GA178488@romley-ivt3.sc.intel.com>
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

On Thu, 4 Apr 2019, Fenghua Yu wrote:
> On Thu, Apr 04, 2019 at 08:07:57PM +0200, Thomas Gleixner wrote:
> > On Wed, 3 Apr 2019, Fenghua Yu wrote:
> > > +static DEFINE_MUTEX(split_lock_detect_mutex);
> > > +static int split_lock_detect_val;
> > 
> > detect_val? What value is that?
> 
> According to previous discussions, I was told to call this split lock feature
> as "split lock detection" instead of "#AC for split lock". So I use
> "split_lock_detect..." in variable names or function names, call feature flag
> as "split_lock_detect", and call the feature as "split lock detection" in
> descriptions.
> 
> If you don't agree to name feature as "split lock detection", I can change
> variable names/function names/feature flag/descriptions etc back to previous
> names "ac_split_lock...", "#AC for split lock", etc.
> 
> The variable split_lock_detect_val is either 0 or 1. It stores current
> enable/disable status of split lock detection feature. By default it's
> one after the feature is enumerated. Then sysadmin can change it to 0 or 1
> to enable or disable the feature during run time.

> > static unsigned int ac_split_lock_enable;
> 
> If you agree to name the split lock feature as "split lock detection" feature,
> can I change this variable to static unsigned int split_lock_detect_enable?

I don't care much whether it's ac_split_lock or split_lock_detect, but _val
is a completely bogus and unintuitive name. The variable tells whether the
functionality is enabled or not. Then do not name it $prefix_val, which can
mean anything. Name it $prefix_enable, which makes it entirely clear what
this is about.

And please make it type bool so you don't need any of these defines either.

> > > +static u32 new_sp_test_ctl_val(u32 test_ctl_val)
> > > +{
> > > +	/* Change the split lock setting. */
> > > +	if (READ_ONCE(split_lock_detect_val) == DISABLE_SPLIT_LOCK_DETECT)
> > 
> > That READ_ONCE() is required because?
> 
> Ok. Will remove READ_ONCE().
> 
> > 
> > > +		test_ctl_val &= ~TEST_CTL_ENABLE_SPLIT_LOCK_DETECT;
> > > +	else
> > > +		test_ctl_val |= TEST_CTL_ENABLE_SPLIT_LOCK_DETECT;
> > > +
> > > +	return test_ctl_val;
> > > +}
> > 
> > Aside of that do we really need a misnomed function which replaces the
> > simple inline code at the call site:
> > 
> > 	rdmsr(l, h)
> > 	l &= ~TEST_CTL_ENABLE_SPLIT_LOCK_DETECT;
> > 	l |= ac_split_lock_enable << TEST_CTL_ENABLE_SPLIT_LOCK_DETECT_SHIFT;
> > 	wrmrs(...)
> > 
> > or the even more simple
> > 
> > 	if (ac_split_lock_enable)
> > 		msr_set_bit(...)
> > 	else
> > 		msr_clear_nit(...)
> > 
> > Hmm?
> 
> The function new_sp_test_ctrl_val() will be called twice: here when
> initializing split lock detection and in split_lock_detect_store()
> when enabling/disabling the feature through the sysfs interface in
> patch 0014.

It's still pointless.

> So can I still keep this function and name it as get_new_test_ctrl_val()?

No. The function you want to share between init code and sysfs is

    split_lock_update_msr()
    {
 	if (split_lock_enable)
 		msr_set_bit(...)
 	else
 		msr_clear_nit(...)
    }

That's all. No duplicated code. No convoluted helper function,
nothing. Simple straight forward readable code.

> > > +static inline void show_split_lock_detection_info(void)
> > > +{
> > > +	if (READ_ONCE(split_lock_detect_val))
> > 
> > That READ_ONCE() is required because?
> 
> Ok. Will remove READ_ONCE().
> 
> > 
> > > +		pr_info_once("x86/split_lock: split lock detection enabled\n");
> > > +	else
> > > +		pr_info_once("x86/split_lock: split lock detection disabled\n");
> > 
> > pr_fmt exists for a reason and having 'split lock' repeated several times
> > in the same line is not making it more readable.
> 
> Ok. I will change the string to "x86/split_lock_detection: enabled\n",
> is it ok?

Care to read carefully what I wrote? Hint: pr_fmt
 
> > Oh well. You add defines on top of the file and then you don't use them.
> 
> Will fix this.

What about the init / feature detection sequence which you snipped from the
reply?

Thanks,

	tglx
