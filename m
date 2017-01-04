Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:33788 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752568AbdADCUl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jan 2017 21:20:41 -0500
Received: by mail-pg0-f53.google.com with SMTP id g1so182116295pgn.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jan 2017 18:20:41 -0800 (PST)
Date: Tue, 3 Jan 2017 18:12:09 -0800
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        "rajatja@google.com" <rajatja@google.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH v3 4/5] mwifiex: wait firmware dump complete during card
 remove process
Message-ID: <20170104021208.GA15537@google.com> (sfid-20170104_032045_108924_6DD5D29F)
References: <1479301749-14803-1-git-send-email-akarwar@marvell.com>
 <1479301749-14803-4-git-send-email-akarwar@marvell.com>
 <20161121173602.GA147125@google.com>
 <ad60355f7feb465199f4dace37e47238@SC-EXCH04.marvell.com>
 <20161128212706.GA45985@google.com>
 <8e65d20f643a4c7f9a242c145ec8f24f@SC-EXCH04.marvell.com>
 <20161130183339.GA11358@google.com>
 <a6067f1c99a749e6a0c265c725694fda@SC-EXCH04.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a6067f1c99a749e6a0c265c725694fda@SC-EXCH04.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, Dec 01, 2016 at 02:02:43PM +0000, Amitkumar Karwar wrote:
> > > I could not find async version of cancel_work().
> > 
> > cancel_work() *is* asynchronous. It does not synchronize with the last
> > event, so you won't have the deadlock. (Remember: the synchronous
> > version is cancel_work_sync().)
> 
> My bad! What I meant is "I could not find async version of cancel_work_sync()"
> cancel_work() isn't available in http://lxr.free-electrons.com/source/kernel/workqueue.c

It's in 4.9-rc1 (and it's available at the above link, at least by now).
See:

commit f72b8792d180948b4b3898374998f5ac8c02e539
Author: Jens Axboe <axboe@fb.com>
Date:   Wed Aug 24 15:51:50 2016 -0600

    workqueue: add cancel_work()

But anyway:

> Anyways, clear_bit() after remove() during card reset would address the problem.

Yes, I think that's OK.

Brian
