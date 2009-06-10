Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:50339 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbZFJDSI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 23:18:08 -0400
Received: by bwz9 with SMTP id 9so431506bwz.37
        for <linux-wireless@vger.kernel.org>; Tue, 09 Jun 2009 20:18:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <69e28c910906090426l4c383665rdc4bffc501085661@mail.gmail.com>
References: <f76a32050906081007q19e9361w8c1fad6fc73c47e7@mail.gmail.com>
	 <f76a32050906081011o589474f2geba321c58c0872c2@mail.gmail.com>
	 <3ace41890906081659o23cb9ee1sd82ca4fc28a3793d@mail.gmail.com>
	 <69e28c910906090426l4c383665rdc4bffc501085661@mail.gmail.com>
Date: Wed, 10 Jun 2009 04:18:09 +0100
Message-ID: <3ace41890906092018o76b0ee62n91819779a8ccd6db@mail.gmail.com>
Subject: Re: Testing AP mode with WLAN-USB-Stick: How to obtain?
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: Stefan Steuerwald <salsasepp@googlemail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/6/9 Gábor Stefanik <netrolller.3d@gmail.com>:

> This will cause problems for power-saving clients, as the ZD1211 chip
> has no multicast buffering feature, something that must be done in
> hardware even for softmac cards. (Possibly this can be worked around
> in the firmware, but so far, no firmware source code has been released
> for the ZD1211/AR2524, only for the ZD1221/AR9170.)

Can you elaborate a bit on that - e.g. reference to specific specs, or
dicussions archived elsewhere? This has been mentioned a few times - I
am just a bit curious. Granted that:
(1) Zydas zd1211 is cheap (I know how much I paid for it - I bought it
mostly for its price when I knew nothing about wireless devices and
their differences) and is expected to be minimal hardware-wise;
(2) having worked on the vendor driver, ported it forward to current
kernels and fixes a couple of old and new bugs on the way, the
quality/maintainability of the code isn't anywhere close to that of
any active open-source projects with more than say, 5 active
developers;
(3) there are still known bugs - it certainly does *not* work
correctly on 64-bit host, and not likely to work on non-[32-bit-intel]
hosts; and some of its 'if KERNEL_VERSION()' defines are plain
wrong...

But I have been using vendor driver 3.0 for a few weeks in AP mode and
I am as happy with it as I could be, I think; I have
suspended//resumed clients.  It works adequately. I'd like the rw
driver to support AP mode eventually (although I have been told in no
uncertain terms it is not going to happen; maybe only firmware
change). Just for curiosity I might have a crack at the 64-bit host
problem, but I'd like not to spend more effort on the vendor driver.
