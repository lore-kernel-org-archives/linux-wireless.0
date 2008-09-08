Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:45868 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270AbYIHGOP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 02:14:15 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1Kca0q-0004sx-5e
	for linux-wireless@vger.kernel.org; Mon, 08 Sep 2008 06:14:12 +0000
Received: from 77.21.170.83 ([77.21.170.83])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 08 Sep 2008 06:14:12 +0000
Received: from feldmann_markus by 77.21.170.83 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 08 Sep 2008 06:14:12 +0000
To: linux-wireless@vger.kernel.org
From: feldmaus <feldmann_markus@gmx.de>
Subject: Do not get BCM4303 to work
Date: Mon, 08 Sep 2008 08:15:51 +0200
Message-ID: <ga2fra$9q$1@ger.gmane.org> (sfid-20080908_081419_189737_2796EF81)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

i do not get my Wlan Card with BCM4303 Chip to work.

My System is Debian Testing 32-bit with Kernel 2.6.25-2 from Debian,
therefore i am using the Driver b43legacy.

I tried to connect this Wlan Card with my Wireless Printer.
It is a Ad-Hoc Connection with,
SSID=3Dkleopatra
Channel=3D10
Authentification=3Dnon
Encryption=3D128-bit Wep

Here it comes the Outout from <lspci>,
02:02.0 Network controller: Broadcom Corporation BCM4303 802.11b
Wireless LAN Controller (rev 02)
	Subsystem: Hewlett-Packard Company Device 12f3
	Flags: bus master, fast devsel, latency 64, IRQ 17
	Memory at e0104000 (32-bit, non-prefetchable) [size=3D8K]
	Kernel driver in use: b43-pci-bridge
	Kernel modules: ssb


I tried some Howtos, but it didn't work.

<ifconfig> show's the following,
eth0      Link encap:Ethernet  Hardware Adresse 00:0f:b0:0e:57:a1
           inet Adresse:77.21.170.83  Bcast:255.255.255.255
Maske:255.255.252.0
           UP BROADCAST RUNNING MULTICAST  MTU:576  Metrik:1
           RX packets:35420 errors:0 dropped:0 overruns:0 frame:0
           TX packets:1946 errors:0 dropped:0 overruns:0 carrier:0
           Kollisionen:0 Sendewarteschlangenl=E4nge:1000
           RX bytes:3756084 (3.5 MiB)  TX bytes:245214 (239.4 KiB)
           Interrupt:18 Basisadresse:0x7000

lo        Link encap:Lokale Schleife
           inet Adresse:127.0.0.1  Maske:255.0.0.0
           inet6-Adresse: ::1/128 G=FCltigkeitsbereich:Maschine
           UP LOOPBACK RUNNING  MTU:16436  Metrik:1
           RX packets:10 errors:0 dropped:0 overruns:0 frame:0
           TX packets:10 errors:0 dropped:0 overruns:0 carrier:0
           Kollisionen:0 Sendewarteschlangenl=E4nge:0
           RX bytes:660 (660.0 B)  TX bytes:660 (660.0 B)

wlan0     Link encap:Ethernet  Hardware Adresse 00:90:4b:97:34:73
           UP BROADCAST MULTICAST  MTU:1500  Metrik:1
           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
           Kollisionen:0 Sendewarteschlangenl=E4nge:1000
           RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

wmaster0  Link encap:UNSPEC  Hardware Adresse
00-90-4B-97-34-73-6C-6F-00-00-00-00-00-00-00-00
           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metrik:1
           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
           Kollisionen:0 Sendewarteschlangenl=E4nge:1000
           RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)


<iwconfig> shows this,
lo        no wireless extensions.

eth0      no wireless extensions.

wmaster0  no wireless extensions.

wlan0     IEEE 802.11b  ESSID:""
           Mode:Managed  Frequency:2.412 GHz  Access Point:
Not-Associated
           Tx-Power=3D27 dBm
           Retry min limit:7   RTS thr:off   Fragment thr=3D2352 B
           Encryption key:off
           Link Quality:0  Signal level:0  Noise level:0
           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
           Tx excessive retries:0  Invalid misc:0   Missed beacon:0

I am not sure whether this Card is active, because <dmesg> show me,
[  409.752921] b43legacy-phy0: Radio hardware status changed to DISABLE=
D

Another funny Thing is, that i can execute <iwlist wla0 scanning> and=20
get a Result,
wlan0     Scan completed :
           Cell 01 - Address: 02:00:7C:81:E1:73
                     ESSID:"kleopatra"
                     Mode:Ad-Hoc
                     Channel:10
                     Frequency:2.457 GHz (Channel 10)
                     Quality=3D55/100  Signal level=3D-55 dBm  Noise=20
level=3D-43 dBm
                     Encryption key:on
                     Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s
                     Extra:tsf=3D0000000075bb2b8d

The Adress seems to change sometimes ??? I don't know why.

Regards Markus

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
