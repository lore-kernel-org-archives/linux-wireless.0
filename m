Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:35332 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967543AbeCAKvC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 05:51:02 -0500
Received: by mail-io0-f193.google.com with SMTP id 30so6690421iog.2
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 02:51:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <f914ce85-5492-ad24-9ce9-ebcd0a79af04@blackstar.nl>
References: <cover.1519827461.git.lorenzo.bianconi@redhat.com>
 <2850551da4495924bde846dd237b736e41913d0f.1519827461.git.lorenzo.bianconi@redhat.com>
 <3263f88f-daec-837c-e58c-bee907295d47@blackstar.nl> <f914ce85-5492-ad24-9ce9-ebcd0a79af04@blackstar.nl>
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date: Thu, 1 Mar 2018 11:51:01 +0100
Message-ID: <CAJ0CqmWanWyqu8dzwx2UVBYaCwiXqDOUKzx9eNaoR0U2v3s1JA@mail.gmail.com> (sfid-20180301_115112_401005_74EBCBEB)
Subject: Re: [PATCH] mt7601u: remove a warning in mt7601u_efuse_physical_size_check()
To: Bas Vermeulen <bvermeul@blackstar.nl>
Cc: Jakub Kicinski <kubakici@wp.pl>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Nevermind. round_up instead of DIV_ROUND_UP.
>
> Bas Vermeulen
>
>
>
> On 01-03-18 11:22, Bas Vermeulen wrote:
>>
>>
>>
>> On 28-02-18 15:26, Lorenzo Bianconi wrote:
>>>
>>> Fix the following sparse warning in mt7601u_efuse_physical_size_check:
>>> - drivers/net/wireless/mediatek/mt7601u/eeprom.c:77:27: warning:
>>>    Variable length array is used
>>>
>>> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
>>> ---
>>>   drivers/net/wireless/mediatek/mt7601u/eeprom.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/wireless/mediatek/mt7601u/eeprom.c
>>> b/drivers/net/wireless/mediatek/mt7601u/eeprom.c
>>> index da6faea092d6..a462064b5c91 100644
>>> --- a/drivers/net/wireless/mediatek/mt7601u/eeprom.c
>>> +++ b/drivers/net/wireless/mediatek/mt7601u/eeprom.c
>>> @@ -74,7 +74,7 @@ static int
>>>   mt7601u_efuse_physical_size_check(struct mt7601u_dev *dev)
>>>   {
>>>       const int map_reads = DIV_ROUND_UP(MT_EFUSE_USAGE_MAP_SIZE, 16);
>>> -    u8 data[map_reads * 16];
>>> +    u8 data[round_up(MT_EFUSE_USAGE_MAP_SIZE, 16)];
>>
>> Shouldn't this be u8 data[round_up(MT_EFUSE_USAGE_MAP_SIZE,16)*16]; to get
>> the
>> same array size as before?
>>
>> Bas Vermeulen
>>

round_up(MT_EFUSE_USAGE_MAP_SIZE, 16) =
(DIV_ROUND_UP(MT_EFUSE_USAGE_MAP_SIZE, 16) * 16) = 32

Regards,
Lorenzo

>
>
> --
> This message has been scanned for viruses and
> dangerous content by MailScanner, and is
> believed to be clean.
>
