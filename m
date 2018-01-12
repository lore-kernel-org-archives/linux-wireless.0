Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33392 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932500AbeALCZN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Jan 2018 21:25:13 -0500
Received: by mail-pg0-f68.google.com with SMTP id i196so3621511pgd.0
        for <linux-wireless@vger.kernel.org>; Thu, 11 Jan 2018 18:25:12 -0800 (PST)
Date: Thu, 11 Jan 2018 18:25:09 -0800
From: Brian Norris <briannorris@chromium.org>
To: Xinming Hu <huxm@marvell.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>,
        "rajatja@google.com" <rajatja@google.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        James Cao <jcao@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Ellie Reeves <ellierevves@gmail.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: Re: Re: [PATCH] mwifiex: cancel pcie/sdio work in
 remove/shutdown handler
Message-ID: <20180112022509.GB243980@google.com> (sfid-20180112_032517_176317_86BECE23)
References: <1515587433253.94629@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1515587433253.94629@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Simon,

On Wed, Jan 10, 2018 at 12:30:35PM +0000, Xinming Hu wrote:
> > -----Original Message-----
> > From: Brian Norris [mailto:briannorris@chromium.org]
> > On Tue, Jan 09, 2018 at 11:42:21AM +0000, Xinming Hu wrote:
> > > I am not sure whether there is any mutual exclusion protect between
> > pcie_reset and pcie_remove in pcie core.
> > > But it looks a different race.
> > > We still need this fix, right?
> > 
> > Good point. Previously, there wasn't any such exclusion, and that's why races
> > like the above were even more likely. But as of 4.13, now there
> > *is* exclusion. See commit b014e96d1abb ("PCI: Protect
> > pci_error_handlers->reset_notify() usage with device_lock()"). That incidentally
> > means that you're creating a deadlock with this patch! [1]
> > 
> > If we start a timeout/reset sequence in mwifiex_init_shutdown_fw() (called
> > from remove()), then you'll eventually have pci_reset_function() waiting on the
> > device lock, but mwifiex_pcie_remove() will be holding the device lock already,
> > and now (with your patch), remove() will be waiting on the worker thread to
> > finish pci_reset_function()...deadlock!
> > 
> > I actually think that the above patch (adding device_lock()) resolves most of the
> > race but introduces a possible deadlock. I believe an easy solution is just to
> > switch to pci_try_reset_function() instead? That will just abort a reset attempt
> > if we're in the middle of removing the device. Problem solved? Diff appended,
> > but I'll send out a real version if that looks right. Can you test your original
> > problem with the above commit from Christopher, as well as the appended
> > diff?
> > 
> 
> Since I don't have the original customer platform, which is 4.1 based.

You could suggest your customer try the aforementioned commit + my
patch. It will likely get them a more reliable result in the end.

> Just run the stress test on my 4.14, with commands:
> while true; do rmmod mwifiex;insmod $mwd/mwifiex.ko; sleep 1; insmod $mwd/mwifiex_pcie.ko; sleep 1; rmmod mwifiex_pcie & echo "1" > /sys/kernel/debug/mwifiex/mlan0/reset;done &

That's actually not much of a good test, since the mutual exclusion of
reset and remove will mean that 'rmmod' and 'echo 1 > ... /reset' won't
really be doing anything significant in parallel.

What you'd really need to do is fake a timeout from within remove().
e.g., you could do

	adapter->if_ops.card_reset(adapter);

plus some sleep (to let the work event get started) followed by the
cancel_work_sync() of your patch.

> 
> Till now, I didn't hit deadlock with/without below diff, though it
> looks finally will be reached, according to the above explanation.  I
> guess, maybe rmmod operation is slowly then sysfs operation.

Per my above explanation, you won't hit the deadlock like that.

Anyway, I'll do my own testing and then submit my patch properly.

Brian
