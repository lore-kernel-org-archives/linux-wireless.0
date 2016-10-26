Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:42487 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755685AbcJZQ7V (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 12:59:21 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Brian Norris <briannorris@chromium.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Cathy Luo <cluo@marvell.com>,
        "Nishant Sarmukadam" <nishants@marvell.com>
Subject: RE: [PATCH 2/5] mwifiex: use spinlock for 'mwifiex_processing' in
 shutdown_drv
Date: Wed, 26 Oct 2016 16:59:17 +0000
Message-ID: <206625aa34dc499a9e6769287571127f@SC-EXCH04.marvell.com> (sfid-20161026_185933_211431_95D7BECB)
References: <1477318892-22877-1-git-send-email-akarwar@marvell.com>
 <1477318892-22877-2-git-send-email-akarwar@marvell.com>
 <20161024191914.GB968@localhost> <20161024235746.GC15034@dtor-ws>
 <91f0f4390ac14afc9e4f3498d1b79c78@SC-EXCH04.marvell.com>
 <20161025163520.GA10979@dtor-ws>
 <24731897638e42ba8b05acd6afafef3b@SC-EXCH04.marvell.com>
 <20161026163607.GA3989@dtor-ws>
In-Reply-To: <20161026163607.GA3989@dtor-ws>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dmitry,

> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: Wednesday, October 26, 2016 10:06 PM
> To: Amitkumar Karwar
> Cc: Brian Norris; linux-wireless@vger.kernel.org; Cathy Luo; Nishant
> Sarmukadam
> Subject: Re: [PATCH 2/5] mwifiex: use spinlock for 'mwifiex_processing'
> in shutdown_drv
> 
> Hi Amit,
> 
> On Wed, Oct 26, 2016 at 03:23:08PM +0000, Amitkumar Karwar wrote:
> >
> > This race won't occur. At this point of time(i.e while calling
> mwifiex_shutdown_drv() in deinit), following things are completed. We
> don't expect mwifiex_main_process() to be scheduled.
> > 1) Connection to peer device is terminated at the beginning of
> teardown thread. So we don't receive any Tx data from kernel.
> > 2) Last command SHUTDOWN is exchanged with firmware. So there won't be
> any activity/interrupt from firmware.
> > 3) Interrupts are disabled.
> > 4) "adapter->surprise_removed" flag is set. It will skip
> mwifiex_main_process() calls.
> >
> > -----------
> > static void mwifiex_main_work_queue(struct work_struct *work) {
> >         struct mwifiex_adapter *adapter =
> >                 container_of(work, struct mwifiex_adapter, main_work);
> >
> >         if (adapter->surprise_removed)
> >                 return;
> >         mwifiex_main_process(adapter); }
> > ----------
> > 5) We have "mwifiex_terminate_workqueue(adapter)" call to flush and
> destroy workqueue.
> 
> OK, but if interrupts are disabled and you ensure that work is flushed
> or completed before you call mwifiex_shutdown_drv() then I do not
> understand why you need all of this at all? Why do you need to check
> status in mwifiex_shutdown_drv() and why do you want
> mwifiex_main_process() to call mwifiex_shutdown_drv() in certain cases?
> Can you simply remove all this stuff?
> 

I agree. This code is there for long time. I will prepare a patch for this cleanup work.

Regards,
Amitkumar
