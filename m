Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f49.google.com ([209.85.219.49]:49878 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab3CIXCo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Mar 2013 18:02:44 -0500
Received: by mail-oa0-f49.google.com with SMTP id j6so3311464oag.22
        for <linux-wireless@vger.kernel.org>; Sat, 09 Mar 2013 15:02:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <512595BC.5030607@lwfinger.net>
References: <1361021140-19871-1-git-send-email-hauke@hauke-m.de>
	<CACna6ryaMfZ9x7VWHnRR9RF0wSN0A+H6vr3AC103Sn4G1XZdKQ@mail.gmail.com>
	<1361381489.3065.1.camel@joe-AO722>
	<51250E6B.3030308@lwfinger.net>
	<1361384969.2219.4.camel@joe-AO722>
	<51252132.3050603@hauke-m.de>
	<1361391065.2223.5.camel@joe-AO722>
	<512595BC.5030607@lwfinger.net>
Date: Sun, 10 Mar 2013 00:02:42 +0100
Message-ID: <CACna6rzQNo9CBrg08y6y+bf3009_EuL5f2UqOXVLKSoE_q7BRQ@mail.gmail.com> (sfid-20130310_000248_238113_3A6C234E)
Subject: Re: [PATCH] ssb: fix unaligned access to mac address
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Joe Perches <joe@perches.com>, Hauke Mehrtens <hauke@hauke-m.de>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/2/21 Larry Finger <Larry.Finger@lwfinger.net>:
> On 02/20/2013 02:11 PM, Joe Perches wrote:
>>
>> On Wed, 2013-02-20 at 20:17 +0100, Hauke Mehrtens wrote:
>>>
>>> On 02/20/2013 07:29 PM, Joe Perches wrote:
>>>>
>>>> On Wed, 2013-02-20 at 11:56 -0600, Larry Finger wrote:
>>>>>
>>>>> On 02/20/2013 11:31 AM, Joe Perches wrote:
>>>>>>
>>>>>> On Mon, 2013-02-18 at 17:09 +0100, Rafał Miłecki wrote:
>>>>>>>
>>>>>>> 2013/2/16 Hauke Mehrtens <hauke@hauke-m.de>:
>>>>>>>>
>>>>>>>> The mac address should be aligned to u16 to prevent an unaligned
>>>>>>>> access
>>>>>>>> in drivers/ssb/pci.c where it is casted to __be16.
>>>>>>
>>>>>> []
>>>>>>>>
>>>>>>>> diff --git a/include/linux/ssb/ssb.h b/include/linux/ssb/ssb.h
>>>>>>
>>>>>> []
>>>>>>>>
>>>>>>>> @@ -26,6 +26,7 @@ struct ssb_sprom_core_pwr_info {
>>>>>>>>
>>>>>>>>    struct ssb_sprom {
>>>>>>>>           u8 revision;
>>>>>>>> +       u8 country_code;        /* Country Code */
>>>>>>>>           u8 il0mac[6];           /* MAC address for 802.11b/g */
>>>>>>>
>>>>>>>
>>>>>>> It looks a little hacky to me too, it's easy to forget about that
>>>>>>> requirement and break that again in the future.
>>>>>>>
>>>>>>> What about not casting il0mac to u16 at all? Maybe we should just
>>>>>>> fill
>>>>>>> it as u8 (which it is)?
>>>>>>>
>>>>>>
>>>>>> Perhaps this?
>>>>>>
>>>>>> From: Joe Perches <joe@perches.com>
>>>>>> Subject: [PATCH] ssb: pci: Standardize a function to get mac address
>>>>>>
>>>>>> Don't require alignment of mac addresses to u16.
>>>
>>>
>>> ...
>>>
>>>>> I like the looks of sprom_get_mac() over that ugly *(((__be16
>>>>> *)out->il0mac)
>>>>> construct, but this patch breaks ssb. The resulting MAC address is all
>>>>> ones. I
>>>>> have not yet figured out the problem.
>>>>
>>>>
>>>> Dunno, I must have done something stupid.
>>>>
>>>> I don't have one of these but the transform
>>>> looked correct when I did  it.
>>>>
>>>> I'm not sure it's the best solution anyway
>>>> because some of the other ether address
>>>> functions like compare_ether_addr also
>>>> require 2 byte alignment and cast to u16.
>>>
>>>
>>> Your patch looks good (haven't tested it), but as you said we should
>>> still align the mac addresses to u16 so functions like
>>> compare_ether_addr work with them.
>>>
>>> There is also a v2 of my patch:
>>> http://www.spinics.net/lists/linux-wireless/msg103628.html
>>
>>
>> Seems OK to me, though I suggest using ETH_ALEN
>> instead of 6.
>>
>> Maybe using both patches would be better still.
>>
>> And as long as I'm futzing with ssb, there's another
>> logging cleanup to go with it.
>>
>> Here's a V2 with the missing SPOFF fixed.
>>
>> Subject: [PATCH 1/2] ssb: pci: Standardize a function to get mac address
>> From: Joe Perches <joe@perches.com>
>>
>> Don't require alignment of mac addresses to u16.
>>
>> Signed-off-by: Joe Perches <joe@perches.com>
>> ---
>>
>> V2: Add missing SPOFF
>
>
> Tested-by: Larry Finger <Larry.Finger@lwfinger.net>

I didn't confirm my issue to be related to this patch, but with recent
kernels my MAC has changed from
00:11:22:33:44:55
to
11:00:33:22:55:44

Larry: did you verify MAC didn't change for you?

-- 
Rafał
