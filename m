Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:51613 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbYAMJeO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jan 2008 04:34:14 -0500
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1JDzEJ-0004SL-C9
	for linux-wireless@vger.kernel.org; Sun, 13 Jan 2008 09:34:11 +0000
Received: from port-87-193-186-180.static.qsc.de ([87.193.186.180])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jan 2008 09:34:11 +0000
Received: from thomas by port-87-193-186-180.static.qsc.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jan 2008 09:34:11 +0000
To: linux-wireless@vger.kernel.org
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
Subject: iwl3945 driver is still unusable!
Date: Sun, 13 Jan 2008 10:33:58 +0100
Message-ID: <fmclu6$dvl$1@ger.gmane.org> (sfid-20080113_093420_104529_6831E4D9)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Cc: ipw3945-devel@lists.sourceforge.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some history of this problem can be found here:
http://bughost.org/bugzilla/show_bug.cgi?id=1468

I want to describe my problem here again to get some more people to pay
attention, as Intel doesn't seem to be able to reproduce this problem,
although it is quite easy and I am not the only one who experiences it.

I will start with my setup: I own a Lenovo 3000 N100, which includes a
Core 2 Duo CPU and an Intel 3945ABG Wireless LAN chip. I am working with
Archlinux x86_64 and use wpa_supplicant 0.5.9 (0.5.8 and 0.5.7 in the
past) combined with autowifi, a small tool that starts dhclient
automatically once a wireless connection has been established by
wpa_supplicant.

I am roaming with my Laptop a lot, so I have to switch between networks
often. After I had some problems with the driver over half a year ago, I
 figured out this test case:

- Connect to my own WPA network.
- Tell wpa_supplicant to switch to an open network.
- Switch to another open network or (if none available) back to my WPA
network.

The first network I use after loading the driver always works fine.
After some switching networks (always the second or at most third
network I try to connect to), I don't get DHCP anymore. Sometimes I
still get a DHCPNAK, but after that, there is no response to my
DHCPDISCOVER messages. When apppropriate, I assign a static IP and still
cannot transmit any traffic. However, I can always reconnect to the last
working network (so long-term, the driver works with exactly one network).

One of the debug outputs I generated for the bug report (see above)
suggests that only the first package is transmitted over the link, after
that no data is transmitted at all!

This problem persists even if I
- restart wpa_supplicant
- unload the driver and the mac80211 stack completely and reload them
- do both of the above and then suspend to RAM, then resume later and
try again

This issue is not limited to switching between encrypted and unencrypted
networks. I am pretty sure that if I connect to my WPA network here at
home, go to the university and connect to their WPA network, the issue
persists (however, this is not a practical test case, as there is a 30
minute walk in between).

These are the test cases I did today (I could get similar results with
older kernel versions and drivers):

Linux 2.6.23.13, iwlwifi 1.2.23 from Intel's website:
- Connect to WPA network succeeds
- Connect to an open network succeeds
- Going back to the WPA network: Associates fine, but no DHCP, with
static IP no traffic can be transmitted

Linux 2.6.24-rc7-gd0c4c9d4 (latest git as of today), included iwl3945
version:
- Connect to WPA network succeeds
- Connect to an open network: Associates fine, no DHCP (same network
that I could connect to in the last test).

Linux 2.6.24-rc7-gd0c4c9d4 (latest git as of today), iwlwifi 1.2.23:
- Does not compile!

All these test cases _always_ worked perfectly with the old ipw3945
driver. Unloading the iwl driver and loading the ipw driver always makes
my connection work again. BUT, the ipw3945 driver has been discontinued
and does not compile anymore with 2.6.24 (as iwl3945 is considered a
replacement, which it is obviously not).
All this means, if I update to 2.6.24 (which I want to, due to several
improvements), I have no usable driver for my wireless anymore.

What I need is a solution, meaning either a working iwl3945 version or a
patch to ipw3945 to compile with 2.6.24.

Thanks in advance for any help or comments.

