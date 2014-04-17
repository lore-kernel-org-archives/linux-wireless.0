Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:64744 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbaDQVlu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2014 17:41:50 -0400
Received: by mail-ie0-f182.google.com with SMTP id y20so955876ier.13
        for <linux-wireless@vger.kernel.org>; Thu, 17 Apr 2014 14:41:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1397710914-10061-2-git-send-email-bzhao@marvell.com>
References: <1397710914-10061-1-git-send-email-bzhao@marvell.com>
	<1397710914-10061-2-git-send-email-bzhao@marvell.com>
Date: Thu, 17 Apr 2014 14:41:49 -0700
Message-ID: <CACUGKYMWqr2-YAXhPzo8GfPPYBd2xoD_zf56FzqpkzN=X80X8A@mail.gmail.com> (sfid-20140417_234153_766331_B0345732)
Subject: Re: [PATCH 2/2] mwifiex: don't clear cmd_sent flag in timeout handler
From: John Tobias <john.tobias.ph@gmail.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bing,

Assuming the timeout happened due to a firmware bug. Does the firmware
able to recover after setting adapter->cmd_sent = false and the
firmware could accept a new commands without locking?.
Seems, this is the bug I was encountering and couldn't access the
mlan0 interface anymore...

Is there a way to force the firmware to reset it without rebooting it?.

Regards,

john


On Wed, Apr 16, 2014 at 10:01 PM, Bing Zhao <bzhao@marvell.com> wrote:
> From: Amitkumar Karwar <akarwar@marvell.com>
>
> When command timeout occurs due to a firmware/hardware bug,
> there is no chance of next command being successful. We will
> keep cmd_sent flag on so that next command won't be sent to
> firmware.
>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>
> ---
>  drivers/net/wireless/mwifiex/cmdevt.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
> index 1062c91..8dee6c8 100644
> --- a/drivers/net/wireless/mwifiex/cmdevt.c
> +++ b/drivers/net/wireless/mwifiex/cmdevt.c
> @@ -955,8 +955,6 @@ mwifiex_cmd_timeout_func(unsigned long function_context)
>                         adapter->cmd_wait_q.status = -ETIMEDOUT;
>                         wake_up_interruptible(&adapter->cmd_wait_q.wait);
>                         mwifiex_cancel_pending_ioctl(adapter);
> -                       /* reset cmd_sent flag to unblock new commands */
> -                       adapter->cmd_sent = false;
>                 }
>         }
>         if (adapter->hw_status == MWIFIEX_HW_STATUS_INITIALIZING)
> --
> 1.8.2.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
