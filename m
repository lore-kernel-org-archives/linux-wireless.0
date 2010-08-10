Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38882 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222Ab0HJQyq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Aug 2010 12:54:46 -0400
Received: by pwj7 with SMTP id 7so1834870pwj.19
        for <linux-wireless@vger.kernel.org>; Tue, 10 Aug 2010 09:54:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C55F377.6040404@candelatech.com>
References: <AANLkTi=W=vkgb0gM7ZWsBeE79Fe3iabtKFgu2S7N5uLe@mail.gmail.com>
	<201008011137.49528.florian@openwrt.org> <AANLkTik=t=jeCG7=bgkq3LBwJP9vq7KmFpgDeHngPoq-@mail.gmail.com>
	<4C55F377.6040404@candelatech.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 10 Aug 2010 09:54:26 -0700
Message-ID: <AANLkTinGqWZ8o9L=ePsbgzWtitWAHCt3=g_z6BM7EpjO@mail.gmail.com>
Subject: Re: virtual access poitns (ath5k/mac80211)
To: Ben Greear <greearb@candelatech.com>
Cc: Ryszard <ryszard99@gmail.com>,
	Florian Fainelli <florian@openwrt.org>,
	Patrick McHardy <kaber@trash.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 1, 2010 at 3:21 PM, Ben Greear <greearb@candelatech.com> wrote:
> On 08/01/2010 01:56 PM, Ryszard wrote:
>>
>> Hey Florian,
>>
>> thanks for the help on this! Ben/Patrick, if you rebase the patches
>> for this functionality, i'm more than happy and willing to do userland
>> testing on this to move it along.
>>
>> regs
>>
>> On 1 August 2010 19:37, Florian Fainelli<florian@openwrt.org>  wrote:
>>>
>>> Hi,
>>>
>>> Le Sunday 1 August 2010 03:53:13, Ryszard a écrit :
>>>>
>>>> Hi all,
>>>>
>>>> i'm working on a project that requires i can create multiple access
>>>> points on the one bit of hardware.  After an insane amount of googling
>>>> and reading the lists the closest i've been able to come up with is
>>>> something along the lines of:
>>>> iw dev wlan0 interface add vap0 type __ap
>>>> iw dev wlan0 interface add vap1 type __ap
>>>>
>>>> then using macchanger to assign unique mac addresses.
>>>>
>>>> I've also seen something from March 2009
>>>> (http://lwn.net/Articles/321690/) that hints at the functionality
>>>> available with the ath9k which gave me a bit of hope!
>>>>
>>>> My question is, is it possible to create multiple virtual access
>>>> points with my hardware ( Atheros Communications Inc. AR5413 802.11abg
>>>> ) and the ath5k/mac80211 drivers (or is there some other method to
>>>> achieve what i'm after) ?  i'm not too fussed about different
>>>> channels, but different SSID's and WPA keys are a requirement for the
>>>> project.
>>>
>>> There is support for creating virtual interfaces using iw and ath5k here:
>>> http://www.candelatech.com/oss/vsta.html
>>>
>>> I really wish someone could submit this mainline, unfortunately it is
>>> pretty
>>> hard to isolate the commits in this tree which are implementing virtual
>>> interfaces support.
>>>
>>> Ben, Patrick, could you rebase your patches on top of wireless-testing
>>> and
>>> send them for review/testing?
>
> You would not believe how hard it is to keep up with the wireless tree.
>  Last time,
> by the time we had something stable, upstream had changed too much to merge.

This is why you should not do your development outside of
wireless-testing. If you are doing development on a stable kernel tree
then you will likely run into huge issues. You should do development
on wireless-testing.git, always rebase when John has a new update, and
break your changes out into a small changes as possible. If you follow
these basic rules I believe you will likely have better luck with
keeping your code up to date.

  Luis
