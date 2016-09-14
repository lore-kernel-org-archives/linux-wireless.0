Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53675 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753427AbcINQ7Z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 12:59:25 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: Re: [PATCH 2/2] mwifiex: firmware name correction for usb8997 chipset
References: <1473686728-8101-1-git-send-email-akarwar@marvell.com>
        <1473686728-8101-3-git-send-email-akarwar@marvell.com>
Date: Wed, 14 Sep 2016 19:59:19 +0300
In-Reply-To: <1473686728-8101-3-git-send-email-akarwar@marvell.com> (Amitkumar
        Karwar's message of "Mon, 12 Sep 2016 18:55:28 +0530")
Message-ID: <87poo6ct94.fsf@kamboji.qca.qualcomm.com> (sfid-20160914_185930_072173_B95F92D2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> writes:

> From: Ganapathi Bhat <gbhat@marvell.com>
>
> Similar to pcie8997 chipset, first firmware submitted for usb8997
> chipset will be usbusb8997_combo_v4.bin. This patch corrects the
> name used in driver.
>
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> ---
>  drivers/net/wireless/marvell/mwifiex/usb.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/usb.h b/drivers/net/wireless/marvell/mwifiex/usb.h
> index 1b49c52..30e8eb8 100644
> --- a/drivers/net/wireless/marvell/mwifiex/usb.h
> +++ b/drivers/net/wireless/marvell/mwifiex/usb.h
> @@ -46,7 +46,7 @@
>  #define USB8766_DEFAULT_FW_NAME	"mrvl/usb8766_uapsta.bin"
>  #define USB8797_DEFAULT_FW_NAME	"mrvl/usb8797_uapsta.bin"
>  #define USB8801_DEFAULT_FW_NAME	"mrvl/usb8801_uapsta.bin"
> -#define USB8997_DEFAULT_FW_NAME	"mrvl/usb8997_uapsta.bin"
> +#define USB8997_DEFAULT_FW_NAME	"mrvl/usbusb8997_combo_v4.bin"

Like discussed earlier, the firmware names are supposed to be stable. I
consider them to be an interface between kernel and user space. Instead
of changing the driver you should actually rename the firmware file. I'm
planning to take this anyway but in the future please pay extra
attention to do this properly.

My recommendation is to keep the firmware name simple as possible and
get rid of any extra cruft, for example in this case a good name would
be "mrvl/usb8997.bin". That extra "usb" and "combo_v4" don't bring any
benefit.

-- 
Kalle Valo
