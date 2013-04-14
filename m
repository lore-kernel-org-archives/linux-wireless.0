Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:56243 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab3DNUTB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Apr 2013 16:19:01 -0400
Received: by mail-ee0-f42.google.com with SMTP id d4so1902551eek.15
        for <linux-wireless@vger.kernel.org>; Sun, 14 Apr 2013 13:19:00 -0700 (PDT)
References: <1365519930-3230-1-git-send-email-stf_xl@wp.pl> <1365519930-3230-10-git-send-email-stf_xl@wp.pl> <0E1FF2EE-1777-42C7-9052-51895C784968@gmail.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <0E1FF2EE-1777-42C7-9052-51895C784968@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <CDF4806D-4662-4E6A-A58E-E9380A77F25E@gmail.com> (sfid-20130414_221911_315901_C6678984)
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 09/11] rt2800: add rt2800_led_open_drain_enable subroutine
Date: Sun, 14 Apr 2013 22:18:58 +0200
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
>> drivers/net/wireless/rt2x00/rt2800lib.c |   29 +++++++++++++++++++++++++----
>> 1 files changed, 25 insertions(+), 4 deletions(-)
>> 
>> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
>> index fe0df88..009fe47 100644
>> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
>> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
>> @@ -4332,6 +4332,15 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
>>   return 0;
>> }
>> 
>> +static void rt2800_led_open_drain_enable(struct rt2x00_dev *rt2x00dev)
>> +{
>> +    u32 reg;
>> +
>> +    rt2800_register_read(rt2x00dev, OPT_14_CSR, &reg);
>> +    rt2x00_set_field32(&reg, OPT_14_CSR_BIT0, 1);
>> +    rt2800_register_write(rt2x00dev, OPT_14_CSR, reg);
>> +}
>> +
>> static u8 rt2800_init_rx_filter(struct rt2x00_dev *rt2x00dev, bool bw40,
>>               u8 filter_target)
>> {
>> @@ -4593,6 +4602,8 @@ static void rt2800_init_rfcsr_30xx(struct rt2x00_dev *rt2x00dev)
>>       rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E) ||
>>       rt2x00_rt_rev_lt(rt2x00dev, RT3090, REV_RT3090E))
>>       rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
>> +
>> +    rt2800_led_open_drain_enable(rt2x00dev);
>> }
>> 
>> static void rt2800_init_rfcsr_3290(struct rt2x00_dev *rt2x00dev)
>> @@ -4653,6 +4664,8 @@ static void rt2800_init_rfcsr_3290(struct rt2x00_dev *rt2x00dev)
>>   rt2800_rfcsr_write(rt2x00dev, 29, rfcsr);
>> 
>>   rt2800_rx_filter_calibration(rt2x00dev);
>> +
>> +    rt2800_led_open_drain_enable(rt2x00dev);
>> }
>> 
>> static void rt2800_init_rfcsr_3352(struct rt2x00_dev *rt2x00dev)
>> @@ -4722,6 +4735,8 @@ static void rt2800_init_rfcsr_3352(struct rt2x00_dev *rt2x00dev)
>>   rt2800_rfcsr_write(rt2x00dev, 63, 0x00);
>> 
>>   rt2800_rx_filter_calibration(rt2x00dev);
>> +
>> +    rt2800_led_open_drain_enable(rt2x00dev);
>> }
>> 
>> static void rt2800_init_rfcsr_3390(struct rt2x00_dev *rt2x00dev)
>> @@ -4769,6 +4784,8 @@ static void rt2800_init_rfcsr_3390(struct rt2x00_dev *rt2x00dev)
>> 
>>   if (rt2x00_rt_rev_lt(rt2x00dev, RT3390, REV_RT3390E))
>>       rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
>> +
>> +    rt2800_led_open_drain_enable(rt2x00dev);
>> }
>> 
>> static void rt2800_init_rfcsr_3572(struct rt2x00_dev *rt2x00dev)
>> @@ -4823,6 +4840,8 @@ static void rt2800_init_rfcsr_3572(struct rt2x00_dev *rt2x00dev)
>>   rt2800_register_write(rt2x00dev, LDO_CFG0, reg);
>> 
>>   rt2800_rx_filter_calibration(rt2x00dev);
>> +
>> +    rt2800_led_open_drain_enable(rt2x00dev);
>> }
>> 
>> static void rt2800_init_rfcsr_5390(struct rt2x00_dev *rt2x00dev)
>> @@ -4911,6 +4930,8 @@ static void rt2800_init_rfcsr_5390(struct rt2x00_dev *rt2x00dev)
>>   rt2800_rfcsr_write(rt2x00dev, 63, 0x00);
>> 
>>   rt2800_normal_mode_setup_5xxx(rt2x00dev);
>> +
>> +    rt2800_led_open_drain_enable(rt2x00dev);
>> }
>> 
>> static void rt2800_init_rfcsr_5392(struct rt2x00_dev *rt2x00dev)
>> @@ -4978,6 +4999,8 @@ static void rt2800_init_rfcsr_5392(struct rt2x00_dev *rt2x00dev)
>>   rt2800_rfcsr_write(rt2x00dev, 63, 0x07);
>> 
>>   rt2800_normal_mode_setup_5xxx(rt2x00dev);
>> +
>> +    rt2800_led_open_drain_enable(rt2x00dev);
>> }
>> 
>> static void rt2800_init_rfcsr_5592(struct rt2x00_dev *rt2x00dev)
>> @@ -5018,6 +5041,8 @@ static void rt2800_init_rfcsr_5592(struct rt2x00_dev *rt2x00dev)
>> 
>>   if (rt2x00_rt_rev_lt(rt2x00dev, RT5592, REV_RT5592C))
>>       rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
>> +
>> +    rt2800_led_open_drain_enable(rt2x00dev);
>> }
>> 
>> static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>> @@ -5074,10 +5099,6 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>>       return 0;
>>   }
>> 
>> -    rt2800_register_read(rt2x00dev, OPT_14_CSR, &reg);
>> -    rt2x00_set_field32(&reg, OPT_14_CSR_BIT0, 1);
>> -    rt2800_register_write(rt2x00dev, OPT_14_CSR, reg);
>> -
>>   if (!rt2x00_rt(rt2x00dev, RT5390) &&
>>       !rt2x00_rt(rt2x00dev, RT5392)) {
>>       rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
>> -- 
>> 1.7.4.4
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
