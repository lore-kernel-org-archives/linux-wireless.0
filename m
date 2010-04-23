Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:35048 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756781Ab0DWUTE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Apr 2010 16:19:04 -0400
Received: by bwz25 with SMTP id 25so11683641bwz.28
        for <linux-wireless@vger.kernel.org>; Fri, 23 Apr 2010 13:19:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <19409.10472.450708.915467@gargle.gargle.HOWL>
References: <19409.10472.450708.915467@gargle.gargle.HOWL>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 23 Apr 2010 22:18:42 +0200
Message-ID: <s2m69e28c911004231318oaf7cd7fex440846d2f90a5774@mail.gmail.com>
Subject: Re: [PATCH 07/11] ath9k_htc: Use USB reboot
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 23, 2010 at 6:58 AM, Sujith <Sujith.Manoharan@atheros.com> wrote:
> So, apparently there is a USB reboot command
> that the target accepts. Using this instead of
> usb_reset_device() fixes the issue of "descriptor read error"
> that pops up on repeated load/unload.
>
> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/hif_usb.c |   22 +++++++++++++++++++++-
>  1 files changed, 21 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
> index cee5feb..31665c5 100644
> --- a/drivers/net/wireless/ath/ath9k/hif_usb.c
> +++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
> @@ -889,6 +889,26 @@ err_alloc:
>        return ret;
>  }
>
> +static void ath9k_hif_usb_reboot(struct usb_device *udev)
> +{
> +       u32 reboot_cmd = 0xffffffff;
> +       void *buf;
> +       int ret;
> +
> +       buf = kmalloc(4, GFP_KERNEL);
> +       if (!buf)
> +               return;
> +
> +       memcpy(buf, &reboot_cmd, 4);
> +
> +       ret = usb_bulk_msg(udev, usb_sndbulkpipe(udev, USB_REG_OUT_PIPE),
> +                          buf, 4, NULL, HZ);
> +       if (ret)
> +               dev_err(&udev->dev, "ath9k_htc: USB reboot failed\n");
> +
> +       kfree(buf);
> +}
> +
>  static void ath9k_hif_usb_disconnect(struct usb_interface *interface)
>  {
>        struct usb_device *udev = interface_to_usbdev(interface);
> @@ -903,7 +923,7 @@ static void ath9k_hif_usb_disconnect(struct usb_interface *interface)
>        }
>
>        if (hif_dev->flags & HIF_USB_START)
> -               usb_reset_device(udev);
> +               ath9k_hif_usb_reboot(udev);
>
>        kfree(hif_dev);
>        dev_info(&udev->dev, "ath9k_htc: USB layer deinitialized\n");
> --
> 1.7.0.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

This patch seems to be the wrong way around... or is it supposed to be
applied using "patch -R"?

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
