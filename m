Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40498 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751531AbeAYM7O (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Jan 2018 07:59:14 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Brian Norris" <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Shrenik Shikhare <shrenik@marvell.com>
Subject: Re: [EXT] Re: [2/2] mwifiex: use more_rx_task_flag to avoid USB RX stall
References: <1516633497-6584-3-git-send-email-gbhat@marvell.com>
        <20180125071202.0F39560A60@smtp.codeaurora.org>
        <e7a1f375b450451da611477943d2eeb6@SC-EXCH02.marvell.com>
Date: Thu, 25 Jan 2018 14:59:08 +0200
In-Reply-To: <e7a1f375b450451da611477943d2eeb6@SC-EXCH02.marvell.com>
        (Ganapathi Bhat's message of "Thu, 25 Jan 2018 09:59:04 +0000")
Message-ID: <87a7x2yu03.fsf@kamboji.qca.qualcomm.com> (sfid-20180125_140145_478693_D24115AC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ganapathi Bhat <gbhat@marvell.com> writes:

>> > The above scenario occurs in some platforms where the RX processing is
>> > comparitively slower. This results in RX stall in driver, command/TX
>> > timeouts in firmware. The above scenario is introduced after commit
>> > c7dbdcb2a4e1
>> > ("mwifiex: schedule rx_work on RX interrupt for USB")
>> >
>> > To fix this set a new more_rx_task_flag whenever RX data callback is
>> > trying to schedule rx_work but rx_processing is not yet cleared. This
>> > will let the current rx_work(which was waiting for
>> > rx_proc_lock) to loopback and process newly arrived RX packets.
>> >
>> > Signed-off-by: Cathy Luo <cluo@marvell.com>
>> > Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
>>
>> I can't find any commit with id c7dbdcb2a4e1, is it correct?
>
> Correct. Actually the commit id c7dbdcb2a4e1 is the PATCH [1/2] sent in this series.

Actually the commit id will be different, I just tested it to be sure:

$ git reset --hard master
HEAD is now at b69c1df47281 brcmfmac: separate firmware errors from i/o errors
$ git am -s -3 1.patch
Applying: mwifiex: schedule rx_work on RX interrupt for USB
$ git log --oneline -1 | cat
676bc4833907 mwifiex: schedule rx_work on RX interrupt for USB
$ git reset --hard master
HEAD is now at b69c1df47281 brcmfmac: separate firmware errors from i/o errors
$ git am -s -3 1.patch
Applying: mwifiex: schedule rx_work on RX interrupt for USB
$ git log --oneline -1 | cat
74c5fc1d45b4 mwifiex: schedule rx_work on RX interrupt for USB
$ 

So the date, and most likely also the commiter, is included when
calculating the hash. So you can't really refer to uncommited patches
using a commit id as the id is determined only once the maintainer
applies the patch.

-- 
Kalle Valo
