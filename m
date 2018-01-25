Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:41759 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750994AbeAYScO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Jan 2018 13:32:14 -0500
Received: by mail-pg0-f65.google.com with SMTP id 136so5584028pgd.8
        for <linux-wireless@vger.kernel.org>; Thu, 25 Jan 2018 10:32:13 -0800 (PST)
Date: Thu, 25 Jan 2018 10:32:11 -0800
From: Brian Norris <briannorris@chromium.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Ganapathi Bhat <gbhat@marvell.com>, linux-wireless@vger.kernel.org,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Shrenik Shikhare <shrenik@marvell.com>
Subject: Re: [1/2] mwifiex: schedule rx_work on RX interrupt for USB
Message-ID: <20180125183209.whiz3mjtbhtoqp6s@ban.mtv.corp.google.com> (sfid-20180125_193217_694048_484F7E82)
References: <1516633497-6584-2-git-send-email-gbhat@marvell.com>
 <20180125071052.E370660A4E@smtp.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180125071052.E370660A4E@smtp.codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 25, 2018 at 07:10:52AM +0000, Kalle Valo wrote:
> Ganapathi Bhat <gbhat@marvell.com> wrote:
> 
> > From: Shrenik Shikhare <shrenik@marvell.com>
> > 
> > There is race for data_received flag between main thread and
> > RX data interrupt(mwifiex_usb_rx_complete()):
> > 1. USB received an RX data interrupt, set data_received flag
> > 2. main thread checks data_received, if set queues rx_work
> > 3. rx worker thread independently start processing rx_data_q
> > 4. rx work exits (once rx_data_q is empty)
> > 5. main thread resets the data_received flag(after #2)
> > 6. Now at the corner case there will be high RX data interrupts
> > between #4 and #5
> > 7. Driver stops submitting URBs to firmware, once rx_pending
> > exceeds HIGH_RX_PENDING
> > 8. The flag data_received(cleared in #5) will remain unset since
> > there will be no interrupts from firmware to set it(after #7)
> > 
> > Above scenario causes RX stall in driver, which will finally
> > result in command/TX timeouts in firmware.
> > 
> > As a fix, queue rx_work directly in mwifiex_usb_rx_complete()
> > callback, instead in the main thread. This removes dependency
> > of RX processing on data_received flag.
> > 
> > Signed-off-by: Cathy Luo <cluo@marvell.com>
> > Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
> 
> Brian, did you have a chance to review these two?

Not really. I don't generally make a lot of time to review the USB
driver unless it's really screwing around with the main driver, since I
don't use the USB driver. But I'll try to give it a few glances.
