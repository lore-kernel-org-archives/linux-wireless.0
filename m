Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43664 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab0HAWVz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Aug 2010 18:21:55 -0400
Message-ID: <4C55F377.6040404@candelatech.com>
Date: Sun, 01 Aug 2010 15:21:43 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Ryszard <ryszard99@gmail.com>
CC: Florian Fainelli <florian@openwrt.org>,
	Patrick McHardy <kaber@trash.net>,
	linux-wireless@vger.kernel.org
Subject: Re: virtual access poitns (ath5k/mac80211)
References: <AANLkTi=W=vkgb0gM7ZWsBeE79Fe3iabtKFgu2S7N5uLe@mail.gmail.com>	<201008011137.49528.florian@openwrt.org> <AANLkTik=t=jeCG7=bgkq3LBwJP9vq7KmFpgDeHngPoq-@mail.gmail.com>
In-Reply-To: <AANLkTik=t=jeCG7=bgkq3LBwJP9vq7KmFpgDeHngPoq-@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/01/2010 01:56 PM, Ryszard wrote:
> Hey Florian,
>
> thanks for the help on this! Ben/Patrick, if you rebase the patches
> for this functionality, i'm more than happy and willing to do userland
> testing on this to move it along.
>
> regs
>
> On 1 August 2010 19:37, Florian Fainelli<florian@openwrt.org>  wrote:
>> Hi,
>>
>> Le Sunday 1 August 2010 03:53:13, Ryszard a écrit :
>>> Hi all,
>>>
>>> i'm working on a project that requires i can create multiple access
>>> points on the one bit of hardware.  After an insane amount of googling
>>> and reading the lists the closest i've been able to come up with is
>>> something along the lines of:
>>> iw dev wlan0 interface add vap0 type __ap
>>> iw dev wlan0 interface add vap1 type __ap
>>>
>>> then using macchanger to assign unique mac addresses.
>>>
>>> I've also seen something from March 2009
>>> (http://lwn.net/Articles/321690/) that hints at the functionality
>>> available with the ath9k which gave me a bit of hope!
>>>
>>> My question is, is it possible to create multiple virtual access
>>> points with my hardware ( Atheros Communications Inc. AR5413 802.11abg
>>> ) and the ath5k/mac80211 drivers (or is there some other method to
>>> achieve what i'm after) ?  i'm not too fussed about different
>>> channels, but different SSID's and WPA keys are a requirement for the
>>> project.
>>
>> There is support for creating virtual interfaces using iw and ath5k here:
>> http://www.candelatech.com/oss/vsta.html
>>
>> I really wish someone could submit this mainline, unfortunately it is pretty
>> hard to isolate the commits in this tree which are implementing virtual
>> interfaces support.
>>
>> Ben, Patrick, could you rebase your patches on top of wireless-testing and
>> send them for review/testing?

You would not believe how hard it is to keep up with the wireless tree.  Last time,
by the time we had something stable, upstream had changed too much to merge.

The merge from .31 to .34 was basically not happening, so we are trying to
re-do things from scratch.  I've been busy working on other .34 bugs (and
updating our user-space stuff to work with .34), and haven't heard from
Patrick in a while.

We plan to get this done, but I don't know when.

For what it's worth, our .31 code works pretty well, supporting virtual STA
and APs and deals with multiple STAs trying to all scan at once, etc.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
