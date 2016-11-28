Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f45.google.com ([74.125.83.45]:35359 "EHLO
        mail-pg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753352AbcK1V1L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 16:27:11 -0500
Received: by mail-pg0-f45.google.com with SMTP id p66so60961958pga.2
        for <linux-wireless@vger.kernel.org>; Mon, 28 Nov 2016 13:27:11 -0800 (PST)
Date: Mon, 28 Nov 2016 13:27:07 -0800
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        "rajatja@google.com" <rajatja@google.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH v3 4/5] mwifiex: wait firmware dump complete during card
 remove process
Message-ID: <20161128212706.GA45985@google.com> (sfid-20161128_222722_334947_A017C787)
References: <1479301749-14803-1-git-send-email-akarwar@marvell.com>
 <1479301749-14803-4-git-send-email-akarwar@marvell.com>
 <20161121173602.GA147125@google.com>
 <ad60355f7feb465199f4dace37e47238@SC-EXCH04.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ad60355f7feb465199f4dace37e47238@SC-EXCH04.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Amit,

On Thu, Nov 24, 2016 at 12:14:07PM +0000, Amitkumar Karwar wrote:
> > From: Brian Norris [mailto:briannorris@chromium.org]
> > Sent: Monday, November 21, 2016 11:06 PM
> > To: Amitkumar Karwar
> > Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam;
> > rajatja@google.com; dmitry.torokhov@gmail.com; Xinming Hu
> > Subject: Re: [PATCH v3 4/5] mwifiex: wait firmware dump complete during
> > card remove process
> > 
> > On Wed, Nov 16, 2016 at 06:39:08PM +0530, Amitkumar Karwar wrote:
> > > From: Xinming Hu <huxm@marvell.com>
> > >
> > > Wait for firmware dump complete in card remove function.
> > > For sdio interface, there are two diffenrent cases, card reset
> > trigger
> > > sdio_work and firmware dump trigger sdio_work.
> > > Do code rearrangement for distinguish between these two cases.
> > 
> > On second review of the SDIO card reset code (which I'll repeat is
> > quite ugly), you seem to be making a bad distinction here. What if
> > there is a firmware dump happening concurrently with your card-reset
> > handling?
> > You *do* want to synchronize with the firmware dump before completing the
> > card reset, or else you might be freeing up internal card resources
> > that are still in use. See below.
> 
> I ran some tests and observed that if same work function is scheduled
> by two threads, it won't have re-entrant calls. They will be executed
> one after another. In SDIO work function, we have SDIO card reset call
> after completing firmware dump. So firmware dump won't run
> concurrently with card-reset as per my understanding.

Ah, you're correct. It's somewhat obscure and potentially fragile, but
correct AFAICT. As you noted though, you do still have a use-after-free
bug, even if the concurrency isn't quite as high as I thought.

> > > Signed-off-by: Xinming Hu <huxm@marvell.com>
> > > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> > > ---

...

> > > --- a/drivers/net/wireless/marvell/mwifiex/sdio.c
> > > +++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
> > > @@ -46,6 +46,9 @@
> > >   */
> > >  static u8 user_rmmod;
> > >
> > > +static void mwifiex_sdio_work(struct work_struct *work); static
> > > +DECLARE_WORK(sdio_work, mwifiex_sdio_work);
> > > +
> > >  static struct mwifiex_if_ops sdio_ops;  static unsigned long
> > > iface_work_flags;
> > >
> > > @@ -220,7 +223,7 @@ static int mwifiex_sdio_resume(struct device
> > *dev)
> > >   * This function removes the interface and frees up the card
> > structure.
> > >   */
> > >  static void
> > > -mwifiex_sdio_remove(struct sdio_func *func)
> > > +__mwifiex_sdio_remove(struct sdio_func *func)
> > >  {
> > >  	struct sdio_mmc_card *card;
> > >  	struct mwifiex_adapter *adapter;
> > > @@ -249,6 +252,13 @@ static int mwifiex_sdio_resume(struct device
> > *dev)
> > >  	mwifiex_remove_card(adapter);
> > >  }
> > >
> > > +static void
> > > +mwifiex_sdio_remove(struct sdio_func *func) {
> > > +	cancel_work_sync(&sdio_work);
> > > +	__mwifiex_sdio_remove(func);
> > > +}
> > > +
> > >  /*
> > >   * SDIO suspend.
> > >   *
> > > @@ -2227,7 +2237,7 @@ static void mwifiex_recreate_adapter(struct
> > sdio_mmc_card *card)
> > >  	 * discovered and initializes them from scratch.
> > >  	 */
> > >
> > > -	mwifiex_sdio_remove(func);
> > > +	__mwifiex_sdio_remove(func);
> > 
> > ^^ So here, you're trying to avoid syncing with the card-reset work
> > event, except that function will free up all your resources (including
> > the static save_adapter). Thus, you're explicitly allowing a use-after-
> > free error here. That seems unwise.
> 
> Even if firmware dump is triggered after card reset is started, it
> will execute after card reset is completed as discussed above. Only
> problem I can see is with "save_adapter". We can put new_adapter
> pointer in "save_adapter" at the end of mwifiex_recreate_adapter() to
> solve the issue.

Ugh, yet another band-aid? You might do better to still cancel any
pending work, just don't do it synchronously. i.e., do cancel_work()
after you've removed the card. It doesn't make sense to do a FW dump on
the "new" adapter when it was requested for the old one.

> > Instead, you should actually retain the invariant that you're doing a
> > full remove/reinitialize here, which includes doing the *same*
> > cancel_work_sync() here in mwifiex_recreate_adapter() as you would in
> > any other remove().
> 
> We are executing mwifiex_recreate_adapter() as a part of sdio_work(). Calling
> cancel_work_sync() here would cause deadlock. The API is supposed to waits
> until sdio_work() is finished.

You are correct. So using the _sync() version would be wrong.

> > 
> > IOW, kill the __mwifiex_sdio_remove() and just call
> > mwifiex_sdio_remove() as you were.
> > 
> > That also means that you can do the same per-adapter cleanup in the
> > following patch as you do for PCIe.
> 
> Currently as sdio_work recreates "card", the work structure can't be moved inside card structure.
> Let me know your suggestions.

If you address the TODO in mwifiex_create_adapter() instead, you can get
past this problem:

        /* TODO mmc_hw_reset does not require destroying and re-probing the
         * whole adapter. Hence there was no need to for this rube-goldberg
         * design to reload the fw from an external workqueue. If we don't
         * destroy the adapter we could reload the fw from
         * mwifiex_main_work_queue directly.

The "save_adapter" is an abomination that should be terminated swiftly,
but it is perpetuated in part by the hacks noted in the TODO.

So I'd recommend addressing the TODO ASAP, but in the meantime, a hack
like my suggestion (cancel the FW dump work w/o synchronizing) or --
less preferably -- yours (manually set 'save_adapter' again) might be
OK.

I think I've asked elsewhere but didn't receive an answer: why is
SDIO's mwifiex_recreate_adapter() so much different from PCIe's
mwifiex_do_flr()? It seems like the latter should be refactored to
remove some of the PCIe-specific cruft from main.c and then reused for
SDIO.

Brian
