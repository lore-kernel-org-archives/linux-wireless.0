Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34202 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938295AbcJYQ47 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Oct 2016 12:56:59 -0400
Received: by mail-pf0-f193.google.com with SMTP id 128so20165480pfz.1
        for <linux-wireless@vger.kernel.org>; Tue, 25 Oct 2016 09:56:59 -0700 (PDT)
Date: Tue, 25 Oct 2016 09:56:55 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Brian Norris <briannorris@chromium.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        "rajatja@google.com" <rajatja@google.com>,
        Xinming Hu <huxm@marvell.com>,
        "abhishekbh@google.com" <abhishekbh@google.com>
Subject: Re: [PATCH v4 1/3] mwifiex: reset card->adapter during device
 unregister
Message-ID: <20161025165655.GD10979@dtor-ws> (sfid-20161025_185703_380277_9E907B7C)
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

On Tue, Oct 25, 2016 at 03:12:44PM +0000, Amitkumar Karwar wrote:
> Hi Brian,
> 
> Thanks for review.
> 
> > From: Brian Norris [mailto:briannorris@chromium.org]
> > Sent: Tuesday, October 25, 2016 6:22 AM
> > To: Amitkumar Karwar
> > Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam;
> > rajatja@google.com; Xinming Hu; abhishekbh@google.com; Dmitry Torokhov
> > Subject: Re: [PATCH v4 1/3] mwifiex: reset card->adapter during device
> > unregister
> > 
> > Hi Amit,
> > 
> > On Thu, Oct 20, 2016 at 01:11:31PM +0000, Amitkumar Karwar wrote:
> > > > From: Brian Norris [mailto:briannorris@chromium.org]
> > > > Sent: Tuesday, October 11, 2016 5:53 AM
> > > > To: Amitkumar Karwar
> > > > Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam;
> > > > rajatja@google.com; Xinming Hu; abhishekbh@google.com; Dmitry
> > > > Torokhov
> > > > Subject: Re: [PATCH v4 1/3] mwifiex: reset card->adapter during
> > > > device unregister
> > > >
> > > > On Mon, Oct 10, 2016 at 01:53:32PM -0700, Brian Norris wrote:
> > > > > On Thu, Oct 06, 2016 at 11:36:24PM +0530, Amitkumar Karwar wrote:
> > > > > > From: Xinming Hu <huxm@marvell.com>
> > > > > >
> > > > > > card->adapter gets initialized during device registration.
> > > > > > As it's not cleared, we may end up accessing invalid memory in
> > > > > > some corner cases. This patch fixes the problem.
> > > > > >
> > > > > > Signed-off-by: Xinming Hu <huxm@marvell.com>
> > > > > > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> > > > > > ---
> > > > > > v4: Same as v1, v2, v3
> > > > > > ---
> > > > > >  drivers/net/wireless/marvell/mwifiex/pcie.c | 1 +
> > > > > > drivers/net/wireless/marvell/mwifiex/sdio.c | 1 +
> > > > > >  2 files changed, 2 insertions(+)
> > > > > >
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
> > > > > As discussed on v1, I had qualms about the raciness between
> > > > > reads/writes of card->adapter, but I believe we:
> > > > > (a) can't have any command activity while writing the ->adapter
> > > > > field (either we're just init'ing the device, or we've disabled
> > > > > interrupts and are tearing it down) and
> > > > > (b) can't have a race between suspend()/resume() and
> > > > > unregister_dev(), since unregister_dev() is called from device
> > > > > remove() (which should not be concurrent with suspend()).
> > > > >
> > > > > Also, I thought you had the same problem in usb.c, but in fact,
> > > > > you fixed that ages ago here:
> > > > >
> > > > > 353d2a69ea26 mwifiex: fix issues in driver unload path for USB
> > > > > chipsets
> > > > >
> > > > > Would be nice if fixes were bettery synchronized across the three
> > > > > interface drivers you support. We seem to be discovering
> > > > > unnecessary divergence on a few points recently.
> > > > >
> > > > > At any rate:
> > > > >
> > > > > Reviewed-by: Brian Norris <briannorris@chromium.org>
> > > > > Tested-by: Brian Norris <briannorris@chromium.org>
> > > >
> > > > Dmitry helped me re-realize my original qualms:
> > > >
> > > > mwifiex_unregister_dev() is called in the failure path for your
> > > > async FW request, and so it may race with suspend(). So I retract my
> > Reviewed-by.
> > > > Sorry.
> > >
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
> Code between POINT C and POINT D won't come into picture for "init + reboot" scenario(Case 1 below) which we are talking here. Reason is "user_rmmod" flag will be false.
> 
> Basically we have 3 teardown cases
> 1) System shutdown (or manually remove wifi card) -- Only mwifiex_pcie_remove() gets called.
> 2) User unloading the driver -- mwifiex_pcie_cleanup_module() followed by mwifiex_pcie_remove() gets called.
> 3) Chip isn't connected. User unloaded the driver -- Only mwifiex_pcie_cleanup_module() gets 
> called.
> 
> In case 2, we have already waited for semaphore in mwifiex_pcie_cleanup_module(). So by the time we execute mwifiex_pcie_remove(), "card->adapter" is NULL.
> Case 3, doesn't use "card->adapter"

Case 4: echo "0000:03:00.0" > /sys/bus/pci/drivers/mwifiex/unbind

This does not play with the semaphore, does not resume device, does
not deauthenticate calls, etc, races happily with another thread.

By the way, "saving" adapter for the dump is not nice if you unbind it
in the mean time. Your pcie_work may be executing after
mwifiex_pcie_remove() is called.

Thanks.

-- 
Dmitry
