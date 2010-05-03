Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:49820 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932628Ab0ECPNZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 11:13:25 -0400
Received: by bwz19 with SMTP id 19so1366555bwz.21
        for <linux-wireless@vger.kernel.org>; Mon, 03 May 2010 08:13:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201005031624.45409.rain_maker@root-forum.org>
References: <201005031624.45409.rain_maker@root-forum.org>
Date: Mon, 3 May 2010 17:13:24 +0200
Message-ID: <v2wa32f33a41005030813m36cbea0blf3963369a934cdac@mail.gmail.com>
Subject: Re: [PATCH] rt2x00: remove USB-ID 148f:2573 from rt2500usb driver
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: "rain_maker@root-forum.org" <rain_maker@root-forum.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/3/10, rain_maker@root-forum.org <rain_maker@root-forum.org> wrote:
> The drivers rt2500usb and rt73usb both contain the usb id 148f:2573 while
> only
> the latter is suitable for devices with that id.
>
> As a consequence, both drivers will be loaded and system log shows messages
> like "rt2500usb_init_eeprom: Error - Invalid RT chipset detected".
>
> If you use the above search term, you will find more than 1500 hits with a
> well known search engine, confirming that rt2500usb is always the wrong
> driver for devices with usb id 148f:2573 and quite often as a side effect
> confusion arose about this -non fatal but misleading- error message in the
> respective bug reports or threads.
>
> This trivial patch removes the id 148f:2573 from rt2500usb driver.
>
> Signed-off-by:  Axel Koellhofer <rain_maker@root-forum.org>

NACK

The ID is confusing indeed, but unfortunately we can't remove this ID,
since in the early days people did report they had to use the rt2500usb driver
for these devices. So the majority of devices with this ID is indeed
rt73usb, but
not for all.

Ivo
