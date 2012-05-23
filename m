Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:36418 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756822Ab2EWTau (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 May 2012 15:30:50 -0400
Received: by ghrr11 with SMTP id r11so1441043ghr.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 May 2012 12:30:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120523135514.GF28713@yumi.tdiedrich.de>
References: <20120517230400.GB22418@yumi.tdiedrich.de>
	<CAGXE3d-MTZu16cU1wybd6zehGOudKPadknuHm9MG6JDVRKmDag@mail.gmail.com>
	<20120522205829.GE28713@yumi.tdiedrich.de>
	<CAGXE3d-MLFJQ-O8=0ToC3fxx0=eLCi+Kbc-DDf_QaNQ2t42=pQ@mail.gmail.com>
	<20120523135514.GF28713@yumi.tdiedrich.de>
Date: Wed, 23 May 2012 21:30:49 +0200
Message-ID: <CAGXE3d8oAFhw8SO_i6M8TXhFeqQGc5LJ76-t12xdpCYcQDhSUQ@mail.gmail.com> (sfid-20120523_213053_872773_C840CFAC)
Subject: Re: [PATCH] rt2800: Initialize max_txpower to MAX_G_TXPOWER and
 MAX_A_TXPOWER respectively
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Tobias Diedrich <ranma+openwrt@tdiedrich.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Hong Wu <Hong.Wu@dspg.com>, openwrt-devel@lists.openwrt.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Wed, May 23, 2012 at 3:55 PM, Tobias Diedrich
<ranma+openwrt@tdiedrich.de> wrote:
> Helmut Schaa wrote:
>> On Tue, May 22, 2012 at 10:58 PM, Tobias Diedrich
>> <ranma+openwrt@tdiedrich.de> wrote:
>> > Helmut Schaa wrote:
>> >> On Fri, May 18, 2012 at 1:04 AM, Tobias Diedrich
>> >> <ranma+openwrt@tdiedrich.de> wrote:
>> >> > rt2800: Initialize max_txpower to MAX_G_TXPOWER and MAX_A_TXPOWER
>> >> > respectively, similar to how it is already done in rt2[45]00pci.c
>> >> >
>> >> > rt2800lib.c doesn't initialize max_power and thus after
>> >> > http://git.kernel.org/?p=linux/kernel/git/linville/wireless-next.git;a=commitdiff;h=eccc068e8e84c8fe997115629925e0422a98e4de
>> >> > was applied txpower is limited to 0 for these devices.
>> >> >
>> >> > This should be the proper fix compared to the net/wireless/reg.c
>> >> > hack in http://patchwork.openwrt.org/patch/2165/
>> >>
>> >> Btw. Tobias, did this affect the real tx power of the device at all or
>> >> is this just
>> >> a cosmetic issue?
>> >
>> > Hmm, apparently setting txpower has no effect?
>> > Is it not implemented in the driver?
>>
>> It is, but only for devices with correct tx power limit in the eeprom.
>
> Why?

Please read [1] for a detailed explanation.

> Lowering the tx power should never be an issue, right?

Yes but only on by percentage since we don't know the tx power the
device was calibrated for.

> Or are you saying I'm stuck with 0dBm txpower?

No, your stuck with the tx power the device was calibrated for by the
manufacturer,
and the manufacturer did not intend to allow users to program arbitrary tx power
values (in terms of dBm or mW) into the hw.

So, your device might be calibrated to let's say 18dBm but the device
doesn't provide
this information to the driver at all. Hence, we cannot apply a tx
power of 16dBm to the
device. We could however reduce the real tx power by for example 50%
(= -3dBm) but
still we don't know the resulting discrete value. We only know we
reduced the tx power
by 3dBm.

> That would be an issue by itself.
> Why not use min(hw defaults, regulatory limits) as maximum if there is
> no limit in the eeprom?

See above and [1].

> Do I have to add an eeprom fixup that will insert valid txpower
> limit bytes as an additional step after the eeprom extraction from flash
> to make this work?

If you know the tx power limit your device is calibrated for you could actually
do this. However, I wouldn't suggest to do that ...

Helmut

[1] http://www.spinics.net/lists/linux-wireless/msg90718.html
