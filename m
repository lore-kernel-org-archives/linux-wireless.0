Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f43.google.com ([74.125.83.43]:35000 "EHLO
        mail-pg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751775AbdCPTjY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Mar 2017 15:39:24 -0400
Received: by mail-pg0-f43.google.com with SMTP id b129so29810630pgc.2
        for <linux-wireless@vger.kernel.org>; Thu, 16 Mar 2017 12:39:01 -0700 (PDT)
Date: Thu, 16 Mar 2017 12:38:58 -0700
From: Brian Norris <briannorris@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>, rajatja@google.com
Subject: Re: [PATCH v2] mwifiex: fix kernel crash after shutdown command
 timeout
Message-ID: <20170316193857.GB105900@google.com> (sfid-20170316_203928_130145_9DCD6F56)
References: <1489660132-27352-1-git-send-email-akarwar@marvell.com>
 <20170316183317.GA2935@dtor-ws>
 <20170316184115.GA105900@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170316184115.GA105900@google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dmitry and Amit,

On Thu, Mar 16, 2017 at 11:41:15AM -0700, Brian Norris wrote:
> On Thu, Mar 16, 2017 at 11:33:17AM -0700, Dmitry Torokhov wrote:
> > On Thu, Mar 16, 2017 at 03:58:52PM +0530, Amitkumar Karwar wrote:
> > > We observed a SHUTDOWN command timeout during reboot stress test
> > > due to a corner case firmware bug. It leads to use-after-free on
> > > adapter structure pointer and crash.
> > > 
> > > Let's add MWIFIEX_IFACE_WORK_DONT_RUN work flag to avoid executing

BTW, the 'DONT_RUN' suggestion was more of a pseudo-code suggestion than
a real name, but I guess it's not terrible :)

> > > any work scheduled after cancel_work_sync() call in teardown path
> > > to resolve the issue.
> > > 
> > > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> > > ---
> > > v2: New work_flag has been added to resolve the issue cleanly as per
> > > Brian's suggestion.
> > > ---
> > >  drivers/net/wireless/marvell/mwifiex/main.h | 1 +
> > >  drivers/net/wireless/marvell/mwifiex/pcie.c | 4 ++++
> > >  drivers/net/wireless/marvell/mwifiex/sdio.c | 4 ++++
> > >  3 files changed, 9 insertions(+)
> > > 
> > > diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
> > > index 5c82972..d5b1fd6 100644
> > > --- a/drivers/net/wireless/marvell/mwifiex/main.h
> > > +++ b/drivers/net/wireless/marvell/mwifiex/main.h
> > > @@ -510,6 +510,7 @@ struct mwifiex_roc_cfg {
> > >  enum mwifiex_iface_work_flags {
> > >  	MWIFIEX_IFACE_WORK_DEVICE_DUMP,
> > >  	MWIFIEX_IFACE_WORK_CARD_RESET,
> > > +	MWIFIEX_IFACE_WORK_DONT_RUN,
> > >  };
> > >  
> > >  struct mwifiex_private {
> > > diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
> > > index a0d9180..bb3d798 100644
> > > --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> > > +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> > > @@ -294,6 +294,7 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
> > >  	if (!adapter || !adapter->priv_num)
> > >  		return;
> > >  
> > > +	set_bit(MWIFIEX_IFACE_WORK_DONT_RUN, &card->work_flags);
> > >  	cancel_work_sync(&card->work);
> > >  
> > >  	reg = card->pcie.reg;
> > > @@ -2721,6 +2722,9 @@ static void mwifiex_pcie_work(struct work_struct *work)
> > >  	struct pcie_service_card *card =
> > >  		container_of(work, struct pcie_service_card, work);
> > >  
> > > +	if (test_bit(MWIFIEX_IFACE_WORK_DONT_RUN, &card->work_flags))
> > > +		return;
> > 
> > I do not see how this could possible prevent use-after-free, assuming
> > that the "card" memory is gone by the time mwifiex_pcie_work() gets to
> > run.
> 
> The 'card' memory isn't getting freed; it's the 'adapter' memory we're
> worried about. This is either already freed (because the FW init
> procedure failed), or else it's freed later in this function via
> mwifiex_remove_card().

I guess there was a slight miscommunication here: Dmitry pointed out to
me that he *was* actually talking about 'card' getting freed -- when it
gets freed after remove() finishes.

So the sequence would have to go like:

1. enter remove()
2. set DONT_RUN flag; cancel_work_sync()
3. begin to shutdown firmware
4. hit, e.g., a command timeout that schedules the work again
5. ** scheduler decides not to schedule the work for a while **
6. we finish mwifiex_remove_card(), and exit from remove() successfully
7. devm_* frees the pcie_service_card (and enclosed work_struct)
8. scheduler tries to run our work item
9. use-after-free!

However unlikely that the delay from 4 to 8 might be, this is indeed a
race condition.

> (We're also worried about having the FW dump race with the FW shutdown
> sequence, which can begin later in this function. This patch blocks both
> races AFAICT.)
> 
> > You need to check this flag before queueing firmware dump work, and
> > make sure it is not racy with setting this flag in mwifiex_pcie_remove()
> > (and sdio).
> 
> That's another approach that could work, but it's a little more
> invasive.

Never mind, that isn't too invasive. There's only one schedule_work() in
pcie.c and two in sdio.c. We could even factor out a helper, that knows
how to check the appropriate MWIFIEX_IFACE_* flags, if we really wanted
to...

Brian
