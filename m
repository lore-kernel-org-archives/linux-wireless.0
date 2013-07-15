Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:50167 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754547Ab3GOJGb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jul 2013 05:06:31 -0400
Message-ID: <51E3BB93.2090000@openwrt.org> (sfid-20130715_110648_962561_8E1A0BB5)
Date: Mon, 15 Jul 2013 11:06:27 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Krzysztof Mazur <krzysiek@podlesie.net>
CC: Sedat Dilek <sedat.dilek@gmail.com>, peizhao.research@gmail.com,
	linux-wireless@vger.kernel.org
Subject: Re: kernel panic on 3.10.0-rc7
References: <51D127E4.2080803@gmail.com> <CA+icZUUQHySKu=qEW3xfheg3DSMuvgB7Dp5PzVGOaiziAPTa5g@mail.gmail.com> <20130715085239.GA31630@shrek.podlesie.net>
In-Reply-To: <20130715085239.GA31630@shrek.podlesie.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-07-15 10:52 AM, Krzysztof Mazur wrote:
> On Mon, Jul 01, 2013 at 09:37:19AM +0200, Sedat Dilek wrote:
>> On Mon, Jul 1, 2013 at 8:55 AM, Peizhao Hu <peizhao.research@gmail.com> wrote:
>> > Hi,
>> >
>> > Is there anyone has the same problem with me? I have a cm9 radio card with
>> > the node.
>> >
>> > The kernel compiled and booted alright, but crashed short after I set it up
>> > in the ad hoc mode. From the debug message output, it looks like something
>> > wrong with the rate control mechanism when it is trying to the rate
>> > (minstreal_get_rate function in this case).
>> >
>> > Is this a bug?
>> >
>> > Kernel version
>> > 3.10.0-rc7
>> >
>> 
>> Please, always add your kernel-config and some outputs like dmesg and
>> lspci/lsusb for better understanding.
>> 2nd, try v3.10 (released a few hours ago)... There were wireless
>> patches pushed after v3.10-rc7.
>> Then report again.
>> 
> 
> I have the same problem. I'm using:
> 
> 02:04.0 Network controller: Broadcom Corporation BCM4318 [AirForce One 54g] 802.11g Wireless LAN Controller (rev 02)
> 	Subsystem: Hewlett-Packard Company Broadcom 802.11b/g WLAN
> 	Flags: bus master, fast devsel, latency 64, IRQ 21
> 	Memory at d0000000 (32-bit, non-prefetchable) [size=8K]
> 	Kernel driver in use: b43-pci-bridge
> 
> with b43 driver and I can easily trigger similar Oops with:
> # ip link set wlan0 up
> # iwlist scan
> 
> The bug is introduced by commit 06d961a8e210035bff7e82f466107f9ab4a8fd94
> ("mac80211/minstrel: use the new rate control API").
> The v3.9 is ok and the v3.11-rc1 is still bad. I haven't checked
> wireless tree yet.
> 
> Wireless related part of my .config:
> [...]
> CONFIG_WIRELESS=y
> CONFIG_WEXT_CORE=y
> CONFIG_WEXT_PROC=y
> CONFIG_CFG80211=y
> CONFIG_CFG80211_DEFAULT_PS=y
> CONFIG_CFG80211_WEXT=y
> CONFIG_MAC80211=y
> CONFIG_MAC80211_HAS_RC=y
> CONFIG_MAC80211_RC_MINSTREL=y
> CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
> CONFIG_MAC80211_RC_DEFAULT="minstrel"
> CONFIG_RFKILL=y
> CONFIG_RFKILL_INPUT=y
> [...]
> CONFIG_WLAN=y
> CONFIG_B43=y
> CONFIG_B43_SSB=y
> CONFIG_B43_PCI_AUTOSELECT=y
> CONFIG_B43_PCICORE_AUTOSELECT=y
> CONFIG_B43_PIO=y
> CONFIG_B43_PHY_LP=y
> 
> Krzysiek
Please post the actual message output. Saying "it looks like something
wrong with the rate control mechanism" doesn't give me anything useful
to work with.

- Felix
