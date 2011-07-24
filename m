Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:49446 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab1GXEeS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jul 2011 00:34:18 -0400
Message-ID: <4E2BA0C5.9030905@candelatech.com> (sfid-20110724_063435_762185_586809E8)
Date: Sat, 23 Jul 2011 21:34:13 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Harshal Chhaya <harshal@gmail.com>
CC: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, Sujith <m.sujith@gmail.com>
Subject: Re: carl9170: Beacons at lower Tx power than data frames?
References: <CAJ8GFOiTwtS7Ddjo8GR3uJMFtkBY+cFuNo3d4mX_4EwOLN9PxQ@mail.gmail.com>	<201107151622.43671.chunkeey@googlemail.com>	<CAJ8GFOiQfMvZAHh4ahCx5_ovqh4_83+a3QADVuNVRohaKyAR6A@mail.gmail.com>	<201107232235.16710.chunkeey@googlemail.com> <CAJ8GFOiJfJyziNjM60CLmzftD+UczMk72nn8hNoVpBxUoSyrBA@mail.gmail.com>
In-Reply-To: <CAJ8GFOiJfJyziNjM60CLmzftD+UczMk72nn8hNoVpBxUoSyrBA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/23/2011 02:18 PM, Harshal Chhaya wrote:
> On Sat, Jul 23, 2011 at 3:35 PM, Christian Lamparter
> <chunkeey@googlemail.com>  wrote:
>> On Saturday 23 July 2011 21:22:35 Harshal Chhaya wrote:
>>> On Fri, Jul 15, 2011 at 9:22 AM, Christian Lamparter
>>> <chunkeey@googlemail.com>  wrote:
>>>> On Thursday 14 July 2011 21:37:29 Harshal Chhaya wrote:
>>>>> I am working on an AP design that uses a TI-OMAP3 host processor with
>>>>> an Atheros AR9170 + AR9101 WLAN chipset. We are currently using
>>>>> carl9170 version 1.9.2 and carl9170 firmware version 1.9.4.
>>>> One question: have you considered ath9k_htc? I would certainly recommend
>>>> it over any ar9170 device.
>>>
>>> I was under the impression that AP mode support is better in carl9170
>>> than in ath9k_htc. I had considered using AR9271 (which is a more
>>> recent chipset than the AR9170) but decided against it based on my
>>> understanding (which is based on the info on the wiki pages).
>> Interesting... Sujith, can you please take a look at the wiki if ath9k_htc's AP/P2P
>> infos are still up to date?
>
> Thanks for following up on this. I am really interested to know if I
> should switch to using the AR9271 (or some other similar chipset).
>
>>
>>> If AR9271 (and ath9k_htc) are more stable and preferable to the AR9170
>>> w/ carl9170, please let me know.
>> AR9271 recevied a lot more testing, so it's ought to perform better.
>>
>>> Also, to clarify: my application is a wireless network that needs to
>>> support 60-70 802.11g clients connecting to the AP using WPA2-PEAP.
>>> All of the clients are battery powered and use the power save
>>> mechanisms of 802.11.
>> 60-70 clients is a lot. This would rule out ath9k_htc since the firmwares
>> only supports 7/8 stations at a time and I think that's a reasonable limit
>> for any wireless network. Also, with so many stations the hardware crypto
>> will not have enough space to store all station keys and has to switch to
>> software de- and encryption.
>>
>>> Do you see any issues using AR9170 and carl9170 in this scenario?
>> Sorry, but I've no data about this scenario. However some time ago
>> Ben<greearb@candelatech.com>  played around 128 stations on a ath9k
>> network. But I don't know if he tested any USB solutions at that time.
>
> I agree - ~8 clients is a reasonable number for most wireless
> networks. However, I have a specific application where I need to
> support 60-70 clients on a single AP. I will check with Ben on his
> experience. Thanks for his contact info.

We haven't used USB, but we can reliably support 128 stations,
using WPA on AR9380 and the older mini-pci chipsets.  We have hacks
to make wpa_supplicant be much more efficient when using lots
of virtual stations on one machine, but no significant changes
to AP mode.

Also, we are associating 128 virtual stations from a single or
small number of radios.  You may get different behaviour if you
are using 128 real radios.

You can find our hostap repository here:
https://github.com/greearb/hostap-ct

We are trying to get our changes pushed upstream, but it's a slow
process...

The 'can-scan-one' logic requires hacks to the kernel as well, in case
you want to use it.  Our kernel patches are here:
http://dmz2.candelatech.com/git/?p=linux-3.0.dev.y/.git;a=summary

I don't think any of our current kernel wireless patches have a chance at upstream
acceptance, but they are fairly minimal, so the stock 3.0 kernel might
be fine for you.

Our hardware is dual-core Atom systems or better, 1GB+ RAM, etc.  These are fairly powerful,
and we disable power saving by default.  We use software encryption to allow
virtualization.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
