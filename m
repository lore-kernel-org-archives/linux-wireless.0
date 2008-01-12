Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:59451 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762739AbYALLXc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jan 2008 06:23:32 -0500
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1JDeSW-0002vw-EA
	for linux-wireless@vger.kernel.org; Sat, 12 Jan 2008 11:23:28 +0000
Received: from port-87-193-186-180.static.qsc.de ([87.193.186.180])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 12 Jan 2008 11:23:28 +0000
Received: from thomas by port-87-193-186-180.static.qsc.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 12 Jan 2008 11:23:28 +0000
To: linux-wireless@vger.kernel.org
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
Subject: [rt2x00] rt2500pci massive speed problems
Date: Sat, 12 Jan 2008 12:23:21 +0100
Message-ID: <fma7v9$cn7$1@ger.gmane.org> (sfid-20080112_112337_306017_646E6E49)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Similar issues were brought up in the rt2x00 forums in the past:

I have a MSI PC54G2 Wireless NIC:
00:0b.0 Network controller: RaLink RT2500 802.11g Cardbus/mini-PCI (rev 01)
00:0b.0 0280: 1814:0201 (rev 01)

I have tested the speed with different rt2500pci versions and with the
rt2500 legacy driver, using a D-Link DI-524 wireless router in mixed
WPA/WPA2 TKIP/CCMP mode:

Linux 2.6.23.13, rt2x00 from CVS, the last version I got to compile with
2.6.23 (a copy of this source is here:
ftp://ftp.archlinux.org/other/rt2x00-cvs/rt2x00-cvs-20070914.tar.bz2):
The speed is about 100KB/s.

Linux 2.6.24-rc7 (pulled from linux-2.6 git today):
The speed is about 20KB/s, which is obviously _much_ slower than the
older version above.

Linux 2.6.23.13, latest rt2500 legacy release.
Speed is over 1MB/s when downloading from the Internet, 900KB/s when
downloading from another client on the same WLAN, which is a sane result
IMO.

As you can see, the rt2500pci included in 2.6.24 is unusable when it
comes to speed, older versions were partially usable. However, if you
need good speed, the only way is to fall back to the legacy driver, with
the obvious problems (lack of wpa_supplicant support, thus only limited
WPA support).

