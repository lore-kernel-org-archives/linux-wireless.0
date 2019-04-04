Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9169C4360F
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 16:35:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E7B7206DF
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 16:35:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729288AbfDDQfq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 12:35:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:16322 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727039AbfDDQfq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 12:35:46 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Apr 2019 09:35:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,308,1549958400"; 
   d="scan'208";a="128641824"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by orsmga007.jf.intel.com with ESMTP; 04 Apr 2019 09:35:45 -0700
Date:   Thu, 4 Apr 2019 09:35:45 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Fenghua Yu' <fenghua.yu@intel.com>,
        'Thomas Gleixner' <tglx@linutronix.de>,
        'Ingo Molnar' <mingo@redhat.com>,
        'Borislav Petkov' <bp@alien8.de>,
        'H Peter Anvin' <hpa@zytor.com>,
        'Dave Hansen' <dave.hansen@intel.com>,
        'Paolo Bonzini' <pbonzini@redhat.com>,
        'Ashok Raj' <ashok.raj@intel.com>,
        'Peter Zijlstra' <peterz@infradead.org>,
        'Kalle Valo' <kvalo@codeaurora.org>,
        'Xiaoyao Li ' <xiaoyao.li@intel.com>,
        'Michael Chan' <michael.chan@broadcom.com>,
        'Ravi V Shankar' <ravi.v.shankar@intel.com>,
        'linux-kernel' <linux-kernel@vger.kernel.org>,
        'x86' <x86@kernel.org>,
        "'linux-wireless@vger.kernel.org'" <linux-wireless@vger.kernel.org>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        "'kvm@vger.kernel.org'" <kvm@vger.kernel.org>
Subject: Re: [PATCH v6 04/20] x86/split_lock: Align x86_capability to
 unsigned long to avoid split locked access
Message-ID: <20190404163545.GE9911@linux.intel.com>
References: <1554326526-172295-1-git-send-email-fenghua.yu@intel.com>
 <1554326526-172295-5-git-send-email-fenghua.yu@intel.com>
 <73ecc9de54c3424da3cddd1a34cb8701@AcuMS.aculab.com>
 <c0d43317cce34389ac4a1e91e97d909b@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c0d43317cce34389ac4a1e91e97d909b@AcuMS.aculab.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Apr 04, 2019 at 04:24:15PM +0000, David Laight wrote:
> From: David Laight
> > Sent: 04 April 2019 15:45
> > 
> > From: Fenghua Yu
> > > Sent: 03 April 2019 22:22
> > > set_cpu_cap() calls locked BTS and clear_cpu_cap() calls locked BTR to
> > > operate on bitmap defined in x86_capability.
> > >
> > > Locked BTS/BTR accesses a single unsigned long location. In 64-bit mode,
> > > the location is at:
> > > base address of x86_capability + (bit offset in x86_capability / 64) * 8
> > >
> > > Since base address of x86_capability may not be aligned to unsigned long,
> > > the single unsigned long location may cross two cache lines and
> > > accessing the location by locked BTS/BTR introductions will trigger #AC.
> > 
> > That is not true.
> > The BTS/BTR instructions access the memory word that contains the
> > expected bit.
> > The 'operand size' only affects the size of the register use for the
> > bit offset.
> > If the 'operand size' is 16 bits wide (+/- 32k bit offset) the cpu might
> > do an aligned 16bit memory access, otherwise (32 or 64bit bit offset) it
> > might do an aligned 32 bit access.
> > It should never do an 64bit access and never a misaligned one (even if
> > the base address is misaligned).
> 
> Hmmm... I may have misread things slightly.
> The accessed address is 'Effective Address + (4 ∗ (BitOffset DIV 32))'.
> However nothing suggests that it ever does 64bit accesses.
> 
> If it does do 64bit accesses when the operand size is 64 bits then the
> asm stubs ought to be changed to only specify 32bit operand size.

Heh, we had this discussion before[1], the op size dictates the size of
the memory access and can generate unaligned accesses.

[1] https://lkml.kernel.org/r/20181127195153.GE27075@linux.intel.com
