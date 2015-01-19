Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:33400 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbbASAfX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2015 19:35:23 -0500
Received: by mail-ie0-f176.google.com with SMTP id rd18so1632517iec.7
        for <linux-wireless@vger.kernel.org>; Sun, 18 Jan 2015 16:35:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54B69807.9030906@rempel-privat.de>
References: <CA+A7n+jFWWs-U2DapExRqYgK=e2kGowPzFHJPh72DRwzBmVggg@mail.gmail.com>
	<54991B32.2010105@rempel-privat.de>
	<CA+A7n+hbr2ctPkSta9-MWT1opAT2hCB9jYHvFu7N3C_ZvxXSzw@mail.gmail.com>
	<5499A391.2060705@rempel-privat.de>
	<CA+A7n+iHKBxy3qfjzrnN7GdZhJ-WwoDdi6hjw8RSaDs8TBznvw@mail.gmail.com>
	<549E6C1A.7010805@rempel-privat.de>
	<CA+A7n+gP6h1HT5F7oDY-SDrrAAjbtTHAtY0683Fe7QdVb7byfQ@mail.gmail.com>
	<CA+A7n+jQQNWk2CqoS9QQFODRsi8k4asjWE=5_q681E6PTiQM+A@mail.gmail.com>
	<54B69807.9030906@rempel-privat.de>
Date: Sun, 18 Jan 2015 19:35:23 -0500
Message-ID: <CA+A7n+gzarweW+ENOfx+QmCGHy+0Vu6qzPM70cPMxe5FTMwCUw@mail.gmail.com> (sfid-20150119_013607_601013_983066F9)
Subject: Re: bug report for ath9k_htc driver
From: Jeremy Audet <ichimonji10@gmail.com>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: linux-wireless@vger.kernel.org, Adrian Chadd <adrian@freebsd.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gaaaaah! Damn it, gmail. I'm sending this email again. The first copy
of this email was rejected by the ML's spam filter, due to the
presence of an HTML part. I'm sorry for spamming y'all.

> Looks like with the hub it can work at least some hours. Correct?

There was an ~18 hour timespan between when the device was physically
plugged in and when freaky error messages were dumped to the kernel
log, so that's good. However, it's worth noting the device wasn't
really "available" that entire time. The kernel log shows that the
device appears to be physically disconnected and reconnected five or
six times in that timespan. (The device remained physically
untouched.) The device is set up as a high-speed USB device again
after each disconnect, which is good, but those disconnects shouldn't
happen in the first place.

I'm doing as you've suggested:

1. Start collecting log messages with `journalctl -k --follow -n 0 >
mylogfile.txt`
2. Plug in USB hub.
3. Plug in TL-WN722N.
4. Execute `sudo bash -c 'echo none > /sys/class/leds/ath9k_htc-phy11/trigger'`
5. `sudo ip link set dev wlp0s19f2u4u2 up`
6. Wait.

I'm currently on step six. I'll post an update when appropriate.

—Jeremy 'Ichimonji10' Audet
