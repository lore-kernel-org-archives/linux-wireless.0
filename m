Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:56057 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933142Ab2J2Vom (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2012 17:44:42 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so7312454iea.19
        for <linux-wireless@vger.kernel.org>; Mon, 29 Oct 2012 14:44:41 -0700 (PDT)
Message-ID: <508EF8C6.20305@lwfinger.net> (sfid-20121029_224451_850943_2220699C)
Date: Mon, 29 Oct 2012 16:44:38 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: Albert Pool <albertpool@solcon.nl>, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org, devel@linuxdriverproject.org
Subject: Re: Unknown Realtek USB device
References: <508EB140.5010102@solcon.nl> <201210291820.03101.chunkeey@googlemail.com>
In-Reply-To: <201210291820.03101.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/29/2012 12:20 PM, Christian Lamparter wrote:
> On Monday, October 29, 2012 05:39:28 PM Albert Pool wrote:
>> Can any of you help me identify the Realtek chip in this device so that the USB ID can be added to the right driver?
>> It's a 802.11n USB nano dongle from ISY. I only have the dongle for short time, so I may not be able to test it
>> myself if it takes some time. usb-devices and lsusb -v output is attached.
>
> Is it a ISY IWL 2000 device? Then it could be supported by rtl8192cu:
>
> <http://forum.ubuntuusers.de/topic/isy-iwl-2000-n150-standard-wird-nicht-erkannt/#post-4641162>
>
> Note:
> you'll have to have to correct firmware in place as well. Either
> you have to install a realtek firmware package (rtlwifi) for your
> distro... Or download it manually (filename: rtlwifi/rtl8192cufw.bin
> <http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git>)
> and put it into the correct place (/lib/firmware/(rtlwifi))
>
> Regards,
> 	Chr
> ---
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
> index 9970c2b..d4338fd 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
> @@ -297,6 +297,7 @@ static struct usb_device_id rtl8192c_usb_ids[] = {
>   	/*=== Customer ID ===*/
>   	/****** 8188CU ********/
>   	{RTL_USB_DEVICE(0x050d, 0x1102, rtl92cu_hal_cfg)}, /*Belkin - Edimax*/
> +	{RTL_USB_DEVICE(0x050d, 0x11f2, rtl92cu_hal_cfg)}, /*Belkin - Edimax*/
>   	{RTL_USB_DEVICE(0x06f8, 0xe033, rtl92cu_hal_cfg)}, /*Hercules - Edimax*/
>   	{RTL_USB_DEVICE(0x07b8, 0x8188, rtl92cu_hal_cfg)}, /*Abocom - Abocom*/
>   	{RTL_USB_DEVICE(0x07b8, 0x8189, rtl92cu_hal_cfg)}, /*Funai - Abocom*/

You also need a kernel 2.6.39 or newer. If you have one older that 3.4, I would 
suggest using compat-wireless.

Larry


