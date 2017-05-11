Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35322 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933972AbdEKS2n (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 May 2017 14:28:43 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: Re: [v2 05/11] rsi: Remove unnecessary buffer allocation
References: <1494336614-2107-1-git-send-email-amit.karwar@redpinesignals.com>
        <1494336614-2107-6-git-send-email-amit.karwar@redpinesignals.com>
Date: Thu, 11 May 2017 21:28:38 +0300
In-Reply-To: <1494336614-2107-6-git-send-email-amit.karwar@redpinesignals.com>
        (Amitkumar Karwar's message of "Tue, 9 May 2017 19:00:08 +0530")
Message-ID: <87fugbs0x5.fsf@kamboji.qca.qualcomm.com> (sfid-20170511_202848_267803_33975F06)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> writes:

> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>
> In functions usb read register and usb write register, dynamic allocation
> of 4 bytes is used. This is removed as it is unncessary for local variable
> and for such small data.
>
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
> ---
>  drivers/net/wireless/rsi/rsi_91x_usb.c | 18 ++++--------------
>  1 file changed, 4 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
> index 73b01a8..8eb7407 100644
> --- a/drivers/net/wireless/rsi/rsi_91x_usb.c
> +++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
> @@ -157,12 +157,8 @@ static int rsi_usb_reg_read(struct usb_device *usbdev,
>  			    u16 *value,
>  			    u16 len)
>  {
> -	u8 *buf;
> -	int status = -ENOMEM;
> -
> -	buf  = kmalloc(0x04, GFP_KERNEL);
> -	if (!buf)
> -		return status;
> +	u8 buf[4];
> +	int status;
>  
>  	status = usb_control_msg(usbdev,
>  				 usb_rcvctrlpipe(usbdev, 0),

Recently I got a patch to orinoco_usb which did exactly the opposite
(unless I'm missing something):

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git/commit/?id=2f6ae79cb04bb7f9b4be3f1c32b6fda35bf976bc

The documentation for usb_control_msg() does not mention anything if
it's possible to use stack memory, but AFAIU it's not possible to use
stack memory with DMA. Can anyone clarify?

-- 
Kalle Valo
