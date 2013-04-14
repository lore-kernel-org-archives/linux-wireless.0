Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:55873 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab3DNUR7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Apr 2013 16:17:59 -0400
Received: by mail-ea0-f171.google.com with SMTP id b15so1875562eae.30
        for <linux-wireless@vger.kernel.org>; Sun, 14 Apr 2013 13:17:57 -0700 (PDT)
References: <1365519930-3230-1-git-send-email-stf_xl@wp.pl> <1365519930-3230-8-git-send-email-stf_xl@wp.pl> <948863C1-A75D-4625-A880-5589875479D0@gmail.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <948863C1-A75D-4625-A880-5589875479D0@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <5E4C3175-16F8-4FA1-9353-548A8CA854A3@gmail.com> (sfid-20130414_221802_304246_0B3FD59C)
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 07/11] rt2800: add rt2800_rx_filter_calibration procedure
Date: Sun, 14 Apr 2013 22:17:56 +0200
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
>> Add procedure for both bands filter calibration and use it on individual
>> chipset init rfcsr subroutines.
>> 
>> Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
>> ---
>> drivers/net/wireless/rt2x00/rt2800lib.c |  106 +++++++++++++++++--------------
>> 1 files changed, 59 insertions(+), 47 deletions(-)
>> 
>> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
>> index 7130040..df8760f 100644
>> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
>> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
>> @@ -4332,8 +4332,8 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
>>   return 0;
>> }
>> 
>> -static u8 rt2800_init_rx_filter(struct rt2x00_dev *rt2x00dev,
>> -                bool bw40, u8 rfcsr24, u8 filter_target)
>> +static u8 rt2800_init_rx_filter(struct rt2x00_dev *rt2x00dev, bool bw40,
>> +                u8 filter_target)
>> {
>>   unsigned int i;
>>   u8 bbp;
>> @@ -4341,6 +4341,7 @@ static u8 rt2800_init_rx_filter(struct rt2x00_dev *rt2x00dev,
>>   u8 passband;
>>   u8 stopband;
>>   u8 overtuned = 0;
>> +    u8 rfcsr24 = (bw40) ? 0x27 : 0x07;
>> 
>>   rt2800_rfcsr_write(rt2x00dev, 24, rfcsr24);
>> 
>> @@ -4396,6 +4397,52 @@ static u8 rt2800_init_rx_filter(struct rt2x00_dev *rt2x00dev,
>>   return rfcsr24;
>> }
>> 
>> +static void rt2800_rx_filter_calibration(struct rt2x00_dev *rt2x00dev)
>> +{
>> +    struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
>> +    u8 filter_tgt_bw20;
>> +    u8 filter_tgt_bw40;
>> +    u8 rfcsr, bbp;
>> +
>> +    /*
>> +     * TODO: sync filter_tgt values with vendor driver
>> +     */
>> +    if (rt2x00_rt(rt2x00dev, RT3070)) {
>> +        filter_tgt_bw20 = 0x16;
>> +        filter_tgt_bw40 = 0x19;
>> +    } else {
>> +        filter_tgt_bw20 = 0x13;
>> +        filter_tgt_bw40 = 0x15;
>> +    }
>> +
>> +    drv_data->calibration_bw20 =
>> +        rt2800_init_rx_filter(rt2x00dev, false, filter_tgt_bw20);
>> +    drv_data->calibration_bw40 =
>> +        rt2800_init_rx_filter(rt2x00dev, true, filter_tgt_bw40);
>> +
>> +    /*
>> +     * Save BBP 25 & 26 values for later use in channel switching (for 3052)
>> +     */
>> +    rt2800_bbp_read(rt2x00dev, 25, &drv_data->bbp25);
>> +    rt2800_bbp_read(rt2x00dev, 26, &drv_data->bbp26);
>> +
>> +    /*
>> +     * Set back to initial state
>> +     */
>> +    rt2800_bbp_write(rt2x00dev, 24, 0);
>> +
>> +    rt2800_rfcsr_read(rt2x00dev, 22, &rfcsr);
>> +    rt2x00_set_field8(&rfcsr, RFCSR22_BASEBAND_LOOPBACK, 0);
>> +    rt2800_rfcsr_write(rt2x00dev, 22, rfcsr);
>> +
>> +    /*
>> +     * Set BBP back to BW20
>> +     */
>> +    rt2800_bbp_read(rt2x00dev, 4, &bbp);
>> +    rt2x00_set_field8(&bbp, BBP4_BANDWIDTH, 0);
>> +    rt2800_bbp_write(rt2x00dev, 4, bbp);
>> +}
>> +
>> static void rt2800_normal_mode_setup_5xxx(struct rt2x00_dev *rt2x00dev)
>> {
>>   u8 reg;
>> @@ -4539,6 +4586,8 @@ static void rt2800_init_rfcsr_30xx(struct rt2x00_dev *rt2x00dev)
>>       rt2x00_set_field32(&reg, GPIO_SWITCH_5, 0);
>>       rt2800_register_write(rt2x00dev, GPIO_SWITCH, reg);
>>   }
>> +
>> +    rt2800_rx_filter_calibration(rt2x00dev);
>> }
>> 
>> static void rt2800_init_rfcsr_3290(struct rt2x00_dev *rt2x00dev)
>> @@ -4597,6 +4646,8 @@ static void rt2800_init_rfcsr_3290(struct rt2x00_dev *rt2x00dev)
>>   rt2800_rfcsr_read(rt2x00dev, 29, &rfcsr);
>>   rt2x00_set_field8(&rfcsr, RFCSR29_RSSI_GAIN, 3);
>>   rt2800_rfcsr_write(rt2x00dev, 29, rfcsr);
>> +
>> +    rt2800_rx_filter_calibration(rt2x00dev);
>> }
> 
> This looks a bit fishy to me, as the original code doesn't completely apply to RT3290, but now it does.
> 
>> 
>> static void rt2800_init_rfcsr_3352(struct rt2x00_dev *rt2x00dev)
>> @@ -4664,6 +4715,8 @@ static void rt2800_init_rfcsr_3352(struct rt2x00_dev *rt2x00dev)
>>   rt2800_rfcsr_write(rt2x00dev, 61, 0x00);
>>   rt2800_rfcsr_write(rt2x00dev, 62, 0x00);
>>   rt2800_rfcsr_write(rt2x00dev, 63, 0x00);
>> +
>> +    rt2800_rx_filter_calibration(rt2x00dev);
>> }
>> 
>> static void rt2800_init_rfcsr_3390(struct rt2x00_dev *rt2x00dev)
>> @@ -4706,6 +4759,8 @@ static void rt2800_init_rfcsr_3390(struct rt2x00_dev *rt2x00dev)
>>   rt2800_register_read(rt2x00dev, GPIO_SWITCH, &reg);
>>   rt2x00_set_field32(&reg, GPIO_SWITCH_5, 0);
>>   rt2800_register_write(rt2x00dev, GPIO_SWITCH, reg);
>> +
>> +    rt2800_rx_filter_calibration(rt2x00dev);
>> }
>> 
>> static void rt2800_init_rfcsr_3572(struct rt2x00_dev *rt2x00dev)
>> @@ -4758,6 +4813,8 @@ static void rt2800_init_rfcsr_3572(struct rt2x00_dev *rt2x00dev)
>>   rt2x00_set_field32(&reg, LDO_CFG0_LDO_CORE_VLEVEL, 0);
>>   rt2x00_set_field32(&reg, LDO_CFG0_BGSEL, 1);
>>   rt2800_register_write(rt2x00dev, LDO_CFG0, reg);
>> +
>> +    rt2800_rx_filter_calibration(rt2x00dev);
>> }
>> 
>> static void rt2800_init_rfcsr_5390(struct rt2x00_dev *rt2x00dev)
>> @@ -4956,7 +5013,6 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>> {
>>   struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
>>   u8 rfcsr;
>> -    u8 bbp;
>>   u32 reg;
>> 
>>   if (!rt2x00_rt(rt2x00dev, RT3070) &&
>> @@ -5007,50 +5063,6 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>>       return 0;
>>   }
>> 
>> -    /*
>> -     * Set RX Filter calibration for 20MHz and 40MHz
>> -     */
>> -    if (rt2x00_rt(rt2x00dev, RT3070)) {
>> -        drv_data->calibration_bw20 =
>> -            rt2800_init_rx_filter(rt2x00dev, false, 0x07, 0x16);
>> -        drv_data->calibration_bw40 =
>> -            rt2800_init_rx_filter(rt2x00dev, true, 0x27, 0x19);
>> -    } else if (rt2x00_rt(rt2x00dev, RT3071) ||
>> -           rt2x00_rt(rt2x00dev, RT3090) ||
>> -           rt2x00_rt(rt2x00dev, RT3352) ||
>> -           rt2x00_rt(rt2x00dev, RT3390) ||
>> -           rt2x00_rt(rt2x00dev, RT3572)) {
>> -        drv_data->calibration_bw20 =
>> -            rt2800_init_rx_filter(rt2x00dev, false, 0x07, 0x13);
>> -        drv_data->calibration_bw40 =
>> -            rt2800_init_rx_filter(rt2x00dev, true, 0x27, 0x15);
>> -    }
>> -
>> -    /*
>> -     * Save BBP 25 & 26 values for later use in channel switching
>> -     */
>> -    rt2800_bbp_read(rt2x00dev, 25, &drv_data->bbp25);
>> -    rt2800_bbp_read(rt2x00dev, 26, &drv_data->bbp26);
>> -
>> -    if (!rt2x00_rt(rt2x00dev, RT5390) &&
>> -        !rt2x00_rt(rt2x00dev, RT5392)) {
>> -        /*
>> -         * Set back to initial state
>> -         */
>> -        rt2800_bbp_write(rt2x00dev, 24, 0);
>> -
>> -        rt2800_rfcsr_read(rt2x00dev, 22, &rfcsr);
>> -        rt2x00_set_field8(&rfcsr, RFCSR22_BASEBAND_LOOPBACK, 0);
>> -        rt2800_rfcsr_write(rt2x00dev, 22, rfcsr);
>> -
>> -        /*
>> -         * Set BBP back to BW20
>> -         */
>> -        rt2800_bbp_read(rt2x00dev, 4, &bbp);
>> -        rt2x00_set_field8(&bbp, BBP4_BANDWIDTH, 0);
>> -        rt2800_bbp_write(rt2x00dev, 4, bbp);
>> -    }
>> -
>>   if (rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070F) ||
>>       rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E) ||
>>       rt2x00_rt_rev_lt(rt2x00dev, RT3090, REV_RT3090E) ||
>> -- 
>> 1.7.4.4
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
