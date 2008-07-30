Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from afrodite.halogica.com.br ([201.48.126.211]:31529 "EHLO
	afrodite.halogica.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbYG3TQG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 15:16:06 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Subject: Issue: iwlist scanning sees the network; dhclient can't connect
Date: Wed, 30 Jul 2008 16:13:51 -0300
Message-ID: <1127857B97C63B4285A9B02BEF67AEE601627648@afrodite.halogica.com.br> (sfid-20080730_211610_372213_C4BF2669)
From: "Thiago F. Tavares" <ttavares@halogica.com>
To: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 
Hello,
 
I have a problem with the broadcom wireless card (BCM4306 using b43).
I'm can list the wireless ESSIDs with "iwlist scanning" command, but I'm
can't connect in the LAN. My dhclient or dhcpcd can't receive an IP.
When I set a static IP, I can't ping the gateway.
 
Follows the output of the interesting commands:
 


#ifconfig
 
eth0      Link encap:Ethernet  HWaddr #######################  
          inet addr:192.168.0.200  Bcast:192.168.0.255
Mask:255.255.255.0
          inet6 addr: ##################### Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:953 errors:0 dropped:0 overruns:0 frame:0
          TX packets:1055 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:750261 (732.6 KiB)  TX bytes:178857 (174.6 KiB)
          Interrupt:220 Base address:0xe000 

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          RX packets:24 errors:0 dropped:0 overruns:0 frame:0
          TX packets:24 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:1648 (1.6 KiB)  TX bytes:1648 (1.6 KiB)

wlan0     Link encap:Ethernet  HWaddr ###################
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:11 errors:0 dropped:0 overruns:0 frame:0
          TX packets:7 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:3941 (3.8 KiB)  TX bytes:2004 (1.9 KiB)

wmaster0  Link encap:UNSPEC  HWaddr ################
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
 

-------------------------------------------------------------------
#iwlist scanning


lo        Interface doesn't support scanning.

eth0      Interface doesn't support scanning.

wmaster0  Interface doesn't support scanning.

wlan0     Scan completed :
          Cell 01 - Address: ##:##:##:##:##:##
                    ESSID:"fastermangrate-on-song"
                    Mode:Master
                    Channel:11
                    Frequency:2.462 GHz (Channel 11)
                    Quality=76/100  Signal level=-58 dBm  Noise
level=-127 dBm
                    Encryption key:off
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 18 Mb/s
                              24 Mb/s; 36 Mb/s; 54 Mb/s; 6 Mb/s; 9 Mb/s
                              12 Mb/s; 48 Mb/s
                    Extra:tsf=00000051a4c1557d
 
------------------------------------------------------------------- 
#dhclient wlan0


There is already a pid file /var/run/dhclient.pid with pid 3239
killed old client process, removed PID file
Internet Systems Consortium DHCP Client V3.1.1
Copyright 2004-2008 Internet Systems Consortium.
All rights reserved.
For info, please visit http://www.isc.org/sw/dhcp/

wmaster0: unknown hardware address type 801
wmaster0: unknown hardware address type 801
Listening on LPF/wlan0/##:##:##:##:##:##
Sending on   LPF/wlan0/##:##:##:##:##:##
Sending on   Socket/fallback
DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 5
DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 7
DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 12
DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 12
DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 16
DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 9
No DHCPOFFERS received.
No working leases in persistent database - sleeping.
 

--------------------------------------------------------------------


Please, help me with this problem.
 
Thank you.
 
 
Best Regards,
 
 

    Thiago Tavares

(CCNA - CISS - LPIC1)
