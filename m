Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:45224 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753456AbcLAObU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Dec 2016 09:31:20 -0500
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
Date: Thu, 1 Dec 2016 14:02:43 +0000
Message-ID: <a6067f1c99a749e6a0c265c725694fda@SC-EXCH04.marvell.com> (sfid-20161201_153123_792409_84E1DB81)
References: <1479301749-14803-1-git-send-email-akarwar@marvell.com>
 <1479301749-14803-4-git-send-email-akarwar@marvell.com>
 <20161121173602.GA147125@google.com>
 <ad60355f7feb465199f4dace37e47238@SC-EXCH04.marvell.com>
 <20161128212706.GA45985@google.com>
 <8e65d20f643a4c7f9a242c145ec8f24f@SC-EXCH04.marvell.com>
 <20161130183339.GA11358@google.com>
In-Reply-To: <20161130183339.GA11358@google.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Brian,

> From: Brian Norris [mailto:briannorris@chromium.org]
> Sent: Thursday, December 01, 2016 12:04 AM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam;
> rajatja@google.com; dmitry.torokhov@gmail.com; Xinming Hu
> Subject: Re: [PATCH v3 4/5] mwifiex: wait firmware dump complete during
> card remove process
> 
> On Wed, Nov 30, 2016 at 12:39:11PM +0000, Amitkumar Karwar wrote:
> 
> > > Ugh, yet another band-aid? You might do better to still cancel any
> > > pending work, just don't do it synchronously. i.e., do
> cancel_work()
> > > after you've removed the card. It doesn't make sense to do a FW
> dump
> > > on the "new" adapter when it was requested for the old one.
> >
> > I could not find async version of cancel_work().
> 
> cancel_work() *is* asynchronous. It does not synchronize with the last
> event, so you won't have the deadlock. (Remember: the synchronous
> version is cancel_work_sync().)

My bad! What I meant is "I could not find async version of cancel_work_sync()"
cancel_work() isn't available in http://lxr.free-electrons.com/source/kernel/workqueue.c
Anyways, clear_bit() after remove() during card reset would address the problem.

> 
> > We can fix this problem with below change at the end of
> > mwifiex_sdio_work(). All pending work requests would be ignored.
> >
> > --------
> > @ -2571,6 +2571,8 @@ static void mwifiex_sdio_work(struct work_struct
> *work)
> >         if (test_and_clear_bit(MWIFIEX_IFACE_WORK_CARD_RESET,
> >                                &iface_work_flags))
> >                 mwifiex_sdio_card_reset_work(save_adapter);
> > +       clear_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP, &iface_work_flags);
> > +       clear_bit(MWIFIEX_IFACE_WORK_CARD_RESET, &iface_work_flags);
> >  }
> > ----------
> 
> I don't think that's exactly what you want. That might lose events,
> won't it? I'd rather this sort of hack go into
> mwifiex_recreate_adapter(), in between the remove() and probe() calls,
> where you don't expect any new events to trigger. And maybe include a
> comment as to why.

Right. I have just posted a patch for this.

> 
> > > I think I've asked elsewhere but didn't receive an answer: why is
> > > SDIO's mwifiex_recreate_adapter() so much different from PCIe's
> > > mwifiex_do_flr()? It seems like the latter should be refactored to
> > > remove some of the PCIe-specific cruft from main.c and then reused
> > > for SDIO.
> >
> > Our initial SDIO card reset implementation was based on MMC APIs
> where
> > remove() and probe() would automatically get called by MMC subsystem
> > after power cycle.
> > https://www.spinics.net/lists/linux-wireless/msg98435.html
> > Later it was improved by Andreas Fenkart by replacing those power
> > cycle APIs with mmc_hw_reset().
> 
> Right.
> 
> > For PCIe, function level reset is standard feature. We implemented
> > ".reset_notify" handler which gets called after and before FLR.
> 
> OK.
> 
> > You are right. We can have SDIO's handling similar to PCIe and avoid
> > destroying+recreating adapter/card.
> 
> So all in all, you're saying it's just an artifact of history, and
> there's no good reason they are so different? If so, then this looks
> like another instance where you would have done well to refactor and
> improve the existing mechanisms at the same time as you added new
> features (i.e., PCIe FLR). I've seen this problem already several
> times, where it seems development for your SDIO/PCIe/USB interface
> drivers occur almost in isolation. IMO, it'd do you well to notice
> these patterns while implementing features in the first place. The more
> code you can share, the fewer bugs you (or I) will have to chase down.

Thanks for your guidance. I'll follow this for future development.

Regards,
Amitkumar
