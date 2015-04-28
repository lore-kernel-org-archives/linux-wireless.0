Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:35469 "EHLO
	mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966006AbbD1VPs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Apr 2015 17:15:48 -0400
Received: by qkhg7 with SMTP id g7so5037735qkh.2
        for <linux-wireless@vger.kernel.org>; Tue, 28 Apr 2015 14:15:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87iocg5jdn.fsf@kamboji.qca.qualcomm.com>
References: <1428916704-9635-1-git-send-email-afenkart@gmail.com>
	<1428916704-9635-2-git-send-email-afenkart@gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951B16DFB8F9@SC-VEXCH1.marvell.com>
	<87iocg5jdn.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 28 Apr 2015 23:15:47 +0200
Message-ID: <CALtMJEBEcTyXnjDJD2TWpvO46cPec=R+gf5UvhKRhNTJTW5uKw@mail.gmail.com> (sfid-20150428_231600_363734_61D3AF64)
Subject: Re: [PATCH 2/2] mwifiex: sdio: bug: dead-lock in card reset
From: Andreas Fenkart <afenkart@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Avinash Patil <patila@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

thanks for reviewing this

2015-04-28 18:04 GMT+02:00 Kalle Valo <kvalo@codeaurora.org>:
> Amitkumar Karwar <akarwar@marvell.com> writes:
>
>>> Card reset is implemented by removing/re-adding the adapter instance.
>>> This is implemented by removing the mmc host, which will then trigger a
>>> cascade of removal callbacks including mwifiex_sdio_remove.
>>> The dead-lock results in the latter function, trying to cancel the work
>>> item executing the mmc host removal. This patch adds a driver level, not
>>> adapter level, work struct to break the dead-lock
>>>
>
> Ok, so we are talking about this commit which apparently fell through
> the cracks:
>
> https://git.kernel.org/cgit/linux/kernel/git/kvalo/wireless-drivers-next.git/commit/?id=2f5872b60146
>
> Like I said as a reply to patch 1, using static variables for this is
> ugly. Isn't there really any better way to handle the problem?

The root of the evil is calling internal mmc-host API to solve a
problem in mwifiex:

target = adapter->card->sdio_func->host;
mmc_remove_host(target);
mdelay(200);
mmc_add_host(target);

This code needs to run on a workqueue that is independent of the
adapter, since all workqueues of the adapter are destroyed.

We can hide the adapter pointer through sdio_set_drvdata, Then from
the workqueue, we can iterate over all sdio_func in the system.
Must be possible through the device model somehow, then use,
a *global* variable to filter out the sdio_func that is ours.
That saves us from de-referencing the weak adapter pointer
(card could be removed by mmc-core workqueue running in parallel).

But it doesn't safe us from a weak mmc host pointer: That particular
card has a BT function as well, and if cmd handler is hosed for one
function, it's hosed for the other one as well. If they both issue card
reset simultaneously we have a race condition. (we can't claim the
host we are going to destroy),
- unless they both run on the same workqueue, and the
workqueue only executes 1 task simultaneously
.
It's also quite unpolite of one function to reset card before consulting
the other functions. Something like request reset / and each function
has a veto. (There is also an FM tuner, that can send it's data via
I2S, not affected by the sdio cmd handler)

The current solution is pragmatic, 99.99% of the cards are
non-removable /  1 adapter per system / no-BT? But it might be
a bit labor intensive to maintain, since changes in the mmc
subsystem might break it by accident.
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=81df6cafe28b358739d121205e1ddaeec2ed5b15

 /Andi
