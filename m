Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40600 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753804AbcJZPzi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 11:55:38 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Barry Day <briselec@gmail.com>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH] rtl8xxxu: Add D-Link DWA-131 rev E1
References: <20161025202928.GA10934@box64.home.org>
Date: Wed, 26 Oct 2016 11:55:37 -0400
In-Reply-To: <20161025202928.GA10934@box64.home.org> (Barry Day's message of
        "Wed, 26 Oct 2016 06:29:37 +1000")
Message-ID: <wrfj1sz3nlza.fsf@redhat.com> (sfid-20161026_175541_959625_E685F25E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Barry Day <briselec@gmail.com> writes:
> This is a rtl8192eu dongle and has been tested
>
> Signed-off-by: Barry Day <briselec@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Thanks, I'll add it to my queue, unless Kalle grabs it first. Glad to
know it's working for you!

Jes

> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> index 04141e5..d426836 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> @@ -6009,7 +6009,7 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
>  			untested = 0;
>  		break;
>  	case 0x2001:
> -		if (id->idProduct == 0x3308)
> +		if (id->idProduct == 0x3308 || id->idProduct == 0x3319)
>  			untested = 0;
>  		break;
>  	case 0x2357:
> @@ -6188,6 +6188,8 @@ static struct usb_device_id dev_table[] = {
>  	.driver_info = (unsigned long)&rtl8723au_fops},
>  {USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x818b, 0xff, 0xff, 0xff),
>  	.driver_info = (unsigned long)&rtl8192eu_fops},
> +{USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x3319, 0xff, 0xff, 0xff),
> +	.driver_info = (unsigned long)&rtl8192eu_fops},
>  /* Tested by Myckel Habets */
>  {USB_DEVICE_AND_INTERFACE_INFO(0x2357, 0x0109, 0xff, 0xff, 0xff),
>  	.driver_info = (unsigned long)&rtl8192eu_fops},
