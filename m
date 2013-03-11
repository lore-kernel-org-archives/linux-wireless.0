Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:46722 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647Ab3CKGbD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Mar 2013 02:31:03 -0400
Message-ID: <513D78C8.5020708@neratec.com> (sfid-20130311_073108_258102_33174C55)
Date: Mon, 11 Mar 2013 07:25:12 +0100
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com
Subject: Re: [PATCH 3.8 1/3] ath9k_hw: fix calibration issues on chainmask
 that don't include chain 0
References: <1358715322-46447-1-git-send-email-nbd@openwrt.org> <5138A4C8.7040500@neratec.com> <5138AB4A.7000405@openwrt.org> <5138B656.5090408@neratec.com> <513996DE.6030500@neratec.com> <5139B35D.9060803@neratec.com> <5139DCAA.8050003@openwrt.org>
In-Reply-To: <5139DCAA.8050003@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/08/2013 01:42 PM, Felix Fietkau wrote:
> On 2013-03-08 10:46 AM, Wojciech Dubowik wrote:
>> On 03/08/2013 08:44 AM, Wojciech Dubowik wrote:
>>> On 03/07/2013 04:46 PM, Wojciech Dubowik wrote:
>>>> On 03/07/2013 03:59 PM, Felix Fietkau wrote:
>>>>> On 2013-03-07 3:31 PM, Wojciech Dubowik wrote:
>>>>>> There is a regression introduced by this patch when power save is
>>>>>> off on
>>>>>> the station for idle checks.
>>>>>> I have AR9590 station with rx and tx chain set to 0x1 connected
>>>>>> to legacy AP (based on Ar9390) with RF cable and 40dB attenuator.
>>>>>>
>>>>>> Before this patch in connection polling the station was properly
>>>>>> sending
>>>>>> null function to check whether AP is still there. After this patch
>>>>>> it sends
>>>>>> broadcast probe request which is anyway wrong or some 16 or so packets
>>>>>> of random data (rarely). It manifests itself in lost connection
>>>>>> because
>>>>>> there
>>>>>> is no ack from AP which is expected for null function.
>>>>>>
>>>>>> I have been following skb's up to the descriptor setting in ath9k
>>>>>> and it was
>>>>>> all ok i.e. proper null function with valid addresses.
>>>>>>
>>>>>> I have been bisecting it twice because it doesn't make much sense
>>>>>> but maybe
>>>>>> it's a HW issue?
>>>>> You're right, it does not make much sense. I can't figure out how this
>>>>> patch could possibly change the runtime behavior with tx chainmask set
>>>>> to 0x1. Have you tried reverting this patch in a current build to
>>>>> see if
>>>>> that fixes the issue?
>>>> It does fix it. I will check tomorrow whether it's only AR9590 or also
>>>> previous revisions. I will also try with different chainmasks. I will
>>>> have
>>>> to rescrew my setup...
>>>>
>>> I have been doing some tests and it seems to affect both AR9390 and
>>> AR9590.
>>> To summarize: sta doesn't send null function but broadcast probe
>>> request or
>>> corrupted frames in idle checking routine when power save is off and
>>> only some
>>> antennas are selected for transmission.
>>> So for example when I set antenna mask 7 i.e. all available it works
>>> ok but with
>>> mask 1, 3 or 6 not. When I swith power save it's all ok no matter what
>>> mask I use.
>>>
>>> Thing with power save on is that before it goes to idle check it will
>>> go to sleep since
>>> there is no traffic anyway, then we get beacon miss, it wakes up and
>>> it sends null
>>> function. I guess waking up is reinitializing sth in a chip which
>>> doesn't occur in my
>>> scenario.
>>> HW issue?
>> It will also work if I set user specified antenna masks instead of hw
>> capabilities.
> What do you mean with that? How do you set the rx and tx chainmasks if
> not via antenna masks? debugfs?
I do it with iw set antenna.
Wojtek
