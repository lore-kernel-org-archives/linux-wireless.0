Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1785 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757107Ab3CFLHL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Mar 2013 06:07:11 -0500
Message-ID: <51372354.50901@broadcom.com> (sfid-20130306_120717_938525_B2463B92)
Date: Wed, 6 Mar 2013 12:07:00 +0100
From: "Piotr Haber" <phaber@broadcom.com>
MIME-Version: 1.0
To: "Alexander Mezin" <mezin.alexander@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: BCM4313 problems connecting to AP since 3.8
References: <CA+K+NcR9tExM9y-yjH_MB=ZpjeeakMW2GozECg4Pejp54nkCjA@mail.gmail.com>
 <513624B7.8010109@broadcom.com>
 <loom.20130306T000201-626@post.gmane.org>
 <5137188A.4070007@broadcom.com>
 <CADnvcf+Mub7DhGWNqSuRF9u2A5HMfqUv5GuYrYcrkGjbXx470A@mail.gmail.com>
In-Reply-To: <CADnvcf+Mub7DhGWNqSuRF9u2A5HMfqUv5GuYrYcrkGjbXx470A@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/06/13 11:24, Alexander Mezin wrote:
> 2013/3/6 Piotr Haber <phaber@broadcom.com>:
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
> 
> board vendor: 103c
> board type: 1483
> board revision: 2410
> board flags: 8402a01
> board flags2: 880
> firmware revision: 262032c
> 
Thanks,
we had reports of poor performance of 4313/BT combo boards, but did not connect it to 4313iPA
support added by that problematic patch.
Will investigate.

Piotr

