Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:39632 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755858Ab3CUN56 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Mar 2013 09:57:58 -0400
Received: by mail-bk0-f44.google.com with SMTP id j4so1405739bkw.3
        for <linux-wireless@vger.kernel.org>; Thu, 21 Mar 2013 06:57:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <514AF0EA.9020504@tieto.com>
References: <CAPgLHd-BKoizHok9hDdAz9yBY1YqfpTov6s3CoefPTtbacQW3g@mail.gmail.com>
	<514AF0EA.9020504@tieto.com>
Date: Thu, 21 Mar 2013 21:57:56 +0800
Message-ID: <CAPgLHd9tUibxW53tQXhCsS9LPsgn=UA2Zj8O4Fxet0u7eEK7cQ@mail.gmail.com> (sfid-20130321_145802_123232_F3F77ECF)
Subject: Re: [linux-nfc] [PATCH] NFC: microread: use kfree_skb() instead of kfree()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: waldemar.rymarkiewicz@tieto.com
Cc: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	sameo@linux.intel.com, yongjun_wei@trendmicro.com.cn,
	linux-wireless@vger.kernel.org, linux-nfc@lists.01.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/21/2013 07:37 PM, Rymarkiewicz Waldemar wrote:
> Hi,
>
>> Use kfree_skb() instead of kfree() to free sk_buff.
>>
>> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>> ---
>>   drivers/nfc/microread/mei.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/nfc/microread/mei.c b/drivers/nfc/microread/mei.c
>> index eef38cf..da8264c 100644
>> --- a/drivers/nfc/microread/mei.c
>> +++ b/drivers/nfc/microread/mei.c
>> @@ -130,7 +130,7 @@ static void microread_event_cb(struct mei_device *device, u32 events,
>>
>>           reply_size = mei_recv(device, skb->data, MEI_NFC_MAX_READ);
>>           if (reply_size < MEI_NFC_HEADER_SIZE) {
>> -            kfree(skb);
>> +            kfree_skb(skb);
>>               return;
>>           }
>
> kfree_skb call is used internally by the kernel. A driver should use dev_kfree_skb instead, I guess.

It seems that dev_kfree_skb() call when dev_alloc_skb() is used, and
kfree_skb() use to free skb malloced by alloc_skb().

Regards,
Yongjun Wei 


