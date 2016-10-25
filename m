Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:34511 "EHLO
        mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932547AbcJYQyd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Oct 2016 12:54:33 -0400
Received: by mail-pf0-f169.google.com with SMTP id n85so5868302pfi.1
        for <linux-wireless@vger.kernel.org>; Tue, 25 Oct 2016 09:54:33 -0700 (PDT)
Date: Tue, 25 Oct 2016 09:54:30 -0700
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        "rajatja@google.com" <rajatja@google.com>,
        Xinming Hu <huxm@marvell.com>,
        "abhishekbh@google.com" <abhishekbh@google.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH v4 1/3] mwifiex: reset card->adapter during device
 unregister
Message-ID: <20161025165429.GA64548@google.com> (sfid-20161025_185446_638051_35F6A3CD)
References: <1475777186-20486-1-git-send-email-akarwar@marvell.com>
 <20161010205332.GB11254@localhost>
 <20161011002238.GC19969@localhost>
 <b1231f275ecc4e45a9c98dadb1d585f1@SC-EXCH04.marvell.com>
 <20161025005150.GA84310@google.com>
 <933ec70e65a6470ca0654d1a5b5c4496@SC-EXCH04.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <933ec70e65a6470ca0654d1a5b5c4496@SC-EXCH04.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Amit,

