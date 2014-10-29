Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:55729 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932512AbaJ2L6n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 07:58:43 -0400
Received: by mail-ob0-f176.google.com with SMTP id va2so2194198obc.21
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 04:58:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5450CB46.4050207@gmail.com>
References: <544AA2F9.6050806@gmail.com>
	<CANUX_P1eHKLa4JQ9zx8D_mXr84__raCH0NrzGkxxB5CxTsGGAQ@mail.gmail.com>
	<5450CB46.4050207@gmail.com>
Date: Wed, 29 Oct 2014 13:58:43 +0200
Message-ID: <CANUX_P0ZBHYBXwkVbcXsEhoDqS4hH6==ucz1wFvpmdZEfFXc4A@mail.gmail.com> (sfid-20141029_125847_744237_3C102A60)
Subject: Re: Channel Estimation Question
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Jeremy Lansman <jeremy.lansman@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 29, 2014 at 1:11 PM, jeremy lansman
<jeremy.lansman@gmail.com> wrote:
> Emmanul;
>
> Thank you for that.
>
> I am a newbe to changing things at this low a level, so before I take the
> time to learn something new, I decided to do a test.
>
>  On the page it says, "When mac80211 wants to ensure that a frame is sent,
> it calls the flush() callback. Until now, iwldvm implemented this by waiting
> that all the frames are sent (ACKed or timeout). In case of weak signal,
> this can take a significant amount of time,..."
>
> In this case the signal is not weak, and there is no co-channel or adjacent
> channel interference.   The only interference will be from multipath
> reflections.
>

Well - honestly, this kind of things are really further down in the
firmware, and we have no easy-to-use tools to see what could cause
this kind of latency on this kind of device.
Note that when you move, the RSSI changes and that triggers scan which
induces latency.
But I can't really say much more than this.

