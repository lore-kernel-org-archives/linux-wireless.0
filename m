Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:48302 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750922AbcK3MjQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Nov 2016 07:39:16 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: Brian Norris <briannorris@chromium.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        "rajatja@google.com" <rajatja@google.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        Xinming Hu <huxm@marvell.com>
Subject: RE: [PATCH v3 4/5] mwifiex: wait firmware dump complete during card
 remove process
Date: Wed, 30 Nov 2016 12:39:11 +0000
Message-ID: <8e65d20f643a4c7f9a242c145ec8f24f@SC-EXCH04.marvell.com> (sfid-20161130_133920_300015_F34881B5)
References: <1479301749-14803-1-git-send-email-akarwar@marvell.com>
 <1479301749-14803-4-git-send-email-akarwar@marvell.com>
 <20161121173602.GA147125@google.com>
 <ad60355f7feb465199f4dace37e47238@SC-EXCH04.marvell.com>
 <20161128212706.GA45985@google.com>
In-Reply-To: <20161128212706.GA45985@google.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Brian,

> > > >   *
> > > > @@ -2227,7 +2237,7 @@ static void mwifiex_recreate_adapter(struct
> > > sdio_mmc_card *card)
> > > >  	 * discovered and initializes them from scratch.
> > > >  	 */
> > > >
> > > > -	mwifiex_sdio_remove(func);
> > > > +	__mwifiex_sdio_remove(func);
> > >
> > > ^^ So here, you're trying to avoid syncing with the card-reset work
> > > event, except that function will free up all your resources
> > > (including the static save_adapter). Thus, you're explicitly
> > > allowing a use-after- free error here. That seems unwise.
> >
> > Even if firmware dump is triggered after card reset is started, it
> > will execute after card reset is completed as discussed above. Only
> > problem I can see is with "save_adapter". We can put new_adapter
> > pointer in "save_adapter" at the end of mwifiex_recreate_adapter() to
> > solve the issue.
> 
> Ugh, yet another band-aid? You might do better to still cancel any
> pending work, just don't do it synchronously. i.e., do cancel_work()
> after you've removed the card. It doesn't make sense to do a FW dump on
> the "new" adapter when it was requested for the old one.

I could not find async version of cancel_work().
We can fix this problem with below change at the end of mwifiex_sdio_work(). All pending work requests would be ignored.

--------
@ -2571,6 +2571,8 @@ static void mwifiex_sdio_work(struct work_struct *work)
        if (test_and_clear_bit(MWIFIEX_IFACE_WORK_CARD_RESET,
                               &iface_work_flags))
                mwifiex_sdio_card_reset_work(save_adapter);
+       clear_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP, &iface_work_flags);
+       clear_bit(MWIFIEX_IFACE_WORK_CARD_RESET, &iface_work_flags);
 }
----------

> 
> > > Instead, you should actually retain the invariant that you're doing
> > > a full remove/reinitialize here, which includes doing the *same*
> > > cancel_work_sync() here in mwifiex_recreate_adapter() as you would
> > > in any other remove().
> >
> > We are executing mwifiex_recreate_adapter() as a part of sdio_work().
> > Calling
> > cancel_work_sync() here would cause deadlock. The API is supposed to
> > waits until sdio_work() is finished.
> 
> You are correct. So using the _sync() version would be wrong.
> 
> > >
> > > IOW, kill the __mwifiex_sdio_remove() and just call
> > > mwifiex_sdio_remove() as you were.
> > >
> > > That also means that you can do the same per-adapter cleanup in the
> > > following patch as you do for PCIe.
> >
> > Currently as sdio_work recreates "card", the work structure can't be
> moved inside card structure.
> > Let me know your suggestions.
> 
> If you address the TODO in mwifiex_create_adapter() instead, you can
> get past this problem:
> 
>         /* TODO mmc_hw_reset does not require destroying and re-probing
> the
>          * whole adapter. Hence there was no need to for this rube-
> goldberg
>          * design to reload the fw from an external workqueue. If we
> don't
>          * destroy the adapter we could reload the fw from
>          * mwifiex_main_work_queue directly.
> 
> The "save_adapter" is an abomination that should be terminated swiftly,
> but it is perpetuated in part by the hacks noted in the TODO.
> 
> So I'd recommend addressing the TODO ASAP, but in the meantime, a hack
> like my suggestion (cancel the FW dump work w/o synchronizing) or --
> less preferably -- yours (manually set 'save_adapter' again) might be
> OK.
> 
> I think I've asked elsewhere but didn't receive an answer: why is
> SDIO's mwifiex_recreate_adapter() so much different from PCIe's
> mwifiex_do_flr()? It seems like the latter should be refactored to
> remove some of the PCIe-specific cruft from main.c and then reused for
> SDIO.

Our initial SDIO card reset implementation was based on MMC APIs where remove() and probe() would automatically get called by MMC subsystem after power cycle.
https://www.spinics.net/lists/linux-wireless/msg98435.html
Later it was improved by Andreas Fenkart by replacing those power cycle APIs with mmc_hw_reset().

For PCIe, function level reset is standard feature. We implemented ".reset_notify" handler which gets called after and before FLR.

You are right. We can have SDIO's handling similar to PCIe and avoid destroying+recreating adapter/card.
We have started working on this. We will get rid of global save_adapter, sdio_work etc. Meanwhile I will post above mentioned change if it looks good to you.

Regards,
Amitkumar
