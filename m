Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f179.google.com ([209.85.221.179]:35963 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778Ab0DVOVJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Apr 2010 10:21:09 -0400
Received: by qyk9 with SMTP id 9so11294914qyk.1
        for <linux-wireless@vger.kernel.org>; Thu, 22 Apr 2010 07:21:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <19407.50660.739033.942199@gargle.gargle.HOWL>
References: <19407.50660.739033.942199@gargle.gargle.HOWL>
Date: Thu, 22 Apr 2010 22:21:06 +0800
Message-ID: <j2nd82e647a1004220721n4668229l51c6e27a21ec9f8c@mail.gmail.com>
Subject: Re: [PATCH 7/9] ath9k_htc: Use USB reboot
From: Ming Lei <tom.leiming@gmail.com>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/4/22 Sujith <Sujith.Manoharan@atheros.com>:
> So, apparently there is a USB reboot command
> that the target accepts. Using this instead of
> usb_reset_device() fixes the issue of "descriptor read error"
> that pops up on repeated load/unload.
>
> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/hif_usb.c |   13 ++++++++++++-
>  1 files changed, 12 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
> index cee5feb..ce13e08 100644
> --- a/drivers/net/wireless/ath/ath9k/hif_usb.c
> +++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
> @@ -889,6 +889,17 @@ err_alloc:
>        return ret;
>  }
>
> +static void ath9k_hif_usb_reboot(struct usb_device *udev)
> +{
> +       u32 cmd = 0xffffffff;
> +       int ret;
> +
> +       ret = usb_bulk_msg(udev, usb_sndbulkpipe(udev, USB_REG_OUT_PIPE),
> +                          &cmd, sizeof(cmd), NULL, HZ);

The buffer passed to usb hcd should not be allocated from stack since
it will be DMAed to usb host controller. The 'cmd' should be allocated by
kmalloc even though it is only 4byte.


-- 
Lei Ming
