Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:52840 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754005AbcJTNLg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Oct 2016 09:11:36 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Brian Norris <briannorris@chromium.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        "rajatja@google.com" <rajatja@google.com>,
        Xinming Hu <huxm@marvell.com>,
        "abhishekbh@google.com" <abhishekbh@google.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: RE: [PATCH v4 1/3] mwifiex: reset card->adapter during device
 unregister
Date: Thu, 20 Oct 2016 13:11:31 +0000
Message-ID: <b1231f275ecc4e45a9c98dadb1d585f1@SC-EXCH04.marvell.com> (sfid-20161020_151140_917882_DFBD096A)
References: <1475777186-20486-1-git-send-email-akarwar@marvell.com>
 <20161010205332.GB11254@localhost> <20161011002238.GC19969@localhost>
In-Reply-To: <20161011002238.GC19969@localhost>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Brian/Dmitry,

> From: Brian Norris [mailto:briannorris@chromium.org]
> Sent: Tuesday, October 11, 2016 5:53 AM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam;
> rajatja@google.com; Xinming Hu; abhishekbh@google.com; Dmitry Torokhov
> Subject: Re: [PATCH v4 1/3] mwifiex: reset card->adapter during device
> unregister
> 
> + Dmitry
> 
> Hi Amit,
> 
> On Mon, Oct 10, 2016 at 01:53:32PM -0700, Brian Norris wrote:
> > On Thu, Oct 06, 2016 at 11:36:24PM +0530, Amitkumar Karwar wrote:
> > > From: Xinming Hu <huxm@marvell.com>
> > >
> > > card->adapter gets initialized during device registration.
> > > As it's not cleared, we may end up accessing invalid memory in some
> > > corner cases. This patch fixes the problem.
> > >
> > > Signed-off-by: Xinming Hu <huxm@marvell.com>
> > > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> > > ---
> > > v4: Same as v1, v2, v3
> > > ---
> > >  drivers/net/wireless/marvell/mwifiex/pcie.c | 1 +
> > > drivers/net/wireless/marvell/mwifiex/sdio.c | 1 +
> > >  2 files changed, 2 insertions(+)
> > >
> > > diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c
> > > b/drivers/net/wireless/marvell/mwifiex/pcie.c
> > > index f1eeb73..ba9e068 100644
> > > --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> > > +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> > > @@ -3042,6 +3042,7 @@ static void mwifiex_unregister_dev(struct
> mwifiex_adapter *adapter)
> > >  				pci_disable_msi(pdev);
> > >  	       }
> > >  	}
> > > +	card->adapter = NULL;
> > >  }
> > >
> > >  /* This function initializes the PCI-E host memory space, WCB
> rings, etc.
> > > diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c
> > > b/drivers/net/wireless/marvell/mwifiex/sdio.c
> > > index 8718950..4cad1c2 100644
> > > --- a/drivers/net/wireless/marvell/mwifiex/sdio.c
> > > +++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
> > > @@ -2066,6 +2066,7 @@ mwifiex_unregister_dev(struct mwifiex_adapter
> *adapter)
> > >  	struct sdio_mmc_card *card = adapter->card;
> > >
> > >  	if (adapter->card) {
> > > +		card->adapter = NULL;
> > >  		sdio_claim_host(card->func);
> > >  		sdio_disable_func(card->func);
> > >  		sdio_release_host(card->func);
> >
> > As discussed on v1, I had qualms about the raciness between
> > reads/writes of card->adapter, but I believe we:
> > (a) can't have any command activity while writing the ->adapter field
> > (either we're just init'ing the device, or we've disabled interrupts
> > and are tearing it down) and
> > (b) can't have a race between suspend()/resume() and unregister_dev(),
> > since unregister_dev() is called from device remove() (which should
> > not be concurrent with suspend()).
> >
> > Also, I thought you had the same problem in usb.c, but in fact, you
> > fixed that ages ago here:
> >
> > 353d2a69ea26 mwifiex: fix issues in driver unload path for USB
> > chipsets
> >
> > Would be nice if fixes were bettery synchronized across the three
> > interface drivers you support. We seem to be discovering unnecessary
> > divergence on a few points recently.
> >
> > At any rate:
> >
> > Reviewed-by: Brian Norris <briannorris@chromium.org>
> > Tested-by: Brian Norris <briannorris@chromium.org>
> 
> Dmitry helped me re-realize my original qualms:
> 
> mwifiex_unregister_dev() is called in the failure path for your async FW
> request, and so it may race with suspend(). So I retract my Reviewed-by.
> Sorry.

Thanks for your comments.

Actually description for this patch was ambiguous and incorrect. Sorry for that. This patch doesn't fix any race. In fact, we don't have a race between init and remove threads due to semaphore usage as per design. This patch just adds missing "card->adapter=NULL" so that when teardown/remove thread starts after init failure, it won't try freeing already freed things.

I have updated patch description in v5 series.

You are right. We may have a race between init failure and suspend thread. I have prepared 4th patch in my v5 series to address this.

> 
> I'm going to look into converting to asynchronous device probing, which
> might remove the need for async FW request, and would therefore resolve
> both patch 1 and 3's races without any additional complicated hacks. But
> I'm not sure if that will satisfy all mwifiex users well enough. I'll
> have to give it a little more thought. Any thoughts from your side,
> Amit?
> 

This is not needed. 4th patch in V5 series would take care of this race.
I will be posting v5 series shortly.

Regards,
Amitkumar
