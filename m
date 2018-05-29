Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:39069 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967497AbeE2V7M (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 May 2018 17:59:12 -0400
Received: by mail-pl0-f67.google.com with SMTP id f1-v6so9300638plt.6
        for <linux-wireless@vger.kernel.org>; Tue, 29 May 2018 14:59:11 -0700 (PDT)
Date: Tue, 29 May 2018 14:59:07 -0700
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>
Subject: Re: [PATCH] mwifiex: handle race during mwifiex_usb_disconnect
Message-ID: <20180529215906.GA108046@rodete-desktop-imager.corp.google.com> (sfid-20180530_000006_312355_0A5ED655)
References: <1527169707-27317-1-git-send-email-gbhat@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1527169707-27317-1-git-send-email-gbhat@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ganapathi,

On Thu, May 24, 2018 at 07:18:27PM +0530, Ganapathi Bhat wrote:
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
> ---
>  drivers/net/wireless/marvell/mwifiex/usb.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
> index bc475b8..6e3cf98 100644
> --- a/drivers/net/wireless/marvell/mwifiex/usb.c
> +++ b/drivers/net/wireless/marvell/mwifiex/usb.c
> @@ -644,6 +644,9 @@ static void mwifiex_usb_disconnect(struct usb_interface *intf)
>  					 MWIFIEX_FUNC_SHUTDOWN);
>  	}
>  
> +	if (adapter->workqueue)
> +		flush_workqueue(adapter->workqueue);

This seems like a bad fix. I'm fairly sure there's another race in here
somewhere, and at a minimum, this is fragile code.

Instead, can't you just move the mwifiex_usb_free() into a .cleanup_if()
or .unregister_dev() callback? That's what your other drivers (PCIe and
SDIO) use to clean up old buffers and stop bus activity; those are
called after the appropriate synchronization points; and I'm pretty sure
I've already audited those to be more or less safe.

Brian

> +
>  	mwifiex_usb_free(card);
>  
>  	mwifiex_dbg(adapter, FATAL,
> -- 
> 1.9.1
> 
