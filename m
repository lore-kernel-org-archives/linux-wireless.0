Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59739 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbcGEN4d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2016 09:56:33 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Jes.Sorensen@redhat.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Subject: Re: [PATCH 4/4] rtl8xxxu: Mark 0x2001:0x3308 as tested
References: <1466706955-10339-1-git-send-email-Jes.Sorensen@redhat.com>
	<1466706955-10339-5-git-send-email-Jes.Sorensen@redhat.com>
Date: Tue, 05 Jul 2016 16:56:28 +0300
In-Reply-To: <1466706955-10339-5-git-send-email-Jes.Sorensen@redhat.com> (Jes
	Sorensen's message of "Thu, 23 Jun 2016 14:35:55 -0400")
Message-ID: <87d1ms2noz.fsf@kamboji.qca.qualcomm.com> (sfid-20160705_155752_472501_35F58DC8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes.Sorensen@redhat.com writes:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>
> D-Link DWA-121 is reported as working.
>
> Reported-by: Stefano Bravi <stefanobravi69@libero.it>
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> ---
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> index 90d21c3..dfe61e4 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> @@ -5856,6 +5856,10 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
>  		if (id->idProduct == 0x648b)
>  			untested = 0;
>  		break;
> +	case 0x2001:
> +		if (id->idProduct == 0x3308)
> +			untested = 0;
> +		break;
>  	default:
>  		break;
>  	}
> @@ -6028,6 +6032,9 @@ static struct usb_device_id dev_table[] = {
>  /* Tested by Jocelyn Mayer */
>  {USB_DEVICE_AND_INTERFACE_INFO(0x20f4, 0x648b, 0xff, 0xff, 0xff),
>  	.driver_info = (unsigned long)&rtl8192cu_fops},
> +/* Tested by Stefano Bravi */
> +{USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x3308, 0xff, 0xff, 0xff),
> +	.driver_info = (unsigned long)&rtl8192cu_fops},
>  /* Currently untested 8188 series devices */
>  {USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x8191, 0xff, 0xff, 0xff),
>  	.driver_info = (unsigned long)&rtl8192cu_fops},
> @@ -6075,8 +6082,6 @@ static struct usb_device_id dev_table[] = {
>  	.driver_info = (unsigned long)&rtl8192cu_fops},
>  {USB_DEVICE_AND_INTERFACE_INFO(0x13d3, 0x3357, 0xff, 0xff, 0xff),
>  	.driver_info = (unsigned long)&rtl8192cu_fops},
> -{USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x3308, 0xff, 0xff, 0xff),
> -	.driver_info = (unsigned long)&rtl8192cu_fops},

Isn't this also supported by rtlwifi?

drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c:    {RTL_USB_DEVICE(0x2001, 0x3308, rtl92cu_hal_cfg)}, /*D-Link - Alpha*/

-- 
Kalle Valo
