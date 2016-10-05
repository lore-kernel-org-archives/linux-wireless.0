Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:36776 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754490AbcJEQlm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Oct 2016 12:41:42 -0400
Received: by mail-pf0-f175.google.com with SMTP id i85so39058285pfa.3
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2016 09:41:42 -0700 (PDT)
Date: Wed, 5 Oct 2016 09:41:38 -0700
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        "rajatja@google.com" <rajatja@google.com>,
        Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH v2 2/2] mwifiex: check hw_status in suspend and resume
 handlers
Message-ID: <20161005164138.GB54237@google.com> (sfid-20161005_184146_571182_04E06921)
References: <1475600905-2997-1-git-send-email-akarwar@marvell.com>
 <1475600905-2997-2-git-send-email-akarwar@marvell.com>
 <20161004210435.GA31652@localhost>
 <39b7881045ec42628a4ffa654840681e@SC-EXCH04.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <39b7881045ec42628a4ffa654840681e@SC-EXCH04.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Amit,

On Wed, Oct 05, 2016 at 12:26:36PM +0000, Amitkumar Karwar wrote:
> > From: Brian Norris [mailto:briannorris@chromium.org]
> > Sent: Wednesday, October 05, 2016 2:35 AM
> > To: Amitkumar Karwar
> > Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam;
> > rajatja@google.com; briannorris@google.com; Xinming Hu
> > Subject: Re: [PATCH v2 2/2] mwifiex: check hw_status in suspend and
> > resume handlers
> > 
> > On Tue, Oct 04, 2016 at 10:38:25PM +0530, Amitkumar Karwar wrote:
> > > From: Xinming Hu <huxm@marvell.com>
> > >
> > > We have observed a kernel crash when system immediately suspends after
> > > booting. There is a race between suspend and driver initialization
> > > paths.
> > > This patch adds hw_status checks to fix the problem
> > >
> > > Signed-off-by: Xinming Hu <huxm@marvell.com>
> > > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> > > ---
> > > v2: Return failure in suspend/resume handler in this scenario.
> > > ---
> > >  drivers/net/wireless/marvell/mwifiex/pcie.c | 10 ++++++----
> > >  1 file changed, 6 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c
> > > b/drivers/net/wireless/marvell/mwifiex/pcie.c
> > > index ba9e068..fa6bf85 100644
> > > --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> > > +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> > > @@ -122,9 +122,10 @@ static int mwifiex_pcie_suspend(struct device
> > > *dev)
> > >
> > >  	if (pdev) {
> > >  		card = pci_get_drvdata(pdev);
> > > -		if (!card || !card->adapter) {
> > > +		if (!card || !card->adapter ||
> > > +		    card->adapter->hw_status != MWIFIEX_HW_STATUS_READY) {
> > 
> > Wait, is there no locking on the 'hw_status' field? That is inherently
> > an unsafe race all on its own; you're not guaranteed that this will be
> > read/written atomically. And you also aren't guaranteed that writes to
> > this happen in the order they appear in the code -- in other words,
> > reading this flag doesn't necessarily guarantee that initialization is
> > actually complete (even if that's very likely to be true, given that
> > it's probably just a single-instruction word-access, and any prior HW
> > polling or interrupts likely have done some synchronization and can't be
> > reordered).
> > actually complete
> 
> Here is the brief info on how "hw_status" flag is updated.
> 1) It gets changed incrementally during initialization.
>     MWIFIEX_HW_STATUS_INITIALIZING -> MWIFIEX_HW_STATUS_INIT_DONE -> MWIFIEX_HW_STATUS_READY
> 
> 2) Status will remain READY once driver+firmware is up and running.
> 
> 3) Below is status during teardown
> MWIFIEX_HW_STATUS_READY -> MWIFIEX_HW_STATUS_RESET -> MWIFIEX_HW_STATUS_CLOSING -> MWIFIEX_HW_STATUS_NOT_READY
> 
> As the events occur one after another, we don't expect a race and
> don't need locking here for the flag. Flag status
> MWIFIEX_HW_STATUS_READY guarantees that initialization is completed.

It seems like, as with patch 1, you're mostly arguing about the writes
to this variable. But writes race with reads as well; how do you
guarantee that you're not seeing incorrect values of 'hw_status' here in
suspend() -- e.g., either old or new values of it, or even
partially-written values, if for some reason the compiler decides it
can't read/write this all in one go?

> In worst case scenario, only first system suspend attempt issued
> immediately after system boot will be aborted with BUSY error. I
> think, that should be fine.

(For the record, my concern about -EBUSY is separate from my concern
about the potential race condition.)

> Let me know if you have any concerns.

Sorry, I probably didn't completely flesh out my thought here.

I think I was concerned about a failed initialization causing the system
to never enter suspend again. So specifically: what happens if (e.g.)
the firmware fails to load? AFAICT, the device doesn't actually unbind
itself from the driver, so instead, you have a device in limbo that will
always return -EBUSY in suspend(), and your system can never again enter
suspend. Am I correct? If so, that doesn't sound great.

> > This is probably better than nothing, but it's not very good.
> > 
> > >  			pr_err("Card or adapter structure is not valid\n");
> > > -			return 0;
> > > +			return -EBUSY;
> > 
> > So the above cases all mean that the driver hasn't finished loading,
> > right?
> > 
> > !card => can't happen (PCIe probe() would have failed
> > mwifiex_add_card()), but fine to check
> 
> NULL "card" or "card->adapter" pointers are expected in below cases
> 1) Driver initialization failed after downloading the firmware. Driver is performing cleanup in init failure path. Now system suspends.
> 2) Race of teardown + suspend
>  
> > 
> > !card->adapter => only happens after patch 1; i.e., when tearing down
> > the device and detaching it from the driver
> > 
> > card->adapter->hw_status != MWIFIEX_HW_STATUS_READY => FW is not loaded
> > (i.e., in the process of starting or stopping FW?)
> > 
> > I guess all of those cases make sense to be -EBUSY.

^^ I'm second-guessing my claim here then.

> Yes. we can keep -EBUSY for all of the cases.

Brian
