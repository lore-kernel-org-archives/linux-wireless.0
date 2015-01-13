Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:41648 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbbAMWq5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2015 17:46:57 -0500
Received: by mail-ig0-f181.google.com with SMTP id r2so4094967igi.2
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jan 2015 14:46:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+A7n+gP6h1HT5F7oDY-SDrrAAjbtTHAtY0683Fe7QdVb7byfQ@mail.gmail.com>
References: <CA+A7n+jFWWs-U2DapExRqYgK=e2kGowPzFHJPh72DRwzBmVggg@mail.gmail.com>
	<54991B32.2010105@rempel-privat.de>
	<CA+A7n+hbr2ctPkSta9-MWT1opAT2hCB9jYHvFu7N3C_ZvxXSzw@mail.gmail.com>
	<5499A391.2060705@rempel-privat.de>
	<CA+A7n+iHKBxy3qfjzrnN7GdZhJ-WwoDdi6hjw8RSaDs8TBznvw@mail.gmail.com>
	<549E6C1A.7010805@rempel-privat.de>
	<CA+A7n+gP6h1HT5F7oDY-SDrrAAjbtTHAtY0683Fe7QdVb7byfQ@mail.gmail.com>
Date: Tue, 13 Jan 2015 17:46:56 -0500
Message-ID: <CA+A7n+jQQNWk2CqoS9QQFODRsi8k4asjWE=5_q681E6PTiQM+A@mail.gmail.com> (sfid-20150113_234701_500766_7AD9935B)
Subject: Re: bug report for ath9k_htc driver
From: Jeremy Audet <ichimonji10@gmail.com>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: linux-wireless@vger.kernel.org, Adrian Chadd <adrian@freebsd.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Grr. I'm sending this again. My first email was filtered by kernel
mailing list due to the presence of HTML in the message.

Hi again,

The USB hub has arrived. [1] I ran through the same test procedure as last time:

1. Start collecting logging info with `journalctl -k --follow -n 0`.
2. Plug in the hub, if appropriate. Plug in the TL-WN722N.
3. Bring up the adapter with `ip link set dev $device up`.
4. Wait for an error.

My test system has changed slightly since I last ran this test, so I
made sure to run the test twice: once without a USB hub, and once with
a USB hub. When I ran this test without the USB hub, the kernel
immediately emitted gobs of messages and the TL-WN722N was immediately
demoted to a full-speed device. I didn't even have a chance to bring
up the device with `ip link set dev $device up`. [2] When I ran this
test with a USB hub, the kernel did eventually emit gobs of messages,
but lead-up to that failure did contain some new error messages.

I mentioned that my test system has changed. In particular, I've added
a new PCI wireless adapter to the system. [4] I've also installed some
updates, but it is worth noting that the software listed in my
original email has not changed:

    $ uname -a
    Linux pine 3.17.6-1-ARCH #1 SMP PREEMPT Sun Dec 7 23:43:32 UTC
2014 x86_64 GNU/Linux
    $ ip -V
    ip utility, iproute2-ss141009
    $ netctl --version
    netctl version 1.9

—Jeremy 'Ichimonji10' Audet

[1] http://i.imgur.com/TdlwxIC.jpg
[2] http://www.ichimonji10.name/downloads/2015-01-13-p3-new-nohub.txt
[3] http://www.ichimonji10.name/downloads/2015-01-13-p3-new-hub.txt
[4] Output from lspci -v:
04:05.0 Network controller: Ralink corp. RT3060 Wireless 802.11n 1T/1R
        Subsystem: Edimax Computer Co. Device 7711
        Flags: bus master, slow devsel, latency 32, IRQ 20
        Memory at fe900000 (32-bit, non-prefetchable) [size=64K]
        Capabilities: <access denied>
        Kernel driver in use: rt2800pci
        Kernel modules: rt2800pci
