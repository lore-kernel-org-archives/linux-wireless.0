Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:47382 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab3DNURC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Apr 2013 16:17:02 -0400
Received: by mail-ee0-f50.google.com with SMTP id e53so1979628eek.23
        for <linux-wireless@vger.kernel.org>; Sun, 14 Apr 2013 13:17:00 -0700 (PDT)
References: <1365519930-3230-1-git-send-email-stf_xl@wp.pl> <1365519930-3230-6-git-send-email-stf_xl@wp.pl> <5FA86BE2-7773-4D09-B891-6B1C80DCED72@gmail.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <5FA86BE2-7773-4D09-B891-6B1C80DCED72@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <E77B5173-475B-4218-8C16-9B3249B376C5@gmail.com> (sfid-20130414_221706_542365_E3EE0019)
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 05/11] rt2800: move GPIO_SWITCH setup to 3390 specific rfcsr init
Date: Sun, 14 Apr 2013 22:16:58 +0200
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
>> Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
>> ---
>> drivers/net/wireless/rt2x00/rt2800lib.c |   12 +++++++-----
>> 1 files changed, 7 insertions(+), 5 deletions(-)
>> 
>> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
>> index 216ceb6..83554da 100644
>> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
>> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
>> @@ -4668,6 +4668,8 @@ static void rt2800_init_rfcsr_3352(struct rt2x00_dev *rt2x00dev)
>> 
>> static void rt2800_init_rfcsr_3390(struct rt2x00_dev *rt2x00dev)
>> {
>> +    u32 reg;
>> +
>>   rt2800_rfcsr_write(rt2x00dev, 0, 0xa0);
>>   rt2800_rfcsr_write(rt2x00dev, 1, 0xe1);
>>   rt2800_rfcsr_write(rt2x00dev, 2, 0xf1);
>> @@ -4700,6 +4702,10 @@ static void rt2800_init_rfcsr_3390(struct rt2x00_dev *rt2x00dev)
>>   rt2800_rfcsr_write(rt2x00dev, 29, 0x8f);
>>   rt2800_rfcsr_write(rt2x00dev, 30, 0x20);
>>   rt2800_rfcsr_write(rt2x00dev, 31, 0x0f);
>> +
>> +    rt2800_register_read(rt2x00dev, GPIO_SWITCH, &reg);
>> +    rt2x00_set_field32(&reg, GPIO_SWITCH_5, 0);
>> +    rt2800_register_write(rt2x00dev, GPIO_SWITCH, reg);
>> }
>> 
>> static void rt2800_init_rfcsr_3572(struct rt2x00_dev *rt2x00dev)
>> @@ -4985,11 +4991,7 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>>   }
>> 
>> 
>> -    if (rt2x00_rt(rt2x00dev, RT3390)) {
>> -        rt2800_register_read(rt2x00dev, GPIO_SWITCH, &reg);
>> -        rt2x00_set_field32(&reg, GPIO_SWITCH_5, 0);
>> -        rt2800_register_write(rt2x00dev, GPIO_SWITCH, reg);
>> -    } else if (rt2x00_rt(rt2x00dev, RT3572)) {
>> +    if (rt2x00_rt(rt2x00dev, RT3572)) {
>>       rt2800_rfcsr_read(rt2x00dev, 6, &rfcsr);
>>       rt2x00_set_field8(&rfcsr, RFCSR6_R2, 1);
>>       rt2800_rfcsr_write(rt2x00dev, 6, rfcsr);
>> -- 
>> 1.7.4.4
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