On Tue, Oct 25, 2016 at 03:12:44PM +0000, Amitkumar Karwar wrote:
> > From: Brian Norris [mailto:briannorris@chromium.org]
> > Sent: Tuesday, October 25, 2016 6:22 AM
> > To: Amitkumar Karwar
> > 
> > On Thu, Oct 20, 2016 at 01:11:31PM +0000, Amitkumar Karwar wrote:
> > > > From: Brian Norris [mailto:briannorris@chromium.org]
> > > > Sent: Tuesday, October 11, 2016 5:53 AM
> > > > To: Amitkumar Karwar
> > > >
> > > > On Mon, Oct 10, 2016 at 01:53:32PM -0700, Brian Norris wrote:
> > > > > On Thu, Oct 06, 2016 at 11:36:24PM +0530, Amitkumar Karwar wrote:
> > > > > > diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c
> > > > > > b/drivers/net/wireless/marvell/mwifiex/pcie.c
> > > > > > index f1eeb73..ba9e068 100644
> > > > > > --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> > > > > > +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> > > > > > @@ -3042,6 +3042,7 @@ static void mwifiex_unregister_dev(struct
> > > > mwifiex_adapter *adapter)
> > > > > >  				pci_disable_msi(pdev);
> > > > > >  	       }
> > > > > >  	}
> > > > > > +	card->adapter = NULL;
> > > > > >  }
> > > > > >
> > > > > >  /* This function initializes the PCI-E host memory space, WCB
> > > > rings, etc.
> > > > > > diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c
> > > > > > b/drivers/net/wireless/marvell/mwifiex/sdio.c
> > > > > > index 8718950..4cad1c2 100644
> > > > > > --- a/drivers/net/wireless/marvell/mwifiex/sdio.c
> > > > > > +++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
> > > > > > @@ -2066,6 +2066,7 @@ mwifiex_unregister_dev(struct
> > > > > > mwifiex_adapter
> > > > *adapter)
> > > > > >  	struct sdio_mmc_card *card = adapter->card;
> > > > > >
> > > > > >  	if (adapter->card) {
> > > > > > +		card->adapter = NULL;
> > > > > >  		sdio_claim_host(card->func);
> > > > > >  		sdio_disable_func(card->func);
> > > > > >  		sdio_release_host(card->func);
> > > > >

[...]

> > > Thanks for your comments.
> > >
> > > Actually description for this patch was ambiguous and incorrect. Sorry
> > > for that. This patch doesn't fix any race. In fact, we don't have a
> > > race between init and remove threads due to semaphore usage as per
> > > design. This patch just adds missing "card->adapter=NULL" so that when
> > > teardown/remove thread starts after init failure, it won't try freeing
> > > already freed things.
> > 
> > So to be clear, you'r talking about mwifiex_fw_dpc(), which in the error
> > path
> > has:
> > 
> >        if (adapter->if_ops.unregister_dev)
> >                 adapter->if_ops.unregister_dev(adapter); <--- POINT A:
> > This is where you want to set ->adapter = NULL ...
> >         if (init_failed)
> >                 mwifiex_free_adapter(adapter);
> >         up(sem); <--- POINT B: This is where you release the semaphore,
> > which is supposed to guarantee that remove() isn't happening
> >         return;
> > }
> > 
> > But you *do* have a race between the above code and the remove code in
> > some cases. Particularly, see this:
> > 
> > static void mwifiex_pcie_remove(struct pci_dev *pdev) {
> >         struct pcie_service_card *card;
> >         struct mwifiex_adapter *adapter;
> >         struct mwifiex_private *priv;
> > 
> >         card = pci_get_drvdata(pdev);
> >         if (!card)
> >                 return;
> > 
> >         adapter = card->adapter; <--- POINT C: This can execute at the
> > same time as unregister_dev()
> >         if (!adapter || !adapter->priv_num)
> >                 return;
> > 
> >         if (user_rmmod && !adapter->mfg_mode) { #ifdef CONFIG_PM_SLEEP
> >                 if (adapter->is_suspended)
> >                         mwifiex_pcie_resume(&pdev->dev); #endif
> > 
> >                 mwifiex_deauthenticate_all(adapter);
> > 
> >                 priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
> > 
> >                 mwifiex_disable_auto_ds(priv);
> > 
> >                 mwifiex_init_shutdown_fw(priv, MWIFIEX_FUNC_SHUTDOWN);
> >         }
> > 
> >         mwifiex_remove_card(card->adapter, &add_remove_card_sem); <---
> > POINT D: You only grab the semaphore here }
> > 
> > So IIUC, you have a race **even here, where you claim the semaphore
> > should protect you** such that the adapter might be freed, but you still
> > can access it anywhere between C and D. i.e., you can see this:
> > 
> > Thread 1                              Thread 2
> >                                       (1) POINT C (retrieve adapter !=
> > NULL)
> > (2) POINT A (set adapter NULL)
> > (3) POINT B (adapter has been freed)
> >                                       (3) ....Keep accessing freed
> > adapter structure
> >                                       (4) POINT D - acquire semaphore,
> > but we're too late
> > 
> > Step 3 is an error, and AFAICT, that's exactly what you're trying to
> > solve in this patch. It essentially comes down to the same fact: you're
> > getting a reference to the adapter structure *without* any protection at
> > all. Your add_remove_card_sem is *almost* the right thing to resolve
> > this, but you still don't have the ordering quite right.
> 
> Code between POINT C and POINT D won't come into picture for "init +
> reboot" scenario(Case 1 below) which we are talking here. Reason is
> "user_rmmod" flag will be false.

Wait, but doesn't mwifiex_pcie_shutdown() set 'user_rmmod = 1'? And
whether or not user_rmmod is set, you still have a problem. See below.

> Basically we have 3 teardown cases
> 1) System shutdown (or manually remove wifi card) -- Only mwifiex_pcie_remove() gets called.

This is wrong, due to above. But that isn't key either. Still see below.

> 2) User unloading the driver -- mwifiex_pcie_cleanup_module() followed by mwifiex_pcie_remove() gets called.

This case is sort of OK, because you grab the semaphore first in this
function. (You then release it, but that's a different problem. Probably
not going to cause problems, but it still feels wrong.)

> 3) Chip isn't connected. User unloaded the driver -- Only mwifiex_pcie_cleanup_module() gets 
> called.
> 
> In case 2, we have already waited for semaphore in
> mwifiex_pcie_cleanup_module(). So by the time we execute
> mwifiex_pcie_remove(), "card->adapter" is NULL.

Yes, that's (mostly) fine.

> Case 3, doesn't use "card->adapter"

That case is fine.

But you haven't addressed 1 properly. Whether or not you have user_rmmod
= 1, you still have this code that uses adapter:

        if (!adapter || !adapter->priv_num)
                return;

The ->priv_num dereference can be a user-after-free.

You also have the problem below which you argue is "very small." That's
not a real argument. At large enough scale, "small" problems become
noticeable. And with sufficiently complicated compilers and/or
out-of-order parallel processors, races can become issues later, even if
they aren't today. So wrong code is wrong.

> > Maybe you could solve this all by acquiring the semaphore in suspend(),
> > remove(), shutdown(), before you ever acquire the card->adapter? If you
> > do that first (to fix the race), and only *then* do you submit the
> > $subject patch, then you might have fixed all the races in question (at
> > least between FW init and {suspend,resume,remove,shutdown} -- you have
> > plenty of other races still, both known and unknown).
> 
> "add_remove_card_sem" is used only for init and teardown threads as
> per our design. V5 4/4 takes care of race between "init fail +
> suspend". Please let us know if you see any other race situation.

No, patch 4 does not handle the problem. It's almost exactly the same
problem as I'm trying to describe here. But it's becoming more and more
clear that you do not understand the problem here. Let's focus on this
patch, and then we can try and shift our gaze to your other problems.

> > 
> > [[ Also, a side note on POINT D: it's possible that even though you're
> > retrieving card->adapter in the argument to that function call, it's
> > possible the compiler will notice that this is redundant with the
> > retrieval at POINT C and just use that one. But even if not, there's a
> > window between "retrieve function argument" and "grab semaphore in
> > mwifiex_remove_card()". ]]
> 
> I had not considered that compiler will notice this is redundant and
> use "card->adapter" assigned at POINT C.

Compiler optimization isn't really the point here. Even if the compiler
doesn't coalesce these dereferences, you have a problem.

> But this window is very small compared to the window between in
> "card->adapter = NULL" and releasing semaphore in
> other(mwifiex_fw_dpc()) thread.

I can't even listen to that argument. A "small window" of incorrectness
is still incorrect.

> Even if "card->adapter" is set to NULL in mwifiex_fw_dpc() after we
> checked it at POINT C, we will return from mwifiex_remove_card()
> without grabing semaphore. mwifiex_fw_dpc() wouldn't have released the
> semaphore at that point of time.

Did you read my sequence? Remember things are happening concurrently.
But I claimed that we can have this overall interleaving of events:

C -> A -> B -> D

Remember that 'adapter' is freed between A and B, and the semaphore is
released right at B. So D is free to both grab the semaphore and
dereference the 'adapter' pointer that we read in POINT C.

Note that this all works exactly the same even if POINT C is instead
moved to POINT C-prime at the end of mwifiex_pcie_remove():

	mwifiex_remove_card(card->adapter, <--- POINT C-prime - where we read card->adapter again
			&add_remove_card_sem);

The key point that I hope you're understanding here is you have no
synchronization between the end of the mwifiex_fw_dpc() thread and the
start of grabbing your 'adapter' pointer. So even if you do some kind of
synchronization *afterward*, it's pointless -- you already are planning
on using a pointer to freed memory.


> mwifiex_fw_dpc() will take care of performing cleanup.
> > 
> > ---
> > 
> > BTW I'm gonna sidetrack us here... what's up with this code, in pcie.c?
> > 
> >         if (!down_interruptible(&add_remove_card_sem))
> >                 up(&add_remove_card_sem);
> > 
> > I can understand that you want to grab the semaphore for the remove
> > code, but why do you want to immediately release it? If you release it,
> > that must mean that someone else is trying to get it. And they won't
> > notice that you're tearing down the device... 
> 
> I don't see any problem in releasing the semaphore here. Only other
> thread which can acquire this semaphore is "init" thread.
> "init" thread won't get called when user is unloading the driver.

If no one can acquire it, then why are you releasing it? Seems
unnecessary, and borderline wrong.

> The purpose of immediately releasing it is we just wanted to wait
> until init is completed if it's running.

That's not a reason for releasing it. That's a reason for acquiring it.

> >(Also, why aren't you
> > handling the interrupted case?)
> 
> The cleanup performed in this function is done without touching
> hardware OR referring adapter/card etc. It can be done even for the
> interrupted case.

Uh, but if you're interrupted, that means you *didn't* wait for the
other thread to complete. So all the safety about use-after-free that
we're trying to work on gets thrown away...

Seems like a case where either you don't use the interruptible version,
or else you should return an error like -EBUSY.

> > > I have updated patch description in v5 series.
> > >
> > > You are right. We may have a race between init failure and suspend
> > > thread. I have prepared 4th patch in my v5 series to address this.
> > >
> > > >
> > > > I'm going to look into converting to asynchronous device probing,
> > > > which might remove the need for async FW request, and would
> > > > therefore resolve both patch 1 and 3's races without any additional
> > > > complicated hacks. But I'm not sure if that will satisfy all mwifiex
> > > > users well enough. I'll have to give it a little more thought. Any
> > > > thoughts from your side, Amit?
> > > >
> > >
> > > This is not needed.
> > 
> > Yeah, I ended up deciding this really wasn't that great of a solution.
> > For one, you also need to do firmware reloads for your PCIe reset
> > handling, and this happens in parallel to any device suspend. So:
> > (a) I'd bet that has plenty of race conditions and
> > (b) that means we can't just "load the firmware synchronously once and
> > forget about it"
> > 
> > > 4th patch in V5 series would take care of this race.
> > 
> > No, patch 4 does not handle this race, and it doesn't handle the race I
> > point out above either. You still can get a pointer card->adapter and
> > then see another thread subsequently free() it out from under you.
> 
> We have used spinlock in v5 4/4 to guard "card->adapter".
> Please help me understand if it doesn't handle the race between "init fail" + suspend.

I think you do. But I'll have to get to that later. We have enough
problems here.

Brian
