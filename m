Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f31.google.com ([209.85.219.31]:50769 "EHLO
	mail-ew0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbYLQNVh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 08:21:37 -0500
Received: by ewy12 with SMTP id 12so3629632ewy.13
        for <linux-wireless@vger.kernel.org>; Wed, 17 Dec 2008 05:21:35 -0800 (PST)
Message-ID: <4948FCDC.1000703@gmail.com> (sfid-20081217_142141_172431_0D21FE08)
Date: Wed, 17 Dec 2008 14:21:32 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] p54usb: bring first generation devices back to life
References: <200812171204.43946.chunkeey@web.de>
In-Reply-To: <200812171204.43946.chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> This patch fixes a serious regression (introduced by:
> "p54: fix memory management" 872037115977dc0 )
> that affected isl3886+net2280 usb devices operation.
> 
> Signed-off-by: Christian Lamparter <chunkeey@web.de>
> ---
> Artur, can you please test the attached patch.
> if it works, please add a tested-by/acked/signed-off (whatever you want) line.

patch works.

Tested-by: Artur Skawina <art.08.09@gmail.com>

> ---
> John,
> 
> This patch is made against the current wireless-testing.
> (so I hope you don't get any rejects if you merge put it into wireless-2.6 straight away).
> Of course, I tried to apply them on top of the last patch (free after tx) and all you
> get is little complaint about offsets.. e.g:
> 
> patching file p54usb.c
> Hunk #1 succeeded at 301 (offset -13 lines).
> Hunk #2 succeeded at 327 (offset -13 lines).
> ---
> diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
> index 9c2c651..62c2ad4 100644
> --- a/drivers/net/wireless/p54/p54usb.c
> +++ b/drivers/net/wireless/p54/p54usb.c
> @@ -314,6 +314,8 @@ static void p54u_tx_net2280(struct ieee80211_hw *dev, struct sk_buff *skb,
>  	struct net2280_tx_hdr *hdr;
>  	struct net2280_reg_write *reg;
>  	int err = 0;
> +	__le32 addr = ((struct p54_hdr *) skb->data)->req_id;
> +	__le16 len = cpu_to_le16(skb->len);
>  
>  	reg = kmalloc(sizeof(*reg), GFP_ATOMIC);
>  	if (!reg)
> @@ -338,8 +340,8 @@ static void p54u_tx_net2280(struct ieee80211_hw *dev, struct sk_buff *skb,
>  
>  	hdr = (void *)skb_push(skb, sizeof(*hdr));
>  	memset(hdr, 0, sizeof(*hdr));
> -	hdr->device_addr = ((struct p54_hdr *)skb->data)->req_id;
> -	hdr->len = cpu_to_le16(skb->len + sizeof(struct p54_hdr));
> +	hdr->len = len;
> +	hdr->device_addr = addr;
>  
>  	usb_fill_bulk_urb(int_urb, priv->udev,
>  		usb_sndbulkpipe(priv->udev, P54U_PIPE_DEV), reg, sizeof(*reg),
> 
> 

