Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:47806 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab3DNUUU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Apr 2013 16:20:20 -0400
Received: by mail-ee0-f42.google.com with SMTP id d4so1997123eek.29
        for <linux-wireless@vger.kernel.org>; Sun, 14 Apr 2013 13:20:19 -0700 (PDT)
References: <1365519930-3230-1-git-send-email-stf_xl@wp.pl> <1365519930-3230-12-git-send-email-stf_xl@wp.pl> <35BCCCCF-97E2-42EE-839F-89DB7542719B@gmail.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <35BCCCCF-97E2-42EE-839F-89DB7542719B@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <56F760F7-6987-4C58-80F9-C75DD492E06D@gmail.com> (sfid-20130414_222023_233850_13DD3F66)
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 11/11] rt2800: cleanup rt2800_init_rfcsr
Date: Sun, 14 Apr 2013 22:20:17 +0200
To: "stf_xl@wp.pl" <stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Resending as the message didn't seem to end up on the mailing list)

> Hi Stanislaw,
> 
> Looks good to me. When you repost the series with all comments fixed, you can add my acked-by.
> 
> Sent from my iPad
> 
> On 9 apr. 2013, at 17:05, stf_xl@wp.pl wrote:
> 
>> From: Stanislaw Gruszka <stf_xl@wp.pl>
>> 
>> This procedure is simple switch now and return no error any longer.
>> 
>> Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
>> ---
>> drivers/net/wireless/rt2x00/rt2800lib.c |   31 ++++++-------------------------
>> 1 files changed, 6 insertions(+), 25 deletions(-)
>> 
>> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
>> index f31b9b9..b084e90 100644
>> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
>> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
>> @@ -5100,29 +5100,11 @@ static void rt2800_init_rfcsr_5592(struct rt2x00_dev *rt2x00dev)
>>   rt2800_led_open_drain_enable(rt2x00dev);
>> }
>> 
>> -static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>> +static void rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>> {
>> -    struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
>> -    u8 rfcsr;
>> -    u32 reg;
>> -
>> -    if (!rt2x00_rt(rt2x00dev, RT3070) &&
>> -        !rt2x00_rt(rt2x00dev, RT3071) &&
>> -        !rt2x00_rt(rt2x00dev, RT3090) &&
>> -        !rt2x00_rt(rt2x00dev, RT3290) &&
>> -        !rt2x00_rt(rt2x00dev, RT3352) &&
>> -        !rt2x00_rt(rt2x00dev, RT3390) &&
>> -        !rt2x00_rt(rt2x00dev, RT3572) &&
>> -        !rt2x00_rt(rt2x00dev, RT5390) &&
>> -        !rt2x00_rt(rt2x00dev, RT5392) &&
>> -        !rt2x00_rt(rt2x00dev, RT5392) &&
>> -        !rt2x00_rt(rt2x00dev, RT5592) &&
>> -        !rt2800_is_305x_soc(rt2x00dev))
>> -        return 0;
>> -
>>   if (rt2800_is_305x_soc(rt2x00dev)) {
>>       rt2800_init_rfcsr_305x_soc(rt2x00dev);
>> -        return 0;
>> +        return;
>>   }
>> 
>>   switch (rt2x00dev->chip.rt) {
>> @@ -5151,10 +5133,8 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>>       break;
>>   case RT5592:
>>       rt2800_init_rfcsr_5592(rt2x00dev);
>> -        return 0;
>> +        break;
>>   }
>> -
>> -    return 0;
>> }
>> 
>> int rt2800_enable_radio(struct rt2x00_dev *rt2x00dev)
>> @@ -5180,10 +5160,11 @@ int rt2800_enable_radio(struct rt2x00_dev *rt2x00dev)
>>   }
>>   msleep(1);
>> 
>> -    if (unlikely(rt2800_init_bbp(rt2x00dev) ||
>> -             rt2800_init_rfcsr(rt2x00dev)))
>> +    if (unlikely(rt2800_init_bbp(rt2x00dev)))
>>       return -EIO;
>> 
>> +    rt2800_init_rfcsr(rt2x00dev);
>> +
>>   if (rt2x00_is_usb(rt2x00dev) &&
>>       (rt2x00_rt(rt2x00dev, RT3070) ||
>>        rt2x00_rt(rt2x00dev, RT3071) ||
>> -- 
>> 1.7.4.4
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
