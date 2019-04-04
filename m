Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AD2DC4360F
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 19:11:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 383B5206B7
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 19:11:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730155AbfDDTLh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 15:11:37 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:46283 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729848AbfDDTLg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 15:11:36 -0400
Received: from p5492e2fc.dip0.t-ipconnect.de ([84.146.226.252] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hC7lf-00006C-IQ; Thu, 04 Apr 2019 21:11:19 +0200
Date:   Thu, 4 Apr 2019 21:11:18 +0200 (CEST)
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
Subject: Re: [PATCH v6 14/20] x86/split_lock: Add a sysfs interface to
 enable/disable split lock detection during run time
In-Reply-To: <1554326526-172295-15-git-send-email-fenghua.yu@intel.com>
Message-ID: <alpine.DEB.2.21.1904042039150.1802@nanos.tec.linutronix.de>
References: <1554326526-172295-1-git-send-email-fenghua.yu@intel.com> <1554326526-172295-15-git-send-email-fenghua.yu@intel.com>
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
> +
> +static ssize_t
> +split_lock_detect_show(struct device *dev, struct device_attribute *attr,
> +		       char *buf)
> +{
> +	return sprintf(buf, "%u\n", READ_ONCE(split_lock_detect_val));

Please stop sprinkling READ_ONCE all over the place or can you explain why
this is in any way useful? You know what READ/WRITE_ONCE() is for, right?

> +}
> +
> +static ssize_t
> +split_lock_detect_store(struct device *dev, struct device_attribute *attr,
> +			const char *buf, size_t count)
> +{
> +	u32 val, l, h;
> +	int cpu, ret;
> +
> +	ret = kstrtou32(buf, 10, &val);
> +	if (ret)
> +		return ret;
> +
> +	if (val != DISABLE_SPLIT_LOCK_DETECT && val != ENABLE_SPLIT_LOCK_DETECT)
> +		return -EINVAL;

As this is really a simple boolean you can just use strtobool() and be done
with it.

> +
> +	/*
> +	 * Since split lock could be disabled by kernel #AC handler or user
> +	 * may directly change bit 29 in MSR_TEST_CTL, split lock setting on

The user can change bit 29 in that MSR? If you talk about /dev/msr then I
really do not care. That interface should die.

Aside of that your usage of the term 'user' is really misleading and
inconsistent all over the place.

> +	 * each CPU may be different from global setting split_lock_detect_val
> +	 * by now. Update MSR on each CPU, so all of CPUs will have same split
> +	 * lock setting.

That helps in which way? If #AC was detected in the kernel then

     1) It's likely to be switched off again right away

     2) The WARN_ONCE() already triggered and will not warn again.

So what's the point here, really? If the kernel triggers #AC, game
over. Fix the kernel first. If your kernel is clean, then why do you need
that knob at all?

> +	 */
> +	mutex_lock(&split_lock_detect_mutex);
> +
> +	WRITE_ONCE(split_lock_detect_val, val);

Oh well.

> +	/*
> +	 * Get MSR_TEST_CTL on this CPU, assuming all CPUs have same value
> +	 * in the MSR except split lock detection bit (bit 29).

And some day in the future this breaks because MRS_TEST_CTL has some other
shiny bits.

> +	 */
> +	rdmsr(MSR_TEST_CTL, l, h);
> +	l = new_sp_test_ctl_val(l);
> +	/* Update the split lock detection setting on all online CPUs. */
> +	for_each_online_cpu(cpu)

And what exactly protects the online cpu mask?

> +		wrmsr_on_cpu(cpu, MSR_TEST_CTL, l, h);

Oh well. Instead of just having a function which does:

fun() 
   	 if (ac_...enabled)
	 	msr_set_bit()
	 else
	 	msr_clear_bit()

and invoke that from cpu init code and from here via on_each_cpu() or such?

> +	mutex_unlock(&split_lock_detect_mutex);
> +
> +	return count;
> +}
> +
> +static DEVICE_ATTR_RW(split_lock_detect);
> +
> +static int __init split_lock_init(void)
> +{
> +	int ret;
> +
> +	if (!boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT))
> +		return -ENODEV;
> +
> +	ret = device_create_file(cpu_subsys.dev_root,
> +				 &dev_attr_split_lock_detect);
> +	if (ret)
> +		return ret;
> +
> +	return 0;

What's wrong with:

       return device_create_file();

??? Not hard enough to read, right?

> +}
> +

Pointless empty line.

> +subsys_initcall(split_lock_init);

Thanks,

	tglx
