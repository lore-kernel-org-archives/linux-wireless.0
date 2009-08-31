Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from correio.ufra.edu.br ([200.129.150.6]:35918 "EHLO
	correio.ufra.edu.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbZHaQpN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2009 12:45:13 -0400
Received: from localhost (localhost [127.0.0.1])
	by correio.ufra.edu.br (Postfix) with ESMTP id 82F137A498
	for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2009 13:42:21 -0300 (BRT)
Received: from correio.ufra.edu.br ([127.0.0.1])
	by localhost (correio.ufra.edu.br [127.0.0.1]) (amavisd-new, port 10025)
	with LMTP id aK385MbLo999 for <linux-wireless@vger.kernel.org>;
	Mon, 31 Aug 2009 13:42:12 -0300 (BRT)
Received: from [10.10.17.60] (srv2.ufra.edu.br [200.129.150.5])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by correio.ufra.edu.br (Postfix) with ESMTP id 0C8877A492
	for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2009 13:42:12 -0300 (BRT)
Message-ID: <4A9BFCCB.6040808@ufra.edu.br>
Date: Mon, 31 Aug 2009 13:39:39 -0300
From: "Leonardo H. Souza Hamada" <leonardo.hamada@ufra.edu.br>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: zd1211rw on ppc (iBook G4)
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi list,

On linux-2.6.24-gentoo-r3, the zd1211rw driver was working as eth1.

This is a big-endian machine.

On 2.6.30-gentoo-r5, 'ifconfig -a' shows the relevant entries below:

wlan0     Link encap:Ethernet  HWaddr 00:16:01:D0:11:7D 
          BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)

wmaster0  Link encap:UNSPEC  HWaddr
00-16-01-D0-11-7D-10-00-00-00-00-00-00-00-00-00 
          [NO FLAGS]  MTU:0  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)

dmesg command shows:

usb 1-2: new high speed USB device using ehci_hcd and address 3
usb 1-2: New USB device found, idVendor=0411, idProduct=00da
usb 1-2: New USB device strings: Mfr=16, Product=32, SerialNumber=0
usb 1-2: Product: USB2.0 WLAN
usb 1-2: Manufacturer: Buffalo
usb 1-2: configuration #1 chosen from 1 choice
usb 1-2: reset high speed USB device using ehci_hcd and address 3
phy1: Selected rate control algorithm 'minstrel'
zd1211rw 1-2:1.0: phy1
usb 1-2: firmware: requesting zd1211/zd1211b_ub
usb 1-2: firmware: requesting zd1211/zd1211b_uphr
zd1211rw 1-2:1.0: firmware version 4725
zd1211rw 1-2:1.0: zd1211b chip 0411:00da v4810 high 00-16-01 AL2230S_RF
pa0 g--N-
usb 1-2: firmware: requesting zd1211/zd1211b_ub
usb 1-2: firmware: requesting zd1211/zd1211b_uphr
usb 1-2: firmware: requesting zd1211/zd1211b_ub
usb 1-2: firmware: requesting zd1211/zd1211b_uphr
usb 1-2: USB control request for firmware upload failed. Error number -110
usb 1-2: Could not upload firmware code uph. Error number -110
zd1211rw 1-2:1.0: couldn't load firmware. Error number -110

lsusb shows:

Bus 001 Device 003: ID 0411:00da MelCo., Inc. WLI-U2-KG54L
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

Bringing it up:

ifconfig wlan0 up
SIOCSIFFLAGS: Connection timed out

DHCP command:
dhcpcd wlan0
dhcpcd: version 5.0.6 starting
dhcpcd: wlan0: interface not found or invalid

Likely is a issue similar reported previously:
http://marc.info/?l=linux-wireless&m=124906700820860&w=2

Quick peek at the source diffs between previous version reveals some
changes.

Regards,

Leonardo
