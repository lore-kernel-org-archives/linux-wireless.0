Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33424 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756558AbcKCQPI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Nov 2016 12:15:08 -0400
Received: by mail-pf0-f196.google.com with SMTP id a136so5269054pfa.0
        for <linux-wireless@vger.kernel.org>; Thu, 03 Nov 2016 09:15:08 -0700 (PDT)
Date: Thu, 3 Nov 2016 09:15:04 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Xinming Hu <huxm@marvell.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        "rajatja@google.com" <rajatja@google.com>,
        "briannorris@google.com" <briannorris@google.com>
Subject: Re: [PATCH v2 2/5] mwifiex: use spinlock for 'mwifiex_processing' in
 shutdown_drv
Message-ID: <20161103161504.GA15366@dtor-ws> (sfid-20161103_171512_572043_493C2EAA)
References: <1477559563-18328-1-git-send-email-akarwar@marvell.com>
 <1477559563-18328-2-git-send-email-akarwar@marvell.com>
 <20161027174422.GA509@dtor-ws>
 <b9fed0716cfb46818b0a93a925e5d37a@SC-EXCH02.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <b9fed0716cfb46818b0a93a925e5d37a@SC-EXCH02.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 03, 2016 at 08:34:06AM +0000, Xinming Hu wrote:
> Hi Dmitry,
> 
> > -----Original Message-----
> > From: linux-wireless-owner@vger.kernel.org
> > [mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of Dmitry Torokhov
> > Sent: 2016年10月28日 1:44
> > To: Amitkumar Karwar
> > Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam;
> > rajatja@google.com; briannorris@google.com
> > Subject: Re: [PATCH v2 2/5] mwifiex: use spinlock for 'mwifiex_processing' in
> > shutdown_drv
> > 
> > Hi Amit,
> > 
> > On Thu, Oct 27, 2016 at 02:42:40PM +0530, Amitkumar Karwar wrote:
> > > This variable is guarded by spinlock at all other places. This patch
> > > takes care of missing spinlock usage in mwifiex_shutdown_drv().
> > 
> > Since in the previous discussion you stated that we inhibit interrupts and flush
> > the workqueue so that mwifiex_shutdown_drv() can't run simultaneously with
> > the main processing routine, why do we need this?
> > 
> > Instead please remove call to mwifiex_shutdown_drv() in the main routine
> > and "if (adapter->mwifiex_processing)" check here.
> > 
> 
> mwifiex_main_process will be used from interrupt or workqueue.
> Now we have disabled interrupt and flush workqueue, so mwifiex_main_process won't be scheduled in the future.
> But mwifiex_main_process might just running in context of last interrupt, so we need wait current main_process complete in mwifiex_shutdown_drv.

synchronize_irq() is your friend then.

Thanks.

-- 
Dmitry
