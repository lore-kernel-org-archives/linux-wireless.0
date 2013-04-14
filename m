Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:48920 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab3DNUQA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Apr 2013 16:16:00 -0400
Received: by mail-ea0-f182.google.com with SMTP id q15so1948876ead.41
        for <linux-wireless@vger.kernel.org>; Sun, 14 Apr 2013 13:15:58 -0700 (PDT)
References: <1365519930-3230-1-git-send-email-stf_xl@wp.pl> <1365519930-3230-5-git-send-email-stf_xl@wp.pl> <A636A59B-CC0A-41E2-98A8-0165993938FA@gmail.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <A636A59B-CC0A-41E2-98A8-0165993938FA@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <012BC257-AE34-4BFB-BACE-2D3AAC6ED55A@gmail.com> (sfid-20130414_221604_397690_FFF3A52A)
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 04/11] rt2800: move 30xx common rf init code
Date: Sun, 14 Apr 2013 22:15:57 +0200
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
>> drivers/net/wireless/rt2x00/rt2800lib.c |   62 ++++++++++++++++--------------
>> 1 files changed, 33 insertions(+), 29 deletions(-)
>> 
>> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
>> index 085b60c..216ceb6 100644
>> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
>> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
>> @@ -4476,6 +4476,8 @@ static void rt2800_init_rfcsr_305x_soc(struct rt2x00_dev *rt2x00dev)
>> static void rt2800_init_rfcsr_30xx(struct rt2x00_dev *rt2x00dev)
>> {
>>   u8 rfcsr;
>> +    u16 eeprom;
>> +    u32 reg;
>> 
>>   /*
>>    * Init RF calibration.
>> @@ -4507,6 +4509,36 @@ static void rt2800_init_rfcsr_30xx(struct rt2x00_dev *rt2x00dev)
>>   rt2800_rfcsr_write(rt2x00dev, 24, 0x16);
>>   rt2800_rfcsr_write(rt2x00dev, 25, 0x01);
>>   rt2800_rfcsr_write(rt2x00dev, 29, 0x1f);
>> +
>> +    if (rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070F)) {
>> +        rt2800_register_read(rt2x00dev, LDO_CFG0, &reg);
>> +        rt2x00_set_field32(&reg, LDO_CFG0_BGSEL, 1);
>> +        rt2x00_set_field32(&reg, LDO_CFG0_LDO_CORE_VLEVEL, 3);
>> +        rt2800_register_write(rt2x00dev, LDO_CFG0, reg);
>> +    } else if (rt2x00_rt(rt2x00dev, RT3071) ||
>> +           rt2x00_rt(rt2x00dev, RT3090)) {
>> +        rt2800_rfcsr_write(rt2x00dev, 31, 0x14);
>> +
>> +        rt2800_rfcsr_read(rt2x00dev, 6, &rfcsr);
>> +        rt2x00_set_field8(&rfcsr, RFCSR6_R2, 1);
>> +        rt2800_rfcsr_write(rt2x00dev, 6, rfcsr);
>> +
>> +        rt2800_register_read(rt2x00dev, LDO_CFG0, &reg);
>> +        rt2x00_set_field32(&reg, LDO_CFG0_BGSEL, 1);
>> +        if (rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E) ||
>> +            rt2x00_rt_rev_lt(rt2x00dev, RT3090, REV_RT3090E)) {
>> +            rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &eeprom);
>> +            if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF1_DAC_TEST))
>> +                rt2x00_set_field32(&reg, LDO_CFG0_LDO_CORE_VLEVEL, 3);
>> +            else
>> +                rt2x00_set_field32(&reg, LDO_CFG0_LDO_CORE_VLEVEL, 0);
>> +        }
>> +        rt2800_register_write(rt2x00dev, LDO_CFG0, reg);
>> +
>> +        rt2800_register_read(rt2x00dev, GPIO_SWITCH, &reg);
>> +        rt2x00_set_field32(&reg, GPIO_SWITCH_5, 0);
>> +        rt2800_register_write(rt2x00dev, GPIO_SWITCH, reg);
>> +    }
>> }
>> 
>> static void rt2800_init_rfcsr_3290(struct rt2x00_dev *rt2x00dev)
>> @@ -4903,7 +4935,6 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>>   u8 rfcsr;
>>   u8 bbp;
>>   u32 reg;
>> -    u16 eeprom;
>> 
>>   if (!rt2x00_rt(rt2x00dev, RT3070) &&
>>       !rt2x00_rt(rt2x00dev, RT3071) &&
>> @@ -4953,35 +4984,8 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>>       return 0;
>>   }
>> 
>> -    if (rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070F)) {
>> -        rt2800_register_read(rt2x00dev, LDO_CFG0, &reg);
>> -        rt2x00_set_field32(&reg, LDO_CFG0_BGSEL, 1);
>> -        rt2x00_set_field32(&reg, LDO_CFG0_LDO_CORE_VLEVEL, 3);
>> -        rt2800_register_write(rt2x00dev, LDO_CFG0, reg);
>> -    } else if (rt2x00_rt(rt2x00dev, RT3071) ||
>> -           rt2x00_rt(rt2x00dev, RT3090)) {
>> -        rt2800_rfcsr_write(rt2x00dev, 31, 0x14);
>> -
>> -        rt2800_rfcsr_read(rt2x00dev, 6, &rfcsr);
>> -        rt2x00_set_field8(&rfcsr, RFCSR6_R2, 1);
>> -        rt2800_rfcsr_write(rt2x00dev, 6, rfcsr);
>> -
>> -        rt2800_register_read(rt2x00dev, LDO_CFG0, &reg);
>> -        rt2x00_set_field32(&reg, LDO_CFG0_BGSEL, 1);
>> -        if (rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E) ||
>> -            rt2x00_rt_rev_lt(rt2x00dev, RT3090, REV_RT3090E)) {
>> -            rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &eeprom);
>> -            if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF1_DAC_TEST))
>> -                rt2x00_set_field32(&reg, LDO_CFG0_LDO_CORE_VLEVEL, 3);
>> -            else
>> -                rt2x00_set_field32(&reg, LDO_CFG0_LDO_CORE_VLEVEL, 0);
>> -        }
>> -        rt2800_register_write(rt2x00dev, LDO_CFG0, reg);
>> 
>> -        rt2800_register_read(rt2x00dev, GPIO_SWITCH, &reg);
>> -        rt2x00_set_field32(&reg, GPIO_SWITCH_5, 0);
>> -        rt2800_register_write(rt2x00dev, GPIO_SWITCH, reg);
>> -    } else if (rt2x00_rt(rt2x00dev, RT3390)) {
>> +    if (rt2x00_rt(rt2x00dev, RT3390)) {
>>       rt2800_register_read(rt2x00dev, GPIO_SWITCH, &reg);
>>       rt2x00_set_field32(&reg, GPIO_SWITCH_5, 0);
>>       rt2800_register_write(rt2x00dev, GPIO_SWITCH, reg);
>> -- 
>> 1.7.4.4
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
