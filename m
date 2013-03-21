Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:50216 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932084Ab3CULhS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Mar 2013 07:37:18 -0400
Message-ID: <514AF0EA.9020504@tieto.com> (sfid-20130321_123727_467053_88A7C3E2)
Date: Thu, 21 Mar 2013 12:37:14 +0100
From: Rymarkiewicz Waldemar <waldemar.rymarkiewicz@tieto.com>
MIME-Version: 1.0
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: "lauro.venancio@openbossa.org" <lauro.venancio@openbossa.org>,
	"aloisio.almeida@openbossa.org" <aloisio.almeida@openbossa.org>,
	"sameo@linux.intel.com" <sameo@linux.intel.com>,
	"yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-nfc@lists.01.org" <linux-nfc@lists.01.org>
Subject: Re: [linux-nfc] [PATCH] NFC: microread: use kfree_skb() instead of
 kfree()
References: <CAPgLHd-BKoizHok9hDdAz9yBY1YqfpTov6s3CoefPTtbacQW3g@mail.gmail.com>
In-Reply-To: <CAPgLHd-BKoizHok9hDdAz9yBY1YqfpTov6s3CoefPTtbacQW3g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Use kfree_skb() instead of kfree() to free sk_buff.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>   drivers/nfc/microread/mei.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/nfc/microread/mei.c b/drivers/nfc/microread/mei.c
> index eef38cf..da8264c 100644
> --- a/drivers/nfc/microread/mei.c
> +++ b/drivers/nfc/microread/mei.c
> @@ -130,7 +130,7 @@ static void microread_event_cb(struct mei_device *device, u32 events,
>
>   		reply_size = mei_recv(device, skb->data, MEI_NFC_MAX_READ);
>   		if (reply_size < MEI_NFC_HEADER_SIZE) {
> -			kfree(skb);
> +			kfree_skb(skb);
>   			return;
>   		}

kfree_skb call is used internally by the kernel. A driver should use 
dev_kfree_skb instead, I guess.

Thanks,
/Waldek
