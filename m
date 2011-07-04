Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53604 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab1GDTqs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jul 2011 15:46:48 -0400
Received: by iwn6 with SMTP id 6so4666404iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 04 Jul 2011 12:46:48 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 4 Jul 2011 21:46:46 +0200
Message-ID: <CAMJnVwmtNBrAbaL5TU-pQO+cvFn=UJC2rQroJeYASL3zJEesaw@mail.gmail.com> (sfid-20110704_214659_655645_BF8AAA6C)
Subject: carl9170: Problems setting up Virtual Interface
From: Alex <alex9434@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,

I am using the carl9170 interface from the 2.6.39.2 kernel with the
newest carl9170 firmware. I have set-up an AP with hostapd. Everything
is working so far:

root@box:~# ifconfig
eth0      Link encap:Ethernet  HWaddr <deleted>
          inet addr:192.168.178.25  Bcast:192.168.178.255  Mask:255.255.255.0
          inet6 addr: fe80::210:75ff:fe1a:bc7e/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:18885 errors:0 dropped:0 overruns:0 frame:0
          TX packets:10301 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:25168612 (24.0 MiB)  TX bytes:829805 (810.3 KiB)
          Interrupt:11

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          RX packets:71 errors:0 dropped:0 overruns:0 frame:0
          TX packets:71 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:6694 (6.5 KiB)  TX bytes:6694 (6.5 KiB)

mon.wlan0 Link encap:UNSPEC  HWaddr <deleted>
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:27070 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:4583087 (4.3 MiB)  TX bytes:0 (0.0 B)

wlan0     Link encap:Ethernet  HWaddr <deleted>
          inet addr:192.168.80.1  Bcast:192.168.80.255  Mask:255.255.255.0
          inet6 addr: fe80::76ea:3aff:fe8f:130c/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:320 errors:0 dropped:1 overruns:0 frame:0
          TX packets:231 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:28815 (28.1 KiB)  TX bytes:26887 (26.2 KiB)

I am now trying to create an additional virtual intereface to connect
wireless to my router as described on:

http://linuxwireless.org/en/users/Documentation/iw/vif/

with
iw dev wlan0 interface add wlan1 type station

However, ifconfig does not list the additional wlan1 interface. According to

http://linuxwireless.org/en/users/Drivers/carl9170#Multiple_Interfaces

this should be supported. What am I doing wrong? Any additional logs
etc. required to investigate?

Thank you very much for your support.

Regards,
Alex
