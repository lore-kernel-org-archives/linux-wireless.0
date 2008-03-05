Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:35773 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1765778AbYCEXNA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 18:13:00 -0500
Message-ID: <47CF28F2.6050509@gmx.at> (sfid-20080305_231328_405485_4CF10539)
Date: Thu, 06 Mar 2008 00:12:50 +0100
From: Franz Apeltauer <franz.apeltauer@gmx.at>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: 2 compile errors: rt2x00firmware.c and mesh.c
References: <47CB3B5E.4020701@gmx.at> <1204504331.3917.31.camel@johannes.berg> <20080303035222.GP28995@ruslug.rutgers.edu>
In-Reply-To: <20080303035222.GP28995@ruslug.rutgers.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez schrieb:
> Forced a new tarball out with new changes applied, would appreciate
> some testing on 2.6.21, 2.6.22. You can get the tarball from the
> usual place:
> http://linuxwireless.org/download/compat-wireless-2.6/compat-wireless-2.6.tar.bz2

Thank you very much!
Now everything compiles fine on 2.6.22.

I cannot send you test results yet. It looks like I have to read some 
more documentation first. For now I can only tell you this:

a) Test on a PC with a Broadcom 4306 rev 03:
- Downloaded and installed the firmware.
- The module b43legacy loads without errors, but nothing else happens.
   ifconfig doesn't show any new interface, like eth0 or wlan0.
# modprobe b43legacy
=> messages: Mar  5 23:14:02 af-nb-3 kernel: [10519.728000] Broadcom 
43xx driver loaded [ Features: PID, Firmware-ID: FW10 ]
=> dmesg: [10519.728000] Broadcom 43xx driver loaded [ Features: PID, 
Firmware-ID: FW10 ]

Maybe this is important: dmesg says "Firmware-ID: FW10", but there is no 
ucode10.fw in /lib/firmware/b43legacy, only 2, 4, 5, 11 (downloaded 
today, as described in the wiki).

# lsmod | grep 43
b43legacy             102040  0
ssb                    36484  1 b43legacy
mac80211              220020  1 b43legacy

# lspci
00:00.0 Host bridge: VIA Technologies, Inc. VT8378 [KM400/A] Chipset 
Host Bridge
00:01.0 PCI bridge: VIA Technologies, Inc. VT8237 PCI Bridge
00:09.0 Network controller: Broadcom Corporation BCM4306 802.11b/g 
Wireless LAN Controller (rev 03)
...


b) Test on a PC with MSI PC54G2 ... RaLink rt2500
You wrote "For now I'll disable rt2x00 in compat-wireless."
So, the result of this test seems to be unimportant (it tried to load 
the old driver).


If you would like to see the output of any test, that I can do for you, 
just let me know.

Greetings,
Franz
