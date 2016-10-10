Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36282 "EHLO
        mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751378AbcJJUn5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Oct 2016 16:43:57 -0400
Received: by mail-pa0-f46.google.com with SMTP id ry6so803437pac.3
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2016 13:43:56 -0700 (PDT)
Date: Mon, 10 Oct 2016 13:43:54 -0700
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        "rajatja@google.com" <rajatja@google.com>,
        Xinming Hu <huxm@marvell.com>, abhishekbh@google.com
Subject: Re: [PATCH v2 1/2] mwifiex: reset card->adapter during device
 unregister
Message-ID: <20161010204352.GA11254@localhost> (sfid-20161010_224401_834535_D9989DCD)
References: <1475600905-2997-1-git-send-email-akarwar@marvell.com>
 <20161004215814.GB31652@localhost>
 <8ec683dc72a746909157fca4dcbd10e8@SC-EXCH04.marvell.com>
 <20161005163024.GA54237@google.com>
 <127198026f5149c783bb0f5855dc87b9@SC-EXCH04.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <127198026f5149c783bb0f5855dc87b9@SC-EXCH04.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Amit,

On Thu, Oct 06, 2016 at 01:03:02PM +0000, Amitkumar Karwar wrote:
> > From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
> > owner@vger.kernel.org] On Behalf Of Brian Norris
> > Sent: Wednesday, October 05, 2016 10:00 PM
> > To: Amitkumar Karwar
> > Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam;
> > rajatja@google.com; Xinming Hu
> > Subject: Re: [PATCH v2 1/2] mwifiex: reset card->adapter during device
> > unregister
> > 
> > On Wed, Oct 05, 2016 at 02:04:53PM +0000, Amitkumar Karwar wrote:
> > > > From: Brian Norris [mailto:briannorris@chromium.org]
> > > > Sent: Wednesday, October 05, 2016 3:28 AM
> > > > To: Amitkumar Karwar
> > > > Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam;
> > > > rajatja@google.com; briannorris@google.com; Xinming Hu
> > > > Subject: Re: [PATCH v2 1/2] mwifiex: reset card->adapter during
> > > > device unregister
> > > >
> > > > On Tue, Oct 04, 2016 at 10:38:24PM +0530, Amitkumar Karwar wrote:
> > 
> > > > > --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> > > > > +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> > > > > @@ -3042,6 +3042,7 @@ static void mwifiex_unregister_dev(struct
> > > > mwifiex_adapter *adapter)
> > > > >  				pci_disable_msi(pdev);
> > > > >  	       }
> > > > >  	}
> > > > > +	card->adapter = NULL;

...

> > What about writes racing with reads? You have lots of unsynchronized
> > cases that read this, although most of them should be halted by now
> > (e.g., cmd processing). I was looking at suspend() in particular, which
> > I thought you were looking at in this patch series.
> 
> Please note that "card->adapter" is used only in pcie.c/sdio.c/usb.c files
> 
> Writes won't have race with reads.
> 
> 1) write 1  --- "card->adapter = adapter;" in mwifiex_register_dev()
> 	This place is at the beginning of initialization. 
> 	mwifiex_pcie_probe() -> mwifiex_add_card() -> adapter->if_ops.register_dev()
> 	There is no chance that "card->adapter" is read anywhere at this point. FW is not yet downloaded

Sure.

> 2) write 2 ---- "card->adapter = NULL;" in mwifiex_unregister_dev()
> 	This place the end of teardown phase.
> 	Interrupts are disabled and all cleanup is done. We have
> 	"card->adapter" NULL checks at entry point of
> 	suspend/remove/resume, if they get called after this.

I guess the question boils down to: can driver suspend() race with
mwifiex_unregister_dev() here, then?

And I guess the answer is "no", because unregistration only happens via

  PCIe driver remove() -> mwifiex_remove_card() -> adapter->if_ops.unregister_dev()

and I think the device driver core guarantees that suspend() and
remove() won't race.

In that case:

Reviewed-by: Brian Norris <briannorris@chromium.org>

I'll reply to the latest revision too, since it's identical.

Thanks for the explanations.

Regards,
Brian
