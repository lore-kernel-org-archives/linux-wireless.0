Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f193.google.com ([209.85.214.193]:33143 "EHLO
	mail-ob0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbcC0E46 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Mar 2016 00:56:58 -0400
Received: by mail-ob0-f193.google.com with SMTP id do7so7530162obb.0
        for <linux-wireless@vger.kernel.org>; Sat, 26 Mar 2016 21:56:57 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 26 Mar 2016 21:56:56 -0700
Message-ID: <CAArymCm8Yk1hpD37mryE59NMq3YsmEWTJY3+EqviqtEHi8bKpQ@mail.gmail.com> (sfid-20160327_065800_457294_07C36071)
Subject: test suite for ath9k_htc
From: bruce m beach <brucembeach@gmail.com>
To: linux-wireless@vger.kernel.org, linux@rempel-privat.de,
	dave.taht@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Oleksij

>> Suddenly I'm not aware of any low-level test-suite.

>> What do you mean by low-level?

I mean either going in via an out of tree module or through user land via
libusb, in both cases bypassing all the protocol stacks, (the out of tree
module would directly access the driver calls), both of which I have bits and
pieces working. From reading Dave Taht's email and yours I have decided on the
USB approach, the only real change to the firmware that I have in mind (other
that cleaning up the mess) The change being that with the FUSB200 can
be setup to
have multiple interaces. The first interface being the existing one that the
driver currently talks to. The second interface being for debugging and
exaustive testing of the firmware. I've bits and pieces in place and was
working on it until I became totally distracted by the never ending saga of the
hideous nightmare of the duplicate include files which I mostly got under
control, one directory for building the rom stuff and one directory for
building the ram stuff. I currently can access the firmware with USB but I have
to detach the driver. It would be nice to get around that and have the driver
running while you are working.

>> What exactly do you want to test?

Well in general everything. There is no test suite for the firmware. What I
want I will do and will become available but the thought occurs to me: How many
tests can you dream up using the proc or sys filesystems to put in scripts? Me:
I only know one: turn off the led and I stole that one from Oleksij. What about
Dave Taht's suggestion for exercising both the driver and firmware. That Stuff
is way up in the stratosphere for me. I never work at that level. Do you have
an interest? How about you Dave? What we are talking about is the AR9271 chip
which is the basis of all sorts WIFI adapters. It comes in 2 flavours usb and
pci. I have a TP-LINK TL-WN722N so inexpensive that I bought 3 of them and very
common but also lots of other manufacturers that Oleksij knows about. I would
like to know if anybody has ever had one of these transmitting at a sustained
rate of 155 mbs for an hour or so. I'm curious about something.(Other than will
it melt)

By the way this is all about making the firmware tree easier to use.  Both the
kernel driver and the firmware work fine with certain things known to be
nonfunctional at this time.

Bruce
