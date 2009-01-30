Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50369 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbZA3OPx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2009 09:15:53 -0500
Date: Fri, 30 Jan 2009 09:05:03 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Jason Andryuk <jandryuk@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	gregkh@suse.de, kalle.valo@iki.fi
Subject: Re: [PATCH] at76_usb: fix bugs introduced by "Staging: at76_usb:
	cleanup dma on stack issues"
Message-ID: <20090130140503.GC3485@tuxdriver.com> (sfid-20090130_151558_487840_3F695513)
References: <c4d76b3b0901292059w20fccf62gdae10eee02ac4791@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <c4d76b3b0901292059w20fccf62gdae10eee02ac4791@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

FWIW, that driver is in the staging tree.  I'm not sure if there is
a mailing list for that or not, but you should at least copy Greg on
any patches.  Kalle might be interested in seeing them too.

Hth!

John

On Thu, Jan 29, 2009 at 11:59:48PM -0500, Jason Andryuk wrote:
> Tracking down the firmware loading problem led to this commit.
> 
> $ git bisect bad
> 0d1d1424330cc1934f2b2742f0cfa2c31e6a250b is first bad commit
> commit 0d1d1424330cc1934f2b2742f0cfa2c31e6a250b
> Author: Oliver Neukum <oliver@neukum.org>
> Date:   Thu Dec 18 13:16:40 2008 +0100
> 
>     Staging: at76_usb: cleanup dma on stack issues
> 
>     - no DMA on stack
>     - cleanup unclear endianness issue
> 
>     Signed-off-by: Oliver Neukum <oneukum@suse.de>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> :040000 040000 c4fee9ea0fef25926229d810d19dc2f89cca9401
> 8b165a35d16280d2413b2700a6080ef290ca1009 M	drivers
> 
> The "no DMA on stack" conversion was incomplete with respect to
> updating the arguments passed to usb_control_msg.  The value 40 is
> hardcoded as it was prior to conversion.
> 
> The driver can now load firmware, but is not fully functional.
> 
> Signed-off-by: Jason Andryuk <jandryuk@gmail.com>
> --
> 
> diff --git a/drivers/staging/at76_usb/at76_usb.c b/drivers/staging/at76_usb/at76
> index 185533e..befde9b 100644
> --- a/drivers/staging/at76_usb/at76_usb.c
> +++ b/drivers/staging/at76_usb/at76_usb.c
> @@ -598,7 +598,7 @@ static int at76_get_op_mode(struct usb_device *udev)
>                 return -ENOMEM;
>         ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0), 0x33,
>                               USB_TYPE_VENDOR | USB_DIR_IN |
> -                             USB_RECIP_INTERFACE, 0x01, 0, &op_mode, 1,
> +                             USB_RECIP_INTERFACE, 0x01, 0, op_mode, 1,
>                               USB_CTRL_GET_TIMEOUT);
>         saved = *op_mode;
>         kfree(op_mode);
> @@ -731,7 +731,7 @@ static inline int at76_get_cmd_status(struct usb_device *ude
>         ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0), 0x22,
>                               USB_TYPE_VENDOR | USB_DIR_IN |
>                               USB_RECIP_INTERFACE, cmd, 0, stat_buf,
> -                             sizeof(stat_buf), USB_CTRL_GET_TIMEOUT);
> +                             40, USB_CTRL_GET_TIMEOUT);
>         if (ret >= 0)
>                 ret = stat_buf[5];
>         kfree(stat_buf);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
