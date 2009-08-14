Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kso.tls-tautenburg.de ([194.94.209.8]:7215 "EHLO
	kso.tls-tautenburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932725AbZHNRq6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 13:46:58 -0400
Message-ID: <4A85A30C.4080103@tls-tautenburg.de>
Date: Fri, 14 Aug 2009 19:46:52 +0200
From: Bringfried Stecklum <stecklum@tls-tautenburg.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: compat-wireless-2009-08-13 - connection problems
References: <4A829D90.2080208@tls-tautenburg.de> <43e72e890908121902g11b136e8y3f1cd30e6c607c08@mail.gmail.com>
In-Reply-To: <43e72e890908121902g11b136e8y3f1cd30e6c607c08@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

compilation of compat-wireless-2009-08-13 on my Ubuntu 8.10 kernel 2.6.27-12 
x86_64 system went fine. I noticed however, that upon resuming from 
standby/hibernate and unloading/loading iwlagn persistent connection problems 
occur which were not present with compat-wireless-2009-06-30 (the version I used 
until now). Here are the excerpts from /var/log/messages which illustrate the case

compat-wireless-2009-08-13
--------------------------
> 2009/08/14 18:29:44 :: No wired connection present, attempting to autoconnect to wireless network
> 2009/08/14 18:29:45 :: Unable to autoconnect, you'll have to manually connect
> 2009/08/14 18:29:50 :: No wired connection present, attempting to autoconnect to wireless network
> 2009/08/14 18:29:50 :: trying to automatically connect to...NET2NET
> 2009/08/14 18:29:50 :: Connecting to wireless network NET2NET
> 2009/08/14 18:29:50 :: Putting interface down
> 2009/08/14 18:29:50 :: Releasing DHCP leases...
> 2009/08/14 18:29:51 :: Setting false IP...
> 2009/08/14 18:29:52 :: Stopping wpa_supplicant and any DHCP clients
> 2009/08/14 18:29:52 :: Flushing the routing table...
> 2009/08/14 18:29:52 :: Generating psk...
> 2009/08/14 18:29:52 :: Attempting to authenticate...
> 2009/08/14 18:29:53 :: Putting interface up...
> 2009/08/14 18:29:55 :: Running DHCP
> 2009/08/14 18:29:55 :: Internet Systems Consortium DHCP Client V3.1.1
> 2009/08/14 18:29:55 :: Copyright 2004-2008 Internet Systems Consortium.
> 2009/08/14 18:29:55 :: All rights reserved.
> 2009/08/14 18:29:55 :: For info, please visit http://www.isc.org/sw/dhcp/
> 2009/08/14 18:29:55 :: 
> 2009/08/14 18:29:57 :: Listening on LPF/wlan0/00:21:5c:a0:ee:f7
> 2009/08/14 18:29:57 :: Sending on   LPF/wlan0/00:21:5c:a0:ee:f7
> 2009/08/14 18:29:57 :: Sending on   Socket/fallback
> 2009/08/14 18:30:00 :: DHCPREQUEST of 192.168.178.37 on wlan0 to 255.255.255.255 port 67
> 2009/08/14 18:30:08 :: DHCPREQUEST of 192.168.178.37 on wlan0 to 255.255.255.255 port 67
> 2009/08/14 18:30:28 :: DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 4
> 2009/08/14 18:30:32 :: DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 5
> 2009/08/14 18:30:37 :: DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 8
> 2009/08/14 18:30:45 :: DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 15
> 2009/08/14 18:31:00 :: DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 13
> 2009/08/14 18:31:13 :: DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 16
> 2009/08/14 18:31:29 :: No DHCPOFFERS received.
> 2009/08/14 18:31:29 :: Trying recorded lease 192.168.178.37
> 2009/08/14 18:31:32 :: PING 192.168.178.1 (192.168.178.1) 56(84) bytes of data.
> 2009/08/14 18:31:32 :: 
> 2009/08/14 18:31:32 :: --- 192.168.178.1 ping statistics ---
> 2009/08/14 18:31:32 :: 1 packets transmitted, 0 received, +1 errors, 100% packet loss, time 0ms
> 2009/08/14 18:31:32 :: 
> 2009/08/14 18:31:32 :: Trying recorded lease 192.168.2.105
> 2009/08/14 18:31:35 :: PING 192.168.2.1 (192.168.2.1) 56(84) bytes of data.
> 2009/08/14 18:31:35 :: 
> 2009/08/14 18:31:35 :: --- 192.168.2.1 ping statistics ---
> 2009/08/14 18:31:35 :: 1 packets transmitted, 0 received, +1 errors, 100% packet loss, time 0ms
> 2009/08/14 18:31:35 :: 
> 2009/08/14 18:31:35 :: No working leases in persistent database - sleeping.
> 2009/08/14 18:31:35 :: DHCP connection failed
> 2009/08/14 18:31:35 :: exiting connection thread
> 2009/08/14 18:31:39 :: No wired connection present, attempting to autoconnect to wireless network
> 2009/08/14 18:31:39 :: trying to automatically connect to...NET2NET
> 2009/08/14 18:31:39 :: Connecting to wireless network NET2NET
> 2009/08/14 18:31:39 :: Putting interface down
> 2009/08/14 18:31:39 :: Releasing DHCP leases...
> 2009/08/14 18:31:39 :: Setting false IP...
> 2009/08/14 18:31:40 :: Stopping wpa_supplicant and any DHCP clients
> 2009/08/14 18:31:40 :: Flushing the routing table...
> 2009/08/14 18:31:40 :: Generating psk...
> 2009/08/14 18:31:40 :: Attempting to authenticate...
> 2009/08/14 18:31:40 :: Putting interface up...
> 2009/08/14 18:31:41 :: Running DHCP
> 2009/08/14 18:31:41 :: Internet Systems Consortium DHCP Client V3.1.1
> 2009/08/14 18:31:41 :: Copyright 2004-2008 Internet Systems Consortium.
> 2009/08/14 18:31:41 :: All rights reserved.
> 2009/08/14 18:31:41 :: For info, please visit http://www.isc.org/sw/dhcp/
> 2009/08/14 18:31:42 :: Listening on LPF/wlan0/00:21:5c:a0:ee:f7
> 2009/08/14 18:31:42 :: Sending on   LPF/wlan0/00:21:5c:a0:ee:f7
> 2009/08/14 18:31:42 :: Sending on   Socket/fallback
> 2009/08/14 18:31:42 :: DHCPREQUEST of 192.168.178.37 on wlan0 to 255.255.255.255 port 67
> 2009/08/14 18:31:42 :: DHCPACK of 192.168.178.37 from 192.168.178.1
> 2009/08/14 18:31:42 :: bound to 192.168.178.37 -- renewal in 349940 seconds.
> 2009/08/14 18:31:42 :: DHCP connection successful
> 2009/08/14 18:31:42 :: Connecting thread exiting.


compat-wireless-2009-06-30
--------------------------
> 2009/08/14 19:30:16 :: No wired connection present, attempting to autoconnect to wireless network
> 2009/08/14 19:30:16 :: Unable to autoconnect, you'll have to manually connect
> 2009/08/14 19:30:22 :: No wired connection present, attempting to autoconnect to wireless network
> 2009/08/14 19:30:22 :: trying to automatically connect to...NET2NET
> 2009/08/14 19:30:22 :: Connecting to wireless network NET2NET
> 2009/08/14 19:30:22 :: Putting interface down
> 2009/08/14 19:30:22 :: Releasing DHCP leases...
> 2009/08/14 19:30:23 :: Setting false IP...
> 2009/08/14 19:30:23 :: Stopping wpa_supplicant and any DHCP clients
> 2009/08/14 19:30:23 :: Flushing the routing table...
> 2009/08/14 19:30:23 :: Generating psk...
> 2009/08/14 19:30:23 :: Attempting to authenticate...
> 2009/08/14 19:30:23 :: Putting interface up...
> 2009/08/14 19:30:32 :: Running DHCP
> 2009/08/14 19:30:32 :: Internet Systems Consortium DHCP Client V3.1.1
> 2009/08/14 19:30:32 :: Copyright 2004-2008 Internet Systems Consortium.
> 2009/08/14 19:30:32 :: All rights reserved.
> 2009/08/14 19:30:32 :: For info, please visit http://www.isc.org/sw/dhcp/
> 2009/08/14 19:30:32 :: 
> 2009/08/14 19:30:33 :: Listening on LPF/wlan0/00:21:5c:a0:ee:f7
> 2009/08/14 19:30:33 :: Sending on   LPF/wlan0/00:21:5c:a0:ee:f7
> 2009/08/14 19:30:33 :: Sending on   Socket/fallback
> 2009/08/14 19:30:37 :: DHCPREQUEST of 192.168.178.37 on wlan0 to 255.255.255.255 port 67
> 2009/08/14 19:30:37 :: DHCPACK of 192.168.178.37 from 192.168.178.1
> 2009/08/14 19:30:37 :: bound to 192.168.178.37 -- renewal in 347388 seconds.
> 2009/08/14 19:30:37 :: DHCP connection successful
> 2009/08/14 19:30:37 :: Connecting thread exiting.

Regards,

	Bringfried


