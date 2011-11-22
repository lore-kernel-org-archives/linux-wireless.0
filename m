Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43547 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755393Ab1KVAGA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 19:06:00 -0500
Received: by yenq3 with SMTP id q3so5316649yen.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 Nov 2011 16:06:00 -0800 (PST)
Message-ID: <4ECAE764.4000407@lwfinger.net> (sfid-20111122_010605_152034_597AF29F)
Date: Mon, 21 Nov 2011 18:05:56 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org,
	Chaoming Li <chaoming_li@realsil.com.cn>
Subject: Re: [PATCH] rtlwifi: squash warning in _usb_read_sync
References: <1321911446-11564-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1321911446-11564-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/21/2011 03:37 PM, John W. Linville wrote:
> drivers/net/wireless/rtlwifi/usb.c: In function ‘_usb_read_sync’:
> drivers/net/wireless/rtlwifi/usb.c:102:6: warning: ‘status’ may be used uninitialized in this function
> drivers/net/wireless/rtlwifi/usb.c:102:6: note: ‘status’ was declared here
>
> My compiler is dumb, but better to eliminate the warning then to have
> anyone waste time evaluating this again...
>
> Signed-off-by: John W. Linville<linville@tuxdriver.com>
> ---
>   drivers/net/wireless/rtlwifi/usb.c |    5 +++--
>   1 files changed, 3 insertions(+), 2 deletions(-)

I like this fix a lot better than initializing 'status' to zero.

ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>


>
> diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
> index 79889b8..20f4403 100644
> --- a/drivers/net/wireless/rtlwifi/usb.c
> +++ b/drivers/net/wireless/rtlwifi/usb.c
> @@ -107,7 +107,7 @@ static int _usbctrl_vendorreq_sync_read(struct usb_device *udev, u8 request,
>   	pipe = usb_rcvctrlpipe(udev, 0); /* read_in */
>   	reqtype =  REALTEK_USB_VENQT_READ;
>
> -	while (++vendorreq_times<= MAX_USBCTRL_VENDORREQ_TIMES) {
> +	do {
>   		status = usb_control_msg(udev, pipe, request, reqtype, value,
>   					 index, pdata, len, 0); /*max. timeout*/
>   		if (status<  0) {
> @@ -118,7 +118,8 @@ static int _usbctrl_vendorreq_sync_read(struct usb_device *udev, u8 request,
>   		} else {
>   			break;
>   		}
> -	}
> +	} while (++vendorreq_times<  MAX_USBCTRL_VENDORREQ_TIMES);
> +
>   	if (status<  0&&  count++<  4)
>   		pr_err("reg 0x%x, usbctrl_vendorreq TimeOut! status:0x%x value=0x%x\n",
>   		       value, status, le32_to_cpu(*(u32 *)pdata));

