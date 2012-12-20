Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f180.google.com ([209.85.216.180]:53442 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab2LTSIS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2012 13:08:18 -0500
Message-ID: <50D35243.5080201@lwfinger.net> (sfid-20121220_190823_146458_7F89A502)
Date: Thu, 20 Dec 2012 12:00:35 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
CC: linux-wireless@vger.kernel.org,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>, stable@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: fix incorrect use of usb_alloc_coherent with
 usb_control_msg
References: <20121220142443.16895.45834.stgit@localhost6.localdomain6>
In-Reply-To: <20121220142443.16895.45834.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/20/2012 08:24 AM, Jussi Kivilinna wrote:
> Incorrect use of usb_alloc_coherent memory as input buffer to usb_control_msg
> can cause problems in arch DMA code, for example kernel BUG at
> 'arch/arm/include/asm/dma-mapping.h:321' on ARM (linux-3.4).
>
> Change _usb_writeN_sync use kmalloc'd buffer instead.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
> ---
>   drivers/net/wireless/rtlwifi/usb.c |    7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks. My only test platforms are X86 and PPC-32. Neither showed this problem.

Larry
>
> diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
> index 29f0969..a3312b7 100644
> --- a/drivers/net/wireless/rtlwifi/usb.c
> +++ b/drivers/net/wireless/rtlwifi/usb.c
> @@ -210,17 +210,16 @@ static void _usb_writeN_sync(struct rtl_priv *rtlpriv, u32 addr, void *data,
>   	u16 index = REALTEK_USB_VENQT_CMD_IDX;
>   	int pipe = usb_sndctrlpipe(udev, 0); /* write_out */
>   	u8 *buffer;
> -	dma_addr_t dma_addr;
>
> -	wvalue = (u16)(addr&0x0000ffff);
> -	buffer = usb_alloc_coherent(udev, (size_t)len, GFP_ATOMIC, &dma_addr);
> +	wvalue = (u16)(addr & 0x0000ffff);
> +	buffer = kmalloc(len, GFP_ATOMIC);
>   	if (!buffer)
>   		return;
>   	memcpy(buffer, data, len);
>   	usb_control_msg(udev, pipe, request, reqtype, wvalue,
>   			index, buffer, len, 50);
>
> -	usb_free_coherent(udev, (size_t)len, buffer, dma_addr);
> +	kfree(buffer);
>   }
>
>   static void _rtl_usb_io_handler_init(struct device *dev,
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

