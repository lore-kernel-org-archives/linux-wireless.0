Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDD08C4360F
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 14:39:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8442D2177E
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 14:39:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="myuIZy2B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728909AbfDDOjv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 10:39:51 -0400
Received: from mail.skyhub.de ([5.9.137.197]:34200 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727310AbfDDOjv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 10:39:51 -0400
Received: from zn.tnic (p200300EC2F148A00329C23FFFEA6A903.dip0.t-ipconnect.de [IPv6:2003:ec:2f14:8a00:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C94771EC05DE;
        Thu,  4 Apr 2019 16:39:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1554388788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=n6kK5AoazVvyMd+L0CyOKXnnpfZyOQimMyqPjIuZd2w=;
        b=myuIZy2BZEXZwEZWuz78vZg+LOR2S+efFJPTsmqg+u12/K5P2pO6b9aRt8tROxS+AYJ5TR
        bj4VCa8ODpP03mkHoDpgL4/qGCuM9ALVb+WJovefMj1txbh6oJDuaNqv/deQ37rU/5UqKa
        4mh9QdtTTjDCTfTLjY0Qm5lMTeewyCo=
Date:   Thu, 4 Apr 2019 16:39:43 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Fenghua Yu <fenghua.yu@intel.com>
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
Message-ID: <20190404143942.GD22539@zn.tnic>
References: <1554326526-172295-1-git-send-email-fenghua.yu@intel.com>
 <1554326526-172295-2-git-send-email-fenghua.yu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1554326526-172295-2-git-send-email-fenghua.yu@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Apr 03, 2019 at 02:21:47PM -0700, Fenghua Yu wrote:
> cpu_caps_cleared and cpu_caps_set may not be aligned to unsigned long.
> Atomic operations (i.e. set_bit and clear_bit) on the bitmaps may access

Please end function names with parentheses.

> two cache lines (a.k.a. split lock) and lock the bus to block all memory

not "lock the bus" but "cause the CPU to do a bus lock... "

> accesses from other processors to ensure atomicity.
> 
> To avoid the overall performance degradation from the bus locking, align
> the two variables to unsigned long.
> 
> Defining the variables as unsigned long may also fix the issue because
> they are naturally aligned to unsigned long. But that needs additional
> code changes. Adding __aligned(unsigned long) is a simpler fix.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  arch/x86/kernel/cpu/common.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

With the above nitpicks addressed:

Reviewed-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
