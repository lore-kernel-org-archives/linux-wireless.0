Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f168.google.com ([209.85.220.168]:52755 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757603AbZE0Mqt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2009 08:46:49 -0400
MIME-Version: 1.0
In-Reply-To: <200905271158.57067.florian@openwrt.org>
References: <20090526112157.GA19976@doriath.ww600.siemens.net>
	 <200905271158.57067.florian@openwrt.org>
Date: Wed, 27 May 2009 16:46:47 +0400
Message-ID: <bc64b4640905270546k297ee36o4a11f46136863e2b@mail.gmail.com>
Subject: Re: [RFC][WIP] IEEE 802.15.4 implementation for Linux
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Florian Fainelli <florian@openwrt.org>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	slapin@ossfans.org, maxim.osipov@siemens.com,
	dmitry.baryshkov@siemens.com, oliver.fendt@siemens.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/5/27 Florian Fainelli <florian@openwrt.org>:
> Hi Dmitry,
>
> Le Tuesday 26 May 2009 13:21:57 Dmitry Eremin-Solenikov, vous avez écrit :
>> The project page is available at
>> http://apps.sourceforge.net/trac/linux-zigbee with source code of kernel
>> part available from git at
>> http://zigbee-linux.git.sourceforge.net, mirrored for convenience at
>> git://git.kernel.org/pub/scm/linux/kernel/git/lumag/lowpan.git
>>
>> The source code for userspace utils is available from git at
>> http://linux-zigbee.git.sourceforge.net/
>
> From the project page I understand that you plan on providing a ZigBee stack,
> based on this 802.15.4 stack ? Do you plan on submitting the ZigBee stack
> later on ?

The ZigBee stack currently is in design stage of development. When it will be
more or less "in shape" we will present it to the community.

> Maybe you should mention that this implementation is royalty-free, but that
> commercial products using it should both respect the GPL license and pay a
> ZigBee royalty as per the ZigBee Alliance . That is just for clarification
> since right now it simply does 802.15.4 which is not subject to this royalty
> thing.

We will look into this, thank you for putting our attention on this topic.

>
>>
>> Several comments about our implementation:
>> * As with 802.11 there are two types of devices: the smart ones that
>> implement most parts of the protocol by themselves and more or less dumb
>> ones which simply send and receive what they are told. Currently we do only
>> support the second type of devices (SoftMAC)
>> * The implementation is split between code driving radio, (master, mwpanX
>>   interface: mdev.c), code processing frames according the IEEE 802.15.4
>>   rules (slave wpanX devices) and finally sockets (af_ieee802154.c,
>> dgram.c, raw.c).
>
> This sounds good. Do you also plan on integrating some meshing algorithm on
> top of 802.15.4 ? If so,

Hmmm. IIUC the 802.15.4 doesn't have any knowledge about meshing. It's the
part of higher level protocol. ZigBee part will of course contain some
kind of routing/
meshing algos. If you'd like to implement mesing over raw 802.15.4,
it's up to your
protocol. We plan to provide all hooks necessary for doing this.

>> * We do present two example drivers using our stack. One is purely virtual
>>   one either looping the packets back or connecting several virtual
>> interfaces (the one at fakelb.c), and the driver for the Freescale MC13192
>> evaluation boards (13192-SARD, 13192-EVK) using our custom firmware
>> (currently only available at request, we are working on publishing it). The
>> driver for the Atmel at86rf230/at86rf231 chips will follow in several
>> weeks.
>
> Is the virtual interface just like mac80211_hwsim for 802.11 ?h

More or less.We do not implement the global 'monitor' interface, only separate
radios.  We have a page in the wiki that describes usage of this
virtual device driver:
http://apps.sourceforge.net/trac/linux-zigbee/wiki/GettingStarted

-- 
With best wishes
Dmitry
