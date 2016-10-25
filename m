Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:34984 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755062AbcJYAvy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Oct 2016 20:51:54 -0400
Received: by mail-pf0-f176.google.com with SMTP id s8so107951717pfj.2
        for <linux-wireless@vger.kernel.org>; Mon, 24 Oct 2016 17:51:54 -0700 (PDT)
Date: Mon, 24 Oct 2016 17:51:51 -0700
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
Message-ID: <20161025005150.GA84310@google.com> (sfid-20161025_025159_424371_7F3F6CBE)
References: <1475777186-20486-1-git-send-email-akarwar@marvell.com>
 <20161010205332.GB11254@localhost>
 <20161011002238.GC19969@localhost>
 <b1231f275ecc4e45a9c98dadb1d585f1@SC-EXCH04.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b1231f275ecc4e45a9c98dadb1d585f1@SC-EXCH04.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Amit,

On Thu, Oct 20, 2016 at 01:11:31PM +0000, Amitkumar Karwar wrote:
> > From: Brian Norris [mailto:briannorris@chromium.org]
> > Sent: Tuesday, October 11, 2016 5:53 AM
> > To: Amitkumar Karwar
> > Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam;
> > rajatja@google.com; Xinming Hu; abhishekbh@google.com; Dmitry Torokhov
> > Subject: Re: [PATCH v4 1/3] mwifiex: reset card->adapter during device
> > unregister
> > 
> > On Mon, Oct 10, 2016 at 01:53:32PM -0700, Brian Norris wrote:
> > > On Thu, Oct 06, 2016 at 11:36:24PM +0530, Amitkumar Karwar wrote:
> > > > From: Xinming Hu <huxm@marvell.com>
> > > >
> > > > card->adapter gets initialized during device registration.
> > > > As it's not cleared, we may end up accessing invalid memory in some
> > > > corner cases. This patch fixes the problem.
> > > >
> > > > Signed-off-by: Xinming Hu <huxm@marvell.com>
> > > > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> > > > ---
> > > > v4: Same as v1, v2, v3
> > > > ---
> > > >  drivers/net/wireless/marvell/mwifiex/pcie.c | 1 +
> > > > drivers/net/wireless/marvell/mwifiex/sdio.c | 1 +
> > > >  2 files changed, 2 insertions(+)
> > > >
> > > > diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c
> > > > b/drivers/net/wireless/marvell/mwifiex/pcie.c
> > > > index f1eeb73..ba9e068 100644
> > > > --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> > > > +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> > > > @@ -3042,6 +3042,7 @@ static void mwifiex_unregister_dev(struct
> > mwifiex_adapter *adapter)
> > > >  				pci_disable_msi(pdev);
> > > >  	       }
> > > >  	}
> > > > +	card->adapter = NULL;
> > > >  }
> > > >
> > > >  /* This function initializes the PCI-E host memory space, WCB
> > rings, etc.
> > > > diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c
> > > > b/drivers/net/wireless/marvell/mwifiex/sdio.c
> > > > index 8718950..4cad1c2 100644
> > > > --- a/drivers/net/wireless/marvell/mwifiex/sdio.c
> > > > +++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
> > > > @@ -2066,6 +2066,7 @@ mwifiex_unregister_dev(struct mwifiex_adapter
> > *adapter)
> > > >  	struct sdio_mmc_card *card = adapter->card;
> > > >
> > > >  	if (adapter->card) {
> > > > +		card->adapter = NULL;
> > > >  		sdio_claim_host(card->func);
> > > >  		sdio_disable_func(card->func);
> > > >  		sdio_release_host(card->func);
> > >
> > > As discussed on v1, I had qualms about the raciness between
> > > reads/writes of card->adapter, but I believe we:
> > > (a) can't have any command activity while writing the ->adapter field
> > > (either we're just init'ing the device, or we've disabled interrupts
> > > and are tearing it down) and
> > > (b) can't have a race between suspend()/resume() and unregister_dev(),
> > > since unregister_dev() is called from device remove() (which should
> > > not be concurrent with suspend()).
> > >
> > > Also, I thought you had the same problem in usb.c, but in fact, you
> > > fixed that ages ago here:
> > >
> > > 353d2a69ea26 mwifiex: fix issues in driver unload path for USB
> > > chipsets
> > >
> > > Would be nice if fixes were bettery synchronized across the three
> > > interface drivers you support. We seem to be discovering unnecessary
> > > divergence on a few points recently.
> > >
> > > At any rate:
> > >
> > > Reviewed-by: Brian Norris <briannorris@chromium.org>
> > > Tested-by: Brian Norris <briannorris@chromium.org>
> > 
> > Dmitry helped me re-realize my original qualms:
> > 
> > mwifiex_unregister_dev() is called in the failure path for your async FW
> > request, and so it may race with suspend(). So I retract my Reviewed-by.
> > Sorry.
> 
> Thanks for your comments.
> 
> Actually description for this patch was ambiguous and incorrect. Sorry
> for that. This patch doesn't fix any race. In fact, we don't have a
> race between init and remove threads due to semaphore usage as per
> design. This patch just adds missing "card->adapter=NULL" so that when
> teardown/remove thread starts after init failure, it won't try freeing
> already freed things.

So to be clear, you'r talking about mwifiex_fw_dpc(), which in the error path
has:

       if (adapter->if_ops.unregister_dev)
                adapter->if_ops.unregister_dev(adapter); <--- POINT A: This is where you want to set ->adapter = NULL
...
        if (init_failed)
                mwifiex_free_adapter(adapter);
        up(sem); <--- POINT B: This is where you release the semaphore, which is supposed to guarantee that remove() isn't happening
        return;
}

But you *do* have a race between the above code and the remove code in some
cases. Particularly, see this:

static void mwifiex_pcie_remove(struct pci_dev *pdev)
{
        struct pcie_service_card *card;
        struct mwifiex_adapter *adapter;
        struct mwifiex_private *priv;
        
        card = pci_get_drvdata(pdev);
        if (!card)
                return;

        adapter = card->adapter; <--- POINT C: This can execute at the same time as unregister_dev()
        if (!adapter || !adapter->priv_num)
                return;

        if (user_rmmod && !adapter->mfg_mode) {
#ifdef CONFIG_PM_SLEEP
                if (adapter->is_suspended)
                        mwifiex_pcie_resume(&pdev->dev);
#endif

                mwifiex_deauthenticate_all(adapter);

                priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);

                mwifiex_disable_auto_ds(priv);

                mwifiex_init_shutdown_fw(priv, MWIFIEX_FUNC_SHUTDOWN);
        }

        mwifiex_remove_card(card->adapter, &add_remove_card_sem); <--- POINT D: You only grab the semaphore here
}

So IIUC, you have a race **even here, where you claim the semaphore
should protect you** such that the adapter might be freed, but you still
can access it anywhere between C and D. i.e., you can see this:

Thread 1                              Thread 2
                                      (1) POINT C (retrieve adapter != NULL)
(2) POINT A (set adapter NULL)
(3) POINT B (adapter has been freed)
                                      (3) ....Keep accessing freed adapter structure
                                      (4) POINT D - acquire semaphore, but we're too late

Step 3 is an error, and AFAICT, that's exactly what you're trying to
solve in this patch. It essentially comes down to the same fact: you're
getting a reference to the adapter structure *without* any protection at
all. Your add_remove_card_sem is *almost* the right thing to resolve
this, but you still don't have the ordering quite right.

Maybe you could solve this all by acquiring the semaphore in suspend(),
remove(), shutdown(), before you ever acquire the card->adapter? If you
do that first (to fix the race), and only *then* do you submit the
$subject patch, then you might have fixed all the races in question (at
least between FW init and {suspend,resume,remove,shutdown} -- you have
plenty of other races still, both known and unknown).

[[ Also, a side note on POINT D: it's possible that even though you're
retrieving card->adapter in the argument to that function call, it's
possible the compiler will notice that this is redundant with the
retrieval at POINT C and just use that one. But even if not, there's a
window between "retrieve function argument" and "grab semaphore in
mwifiex_remove_card()". ]]

---

BTW I'm gonna sidetrack us here... what's up with this code, in pcie.c?

        if (!down_interruptible(&add_remove_card_sem))
                up(&add_remove_card_sem);

I can understand that you want to grab the semaphore for the remove code, but
why do you want to immediately release it? If you release it, that must
mean that someone else is trying to get it. And they won't notice that
you're tearing down the device... (Also, why aren't you handling the
interrupted case?)

> I have updated patch description in v5 series.
> 
> You are right. We may have a race between init failure and suspend
> thread. I have prepared 4th patch in my v5 series to address this.
> 
> > 
> > I'm going to look into converting to asynchronous device probing, which
> > might remove the need for async FW request, and would therefore resolve
> > both patch 1 and 3's races without any additional complicated hacks. But
> > I'm not sure if that will satisfy all mwifiex users well enough. I'll
> > have to give it a little more thought. Any thoughts from your side,
> > Amit?
> > 
> 
> This is not needed.

Yeah, I ended up deciding this really wasn't that great of a solution.
For one, you also need to do firmware reloads for your PCIe reset
handling, and this happens in parallel to any device suspend. So:
(a) I'd bet that has plenty of race conditions and
(b) that means we can't just "load the firmware synchronously once and
forget about it"

> 4th patch in V5 series would take care of this race.

No, patch 4 does not handle this race, and it doesn't handle the race I
point out above either. You still can get a pointer card->adapter and
then see another thread subsequently free() it out from under you.

> I will be posting v5 series shortly.

Nak to both v4 and v5. They're not substantially different.

Brian
