Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:46475 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753041AbdARN0f (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Jan 2017 08:26:35 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: Brian Norris <briannorris@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Nishant Sarmukadam <nishants@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Cathy Luo <cluo@marvell.com>
Subject: RE:  Re: [PATCH v2 2/3] mwifiex: pcie: don't loop/retry interrupt
 status checks
Date: Wed, 18 Jan 2017 13:13:23 +0000
Message-ID: <c8b88eda95e34164a9f933258f3a82a3@SC-EXCH04.marvell.com> (sfid-20170118_142655_673321_3298CD36)
References: <20170113233538.36196-1-briannorris@chromium.org>
 <20170113233538.36196-2-briannorris@chromium.org>
 <20170116005452.GI23285@dtor-ws> <20170117194822.GA29749@google.com>
In-Reply-To: <20170117194822.GA29749@google.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Brian,

> From: Brian Norris [mailto:briannorris@chromium.org]
> Sent: Wednesday, January 18, 2017 1:18 AM
> To: Dmitry Torokhov
> Cc: Amitkumar Karwar; Nishant Sarmukadam; linux-kernel@vger.kernel.org;
> Kalle Valo; linux-wireless@vger.kernel.org; Cathy Luo
> Subject: Re: [PATCH v2 2/3] mwifiex: pcie: don't loop/retry
> interrupt status checks
> 
> On Sun, Jan 15, 2017 at 04:54:52PM -0800, Dmitry Torokhov wrote:
> > On Fri, Jan 13, 2017 at 03:35:37PM -0800, Brian Norris wrote:
> > > The following sequence occurs when using IEEE power-save on 8997:
> > > (a) driver sees SLEEP event
> > > (b) driver issues SLEEP CONFIRM
> > > (c) driver recevies CMD interrupt; within the interrupt processing
> loop,
> > >     we do (d) and (e):
> > > (d) wait for FW sleep cookie (and often time out; it takes a
> while), FW
> > >     is putting card into low power mode
> > > (e) re-check PCIE_HOST_INT_STATUS register; quit loop with 0 value
> > >
> > > But at (e), no one actually signaled an interrupt (i.e., we didn't
> > > check
> > > adapter->int_status). And what's more, because the card is going to
> > > sleep, this register read appears to take a very long time in some
> > > cases
> > > -- 3 milliseconds in my case!
> > >
> > > Now, I propose that (e) is completely unnecessary. If there were
> any
> > > additional interrupts signaled after the start of this loop, then
> > > the interrupt handler would have set adapter->int_status to non-
> zero
> > > and queued more work for the main loop -- and we'd catch it on the
> > > next iteration of the main loop.
> > >
> > > So this patch drops all the looping/re-reading of
> > > PCIE_HOST_INT_STATUS, which avoids the problematic (and slow)
> register read in step (e).
> > >
> > > Incidentally, this is a very similar issue to the one fixed in
> > > commit
> > > ec815dd2a5f1 ("mwifiex: prevent register accesses after host is
> > > sleeping"), except that the register read is just very slow instead
> > > of fatal in this case.
> > >
> > > Tested on 8997 in both MSI and (though not technically supported at
> > > the
> > > moment) MSI-X mode.
> >
> > Well, that kills interrupt mitigation and with PCIE that might be
> > somewhat important (SDIO is too slow to be important I think) and
> > might cost you throughput.
> 
> Hmm, well I don't see us disabling interrupts in here, at least for MSI
> mode, so it doesn't actually look like a mitigation mechanism. More
> like a redundancy. But I'm not an expert on MSI, and definitely not on
> network performance.
> 
> Also, FWIW, I did some fairly non-scientific tests of this on my
> systems, and I didn't see much difference. I can run better tests, and
> even collect data on how often we loop here vs. see new interrupts.
> 
> > OTOH maybe Marvell should convert PICE to NAPI to make this more
> > obvious and probably more correct.
> 
> From my brief reading, that sounds like a better way to make this
> configurable.
> 
> So I'm not sure which way you'd suggest then; take a patch like this,
> which makes the driver more clear and less buggy? Or write some
> different patch that isolates just the power-save related condition, so
> we break out of this look [1]?
> 
> I'm also interested in any opinions from the Marvell side --
> potentially testing results, rationale behind this code structure, or
> even a better alternative patch.
> 

Thanks for the fix. It looks fine to me. Alternate fix would be below change.
We ran throughput tests with your patch vs below change. Results are almost same.

--------
@@ -2370,7 +2370,7 @@ static int mwifiex_process_pcie_int(struct mwifiex_adapter *adapter)
                        ret = mwifiex_pcie_process_cmd_complete(adapter);
                        if (ret)
                                return ret;
-                       if (adapter->hs_activated)
+                       if (adapter->hs_activated || adapter->ps_state == PS_STATE_SLEEP)
                                return ret;
--------

The logic of having while loop here was to avoid scheduling latency. As Dmitry pointed out in other email packet aggregation takes care of interrupts arriving too closely together. We have Rx buffer ring of size 32. So we may get a single interrupt to deliver 32 Rx packets.

Regards,
Amitkumar
