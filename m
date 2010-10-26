Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54358 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774Ab0JZPmo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 11:42:44 -0400
Received: by pzk3 with SMTP id 3so906924pzk.19
        for <linux-wireless@vger.kernel.org>; Tue, 26 Oct 2010 08:42:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1288104164-18940-1-git-send-email-rmanoharan@atheros.com>
References: <1288104164-18940-1-git-send-email-rmanoharan@atheros.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 26 Oct 2010 08:37:18 -0700
Message-ID: <AANLkTin+TtPKtOgWd2+BZyYLpP4Jagv4u68CALjBNc7G@mail.gmail.com>
Subject: Re: [PATCH] ath9k_htc: Set proper firmware offset for AR7010 devices
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 26, 2010 at 7:42 AM, Rajkumar Manoharan
<rmanoharan@atheros.com> wrote:
> This patch handles the firmware loading properly for
> AR7010 HTC devices.

This description is vague, you could have said instead that it treats
0x9018 as a AR7010.

  Luis

> Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/hif_usb.c |   10 ++++++++--
>  1 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
> index 728d904..6576f68 100644
> --- a/drivers/net/wireless/ath/ath9k/hif_usb.c
> +++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
> @@ -801,10 +801,16 @@ static int ath9k_hif_usb_download_fw(struct hif_device_usb *hif_dev)
>        }
>        kfree(buf);
>
> -       if ((hif_dev->device_id == 0x7010) || (hif_dev->device_id == 0x7015))
> +       switch (hif_dev->device_id) {
> +       case 0x7010:
> +       case 0x7015:
> +       case 0x9018:
>                firm_offset = AR7010_FIRMWARE_TEXT;
> -       else
> +               break;
> +       default:
>                firm_offset = AR9271_FIRMWARE_TEXT;
> +               break;
> +       }
>
>        /*
>         * Issue FW download complete command to firmware.
> --
> 1.7.3.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
