Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3209 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753710Ab3IFQuX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Sep 2013 12:50:23 -0400
Message-ID: <522A07C2.5040906@broadcom.com> (sfid-20130906_185026_622904_67F4E3CF)
Date: Fri, 6 Sep 2013 18:50:10 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: bcma problem on x86_64
References: <522879D0.2030107@broadcom.com>
 <CACna6ryc0_9xcQonuJbK6aB0-ak_izLTi_LNGHB=Lsx0Q5t-Zw@mail.gmail.com>
 <52299AC3.5010809@broadcom.com> <5229F3D1.9000200@broadcom.com>
 <522A04B4.3050708@hauke-m.de>
In-Reply-To: <522A04B4.3050708@hauke-m.de>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/06/2013 06:37 PM, Hauke Mehrtens wrote:
> On 09/06/2013 05:25 PM, Arend van Spriel wrote:
>> On 09/06/2013 11:05 AM, Arend van Spriel wrote:
>>> On 09/06/2013 10:05 AM, Rafał Miłecki wrote:
>>>> Hi,
>>>>
>>>> 2013/9/5 Arend van Spriel <arend@broadcom.com>:
>>>>> Since 3.11-rc4 I am seeing a problem with bcma on x64 (see attached
>>>>> log). I
>>>>> thought I misconfigured my setup, but just upgraded to 3.11 and I am
>>>>> still
>>>>> seeing the same issue. Did you have any reports like this?
>>>>
>>>> Unfortunately I wasn't testing final 3.11 with x86_64, I'll give it a
>>>> try over the weekend.
>>>>
>>>
>>> I am bisecting. Will let you know when I find something.
>>
>> Bisect points to:
>>
>> fd4edf197544bae1c77d84bad354aa7ce1d08ce1 is the first bad commit
>> commit fd4edf197544bae1c77d84bad354aa7ce1d08ce1
>> Author: Hauke Mehrtens <hauke@hauke-m.de>
>> Date:   Mon Jul 15 13:15:08 2013 +0200
>>
>>      bcma: fix handling of big addrl
>>
>>      The return value of bcma_erom_get_addr_desc() is a unsigned value
>> and it
>>      could wrap around in the two complement writing. This happens for one
>>      core in the BCM4708 SoC.
>>
>>      Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>>      Signed-off-by: John W. Linville <linville@tuxdriver.com>
>>
>> It is probably caused by using IS_ERR_VALUE() macro which does a
>> unsigned long cast, which gives different results on 64-bit platform.
>>
>> This patch was submitted upstream yesterday by Dave for 3.12-rc1.
>>
>> Regards,
>> Arend
>>
> Hi Arend,
>
> Thanks for spotting this. This commit is not in final 3.11, otherwise
> I would have suspected it before.

Yeah. It will need to be fixed for 3.12 after the merge window.

> Could you please try the attached patch.

Just tried my own patch, which essentially does the same (not using a 
macro).

So you may add
Acked-by: or Tested-by: Arend van Spriel <arend@broadcom.com>
Whatever you think is most appropriate.

Regards,
Arend

