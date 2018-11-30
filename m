Return-Path: <SRS0=8CYu=OJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A7A7C04EB8
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Nov 2018 18:32:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CF2220673
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Nov 2018 18:32:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1CF2220673
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=atomide.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbeLAFnG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 1 Dec 2018 00:43:06 -0500
Received: from muru.com ([72.249.23.125]:55754 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725817AbeLAFnG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 1 Dec 2018 00:43:06 -0500
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 7D4B580CC;
        Fri, 30 Nov 2018 18:32:57 +0000 (UTC)
Date:   Fri, 30 Nov 2018 10:32:52 -0800
From:   Tony Lindgren <tony@atomide.com>
To:     Adam Ford <aford173@gmail.com>
Cc:     kvalo@codeaurora.org, "Reizer, Eyal" <eyalr@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, guym@ti.com,
        luciano.coelho@intel.com, maitalm@ti.com, maxim.altshul@ti.com,
        shaharp@ti.com, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] wlcore: Fix BUG with clear completion on timeout
Message-ID: <20181130183252.GH53235@atomide.com>
References: <20181001213805.86511-1-tony@atomide.com>
 <20181005083324.D2D5160818@smtp.codeaurora.org>
 <CAHCN7xKiCrrG=YLMX4gTtgfEQ3zG3P++OpG5aaQ3uoFO9A5RSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHCN7xKiCrrG=YLMX4gTtgfEQ3zG3P++OpG5aaQ3uoFO9A5RSA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

* Adam Ford <aford173@gmail.com> [181130 13:16]:
> On Fri, Oct 5, 2018 at 3:33 AM Kalle Valo <kvalo@codeaurora.org> wrote:
> >
> > Tony Lindgren <tony@atomide.com> wrote:
> >
> > > We do not currently clear wl->elp_compl on ELP timeout and we have bogus
> > > lingering pointer that wlcore_irq then will try to access after recovery
> > > is done:
> > >
> > > BUG: spinlock bad magic on CPU#1, irq/255-wl12xx/580
> > > ...
> > > (spin_dump) from [<c01b9344>] (do_raw_spin_lock+0xc8/0x124)
> > > (do_raw_spin_lock) from [<c09b3970>] (_raw_spin_lock_irqsave+0x68/0x74)
> > > (_raw_spin_lock_irqsave) from [<c01a02f0>] (complete+0x24/0x58)
> > > (complete) from [<bf572610>] (wlcore_irq+0x48/0x17c [wlcore])
> > > (wlcore_irq [wlcore]) from [<c01c5efc>] (irq_thread_fn+0x2c/0x64)
> > > (irq_thread_fn) from [<c01c623c>] (irq_thread+0x148/0x290)
> > > (irq_thread) from [<c016b4b0>] (kthread+0x160/0x17c)
> > > (kthread) from [<c01010b4>] (ret_from_fork+0x14/0x20)
> > > ...
> > >
> > > After that the system will hang. Let's fix this by adding a flag for
> > > recovery and moving the recovery work call to to the error handling
> > > section.
> > >
> > > And we want to set WL1271_FLAG_INTENDED_FW_RECOVERY and actually clear
> > > it too in wl1271_recovery_work() and just downgrade the error to a
> > > warning to prevent overly verbose output.
> > >
> 
> Do we know how far back this bug goes and which versions need this
> patch applied to it?  I have seen something similar on 4.19, but I
> haven't tried this patch to fix it.  It wasn't clear to me if this is
> linux-next or 4.19 or something different.

I'm not sure if this is needed for v4.19 as the wakeirq patch
is not there. Maybe give it a try and see if it helps with
the issue you're seeing, then request inclusion for stable if
it helps?

BTW any wlcore issues with earlier kernels should be separately
debugged and tested. Fixes done after changing wlcore to use
PM runtime and wakeirq may be incomple for earlier kernels,
that's the two commits and below and any changes related to them.

And in general there seems to be two categories of common issues
with wlcore that I've seen: GPIO interrupt not behaving with the
SoC or old firmware being used for wlcore.

Regards,

Tony

8< -----------------
3c83dd577c7f ("wlcore: Add support for optional wakeirq")
fa2648a34e73 ("wlcore: Add support for runtime PM")
