Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37761 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965826Ab2FBVes (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jun 2012 17:34:48 -0400
Received: by wgbdr13 with SMTP id dr13so2930595wgb.1
        for <linux-wireless@vger.kernel.org>; Sat, 02 Jun 2012 14:34:47 -0700 (PDT)
Message-ID: <4FCA86F5.3070801@gmail.com> (sfid-20120602_233453_372974_3A7E63DA)
Date: Sat, 02 Jun 2012 23:34:45 +0200
From: kuba <kuba.g4@gmail.com>
MIME-Version: 1.0
To: Mohammed Shafi <shafi.wireless@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Slow wifi connection AR9287 with ath9k 3.x kernel
References: <4F569512.4000109@gmail.com> <CAD2nsn0e6zGbquTf7DG4_hM6rr+q0GgYwpDuX+jQyGOHWHrdSg@mail.gmail.com> <CAD2nsn1RZVkv3r7JredsLhuSL_+FAObugyryuThhdaA4ihtFnw@mail.gmail.com>
In-Reply-To: <CAD2nsn1RZVkv3r7JredsLhuSL_+FAObugyryuThhdaA4ihtFnw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 07.03.2012 06:37, Mohammed Shafi pisze:
> On Wed, Mar 7, 2012 at 11:05 AM, Mohammed Shafi
> <shafi.wireless@gmail.com>  wrote:
>> On Wed, Mar 7, 2012 at 4:22 AM, kuba<kuba.g4@gmail.com>  wrote:
>>> Hello,
>> hi,
>>
>>> I have submitted bug on Kernel bug tracker and provide info, but it seems
>>> that no one there is interested in this topic. I discovered that since
>>> 2.6.38 kernel version there is bug in ath9k driver (using AR9287 chipset).
>>> I've posted some additional info at this adress:
>>> https://bugzilla.kernel.org/show_bug.cgi?id=42352
>> please provide as much info as possible, in which mode you are
>> operating, how noisy is the environment, distance between STA and AP.
>> anything specific etc.
>> i just tried  compat-wireless-2012-02-04, distance between STA and AP
>> at least 5ms, a bit of noisy environment, channel 6 HT40 plus, AES
>> ping RTT is good only. i  may be missing something
>>
>>
>>> The last working version is 2.6.37.6.
>> if we are very clear about the working one and non-working doing the
>> following things will make our work very easier
>> lets say 2.6.37.6 is working fine and 2.6.38 is broken for you
>>
>> we can work with our wireless-testing tree kernel
>> git clone git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
>>
>> then please do git tag
>>
>> *git log --pretty=oneline v2.6.37-rc6..v2.6.38 | grep AR9287
>> 07422063d43612762d53fac8b6df213c96f4b1f6 ath9k_hw: Fix calibration for
>> AR9287 devices
>> f7ec8fb4d6f8f3ecb8b11e9e46ece95aa66139cc ath9k_hw: Fix eeprom offset
>> for AR9287 devices (PCI/USB)
>>
>> *even with 3.3-rc5 we got less commits
>>
>> 6321eb0977b011ac61dfca36e7c69b2c4325b104 ath9k_hw: Fix number of GPIO
>> pins for AR9287/9300
>> a7be039d347743c289b7280d5de82abf7bbdf1d8 ath9k: Fix eifs/usec timeout
>> for AR9287 v1.3+
>> 49c99520f3b15300156830904f9ffcf51cb1160e ath9k_hw: Add dump_eeprom
>> support for AR9287
>> 087b6ff682ff62c49c9a36ddfd24fc781367b1d1 ath9k_hw: fix MAC clock rate
>> for AR9287 v1.3+
>> 1df85ecec36ad5da3f0165760704310d6c03f65f ath9k: Fix AR9287 calibration
>> 2d05a0c2b4ac614cb5e0eba75d39a37205d129e8 ath9k_hw: Remove unused code
>> in AR9287 eeprom
>> 81544026e4cecb85a8b727d5f64cb3c8a8cb64a3 ath9k_hw: Fix throughput
>> drops in HT40 mode for AR9287 chips
>> 6d64ab7f9240e3201fde3fd16ce4227bd795d2ab ath9k_htc: Fix LED pin for
>> AR9287 HTC device
>> 07422063d43612762d53fac8b6df213c96f4b1f6 ath9k_hw: Fix calibration for
>> AR9287 devices
>> f7ec8fb4d6f8f3ecb8b11e9e46ece95aa66139cc ath9k_hw: Fix eeprom offset
>> for AR9287 devices (PCI/USB)
>>
>>
>> *git log --pretty=oneline v2.6.37-rc6..v2.6.38 | grep ath9k_hw
>>
>> *git log --pretty=oneline v2.6.37-rc6..v2.6.38 | grep ath9k
>>
>>
> please do try with the latest wireless-testing tree if you can get the
> same problem, also please try to check if this issue occurs with some
> other AP too.
>
>>> I can provide more data if anyone is interested.
>>> Cheers,
>>> Kuba
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>> --
>> thanks,
>> shafi
>
>

Hi,

I didn't have access to my notebook for 3 months, so I can't anwser, sorry.
I have tried kernel 3.3.4 and I can still reproduce this error. This 
issue occurs with all AP, even if my notebook stands close to AP (1-5 
m). I've noticed that wireless card works better with 3.3.4 but there 
are times when connection slows down and looks like this:

--- 192.168.1.1 ping statistics ---
35 packets transmitted, 26 received, 25% packet loss, time 34017ms
rtt min/avg/max/mdev = 0.986/6194.909/9659.450/2844.281 ms, pipe 10

It's a ping to gateway, ping to random website looks even worse. 
Wireless-testing doesn't solve this problem.

lspci -v
03:00.0 Network controller: Atheros Communications Inc. AR9287 Wireless 
Network Adapter (PCI-Express) (rev 01)
         Subsystem: Foxconn International, Inc. Device e034
         Flags: bus master, fast devsel, latency 0, IRQ 17
         Memory at b5100000 (64-bit, non-prefetchable) [size=64K]
         Capabilities: <access denied>
         Kernel driver in use: ath9k

I can provide more data, just tell me what should I paste here.

Cheers,
Kuba

