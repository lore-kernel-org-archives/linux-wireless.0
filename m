Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:46297 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935676Ab3BTTRS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 14:17:18 -0500
Message-ID: <51252132.3050603@hauke-m.de> (sfid-20130220_201725_083590_EC0A992E)
Date: Wed, 20 Feb 2013 20:17:06 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlYw==?= =?UTF-8?B?a2k=?=
	<zajec5@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ssb: fix unaligned access to mac address
References: <1361021140-19871-1-git-send-email-hauke@hauke-m.de>  <CACna6ryaMfZ9x7VWHnRR9RF0wSN0A+H6vr3AC103Sn4G1XZdKQ@mail.gmail.com>  <1361381489.3065.1.camel@joe-AO722> <51250E6B.3030308@lwfinger.net> <1361384969.2219.4.camel@joe-AO722>
In-Reply-To: <1361384969.2219.4.camel@joe-AO722>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/20/2013 07:29 PM, Joe Perches wrote:
> On Wed, 2013-02-20 at 11:56 -0600, Larry Finger wrote:
>> On 02/20/2013 11:31 AM, Joe Perches wrote:
>>> On Mon, 2013-02-18 at 17:09 +0100, Rafał Miłecki wrote:
>>>> 2013/2/16 Hauke Mehrtens <hauke@hauke-m.de>:
>>>>> The mac address should be aligned to u16 to prevent an unaligned access
>>>>> in drivers/ssb/pci.c where it is casted to __be16.
>>> []
>>>>> diff --git a/include/linux/ssb/ssb.h b/include/linux/ssb/ssb.h
>>> []
>>>>> @@ -26,6 +26,7 @@ struct ssb_sprom_core_pwr_info {
>>>>>
>>>>>   struct ssb_sprom {
>>>>>          u8 revision;
>>>>> +       u8 country_code;        /* Country Code */
>>>>>          u8 il0mac[6];           /* MAC address for 802.11b/g */
>>>>
>>>> It looks a little hacky to me too, it's easy to forget about that
>>>> requirement and break that again in the future.
>>>>
>>>> What about not casting il0mac to u16 at all? Maybe we should just fill
>>>> it as u8 (which it is)?
>>>>
>>>
>>> Perhaps this?
>>>
>>> From: Joe Perches <joe@perches.com>
>>> Subject: [PATCH] ssb: pci: Standardize a function to get mac address
>>>
>>> Don't require alignment of mac addresses to u16.

...

>> I like the looks of sprom_get_mac() over that ugly *(((__be16 *)out->il0mac) 
>> construct, but this patch breaks ssb. The resulting MAC address is all ones. I 
>> have not yet figured out the problem.
> 
> Dunno, I must have done something stupid.
> 
> I don't have one of these but the transform
> looked correct when I did  it.
> 
> I'm not sure it's the best solution anyway
> because some of the other ether address
> functions like compare_ether_addr also
> require 2 byte alignment and cast to u16.

Your patch looks good (haven't tested it), but as you said we should
still align the mac addresses to u16 so functions like
compare_ether_addr work with them.

There is also a v2 of my patch:
http://www.spinics.net/lists/linux-wireless/msg103628.html

Hauke
