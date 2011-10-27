Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49731 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab1J0WSQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Oct 2011 18:18:16 -0400
Received: by gyb13 with SMTP id 13so3079539gyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 27 Oct 2011 15:18:16 -0700 (PDT)
Message-ID: <4EA9D8A5.9060104@lwfinger.net> (sfid-20111028_001820_055285_564AC50A)
Date: Thu, 27 Oct 2011 17:18:13 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: Roman Proud <setamagiga@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: RTL8188RU no injection?
References: <CAF7qGM4BL10gn2786kW73sAk8f-y8CzX0rx2BQsY_Q96W=pfog@mail.gmail.com> <4EA89B8D.7060104@lwfinger.net> <CAF7qGM7hfaz0SGiZVZ62r_nPO8viMT5F2_Kd1uRxN9Ha3mRO+Q@mail.gmail.com> <4EA97323.50004@lwfinger.net> <CA+XFjipvGBsWCCWt5OvFfeCiOpsH28Txvui4A+d8sVCaACQ57Q@mail.gmail.com>
In-Reply-To: <CA+XFjipvGBsWCCWt5OvFfeCiOpsH28Txvui4A+d8sVCaACQ57Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/27/2011 05:00 PM, Gábor Stefanik wrote:
> On Thu, Oct 27, 2011 at 5:05 PM, Larry Finger<Larry.Finger@lwfinger.net>  wrote:
>> On 10/27/2011 08:17 AM, Roman Proud wrote:
>>>
>>> Hi peops
>>>
>>> thx for all youre responses!
>>>
>>> Well i didnt really thought about g and n -.-
>>>
>>> Im using the latest 8192cu driver from Realtek now, it works just
>>> fine. Also monitor mode works like a charm (yes if i use airmon-ng for
>>> it). My Kernel is (now the default) Arch kernel, on Linux Version
>>> 3.0.4
>>>
>>> My last problem is the Package injection. Im surprised you are
>>> thinking it could work (ive found many resources that say something
>>> different, but hey its an OpenSource driver ;)
>>
>> Well, I tested with Packetspammer and it worked. As in many cases, the
>> resources that say otherwise are wrong.
>>
>>> Pls excuse my "stupidness" but im really not sure if i am using
>>> "mac80211", i think so, its leaded in the System.
>>
>> The drivers for most devices without a hardware MAC use mac80211 and
>> friends. In fact, it is a prerequisite for getting a driver included in the
>> mainline drivers/net/wireless/ tree. If the driver implements its own MAC
>> layer, then it resides in drivers/staging/. Yes, it is loaded on your
>> system, and it handles a lot of things for the drivers that use it.
>>
>>> And yes its Aircrack im trying to work with, and its Aircrack which
>>> tells me i cant use Packet Injection.
>>> I will try Packetspammer as soon as i am at home. If this works i have
>>> to contact Aircrack, am i right?
>>
>> If Aircrack adds the socket method used by Packetspammer, it will work with
>> nearly every driver in the kernel that supports monitor mode. Whether they
>> want to do that will be their decision, of course.
>
> As a former Aircrack developer, I can definitely state that Aircrack
> uses the same injection method as packetspammer.
>
> However, Realtek's r8192cu driver will never support injection, and it
> is not a mac80211 driver. Look for a driver whose module name begins
> with "rtl" (not just "r"). AFAIK one is included in recent kernels.

I accepted his word that Aircrack does not work. He is using the mac80211 driver 
rtl8192cu, which was introduced in 2.6.39. The driver in 
drivers/staging/rtl8192u/ is for a different device.

Larry


