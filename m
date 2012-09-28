Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:58783 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753355Ab2I1RhM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2012 13:37:12 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Wei Yongjun <weiyj.lk@gmail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 28 Sep 2012 10:37:05 -0700
Subject: RE: [PATCH] mwifiex: convert to use le16_add_cpu()
Message-ID: <477F20668A386D41ADCC57781B1F7043083B590C46@SC-VEXCH1.marvell.com> (sfid-20120928_193717_173155_B39E03A0)
References: <CAPgLHd-8KQjVnouB15F5Yc0LPrZQwnHUCa9gwjpZXEGAMzjk=g@mail.gmail.com>
In-Reply-To: <CAPgLHd-8KQjVnouB15F5Yc0LPrZQwnHUCa9gwjpZXEGAMzjk=g@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Wei,

Thanks for your patch.

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Convert cpu_to_le16(le16_to_cpu(E1) + E2) to use le16_add_cpu().
> 
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Bing Zhao <bzhao@marvell.com>

Thanks,
Bing

> ---
>  drivers/net/wireless/mwifiex/scan.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
> index 04dc7ca..8272562 100644
> --- a/drivers/net/wireless/mwifiex/scan.c
> +++ b/drivers/net/wireless/mwifiex/scan.c
> @@ -614,9 +614,8 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv,
> 
>  			/* Increment the TLV header length by the size
>  			   appended */
> -			chan_tlv_out->header.len =
> -			cpu_to_le16(le16_to_cpu(chan_tlv_out->header.len) +
> -			(sizeof(chan_tlv_out->chan_scan_param)));
> +			le16_add_cpu(&chan_tlv_out->header.len,
> +				     sizeof(chan_tlv_out->chan_scan_param));
> 
>  			/*
>  			 * The tlv buffer length is set to the number of bytes
> 
> 
> --
