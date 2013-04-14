Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:46585 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab3DNUTj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Apr 2013 16:19:39 -0400
Received: by mail-ea0-f169.google.com with SMTP id n15so1963766ead.0
        for <linux-wireless@vger.kernel.org>; Sun, 14 Apr 2013 13:19:37 -0700 (PDT)
References: <1365519930-3230-1-git-send-email-stf_xl@wp.pl> <1365519930-3230-11-git-send-email-stf_xl@wp.pl> <D7DE287D-EED7-4657-B388-ADCCDB823A8B@gmail.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <D7DE287D-EED7-4657-B388-ADCCDB823A8B@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <18A43EE8-A3C0-4DE2-9F25-A035C48DB73F@gmail.com> (sfid-20130414_221942_482279_5B409D30)
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 10/11] rt2800: add rt2800_normal_mode_setup_3xxx subroutine
Date: Sun, 14 Apr 2013 22:19:36 +0200
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
>> Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
>> ---
>> drivers/net/wireless/rt2x00/rt2800lib.c |  114 ++++++++++++++++---------------
>> 1 files changed, 58 insertions(+), 56 deletions(-)
>> 
>> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
>> index 009fe47..f31b9b9 100644
>> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
>> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
>> @@ -4452,6 +4452,59 @@ static void rt2800_rx_filter_calibration(struct rt2x00_dev *rt2x00dev)
>>   rt2800_bbp_write(rt2x00dev, 4, bbp);
>> }
>> 
>> +static void rt2800_normal_mode_setup_3xxx(struct rt2x00_dev *rt2x00dev)
>> +{
>> +    struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
>> +    u8 rfcsr;
>> +
>> +    rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
>> +    rt2x00_set_field8(&rfcsr, RFCSR17_TX_LO1_EN, 0);
>> +    if (rt2x00_rt(rt2x00dev, RT3070) ||
>> +        rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E) ||
>> +        rt2x00_rt_rev_lt(rt2x00dev, RT3090, REV_RT3090E) ||
>> +        rt2x00_rt_rev_lt(rt2x00dev, RT3390, REV_RT3390E)) {
>> +        if (!test_bit(CAPABILITY_EXTERNAL_LNA_BG, &rt2x00dev->cap_flags))
>> +            rt2x00_set_field8(&rfcsr, RFCSR17_R, 1);
>> +    }
>> +    rt2x00_set_field8(&rfcsr, RFCSR17_TXMIXER_GAIN,
>> +              drv_data->txmixer_gain_24g);
>> +    rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
>> +
>> +    if (rt2x00_rt(rt2x00dev, RT3071) ||
>> +        rt2x00_rt(rt2x00dev, RT3090) ||
>> +        rt2x00_rt(rt2x00dev, RT3390)) {
>> +        rt2800_rfcsr_read(rt2x00dev, 1, &rfcsr);
>> +        rt2x00_set_field8(&rfcsr, RFCSR1_RF_BLOCK_EN, 1);
>> +        rt2x00_set_field8(&rfcsr, RFCSR1_RX0_PD, 0);
>> +        rt2x00_set_field8(&rfcsr, RFCSR1_TX0_PD, 0);
>> +        rt2x00_set_field8(&rfcsr, RFCSR1_RX1_PD, 1);
>> +        rt2x00_set_field8(&rfcsr, RFCSR1_TX1_PD, 1);
>> +        rt2800_rfcsr_write(rt2x00dev, 1, rfcsr);
>> +
>> +        rt2800_rfcsr_read(rt2x00dev, 15, &rfcsr);
>> +        rt2x00_set_field8(&rfcsr, RFCSR15_TX_LO2_EN, 0);
>> +        rt2800_rfcsr_write(rt2x00dev, 15, rfcsr);
>> +
>> +        rt2800_rfcsr_read(rt2x00dev, 20, &rfcsr);
>> +        rt2x00_set_field8(&rfcsr, RFCSR20_RX_LO1_EN, 0);
>> +        rt2800_rfcsr_write(rt2x00dev, 20, rfcsr);
>> +
>> +        rt2800_rfcsr_read(rt2x00dev, 21, &rfcsr);
>> +        rt2x00_set_field8(&rfcsr, RFCSR21_RX_LO2_EN, 0);
>> +        rt2800_rfcsr_write(rt2x00dev, 21, rfcsr);
>> +    } else if (rt2x00_rt(rt2x00dev, RT3070)) {
>> +        rt2800_rfcsr_read(rt2x00dev, 27, &rfcsr);
>> +        if (rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070F))
>> +            rt2x00_set_field8(&rfcsr, RFCSR27_R1, 3);
>> +        else
>> +            rt2x00_set_field8(&rfcsr, RFCSR27_R1, 0);
>> +        rt2x00_set_field8(&rfcsr, RFCSR27_R2, 0);
>> +        rt2x00_set_field8(&rfcsr, RFCSR27_R3, 0);
>> +        rt2x00_set_field8(&rfcsr, RFCSR27_R4, 0);
>> +        rt2800_rfcsr_write(rt2x00dev, 27, rfcsr);
>> +    }
> 
> Personally, I would switch the if- and else branches, to have the RT chipset numbers in numerical order.
> 
>> +}
>> +
>> static void rt2800_normal_mode_setup_5xxx(struct rt2x00_dev *rt2x00dev)
>> {
>>   u8 reg;
>> @@ -4604,6 +4657,7 @@ static void rt2800_init_rfcsr_30xx(struct rt2x00_dev *rt2x00dev)
>>       rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
>> 
>>   rt2800_led_open_drain_enable(rt2x00dev);
>> +    rt2800_normal_mode_setup_3xxx(rt2x00dev);
>> }
>> 
>> static void rt2800_init_rfcsr_3290(struct rt2x00_dev *rt2x00dev)
>> @@ -4664,8 +4718,8 @@ static void rt2800_init_rfcsr_3290(struct rt2x00_dev *rt2x00dev)
>>   rt2800_rfcsr_write(rt2x00dev, 29, rfcsr);
>> 
>>   rt2800_rx_filter_calibration(rt2x00dev);
>> -
>>   rt2800_led_open_drain_enable(rt2x00dev);
>> +    rt2800_normal_mode_setup_3xxx(rt2x00dev);
>> }
>> 
>> static void rt2800_init_rfcsr_3352(struct rt2x00_dev *rt2x00dev)
>> @@ -4735,8 +4789,8 @@ static void rt2800_init_rfcsr_3352(struct rt2x00_dev *rt2x00dev)
>>   rt2800_rfcsr_write(rt2x00dev, 63, 0x00);
>> 
>>   rt2800_rx_filter_calibration(rt2x00dev);
>> -
>>   rt2800_led_open_drain_enable(rt2x00dev);
>> +    rt2800_normal_mode_setup_3xxx(rt2x00dev);
>> }
>> 
>> static void rt2800_init_rfcsr_3390(struct rt2x00_dev *rt2x00dev)
>> @@ -4786,6 +4840,7 @@ static void rt2800_init_rfcsr_3390(struct rt2x00_dev *rt2x00dev)
>>       rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
>> 
>>   rt2800_led_open_drain_enable(rt2x00dev);
>> +    rt2800_normal_mode_setup_3xxx(rt2x00dev);
>> }
>> 
>> static void rt2800_init_rfcsr_3572(struct rt2x00_dev *rt2x00dev)
>> @@ -4840,8 +4895,8 @@ static void rt2800_init_rfcsr_3572(struct rt2x00_dev *rt2x00dev)
>>   rt2800_register_write(rt2x00dev, LDO_CFG0, reg);
>> 
>>   rt2800_rx_filter_calibration(rt2x00dev);
>> -
>>   rt2800_led_open_drain_enable(rt2x00dev);
>> +    rt2800_normal_mode_setup_3xxx(rt2x00dev);
>> }
>> 
>> static void rt2800_init_rfcsr_5390(struct rt2x00_dev *rt2x00dev)
>> @@ -5099,59 +5154,6 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>>       return 0;
>>   }
>> 
>> -    if (!rt2x00_rt(rt2x00dev, RT5390) &&
>> -        !rt2x00_rt(rt2x00dev, RT5392)) {
>> -        rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
>> -        rt2x00_set_field8(&rfcsr, RFCSR17_TX_LO1_EN, 0);
>> -        if (rt2x00_rt(rt2x00dev, RT3070) ||
>> -            rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E) ||
>> -            rt2x00_rt_rev_lt(rt2x00dev, RT3090, REV_RT3090E) ||
>> -            rt2x00_rt_rev_lt(rt2x00dev, RT3390, REV_RT3390E)) {
>> -            if (!test_bit(CAPABILITY_EXTERNAL_LNA_BG,
>> -                      &rt2x00dev->cap_flags))
>> -                rt2x00_set_field8(&rfcsr, RFCSR17_R, 1);
>> -        }
>> -        rt2x00_set_field8(&rfcsr, RFCSR17_TXMIXER_GAIN,
>> -                  drv_data->txmixer_gain_24g);
>> -        rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
>> -    }
>> -
>> -    if (rt2x00_rt(rt2x00dev, RT3071) ||
>> -        rt2x00_rt(rt2x00dev, RT3090) ||
>> -        rt2x00_rt(rt2x00dev, RT3390)) {
>> -        rt2800_rfcsr_read(rt2x00dev, 1, &rfcsr);
>> -        rt2x00_set_field8(&rfcsr, RFCSR1_RF_BLOCK_EN, 1);
>> -        rt2x00_set_field8(&rfcsr, RFCSR1_RX0_PD, 0);
>> -        rt2x00_set_field8(&rfcsr, RFCSR1_TX0_PD, 0);
>> -        rt2x00_set_field8(&rfcsr, RFCSR1_RX1_PD, 1);
>> -        rt2x00_set_field8(&rfcsr, RFCSR1_TX1_PD, 1);
>> -        rt2800_rfcsr_write(rt2x00dev, 1, rfcsr);
>> -
>> -        rt2800_rfcsr_read(rt2x00dev, 15, &rfcsr);
>> -        rt2x00_set_field8(&rfcsr, RFCSR15_TX_LO2_EN, 0);
>> -        rt2800_rfcsr_write(rt2x00dev, 15, rfcsr);
>> -
>> -        rt2800_rfcsr_read(rt2x00dev, 20, &rfcsr);
>> -        rt2x00_set_field8(&rfcsr, RFCSR20_RX_LO1_EN, 0);
>> -        rt2800_rfcsr_write(rt2x00dev, 20, rfcsr);
>> -
>> -        rt2800_rfcsr_read(rt2x00dev, 21, &rfcsr);
>> -        rt2x00_set_field8(&rfcsr, RFCSR21_RX_LO2_EN, 0);
>> -        rt2800_rfcsr_write(rt2x00dev, 21, rfcsr);
>> -    }
>> -
>> -    if (rt2x00_rt(rt2x00dev, RT3070)) {
>> -        rt2800_rfcsr_read(rt2x00dev, 27, &rfcsr);
>> -        if (rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070F))
>> -            rt2x00_set_field8(&rfcsr, RFCSR27_R1, 3);
>> -        else
>> -            rt2x00_set_field8(&rfcsr, RFCSR27_R1, 0);
>> -        rt2x00_set_field8(&rfcsr, RFCSR27_R2, 0);
>> -        rt2x00_set_field8(&rfcsr, RFCSR27_R3, 0);
>> -        rt2x00_set_field8(&rfcsr, RFCSR27_R4, 0);
>> -        rt2800_rfcsr_write(rt2x00dev, 27, rfcsr);
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
