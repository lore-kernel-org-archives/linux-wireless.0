Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:61095 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab3EETue convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 May 2013 15:50:34 -0400
Received: by mail-ob0-f175.google.com with SMTP id wd20so1466798obb.6
        for <linux-wireless@vger.kernel.org>; Sun, 05 May 2013 12:50:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130505192405.0cf4350e@milhouse>
References: <alpine.DEB.2.02.1304231851040.1513@kelly.ryd.net>
	<CACna6rxWPOqQPNUaASaj=v=O+Wjt0okjX4jNwE3tv-=etfATCg@mail.gmail.com>
	<CACna6rwk0akD0x+sWTmjDDoaQqF0Y=NQ58rzqgZH92GCug6CeQ@mail.gmail.com>
	<CACna6ry+F45PhCXahPpJtzu-w+vLE29ksHo9njXfTcfY3Av6LA@mail.gmail.com>
	<20130505192405.0cf4350e@milhouse>
Date: Sun, 5 May 2013 21:50:33 +0200
Message-ID: <CACna6rz+PsN1GyniJL7JZJmb7T6Fnk_g101M8DeePr29LsAXaA@mail.gmail.com> (sfid-20130505_215046_479623_BC013425)
Subject: Re: [PATCH] B43: Handle DMA RX descriptor underrun
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>
Cc: Thommy Jakobsson <thommyj@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	piotras@gmail.com, Larry.Finger@lwfinger.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/5/5 Michael Büsch <m@bues.ch>:
> On Sun, 5 May 2013 18:31:20 +0200
> Rafał Miłecki <zajec5@gmail.com> wrote:
>
>> Still worth considering is my previous e-mail. Why writing (for
>> example) 1 to RXSTOPINDEX doesn't stop firmware from using slot 1?
>
> What makes you think this register does not work?

Take a look at this:

[  327.224976] [DBG] old current:5      new current:6
[  327.224982] [DBG] reading slot 5
[  327.224997] [DBG] writing stop slot 6

In above ring->slot was 5, but IRQ was generated, and we read new
"current" using get_current_rxslot. It appeared to be 6. So we read
packet from slot 5 and then called
ops->set_current_rxslot(ring, 6);
AFAIU hardware shouldn't use slot 6, right? But take a look at what
happens next:

[  327.319582] [DBG] old current:6      new current:7
[  327.319590] [DBG] reading slot 6
[  327.319619] [DBG] writing stop slot 7

Hardware generated IRQ and we get_current_rxslot returned 7. It means
we're allowed to read slots up to 7 (excluding). It other words it
means firmware used slot 6... but 100ms earlier we forbid firmware to
use slot 6!

This is part I don't understand. It looks like firmware ignores what
we set with the ops->set_current_rxslot


> Do you write a 1 to the register, or do you mean "the offset that
> corresponds to slot 1"?

I mean "the offset that corresponds to slot 1". In code it's:
ops->set_current_rxslot(ring, 1);


>> Can it be because it's "too late"? For example:
>> 1) Firmware writes to slot 0, changes "curr descr" to 1
>> 2) Firmware grabs slot 1
>> 3) Firmware generates IRQ
>> 4) Driver reads slot 0
>> 5) Driver writes RX stop index 1
>
> The stop index is the index that the firmware does _not_ write to.
> If you set it _after_ it already wrote, you clearly are too late (for
> this ring wrapping).

Take a look at above log. First we forbid firmware to use slot 6:
[  327.224997] [DBG] writing stop slot 6
but 100ms later firmware used that slot:
[  327.319582] [DBG] old current:6      new current:7
(it filled slot 6 and bumped value in B43_DMA64_RXSTATUS)

-- 
Rafał
