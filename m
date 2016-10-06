Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:47570 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753983AbcJFNDH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Oct 2016 09:03:07 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Brian Norris <briannorris@chromium.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        "rajatja@google.com" <rajatja@google.com>,
        Xinming Hu <huxm@marvell.com>
Subject: RE: [PATCH v2 1/2] mwifiex: reset card->adapter during device
 unregister
Date: Thu, 6 Oct 2016 13:03:02 +0000
Message-ID: <127198026f5149c783bb0f5855dc87b9@SC-EXCH04.marvell.com> (sfid-20161006_150320_842820_62E4B165)
References: <1475600905-2997-1-git-send-email-akarwar@marvell.com>
 <20161004215814.GB31652@localhost>
 <8ec683dc72a746909157fca4dcbd10e8@SC-EXCH04.marvell.com>
 <20161005163024.GA54237@google.com>
In-Reply-To: <20161005163024.GA54237@google.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Brian,

> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
> owner@vger.kernel.org] On Behalf Of Brian Norris
> Sent: Wednesday, October 05, 2016 10:00 PM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam;
> rajatja@google.com; Xinming Hu
> Subject: Re: [PATCH v2 1/2] mwifiex: reset card->adapter during device
> unregister
> 
> Hi,
> 
> On Wed, Oct 05, 2016 at 02:04:53PM +0000, Amitkumar Karwar wrote:
> > > From: Brian Norris [mailto:briannorris@chromium.org]
> > > Sent: Wednesday, October 05, 2016 3:28 AM
> > > To: Amitkumar Karwar
> > > Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam;
> > > rajatja@google.com; briannorris@google.com; Xinming Hu
> > > Subject: Re: [PATCH v2 1/2] mwifiex: reset card->adapter during
> > > device unregister
> > >
> > > Hi,
> > >
> > > On Tue, Oct 04, 2016 at 10:38:24PM +0530, Amitkumar Karwar wrote:
> 
> > > > --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> > > > +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> > > > @@ -3042,6 +3042,7 @@ static void mwifiex_unregister_dev(struct
> > > mwifiex_adapter *adapter)
> > > >  				pci_disable_msi(pdev);
> > > >  	       }
> > > >  	}
> > > > +	card->adapter = NULL;
> > >
> > > I think you have a similar problem here as in patch 2; there is no
> > > locking to protect fields in struct pcie_service_card or struct
> > > sdio_mmc_card below. That problem kind of already exists, except
> > > that you only write the value of card->adapter once at registration
> > > time, so it's not actually unsafe. But now that you're introducing a
> > > second write, you have a problem.
> > >
> > > Brian
> > >
> >
> > We have a global "add_remove_card_sem" semaphore in our code for
> > synchronizing initialization and teardown threads. Ideally "init +
> > teardown/reboot" should not have a race issue with this logic
> >
> > Later there was a loophole introduced in this after using async
> > firmware download API. During initialization, firmware downloads
> > asynchronously in a separate thread where might have released the
> > semaphore. I am working on a patch to fix this.
> >
> > So "card->adapter" doesn't need to have locking. Even if we have two
> > write operations, those two threads can't run simultaneously due to
> > above mentioned logic.
> 
> What about writes racing with reads? You have lots of unsynchronized
> cases that read this, although most of them should be halted by now
> (e.g., cmd processing). I was looking at suspend() in particular, which
> I thought you were looking at in this patch series.

Please note that "card->adapter" is used only in pcie.c/sdio.c/usb.c files

Writes won't have race with reads.

1) write 1  --- "card->adapter = adapter;" in mwifiex_register_dev()
	This place is at the beginning of initialization. 
	mwifiex_pcie_probe() -> mwifiex_add_card() -> adapter->if_ops.register_dev()
	There is no chance that "card->adapter" is read anywhere at this point. FW is not yet downloaded

2) write 2 ---- "card->adapter = NULL;" in mwifiex_unregister_dev()
	This place the end of teardown phase.
	Interrupts are disabled and all cleanup is done. We have "card->adapter" NULL checks at entry point of suspend/remove/resume, if they get called after this.
	
Regards,
Amitkumar
