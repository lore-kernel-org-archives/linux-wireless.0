Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40080 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968358Ab0B1D2O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Feb 2010 22:28:14 -0500
Received: by pwj8 with SMTP id 8so920433pwj.19
        for <linux-wireless@vger.kernel.org>; Sat, 27 Feb 2010 19:28:13 -0800 (PST)
Message-ID: <4B89E0D7.9020103@lwfinger.net>
Date: Sat, 27 Feb 2010 21:19:51 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, stable@kernel.org
Subject: Re: [PATCH] ath9k: decrease size of ath9k.ko
References: <1267289803-6795-1-git-send-email-tom.leiming@gmail.com>	 <4B89520D.1000209@lwfinger.net> <d82e647a1002271852j20006c27i92d1f7a99e032f2d@mail.gmail.com>
In-Reply-To: <d82e647a1002271852j20006c27i92d1f7a99e032f2d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/27/2010 08:52 PM, Ming Lei wrote:
> 2010/2/28 Larry Finger <Larry.Finger@lwfinger.net>:
>> On 02/27/2010 10:56 AM, tom.leiming@gmail.com wrote:
>>> From: Ming Lei <tom.leiming@gmail.com>
>>>
>>> The patch defines the fields of 'valid_single_stream' and 'valid' in
>>> struct ath_rate_table as char type, so decrease the size of ath9k.ko
>>> about 2KB.
>>>
>>> old ath9k.ko
>>> [tom@tom-lei ath9k]$ size ath9k.ko
>>>    text    data     bss     dec     hex filename
>>>   69344    3080     168   72592   11b90 ath9k.ko
>>>
>>> new ath9k.ko
>>> [tom@tom-lei ath9k]$ size ath9k.ko
>>>    text    data     bss     dec     hex filename
>>>   67304    3080     168   70552   11398 ath9k.ko
>>>
>>> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
>>> ---
>>>  drivers/net/wireless/ath/ath9k/rc.h |    4 ++--
>>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/ath/ath9k/rc.h b/drivers/net/wireless/ath/ath9k/rc.h
>>> index 4f6d6fd..389168a 100644
>>> --- a/drivers/net/wireless/ath/ath9k/rc.h
>>> +++ b/drivers/net/wireless/ath/ath9k/rc.h
>>> @@ -110,8 +110,8 @@ struct ath_rate_table {
>>>       int rate_cnt;
>>>       int mcs_start;
>>>       struct {
>>> -             int valid;
>>> -             int valid_single_stream;
>>> +             char valid;
>>> +             char valid_single_stream;
>>>               u8 phy;
>>>               u32 ratekbps;
>>>               u32 user_ratekbps;
>>
>> Why 'char' rather than 'u8'? To me, the latter implies a small integer, not
>> character data.
> 
> Either 'char' or 'u8' is OK, since both has one-byte size, isn't it?

It wasn't the size, but the content implied by the type.
