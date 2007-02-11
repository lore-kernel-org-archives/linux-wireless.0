Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:45021
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbXBKNH6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Feb 2007 08:07:58 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] bcm43xx: Fix loss of association after resume
Date: Sun, 11 Feb 2007 14:07:07 +0100
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Larry Finger <larry.finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
References: <45cc9ebb.+9O/IXvs/C9RyFnk%Larry.Finger@lwfinger.net> <45CE2C2F.8070502@lwfinger.net> <200702111356.12206.rjw@sisk.pl>
In-Reply-To: <200702111356.12206.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702111407.08099.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 11 February 2007 13:56, Rafael J. Wysocki wrote:
> On Saturday, 10 February 2007 21:33, Larry Finger wrote:
> > Rafael,
> > 
> > Rafael J. Wysocki wrote:
> > > 
> > > I'm running with this patch applied right now, but the association is lost
> > > after the resume anyway.  I have to reload bcm43xx to make it associate with
> > > the AP again (no big deal).
> > 
> > 
> > Please send me the output of iwconfig and ifconfig after the resume, but before you reload bcm43xx.
> 
> albercik:~ # iwconfig
> lo        no wireless extensions.
> 
> eth0      no wireless extensions.
> 
> eth1      IEEE 802.11b/g  ESSID:"DI524"  Nickname:"Broadcom 4311"
>           Mode:Managed  Frequency=2.484 GHz  Access Point: Invalid
>           Bit Rate=1 Mb/s   Tx-Power=18 dBm
>           RTS thr:off   Fragment thr:off
>           Encryption key:off
>           Link Quality=0/100  Signal level=-256 dBm  Noise level=-256 dBm
>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
> 
> albercik:~ # ifconfig eth1
> eth1      Link encap:Ethernet  HWaddr 00:14:A5:BE:95:31
>           inet addr:192.168.100.101  Bcast:192.168.100.255  Mask:255.255.255.0
>           inet6 addr: fe80::214:a5ff:febe:9531/64 Scope:Link
>           UP BROADCAST MULTICAST  MTU:1500  Metric:1
>           RX packets:5137 errors:0 dropped:120 overruns:0 frame:0
>           TX packets:5703 errors:0 dropped:0 overruns:0 carrier:0
>           collisions:0 txqueuelen:1000
>           RX bytes:4569090 (4.3 Mb)  TX bytes:156826797 (149.5 Mb)
>           Interrupt:18
> 
> albercik:~ # ifconfig eth1 down
> albercik:~ # ifconfig eth1 up
> SIOCSIFFLAGS: No such device
		^^^^^

I'd like to see dmesg, please.

-- 
Greetings Michael.
