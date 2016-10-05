Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:60694 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752516AbcJEOFF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Oct 2016 10:05:05 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Brian Norris <briannorris@chromium.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        "rajatja@google.com" <rajatja@google.com>,
        "briannorris@google.com" <briannorris@google.com>,
        Xinming Hu <huxm@marvell.com>
Subject: RE: [PATCH v2 1/2] mwifiex: reset card->adapter during device
 unregister
Date: Wed, 5 Oct 2016 14:04:53 +0000
Message-ID: <8ec683dc72a746909157fca4dcbd10e8@SC-EXCH04.marvell.com> (sfid-20161005_160548_161611_35502BCC)
References: <1475600905-2997-1-git-send-email-akarwar@marvell.com>
 <20161004215814.GB31652@localhost>
In-Reply-To: <20161004215814.GB31652@localhost>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Brian,

> From: Brian Norris [mailto:briannorris@chromium.org]
> Sent: Wednesday, October 05, 2016 3:28 AM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam;
> rajatja@google.com; briannorris@google.com; Xinming Hu
> Subject: Re: [PATCH v2 1/2] mwifiex: reset card->adapter during device
> unregister
> 
> Hi,
> 
> On Tue, Oct 04, 2016 at 10:38:24PM +0530, Amitkumar Karwar wrote:
> > From: Xinming Hu <huxm@marvell.com>
> >
> > card->adapter gets initialized during device registration.
> > As it's not cleared, we may end up accessing invalid memory in some
> > corner cases. This patch fixes the problem.
> >
> > Signed-off-by: Xinming Hu <huxm@marvell.com>
> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> > ---
> > v2: Same as v1
> > ---
> >  drivers/net/wireless/marvell/mwifiex/pcie.c | 1 +
> > drivers/net/wireless/marvell/mwifiex/sdio.c | 1 +
> >  2 files changed, 2 insertions(+)
> >
> > diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c
> > b/drivers/net/wireless/marvell/mwifiex/pcie.c
> > index f1eeb73..ba9e068 100644
> > --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> > +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> > @@ -3042,6 +3042,7 @@ static void mwifiex_unregister_dev(struct
> mwifiex_adapter *adapter)
> >  				pci_disable_msi(pdev);
> >  	       }
> >  	}
> > +	card->adapter = NULL;
> 
> I think you have a similar problem here as in patch 2; there is no
> locking to protect fields in struct pcie_service_card or struct
> sdio_mmc_card below. That problem kind of already exists, except that
> you only write the value of card->adapter once at registration time, so
> it's not actually unsafe. But now that you're introducing a second
> write, you have a problem.
> 
> Brian
> 

We have a global "add_remove_card_sem" semaphore in our code for synchronizing initialization and teardown threads. Ideally "init + teardown/reboot" should not have a race issue with this logic

Later there was a loophole introduced in this after using async firmware download API. During initialization, firmware downloads asynchronously in a separate thread where might have released the semaphore. I am working on a patch to fix this.

So "card->adapter" doesn't need to have locking. Even if we have two write operations, those two threads can't run simultaneously due to above mentioned logic.

Regards,
Amitkumar
