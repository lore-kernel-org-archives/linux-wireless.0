Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34193 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab2AZOF2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 09:05:28 -0500
Received: by bkas6 with SMTP id s6so456560bka.19
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jan 2012 06:05:27 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Brad Bellomo <bvbellomo@gmail.com>
Subject: Re: frustrated by carl9170
Date: Thu, 26 Jan 2012 15:05:13 +0100
Cc: linux-wireless@vger.kernel.org
References: <CALY7HC+gbzBmYJK3qQ0aMip_z6utA9jq2ZU6LtDrWpUOGn03CQ@mail.gmail.com> <201201231915.48430.chunkeey@googlemail.com> <CALY7HCJ_9kh7YYk4YBzVkzK9180vf3H7mun-Gp7eCPNACK8pyA@mail.gmail.com>
In-Reply-To: <CALY7HCJ_9kh7YYk4YBzVkzK9180vf3H7mun-Gp7eCPNACK8pyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201201261505.13271.chunkeey@googlemail.com> (sfid-20120126_150531_736163_B7804824)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please keep the CC.

On Wednesday, January 25, 2012 02:39:38 AM Brad Bellomo wrote:
> There isn't much debug information as I was hoping people would help
> tell me how to debug this, rather than trying to debug it for me via
> e-mail.
Ok, but then were do we start? There's a lot more than just a driver
and a firmware that could be buggy. So, if you want to debug this
all by yourself, then be prepared to be frustrated a whole lot more.

> Does this driver log anything outside what I see as dmesg or
> debugfs?
No, the more interesting stuff is logged by the stack above.
You can take a look what the wpa_supplicant is doing in the
syslog [or wpa_cli] and mac80211/cfg80211 has an event viewer
[iw event] and trace points [needs to be enabled in the
kernel config at compile time of course]

> I don't have a debug directory under my kernel, is there
> something I need to do?
There no directory called debug? Well, then I assume that
the "debug Filesystem" (CONFIG_DEBUG_FS) wasn't enabled at
compile time. I'm afraid you have to enable it yourself
and build a kernel. I hope ARCH Linux has a few good wiki-pages
on the subject because you'll definitely need it.

> Is this driver being actively developed or should I just give
> up and buy new hardware?
I think it is :D.  But seriously, if you want to buy something else
go ahead. There's ath9k_htc, but you may end up having the same
problem [so, I would go for cheap products first].

> If it helps:
> 
> I am using a NETGEAR WNDA3100.
Not really, I have three of those and they are working fine in my
setup. Of course, I'm aware that my testing environment is just "mine"
so I won't even think about claiming that the driver/fw will always
work anytime for anyone anywhere.

> The question about outgoing or incoming or both being stopped is a
> good one, but I don't know how to check this.  I won't be able to ping
> to or from the machine either way.
Well, the debugfs interface exports a few statistics like tx and rx counters.
But you could also setup a monitor interface and wait until it dies.
If you still see incoming frames [e.g.: beacons from the AP] you know that
the device is still able to receive. And if you see ACKs and other responses
directed to your device MAC you know that it also sends alright. 
 
> I have replaced both the firmware and driver many times
> troubleshooting this problem, so I don't know where the current driver
> came from, but believe I am using the driver from the 3.0 kernel and
> firmware 1.9.4.  All other versions that I have tried that load (i.e.
> not mismatched driver/firmware) behave the same.
good to know.
 
> I am unsure about HT20/HT40 - I have not messed with this, so it is
> probably the default.
ar9170usb never supported 11n, so you may want to modprobe the module
with a noht=1 parameter to see if it also misbehaves when 11n is
turned off.

Reagards,
	Chr
