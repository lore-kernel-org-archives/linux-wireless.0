Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:55739 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab0HAU4Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Aug 2010 16:56:16 -0400
Received: by ewy23 with SMTP id 23so1130375ewy.19
        for <linux-wireless@vger.kernel.org>; Sun, 01 Aug 2010 13:56:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201008011137.49528.florian@openwrt.org>
References: <AANLkTi=W=vkgb0gM7ZWsBeE79Fe3iabtKFgu2S7N5uLe@mail.gmail.com>
	<201008011137.49528.florian@openwrt.org>
Date: Mon, 2 Aug 2010 06:56:13 +1000
Message-ID: <AANLkTik=t=jeCG7=bgkq3LBwJP9vq7KmFpgDeHngPoq-@mail.gmail.com>
Subject: Re: virtual access poitns (ath5k/mac80211)
From: Ryszard <ryszard99@gmail.com>
To: Florian Fainelli <florian@openwrt.org>
Cc: Patrick McHardy <kaber@trash.net>,
	Ben Greear <greearb@candelatech.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey Florian,

thanks for the help on this! Ben/Patrick, if you rebase the patches
for this functionality, i'm more than happy and willing to do userland
testing on this to move it along.

regs

On 1 August 2010 19:37, Florian Fainelli <florian@openwrt.org> wrote:
> Hi,
>
> Le Sunday 1 August 2010 03:53:13, Ryszard a écrit :
>> Hi all,
>>
>> i'm working on a project that requires i can create multiple access
>> points on the one bit of hardware.  After an insane amount of googling
>> and reading the lists the closest i've been able to come up with is
>> something along the lines of:
>> iw dev wlan0 interface add vap0 type __ap
>> iw dev wlan0 interface add vap1 type __ap
>>
>> then using macchanger to assign unique mac addresses.
>>
>> I've also seen something from March 2009
>> (http://lwn.net/Articles/321690/) that hints at the functionality
>> available with the ath9k which gave me a bit of hope!
>>
>> My question is, is it possible to create multiple virtual access
>> points with my hardware ( Atheros Communications Inc. AR5413 802.11abg
>> ) and the ath5k/mac80211 drivers (or is there some other method to
>> achieve what i'm after) ?  i'm not too fussed about different
>> channels, but different SSID's and WPA keys are a requirement for the
>> project.
>
> There is support for creating virtual interfaces using iw and ath5k here:
> http://www.candelatech.com/oss/vsta.html
>
> I really wish someone could submit this mainline, unfortunately it is pretty
> hard to isolate the commits in this tree which are implementing virtual
> interfaces support.
>
> Ben, Patrick, could you rebase your patches on top of wireless-testing and
> send them for review/testing?
> --
> Florian
>
