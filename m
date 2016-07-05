Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59410 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779AbcGENzF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2016 09:55:05 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Jes.Sorensen@redhat.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Subject: Re: [PATCH 3/4] rtl8xxxu: Mark 0x20f4:0x648b as tested
References: <1466706955-10339-1-git-send-email-Jes.Sorensen@redhat.com>
	<1466706955-10339-4-git-send-email-Jes.Sorensen@redhat.com>
Date: Tue, 05 Jul 2016 16:54:58 +0300
In-Reply-To: <1466706955-10339-4-git-send-email-Jes.Sorensen@redhat.com> (Jes
	Sorensen's message of "Thu, 23 Jun 2016 14:35:54 -0400")
Message-ID: <87h9c42nrh.fsf@kamboji.qca.qualcomm.com> (sfid-20160705_155821_919869_4116BFD1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes.Sorensen@redhat.com writes:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>
> Successfully tested by Jocelyn Mayer
>
> Reported-by: J. Mayer <l_indien@magic.fr>
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> ---
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> index cfa5528..90d21c3 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> @@ -5852,6 +5852,10 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
>  		if (id->idProduct == 0x1004)
>  			untested = 0;
>  		break;
> +	case 0x20f4:
> +		if (id->idProduct == 0x648b)
> +			untested = 0;
> +		break;
>  	default:
>  		break;
>  	}
> @@ -6021,6 +6025,9 @@ static struct usb_device_id dev_table[] = {
>  /* Tested by Andrea Merello */
>  {USB_DEVICE_AND_INTERFACE_INFO(0x050d, 0x1004, 0xff, 0xff, 0xff),
>  	.driver_info = (unsigned long)&rtl8192cu_fops},
> +/* Tested by Jocelyn Mayer */
> +{USB_DEVICE_AND_INTERFACE_INFO(0x20f4, 0x648b, 0xff, 0xff, 0xff),
> +	.driver_info = (unsigned long)&rtl8192cu_fops},
>  /* Currently untested 8188 series devices */
>  {USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x8191, 0xff, 0xff, 0xff),
>  	.driver_info = (unsigned long)&rtl8192cu_fops},
> @@ -6080,8 +6087,6 @@ static struct usb_device_id dev_table[] = {
>  	.driver_info = (unsigned long)&rtl8192cu_fops},
>  {USB_DEVICE_AND_INTERFACE_INFO(0x2019, 0xed17, 0xff, 0xff, 0xff),
>  	.driver_info = (unsigned long)&rtl8192cu_fops},
> -{USB_DEVICE_AND_INTERFACE_INFO(0x20f4, 0x648b, 0xff, 0xff, 0xff),
> -	.driver_info = (unsigned long)&rtl8192cu_fops},
>  {USB_DEVICE_AND_INTERFACE_INFO(0x4855, 0x0090, 0xff, 0xff, 0xff),
>  	.driver_info = (unsigned long)&rtl8192cu_fops},
>  {USB_DEVICE_AND_INTERFACE_INFO(0x4856, 0x0091, 0xff, 0xff, 0xff),

But will this now conflict with rtlwifi?

drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c:    {RTL_USB_DEVICE(0x20f4, 0x648b, rtl92cu_hal_cfg)}, /*TRENDnet - Cameo*/

Like discussed before, I don't like having two drivers support same
hardware and users more or less randomly using either of them.

-- 
Kalle Valo
