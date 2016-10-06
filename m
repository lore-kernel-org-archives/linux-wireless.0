Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:33123 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752899AbcJFR2V (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Oct 2016 13:28:21 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Brian Norris <briannorris@chromium.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        "rajatja@google.com" <rajatja@google.com>,
        Xinming Hu <huxm@marvell.com>
Subject: RE: [PATCH v2 2/2] mwifiex: check hw_status in suspend and resume
 handlers
Date: Thu, 6 Oct 2016 17:28:16 +0000
Message-ID: <8034f06fde284121a50552d697c3bf87@SC-EXCH04.marvell.com> (sfid-20161006_192844_880477_A5B4B19D)
References: <1475600905-2997-1-git-send-email-akarwar@marvell.com>
 <1475600905-2997-2-git-send-email-akarwar@marvell.com>
 <20161004210435.GA31652@localhost>
 <39b7881045ec42628a4ffa654840681e@SC-EXCH04.marvell.com>
 <20161005164138.GB54237@google.com>
In-Reply-To: <20161005164138.GB54237@google.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Brain,

> From: Brian Norris [mailto:briannorris@chromium.org]
> Sent: Wednesday, October 05, 2016 10:12 PM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam;
> rajatja@google.com; Xinming Hu
> Subject: Re: [PATCH v2 2/2] mwifiex: check hw_status in suspend and
> resume handlers
> 
> Hi Amit,
> 
> On Wed, Oct 05, 2016 at 12:26:36PM +0000, Amitkumar Karwar wrote:
> > > From: Brian Norris [mailto:briannorris@chromium.org]
> > > Sent: Wednesday, October 05, 2016 2:35 AM
> > > To: Amitkumar Karwar
> > > Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam;
> > > rajatja@google.com; briannorris@google.com; Xinming Hu
> > > Subject: Re: [PATCH v2 2/2] mwifiex: check hw_status in suspend and
> > > resume handlers
> > >
> > > On Tue, Oct 04, 2016 at 10:38:25PM +0530, Amitkumar Karwar wrote:
> > > > From: Xinming Hu <huxm@marvell.com>
> > > >
> > > > We have observed a kernel crash when system immediately suspends
> > > > after booting. There is a race between suspend and driver
> > > > initialization paths.
> > > > This patch adds hw_status checks to fix the problem
> > > >
> > > > Signed-off-by: Xinming Hu <huxm@marvell.com>
> > > > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> > > > ---
> > > > v2: Return failure in suspend/resume handler in this scenario.
> > > > ---
> > > >  drivers/net/wireless/marvell/mwifiex/pcie.c | 10 ++++++----
> > > >  1 file changed, 6 insertions(+), 4 deletions(-)
> > > >
> > > > diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c
> > > > b/drivers/net/wireless/marvell/mwifiex/pcie.c
> > > > index ba9e068..fa6bf85 100644
> > > > --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> > > > +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> > > > @@ -122,9 +122,10 @@ static int mwifiex_pcie_suspend(struct device
> > > > *dev)
> > > >
> > > >  	if (pdev) {
> > > >  		card = pci_get_drvdata(pdev);
> > > > -		if (!card || !card->adapter) {
> > > > +		if (!card || !card->adapter ||
> > > > +		    card->adapter->hw_status !=
> MWIFIEX_HW_STATUS_READY) {
> > >
> > > Wait, is there no locking on the 'hw_status' field? That is
> > > inherently an unsafe race all on its own; you're not guaranteed that
> > > this will be read/written atomically. And you also aren't guaranteed
> > > that writes to this happen in the order they appear in the code --
> > > in other words, reading this flag doesn't necessarily guarantee that
> > > initialization is actually complete (even if that's very likely to
> > > be true, given that it's probably just a single-instruction
> > > word-access, and any prior HW polling or interrupts likely have done
> > > some synchronization and can't be reordered).
> > > actually complete
> >
> > Here is the brief info on how "hw_status" flag is updated.
> > 1) It gets changed incrementally during initialization.
> >     MWIFIEX_HW_STATUS_INITIALIZING -> MWIFIEX_HW_STATUS_INIT_DONE ->
> > MWIFIEX_HW_STATUS_READY
> >
> > 2) Status will remain READY once driver+firmware is up and running.
> >
> > 3) Below is status during teardown
> > MWIFIEX_HW_STATUS_READY -> MWIFIEX_HW_STATUS_RESET ->
> > MWIFIEX_HW_STATUS_CLOSING -> MWIFIEX_HW_STATUS_NOT_READY
> >
> > As the events occur one after another, we don't expect a race and
> > don't need locking here for the flag. Flag status
> > MWIFIEX_HW_STATUS_READY guarantees that initialization is completed.
> 
> It seems like, as with patch 1, you're mostly arguing about the writes
> to this variable. But writes race with reads as well; how do you
> guarantee that you're not seeing incorrect values of 'hw_status' here in
> suspend() -- e.g., either old or new values of it, or even partially-
> written values, if for some reason the compiler decides it can't
> read/write this all in one go?

Got it. I think, we need to define "hw_status" as atomic variable to resolve the issue. I will create separate patch for this.

> 
> > In worst case scenario, only first system suspend attempt issued
> > immediately after system boot will be aborted with BUSY error. I
> > think, that should be fine.
> 
> (For the record, my concern about -EBUSY is separate from my concern
> about the potential race condition.)
> 
> > Let me know if you have any concerns.
> 
> Sorry, I probably didn't completely flesh out my thought here.
> 
> I think I was concerned about a failed initialization causing the system
> to never enter suspend again. So specifically: what happens if (e.g.)
> the firmware fails to load? AFAICT, the device doesn't actually unbind
> itself from the driver, so instead, you have a device in limbo that will
> always return -EBUSY in suspend(), and your system can never again enter
> suspend. Am I correct? If so, that doesn't sound great.

You are right. I will add an extra check for this so that both the cases would be handled
Case 1:
	Firmware has gone bad or has failed to initialize. We will return zero here, so that it won't block subsequent suspend attempts.
Case 2:
	Init or teardown is in process. We will return -EBUSY here. Next suspend attempt would be successful.

I will submit v3 with these changes shortly.

Regards,
Amitkumar
