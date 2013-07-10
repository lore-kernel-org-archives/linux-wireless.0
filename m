Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f180.google.com ([209.85.216.180]:58162 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970Ab3GJT1e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jul 2013 15:27:34 -0400
Received: by mail-qc0-f180.google.com with SMTP id a1so3910337qcx.11
        for <linux-wireless@vger.kernel.org>; Wed, 10 Jul 2013 12:27:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1373438404-5871-2-git-send-email-linux@rempel-privat.de>
References: <1373438404-5871-1-git-send-email-linux@rempel-privat.de>
	<1373438404-5871-2-git-send-email-linux@rempel-privat.de>
Date: Wed, 10 Jul 2013 12:27:33 -0700
Message-ID: <CAJ-Vmo=XPbOxmp=Kz-2Bp289YYFSrPuOb7u0FE1cxUmN-TpSrQ@mail.gmail.com> (sfid-20130710_212740_899941_CA779886)
Subject: Re: [PATCH 2/2] ath9k_htc: reboot firmware if it was loaded
From: Adrian Chadd <adrian@freebsd.org>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Great catch!


-adrian

On 9 July 2013 23:40, Oleksij Rempel <linux@rempel-privat.de> wrote:
> Currently ath9k_htc will reboot firmware only if interface was
> ever started. Which lead to the problem in case where interface
> was never started but module need to be reloaded.
>
> This patch will partially fix bug "ath9k_htc: Target is unresponsive"
> https://github.com/qca/open-ath9k-htc-firmware/issues/1
>
> Reproduction case:
> - plug adapter
> - make sure nothing will touch it. Stop Networkmanager or blacklist mac address of this adapter.
> - rmmod ath9k_htc; sleep 1; modprobe ath9k_htc
>
> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
> ---
>  drivers/net/wireless/ath/ath9k/hif_usb.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
> index 2469db5..5205a36 100644
> --- a/drivers/net/wireless/ath/ath9k/hif_usb.c
> +++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
> @@ -1295,7 +1295,9 @@ static void ath9k_hif_usb_disconnect(struct usb_interface *interface)
>
>         usb_set_intfdata(interface, NULL);
>
> -       if (!unplugged && (hif_dev->flags & HIF_USB_START))
> +       /* If firmware was loaded we should drop it
> +        * go back to first stage bootloader. */
> +       if (!unplugged && (hif_dev->flags & HIF_USB_READY))
>                 ath9k_hif_usb_reboot(udev);
>
>         kfree(hif_dev);
> --
> 1.8.1.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
