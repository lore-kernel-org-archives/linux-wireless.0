Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:43070 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab1DRN4O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 09:56:14 -0400
Received: by qyk7 with SMTP id 7so1057371qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 06:56:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201104181534.23133.IvDoorn@gmail.com>
References: <201104181526.01722.IvDoorn@gmail.com>
	<201104181533.42494.IvDoorn@gmail.com>
	<201104181534.02553.IvDoorn@gmail.com>
	<201104181534.23133.IvDoorn@gmail.com>
Date: Mon, 18 Apr 2011 15:56:13 +0200
Message-ID: <BANLkTi=37Qv6tf5FH4VP=FrrFU=V7UhbNQ@mail.gmail.com>
Subject: Re: [PATCH 21/23] rt2x00: Optimize register access in rt2800usb
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Ivo,

I don't develop rt2x00 and I'm not sure about my solution, so of
course decision is up to you, just wanted to suggest you sth.

2011/4/18 Ivo van Doorn <ivdoorn@gmail.com>:
> From: Ivo van Doorn <IvDoorn@gmail.com>
>
> All register reads/writes in rt2800usb were previously done with
> rt2800_register_read/rt2800_register_write. These however indirectly
> call rt2x00usb_register_read/rt2x00usb_register_write which adds an
> additional overhead of at least one call and several move instructions
> to each register access.
>
> Replacing the calls to rt2800_register_read/rt2800_register_write with
> direct calls to rt2x00usb_register_read/rt2x00usb_register_write gets
> rid of quite a number of instructions in the drivers hotpaths (IRQ
> handling and txdone handling).
>
> For consistency replace all references to rt2800_register_read/write
> with the rt2x00usb_register_read/write variants.

This way you loose abstraction of writes/reads for usb vs. pci. And
you still can not optimize rt2800lib code which is shared between usb
and pci.

Wouldn't this be better to create two pointers in struct rt2x00_dev.
One for writing function and one for reading function? Am I right
thinking calling functions by pointers is quite fast? Or is this still
noticeably slower than using proper functions directly?

-- 
Rafał
