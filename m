Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:35832 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751320AbcJEQa2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Oct 2016 12:30:28 -0400
Received: by mail-pf0-f176.google.com with SMTP id s13so90316383pfd.2
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2016 09:30:27 -0700 (PDT)
Date: Wed, 5 Oct 2016 09:30:24 -0700
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        "rajatja@google.com" <rajatja@google.com>,
        Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH v2 1/2] mwifiex: reset card->adapter during device
 unregister
Message-ID: <20161005163024.GA54237@google.com> (sfid-20161005_183031_687873_09772CEC)
References: <1475600905-2997-1-git-send-email-akarwar@marvell.com>
 <20161004215814.GB31652@localhost>
 <8ec683dc72a746909157fca4dcbd10e8@SC-EXCH04.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8ec683dc72a746909157fca4dcbd10e8@SC-EXCH04.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Wed, Oct 05, 2016 at 02:04:53PM +0000, Amitkumar Karwar wrote:
> > From: Brian Norris [mailto:briannorris@chromium.org]
> > Sent: Wednesday, October 05, 2016 3:28 AM
> > To: Amitkumar Karwar
> > Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam;
> > rajatja@google.com; briannorris@google.com; Xinming Hu
> > Subject: Re: [PATCH v2 1/2] mwifiex: reset card->adapter during device
> > unregister
> > 
> > Hi,
> > 
> > On Tue, Oct 04, 2016 at 10:38:24PM +0530, Amitkumar Karwar wrote:

> > > --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> > > +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> > > @@ -3042,6 +3042,7 @@ static void mwifiex_unregister_dev(struct
> > mwifiex_adapter *adapter)
> > >  				pci_disable_msi(pdev);
> > >  	       }
> > >  	}
> > > +	card->adapter = NULL;
> > 
> > I think you have a similar problem here as in patch 2; there is no
> > locking to protect fields in struct pcie_service_card or struct
> > sdio_mmc_card below. That problem kind of already exists, except that
> > you only write the value of card->adapter once at registration time, so
> > it's not actually unsafe. But now that you're introducing a second
> > write, you have a problem.
> > 
> > Brian
> > 
> 
> We have a global "add_remove_card_sem" semaphore in our code for
> synchronizing initialization and teardown threads. Ideally "init +
> teardown/reboot" should not have a race issue with this logic
> 
> Later there was a loophole introduced in this after using async
> firmware download API. During initialization, firmware downloads
> asynchronously in a separate thread where might have released the
> semaphore. I am working on a patch to fix this.
> 
> So "card->adapter" doesn't need to have locking. Even if we have two
> write operations, those two threads can't run simultaneously due to
> above mentioned logic.

What about writes racing with reads? You have lots of unsynchronized
cases that read this, although most of them should be halted by now
(e.g., cmd processing). I was looking at suspend() in particular, which
I thought you were looking at in this patch series.

Brian
