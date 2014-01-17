Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f43.google.com ([209.85.216.43]:60000 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbaAQOQr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 09:16:47 -0500
Received: by mail-qa0-f43.google.com with SMTP id o15so3312446qap.2
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jan 2014 06:16:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALtMJEDwkCV_wXiPGecoBG-bnG-2OzNMQB-hLHbV9gVr3hZE-A@mail.gmail.com>
References: <CALtMJEDwkCV_wXiPGecoBG-bnG-2OzNMQB-hLHbV9gVr3hZE-A@mail.gmail.com>
Date: Fri, 17 Jan 2014 15:16:47 +0100
Message-ID: <CALtMJEBuMfTi=nqjC_T8GcJCkfM3M1Q1g6PMH2k+7=XOFkdabA@mail.gmail.com> (sfid-20140117_151651_013232_340B8582)
Subject: Re: mwifiex wowlan not working
From: Andreas Fenkart <afenkart@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

2014/1/10 Andreas Fenkart <afenkart@gmail.com>:
> these fail:
>
> iw phy0 wowlan enable magic-packet
> etherwake -i wlan0 5C:F8:A1:15:1B:0B
> wakeonlan 5C:F8:A1:15:1B:0B

see followup patch, looks like a bug

> wake-on RX packets with TCP destination port 22
> iw phy0 wowlan enable patterns 44+16

me bad here, should be: (mind the extr 0x00 after the offset)
iw phy0 wowlan enable patterns 44+00:16

> <hit random keys in ssh session, established before sleep>
works great! login through ssh, put it to sleep and wake it
up by hitting a random key. all from the same ssh shell. loving it

Also started to play around with ethtool:

http://permalink.gmane.org/gmane.linux.kernel.wireless.general/105122

One thing I noticed, these triggers don't work unless you also
enable a trigger with iw. Any ideas why I need to setup wowlan
via both tools iw and ethtool even if only want ethtool functions?

e.g.

<fresh booted system, wifi connected>
ethttool -s wlan0 wol u
echo mem > /sys/power/state

-> no wakeup on ping request, I see ICMP packets with tcpdump

iw phy0 wowlan enable patterns de:ad:be:ef
ethttool -s wlan0 wol u
echo mem > /sys/power/state

-> wakeup on ping request works

iw phy0 wowlan disable

-> no more wakeup on ping request

iw phy0 wowlan enable patterns de:ad:be:ef

-> works again

iw phy0 wowlan disable
ethttool -s wlan0 wol u

-> doesn't work

iw phy0 wowlan enable patterns de:ad:be:ef

-> works again

Any ideas on that?
