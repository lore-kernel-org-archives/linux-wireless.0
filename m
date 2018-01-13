Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43048 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965463AbeAMJy7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Jan 2018 04:54:59 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Brian Norris <briannorris@chromium.org>
Cc: Xinming Hu <huxm@marvell.com>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>,
        "rajatja\@google.com" <rajatja@google.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        James Cao <jcao@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Ellie Reeves <ellierevves@gmail.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] mwifiex: cancel pcie/sdio work in remove/shutdown handler
References: <1515587433253.94629@marvell.com>
        <20180112022509.GB243980@google.com>
        <20180112190644.GC102880@google.com>
Date: Sat, 13 Jan 2018 11:54:53 +0200
In-Reply-To: <20180112190644.GC102880@google.com> (Brian Norris's message of
        "Fri, 12 Jan 2018 11:06:45 -0800")
Message-ID: <87tvvqqe1e.fsf@kamboji.qca.qualcomm.com> (sfid-20180113_105503_899002_2DE23EC3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> writes:

> On Thu, Jan 11, 2018 at 06:25:09PM -0800, Brian Norris wrote:
>> Anyway, I'll do my own testing and then submit my patch properly.
>
> OK, so I definitely confirmed: if your patch does anything, it
> introduces a new deadlock possibility. Just trigger a Wifi timeout or
> reset from within remove(), and you'll see the work event get stuck in
> pci_reset_function(), while remove() gets stuck at cancel_work_sync().
>
> I also confirmed that my patch resolves this problem.
>
> I'll send the revert + my patch now.

Great, thanks. I didn't had a chance to do the revert yet but I'll now
apply your revert instead.

-- 
Kalle Valo
