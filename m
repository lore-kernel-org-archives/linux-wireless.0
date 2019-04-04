Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8DE4C4360F
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 16:02:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77DB22082E
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 16:02:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729397AbfDDQCE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 12:02:04 -0400
Received: from mga05.intel.com ([192.55.52.43]:18965 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728710AbfDDQCE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 12:02:04 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Apr 2019 09:02:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,308,1549958400"; 
   d="scan'208";a="313154179"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by orsmga005.jf.intel.com with ESMTP; 04 Apr 2019 09:02:02 -0700
Date:   Thu, 4 Apr 2019 08:54:23 -0700
From:   Fenghua Yu <fenghua.yu@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, H Peter Anvin <hpa@zytor.com>,
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
Subject: Re: [PATCH v6 01/20] x86/common: Align cpu_caps_cleared and
 cpu_caps_set to unsigned long
Message-ID: <20190404155422.GA177894@romley-ivt3.sc.intel.com>
References: <1554326526-172295-1-git-send-email-fenghua.yu@intel.com>
 <1554326526-172295-2-git-send-email-fenghua.yu@intel.com>
 <20190404143942.GD22539@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190404143942.GD22539@zn.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Apr 04, 2019 at 04:39:43PM +0200, Borislav Petkov wrote:
> On Wed, Apr 03, 2019 at 02:21:47PM -0700, Fenghua Yu wrote:
> > cpu_caps_cleared and cpu_caps_set may not be aligned to unsigned long.
> > Atomic operations (i.e. set_bit and clear_bit) on the bitmaps may access
> 
> Please end function names with parentheses.

Sure.

> 
> > two cache lines (a.k.a. split lock) and lock the bus to block all memory
> 
> not "lock the bus" but "cause the CPU to do a bus lock... "

Sure.

> 
> > accesses from other processors to ensure atomicity.
> > 
> > To avoid the overall performance degradation from the bus locking, align
> > the two variables to unsigned long.
> > 
> > Defining the variables as unsigned long may also fix the issue because
> > they are naturally aligned to unsigned long. But that needs additional
> > code changes. Adding __aligned(unsigned long) is a simpler fix.
> > 
> > Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> > ---
> >  arch/x86/kernel/cpu/common.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> With the above nitpicks addressed:
> 
> Reviewed-by: Borislav Petkov <bp@suse.de>

Thank you for your review!

-Fenghua
