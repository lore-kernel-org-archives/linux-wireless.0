Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:36321 "EHLO
        mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750952AbdAQT5E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Jan 2017 14:57:04 -0500
Received: by mail-pf0-f171.google.com with SMTP id 189so64384848pfu.3
        for <linux-wireless@vger.kernel.org>; Tue, 17 Jan 2017 11:57:03 -0800 (PST)
Date: Tue, 17 Jan 2017 11:48:22 -0800
From: Brian Norris <briannorris@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        linux-kernel@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>
Subject: Re: [PATCH v2 2/3] mwifiex: pcie: don't loop/retry interrupt status
 checks
Message-ID: <20170117194822.GA29749@google.com> (sfid-20170117_205707_559872_8EE3564C)
References: <20170113233538.36196-1-briannorris@chromium.org>
 <20170113233538.36196-2-briannorris@chromium.org>
 <20170116005452.GI23285@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170116005452.GI23285@dtor-ws>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 15, 2017 at 04:54:52PM -0800, Dmitry Torokhov wrote:
> On Fri, Jan 13, 2017 at 03:35:37PM -0800, Brian Norris wrote:
> > The following sequence occurs when using IEEE power-save on 8997:
> > (a) driver sees SLEEP event
> > (b) driver issues SLEEP CONFIRM
> > (c) driver recevies CMD interrupt; within the interrupt processing loop,
> >     we do (d) and (e):
> > (d) wait for FW sleep cookie (and often time out; it takes a while), FW
> >     is putting card into low power mode
> > (e) re-check PCIE_HOST_INT_STATUS register; quit loop with 0 value
> > 
> > But at (e), no one actually signaled an interrupt (i.e., we didn't check
> > adapter->int_status). And what's more, because the card is going to
> > sleep, this register read appears to take a very long time in some cases
> > -- 3 milliseconds in my case!
> > 
> > Now, I propose that (e) is completely unnecessary. If there were any
> > additional interrupts signaled after the start of this loop, then the
> > interrupt handler would have set adapter->int_status to non-zero and
> > queued more work for the main loop -- and we'd catch it on the next
> > iteration of the main loop.
> > 
> > So this patch drops all the looping/re-reading of PCIE_HOST_INT_STATUS,
> > which avoids the problematic (and slow) register read in step (e).
> > 
> > Incidentally, this is a very similar issue to the one fixed in commit
> > ec815dd2a5f1 ("mwifiex: prevent register accesses after host is
> > sleeping"), except that the register read is just very slow instead of
> > fatal in this case.
> > 
> > Tested on 8997 in both MSI and (though not technically supported at the
> > moment) MSI-X mode.
> 
> Well, that kills interrupt mitigation and with PCIE that might be
> somewhat important (SDIO is too slow to be important I think) and might
> cost you throughput.

Hmm, well I don't see us disabling interrupts in here, at least for MSI
mode, so it doesn't actually look like a mitigation mechanism. More like
a redundancy. But I'm not an expert on MSI, and definitely not on
network performance.

Also, FWIW, I did some fairly non-scientific tests of this on my
systems, and I didn't see much difference. I can run better tests, and
even collect data on how often we loop here vs. see new interrupts.

> OTOH maybe Marvell should convert PICE to NAPI to make this more
> obvious and probably more correct.

>From my brief reading, that sounds like a better way to make this
configurable.

So I'm not sure which way you'd suggest then; take a patch like this,
which makes the driver more clear and less buggy? Or write some
different patch that isolates just the power-save related condition, so
we break out of this look [1]?

I'm also interested in any opinions from the Marvell side -- potentially
testing results, rationale behind this code structure, or even a better
alternative patch.

Brian

[1] i.e., along the lines of commit ec815dd2a5f1 ("mwifiex: prevent
register accesses after host is sleeping").