> I just ran a test to demonstrate.
>
> Here is a signal sitting in one place as reported by nm-tool:
>   Wireless Access Points (* = current AP)
>   Busklandia:      Infra, D6:CA:6D:7A:BF:39, Freq 2447 MHz, Rate 54 Mb/s,
> Strength 55 WPA2
>   FishNet:         Infra, D6:CA:6D:7A:BF:37, Freq 2447 MHz, Rate 54 Mb/s,
> Strength 55
> *Office-C-Band:  Infra, D4:CA:6D:C5:68:29, Freq 5260 MHz, Rate 6 Mb/s,
> Strength 44 WPA
>
> Note I am using my Mikrotik 5 GHz AP, which is on the ouside wall of a
> building some 10 meters away.
> Here is the ping to this AP with the laptop on the floor after it has been
> sitting for a while:
> 64 bytes from 192.168.66.1: icmp_seq=60 ttl=64 time=1.18 ms
> 64 bytes from 192.168.66.1: icmp_seq=61 ttl=64 time=1.16 ms
> 64 bytes from 192.168.66.1: icmp_seq=62 ttl=64 time=1.08 ms
> 64 bytes from 192.168.66.1: icmp_seq=63 ttl=64 time=1.15 ms
> 64 bytes from 192.168.66.1: icmp_seq=64 ttl=64 time=1.02 ms
> 64 bytes from 192.168.66.1: icmp_seq=65 ttl=64 time=1.10 ms
> 64 bytes from 192.168.66.1: icmp_seq=66 ttl=64 time=1.11 ms
>
> Now I pick up the laptop and move it to a stronger signal.
>
> 64 bytes from 192.168.66.1: icmp_seq=259 ttl=64 time=1.09 ms
> 64 bytes from 192.168.66.1: icmp_seq=260 ttl=64 time=1.03 ms
> 64 bytes from 192.168.66.1: icmp_seq=261 ttl=64 time=0.986 ms
> 64 bytes from 192.168.66.1: icmp_seq=262 ttl=64 time=0.971 ms
> 64 bytes from 192.168.66.1: icmp_seq=263 ttl=64 time=1.02 ms
> 64 bytes from 192.168.66.1: icmp_seq=264 ttl=64 time=1.90 ms
> 64 bytes from 192.168.66.1: icmp_seq=265 ttl=64 time=1.02 ms
> 64 bytes from 192.168.66.1: icmp_seq=266 ttl=64 time=6038 ms
> 64 bytes from 192.168.66.1: icmp_seq=267 ttl=64 time=5032 ms
> 64 bytes from 192.168.66.1: icmp_seq=268 ttl=64 time=4024 ms
> 64 bytes from 192.168.66.1: icmp_seq=269 ttl=64 time=3016 ms
> 64 bytes from 192.168.66.1: icmp_seq=270 ttl=64 time=2008 ms
> 64 bytes from 192.168.66.1: icmp_seq=271 ttl=64 time=1000 ms
> 64 bytes from 192.168.66.1: icmp_seq=272 ttl=64 time=99.1 ms
> 64 bytes from 192.168.66.1: icmp_seq=273 ttl=64 time=4017 ms
> 64 bytes from 192.168.66.1: icmp_seq=274 ttl=64 time=3011 ms
> 64 bytes from 192.168.66.1: icmp_seq=275 ttl=64 time=2003 ms
> 64 bytes from 192.168.66.1: icmp_seq=276 ttl=64 time=995 ms
> 64 bytes from 192.168.66.1: icmp_seq=277 ttl=64 time=87.5 ms
> 64 bytes from 192.168.66.1: icmp_seq=278 ttl=64 time=1146 ms
> 64 bytes from 192.168.66.1: icmp_seq=279 ttl=64 time=139 ms
> 64 bytes from 192.168.66.1: icmp_seq=280 ttl=64 time=1148 ms
> 64 bytes from 192.168.66.1: icmp_seq=281 ttl=64 time=142 ms
> 64 bytes from 192.168.66.1: icmp_seq=282 ttl=64 time=5001 ms
> 64 bytes from 192.168.66.1: icmp_seq=283 ttl=64 time=4001 ms
> 64 bytes from 192.168.66.1: icmp_seq=284 ttl=64 time=3002 ms
> 64 bytes from 192.168.66.1: icmp_seq=285 ttl=64 time=2002 ms
> 64 bytes from 192.168.66.1: icmp_seq=286 ttl=64 time=1003 ms
> 64 bytes from 192.168.66.1: icmp_seq=287 ttl=64 time=5.03 ms
> 64 bytes from 192.168.66.1: icmp_seq=288 ttl=64 time=3018 ms
> 64 bytes from 192.168.66.1: icmp_seq=289 ttl=64 time=2011 ms
> 64 bytes from 192.168.66.1: icmp_seq=290 ttl=64 time=1003 ms
> 64 bytes from 192.168.66.1: icmp_seq=291 ttl=64 time=3.11 ms
> 64 bytes from 192.168.66.1: icmp_seq=292 ttl=64 time=1007 ms
>
> nm-tool says this signal is much stronger and still says there are no other
> visible access points.
>
>       Wireless Access Points (* = current AP)
>     FishNet:         Infra, D6:CA:6D:7A:BF:37, Freq 2447 MHz, Rate 54 Mb/s,
> Strength 75
>     Busklandia:      Infra, D6:CA:6D:7A:BF:39, Freq 2447 MHz, Rate 54 Mb/s,
> Strength 54 WPA2
>     *Office-C-Band:  Infra, D4:CA:6D:C5:68:29, Freq 5260 MHz, Rate 6 Mb/s,
> Strength 59 WPA2
>
> A frequency scan on the Mikrotik  5 GHz both will show there is nothing to
> be seen.
>
> Based upon my theory, it would be true that a lot of frames are not
> acknowledged due to "interference".  However, it would be multipath
> interference.  In 802.11x multipath should not be a problem unless the
> reflection is from a very distant object.
>
> So, although application of your suggested cure SHOULD HELP, it would be
> correcting a symptom for something which is not caused by weak signal.
>
> I would appreciate any comment you have on this, as I suspect you know a lot
> more than I.
>
> Later today I will attempt to apply your suggested fix.
>
> Thanks
>
>
>
>
>
>
>
>
>
>
>
>
>
> On 25/10/2014 18:10, Emmanuel Grumbach wrote:
>>
>> On Fri, Oct 24, 2014 at 10:05 PM, jeremy lansman
>> <jeremy.lansman@gmail.com> wrote:
>>>
>>> Hi.
>>>
>>> I beg your pardon for asking a newbe question...but..here goes anyway.
>>>
>>> My problem is with an Intel Advanced 6230.  I have noted over the year +
>>> I
>>> have used it under Ubuntu that it seems to have a problem when I move the
>>> laptop.  This is consistent with a channel estimation (tap equalizer)
>>> issue
>>> under COFDM modulation.
>>> No, I do not know about wi-fi, and I do not relish digging into driver
>>> stuff.  But I do know digital RF in general.
>>> If it is going to take more hoursout of my life , maybe I should buy an
>>> external wi-fi for the lap top and put up with the resultant klutz.
>>
>> Please try this:
>>
>>
>> https://git.kernel.org/cgit/linux/kernel/git/iwlwifi/iwlwifi-fixes.git/commit/?id=a0855054e59b0c5b2b00237fdb5147f7bcc18efb
>>
>> It is on its way upstream.
>>
>>> This is ping to my AP after I move about:
>>> 64 bytes from 10.5.50.1: icmp_seq=509 ttl=64 time=1057 ms
>>> 64 bytes from 10.5.50.1: icmp_seq=510 ttl=64 time=5382 ms
>>> 64 bytes from 10.5.50.1: icmp_seq=511 ttl=64 time=4386 ms
>>> 64 bytes from 10.5.50.1: icmp_seq=512 ttl=64 time=3383 ms
>>> 64 bytes from 10.5.50.1: icmp_seq=513 ttl=64 time=2376 ms
>>> 64 bytes from 10.5.50.1: icmp_seq=514 ttl=64 time=1438 ms
>>> 64 bytes from 10.5.50.1: icmp_seq=515 ttl=64 time=433 ms
>>> 64 bytes from 10.5.50.1: icmp_seq=516 ttl=64 time=823 ms
>>> 64 bytes from 10.5.50.1: icmp_seq=517 ttl=64 time=1533 ms
>>>
>>>
>>> This is if I sit still a while:
>>> 64 bytes from 10.5.50.1: icmp_seq=583 ttl=64 time=1.18 ms
>>> 64 bytes from 10.5.50.1: icmp_seq=584 ttl=64 time=1.79 ms
>>> 64 bytes from 10.5.50.1: icmp_seq=585 ttl=64 time=0.871 ms
>>> 64 bytes from 10.5.50.1: icmp_seq=586 ttl=64 time=2.96 ms
>>> 64 bytes from 10.5.50.1: icmp_seq=587 ttl=64 time=1.28 ms
>>> 64 bytes from 10.5.50.1: icmp_seq=588 ttl=64 time=1.57 ms
>>> 64 bytes from 10.5.50.1: icmp_seq=589 ttl=64 time=1.03 ms
>>>
>>> WIFI worked after I installed Unbuntu Trusty, but an update seems to have
>>> broken it, sending performance back to what it was under 12.04.
>>>
>>> So.. do you think it might be a simple fix related to channel estimation?
>>>
>>> Thank you.
>>>
>>>
>>>
>>>
>>>
>>>
>>> --
>>> Jeremy Lansman
>>> New York City USA, +1 347 696 0120
>>> Western Cape RSA, +27 21 300 2105
>>> Anchorage AK USA,+1 907 339 3800
>>> Skype Lansmankyes
>>> Fax 27862460713
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
>>> in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Jeremy Lansman
> New York City USA, +1 347 696 0120
> Western Cape RSA, +27 21 300 2105
> Anchorage AK USA,+1 907 339 3800
> Skype Lansmankyes
> Fax 27862460713
>
