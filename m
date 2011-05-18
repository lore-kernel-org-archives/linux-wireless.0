Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:2178 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756959Ab1ERMvI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 08:51:08 -0400
Message-ID: <4DD3C0B9.5070400@gmail.com> (sfid-20110518_145113_233703_3B25A10A)
Date: Wed, 18 May 2011 14:51:05 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Mohammed Shafi <shafi.wireless@gmail.com>,
	Walter Goldens <goldenstranger@yahoo.com>
CC: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: rt2x00: rt2800usb causing kernel panic /compat-wireless/
References: <BANLkTi=3i6LEYFivGYB0OZDKmjXxeo+yrQ@mail.gmail.com> <294183.47547.qm@web161601.mail.bf1.yahoo.com> <BANLkTimwBB35HhOBjOq=OyhrVWq9MOZ3tA@mail.gmail.com>
In-Reply-To: <BANLkTimwBB35HhOBjOq=OyhrVWq9MOZ3tA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/18/11 14:41, Mohammed Shafi wrote:
> On Wed, May 18, 2011 at 5:26 PM, Walter Goldens
> <goldenstranger@yahoo.com> wrote:
>>>> A very peculiar bug.
>>>>
>>>> With compat-wireless from 16.05 a nasty bug started to
>>> manifest itself. Right around association time, the
>>> rt2800usb causes kernel panic. The system freezes and the
>>> Caps Lock and Num Lock leds on the keyboard begin to flash.
>>>
>>> also ath9k, iwlagn.
>>>
>>>>
>>>> Unfortunately there are no recoverable traces after
>>> the system failure to aid this bug report or to indicate its
>>> origin.
>>>>
>>>> I believe it may somehow be related to Ubuntu's
>>> network-manager. If I turn off the network-manager service,
>>> I can go into monitor mode for example, but if
>>> network-manager is running and I plug my USB dongle, it
>>> starts to associate, a second or two later the system is in
>>> complete meltdown.
>>>
>>> same thing, monitor mode worked perfectly fine.
>>>
>>>>
>>>> Nothing concrete, but a hunch is telling me this has
>>> something to do with the association mechanism of the
>>> rt2800usb. Compat-wireless from few days back exhibits no
>>> such foul play.
>>>
>>> yes just right at the association complete freeze.
>>>
>>
>> That's strange. I wonder what's the connection with this bug and network-manager. Because when I manually tried to associate, dmesg reported the association attempt timed out.
> 
> no even when we use iw dev connect command we can see the panic.

Yeah, I've seen this freeze as well using one of the later compat-wireless packages using just iw and wpa_supplicant to bring up the card. This is on all sorts of rt2x00 supported devices.

However, I don't believe this to be an rt2x00-specific bug, as exactly the same rt2x00 sources inside a compat-wireless-2.6.39rc7 package do not produce the freeze.

> some expert suspected that there is a chance of kfree_rcu in
> compat-wireless may have caused the problem
> 

That's where my suspicion is as well, but I didn't have the time to further investigate. Since my focus was on rt2x00 I used the compat-wireless-2.6.39rc7 package to test my patches. I only did a quick check, and the kfree_rcu compatibility fix that was done in compat-wireless did seem to match the kfree_rcu code is present in linux-next, but maybe there is an odd side-effect.

---
Gertjan
