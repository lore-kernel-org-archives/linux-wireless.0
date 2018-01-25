Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33174 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750763AbeAYHNr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Jan 2018 02:13:47 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Shrenik Shikhare <shrenik@marvell.com>
Subject: Re: [2/2] mwifiex: use more_rx_task_flag to avoid USB RX stall
References: <1516633497-6584-3-git-send-email-gbhat@marvell.com>
        <20180125071202.482C060A61@smtp.codeaurora.org>
Date: Thu, 25 Jan 2018 09:13:42 +0200
In-Reply-To: <20180125071202.482C060A61@smtp.codeaurora.org> (Kalle Valo's
        message of "Thu, 25 Jan 2018 07:12:02 +0000 (UTC)")
Message-ID: <87po5ys95l.fsf@purkki.adurom.net> (sfid-20180125_081350_438081_B6CFFB35)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

> Ganapathi Bhat <gbhat@marvell.com> wrote:
>
>> From: Shrenik Shikhare <shrenik@marvell.com>
>> 
>> There is a race condition for acquiring rx_proc_lock between
>> rx worker thread and USB RX data interrupt
>> (mwifiex_usb_rx_complete):
>> 
>> 1. USB receives an RX data interrupt, queues rx_work
>> 2. rx_work empties rx_data_q, tries to acquire rx_proc_lock (to
>> clear rx_processing flag)
>> 3. While #2 is yet to acquire rx_proc_lock, driver receives
>> continuous RX data interupts(mwifiex_usb_rx_complete)
>> 3. For each interrupt at #3, driver acquires rx_proc_lock(it gets
>> the lock since it is in interrupt context), tries to queue
>> rx_work, but fails to do so since rx_processing is still set(#2)
>> 4. When rx_pending exceeds HIGH_RX_PENDING, driver stops
>> submitting URBs back to USB subsystem and thus firmware stops
>> uploading RX data to driver
>> 5. Now finally #2 will acquire rx_proc_lock, but because of #4,
>> there are no further triggers to schedule rx_work again
>> 
>> The above scenario occurs in some platforms where the RX
>> processing is comparitively slower. This results in RX stall in
>> driver, command/TX timeouts in firmware. The above scenario is
>> introduced after commit c7dbdcb2a4e1
>> ("mwifiex: schedule rx_work on RX interrupt for USB")
>> 
>> To fix this set a new more_rx_task_flag whenever RX data callback
>> is trying to schedule rx_work but rx_processing is not yet
>> cleared. This will let the current rx_work(which was waiting for
>> rx_proc_lock) to loopback and process newly arrived RX packets.
>> 
>> Signed-off-by: Cathy Luo <cluo@marvell.com>
>> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
>
> I can't find any commit with id c7dbdcb2a4e1, is it correct?

Oh, and please use Fixes line to mark the commit which broke this.

-- 
Kalle Valo
