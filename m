Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f49.google.com ([209.85.219.49]:38414 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab3DLWU1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Apr 2013 18:20:27 -0400
Received: by mail-oa0-f49.google.com with SMTP id j6so2936393oag.8
        for <linux-wireless@vger.kernel.org>; Fri, 12 Apr 2013 15:20:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51671663.3070707@lwfinger.net>
References: <1365703360-19982-1-git-send-email-shenhan@google.com>
	<1365705330.1929.30.camel@joe-AO722>
	<51671663.3070707@lwfinger.net>
Date: Fri, 12 Apr 2013 15:20:27 -0700
Message-ID: <CACkGtri5R2sgFZd9-M+UCNJ1NOwFS769NJqHUTgWUgtgRnDWow@mail.gmail.com> (sfid-20130413_002031_967620_18321548)
Subject: Re: [PATCH] Fix uninitialized-variable warnings.
From: =?GB2312?B?SGFuIFNoZW4oyfK6rSk=?= <shenhan@google.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Joe Perches <joe@perches.com>, linux-wireless@vger.kernel.org,
	chaoming_li@realsil.com.cn
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Joe's patch (the 1-line fix) does not work for me. The assignment
is in a conditional block, when refer to this ofdm_index_old later, I
still get error -

/mnt/host/source/src/third_party/kernel/files/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c:771:31:
error: 'ofdm_index_old[1]' may be used uninitialized in this function
[-Werror=maybe-uninitialized]
     rtlpriv->dm.ofdm_index[i] = ofdm_index_old[i];

(I'm working on 3.4 branch.)

Thanks,

On Thu, Apr 11, 2013 at 1:00 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 04/11/2013 01:35 PM, Joe Perches wrote:
>>
>> On Thu, 2013-04-11 at 11:02 -0700, Han Shen wrote:
>>>
>>> GCC 4.8 is spitting out uninitialized-varaible warnings against
>>> "drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c".
>>> This trivial patch just adds initialization to the variable.
>>
>>
>> Not sure this is correct.
>> I think the logic should be inspected instead.
>>
>> ofdm_index_old[1] _is_ used uninitialized.
>>
>> It appears there might be a missing
>>
>>         ofdm_index_old[1] = (u8) i;
>>
>> as that's the same style test done in the
>> section above.
>>
>> Maybe this:
>> ---
>>   drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
>> b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
>> index b793a65..56b2b2f 100644
>> --- a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
>> +++ b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
>> @@ -717,6 +717,7 @@ static void
>> rtl92c_dm_txpower_tracking_callback_thermalmeter(struct ieee80211_hw
>>                         for (i = 0; i < OFDM_TABLE_LENGTH; i++) {
>>                                 if (ele_d == (ofdmswing_table[i] &
>>                                     MASKOFDM_D)) {
>> +                                       ofdm_index_old[1] = (u8) i;
>>
>>                                         RT_TRACE(rtlpriv,
>> COMP_POWER_TRACKING,
>>                                                  DBG_LOUD,
>
>
> My earlier E-mail was too hasty. Joe's patch is correct. It should be marked
> for stable (2.6.39+).
>
> Larry
>
>
>



-- 
Han Shen |  Software Engineer |  shenhan@google.com |  +1-650-440-3330
