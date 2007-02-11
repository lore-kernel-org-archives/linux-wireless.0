Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:36960 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932805AbXBKM6h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Feb 2007 07:58:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH] bcm43xx: Fix loss of association after resume
Date: Sun, 11 Feb 2007 13:56:11 +0100
Cc: bcm43xx-dev@lists.berlios.de, Michael Buesch <mb@bu3sch.de>,
	wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
References: <45cc9ebb.+9O/IXvs/C9RyFnk%Larry.Finger@lwfinger.net> <200702101811.37355.rjw@sisk.pl> <45CE2C2F.8070502@lwfinger.net>
In-Reply-To: <45CE2C2F.8070502@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702111356.12206.rjw@sisk.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday, 10 February 2007 21:33, Larry Finger wrote:
> Rafael,
> 
> Rafael J. Wysocki wrote:
> > 
> > I'm running with this patch applied right now, but the association is lost
> > after the resume anyway.  I have to reload bcm43xx to make it associate with
> > the AP again (no big deal).
> 
> 
> Please send me the output of iwconfig and ifconfig after the resume, but before you reload bcm43xx.

albercik:~ # iwconfig
lo        no wireless extensions.

eth0      no wireless extensions.

eth1      IEEE 802.11b/g  ESSID:"DI524"  Nickname:"Broadcom 4311"
          Mode:Managed  Frequency=2.484 GHz  Access Point: Invalid
          Bit Rate=1 Mb/s   Tx-Power=18 dBm
          RTS thr:off   Fragment thr:off
          Encryption key:off
          Link Quality=0/100  Signal level=-256 dBm  Noise level=-256 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

albercik:~ # ifconfig eth1
eth1      Link encap:Ethernet  HWaddr 00:14:A5:BE:95:31
          inet addr:192.168.100.101  Bcast:192.168.100.255  Mask:255.255.255.0
          inet6 addr: fe80::214:a5ff:febe:9531/64 Scope:Link
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:5137 errors:0 dropped:120 overruns:0 frame:0
          TX packets:5703 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:4569090 (4.3 Mb)  TX bytes:156826797 (149.5 Mb)
          Interrupt:18

albercik:~ # ifconfig eth1 down
albercik:~ # ifconfig eth1 up
SIOCSIFFLAGS: No such device

Reloading the driver helps. ;-)

Greetings,
Rafael
