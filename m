Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:48121 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab3DNUSb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Apr 2013 16:18:31 -0400
Received: by mail-ea0-f171.google.com with SMTP id b15so1949143eae.16
        for <linux-wireless@vger.kernel.org>; Sun, 14 Apr 2013 13:18:30 -0700 (PDT)
References: <1365519930-3230-1-git-send-email-stf_xl@wp.pl> <1365519930-3230-9-git-send-email-stf_xl@wp.pl> <742363D2-2E4F-40E5-81BB-69252F998D43@gmail.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <742363D2-2E4F-40E5-81BB-69252F998D43@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <81100A2D-7BA5-41F0-B118-D979739ECA45@gmail.com> (sfid-20130414_221836_461476_4D47262C)
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 08/11] rt2800: move RF_R27 setup to individual rfcsr init subroutines
Date: Sun, 14 Apr 2013 22:18:29 +0200
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
>> drivers/net/wireless/rt2x00/rt2800lib.c |   18 +++++++++++-------
>> 1 files changed, 11 insertions(+), 7 deletions(-)
>> 
>> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
>> index df8760f..fe0df88 100644
>> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
>> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
>> @@ -4588,6 +4588,11 @@ static void rt2800_init_rfcsr_30xx(struct rt2x00_dev *rt2x00dev)
>>   }
>> 
>>   rt2800_rx_filter_calibration(rt2x00dev);
>> +
>> +    if (rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070F) ||
>> +        rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E) ||
>> +        rt2x00_rt_rev_lt(rt2x00dev, RT3090, REV_RT3090E))
>> +        rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
>> }
>> 
>> static void rt2800_init_rfcsr_3290(struct rt2x00_dev *rt2x00dev)
>> @@ -4761,6 +4766,9 @@ static void rt2800_init_rfcsr_3390(struct rt2x00_dev *rt2x00dev)
>>   rt2800_register_write(rt2x00dev, GPIO_SWITCH, reg);
>> 
>>   rt2800_rx_filter_calibration(rt2x00dev);
>> +
>> +    if (rt2x00_rt_rev_lt(rt2x00dev, RT3390, REV_RT3390E))
>> +        rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
>> }
>> 
>> static void rt2800_init_rfcsr_3572(struct rt2x00_dev *rt2x00dev)
>> @@ -5007,6 +5015,9 @@ static void rt2800_init_rfcsr_5592(struct rt2x00_dev *rt2x00dev)
>>       rt2800_bbp_write(rt2x00dev, 103, 0xc0);
>> 
>>   rt2800_normal_mode_setup_5xxx(rt2x00dev);
>> +
>> +    if (rt2x00_rt_rev_lt(rt2x00dev, RT5592, REV_RT5592C))
>> +        rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
>> }
>> 
>> static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>> @@ -5063,13 +5074,6 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>>       return 0;
>>   }
>> 
>> -    if (rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070F) ||
>> -        rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E) ||
>> -        rt2x00_rt_rev_lt(rt2x00dev, RT3090, REV_RT3090E) ||
>> -        rt2x00_rt_rev_lt(rt2x00dev, RT3390, REV_RT3390E) ||
>> -        rt2x00_rt_rev_lt(rt2x00dev, RT5592, REV_RT5592C))
>> -        rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
>> -
>>   rt2800_register_read(rt2x00dev, OPT_14_CSR, &reg);
>>   rt2x00_set_field32(&reg, OPT_14_CSR_BIT0, 1);
>>   rt2800_register_write(rt2x00dev, OPT_14_CSR, reg);
>> -- 
>> 1.7.4.4
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
