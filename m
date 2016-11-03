Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:33703 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751264AbcKCS1J (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Nov 2016 14:27:09 -0400
Received: by mail-pf0-f173.google.com with SMTP id d2so35856535pfd.0
        for <linux-wireless@vger.kernel.org>; Thu, 03 Nov 2016 11:27:08 -0700 (PDT)
Date: Thu, 3 Nov 2016 11:27:05 -0700
From: Brian Norris <briannorris@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Xinming Hu <huxm@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        "rajatja@google.com" <rajatja@google.com>
Subject: Re: [PATCH v2 2/5] mwifiex: use spinlock for 'mwifiex_processing' in
 shutdown_drv
Message-ID: <20161103182705.GA1153@google.com> (sfid-20161103_192713_113477_D961C990)
References: <1477559563-18328-1-git-send-email-akarwar@marvell.com>
 <1477559563-18328-2-git-send-email-akarwar@marvell.com>
 <20161027174422.GA509@dtor-ws>
 <b9fed0716cfb46818b0a93a925e5d37a@SC-EXCH02.marvell.com>
 <20161103161504.GA15366@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161103161504.GA15366@dtor-ws>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 03, 2016 at 09:15:04AM -0700, Dmitry Torokhov wrote:
> On Thu, Nov 03, 2016 at 08:34:06AM +0000, Xinming Hu wrote:
> > > -----Original Message-----
> > > From: linux-wireless-owner@vger.kernel.org
> > > [mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of Dmitry Torokhov
> > > 
> > > Instead please remove call to mwifiex_shutdown_drv() in the main routine
> > > and "if (adapter->mwifiex_processing)" check here.
> > > 
> > 
> > mwifiex_main_process will be used from interrupt or workqueue.
> > Now we have disabled interrupt and flush workqueue, so
> > mwifiex_main_process won't be scheduled in the future.
> > But mwifiex_main_process might just running in context of last
> > interrupt, so we need wait current main_process complete in
> > mwifiex_shutdown_drv.
> 
> synchronize_irq() is your friend then.

Hmm, that sounds right, but IIUC, the "interrupt context" is actually
only used for SDIO, and for SDIO, the driver doesn't actually have
access to the IRQ number. The MMC/SDIO layer has some extra abstraction
around the IRQ. So this may be more difficult than it appears.

Do we need a sdio_synchronize_irq() API?

Brian
