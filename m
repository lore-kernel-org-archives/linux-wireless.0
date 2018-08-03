Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42082 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728122AbeHCLF0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Aug 2018 07:05:26 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Wireless <linux-wireless@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: linux-next: build failure after merge of the wireless-drivers-next tree
References: <20180803182942.4de98df2@canb.auug.org.au>
Date: Fri, 03 Aug 2018 12:09:59 +0300
In-Reply-To: <20180803182942.4de98df2@canb.auug.org.au> (Stephen Rothwell's
        message of "Fri, 3 Aug 2018 18:29:42 +1000")
Message-ID: <874lgb7r4o.fsf@kamboji.qca.qualcomm.com> (sfid-20180803_111017_819130_E47136C7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> After merging the wireless-drivers-next tree, today's linux-next build
> (powerpc allyesconfig) failed like this:
>
> ld: drivers/net/wireless/mediatek/mt76/mt76x0/trace.o:(__tracepoints+0x0): multiple definition of `__tracepoint_set_shared_key'; drivers/net/wireless/mediatek/mt7601u/trace.o:(__tracepoints+0x0): first defined here

[...]

> Caused by commit
>
>   7b4859026ccd ("mt76x0: core files")
>
> and following ones.
>
> I have just marked that driver broken for now:

Thanks Stephen for the report. Odd that kbuild bot didn't catch this, I
did have these patches in my pending branch for several days.

Stanislaw, could you please send a fix for this ASAP? I can't submit a
pull request to Dave until this is fixed.

-- 
Kalle Valo
