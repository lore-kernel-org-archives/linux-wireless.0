Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:32841 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750977AbdCOOLD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Mar 2017 10:11:03 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Brian Norris <briannorris@chromium.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        "rajatja@google.com" <rajatja@google.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: Re: [PATCH] mwifiex: fix kernel crash after shutdown command timeout
Date: Wed, 15 Mar 2017 14:10:59 +0000
Message-ID: <6e50b96fbc2b43bab43a08d7a3f6307d@SC-EXCH04.marvell.com> (sfid-20170315_151145_713289_7D5D9AA2)
References: <1487942964-3193-1-git-send-email-akarwar@marvell.com>
 <20170314183306.GA55602@google.com>
In-Reply-To: <20170314183306.GA55602@google.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: Brian Norris [mailto:briannorris@chromium.org]
> Sent: Wednesday, March 15, 2017 12:03 AM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam;
> rajatja@google.com; dmitry.torokhov@gmail.com
> Subject: [EXT] Re: [PATCH] mwifiex: fix kernel crash after shutdown
> command timeout
>  
> On Fri, Feb 24, 2017 at 06:59:24PM +0530, Amitkumar Karwar wrote:
> > We observed a SHUTDOWN command timeout during reboot stress test due
> > to a corner case firmware bug. It leads to use-after-free on adapter
> > structure pointer and crash.
> >
> > We already have a cancel_work_sync() call in teardown thread. This
> > issue is fixed by having this call just before mwifiex_remove_card().
> > At this point no further work will be scheduled.
> >
> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> > Signed-off-by: Cathy Luo <cluo@marvell.com>
> 
> I'm testing this artificially by testing things like this concurrently:
> 
> rmmod mwifiex_pcie &
> cat /sys/kernel/debug/mwifiex/mlan0/device_dump
> 
> I'm using a 4.4-based kernel (plus quite a few backports) at the moment
> and I'm having problems (I can retest on upstream if really needed),
> and pretty sure this patch is buggy.
> 
> > ---
> >  drivers/net/wireless/marvell/mwifiex/pcie.c | 3 +--
> > drivers/net/wireless/marvell/mwifiex/sdio.c | 3 +--
> >  2 files changed, 2 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c
> > b/drivers/net/wireless/marvell/mwifiex/pcie.c
> > index a0d9180..f31c5ea 100644
> > --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> > +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> > @@ -294,8 +294,6 @@ static void mwifiex_pcie_remove(struct pci_dev
> *pdev)
> >  	if (!adapter || !adapter->priv_num)
> >  		return;
> >
> > -	cancel_work_sync(&card->work);
> > -
> >  	reg = card->pcie.reg;
> >  	if (reg)
> >  		ret = mwifiex_read_reg(adapter, reg->fw_status,
> &fw_status); @@
> > -312,6 +310,7 @@ static void mwifiex_pcie_remove(struct pci_dev
> *pdev)
> >  		mwifiex_init_shutdown_fw(priv, MWIFIEX_FUNC_SHUTDOWN);
> >  	}
> >
> > +	cancel_work_sync(&card->work);
> 
> I don't think we want to move the cancellation to be this far; see the
> mwifiex_init_shutdown_fw() above! If I add a msleep(3000) below this,
> then run:
> 
>   rmmod mwifiex_pcie & sleep 0.5; cat
> /sys/kernel/debug/mwifiex/mlan0/device_dump
> 
> I can trigger an abort in mwifiex_pcie_rdwr_firmware(). The problem is
> that you still allow a command timeout + firmware dump worker to still
> race with the shutdown -- in this case, I think it's
> mwifiex_init_shutdown_fw() that's disabling the device.
> 
> I think the real solution is to, somewhere before we shutdown the
> firmware, *really* prevent any further work to be scheduled to &card-
> >work. Maybe that means adding another flag so that the worker will
> just abort quickly in that case? So it's something like:
> 
> 	card->worker_flags |= DONT_RUN_ANY_MORE;
> 	cancel_work_sync(&card->work);
> 
> 	... (this can be done either above the FIRMWARE_READY_PCIE
> 	check, or else you need to write a different version for
> 	FIRMWARE_READY_PCIE vs. !FIRMWARE_READY_PCIE) ... but definitely
> 	before mwifiex_init_shutdown_fw() ) ...
> 
> And in mwifiex_pcie_work():
> 
> 	if (card->worker_flags & DONT_RUN_ANY_MORE)
> 		return;
> 

Thanks for the review.
You are right. This can be cleanly fixed with a extra worker flag(DONT_RUN_ANY_MORE)
I will submit updated version with this approach.

Regards,
Amitkumar
