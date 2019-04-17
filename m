Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DBE2C282DD
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 23:55:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D73621479
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 23:55:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387768AbfDQXz2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 19:55:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:2215 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729331AbfDQXz1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 19:55:27 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Apr 2019 16:55:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,363,1549958400"; 
   d="scan'208";a="162854450"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by fmsmga004.fm.intel.com with ESMTP; 17 Apr 2019 16:55:27 -0700
Date:   Wed, 17 Apr 2019 16:47:28 -0700
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
Subject: Re: [PATCH v7 18/21] x86/clearcpuid: Support feature flag string in
 kernel option clearcpuid
Message-ID: <20190417234728.GA18776@romley-ivt3.sc.intel.com>
References: <1555536851-17462-1-git-send-email-fenghua.yu@intel.com>
 <1555536851-17462-19-git-send-email-fenghua.yu@intel.com>
 <alpine.DEB.2.21.1904180106400.3174@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1904180106400.3174@nanos.tec.linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Apr 18, 2019 at 01:19:41AM +0200, Thomas Gleixner wrote:
> On Wed, 17 Apr 2019, Fenghua Yu wrote:
> 
> > The kernel option clearcpuid currently only takes feature bit which
> > can be changed from kernel to kernel.
> > 
> > Extend clearcpuid to use cap flag string, which is defined in
> > x86_cap_flags[] and won't be changed from kernel to kernel.
> > And user can easily get the cap flag string from /proc/cpuinfo.
> 
> If your machine dies because init triggers #AC then please explain how that
> easily can be read from /proc/cpuinfo and how the sysadmin can figure out
> what the heck he needs to write on the kernel command line.
> 
> The whole 'clearcpuid' thing should have never been merged. It's a pure
> testing/debugging thing. And no, we are not going to proliferate it and
> extend it for dubious value. Quite the contrary, we should simply rip it
> out.

So I can remove the four 'clearcpuid' related patches 0018-0021 in the next
version, right?

> 
> Add a simple 'noac' or whatever command line option, which is documented
> proper and can easily be mapped to a #AC crash during boot.

OK. I will do this.

Thanks.

-Fenghua
