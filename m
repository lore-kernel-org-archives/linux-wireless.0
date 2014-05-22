Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:51310 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaEVFqo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 01:46:44 -0400
Date: Thu, 22 May 2014 15:46:18 +1000
From: James Cameron <quozl@laptop.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] mwifiex: block work queue while suspended
Message-ID: <20140522054618.GL6184@us.netrek.org> (sfid-20140522_074647_787250_93576253)
References: <20140516012439.GI15430@us.netrek.org>
 <477F20668A386D41ADCC57781B1F70430F70F5D8ED@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <477F20668A386D41ADCC57781B1F70430F70F5D8ED@SC-VEXCH1.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 21, 2014 at 08:50:02PM -0700, Bing Zhao wrote:
> Hi James,
> 
> > The work queue may execute after the device is suspended, leading to
> > SDIO register I/O over a suspend and resume of the system.  With a
> > WARN_ON in mwifiex_write_data_to_card we see:
> > 
> > [ 2115.351137] PM: suspend of devices complete after 15.989 msecs
> > [ 2115.366047] mwifiex_sdio mmc0:0001:1: mwifiex_write_data_sync: not allowed while suspended
> > [ 2115.366067] mwifiex_sdio mmc0:0001:1: host_to_card, write iomem (1) failed: -1
> > [ 2115.386023] PM: late suspend of devices complete after 34.845 msecs
> > [ 2115.386303] PM: noirq suspend of devices complete after 0.272 msecs
> > [ 2115.386388] before suspend
> > [ 2115.387824] after resume
> > [ 2115.388618] PM: noirq resume of devices complete after 0.745 msecs
> > [ 2115.407641] PM: early resume of devices complete after 18.849 msecs
> > [ 2125.397532] mmc0: Timeout waiting for hardware interrupt.
> > [ 2125.397559] mwifiex_sdio mmc0:0001:1: write CFG reg failed
> > [ 2125.397575] ------------[ cut here ]------------
> > [ 2125.397575] WARNING: at drivers/net/wireless/mwifiex/sdio.c:485
> > mwifiex_write_data_to_card+0x98/0xc4 [mwifiex_sdio]()
> > [ 2125.397746] [<bf0eb34c>] (mwifiex_host_to_card_mp_aggr+0x354/0x46c [mwifiex_sdio])
> > [ 2125.397746] [<bf0eb5f4>] (mwifiex_sdio_host_to_card+0x190/0x234 [mwifiex_sdio])
> > [ 2125.397788] [<bf0bed00>] (mwifiex_process_tx+0x90/0x1a0 [mwifiex])
> > [ 2125.397823] [<bf0bf8a0>] (mwifiex_send_single_packet+0x134/0x2b0 [mwifiex])
> > [ 2125.397857] [<bf0c074c>] (mwifiex_wmm_process_tx+0x76c/0x800 [mwifiex])
> > [ 2125.397887] [<bf0ba3f8>] (mwifiex_main_process+0x344/0x504 [mwifiex])
> > [ 2125.397913] [<bf0ba5e0>] (mwifiex_main_work_queue+0x28/0x2c [mwifiex])
> > [ 2125.397949] [<c00409fc>] (process_one_work+0x260/0x488)
> > [ 2125.397949] [<c0040e40>] (worker_thread+0x1e0/0x32c)
> > [ 2125.397979] [<c00464d0>] (kthread+0x9c/0xac)
> > [ 2125.397979] ---[ end trace 86d7b628a6c8ddd0 ]---
> > ---
> > 
> > Test environment is an OLPC XO-4 doing one sleep every few seconds,
> > with the device configured to wake the system, with constant ping by
> > another host.  Kernel is 3.5 with many backported mwifiex patches.
> > 
> > We also see that an SDIO interrupt from the device may occur after all
> > devices are suspended, leading to a similar symptom:
> 
> To understand what is happening here could you apply attached debug
> patch to generate logs, or enable dynamic_debug for that?

Thanks, will add that to plan for next work on the ticket.

> > [ 1292.887221] PM: suspend of devices complete after 21.990 msecs
> > [ 1292.922632] PM: late suspend of devices complete after 35.403 msecs
> > [ 1292.922901] PM: noirq suspend of devices complete after 0.001 msecs
> >                <-- here an mmc register read begins in sdio_irq_thread
> > [ 1292.923020] before suspend
> > [ 1292.953311] after resume
> > [ 1292.954106] PM: noirq resume of devices complete after 0.099 msecs
> > [ 1292.973124] PM: early resume of devices complete after 18.814 msecs
> > [ 1302.923009] mmc0: Timeout waiting for hardware interrupt.
> > [ 1302.923050] ------------[ cut here ]------------
> > [ 1302.923075] WARNING: at drivers/net/wireless/mwifiex/sdio.c:688 mwifiex_sdio_interrupt+0xcc/0x21c
> > [mwifiex_sdio]()
> > [ 1302.923204] [<bf0c089c>] (mwifiex_sdio_interrupt+0xcc/0x21c [mwifiex_sdio])
> > [ 1302.923218] [<c0302be4>] (sdio_irq_thread+0x178/0x2f0)
> > [ 1302.923218] [<c00464d0>] (kthread+0x9c/0xac)
> > [ 1302.923235] ---[ end trace 7e9f40af36cc200c ]---
> > [ 1302.923240] mwifiex_sdio mmc0:0001:1: read mp_regs failed, will retry ...
> > [ 1302.923291] mwifiex_sdio mmc0:0001:1: read mp_regs worked on retry
> 
> I guess the driver and firmware are out of sync here. If firmware is
> sleeping we will get this failure.

I'm a little alarmed at this possibility.  What you say implies an
interrupt from the device arrives after the firmware is in host sleep
mode, yet the device is not available to take the read mp_regs
transaction.  Have I understood correctly?

We never see this "mmc0: Timeout ..." _except_ when the host has gone
through suspend and resume, so it seemed more likely to be caused by
SDHCI.

> > [ 1303.554228] PM: resume of devices complete after 10581.100 msecs
> >                ^-- note how resume was delayed by mmc0 timeout
> > [ 1303.745395] Restarting tasks ... done.
> > [ 1312.943035] mwifiex_sdio mmc0:0001:1: mwifiex_cmd_timeout_func: Timeout cmd id (1400141716.779991)
> > = 0xe5, act = 0x1
> > 
> > I don't know how to fix this one yet; I don't know why the SDHCI
> > transaction fails, given the clocks remain running.
> 
> Are you able to get an SDIO Bus Analyzer capture?

No, sorry, I don't have such equipment.

> >  drivers/net/wireless/mwifiex/main.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
> > index 9c771b3..512ccd6 100644
> > --- a/drivers/net/wireless/mwifiex/main.c
> > +++ b/drivers/net/wireless/mwifiex/main.c
> > @@ -833,6 +833,8 @@ static void mwifiex_main_work_queue(struct work_struct *work)
> > 
> >  	if (adapter->surprise_removed)
> >  		return;
> > +	if (adapter->is_suspended)
> > +		return;
> 
> If we can find the root cause and fix it, this change won't be
> necessary.

Okay.  How will the work queue not be executed?

> 
> Thanks,
> Bing
> 
> >  	mwifiex_main_process(adapter);
> >  }
> > 
> 



-- 
James Cameron
http://quozl.linux.org.au/
