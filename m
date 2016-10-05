Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:55920 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751404AbcJEM0p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Oct 2016 08:26:45 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Brian Norris <briannorris@chromium.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        "rajatja@google.com" <rajatja@google.com>,
        "briannorris@google.com" <briannorris@google.com>,
        Xinming Hu <huxm@marvell.com>
Subject: RE: [PATCH v2 2/2] mwifiex: check hw_status in suspend and resume
 handlers
Date: Wed, 5 Oct 2016 12:26:36 +0000
Message-ID: <39b7881045ec42628a4ffa654840681e@SC-EXCH04.marvell.com> (sfid-20161005_142649_373770_0F7563F7)
References: <1475600905-2997-1-git-send-email-akarwar@marvell.com>
 <1475600905-2997-2-git-send-email-akarwar@marvell.com>
 <20161004210435.GA31652@localhost>
In-Reply-To: <20161004210435.GA31652@localhost>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Brian,

Thanks for your thorough review.

> From: Brian Norris [mailto:briannorris@chromium.org]
> Sent: Wednesday, October 05, 2016 2:35 AM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam;
> rajatja@google.com; briannorris@google.com; Xinming Hu
> Subject: Re: [PATCH v2 2/2] mwifiex: check hw_status in suspend and
> resume handlers
> 
> Hi,
> 
> On Tue, Oct 04, 2016 at 10:38:25PM +0530, Amitkumar Karwar wrote:
> > From: Xinming Hu <huxm@marvell.com>
> >
> > We have observed a kernel crash when system immediately suspends after
> > booting. There is a race between suspend and driver initialization
> > paths.
> > This patch adds hw_status checks to fix the problem
> >
> > Signed-off-by: Xinming Hu <huxm@marvell.com>
> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> > ---
> > v2: Return failure in suspend/resume handler in this scenario.
> > ---
> >  drivers/net/wireless/marvell/mwifiex/pcie.c | 10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c
> > b/drivers/net/wireless/marvell/mwifiex/pcie.c
> > index ba9e068..fa6bf85 100644
> > --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> > +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> > @@ -122,9 +122,10 @@ static int mwifiex_pcie_suspend(struct device
> > *dev)
> >
> >  	if (pdev) {
> >  		card = pci_get_drvdata(pdev);
> > -		if (!card || !card->adapter) {
> > +		if (!card || !card->adapter ||
> > +		    card->adapter->hw_status != MWIFIEX_HW_STATUS_READY) {
> 
> Wait, is there no locking on the 'hw_status' field? That is inherently
> an unsafe race all on its own; you're not guaranteed that this will be
> read/written atomically. And you also aren't guaranteed that writes to
> this happen in the order they appear in the code -- in other words,
> reading this flag doesn't necessarily guarantee that initialization is
> actually complete (even if that's very likely to be true, given that
> it's probably just a single-instruction word-access, and any prior HW
> polling or interrupts likely have done some synchronization and can't be
> reordered).
> actually complete

Here is the brief info on how "hw_status" flag is updated.
1) It gets changed incrementally during initialization.
    MWIFIEX_HW_STATUS_INITIALIZING -> MWIFIEX_HW_STATUS_INIT_DONE -> MWIFIEX_HW_STATUS_READY

2) Status will remain READY once driver+firmware is up and running.

3) Below is status during teardown
MWIFIEX_HW_STATUS_READY -> MWIFIEX_HW_STATUS_RESET -> MWIFIEX_HW_STATUS_CLOSING -> MWIFIEX_HW_STATUS_NOT_READY

As the events occur one after another, we don't expect a race and don't need locking here for the flag. Flag status MWIFIEX_HW_STATUS_READY guarantees that initialization is completed.

In worst case scenario, only first system suspend attempt issued immediately after system boot will be aborted with BUSY error. I think, that should be fine.

Let me know if you have any concerns.

> 
> This is probably better than nothing, but it's not very good.
> 
> >  			pr_err("Card or adapter structure is not valid\n");
> > -			return 0;
> > +			return -EBUSY;
> 
> So the above cases all mean that the driver hasn't finished loading,
> right?
> 
> !card => can't happen (PCIe probe() would have failed
> mwifiex_add_card()), but fine to check

NULL "card" or "card->adapter" pointers are expected in below cases
1) Driver initialization failed after downloading the firmware. Driver is performing cleanup in init failure path. Now system suspends.
2) Race of teardown + suspend
 
> 
> !card->adapter => only happens after patch 1; i.e., when tearing down
> the device and detaching it from the driver
> 
> card->adapter->hw_status != MWIFIEX_HW_STATUS_READY => FW is not loaded
> (i.e., in the process of starting or stopping FW?)
> 
> I guess all of those cases make sense to be -EBUSY.

Yes. we can keep -EBUSY for all of the cases.

> 
> >  		}
> >  	} else {
> >  		pr_err("PCIE device is not specified\n");
> 
> I was going to complain about this branch (!pdev) returning 0, since
> that looked asymmetric. But this case will never happen, actually, since
> to_pci_dev() is just doing struct offset arithmetic on struct device,
> and struct device is never going to be NULL. It probably makes more
> sense to just remove this branch entirely, but that's for another patch.

Thanks for pointing this out. I will create separate patch for this.

> 
> > @@ -166,9 +167,10 @@ static int mwifiex_pcie_resume(struct device
> > *dev)
> >
> >  	if (pdev) {
> >  		card = pci_get_drvdata(pdev);
> > -		if (!card || !card->adapter) {
> > +		if (!card || !card->adapter ||
> > +		    card->adapter->hw_status != MWIFIEX_HW_STATUS_READY) {
> 
> Same complaint, except if you've screwed up here, you probably already
> screwed up in suspend().
> 
> Brian
> 
> >  			pr_err("Card or adapter structure is not valid\n");
> > -			return 0;
> > +			return -EBUSY;
> >  		}
> >  	} else {
> >  		pr_err("PCIE device is not specified\n");
> > --
> > 1.9.1
> >

Regards,
Amitkumar
