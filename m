Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:50698 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727Ab3DNUUx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Apr 2013 16:20:53 -0400
Received: by mail-ea0-f172.google.com with SMTP id z7so1954059eaf.3
        for <linux-wireless@vger.kernel.org>; Sun, 14 Apr 2013 13:20:51 -0700 (PDT)
References: <1365519930-3230-1-git-send-email-stf_xl@wp.pl> <1365519930-3230-2-git-send-email-stf_xl@wp.pl> <3B6ED6A8-A24C-4F0C-941C-7A24F55172DA@gmail.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <3B6ED6A8-A24C-4F0C-941C-7A24F55172DA@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <2594259C-77F0-4CE0-A967-9ABDBA7852A2@gmail.com> (sfid-20130414_222057_299963_ED2AB05B)
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 01/11] rt2800: merge 5xxx normal mode setup
Date: Sun, 14 Apr 2013 22:20:50 +0200
To: "stf_xl@wp.pl" <stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Resending as the message didn't seem to end up on the mailing list)


> Hi Stanislaw,
> 
> Sent from my iPad
> 
> On 9 apr. 2013, at 17:05, stf_xl@wp.pl wrote:
> 
>> From: Stanislaw Gruszka <stf_xl@wp.pl>
>> 
>> Merge code which program the same registes at the end of rfcsr
>> initialization for 5592, 5392 and 5390 chips.
>> 
>> Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
>> ---
>> drivers/net/wireless/rt2x00/rt2800lib.c |   91 ++++++++++++-------------------
>> 1 files changed, 34 insertions(+), 57 deletions(-)
>> 
>> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
>> index 7deac4d..d092b47 100644
>> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
>> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
>> @@ -4396,6 +4396,35 @@ static u8 rt2800_init_rx_filter(struct rt2x00_dev *rt2x00dev,
>>   return rfcsr24;
>> }
>> 
>> +static void rt2800_normal_mode_setup_5xxx(struct rt2x00_dev *rt2x00dev)
>> +{
>> +    u8 reg;
>> +    u16 eeprom;
>> +
>> +    rt2800_bbp_read(rt2x00dev, 138, &reg);
>> +    /*  Turn off unused DAC1 and ADC1 to reduce power consumption */
>> +    rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF0, &eeprom);
>> +    if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_RXPATH) == 1)
>> +        rt2x00_set_field8(&reg, BBP138_RX_ADC1, 0);
>> +    if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_TXPATH) == 1)
>> +        rt2x00_set_field8(&reg, BBP138_TX_DAC1, 1);
>> +    rt2800_bbp_write(rt2x00dev, 138, reg);
> 
> I would put the comment above the bbp_read call, as it applies to the whole block and makes the code better readable, IMHO.
> 
>> +
>> +    rt2800_rfcsr_read(rt2x00dev, 38, &reg);
>> +    rt2x00_set_field8(&reg, RFCSR38_RX_LO1_EN, 0);
>> +    rt2800_rfcsr_write(rt2x00dev, 38, reg);
>> +
>> +    rt2800_rfcsr_read(rt2x00dev, 39, &reg);
>> +    rt2x00_set_field8(&reg, RFCSR39_RX_LO2_EN, 0);
>> +    rt2800_rfcsr_write(rt2x00dev, 39, reg);
>> +
>> +    rt2800_bbp4_mac_if_ctrl(rt2x00dev);
>> +
>> +    rt2800_rfcsr_read(rt2x00dev, 30, &reg);
>> +    rt2x00_set_field8(&reg, RFCSR30_RX_VCM, 2);
>> +    rt2800_rfcsr_write(rt2x00dev, 30, reg);
>> +}
>> +
>> static void rt2800_init_rfcsr_305x_soc(struct rt2x00_dev *rt2x00dev)
>> {
>>   rt2800_rfcsr_write(rt2x00dev, 0, 0x50);
>> @@ -4725,6 +4754,8 @@ static void rt2800_init_rfcsr_5390(struct rt2x00_dev *rt2x00dev)
>>       rt2800_rfcsr_write(rt2x00dev, 61, 0xdd);
>>   rt2800_rfcsr_write(rt2x00dev, 62, 0x00);
>>   rt2800_rfcsr_write(rt2x00dev, 63, 0x00);
>> +
>> +    rt2800_normal_mode_setup_5xxx(rt2x00dev);
>> }
>> 
>> static void rt2800_init_rfcsr_5392(struct rt2x00_dev *rt2x00dev)
>> @@ -4788,13 +4819,12 @@ static void rt2800_init_rfcsr_5392(struct rt2x00_dev *rt2x00dev)
>>   rt2800_rfcsr_write(rt2x00dev, 61, 0x91);
>>   rt2800_rfcsr_write(rt2x00dev, 62, 0x39);
>>   rt2800_rfcsr_write(rt2x00dev, 63, 0x07);
>> +
>> +    rt2800_normal_mode_setup_5xxx(rt2x00dev);
>> }
>> 
>> static void rt2800_init_rfcsr_5592(struct rt2x00_dev *rt2x00dev)
>> {
>> -    u8 reg;
>> -    u16 eeprom;
>> -
>>   rt2800_rfcsr_write(rt2x00dev, 1, 0x3F);
>>   rt2800_rfcsr_write(rt2x00dev, 3, 0x08);
>>   rt2800_rfcsr_write(rt2x00dev, 3, 0x08);
>> @@ -4823,34 +4853,11 @@ static void rt2800_init_rfcsr_5592(struct rt2x00_dev *rt2x00dev)
>> 
>>   rt2800_adjust_freq_offset(rt2x00dev);
>> 
>> -    rt2800_bbp_read(rt2x00dev, 138, &reg);
>> -
>> -    /*  Turn off unused DAC1 and ADC1 to reduce power consumption */
>> -    rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF0, &eeprom);
>> -    if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_RXPATH) == 1)
>> -        rt2x00_set_field8(&reg, BBP138_RX_ADC1, 0);
>> -    if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_TXPATH) == 1)
>> -        rt2x00_set_field8(&reg, BBP138_TX_DAC1, 1);
>> -
>> -    rt2800_bbp_write(rt2x00dev, 138, reg);
>> -
>>   /* Enable DC filter */
>>   if (rt2x00_rt_rev_gte(rt2x00dev, RT5592, REV_RT5592C))
>>       rt2800_bbp_write(rt2x00dev, 103, 0xc0);
>> 
>> -    rt2800_rfcsr_read(rt2x00dev, 38, &reg);
>> -    rt2x00_set_field8(&reg, RFCSR38_RX_LO1_EN, 0);
>> -    rt2800_rfcsr_write(rt2x00dev, 38, reg);
>> -
>> -    rt2800_rfcsr_read(rt2x00dev, 39, &reg);
>> -    rt2x00_set_field8(&reg, RFCSR39_RX_LO2_EN, 0);
>> -    rt2800_rfcsr_write(rt2x00dev, 39, reg);
>> -
>> -    rt2800_bbp4_mac_if_ctrl(rt2x00dev);
>> -
>> -    rt2800_rfcsr_read(rt2x00dev, 30, &reg);
>> -    rt2x00_set_field8(&reg, RFCSR30_RX_VCM, 2);
>> -    rt2800_rfcsr_write(rt2x00dev, 30, reg);
>> +    rt2800_normal_mode_setup_5xxx(rt2x00dev);
>> }
>> 
>> static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>> @@ -5051,20 +5058,6 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>>       rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
>>   }
>> 
>> -    if (rt2x00_rt(rt2x00dev, RT3090) ||
>> -        rt2x00_rt(rt2x00dev, RT5592)) {
>> -        rt2800_bbp_read(rt2x00dev, 138, &bbp);
> 
> I don't see the addition of this code to the function for RT3090, but this code is removed here. I guess it still needs to be added to rt2800_init_rfcsr_30xx.
> 
>> -
>> -        /*  Turn off unused DAC1 and ADC1 to reduce power consumption */
>> -        rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF0, &eeprom);
>> -        if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_RXPATH) == 1)
>> -            rt2x00_set_field8(&bbp, BBP138_RX_ADC1, 0);
>> -        if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_TXPATH) == 1)
>> -            rt2x00_set_field8(&bbp, BBP138_TX_DAC1, 1);
>> -
>> -        rt2800_bbp_write(rt2x00dev, 138, bbp);
>> -    }
>> -
>>   if (rt2x00_rt(rt2x00dev, RT3071) ||
>>       rt2x00_rt(rt2x00dev, RT3090) ||
>>       rt2x00_rt(rt2x00dev, RT3390)) {
>> @@ -5107,22 +5100,6 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>>       rt2800_rfcsr_write(rt2x00dev, 29, rfcsr);
>>   }
>> 
>> -    if (rt2x00_rt(rt2x00dev, RT5390) ||
>> -        rt2x00_rt(rt2x00dev, RT5392) ||
>> -        rt2x00_rt(rt2x00dev, RT5592)) {
>> -        rt2800_rfcsr_read(rt2x00dev, 38, &rfcsr);
>> -        rt2x00_set_field8(&rfcsr, RFCSR38_RX_LO1_EN, 0);
>> -        rt2800_rfcsr_write(rt2x00dev, 38, rfcsr);
>> -
>> -        rt2800_rfcsr_read(rt2x00dev, 39, &rfcsr);
>> -        rt2x00_set_field8(&rfcsr, RFCSR39_RX_LO2_EN, 0);
>> -        rt2800_rfcsr_write(rt2x00dev, 39, rfcsr);
>> -
>> -        rt2800_rfcsr_read(rt2x00dev, 30, &rfcsr);
>> -        rt2x00_set_field8(&rfcsr, RFCSR30_RX_VCM, 2);
>> -        rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
>> -    }
>> -
>>   return 0;
>> }
>> 
>> -- 
>> 1.7.4.4
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
