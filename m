Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:40733 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab3DNURa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Apr 2013 16:17:30 -0400
Received: by mail-ee0-f54.google.com with SMTP id e51so1984482eek.13
        for <linux-wireless@vger.kernel.org>; Sun, 14 Apr 2013 13:17:28 -0700 (PDT)
References: <1365519930-3230-1-git-send-email-stf_xl@wp.pl> <1365519930-3230-7-git-send-email-stf_xl@wp.pl> <66918CCA-AAE0-47BF-B989-58A019810AC7@gmail.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <66918CCA-AAE0-47BF-B989-58A019810AC7@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <AB418DC3-9910-45D9-9F73-CC49FEAA5D00@gmail.com> (sfid-20130414_221732_979439_F81401CD)
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 06/11] rt2800: move RFCSR6_R2 & LDO_CFG0 setup to 3572 specific rfcsr init
Date: Sun, 14 Apr 2013 22:17:27 +0200
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
>> drivers/net/wireless/rt2x00/rt2800lib.c |   34 +++++++++++++++---------------
>> 1 files changed, 17 insertions(+), 17 deletions(-)
>> 
>> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
>> index 83554da..7130040 100644
>> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
>> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
>> @@ -4710,6 +4710,9 @@ static void rt2800_init_rfcsr_3390(struct rt2x00_dev *rt2x00dev)
>> 
>> static void rt2800_init_rfcsr_3572(struct rt2x00_dev *rt2x00dev)
>> {
>> +    u8 rfcsr;
>> +    u32 reg;
>> +
>>   rt2800_rfcsr_write(rt2x00dev, 0, 0x70);
>>   rt2800_rfcsr_write(rt2x00dev, 1, 0x81);
>>   rt2800_rfcsr_write(rt2x00dev, 2, 0xf1);
>> @@ -4741,6 +4744,20 @@ static void rt2800_init_rfcsr_3572(struct rt2x00_dev *rt2x00dev)
>>   rt2800_rfcsr_write(rt2x00dev, 29, 0x9b);
>>   rt2800_rfcsr_write(rt2x00dev, 30, 0x09);
>>   rt2800_rfcsr_write(rt2x00dev, 31, 0x10);
>> +
>> +    rt2800_rfcsr_read(rt2x00dev, 6, &rfcsr);
>> +    rt2x00_set_field8(&rfcsr, RFCSR6_R2, 1);
>> +    rt2800_rfcsr_write(rt2x00dev, 6, rfcsr);
>> +
>> +    rt2800_register_read(rt2x00dev, LDO_CFG0, &reg);
>> +    rt2x00_set_field32(&reg, LDO_CFG0_LDO_CORE_VLEVEL, 3);
>> +    rt2x00_set_field32(&reg, LDO_CFG0_BGSEL, 1);
>> +    rt2800_register_write(rt2x00dev, LDO_CFG0, reg);
>> +    msleep(1);
>> +    rt2800_register_read(rt2x00dev, LDO_CFG0, &reg);
>> +    rt2x00_set_field32(&reg, LDO_CFG0_LDO_CORE_VLEVEL, 0);
>> +    rt2x00_set_field32(&reg, LDO_CFG0_BGSEL, 1);
>> +    rt2800_register_write(rt2x00dev, LDO_CFG0, reg);
>> }
>> 
>> static void rt2800_init_rfcsr_5390(struct rt2x00_dev *rt2x00dev)
>> @@ -4990,23 +5007,6 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>>       return 0;
>>   }
>> 
>> -
>> -    if (rt2x00_rt(rt2x00dev, RT3572)) {
>> -        rt2800_rfcsr_read(rt2x00dev, 6, &rfcsr);
>> -        rt2x00_set_field8(&rfcsr, RFCSR6_R2, 1);
>> -        rt2800_rfcsr_write(rt2x00dev, 6, rfcsr);
>> -
>> -        rt2800_register_read(rt2x00dev, LDO_CFG0, &reg);
>> -        rt2x00_set_field32(&reg, LDO_CFG0_LDO_CORE_VLEVEL, 3);
>> -        rt2x00_set_field32(&reg, LDO_CFG0_BGSEL, 1);
>> -        rt2800_register_write(rt2x00dev, LDO_CFG0, reg);
>> -        msleep(1);
>> -        rt2800_register_read(rt2x00dev, LDO_CFG0, &reg);
>> -        rt2x00_set_field32(&reg, LDO_CFG0_LDO_CORE_VLEVEL, 0);
>> -        rt2x00_set_field32(&reg, LDO_CFG0_BGSEL, 1);
>> -        rt2800_register_write(rt2x00dev, LDO_CFG0, reg);
>> -    }
>> -
>>   /*
>>    * Set RX Filter calibration for 20MHz and 40MHz
>>    */
>> -- 
>> 1.7.4.4
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
