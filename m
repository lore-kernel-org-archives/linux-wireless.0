Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:35092 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab3DNUOs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Apr 2013 16:14:48 -0400
Received: by mail-ee0-f47.google.com with SMTP id t10so1899416eei.6
        for <linux-wireless@vger.kernel.org>; Sun, 14 Apr 2013 13:14:46 -0700 (PDT)
References: <1365519930-3230-1-git-send-email-stf_xl@wp.pl> <1365519930-3230-3-git-send-email-stf_xl@wp.pl> <F57510E7-8DE6-4BA4-8256-2144DDE5B30D@gmail.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <F57510E7-8DE6-4BA4-8256-2144DDE5B30D@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <8307F68D-2C8B-4B82-89B0-C7AC06CCF627@gmail.com> (sfid-20130414_221453_478372_936682DD)
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 02/11] rt2800: move rf init calibration code
Date: Sun, 14 Apr 2013 22:14:44 +0200
To: "stf_xl@wp.pl" <stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Resending as the message didn't seem to end up on the mailing list)

> Hi Stanislaw,
> 
> Some more comments on top of those of Gabor.
> 
> Sent from my iPad
> 
> On 9 apr. 2013, at 17:05, stf_xl@wp.pl wrote:
> 
>> From: Stanislaw Gruszka <stf_xl@wp.pl>
>> 
>> Add separate functions for rf init calibration code and use it in
>> proper init rf routines.
>> 
>> Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
>> ---
>> drivers/net/wireless/rt2x00/rt2800lib.c |   53 ++++++++++++++++++-------------
>> 1 files changed, 31 insertions(+), 22 deletions(-)
>> 
>> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
>> index d092b47..334973a 100644
>> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
>> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
>> @@ -4425,6 +4425,18 @@ static void rt2800_normal_mode_setup_5xxx(struct rt2x00_dev *rt2x00dev)
>>   rt2800_rfcsr_write(rt2x00dev, 30, reg);
>> }
>> 
>> +static void rt2800_rf_init_calibration_53xx(struct rt2x00_dev *rt2x00dev)
> 
> The name of the function is't great, as you call it from the RT3290 setup code as well. How about generalizing it to a rt2800_init_calibration, which also takes an RF CSR number and a value bitmask as parameters, which then can also be used for the other chipsets?
> 
>> +{
>> +    u8 rfcsr;
>> +
>> +    rt2800_rfcsr_read(rt2x00dev, 2, &rfcsr);
>> +    rt2x00_set_field8(&rfcsr, RFCSR2_RESCAL_EN, 1);
>> +    rt2800_rfcsr_write(rt2x00dev, 2, rfcsr);
>> +    msleep(1);
>> +    rt2x00_set_field8(&rfcsr, RFCSR2_RESCAL_EN, 0);
>> +    rt2800_rfcsr_write(rt2x00dev, 2, rfcsr);
>> +}
>> +
>> static void rt2800_init_rfcsr_305x_soc(struct rt2x00_dev *rt2x00dev)
>> {
>>   rt2800_rfcsr_write(rt2x00dev, 0, 0x50);
>> @@ -4463,6 +4475,19 @@ static void rt2800_init_rfcsr_305x_soc(struct rt2x00_dev *rt2x00dev)
>> 
>> static void rt2800_init_rfcsr_30xx(struct rt2x00_dev *rt2x00dev)
>> {
>> +    u8 rfcsr;
>> +
>> +    /*
>> +     * Init RF calibration.
>> +     * XXX: vendor driver do this only for 3070 ?
>> +     */
>> +    rt2800_rfcsr_read(rt2x00dev, 30, &rfcsr);
>> +    rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 1);
>> +    rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
>> +    msleep(1);
>> +    rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 0);
>> +    rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
>> +
>>   rt2800_rfcsr_write(rt2x00dev, 4, 0x40);
>>   rt2800_rfcsr_write(rt2x00dev, 5, 0x03);
>>   rt2800_rfcsr_write(rt2x00dev, 6, 0x02);
>> @@ -4486,6 +4511,8 @@ static void rt2800_init_rfcsr_30xx(struct rt2x00_dev *rt2x00dev)
>> 
>> static void rt2800_init_rfcsr_3290(struct rt2x00_dev *rt2x00dev)
>> {
>> +    rt2800_rf_init_calibration_53xx(rt2x00dev);
>> +
>>   rt2800_rfcsr_write(rt2x00dev, 1, 0x0f);
>>   rt2800_rfcsr_write(rt2x00dev, 2, 0x80);
>>   rt2800_rfcsr_write(rt2x00dev, 3, 0x08);
>> @@ -4674,6 +4701,8 @@ static void rt2800_init_rfcsr_3572(struct rt2x00_dev *rt2x00dev)
>> 
>> static void rt2800_init_rfcsr_5390(struct rt2x00_dev *rt2x00dev)
>> {
>> +    rt2800_rf_init_calibration_53xx(rt2x00dev);
>> +
>>   rt2800_rfcsr_write(rt2x00dev, 1, 0x0f);
>>   rt2800_rfcsr_write(rt2x00dev, 2, 0x80);
>>   rt2800_rfcsr_write(rt2x00dev, 3, 0x88);
>> @@ -4760,6 +4789,8 @@ static void rt2800_init_rfcsr_5390(struct rt2x00_dev *rt2x00dev)
>> 
>> static void rt2800_init_rfcsr_5392(struct rt2x00_dev *rt2x00dev)
>> {
>> +    rt2800_rf_init_calibration_53xx(rt2x00dev);
>> +
>>   rt2800_rfcsr_write(rt2x00dev, 1, 0x17);
>>   rt2800_rfcsr_write(rt2x00dev, 2, 0x80);
>>   rt2800_rfcsr_write(rt2x00dev, 3, 0x88);
>> @@ -4882,28 +4913,6 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>>       !rt2800_is_305x_soc(rt2x00dev))
>>       return 0;
>> 
>> -    /*
>> -     * Init RF calibration.
>> -     */
>> -
>> -    if (rt2x00_rt(rt2x00dev, RT3290) ||
>> -        rt2x00_rt(rt2x00dev, RT5390) ||
>> -        rt2x00_rt(rt2x00dev, RT5392)) {
>> -        rt2800_rfcsr_read(rt2x00dev, 2, &rfcsr);
>> -        rt2x00_set_field8(&rfcsr, RFCSR2_RESCAL_EN, 1);
>> -        rt2800_rfcsr_write(rt2x00dev, 2, rfcsr);
>> -        msleep(1);
>> -        rt2x00_set_field8(&rfcsr, RFCSR2_RESCAL_EN, 0);
>> -        rt2800_rfcsr_write(rt2x00dev, 2, rfcsr);
>> -    } else {
>> -        rt2800_rfcsr_read(rt2x00dev, 30, &rfcsr);
>> -        rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 1);
>> -        rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
>> -        msleep(1);
>> -        rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 0);
>> -        rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
>> -    }
>> -
> 
> As Gabor already mentioned, this else branch is used for other chipsets (not just 305x_soc, but also RT35xx, RT55xx).
> 
>>   if (rt2800_is_305x_soc(rt2x00dev)) {
>>       rt2800_init_rfcsr_305x_soc(rt2x00dev);
>>       return 0;
>> -- 
>> 1.7.4.4
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
