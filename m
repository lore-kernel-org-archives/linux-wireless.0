Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:51093 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933453AbcKXMOO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Nov 2016 07:14:14 -0500
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
Date: Thu, 24 Nov 2016 12:14:07 +0000
Message-ID: <ad60355f7feb465199f4dace37e47238@SC-EXCH04.marvell.com> (sfid-20161124_131418_869651_E907E136)
References: <1479301749-14803-1-git-send-email-akarwar@marvell.com>
 <1479301749-14803-4-git-send-email-akarwar@marvell.com>
 <20161121173602.GA147125@google.com>
In-Reply-To: <20161121173602.GA147125@google.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Brian,

> From: Brian Norris [mailto:briannorris@chromium.org]
> Sent: Monday, November 21, 2016 11:06 PM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam;
> rajatja@google.com; dmitry.torokhov@gmail.com; Xinming Hu
> Subject: Re: [PATCH v3 4/5] mwifiex: wait firmware dump complete during
> card remove process
> 
> Hi,
> 
> On Wed, Nov 16, 2016 at 06:39:08PM +0530, Amitkumar Karwar wrote:
> > From: Xinming Hu <huxm@marvell.com>
> >
> > Wait for firmware dump complete in card remove function.
> > For sdio interface, there are two diffenrent cases, card reset
> trigger
> > sdio_work and firmware dump trigger sdio_work.
> > Do code rearrangement for distinguish between these two cases.
> 
> On second review of the SDIO card reset code (which I'll repeat is
> quite ugly), you seem to be making a bad distinction here. What if
> there is a firmware dump happening concurrently with your card-reset
> handling?
> You *do* want to synchronize with the firmware dump before completing the
> card reset, or else you might be freeing up internal card resources
> that are still in use. See below.

I ran some tests and observed that if same work function is scheduled by two threads, it won't have re-entrant calls. They will be executed one after another.
In SDIO work function, we have SDIO card reset call after completing firmware dump.
So firmware dump won't run concurrently with card-reset as per my understanding.

> 
> >
> > Signed-off-by: Xinming Hu <huxm@marvell.com>
> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> > ---
> > v2: 1. Get rid of reset_triggered flag. Instead split the code and
> use
> >     __mwifiex_sdio_remove() (Brian Norris/Dmitry Torokhov)
> >     2. "v1 4/5 mwifiex: firmware dump code rearrangement.." is
> dropped. So
> >     rebased accordingly.
> > v3: same as [v2,5/5]. The improvement of 'moving pcie_work to card
> struct'
> > suggested by Brian is taken care in next patch.
> > ---
> >  drivers/net/wireless/marvell/mwifiex/pcie.c |  6 +++++-
> > drivers/net/wireless/marvell/mwifiex/sdio.c | 15 ++++++++++++---
> >  2 files changed, 17 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c
> > b/drivers/net/wireless/marvell/mwifiex/pcie.c
> > index dd8f7aa..c8e69a4 100644
> > --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> > +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> > @@ -51,6 +51,9 @@ static int mwifiex_pcie_probe_of(struct device
> *dev)
> >  	return 0;
> >  }
> >
> > +static void mwifiex_pcie_work(struct work_struct *work); static
> > +DECLARE_WORK(pcie_work, mwifiex_pcie_work);
> > +
> >  static int
> >  mwifiex_map_pci_memory(struct mwifiex_adapter *adapter, struct
> sk_buff *skb,
> >  		       size_t size, int flags)
> > @@ -254,6 +257,8 @@ static void mwifiex_pcie_remove(struct pci_dev
> *pdev)
> >  	if (!adapter || !adapter->priv_num)
> >  		return;
> >
> > +	cancel_work_sync(&pcie_work);
> > +
> >  	if (user_rmmod && !adapter->mfg_mode) {
> >  		mwifiex_deauthenticate_all(adapter);
> >
> > @@ -2722,7 +2727,6 @@ static void mwifiex_pcie_work(struct
> work_struct *work)
> >  		mwifiex_pcie_device_dump_work(save_adapter);
> >  }
> >
> > -static DECLARE_WORK(pcie_work, mwifiex_pcie_work);
> >  /* This function dumps FW information */  static void
> > mwifiex_pcie_device_dump(struct mwifiex_adapter *adapter)  { diff
> > --git a/drivers/net/wireless/marvell/mwifiex/sdio.c
> > b/drivers/net/wireless/marvell/mwifiex/sdio.c
> > index 16d1d30..78f2cc9 100644
> > --- a/drivers/net/wireless/marvell/mwifiex/sdio.c
> > +++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
> > @@ -46,6 +46,9 @@
> >   */
> >  static u8 user_rmmod;
> >
> > +static void mwifiex_sdio_work(struct work_struct *work); static
> > +DECLARE_WORK(sdio_work, mwifiex_sdio_work);
> > +
> >  static struct mwifiex_if_ops sdio_ops;  static unsigned long
> > iface_work_flags;
> >
> > @@ -220,7 +223,7 @@ static int mwifiex_sdio_resume(struct device
> *dev)
> >   * This function removes the interface and frees up the card
> structure.
> >   */
> >  static void
> > -mwifiex_sdio_remove(struct sdio_func *func)
> > +__mwifiex_sdio_remove(struct sdio_func *func)
> >  {
> >  	struct sdio_mmc_card *card;
> >  	struct mwifiex_adapter *adapter;
> > @@ -249,6 +252,13 @@ static int mwifiex_sdio_resume(struct device
> *dev)
> >  	mwifiex_remove_card(adapter);
> >  }
> >
> > +static void
> > +mwifiex_sdio_remove(struct sdio_func *func) {
> > +	cancel_work_sync(&sdio_work);
> > +	__mwifiex_sdio_remove(func);
> > +}
> > +
> >  /*
> >   * SDIO suspend.
> >   *
> > @@ -2227,7 +2237,7 @@ static void mwifiex_recreate_adapter(struct
> sdio_mmc_card *card)
> >  	 * discovered and initializes them from scratch.
> >  	 */
> >
> > -	mwifiex_sdio_remove(func);
> > +	__mwifiex_sdio_remove(func);
> 
> ^^ So here, you're trying to avoid syncing with the card-reset work
> event, except that function will free up all your resources (including
> the static save_adapter). Thus, you're explicitly allowing a use-after-
> free error here. That seems unwise.

Even if firmware dump is triggered after card reset is started, it will execute after card reset is completed as discussed above. Only problem I can see is with "save_adapter". We can put new_adapter pointer in "save_adapter" at the end of mwifiex_recreate_adapter() to solve the issue.

> 
> Instead, you should actually retain the invariant that you're doing a
> full remove/reinitialize here, which includes doing the *same*
> cancel_work_sync() here in mwifiex_recreate_adapter() as you would in
> any other remove().

We are executing mwifiex_recreate_adapter() as a part of sdio_work(). Calling cancel_work_sync() here would cause deadlock. The API is supposed to waits until sdio_work() is finished.

> 
> IOW, kill the __mwifiex_sdio_remove() and just call
> mwifiex_sdio_remove() as you were.
> 
> That also means that you can do the same per-adapter cleanup in the
> following patch as you do for PCIe.

Currently as sdio_work recreates "card", the work structure can't be moved inside card structure.
Let me know your suggestions.

Regards,
Amitkumar
