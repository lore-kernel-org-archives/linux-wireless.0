Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53140 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750831AbeE2HXO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 May 2018 03:23:14 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: handle race during mwifiex_usb_disconnect
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1527169707-27317-1-git-send-email-gbhat@marvell.com>
References: <1527169707-27317-1-git-send-email-gbhat@marvell.com>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Message-Id: <20180529072314.84BDD6060A@smtp.codeaurora.org> (sfid-20180529_092318_527246_05B5F267)
Date: Tue, 29 May 2018 07:23:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ganapathi Bhat <gbhat@marvell.com> wrote:

> Race condition is observed during rmmod of mwifiex_usb:
> 
> 1. The rmmod thread will call mwifiex_usb_disconnect(), download
>    SHUTDOWN command and do wait_event_interruptible_timeout(),
>    waiting for response.
> 
> 2. The main thread will handle the response and will do a
>    wake_up_interruptible(), unblocking rmmod thread.
> 
> 3. On getting unblocked, rmmod thread  will make rx_cmd.urb = NULL in
>    mwifiex_usb_free().
> 
> 4. The main thread will try to resubmit rx_cmd.urb in
>    mwifiex_usb_submit_rx_urb(), which is NULL.
> 
> To fix, wait for main thread to complete before calling
> mwifiex_usb_free().
> 
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>

Patch applied to wireless-drivers-next.git, thanks.

b817047ae70c mwifiex: handle race during mwifiex_usb_disconnect

-- 
https://patchwork.kernel.org/patch/10424763/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
