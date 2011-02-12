Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web36108.mail.mud.yahoo.com ([66.163.179.222]:41377 "HELO
	web36108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752411Ab1BLSnk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Feb 2011 13:43:40 -0500
Message-ID: <75608.46987.qm@web36108.mail.mud.yahoo.com>
References: <875258.44241.qm@web36104.mail.mud.yahoo.com>
Date: Sat, 12 Feb 2011 10:43:37 -0800 (PST)
From: Noel Milton Vega <nmvega@computingarchitects.com>
Reply-To: Noel Milton Vega <nmvega@ComputingArchitects.Com>
Subject: Re: SOLVED -- Need Linux driver (preferably 64 bit) for "Intel Corporation Centrino Advanced-N 6230 (rev 34)" WiFI & Bluetooth card ...
To: Julian Calaby <julian.calaby@gmail.com>, ozan@pardus.org.tr
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <875258.44241.qm@web36104.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello:

It is working now.

Integrating stable capat-wireless modules into the stock Fedora 14 (64bit)
kernel (2.6.35.10-74.fc14.x86_64) did not resolve the issue, so I turned my 
attention to compiling an entirely new kernel. Note that I only tried 
compat-wireless
version 2.6.35-1 (and none newer), as that was the only one whose compilation 
would
result in an iwlagn.ko (etc.) module being created (... compilations of newer
ones did not).

So after downloading and compiling kernel version 2.6.38-rc4 (kernel.org) (and
manually integrating other necessary subsystems too, like compiling the nVidia
graphics driver while booted to that kernel), I was finally able to get "wlan0"
up via the included "iwlagn.ko (etc)" driver, as confirmed by "ethtool -i 
wlan0".

I do, however, get the following *error* message when performing an
"ifconfig wlan0 up", but I suspect that that is because the hardware switch
(it's actually not a physical switch), might be in the blocked/off mode
when doing so:

    SIOCSIFFLAGS: Operation not possible due to RF-kill

Unless you look at the output of "rfkill list", it's hard to tell what state
that hardware switch in when the indicator LED is off because it only goes on
after two conditions are met: (1) the hardware switch is unblocked, and then
you perform an "ifconfig wlan0 up" (seemingly in that order). So basically I
do a "ifconfig wlan0 up", and if the above error occurs, hit "Fn + F12" to
toggle the RF switch, and then do the "ifconfig wlan0  up" again. That
combination seems to work (it was 4am, so I can't recall all right now).

If someone knows how to, -on boot-, automatically enable/unblock that RF
hardware switch, I'd love to know (probably an entry in modprobe.conf(5) - 
I'll search too).


So everything in this bleeding-edge laptop functions now, and I now can turn
my attention to it's purpose (compute intensive private cloud 
simulations).

Thank you again for your collective help (it was actually guidance in the
technical email exchanges that let to success).

Thanks & Best Regards,
Noel

