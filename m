Return-Path: <SRS0=x8ok=SU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 532F7C282DC
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 01:05:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2197F217FA
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 01:05:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387569AbfDRBFM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 21:05:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:21275 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728268AbfDRBFM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 21:05:12 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Apr 2019 18:05:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,364,1549958400"; 
   d="scan'208";a="316882231"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by orsmga005.jf.intel.com with ESMTP; 17 Apr 2019 18:05:10 -0700
Date:   Wed, 17 Apr 2019 17:57:12 -0700
From:   Fenghua Yu <fenghua.yu@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
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
Message-ID: <20190418005711.GB18776@romley-ivt3.sc.intel.com>
References: <1555536851-17462-1-git-send-email-fenghua.yu@intel.com>
 <1555536851-17462-16-git-send-email-fenghua.yu@intel.com>
 <alpine.DEB.2.21.1904180042090.3174@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1904180042090.3174@nanos.tec.linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Apr 18, 2019 at 12:47:24AM +0200, Thomas Gleixner wrote:
> On Wed, 17 Apr 2019, Fenghua Yu wrote:
> 
> > The interface /sys/device/system/cpu/split_lock_detect is added
> > to allow user to control split lock detection and show current split
> > lock detection setting.
> > 
> > Writing [yY1] or [oO][nN] to the file enables split lock detection and
> > writing [nN0] or [oO][fF] disables split lock detection. Split lock
> > detection is enabled or disabled on all CPUs.
> > 
> > Reading the file returns current global split lock detection setting:
> > 0: disabled
> > 1: enabled
> 
> Again, You explain WHAT this patch does and still there is zero
> justification why this sysfs knob is needed at all. I still do not see any
> reason why this knob should exist.

An important application has split lock issues which are already discovered
and need to be fixed. But before the issues are fixed, sysadmin still wants to
run the application without rebooting the system, the sysfs knob can be useful
to turn off split lock detection. After the application is done, split lock
detection will be enabled again through the sysfs knob.

Without the sysfs knob, sysadmin has to reboot the system with kernel option
"no_split_lock_detect" to run the application before the split lock issues
are fixed.

Is this a valid justification why the sysfs knob is needed? If it is, I can
add the justification in the next version.

Thanks.

-Fenghua
