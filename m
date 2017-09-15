Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:45031 "EHLO
        mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750879AbdIOIsf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Sep 2017 04:48:35 -0400
Received: by mail-io0-f170.google.com with SMTP id v36so6784440ioi.1
        for <linux-wireless@vger.kernel.org>; Fri, 15 Sep 2017 01:48:35 -0700 (PDT)
MIME-Version: 1.0
From: Ernst Wegner <ernstwegner95@gmail.com>
Date: Fri, 15 Sep 2017 10:48:34 +0200
Message-ID: <CAF11ideB1ButOi1r8dmkbQZzSjmVrO247+pMOuxy60pO+BkuiA@mail.gmail.com> (sfid-20170915_104839_253575_11130D3E)
Subject: What makes USB WiFi so difficult in Linux and may I help out?
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear list!

I recently suffer from attempts to use some USB WiFi sticks to connect
to a wireless network using Linux. I tried that with a number of
distros, but found that there seem to be kind of the same problems all
the way from Linux 2.6.x to 4.x. Most USB WiFi sticks don't work
reliably.

As I am a developer also (and very interested in these things) I would
be willing to help debugging drivers and possibly fix them. But I
don't really know where to start searching. So some hints would be
very welcome.

Currently I try to get this one here to work:

Bus 001 Device 006: ID 148f:5370 Ralink Technology, Corp. RT5370
Wireless Adapter

I am on Debian 9 with a pretty recent kernel:

Linux debian 4.9.0-3-amd64 #1 SMP Debian 4.9.30-2+deb9u3 (2017-08-06)
x86_64 GNU/Linux

I was able to get this stick to work kind of. Actually, it drops the
connection every couple of minutes, without any error messages in
dmesg or syslog, actually. But I was able to reach that state only
after applying some tweaks like disabling hardware encrypt, i.e.

options rt2800usb nohwcrypt=y

and

[device]
wifi.scan-rand-mac-address=no

So any pointers would be welcome.

I am not afraid to dig into the code of the driver and recompile.

I could also possibly add or enable some debugging code so I will get
some more debugging output to see what actually happens when I loose
the connection, i.e. if this is an external event, a special kind of
package, overload, ...

And finally: This isn't the only USB Wifi stick which has serious
problems with Linux. The Internet is full of this including drivers
for some sticks which don't work at all and don't go anywhere for
month. Obviously it's not the sticks to blame, as they all work fine
on Windows. So what's the underlying story here which I am missing?

Regards,
Torsten
