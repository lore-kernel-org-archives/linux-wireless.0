Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tor.lindesign.se ([194.17.154.111]:40616 "EHLO tor.lindesign.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbYDELj6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Apr 2008 07:39:58 -0400
Received: from [192.168.100.4] (h-235-0.A189.cust.bahnhof.se [81.170.235.0])
	by tor.lindesign.se (Postfix) with ESMTP id 897F3E2B60
	for <linux-wireless@vger.kernel.org>; Sat,  5 Apr 2008 13:12:52 +0200 (CEST)
Message-ID: <47F75EB4.9090703@tor.lindesign.se> (sfid-20080405_124018_600873_72164D53)
Date: Sat, 05 Apr 2008 13:12:52 +0200
From: Bachman Kharazmi <bachman@tor.lindesign.se>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: compat-wireless iwl4965 on hp/compaq 2510p
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
I've tried to get the onboard iwl4965 wlan nic working with 
compat-wireless since it didn't work with driver that was in 2.6.24 kernel.

However I've followed the guide here: 
http://linuxwireless.org/en/users/Download downloading tarball from 
http://www.orbit-lab.org/kernel/compat-wireless-2.6/2008/04/compat-wireless-2008-04-01.tar.bz2

Compiling and installing went well, but there looks to be serious issues 
using the device.

dmesg and lspci can be found here: 
http://bachman.tor.lindesign.se/tmp/dmesgC2510p.txt
http://bachman.tor.lindesign.se/tmp/lspci-vnn_C2510p.txt
Debian/2.6.24

I've heard that the wlan on this laptop works with ubuntu which suprises 
me after all effort to get it going with latest drivers. Are there any 
solution to get this wlan nic working on my current system?

Thanks! /Bachman


lapp:~/temp/compat-wireless-2008-04-01# modprobe iwl4965
lapp:~/temp/compat-wireless-2008-04-01# iwconfig
lo        no wireless extensions.
eth1      no wireless extensions.
wmaster0  no wireless extensions.
wlan0     IEEE 802.11  ESSID:""
           Mode:Managed  Frequency:2.412 GHz  Access Point: Not-Associated
           Tx-Power=0 dBm
           Retry min limit:7   RTS thr:off   Fragment thr=2352 B
           Encryption key:off
           Link Quality:0  Signal level:0  Noise level:0
           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
           Tx excessive retries:0  Invalid misc:0   Missed beacon:0


Trying to get IP
lapp:~/temp/compat-wireless-2008-04-01# dhclient wlan0
There is already a pid file /var/run/dhclient.pid with pid 6677
killed old client process, removed PID file
Internet Systems Consortium DHCP Client V3.0.4
Copyright 2004-2006 Internet Systems Consortium.
All rights reserved.
For info, please visit http://www.isc.org/sw/dhcp/

wmaster0: unknown hardware address type 801
SIOCSIFFLAGS: No such device
SIOCSIFFLAGS: No such device
wmaster0: unknown hardware address type 801
Listening on LPF/wlan0/00:13:e8:81:40:d3
Sending on   LPF/wlan0/00:13:e8:81:40:d3
Sending on   Socket/fallback
receive_packet failed on wlan0: Network is down
DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 8
send_packet: Network is down
DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 15
send_packet: Network is down
DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 19
send_packet: Network is down
