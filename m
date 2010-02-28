Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f179.google.com ([209.85.221.179]:47297 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966016Ab0B1CwX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Feb 2010 21:52:23 -0500
Received: by qyk9 with SMTP id 9so768496qyk.5
        for <linux-wireless@vger.kernel.org>; Sat, 27 Feb 2010 18:52:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B89520D.1000209@lwfinger.net>
References: <1267289803-6795-1-git-send-email-tom.leiming@gmail.com>
	 <4B89520D.1000209@lwfinger.net>
Date: Sun, 28 Feb 2010 10:52:22 +0800
Message-ID: <d82e647a1002271852j20006c27i92d1f7a99e032f2d@mail.gmail.com>
Subject: Re: [PATCH] ath9k: decrease size of ath9k.ko
From: Ming Lei <tom.leiming@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/2/28 Larry Finger <Larry.Finger@lwfinger.net>:
> On 02/27/2010 10:56 AM, tom.leiming@gmail.com wrote:
>> From: Ming Lei <tom.leiming@gmail.com>
>>
>> The patch defines the fields of 'valid_single_stream' and 'valid' in
>> struct ath_rate_table as char type, so decrease the size of ath9k.ko
>> about 2KB.
>>
>> old ath9k.ko
>> [tom@tom-lei ath9k]$ size ath9k.ko
>>    text    data     bss     dec     hex filename
>>   69344    3080     168   72592   11b90 ath9k.ko
>>
>> new ath9k.ko
>> [tom@tom-lei ath9k]$ size ath9k.ko
>>    text    data     bss     dec     hex filename
>>   67304    3080     168   70552   11398 ath9k.ko
>>
>> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
>> ---
>>  drivers/net/wireless/ath/ath9k/rc.h |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/rc.h b/drivers/net/wireless/ath/ath9k/rc.h
>> index 4f6d6fd..389168a 100644
>> --- a/drivers/net/wireless/ath/ath9k/rc.h
>> +++ b/drivers/net/wireless/ath/ath9k/rc.h
>> @@ -110,8 +110,8 @@ struct ath_rate_table {
>>       int rate_cnt;
>>       int mcs_start;
>>       struct {
>> -             int valid;
>> -             int valid_single_stream;
>> +             char valid;
>> +             char valid_single_stream;
>>               u8 phy;
>>               u32 ratekbps;
>>               u32 user_ratekbps;
>
> Why 'char' rather than 'u8'? To me, the latter implies a small integer, not
> character data.

Either 'char' or 'u8' is OK, since both has one-byte size, isn't it?

Thanks,

-- 
Lei Ming
