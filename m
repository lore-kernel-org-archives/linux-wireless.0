Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f54.google.com ([209.85.219.54]:54404 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755731Ab3CFWFj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Mar 2013 17:05:39 -0500
Received: by mail-oa0-f54.google.com with SMTP id n12so13398775oag.13
        for <linux-wireless@vger.kernel.org>; Wed, 06 Mar 2013 14:05:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+K+NcRUeC2Y-4n828gtMCUeoOb9JVOj5c6zGjKG8iWnvJFnOg@mail.gmail.com>
References: <CA+K+NcR9tExM9y-yjH_MB=ZpjeeakMW2GozECg4Pejp54nkCjA@mail.gmail.com>
	<513624B7.8010109@broadcom.com>
	<loom.20130306T000201-626@post.gmane.org>
	<5137188A.4070007@broadcom.com>
	<CA+K+NcRUeC2Y-4n828gtMCUeoOb9JVOj5c6zGjKG8iWnvJFnOg@mail.gmail.com>
Date: Wed, 6 Mar 2013 23:05:38 +0100
Message-ID: <CA+K+NcS3NkGKV_R4ua2cnpQHNn39emM+d4iO1TR90Y5eLO_YSA@mail.gmail.com> (sfid-20130306_230542_947141_1FF6EA31)
Subject: Re: BCM4313 problems connecting to AP since 3.8
From: =?UTF-8?B?SsOhbiBWZXNlbMO9?= <jano.vesely@gmail.com>
To: Piotr Haber <phaber@broadcom.com>
Cc: Alexander Mezin <mezin.alexander@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 6, 2013 at 9:00 PM, Ján Veselý <jano.vesely@gmail.com> wrote:
> hi,
> this is what my card says:
>
> # cat /sys/kernel/debug/brcmsmac/bcma0\:0/hardware
> board vendor: 1028
> board type: 10
> board revision: 2400
> board flags: 8002a00
> board flags2: 0
> firmware revision: 262032b
>
> I'll try to verify that reverting that commit fixes my problem as well.

I confirm that reverting said commit fixes my problems (tested on 3.9-rc1),

>
> Jan
>
> On Wed, Mar 6, 2013 at 11:20 AM, Piotr Haber <phaber@broadcom.com> wrote:
>> On 03/06/13 00:06, Alexander Mezin wrote:
>>> Arend van Spriel <arend@...> writes:
>>>
>>>>
>>>> On 03/04/13 22:47, Ján Veselý wrote:
>>>>> Hi,
>>>>>
>>>>> after upgrading to 3.8 I started running into a timeout problem on
>>>>> BCM4313 wifi using brcmsmac driver (compiled as module, x86_64).
>>>>> the card is unable to connect to ap after startup of resume.
>>>>> Although it eventually connects it takes a long time (several minutes)
>>>>> and dmesg log is spammed with:
>>>>>
>>>>> [  144.725431] wlan0: authenticate with 00:23:f8:8f:29:14
>>>>> [  144.727786] wlan0: capabilities/regulatory prevented using AP
>>>>> HT/VHT configuration, downgraded
>>>>> [  144.727820] wlan0: direct probe to 00:23:f8:8f:29:14 (try 1/3)
>>>>> [  144.930780] wlan0: direct probe to 00:23:f8:8f:29:14 (try 2/3)
>>>>> [  145.133855] wlan0: direct probe to 00:23:f8:8f:29:14 (try 3/3)
>>>>> [  145.336931] wlan0: authentication with 00:23:f8:8f:29:14 timed out
>>>>> [  151.217245] wlan0: authenticate with 00:23:f8:8f:29:14
>>>>>
>>>>> (30+ times in some cases)
>>>
>>> Had the same problem.
>>> It seems that this commit introduces the bug:
>>> https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?
>>> id=b6fc28a158076ca2764edc9a6d1e1402f56e1c0c
>>> I reverted it and now I have successful connection on first attempt. Linux
>>> 3.8.2, BCM4313 802.11b/g/n Wireless LAN Controller.
>>>
>> Hi,
>> that's disturbing.
>> I wonder what hardware version you have.
>> Could you share the contents of this debugfs file:
>> <debugfs_mount>/brcmsmac/bcma0:0/hardware
>>
>> Piotr
>>
>>
>>
