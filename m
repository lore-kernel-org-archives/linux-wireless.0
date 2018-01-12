Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:43283 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964998AbeALTGs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Jan 2018 14:06:48 -0500
Received: by mail-pf0-f196.google.com with SMTP id e3so5064490pfi.10
        for <linux-wireless@vger.kernel.org>; Fri, 12 Jan 2018 11:06:48 -0800 (PST)
Date: Fri, 12 Jan 2018 11:06:45 -0800
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
Message-ID: <20180112190644.GC102880@google.com> (sfid-20180112_200652_188335_8D71EB81)
References: <1515587433253.94629@marvell.com>
 <20180112022509.GB243980@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180112022509.GB243980@google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 11, 2018 at 06:25:09PM -0800, Brian Norris wrote:
> Anyway, I'll do my own testing and then submit my patch properly.

OK, so I definitely confirmed: if your patch does anything, it
introduces a new deadlock possibility. Just trigger a Wifi timeout or
reset from within remove(), and you'll see the work event get stuck in
pci_reset_function(), while remove() gets stuck at cancel_work_sync().

I also confirmed that my patch resolves this problem.

I'll send the revert + my patch now.

Brian
