Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60330 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750734AbeAYHKx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Jan 2018 02:10:53 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] mwifiex: schedule rx_work on RX interrupt for USB
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1516633497-6584-2-git-send-email-gbhat@marvell.com>
References: <1516633497-6584-2-git-send-email-gbhat@marvell.com>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Shrenik Shikhare <shrenik@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Message-Id: <20180125071053.29F1C6032C@smtp.codeaurora.org> (sfid-20180125_081057_190624_0AC05310)
Date: Thu, 25 Jan 2018 07:10:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ganapathi Bhat <gbhat@marvell.com> wrote:

> From: Shrenik Shikhare <shrenik@marvell.com>
> 
> There is race for data_received flag between main thread and
> RX data interrupt(mwifiex_usb_rx_complete()):
> 1. USB received an RX data interrupt, set data_received flag
> 2. main thread checks data_received, if set queues rx_work
> 3. rx worker thread independently start processing rx_data_q
> 4. rx work exits (once rx_data_q is empty)
> 5. main thread resets the data_received flag(after #2)
> 6. Now at the corner case there will be high RX data interrupts
> between #4 and #5
> 7. Driver stops submitting URBs to firmware, once rx_pending
> exceeds HIGH_RX_PENDING
> 8. The flag data_received(cleared in #5) will remain unset since
> there will be no interrupts from firmware to set it(after #7)
> 
> Above scenario causes RX stall in driver, which will finally
> result in command/TX timeouts in firmware.
> 
> As a fix, queue rx_work directly in mwifiex_usb_rx_complete()
> callback, instead in the main thread. This removes dependency
> of RX processing on data_received flag.
> 
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>

Brian, did you have a chance to review these two?

-- 
https://patchwork.kernel.org/patch/10178731/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
