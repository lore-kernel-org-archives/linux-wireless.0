Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:12498 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751013AbaEWEMx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 00:12:53 -0400
From: Bing Zhao <bzhao@marvell.com>
To: "quozl@laptop.org" <quozl@laptop.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 22 May 2014 21:12:30 -0700
Subject: RE: [RFC] mwifiex: block work queue while suspended
Message-ID: <477F20668A386D41ADCC57781B1F70430F70F5DCA2@SC-VEXCH1.marvell.com> (sfid-20140523_061305_405492_CF4D11AE)
References: <20140516012439.GI15430@us.netrek.org>
 <477F20668A386D41ADCC57781B1F70430F70F5D8ED@SC-VEXCH1.marvell.com>
 <20140522054618.GL6184@us.netrek.org>
In-Reply-To: <20140522054618.GL6184@us.netrek.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi James,

> > > [ 1302.923009] mmc0: Timeout waiting for hardware interrupt.
> > > [ 1302.923050] ------------[ cut here ]------------
> > > [ 1302.923075] WARNING: at drivers/net/wireless/mwifiex/sdio.c:688
> mwifiex_sdio_interrupt+0xcc/0x21c
> > > [mwifiex_sdio]()
> > > [ 1302.923204] [<bf0c089c>] (mwifiex_sdio_interrupt+0xcc/0x21c [mwifiex_sdio])
> > > [ 1302.923218] [<c0302be4>] (sdio_irq_thread+0x178/0x2f0)
> > > [ 1302.923218] [<c00464d0>] (kthread+0x9c/0xac)
> > > [ 1302.923235] ---[ end trace 7e9f40af36cc200c ]---
> > > [ 1302.923240] mwifiex_sdio mmc0:0001:1: read mp_regs failed, will retry ...
> > > [ 1302.923291] mwifiex_sdio mmc0:0001:1: read mp_regs worked on retry
> >
> > I guess the driver and firmware are out of sync here. If firmware is
> > sleeping we will get this failure.
> 
> I'm a little alarmed at this possibility.  What you say implies an
> interrupt from the device arrives after the firmware is in host sleep
> mode, yet the device is not available to take the read mp_regs
> transaction.  Have I understood correctly?

No, that depends on that wakeup (device to host) is through GPIO or SDIO interface.
In case of SDIO wakeup, does the MMC call driver's interrupt routing first or resume handler first?
If MMC calls driver's ISR first, we will see an interrupt arrives after firmware is in host sleep mode.

> 
> We never see this "mmc0: Timeout ..." _except_ when the host has gone
> through suspend and resume, so it seemed more likely to be caused by
> SDHCI.

I overlooked this SDHCI error. So it could be the reason why read mp_regs failed.

> > > @@ -833,6 +833,8 @@ static void mwifiex_main_work_queue(struct work_struct *work)
> > >
> > >  	if (adapter->surprise_removed)
> > >  		return;
> > > +	if (adapter->is_suspended)
> > > +		return;
> >
> > If we can find the root cause and fix it, this change won't be
> > necessary.
> 
> Okay.  How will the work queue not be executed?

Actually I can take this change before we figure out what the real problem is.
For other users without this problem this code shouldn't get executed during suspended.
Please resend it as a [PATCH].

Thanks,
Bing


