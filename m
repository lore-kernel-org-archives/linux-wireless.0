Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:38066 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbaL0EF5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Dec 2014 23:05:57 -0500
Received: by mail-ie0-f178.google.com with SMTP id vy18so8254086iec.23
        for <linux-wireless@vger.kernel.org>; Fri, 26 Dec 2014 20:05:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5499A391.2060705@rempel-privat.de>
References: <CA+A7n+jFWWs-U2DapExRqYgK=e2kGowPzFHJPh72DRwzBmVggg@mail.gmail.com>
	<54991B32.2010105@rempel-privat.de>
	<CA+A7n+hbr2ctPkSta9-MWT1opAT2hCB9jYHvFu7N3C_ZvxXSzw@mail.gmail.com>
	<5499A391.2060705@rempel-privat.de>
Date: Fri, 26 Dec 2014 23:05:56 -0500
Message-ID: <CA+A7n+iHKBxy3qfjzrnN7GdZhJ-WwoDdi6hjw8RSaDs8TBznvw@mail.gmail.com> (sfid-20141227_050603_520422_223ED65C)
Subject: Re: bug report for ath9k_htc driver
From: Jeremy Audet <ichimonji10@gmail.com>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: linux-wireless@vger.kernel.org, Adrian Chadd <adrian@freebsd.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sending this again b/c of a delivery error. [9] Sorry for the possible spam.

Hi again,

When last I wrote, I stated that the issue lay with the USB cradle I'd been
using, and I'd discarded it in favor of plugging the TL-WN722N directly in to
my PC. I also mentioned that I'd gotten a wireless access point up and running
for 30 minutes. Not five minutes after I sent that email, the same error I've
described earlier occurred, and the USB wireless adapter was demoted to
full-speed mode.

This is bothersome, so in an effort to rule out sources of error, I ran a series
of simple tests, all having this structure:

1. Start logging out kernel messages with the `journalctl -k --follow -n 0`
   command.
2. Plug a TP-LINK TL-WN722N wireless adapter directly in to a USB port.
3. Turn on the adapter with the `ip link set dev $device up` command.
4. Wait for an error.
5. Stop collecting logging output. (Send CTRL-C to `journalctl`.)
6. Unplug TL-WN722N.

Here's the purpose of the above:

* It is possible that a specific USB port or ports on my motherboard are flaky.
  To help rule this out, run the test with three different USB ports on my
  motherboard. Two of the ports are built directly in to the back panel of the
  motherboard, and the third connects to header pins on the motherboard.
* It is possible that the specific TL-WN722N I am using is flaky. To help rule
  this out, run the test with a second TL-WN722N. [1, 2]

Notably, I am also using the `htc_9271.fw` firmware file available at
https://github.com/olerem/ath9k-htc-firmware-blob for this test. As a refresher,
here's some other info about my system:

    $ uname -a
    Linux pine 3.17.6-1-ARCH #1 SMP PREEMPT Sun Dec 7 23:43:32 UTC
2014 x86_64 GNU/Linux
    $ ip -V
    ip utility, iproute2-ss141009

And here's some output from `lsusb -v` for the old and new TL-WN722N devices:

* old: http://www.ichimonji10.name/downloads/tl-wn722n-old-lsusb.txt
* new: http://www.ichimonji10.name/downloads/tl-wn722n-lsusb.txt

Here's the test results. Port 1, 2, and 3 are the upper back panel, lower back
panel and header pins on the motherboard, respectively.

* Port 1, old adapter: fail [3]
* Port 1, new adapter: fail [4]
* Port 2, old adapter: fail [5]
* Port 2, new adapter: fail [6]
* Port 3, old adapter: fail [7]
* Port 3, new adapter: fail [8]

[1] I bought a TL-WN722N several years ago, eventually stuck it in the bottom of
    my tool kit and forgot about it until just now. I bought the two TL-WN722Ns
    several years apart, so it is unlikely that the two adapters both suffer
    from e.g. a manufacturing defect. They were bought on 2014-11-10 and
    2012-09-25.
[2] lsusb -v: http://www.ichimonji10.name/downloads/tl-wn722n-old-lsusb.txt
[3] http://www.ichimonji10.name/downloads/2014-12-26-p1-old.txt
[4] http://www.ichimonji10.name/downloads/2014-12-26-p1-new.txt
[5] http://www.ichimonji10.name/downloads/2014-12-26-p2-old.txt
[6] http://www.ichimonji10.name/downloads/2014-12-26-p2-new.txt
[7] http://www.ichimonji10.name/downloads/2014-12-26-p3-old.txt
[8] http://www.ichimonji10.name/downloads/2014-12-26-p3-new.txt
[9] Technical details of permanent failure:
Google tried to deliver your message, but it was rejected by the
server for the recipient domain vger.kernel.org by vger.kernel.org.
[...] The error that the other server returned was: 550 5.7.1
Content-Policy reject msg: The message contains HTML subpart,
therefore we consider it SPAM or Outlook Virus.  TEXT/PLAIN is
accepted.
