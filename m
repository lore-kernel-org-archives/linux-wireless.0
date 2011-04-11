Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37756 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054Ab1DKRuy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2011 13:50:54 -0400
Received: by vws1 with SMTP id 1so4331550vws.19
        for <linux-wireless@vger.kernel.org>; Mon, 11 Apr 2011 10:50:53 -0700 (PDT)
Message-ID: <4DA33F78.5050305@gmail.com>
Date: Mon, 11 Apr 2011 13:50:48 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: Sujith <m.sujith@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k_htc: Fix ethtool reporting
References: <19875.14815.278751.401499@gargle.gargle.HOWL>
In-Reply-To: <19875.14815.278751.401499@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/11/11 13:26, Sujith wrote:
> From: Sujith Manoharan<Sujith.Manoharan@atheros.com>
>
> Pass the correct module name and device interface so that
> ethtool can display the proper values.
>
> The firmware version will be fixed later on when the FW
> can actually report a version. :)
>
> Reported-by: Richard Farina<sidhayn@gmail.com>
> Signed-off-by: Sujith Manoharan<Sujith.Manoharan@atheros.com>
Tested-by: Richard Farina <sidhayn@gmail.com>

Sujith,

Thanks a lot for this patch, it does exactly what I need until the new 
firmware stuff is official.

All,

Since ethtool reports the driver incorrectly without this patch is it 
too much to ask for a stable push? At least into .39, further if anyone 
thinks it appropriate. This seems like a pretty minor patch to me but 
fixes a real problem (well at least it was a real problem for me).

Thanks,
Rick Farina
> ---
>   drivers/net/wireless/ath/ath9k/hif_usb.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
> index f1b8af6..2d10239 100644
> --- a/drivers/net/wireless/ath/ath9k/hif_usb.c
> +++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
> @@ -1040,7 +1040,7 @@ static int ath9k_hif_usb_probe(struct usb_interface *interface,
>   	}
>
>   	ret = ath9k_htc_hw_init(hif_dev->htc_handle,
> -				&hif_dev->udev->dev, hif_dev->device_id,
> +				&interface->dev, hif_dev->device_id,
>   				hif_dev->udev->product, id->driver_info);
>   	if (ret) {
>   		ret = -EINVAL;
> @@ -1158,7 +1158,7 @@ fail_resume:
>   #endif
>
>   static struct usb_driver ath9k_hif_usb_driver = {
> -	.name = "ath9k_hif_usb",
> +	.name = KBUILD_MODNAME,
>   	.probe = ath9k_hif_usb_probe,
>   	.disconnect = ath9k_hif_usb_disconnect,
>   #ifdef CONFIG_PM
> -- 1.7.4.4

