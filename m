Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:38895 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751670AbdECSvt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 May 2017 14:51:49 -0400
Received: by mail-wm0-f51.google.com with SMTP id r190so69004688wme.1
        for <linux-wireless@vger.kernel.org>; Wed, 03 May 2017 11:51:48 -0700 (PDT)
Subject: Re: [PATCH 2/6] mwifiex: usb: urb->context sanity check in complete
 handler
To: Xinming Hu <huxinming820@gmail.com>,
        Linux Wireless <linux-wireless@vger.kernel.org>
References: <1493812123-12053-1-git-send-email-huxinming820@gmail.com>
 <1493812123-12053-2-git-send-email-huxinming820@gmail.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <af056a38-7fc7-0bb5-d43c-41fa6cc10df9@broadcom.com> (sfid-20170503_205159_919533_BB935A5F)
Date: Wed, 3 May 2017 20:51:45 +0200
MIME-Version: 1.0
In-Reply-To: <1493812123-12053-2-git-send-email-huxinming820@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3-5-2017 13:48, Xinming Hu wrote:
> From: Xinming Hu <huxm@marvell.com>
> 
> urb/context might be freed in cornel case, add sanity check to avoid
> use-after-free.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> ---
>  drivers/net/wireless/marvell/mwifiex/usb.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
> index 2f7705c..ee5f488 100644
> --- a/drivers/net/wireless/marvell/mwifiex/usb.c
> +++ b/drivers/net/wireless/marvell/mwifiex/usb.c
> @@ -169,6 +169,11 @@ static void mwifiex_usb_rx_complete(struct urb *urb)
>  	int recv_length = urb->actual_length;
>  	int size, status;
>  
> +	if (!urb || !urb->context) {
> +		pr_err("URB or URB context is not valid in USB Rx complete\n");
> +		return;
> +	}

Something is really off if you need !urb here. Furthermore, you are
already initializing stack variables using fields inside the urb before
this check causing a null-deref so it is bogus anyway. The completion
function is a member in struct urb. If your driver has a list of these
urb's somewhere and they are free in parallel then your design is wrong
and this does not solve the use-after-free. The urb here will not be
NULL and still points to the old memory location as it was handed to the
usb subsystem. That piece of memory might already been handed out to
some other piece of the kernel making any access to it invalid and
potentially crashing the kernel.

Regards,
Arend
