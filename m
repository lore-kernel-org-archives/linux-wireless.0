Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34073 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464Ab1DROGH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 10:06:07 -0400
Received: by qwk3 with SMTP id 3so2424271qwk.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 07:06:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=37Qv6tf5FH4VP=FrrFU=V7UhbNQ@mail.gmail.com>
References: <201104181526.01722.IvDoorn@gmail.com>
	<201104181533.42494.IvDoorn@gmail.com>
	<201104181534.02553.IvDoorn@gmail.com>
	<201104181534.23133.IvDoorn@gmail.com>
	<BANLkTi=37Qv6tf5FH4VP=FrrFU=V7UhbNQ@mail.gmail.com>
Date: Mon, 18 Apr 2011 16:06:05 +0200
Message-ID: <BANLkTimOsO1RSO-+n97a0WiQR__f_sgcUQ@mail.gmail.com>
Subject: Re: [PATCH 21/23] rt2x00: Optimize register access in rt2800usb
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>> All register reads/writes in rt2800usb were previously done with
>> rt2800_register_read/rt2800_register_write. These however indirectly
>> call rt2x00usb_register_read/rt2x00usb_register_write which adds an
>> additional overhead of at least one call and several move instructions
>> to each register access.
>>
>> Replacing the calls to rt2800_register_read/rt2800_register_write with
>> direct calls to rt2x00usb_register_read/rt2x00usb_register_write gets
>> rid of quite a number of instructions in the drivers hotpaths (IRQ
>> handling and txdone handling).
>>
>> For consistency replace all references to rt2800_register_read/write
>> with the rt2x00usb_register_read/write variants.
>
> This way you loose abstraction of writes/reads for usb vs. pci. And
> you still can not optimize rt2800lib code which is shared between usb
> and pci.

Well the rt2800lib code is not changed by this (or patch 20 of this series).

> Wouldn't this be better to create two pointers in struct rt2x00_dev.
> One for writing function and one for reading function? Am I right
> thinking calling functions by pointers is quite fast? Or is this still
> noticeably slower than using proper functions directly?

We already have the pointer inside struct rt2x00_dev which references
the register access functions for rt2800pci/usb. These pointers are used
by rt2800lib to access the common registers. What this patch does, is
optimize the case where we exactly know which function we need, because
we are in the actual driver.

As for the performance, I'll let Helmut comment on that as he created patch 20,
which introduced this change to rt2800pci. :)

Ivo
