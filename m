Return-Path: <SRS0=x8ok=SU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9855CC10F0E
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 06:41:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 715802186A
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 06:41:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388197AbfDRGln (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Apr 2019 02:41:43 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:60437 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733049AbfDRGln (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Apr 2019 02:41:43 -0400
Received: from pd9ef12d2.dip0.t-ipconnect.de ([217.239.18.210] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hH0jj-00076A-4b; Thu, 18 Apr 2019 08:41:31 +0200
Date:   Thu, 18 Apr 2019 08:41:30 +0200 (CEST)
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
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v7 15/21] x86/split_lock: Add a sysfs interface to
 enable/disable split lock detection during run time
In-Reply-To: <20190418005711.GB18776@romley-ivt3.sc.intel.com>
Message-ID: <alpine.DEB.2.21.1904180832290.3174@nanos.tec.linutronix.de>
References: <1555536851-17462-1-git-send-email-fenghua.yu@intel.com> <1555536851-17462-16-git-send-email-fenghua.yu@intel.com> <alpine.DEB.2.21.1904180042090.3174@nanos.tec.linutronix.de> <20190418005711.GB18776@romley-ivt3.sc.intel.com>
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
> On Thu, Apr 18, 2019 at 12:47:24AM +0200, Thomas Gleixner wrote:
> > On Wed, 17 Apr 2019, Fenghua Yu wrote:
> > 
> > > The interface /sys/device/system/cpu/split_lock_detect is added
> > > to allow user to control split lock detection and show current split
> > > lock detection setting.
> > > 
> > > Writing [yY1] or [oO][nN] to the file enables split lock detection and
> > > writing [nN0] or [oO][fF] disables split lock detection. Split lock
> > > detection is enabled or disabled on all CPUs.
> > > 
> > > Reading the file returns current global split lock detection setting:
> > > 0: disabled
> > > 1: enabled
> > 
> > Again, You explain WHAT this patch does and still there is zero
> > justification why this sysfs knob is needed at all. I still do not see any
> > reason why this knob should exist.
> 
> An important application has split lock issues which are already discovered
> and need to be fixed. But before the issues are fixed, sysadmin still wants to
> run the application without rebooting the system, the sysfs knob can be useful
> to turn off split lock detection. After the application is done, split lock
> detection will be enabled again through the sysfs knob.

Are you sure that you are talking about the real world? I might buy the
'off' part somehow, but the 'on' part is beyond theoretical.

Even the 'off' part is dubious on a multi user machine. I personally would
neither think about using the sysfs knob nor about rebooting the machine
simply because I'd consider a lock operation accross a cacheline an malicious
DoS attempt. Why would I allow that?

So in reality the sysadmin will either move the workload to a machine w/o
the #AC magic or just tell the user to fix his crap.

> Without the sysfs knob, sysadmin has to reboot the system with kernel option
> "no_split_lock_detect" to run the application before the split lock issues
> are fixed.
> 
> Is this a valid justification why the sysfs knob is needed? If it is, I can
> add the justification in the next version.

Why has this information not been in the changelog right away? I'm really
tired of asking the same questions and pointing you to
Documentation/process over and over.

Thanks,

	tglx
