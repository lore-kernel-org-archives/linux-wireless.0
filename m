Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:62900 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab3DNUPV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Apr 2013 16:15:21 -0400
Received: by mail-ea0-f178.google.com with SMTP id o10so1963226eaj.9
        for <linux-wireless@vger.kernel.org>; Sun, 14 Apr 2013 13:15:20 -0700 (PDT)
References: <1365519930-3230-1-git-send-email-stf_xl@wp.pl> <1365519930-3230-4-git-send-email-stf_xl@wp.pl> <413EC3EA-0BB4-42CC-A95A-52468DC35C67@gmail.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <413EC3EA-0BB4-42CC-A95A-52468DC35C67@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <8CC8DB9F-51C2-4C0A-88FA-0193000D011A@gmail.com> (sfid-20130414_221526_161438_947863D8)
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 03/11] rt2800: move RFCSR29_RSSI_GAIN to 3290 specific rfcsr init
Date: Sun, 14 Apr 2013 22:15:18 +0200
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
>> drivers/net/wireless/rt2x00/rt2800lib.c |   12 ++++++------
>> 1 files changed, 6 insertions(+), 6 deletions(-)
>> 
>> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
>> index 334973a..085b60c 100644
>> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
>> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
>> @@ -4511,6 +4511,8 @@ static void rt2800_init_rfcsr_30xx(struct rt2x00_dev *rt2x00dev)
>> 
>> static void rt2800_init_rfcsr_3290(struct rt2x00_dev *rt2x00dev)
>> {
>> +    u8 rfcsr;
>> +
>>   rt2800_rf_init_calibration_53xx(rt2x00dev);
>> 
>>   rt2800_rfcsr_write(rt2x00dev, 1, 0x0f);
>> @@ -4559,6 +4561,10 @@ static void rt2800_init_rfcsr_3290(struct rt2x00_dev *rt2x00dev)
>>   rt2800_rfcsr_write(rt2x00dev, 59, 0x09);
>>   rt2800_rfcsr_write(rt2x00dev, 60, 0x45);
>>   rt2800_rfcsr_write(rt2x00dev, 61, 0xc1);
>> +
>> +    rt2800_rfcsr_read(rt2x00dev, 29, &rfcsr);
>> +    rt2x00_set_field8(&rfcsr, RFCSR29_RSSI_GAIN, 3);
>> +    rt2800_rfcsr_write(rt2x00dev, 29, rfcsr);
>> }
>> 
>> static void rt2800_init_rfcsr_3352(struct rt2x00_dev *rt2x00dev)
>> @@ -5103,12 +5109,6 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>>       rt2800_rfcsr_write(rt2x00dev, 27, rfcsr);
>>   }
>> 
>> -    if (rt2x00_rt(rt2x00dev, RT3290)) {
>> -        rt2800_rfcsr_read(rt2x00dev, 29, &rfcsr);
>> -        rt2x00_set_field8(&rfcsr, RFCSR29_RSSI_GAIN, 3);
>> -        rt2800_rfcsr_write(rt2x00dev, 29, rfcsr);
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
