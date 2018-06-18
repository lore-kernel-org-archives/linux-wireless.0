Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45236 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934109AbeFROl2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Jun 2018 10:41:28 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Brian Norris <briannorris@chromium.org>
Cc: Ganapathi Bhat <gbhat@marvell.com>, linux-wireless@vger.kernel.org,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>
Subject: Re: [PATCH 2/2] mwifiex: handle race during mwifiex_usb_disconnect
References: <1527849680-31445-1-git-send-email-gbhat@marvell.com>
        <1527849680-31445-2-git-send-email-gbhat@marvell.com>
        <20180601163355.GA248677@rodete-desktop-imager.corp.google.com>
Date: Mon, 18 Jun 2018 17:41:24 +0300
In-Reply-To: <20180601163355.GA248677@rodete-desktop-imager.corp.google.com>
        (Brian Norris's message of "Fri, 1 Jun 2018 09:33:57 -0700")
Message-ID: <87r2l49my3.fsf@purkki.adurom.net> (sfid-20180618_164134_326829_BB874E08)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> writes:

> Hi Ganapathi,
>
> On Fri, Jun 01, 2018 at 04:11:20PM +0530, Ganapathi Bhat wrote:
>> Race condition is observed during rmmod of mwifiex_usb:
>> 
>> 1. The rmmod thread will call mwifiex_usb_disconnect(), download
>>    SHUTDOWN command and do wait_event_interruptible_timeout(),
>>    waiting for response.
>> 
>> 2. The main thread will handle the response and will do a
>>    wake_up_interruptible(), unblocking rmmod thread.
>> 
>> 3. On getting unblocked, rmmod thread  will make rx_cmd.urb = NULL in
>>    mwifiex_usb_free().
>> 
>> 4. The main thread will try to resubmit rx_cmd.urb in
>>    mwifiex_usb_submit_rx_urb(), which is NULL.
>> 
>> To fix this, move mwifiex_usb_free() from mwifiex_usb_disconnect
>> to mwifiex_unregister_dev(). Function mwifiex_unregister_dev() is
>> called after flushing the command and RX work queues.
>> 
>> Signed-off-by: Brian Norris <briannorris@chromium.org>
>
> ^^ I'm not sure if that line is quite accurate. While I nearly spelled
> out what the patch would look like, you wrote it.
>
> Anyway, patch seems good to me, assuming it tests out OK for you:
>
> Reviewed-by: Brian Norris <briannorris@chromium.org>
>
> and if Kalle hasn't applied this yet, an alternative to Signed-off-by:
>
> Suggested-by: Brian Norris <briannorris@chromium.org>

Ok, I'll change that.

-- 
Kalle Valo
