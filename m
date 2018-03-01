Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blackstar.xs4all.nl ([83.163.96.30]:46471 "EHLO
        blackstar.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966305AbeCAK0l (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 05:26:41 -0500
Subject: Re: [PATCH] mt7601u: remove a warning in
 mt7601u_efuse_physical_size_check()
From: Bas Vermeulen <bvermeul@blackstar.nl>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>, kubakici@wp.pl
Cc: linux-wireless@vger.kernel.org
References: <cover.1519827461.git.lorenzo.bianconi@redhat.com>
 <2850551da4495924bde846dd237b736e41913d0f.1519827461.git.lorenzo.bianconi@redhat.com>
 <3263f88f-daec-837c-e58c-bee907295d47@blackstar.nl>
Message-ID: <f914ce85-5492-ad24-9ce9-ebcd0a79af04@blackstar.nl> (sfid-20180301_112649_909572_56B7367B)
Date: Thu, 1 Mar 2018 11:25:47 +0100
MIME-Version: 1.0
In-Reply-To: <3263f88f-daec-837c-e58c-bee907295d47@blackstar.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nevermind. round_up instead of DIV_ROUND_UP.

Bas Vermeulen


On 01-03-18 11:22, Bas Vermeulen wrote:
>
>
> On 28-02-18 15:26, Lorenzo Bianconi wrote:
>> Fix the following sparse warning in mt7601u_efuse_physical_size_check:
>> - drivers/net/wireless/mediatek/mt7601u/eeprom.c:77:27: warning:
>>    Variable length array is used
>>
>> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
>> ---
>>   drivers/net/wireless/mediatek/mt7601u/eeprom.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/mediatek/mt7601u/eeprom.c 
>> b/drivers/net/wireless/mediatek/mt7601u/eeprom.c
>> index da6faea092d6..a462064b5c91 100644
>> --- a/drivers/net/wireless/mediatek/mt7601u/eeprom.c
>> +++ b/drivers/net/wireless/mediatek/mt7601u/eeprom.c
>> @@ -74,7 +74,7 @@ static int
>>   mt7601u_efuse_physical_size_check(struct mt7601u_dev *dev)
>>   {
>>       const int map_reads = DIV_ROUND_UP(MT_EFUSE_USAGE_MAP_SIZE, 16);
>> -    u8 data[map_reads * 16];
>> +    u8 data[round_up(MT_EFUSE_USAGE_MAP_SIZE, 16)];
> Shouldn't this be u8 data[round_up(MT_EFUSE_USAGE_MAP_SIZE,16)*16]; to 
> get the
> same array size as before?
>
> Bas Vermeulen
>


-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.
