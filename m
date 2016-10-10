Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:32824 "EHLO
        mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752338AbcJJXrN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Oct 2016 19:47:13 -0400
Received: by mail-pa0-f44.google.com with SMTP id vu5so3483911pab.0
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2016 16:47:12 -0700 (PDT)
Date: Mon, 10 Oct 2016 16:47:09 -0700
From: Brian Norris <briannorris@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        "rajatja@google.com" <rajatja@google.com>,
        Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH v2 1/2] mwifiex: reset card->adapter during device
 unregister
Message-ID: <20161010234708.GA19969@localhost> (sfid-20161011_014718_105791_37AD726A)
References: <1475600905-2997-1-git-send-email-akarwar@marvell.com>
 <20161004215814.GB31652@localhost>
 <8ec683dc72a746909157fca4dcbd10e8@SC-EXCH04.marvell.com>
 <20161005163024.GA54237@google.com>
 <127198026f5149c783bb0f5855dc87b9@SC-EXCH04.marvell.com>
 <CAKdAkRTKo3JVJPamM44jyG6QuHoQB89FMKj5vo3-z6T+XH1W9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKdAkRTKo3JVJPamM44jyG6QuHoQB89FMKj5vo3-z6T+XH1W9Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dmitry,

On Mon, Oct 10, 2016 at 04:43:06PM -0700, Dmitry Torokhov wrote:
> On Thu, Oct 6, 2016 at 6:03 AM, Amitkumar Karwar <akarwar@marvell.com> wrote:
> >> From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
> >> owner@vger.kernel.org] On Behalf Of Brian Norris
> >> Sent: Wednesday, October 05, 2016 10:00 PM
> >> To: Amitkumar Karwar
> >> Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam;
> >> rajatja@google.com; Xinming Hu
> >> Subject: Re: [PATCH v2 1/2] mwifiex: reset card->adapter during device
> >> unregister
> >>
> >> On Wed, Oct 05, 2016 at 02:04:53PM +0000, Amitkumar Karwar wrote:
> >> > > From: Brian Norris [mailto:briannorris@chromium.org]
> >> > > Sent: Wednesday, October 05, 2016 3:28 AM
> >> > > To: Amitkumar Karwar
> >> > > Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam;
> >> > > rajatja@google.com; briannorris@google.com; Xinming Hu
> >> > > Subject: Re: [PATCH v2 1/2] mwifiex: reset card->adapter during
> >> > > device unregister
> >> > >
> >> > > On Tue, Oct 04, 2016 at 10:38:24PM +0530, Amitkumar Karwar wrote:
> >>
> >> > > > --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> >> > > > +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> >> > > > @@ -3042,6 +3042,7 @@ static void mwifiex_unregister_dev(struct
> >> > > mwifiex_adapter *adapter)
> >> > > >                                 pci_disable_msi(pdev);
> >> > > >                }
> >> > > >         }
> >> > > > +       card->adapter = NULL;
> >> > >
> >> > > I think you have a similar problem here as in patch 2; there is no
> >> > > locking to protect fields in struct pcie_service_card or struct
> >> > > sdio_mmc_card below. That problem kind of already exists, except
> >> > > that you only write the value of card->adapter once at registration
> >> > > time, so it's not actually unsafe. But now that you're introducing a
> >> > > second write, you have a problem.
> >> > >
> >> > > Brian
> >> > >
> >> >
> >> > We have a global "add_remove_card_sem" semaphore in our code for
> >> > synchronizing initialization and teardown threads. Ideally "init +
> >> > teardown/reboot" should not have a race issue with this logic
> >> >
> >> > Later there was a loophole introduced in this after using async
> >> > firmware download API. During initialization, firmware downloads
> >> > asynchronously in a separate thread where might have released the
> >> > semaphore. I am working on a patch to fix this.
> >> >
> >> > So "card->adapter" doesn't need to have locking. Even if we have two
> >> > write operations, those two threads can't run simultaneously due to
> >> > above mentioned logic.
> >>
> >> What about writes racing with reads? You have lots of unsynchronized
> >> cases that read this, although most of them should be halted by now
> >> (e.g., cmd processing). I was looking at suspend() in particular, which
> >> I thought you were looking at in this patch series.
> >
> > Please note that "card->adapter" is used only in pcie.c/sdio.c/usb.c files
> >
> > Writes won't have race with reads.
> >
> > 1) write 1  --- "card->adapter = adapter;" in mwifiex_register_dev()
> >         This place is at the beginning of initialization.
> >         mwifiex_pcie_probe() -> mwifiex_add_card() -> adapter->if_ops.register_dev()
> >         There is no chance that "card->adapter" is read anywhere at this point. FW is not yet downloaded
> >
> > 2) write 2 ---- "card->adapter = NULL;" in mwifiex_unregister_dev()
> >         This place the end of teardown phase.
> >         Interrupts are disabled and all cleanup is done. We have "card->adapter" NULL checks at entry point of suspend/remove/resume, if they get called after this.
> 
> How exactly are you preventing ->suspend() from being called *while*
> you are running mwifiex_unregister_dev()? I.e. user slamming the lid
> of a laptop and throwing it in their backpack?

As I already commented, isn't this primarily [*] called from the driver
remove() callback? remove() doesn't race with suspend(), does it?

[*] The other cases are in error handling cases. I guess I should make
sure those didn't race too...

Brian
