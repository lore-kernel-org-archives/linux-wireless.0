Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:50240 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S935981AbeE3HUp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 May 2018 03:20:45 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: Brian Norris <briannorris@chromium.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>
Subject: RE: [EXT] Re: [PATCH] mwifiex: handle race during
 mwifiex_usb_disconnect
Date: Wed, 30 May 2018 07:20:41 +0000
Message-ID: <5c016c46c5fb41cda4ef59fdac8b5fd8@SC-EXCH02.marvell.com> (sfid-20180530_092049_962250_62E2B6EF)
References: <1527169707-27317-1-git-send-email-gbhat@marvell.com>
 <20180529215906.GA108046@rodete-desktop-imager.corp.google.com>
In-Reply-To: <20180529215906.GA108046@rodete-desktop-imager.corp.google.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Brian,

> > @@ -644,6 +644,9 @@ static void mwifiex_usb_disconnect(struct
> usb_interface *intf)
> >                                      MWIFIEX_FUNC_SHUTDOWN);
> >     }
> >
> > +   if (adapter->workqueue)
> > +           flush_workqueue(adapter->workqueue);
>
> This seems like a bad fix. I'm fairly sure there's another race in here
> somewhere, and at a minimum, this is fragile code.
Ok. Did you mean there can be some RX work pending at this point, which can
cause a similar race for rx URBs?
>
> Instead, can't you just move the mwifiex_usb_free() into a .cleanup_if()
> or .unregister_dev() callback? That's what your other drivers (PCIe and
> SDIO) use to clean up old buffers and stop bus activity; those are
> called after the appropriate synchronization points; and I'm pretty sure
> I've already audited those to be more or less safe.
Ok. Yes, this is a better fix for this issue. I will revert the earlier fix and upstream this version.
>
> Brian
>
> > +
> >     mwifiex_usb_free(card);
> >
> >     mwifiex_dbg(adapter, FATAL,
> > --
> > 1.9.1
> >
Thanks,
Ganapathi
