Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51512 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab1ERNER convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 09:04:17 -0400
Received: by wya21 with SMTP id 21so1161076wya.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 May 2011 06:04:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DD3C0B9.5070400@gmail.com>
References: <BANLkTi=3i6LEYFivGYB0OZDKmjXxeo+yrQ@mail.gmail.com>
	<294183.47547.qm@web161601.mail.bf1.yahoo.com>
	<BANLkTimwBB35HhOBjOq=OyhrVWq9MOZ3tA@mail.gmail.com>
	<4DD3C0B9.5070400@gmail.com>
Date: Wed, 18 May 2011 18:34:15 +0530
Message-ID: <BANLkTinj6CyWPipu0BuZtrug6ajvqedC7Q@mail.gmail.com> (sfid-20110518_150421_109831_D5BF619B)
Subject: Re: rt2x00: rt2800usb causing kernel panic /compat-wireless/
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Walter Goldens <goldenstranger@yahoo.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 18, 2011 at 6:21 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> On 05/18/11 14:41, Mohammed Shafi wrote:
>> On Wed, May 18, 2011 at 5:26 PM, Walter Goldens
>> <goldenstranger@yahoo.com> wrote:
>>>>> A very peculiar bug.
>>>>>
>>>>> With compat-wireless from 16.05 a nasty bug started to
>>>> manifest itself. Right around association time, the
>>>> rt2800usb causes kernel panic. The system freezes and the
>>>> Caps Lock and Num Lock leds on the keyboard begin to flash.
>>>>
>>>> also ath9k, iwlagn.
>>>>
>>>>>
>>>>> Unfortunately there are no recoverable traces after
>>>> the system failure to aid this bug report or to indicate its
>>>> origin.
>>>>>
>>>>> I believe it may somehow be related to Ubuntu's
>>>> network-manager. If I turn off the network-manager service,
>>>> I can go into monitor mode for example, but if
>>>> network-manager is running and I plug my USB dongle, it
>>>> starts to associate, a second or two later the system is in
>>>> complete meltdown.
>>>>
>>>> same thing, monitor mode worked perfectly fine.
>>>>
>>>>>
>>>>> Nothing concrete, but a hunch is telling me this has
>>>> something to do with the association mechanism of the
>>>> rt2800usb. Compat-wireless from few days back exhibits no
>>>> such foul play.
>>>>
>>>> yes just right at the association complete freeze.
>>>>
>>>
>>> That's strange. I wonder what's the connection with this bug and network-manager. Because when I manually tried to associate, dmesg reported the association attempt timed out.
>>
>> no even when we use iw dev connect command we can see the panic.
>
> Yeah, I've seen this freeze as well using one of the later compat-wireless packages using just iw and wpa_supplicant to bring up the card. This is on all sorts of rt2x00 supported devices.
>
> However, I don't believe this to be an rt2x00-specific bug, as exactly the same rt2x00 sources inside a compat-wireless-2.6.39rc7 package do not produce the freeze.
>
>> some expert suspected that there is a chance of kfree_rcu in
>> compat-wireless may have caused the problem
>>
>
> That's where my suspicion is as well, but I didn't have the time to further investigate. Since my focus was on rt2x00 I used the compat-wireless-2.6.39rc7 package to test my patches. I only did a quick check, and the kfree_rcu compatibility fix that was done in compat-wireless did seem to match the kfree_rcu code is present in linux-next, but maybe there is an odd side-effect.

I could not exactly remember this panic came just after kfree_rcu backported..

>
> ---
> Gertjan
>



-- 
shafi
