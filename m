Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:63566 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbZKLJv0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2009 04:51:26 -0500
Received: by bwz27 with SMTP id 27so1991297bwz.21
        for <linux-wireless@vger.kernel.org>; Thu, 12 Nov 2009 01:51:31 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH V2] p54usb: Remove DMA buffer from stack
Date: Thu, 12 Nov 2009 10:51:11 +0100
Cc: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <4afb5095.fKs+0FCQC9sTYyFW%Larry.Finger@lwfinger.net>
In-Reply-To: <4afb5095.fKs+0FCQC9sTYyFW%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200911121051.11982.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 12 November 2009 01:02:29 Larry Finger wrote:
> On 2.6.32-rc6 from wireless-testing, the following warning is emitted:
> 
> ------------[ cut here ]------------ 
> WARNING: at lib/dma-debug.c:860 check_for_stack+0xaa/0xe0() 
> Hardware name: HP Pavilion dv2700 Notebook PC 
> ehci_hcd 0000:00:02.1: DMA-API: device driver maps memory fromstack
> 	 [addr=ffff8800b6e2bca8] 
> Modules linked in: <Removed> 
> Pid: 16378, comm: modprobe Not tainted 2.6.32-rc6-wl #244 
> Call Trace: 
>  [<ffffffff81049698>] warn_slowpath_common+0x78/0xb0 
>  [<ffffffff8104972c>] warn_slowpath_fmt+0x3c/0x40 
>  [<ffffffff811ae52a>] check_for_stack+0xaa/0xe0 
>  [<ffffffff811afc8d>] debug_dma_map_page+0xfd/0x170 
>  [<ffffffffa006297a>] usb_hcd_submit_urb+0x3da/0x9c0 [usbcore] 
>  [<ffffffff81076e6f>] ? lockdep_init_map+0x5f/0x5d0 
>  [<ffffffffa0063365>] usb_submit_urb+0xe5/0x260 [usbcore] 
>  [<ffffffffa0064b7e>] usb_start_wait_urb+0x5e/0xf0 [usbcore] 
>  [<ffffffffa0063943>] ? usb_init_urb+0x23/0x40 [usbcore] 
>  [<ffffffffa0064cd4>] usb_bulk_msg+0xc4/0x150 [usbcore] 
>  [<ffffffffa0441a91>] T.719+0x31/0x40 [p54usb] 
>  [<ffffffffa0441acf>] p54u_upload_firmware_3887+0x2f/0x490 [p54usb] 
>  [<ffffffffa049c667>] ? p54_parse_firmware+0x427/0x450 [p54common] 
>  <Rest of traceback removed>
> ---[ end trace f77df0316ddad3de ]--- 
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.org>
> ---
> 
> John,
> 
> This is 2.6.32 material. Sorry to find it so late in the rc cycle. I hop
> DaveM doesn't give you too much trouble.
> 
> V2 - Fix line wraps in trace back.
> 
> Larry
> ---
> 
> Index: wireless-testing/drivers/net/wireless/p54/p54usb.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/p54/p54usb.c
> +++ wireless-testing/drivers/net/wireless/p54/p54usb.c
> @@ -426,12 +426,16 @@ static const char p54u_romboot_3887[] =
>  static int p54u_firmware_reset_3887(struct ieee80211_hw *dev)
>  {
>  	struct p54u_priv *priv = dev->priv;
> -	u8 buf[4];
> +	u8 *buf;
>  	int ret;
>  
> -	memcpy(&buf, p54u_romboot_3887, sizeof(buf));
> +	buf = kmalloc(4, GFP_KERNEL);
> +	if (!buf)
> +		return -ENOMEM;
> + 	memcpy(buf, p54u_romboot_3887, 4);
>  	ret = p54u_bulk_msg(priv, P54U_PIPE_DATA,
> -			    buf, sizeof(buf));
> +			    buf, 4);
> +	kfree(buf);
>  	if (ret)
>  		dev_err(&priv->udev->dev, "(p54usb) unable to jump to "
>  			"boot ROM (%d)!\n", ret);
> 

Acked-by: Christian Lamparter <chunkeey@googlemail.com>

FYI, p54u_upload_firmware_net2280 will likely produce the same
same WARN, since "__le32 reg;" is held on the stack as well.

Regards,
	Chr
