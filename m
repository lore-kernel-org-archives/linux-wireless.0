Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55552 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933298Ab2EWLcv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 May 2012 07:32:51 -0400
Received: by yhmm54 with SMTP id m54so6419617yhm.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 May 2012 04:32:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120522205829.GE28713@yumi.tdiedrich.de>
References: <20120517230400.GB22418@yumi.tdiedrich.de>
	<CAGXE3d-MTZu16cU1wybd6zehGOudKPadknuHm9MG6JDVRKmDag@mail.gmail.com>
	<20120522205829.GE28713@yumi.tdiedrich.de>
Date: Wed, 23 May 2012 13:32:50 +0200
Message-ID: <CAGXE3d-MLFJQ-O8=0ToC3fxx0=eLCi+Kbc-DDf_QaNQ2t42=pQ@mail.gmail.com> (sfid-20120523_133254_883918_85F5BBC3)
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

On Tue, May 22, 2012 at 10:58 PM, Tobias Diedrich
<ranma+openwrt@tdiedrich.de> wrote:
> Helmut Schaa wrote:
>> On Fri, May 18, 2012 at 1:04 AM, Tobias Diedrich
>> <ranma+openwrt@tdiedrich.de> wrote:
>> > rt2800: Initialize max_txpower to MAX_G_TXPOWER and MAX_A_TXPOWER
>> > respectively, similar to how it is already done in rt2[45]00pci.c
>> >
>> > rt2800lib.c doesn't initialize max_power and thus after
>> > http://git.kernel.org/?p=linux/kernel/git/linville/wireless-next.git;a=commitdiff;h=eccc068e8e84c8fe997115629925e0422a98e4de
>> > was applied txpower is limited to 0 for these devices.
>> >
>> > This should be the proper fix compared to the net/wireless/reg.c
>> > hack in http://patchwork.openwrt.org/patch/2165/
>>
>> Btw. Tobias, did this affect the real tx power of the device at all or
>> is this just
>> a cosmetic issue?
>
> Hmm, apparently setting txpower has no effect?
> Is it not implemented in the driver?

It is, but only for devices with correct tx power limit in the eeprom.

> i.e. regardless of "iw (dev wlan0|phy phy0) set txpower fixed (100|2000)"
> I don't see any significant chane in Wifi Analyzer on my Android
> phone.
>
> (The real reason I couldn't connect to the AP at all was a different recent
> change)

So, we can actually drop this patch then?

Helmut
