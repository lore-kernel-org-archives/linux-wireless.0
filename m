Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f52.google.com ([209.85.212.52]:59798 "EHLO
	mail-vw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287Ab1G1QSL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2011 12:18:11 -0400
Received: by vws16 with SMTP id 16so3095062vws.11
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jul 2011 09:18:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201107232235.16710.chunkeey@googlemail.com>
References: <CAJ8GFOiTwtS7Ddjo8GR3uJMFtkBY+cFuNo3d4mX_4EwOLN9PxQ@mail.gmail.com>
	<201107151622.43671.chunkeey@googlemail.com>
	<CAJ8GFOiQfMvZAHh4ahCx5_ovqh4_83+a3QADVuNVRohaKyAR6A@mail.gmail.com>
	<201107232235.16710.chunkeey@googlemail.com>
Date: Thu, 28 Jul 2011 11:18:09 -0500
Message-ID: <CAJ8GFOg4FL2vkF5q2Hc1GZyTk0+cfX4nnEOovFcvXiL0nZLO_w@mail.gmail.com> (sfid-20110728_181816_526644_D8FDE5A9)
Subject: Re: carl9170: Beacons at lower Tx power than data frames?
From: Harshal Chhaya <harshal@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org, Sujith <m.sujith@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 23, 2011 at 3:35 PM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> On Saturday 23 July 2011 21:22:35 Harshal Chhaya wrote:
>> On Fri, Jul 15, 2011 at 9:22 AM, Christian Lamparter
>> <chunkeey@googlemail.com> wrote:
>> > On Thursday 14 July 2011 21:37:29 Harshal Chhaya wrote:
>> >> I am working on an AP design that uses a TI-OMAP3 host processor with
>> >> an Atheros AR9170 + AR9101 WLAN chipset. We are currently using
>> >> carl9170 version 1.9.2 and carl9170 firmware version 1.9.4.
>> > One question: have you considered ath9k_htc? I would certainly recommend
>> > it over any ar9170 device.
>>
>> I was under the impression that AP mode support is better in carl9170
>> than in ath9k_htc. I had considered using AR9271 (which is a more
>> recent chipset than the AR9170) but decided against it based on my
>> understanding (which is based on the info on the wiki pages).
> Interesting... Sujith, can you please take a look at the wiki if ath9k_htc's AP/P2P
> infos are still up to date?

Sujith, Christian,

On the wiki page for carl9170, the first item in the "not working yet" list is:
* Power Save Mode, It's implemented but buggy

Is this still the case?

I am seeing clients disconnect after a few seconds when I enable power
saving on the clients. I can send more details if needed.


>> If AR9271 (and ath9k_htc) are more stable and preferable to the AR9170
>> w/ carl9170, please let me know.
> AR9271 recevied a lot more testing, so it's ought to perform better.
>
>> Also, to clarify: my application is a wireless network that needs to
>> support 60-70 802.11g clients connecting to the AP using WPA2-PEAP.
>> All of the clients are battery powered and use the power save
>> mechanisms of 802.11.
> 60-70 clients is a lot. This would rule out ath9k_htc since the firmwares
> only supports 7/8 stations at a time and I think that's a reasonable limit
> for any wireless network. Also, with so many stations the hardware crypto
> will not have enough space to store all station keys and has to switch to
> software de- and encryption.
>
>> Do you see any issues using AR9170 and carl9170 in this scenario?
> Sorry, but I've no data about this scenario. However some time ago
> Ben <greearb@candelatech.com> played around 128 stations on a ath9k
> network. But I don't know if he tested any USB solutions at that time.
>
>> Also, I am running openWRT on an TI-OMAP3 processor @ 600 MHz.
> Any word about the USB hcd? Does it support sending unaligned data dma,
> or is it necessary to align all buffer addresses to a 4-byte boundary?
>
>> [...]
>> Here is what I have tried so far:
>>
>> 30 802.11g clients
>>
>> open mode + power save - no problems, can send data to all 30 for hrs
>> wpa2 + disable power save - no problems, can send data to all 30 for hrs
>> wpa2 + enable power save - clients connect but then randomly
>> disconnect every few seconds.
> Is this with or without the hardware crypto enabled? Usually it's enabled by
> default. But in your case I would give it a try to go without one. Just load
> the module with:
>
> nohwcrypt=1
>
> this will help to rule out any hw limitations in this regard.

Thanks for this suggestion. With h/w crypto enabled, I was limited to
32 clients. With 'nohwcrypt=1', I can connect up to 50 clients
(haven't tried more).

However - I am curious about the limit of 32. The chip itself supports
keys for up to 64 users (i.e. a total of 128 keys). I didn't see any
obvious pieces of the carl9170 code that limited this number to 32.

I first thought that the 'u64 usedkeys;' field in the ar9170 struct
(carl9170.h) limited me to 32 users (each user took up two bits - one
for tx, one for rx). But that doesn't seem to be the case.
Any ideas why I couldn't go beyond 32 when I used h/w encryption?

Thanks,
- Harshal


> Regards,
>        Chr
