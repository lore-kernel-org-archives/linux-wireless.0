Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gproxy2-pub.mail.unifiedlayer.com ([69.89.18.3]:56428 "HELO
	gproxy2-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753687AbaEPWuM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2014 18:50:12 -0400
Message-ID: <53769612.1060600@alphaonedesign.com> (sfid-20140517_005029_480876_2271B90E)
Date: Fri, 16 May 2014 16:49:54 -0600
From: Brian Jones <brianj@alphaonedesign.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Subject: iwlwifi crashing on 3.13 and doesn't work after reloading driver
 without reboot
Content-Type: multipart/mixed;
 boundary="------------010201020504080002020405"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010201020504080002020405
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hey all,

I'm running kernel 3.13.0 on a Lenovo Yoga 2 Pro with i7 and the 7260.  
Here's the lspci:

01:00.0 Network controller: Intel Corporation Wireless 7260 (rev 6b)
     Subsystem: Intel Corporation Wireless-N 7260
     Kernel driver in use: iwlwifi

and the dmesg:

root@brian-laptop:~# dmesg|grep firmware
[    1.790550] iwlwifi 0000:01:00.0: loaded firmware version 22.24.8.0 
op_mode iwlmvm


I am randomly getting a crash which takes down the wifi and even when I 
remove and reload the iwlwifi driver, it still doesn't work until I do a 
hard reboot.  After the crash the syslog/dmesg say "Failed to load 
firmware chunk!".

Any ideas?

Attached is a syslog copy.

Thanks!

Brian Jones

--------------010201020504080002020405
Content-Type: text/plain; charset=UTF-8;
 name="log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="log"

May 16 09:34:16 brian-laptop anacron[11770]: Job `cron.daily' terminated
May 16 09:34:16 brian-laptop anacron[11770]: Normal exit (1 job run)
May 16 09:39:01 brian-laptop CRON[12549]: (root) CMD (  [ -x /usr/lib/php=
5/maxlifetime ] && [ -x /usr/lib/php5/sessionclean ] && [ -d /var/lib/php=
5 ] && /usr/lib/php5/sessionclean /var/lib/php5 $(/usr/lib/php5/maxlifeti=
me))
May 16 09:40:27 brian-laptop avahi-daemon[558]: Registering new address r=
ecord for 2002:d1b5:5206:0:5df5:1d5f:b4ac:b7bf on wlan0.*.
May 16 09:54:07 brian-laptop wpa_supplicant[2784]: wlan0: WPA: Group reke=
ying completed with 00:22:6b:54:68:d2 [GTK=3DTKIP]
May 16 10:09:01 brian-laptop CRON[12664]: (root) CMD (  [ -x /usr/lib/php=
5/maxlifetime ] && [ -x /usr/lib/php5/sessionclean ] && [ -d /var/lib/php=
5 ] && /usr/lib/php5/sessionclean /var/lib/php5 $(/usr/lib/php5/maxlifeti=
me))
May 16 10:17:01 brian-laptop CRON[12696]: (root) CMD (   cd / && run-part=
s --report /etc/cron.hourly)
May 16 10:22:41 brian-laptop avahi-daemon[558]: Registering new address r=
ecord for 2002:d1b5:5206:0:114b:3f42:4fc7:fae4 on wlan0.*.
May 16 10:36:52 brian-laptop kernel: [20911.988838] type=3D1400 audit(140=
0258212.098:74): apparmor=3D"DENIED" operation=3D"open" profile=3D"/usr/b=
in/evince" name=3D"/etc/xfce4/defaults.list" pid=3D12802 comm=3D"evince" =
requested_mask=3D"r" denied_mask=3D"r" fsuid=3D1000 ouid=3D0
May 16 10:38:36 brian-laptop kernel: [21016.136136] type=3D1400 audit(140=
0258316.162:75): apparmor=3D"DENIED" operation=3D"open" profile=3D"/usr/b=
in/evince" name=3D"/etc/xfce4/defaults.list" pid=3D12846 comm=3D"evince" =
requested_mask=3D"r" denied_mask=3D"r" fsuid=3D1000 ouid=3D0
May 16 10:38:57 brian-laptop kernel: [21037.556899] type=3D1400 audit(140=
0258337.566:76): apparmor=3D"DENIED" operation=3D"open" profile=3D"/usr/b=
in/evince" name=3D"/etc/xfce4/defaults.list" pid=3D12866 comm=3D"evince" =
requested_mask=3D"r" denied_mask=3D"r" fsuid=3D1000 ouid=3D0
May 16 10:39:01 brian-laptop CRON[12882]: (root) CMD (  [ -x /usr/lib/php=
5/maxlifetime ] && [ -x /usr/lib/php5/sessionclean ] && [ -d /var/lib/php=
5 ] && /usr/lib/php5/sessionclean /var/lib/php5 $(/usr/lib/php5/maxlifeti=
me))
May 16 11:09:01 brian-laptop CRON[13643]: (root) CMD (  [ -x /usr/lib/php=
5/maxlifetime ] && [ -x /usr/lib/php5/sessionclean ] && [ -d /var/lib/php=
5 ] && /usr/lib/php5/sessionclean /var/lib/php5 $(/usr/lib/php5/maxlifeti=
me))
May 16 11:17:01 brian-laptop CRON[13687]: (root) CMD (   cd / && run-part=
s --report /etc/cron.hourly)
May 16 11:29:01 brian-laptop avahi-daemon[558]: Registering new address r=
ecord for 2002:d1b5:5206:0:f5c3:f954:c1ce:f6d3 on wlan0.*.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:ec86:833a:28d1:eb3a on wlan0.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:a925:8459:1cf4:10ae on wlan0.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:5df5:1d5f:b4ac:b7bf on wlan0.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:4cb9:e69d:4750:d04e on wlan0.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:3878:9246:9c34:1a97 on wlan0.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:1c34:8560:8233:8c70 on wlan0.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:557c:3b0e:bf6d:f974 on wlan0.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:f5c3:f954:c1ce:f6d3 on wlan0.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:5d70:2a8a:4e2e:7c1a on wlan0.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:114b:3f42:4fc7:fae4 on wlan0.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:f905:ea46:72c7:5afc on wlan0.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:f89d:d706:5096:6813 on wlan0.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:ad1d:aa4e:3e5e:51bd on wlan0.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:429:3066:df5e:b2ba on wlan0.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:8992:aac8:e13d:7ca7 on wlan0.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:9938:9b25:6dc9:52d0 on wlan0.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:b0c8:d7e7:2322:4dd2 on wlan0.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:5e51:4fff:fe63:1e10 on wlan0.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:f146:916c:6428:b29d on wlan0.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:ed49:34cf:f2e8:7e83 on wlan0.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:552a:b363:3c34:ba4e on wlan0.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:7152:ce22:e3b5:1537 on wlan0.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:c03:9440:82a5:79a8 on wlan0.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:d0f0:206f:e38c:70d3 on wlan0.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Registering new address r=
ecord for 2002:d1b5:5206:0:f5c3:f954:c1ce:f6d3 on wlan0.*.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Registering new address r=
ecord for 2002:d1b5:5206:0:114b:3f42:4fc7:fae4 on wlan0.*.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Registering new address r=
ecord for 2002:d1b5:5206:0:5df5:1d5f:b4ac:b7bf on wlan0.*.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Registering new address r=
ecord for 2002:d1b5:5206:0:d0f0:206f:e38c:70d3 on wlan0.*.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Registering new address r=
ecord for 2002:d1b5:5206:0:8992:aac8:e13d:7ca7 on wlan0.*.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Registering new address r=
ecord for 2002:d1b5:5206:0:f89d:d706:5096:6813 on wlan0.*.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Registering new address r=
ecord for 2002:d1b5:5206:0:552a:b363:3c34:ba4e on wlan0.*.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Registering new address r=
ecord for 2002:d1b5:5206:0:557c:3b0e:bf6d:f974 on wlan0.*.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Registering new address r=
ecord for 2002:d1b5:5206:0:f905:ea46:72c7:5afc on wlan0.*.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Registering new address r=
ecord for 2002:d1b5:5206:0:c03:9440:82a5:79a8 on wlan0.*.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Registering new address r=
ecord for 2002:d1b5:5206:0:9938:9b25:6dc9:52d0 on wlan0.*.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Registering new address r=
ecord for 2002:d1b5:5206:0:ad1d:aa4e:3e5e:51bd on wlan0.*.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Registering new address r=
ecord for 2002:d1b5:5206:0:b0c8:d7e7:2322:4dd2 on wlan0.*.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Registering new address r=
ecord for 2002:d1b5:5206:0:1c34:8560:8233:8c70 on wlan0.*.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Registering new address r=
ecord for 2002:d1b5:5206:0:ec86:833a:28d1:eb3a on wlan0.*.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Registering new address r=
ecord for 2002:d1b5:5206:0:4cb9:e69d:4750:d04e on wlan0.*.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Registering new address r=
ecord for 2002:d1b5:5206:0:7152:ce22:e3b5:1537 on wlan0.*.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Registering new address r=
ecord for 2002:d1b5:5206:0:5d70:2a8a:4e2e:7c1a on wlan0.*.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Registering new address r=
ecord for 2002:d1b5:5206:0:f146:916c:6428:b29d on wlan0.*.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Registering new address r=
ecord for 2002:d1b5:5206:0:ed49:34cf:f2e8:7e83 on wlan0.*.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Registering new address r=
ecord for 2002:d1b5:5206:0:429:3066:df5e:b2ba on wlan0.*.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Registering new address r=
ecord for 2002:d1b5:5206:0:a925:8459:1cf4:10ae on wlan0.*.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Registering new address r=
ecord for 2002:d1b5:5206:0:5e51:4fff:fe63:1e10 on wlan0.*.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Registering new address r=
ecord for 2002:d1b5:5206:0:3878:9246:9c34:1a97 on wlan0.*.
May 16 11:29:03 brian-laptop avahi-daemon[558]: Registering new address r=
ecord for fe80::5e51:4fff:fe63:1e10 on wlan0.*.
May 16 11:29:13 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:ec86:833a:28d1:eb3a on wlan0.
May 16 11:29:13 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:a925:8459:1cf4:10ae on wlan0.
May 16 11:29:13 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:5df5:1d5f:b4ac:b7bf on wlan0.
May 16 11:29:13 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:4cb9:e69d:4750:d04e on wlan0.
May 16 11:29:13 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:3878:9246:9c34:1a97 on wlan0.
May 16 11:29:13 brian-laptop avahi-daemon[558]: Leaving mDNS multicast gr=
oup on interface wlan0.IPv6 with address 2002:d1b5:5206:0:3878:9246:9c34:=
1a97.
May 16 11:29:13 brian-laptop avahi-daemon[558]: Joining mDNS multicast gr=
oup on interface wlan0.IPv6 with address 2002:d1b5:5206:0:f5c3:f954:c1ce:=
f6d3.
May 16 11:29:13 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:1c34:8560:8233:8c70 on wlan0.
May 16 11:29:13 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:557c:3b0e:bf6d:f974 on wlan0.
May 16 11:29:13 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:f5c3:f954:c1ce:f6d3 on wlan0.
May 16 11:29:13 brian-laptop avahi-daemon[558]: Leaving mDNS multicast gr=
oup on interface wlan0.IPv6 with address 2002:d1b5:5206:0:f5c3:f954:c1ce:=
f6d3.
May 16 11:29:13 brian-laptop avahi-daemon[558]: Joining mDNS multicast gr=
oup on interface wlan0.IPv6 with address 2002:d1b5:5206:0:114b:3f42:4fc7:=
fae4.
May 16 11:29:13 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:5d70:2a8a:4e2e:7c1a on wlan0.
May 16 11:29:13 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:114b:3f42:4fc7:fae4 on wlan0.
May 16 11:29:13 brian-laptop avahi-daemon[558]: Leaving mDNS multicast gr=
oup on interface wlan0.IPv6 with address 2002:d1b5:5206:0:114b:3f42:4fc7:=
fae4.
May 16 11:29:13 brian-laptop avahi-daemon[558]: Joining mDNS multicast gr=
oup on interface wlan0.IPv6 with address 2002:d1b5:5206:0:d0f0:206f:e38c:=
70d3.
May 16 11:29:13 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:f905:ea46:72c7:5afc on wlan0.
May 16 11:29:13 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:f89d:d706:5096:6813 on wlan0.
May 16 11:29:13 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:ad1d:aa4e:3e5e:51bd on wlan0.
May 16 11:29:13 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:429:3066:df5e:b2ba on wlan0.
May 16 11:29:13 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:8992:aac8:e13d:7ca7 on wlan0.
May 16 11:29:13 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:9938:9b25:6dc9:52d0 on wlan0.
May 16 11:29:13 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:b0c8:d7e7:2322:4dd2 on wlan0.
May 16 11:29:13 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:5e51:4fff:fe63:1e10 on wlan0.
May 16 11:29:13 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:f146:916c:6428:b29d on wlan0.
May 16 11:29:13 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:ed49:34cf:f2e8:7e83 on wlan0.
May 16 11:29:13 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:552a:b363:3c34:ba4e on wlan0.
May 16 11:29:13 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:7152:ce22:e3b5:1537 on wlan0.
May 16 11:29:13 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:c03:9440:82a5:79a8 on wlan0.
May 16 11:29:13 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:d0f0:206f:e38c:70d3 on wlan0.
May 16 11:29:13 brian-laptop avahi-daemon[558]: Leaving mDNS multicast gr=
oup on interface wlan0.IPv6 with address 2002:d1b5:5206:0:d0f0:206f:e38c:=
70d3.
May 16 11:29:13 brian-laptop avahi-daemon[558]: Joining mDNS multicast gr=
oup on interface wlan0.IPv6 with address 2002:d1b5:5206:0:3431:e0d3:f58b:=
73e5.
May 16 11:29:13 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 2002:d1b5:5206:0:3431:e0d3:f58b:73e5 on wlan0.
May 16 11:29:13 brian-laptop avahi-daemon[558]: Leaving mDNS multicast gr=
oup on interface wlan0.IPv6 with address 2002:d1b5:5206:0:3431:e0d3:f58b:=
73e5.
May 16 11:29:13 brian-laptop avahi-daemon[558]: Joining mDNS multicast gr=
oup on interface wlan0.IPv6 with address fe80::5e51:4fff:fe63:1e10.
May 16 11:39:01 brian-laptop CRON[13923]: (root) CMD (  [ -x /usr/lib/php=
5/maxlifetime ] && [ -x /usr/lib/php5/sessionclean ] && [ -d /var/lib/php=
5 ] && /usr/lib/php5/sessionclean /var/lib/php5 $(/usr/lib/php5/maxlifeti=
me))
May 16 11:45:40 brian-laptop dhclient: Internet Systems Consortium DHCP C=
lient 4.2.4
May 16 11:45:40 brian-laptop dhclient: Copyright 2004-2012 Internet Syste=
ms Consortium.
May 16 11:45:40 brian-laptop dhclient: All rights reserved.
May 16 11:45:40 brian-laptop dhclient: For info, please visit https://www=
=2Eisc.org/software/dhcp/
May 16 11:45:40 brian-laptop dhclient:=20
May 16 11:45:41 brian-laptop dhclient: Listening on LPF/wlan0/5c:51:4f:63=
:1e:10
May 16 11:45:41 brian-laptop dhclient: Sending on   LPF/wlan0/5c:51:4f:63=
:1e:10
May 16 11:45:41 brian-laptop dhclient: Sending on   Socket/fallback
May 16 11:45:41 brian-laptop dhclient: DHCPRELEASE on wlan0 to 192.168.3.=
1 port 67 (xid=3D0x2fe9026a)
May 16 11:45:41 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for 192.168.3.107 on wlan0.
May 16 11:45:41 brian-laptop avahi-daemon[558]: Leaving mDNS multicast gr=
oup on interface wlan0.IPv4 with address 192.168.3.107.
May 16 11:45:43 brian-laptop kernel: [25046.601849] iwlwifi 0000:01:00.0:=
 Error sending MAC_CONTEXT_CMD: time out after 2000ms.
May 16 11:45:43 brian-laptop kernel: [25046.601861] iwlwifi 0000:01:00.0:=
 Current CMD queue read_ptr 94 write_ptr 95
May 16 11:45:43 brian-laptop kernel: [25046.619637] ------------[ cut her=
e ]------------
May 16 11:45:43 brian-laptop kernel: [25046.619692] WARNING: CPU: 2 PID: =
14018 at /build/buildd/linux-3.13.0/drivers/net/wireless/iwlwifi/pcie/tra=
ns.c:1002 iwl_trans_pcie_grab_nic_access+0xcb/0xe0 [iwlwifi]()
May 16 11:45:43 brian-laptop kernel: [25046.619698] Timeout waiting for h=
ardware access (CSR_GP_CNTRL 0xffffffff)
May 16 11:45:43 brian-laptop kernel: [25046.619702] Modules linked in: cd=
c_acm ctr ccm hid_sensor_als hid_sensor_magn_3d hid_sensor_gyro_3d hid_se=
nsor_accel_3d hid_sensor_trigger industrialio_triggered_buffer kfifo_buf =
industrialio hid_sensor_iio_common hid_multitouch hid_sensor_hub uvcvideo=
 videobuf2_vmalloc videobuf2_memops videobuf2_core usbhid hid videodev bt=
usb snd_hda_codec_hdmi snd_hda_codec_realtek joydev arc4 intel_rapl x86_p=
kg_temp_thermal intel_powerclamp coretemp kvm bnep rfcomm crct10dif_pclmu=
l bluetooth crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw g=
f128mul glue_helper ablk_helper cryptd iwlmvm mac80211 psmouse serio_raw =
snd_hda_intel iwlwifi snd_hda_codec snd_hwdep cfg80211 snd_pcm snd_page_a=
lloc snd_seq_midi snd_seq_midi_event snd_rawmidi i915 intel_smartconnect =
snd_seq snd_seq_device mac_hid video snd_timer drm_kms_helper parport_pc =
drm snd i2c_algo_bit mei_me ppdev nls_iso8859_1 mei soundcore lpc_ich lp =
parport ahci libahci
May 16 11:45:43 brian-laptop kernel: [25046.619837] CPU: 2 PID: 14018 Com=
m: ip Not tainted 3.13.0-24-generic #47-Ubuntu
May 16 11:45:43 brian-laptop kernel: [25046.619841] Hardware name: LENOVO=
 20266/Yoga2, BIOS 76CN27WW 09/17/2013
May 16 11:45:43 brian-laptop kernel: [25046.619845]  0000000000000009 fff=
f8801fad85548 ffffffff81715ac4 ffff8801fad85590
May 16 11:45:43 brian-laptop kernel: [25046.619853]  ffff8801fad85580 fff=
fffff810676bd ffff880252684000 ffff880252687258
May 16 11:45:43 brian-laptop kernel: [25046.619860]  ffff8801fad85628 000=
0000000000000 0000000000000025 ffff8801fad855e0
May 16 11:45:43 brian-laptop kernel: [25046.619868] Call Trace:
May 16 11:45:43 brian-laptop kernel: [25046.619881]  [<ffffffff81715ac4>]=
 dump_stack+0x45/0x56
May 16 11:45:43 brian-laptop kernel: [25046.619890]  [<ffffffff810676bd>]=
 warn_slowpath_common+0x7d/0xa0
May 16 11:45:43 brian-laptop kernel: [25046.619896]  [<ffffffff8106772c>]=
 warn_slowpath_fmt+0x4c/0x50
May 16 11:45:43 brian-laptop kernel: [25046.619917]  [<ffffffffa0325eda>]=
 ? iwl_read32+0x1a/0x80 [iwlwifi]
May 16 11:45:43 brian-laptop kernel: [25046.619934]  [<ffffffffa032732b>]=
 iwl_trans_pcie_grab_nic_access+0xcb/0xe0 [iwlwifi]
May 16 11:45:43 brian-laptop kernel: [25046.619948]  [<ffffffffa03283c1>]=
 iwl_trans_pcie_read_mem+0x31/0x130 [iwlwifi]
May 16 11:45:43 brian-laptop kernel: [25046.619966]  [<ffffffffa0429da7>]=
 iwl_mvm_dump_nic_error_log+0xc7/0x6b0 [iwlmvm]
May 16 11:45:43 brian-laptop kernel: [25046.619974]  [<ffffffff8109df24>]=
 ? arch_vtime_task_switch+0x94/0xa0
May 16 11:45:43 brian-laptop kernel: [25046.619983]  [<ffffffff8148a7ee>]=
 ? dev_printk_emit+0x3e/0x40
May 16 11:45:43 brian-laptop kernel: [25046.619991]  [<ffffffff8107457b>]=
 ? lock_timer_base.isra.35+0x2b/0x50
May 16 11:45:43 brian-laptop kernel: [25046.620000]  [<ffffffff8148ac0e>]=
 ? __dev_printk+0x3e/0x90
May 16 11:45:43 brian-laptop kernel: [25046.620006]  [<ffffffff8148ae2c>]=
 ? dev_err+0x5c/0x60
May 16 11:45:43 brian-laptop kernel: [25046.620017]  [<ffffffff813697aa>]=
 ? delay_tsc+0x4a/0x80
May 16 11:45:43 brian-laptop kernel: [25046.620034]  [<ffffffffa0426ef6>]=
 iwl_mvm_nic_error+0x16/0x30 [iwlmvm]
May 16 11:45:43 brian-laptop kernel: [25046.620049]  [<ffffffffa03255b0>]=
 iwl_trans_pcie_send_hcmd+0x5b0/0x690 [iwlwifi]
May 16 11:45:43 brian-laptop kernel: [25046.620058]  [<ffffffff810aae90>]=
 ? prepare_to_wait_event+0x100/0x100
May 16 11:45:43 brian-laptop kernel: [25046.620072]  [<ffffffffa042988d>]=
 iwl_mvm_send_cmd+0x2d/0x90 [iwlmvm]
May 16 11:45:43 brian-laptop kernel: [25046.620085]  [<ffffffffa0429931>]=
 iwl_mvm_send_cmd_pdu+0x41/0x50 [iwlmvm]
May 16 11:45:43 brian-laptop kernel: [25046.620097]  [<ffffffffa0427c98>]=
 iwl_mvm_mac_ctxt_send_cmd+0x28/0x60 [iwlmvm]
May 16 11:45:43 brian-laptop kernel: [25046.620109]  [<ffffffffa0428bc8>]=
 iwl_mvm_mac_ctxt_cmd_station+0xd8/0x140 [iwlmvm]
May 16 11:45:43 brian-laptop kernel: [25046.620123]  [<ffffffffa0428d9e>]=
 iwl_mvm_mac_ctx_send+0x4e/0xa0 [iwlmvm]
May 16 11:45:43 brian-laptop kernel: [25046.620136]  [<ffffffffa042958c>]=
 iwl_mvm_mac_ctxt_changed+0x1c/0x80 [iwlmvm]
May 16 11:45:43 brian-laptop kernel: [25046.620147]  [<ffffffffa042571b>]=
 iwl_mvm_bss_info_changed+0xcb/0x420 [iwlmvm]
May 16 11:45:43 brian-laptop kernel: [25046.620172]  [<ffffffffa0360457>]=
 ieee80211_ifa_changed+0x127/0x220 [mac80211]
May 16 11:45:43 brian-laptop kernel: [25046.620179]  [<ffffffff81721fbc>]=
 notifier_call_chain+0x4c/0x70
May 16 11:45:43 brian-laptop kernel: [25046.620188]  [<ffffffff8108fd1d>]=
 __blocking_notifier_call_chain+0x4d/0x70
May 16 11:45:43 brian-laptop kernel: [25046.620196]  [<ffffffff8108fd56>]=
 blocking_notifier_call_chain+0x16/0x20
May 16 11:45:43 brian-laptop kernel: [25046.620203]  [<ffffffff81684c94>]=
 __inet_del_ifa+0x154/0x2b0
May 16 11:45:43 brian-laptop kernel: [25046.620209]  [<ffffffff81684f02>]=
 inet_rtm_deladdr+0x112/0x170
May 16 11:45:43 brian-laptop kernel: [25046.620217]  [<ffffffff81629539>]=
 rtnetlink_rcv_msg+0x99/0x260
May 16 11:45:43 brian-laptop kernel: [25046.620227]  [<ffffffff811a2778>]=
 ? __kmalloc_node_track_caller+0x58/0x1e0
May 16 11:45:43 brian-laptop kernel: [25046.620234]  [<ffffffff8160b45e>]=
 ? __alloc_skb+0x7e/0x2b0
May 16 11:45:43 brian-laptop kernel: [25046.620240]  [<ffffffff816294a0>]=
 ? rtnetlink_rcv+0x30/0x30
May 16 11:45:43 brian-laptop kernel: [25046.620247]  [<ffffffff81647a89>]=
 netlink_rcv_skb+0xa9/0xc0
May 16 11:45:43 brian-laptop kernel: [25046.620253]  [<ffffffff81629498>]=
 rtnetlink_rcv+0x28/0x30
May 16 11:45:43 brian-laptop kernel: [25046.620259]  [<ffffffff816470b5>]=
 netlink_unicast+0xd5/0x1b0
May 16 11:45:43 brian-laptop kernel: [25046.620265]  [<ffffffff8164748f>]=
 netlink_sendmsg+0x2ff/0x740
May 16 11:45:43 brian-laptop kernel: [25046.620273]  [<ffffffff8160254b>]=
 sock_sendmsg+0x8b/0xc0
May 16 11:45:43 brian-laptop kernel: [25046.620279]  [<ffffffff81721aa4>]=
 ? __do_page_fault+0x204/0x560
May 16 11:45:43 brian-laptop kernel: [25046.620286]  [<ffffffff816026f1>]=
 SYSC_sendto+0x121/0x1c0
May 16 11:45:43 brian-laptop kernel: [25046.620293]  [<ffffffff8109dd84>]=
 ? vtime_account_user+0x54/0x60
May 16 11:45:43 brian-laptop kernel: [25046.620302]  [<ffffffff81020d35>]=
 ? syscall_trace_enter+0x145/0x250
May 16 11:45:43 brian-laptop kernel: [25046.620309]  [<ffffffff816031fe>]=
 SyS_sendto+0xe/0x10
May 16 11:45:43 brian-laptop kernel: [25046.620316]  [<ffffffff817266bf>]=
 tracesys+0xe1/0xe6
May 16 11:45:43 brian-laptop kernel: [25046.620321] ---[ end trace f79bbc=
826d0c6d86 ]---
May 16 11:45:43 brian-laptop kernel: [25046.620359] iwlwifi 0000:01:00.0:=
 Start IWL Error Log Dump:
May 16 11:45:43 brian-laptop kernel: [25046.620376] iwlwifi 0000:01:00.0:=
 Status: 0x00000000, count: -1
May 16 11:45:43 brian-laptop kernel: [25046.620389] iwlwifi 0000:01:00.0:=
 Loaded firmware version: 22.24.8.0
May 16 11:45:43 brian-laptop kernel: [25046.620403] iwlwifi 0000:01:00.0:=
 0xA033333D | ADVANCED_SYSASSERT         =20
May 16 11:45:43 brian-laptop kernel: [25046.620416] iwlwifi 0000:01:00.0:=
 0xFFFFFFFF | uPc
May 16 11:45:43 brian-laptop kernel: [25046.620429] iwlwifi 0000:01:00.0:=
 0xFAD85728 | branchlink1
May 16 11:45:43 brian-laptop kernel: [25046.620442] iwlwifi 0000:01:00.0:=
 0xFFFF8801 | branchlink2
May 16 11:45:43 brian-laptop kernel: [25046.620455] iwlwifi 0000:01:00.0:=
 0x00000010 | interruptlink1
May 16 11:45:43 brian-laptop kernel: [25046.620468] iwlwifi 0000:01:00.0:=
 0xFFFF8801 | interruptlink2
May 16 11:45:43 brian-laptop kernel: [25046.620480] iwlwifi 0000:01:00.0:=
 0xFAD85780 | data1
May 16 11:45:43 brian-laptop kernel: [25046.620493] iwlwifi 0000:01:00.0:=
 0xFFFF8801 | data2
May 16 11:45:43 brian-laptop kernel: [25046.620506] iwlwifi 0000:01:00.0:=
 0xFAD85740 | data3
May 16 11:45:43 brian-laptop kernel: [25046.620519] iwlwifi 0000:01:00.0:=
 0xFFFF8801 | beacon time
May 16 11:45:43 brian-laptop kernel: [25046.620531] iwlwifi 0000:01:00.0:=
 0x813697AA | tsf low
May 16 11:45:43 brian-laptop kernel: [25046.620544] iwlwifi 0000:01:00.0:=
 0xFFFFFFFF | tsf hi
May 16 11:45:43 brian-laptop kernel: [25046.620553] iwlwifi 0000:01:00.0:=
 0x00000005 | time gp1
May 16 11:45:43 brian-laptop kernel: [25046.620557] iwlwifi 0000:01:00.0:=
 0x00000000 | time gp2
May 16 11:45:43 brian-laptop kernel: [25046.620561] iwlwifi 0000:01:00.0:=
 0xFAD85780 | time gp3
May 16 11:45:43 brian-laptop kernel: [25046.620565] iwlwifi 0000:01:00.0:=
 0xFFFF8801 | uCode version
May 16 11:45:43 brian-laptop kernel: [25046.620569] iwlwifi 0000:01:00.0:=
 0xA0335A30 | hw version
May 16 11:45:43 brian-laptop kernel: [25046.620573] iwlwifi 0000:01:00.0:=
 0xFFFFFFFF | board version
May 16 11:45:43 brian-laptop kernel: [25046.620577] iwlwifi 0000:01:00.0:=
 0x00000000 | hcmd
May 16 11:45:43 brian-laptop kernel: [25046.620580] iwlwifi 0000:01:00.0:=
 0xA03358E0 | isr0
May 16 11:45:43 brian-laptop kernel: [25046.620584] iwlwifi 0000:01:00.0:=
 0xFFFFFFFF | isr1
May 16 11:45:43 brian-laptop kernel: [25046.620588] iwlwifi 0000:01:00.0:=
 0xFAD85780 | isr2
May 16 11:45:43 brian-laptop kernel: [25046.620594] iwlwifi 0000:01:00.0:=
 0xFFFF8801 | isr3
May 16 11:45:43 brian-laptop kernel: [25046.620600] iwlwifi 0000:01:00.0:=
 0x00000028 | isr4
May 16 11:45:43 brian-laptop kernel: [25046.620606] iwlwifi 0000:01:00.0:=
 0xFFFFFFFF | isr_pref
May 16 11:45:43 brian-laptop kernel: [25046.620612] iwlwifi 0000:01:00.0:=
 0xFAD857F8 | wait_event
May 16 11:45:43 brian-laptop kernel: [25046.620618] iwlwifi 0000:01:00.0:=
 0xFFFF8801 | l2p_control
May 16 11:45:43 brian-laptop kernel: [25046.620624] iwlwifi 0000:01:00.0:=
 0xFAD85798 | l2p_duration
May 16 11:45:43 brian-laptop kernel: [25046.620630] iwlwifi 0000:01:00.0:=
 0xFFFF8801 | l2p_mhvalid
May 16 11:45:43 brian-laptop kernel: [25046.620637] iwlwifi 0000:01:00.0:=
 0xFAD857F8 | l2p_addr_match
May 16 11:45:43 brian-laptop kernel: [25046.620642] iwlwifi 0000:01:00.0:=
 0xFFFF8801 | lmpm_pmg_sel
May 16 11:45:43 brian-laptop kernel: [25046.620648] iwlwifi 0000:01:00.0:=
 0xFAD857A8 | timestamp
May 16 11:45:43 brian-laptop kernel: [25046.620654] iwlwifi 0000:01:00.0:=
 0xFFFF8801 | flow_handler
May 16 11:45:43 brian-laptop avahi-daemon[558]: Interface wlan0.IPv4 no l=
onger relevant for mDNS.
May 16 11:45:50 brian-laptop kernel: [25046.638390] ieee80211 phy0: Hardw=
are restart was requested
May 16 11:45:50 brian-laptop kernel: [25046.638403] iwlwifi 0000:01:00.0:=
 Failed to send MAC context (action:2): -110
May 16 11:45:50 brian-laptop kernel: [25046.638409] iwlwifi 0000:01:00.0:=
 failed to update MAC 5c:51:4f:63:1e:10
May 16 11:45:50 brian-laptop kernel: [25048.428637] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 0 [0x5a5a5a5a]
May 16 11:45:50 brian-laptop kernel: [25050.235879] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 2 [0x5a5a5a5a]
May 16 11:45:50 brian-laptop kernel: [25052.077238] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 5 [0x5a5a5a5a]
May 16 11:45:50 brian-laptop kernel: [25053.884487] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 7 [0x5a5a5a5a]
May 16 11:45:52 brian-laptop kernel: [25055.657526] iwlwifi 0000:01:00.0:=
 L1 Disabled; Enabling L0S
May 16 11:45:52 brian-laptop kernel: [25055.674976] [sched_delayed] sched=
: RT throttling activated
May 16 11:45:52 brian-laptop kernel: [25055.796613] iwlwifi 0000:01:00.0:=
 L1 Disabled; Enabling L0S
May 16 11:46:05 brian-laptop kernel: [25061.600256] iwlwifi 0000:01:00.0:=
 Failed to load firmware chunk!
May 16 11:46:05 brian-laptop kernel: [25061.600269] iwlwifi 0000:01:00.0:=
 Could not load the [0] uCode section
May 16 11:46:05 brian-laptop kernel: [25061.600280] iwlwifi 0000:01:00.0:=
 Failed to start RT ucode: -110
May 16 11:46:05 brian-laptop kernel: [25063.414118] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 0 [0x5a5a5a5a]
May 16 11:46:05 brian-laptop kernel: [25065.250133] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 2 [0x5a5a5a5a]
May 16 11:46:05 brian-laptop kernel: [25067.118774] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 5 [0x5a5a5a5a]
May 16 11:46:05 brian-laptop kernel: [25068.941031] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 7 [0x5a5a5a5a]
May 16 11:46:07 brian-laptop kernel: [25070.762535] wlan0: deauthenticati=
ng from 00:22:6b:54:68:d2 by local choice (reason=3D3)
May 16 11:46:07 brian-laptop kernel: [25070.762571] iwlwifi 0000:01:00.0:=
 iwl_trans_send_cmd bad state =3D 0
May 16 11:46:07 brian-laptop kernel: [25070.762575] wlan0: HW problem - c=
an not stop rx aggregation for 00:22:6b:54:68:d2 tid 0
May 16 11:46:07 brian-laptop kernel: [25070.762647] iwlwifi 0000:01:00.0:=
 offset 0 not used in fw key table.
May 16 11:46:07 brian-laptop kernel: [25070.762651] wlan0: failed to remo=
ve key (0, 00:22:6b:54:68:d2) from hardware (-2)
May 16 11:46:07 brian-laptop kernel: [25070.762694] ------------[ cut her=
e ]------------
May 16 11:46:07 brian-laptop kernel: [25070.762714] WARNING: CPU: 0 PID: =
14026 at /build/buildd/linux-3.13.0/drivers/net/wireless/iwlwifi/mvm/mac8=
0211.c:1145 iwl_mvm_mac_sta_state+0x27c/0x290 [iwlmvm]()
May 16 11:46:07 brian-laptop kernel: [25070.762716] Modules linked in: cd=
c_acm ctr ccm hid_sensor_als hid_sensor_magn_3d hid_sensor_gyro_3d hid_se=
nsor_accel_3d hid_sensor_trigger industrialio_triggered_buffer kfifo_buf =
industrialio hid_sensor_iio_common hid_multitouch hid_sensor_hub uvcvideo=
 videobuf2_vmalloc videobuf2_memops videobuf2_core usbhid hid videodev bt=
usb snd_hda_codec_hdmi snd_hda_codec_realtek joydev arc4 intel_rapl x86_p=
kg_temp_thermal intel_powerclamp coretemp kvm bnep rfcomm crct10dif_pclmu=
l bluetooth crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw g=
f128mul glue_helper ablk_helper cryptd iwlmvm mac80211 psmouse serio_raw =
snd_hda_intel iwlwifi snd_hda_codec snd_hwdep cfg80211 snd_pcm snd_page_a=
lloc snd_seq_midi snd_seq_midi_event snd_rawmidi i915 intel_smartconnect =
snd_seq snd_seq_device mac_hid video snd_timer drm_kms_helper parport_pc =
drm snd i2c_algo_bit mei_me ppdev nls_iso8859_1 mei soundcore lpc_ich lp =
parport ahci libahci
May 16 11:46:07 brian-laptop kernel: [25070.762797] CPU: 0 PID: 14026 Com=
m: ip Tainted: G        W    3.13.0-24-generic #47-Ubuntu
May 16 11:46:07 brian-laptop kernel: [25070.762799] Hardware name: LENOVO=
 20266/Yoga2, BIOS 76CN27WW 09/17/2013
May 16 11:46:07 brian-laptop kernel: [25070.762802]  0000000000000009 fff=
f8801eda8d3b0 ffffffff81715ac4 0000000000000000
May 16 11:46:07 brian-laptop kernel: [25070.762808]  ffff8801eda8d3e8 fff=
fffff810676bd ffff8802516417c0 0000000000000004
May 16 11:46:07 brian-laptop kernel: [25070.762813]  0000000000000003 fff=
f880251c612b8 ffff880251110000 ffff8801eda8d3f8
May 16 11:46:07 brian-laptop kernel: [25070.762818] Call Trace:
May 16 11:46:07 brian-laptop kernel: [25070.762828]  [<ffffffff81715ac4>]=
 dump_stack+0x45/0x56
May 16 11:46:07 brian-laptop kernel: [25070.762834]  [<ffffffff810676bd>]=
 warn_slowpath_common+0x7d/0xa0
May 16 11:46:07 brian-laptop kernel: [25070.762839]  [<ffffffff8106779a>]=
 warn_slowpath_null+0x1a/0x20
May 16 11:46:07 brian-laptop kernel: [25070.762849]  [<ffffffffa042493c>]=
 iwl_mvm_mac_sta_state+0x27c/0x290 [iwlmvm]
May 16 11:46:07 brian-laptop kernel: [25070.762869]  [<ffffffffa03642ff>]=
 sta_info_move_state+0x1bf/0x680 [mac80211]
May 16 11:46:07 brian-laptop kernel: [25070.762884]  [<ffffffffa03648bb>]=
 __sta_info_destroy+0xfb/0x360 [mac80211]
May 16 11:46:07 brian-laptop kernel: [25070.762900]  [<ffffffffa0364c65>]=
 sta_info_flush_defer+0x85/0xb0 [mac80211]
May 16 11:46:07 brian-laptop kernel: [25070.762926]  [<ffffffffa03a1600>]=
 ieee80211_set_disassoc+0xb0/0x3d0 [mac80211]
May 16 11:46:07 brian-laptop kernel: [25070.762948]  [<ffffffffa03a5903>]=
 ieee80211_mgd_deauth+0x1d3/0x240 [mac80211]
May 16 11:46:07 brian-laptop kernel: [25070.762967]  [<ffffffffa0377c38>]=
 ieee80211_deauth+0x18/0x20 [mac80211]
May 16 11:46:07 brian-laptop kernel: [25070.762989]  [<ffffffffa025695c>]=
 cfg80211_mlme_deauth+0x9c/0x140 [cfg80211]
May 16 11:46:07 brian-laptop kernel: [25070.763007]  [<ffffffffa0256c0b>]=
 cfg80211_mlme_down+0x6b/0x90 [cfg80211]
May 16 11:46:07 brian-laptop kernel: [25070.763026]  [<ffffffffa025a94b>]=
 cfg80211_disconnect+0x18b/0x1b0 [cfg80211]
May 16 11:46:07 brian-laptop kernel: [25070.763043]  [<ffffffffa023e77c>]=
 ? __cfg80211_stop_sched_scan+0x1c/0x130 [cfg80211]
May 16 11:46:07 brian-laptop kernel: [25070.763057]  [<ffffffffa0235a84>]=
 cfg80211_leave+0xc4/0xe0 [cfg80211]
May 16 11:46:07 brian-laptop kernel: [25070.763071]  [<ffffffffa0235e3b>]=
 cfg80211_netdev_notifier_call+0x39b/0x610 [cfg80211]
May 16 11:46:07 brian-laptop kernel: [25070.763077]  [<ffffffff816861c8>]=
 ? inetdev_event+0x38/0x510
May 16 11:46:07 brian-laptop kernel: [25070.763083]  [<ffffffff81721fbc>]=
 notifier_call_chain+0x4c/0x70
May 16 11:46:07 brian-laptop kernel: [25070.763090]  [<ffffffff8108fb46>]=
 raw_notifier_call_chain+0x16/0x20
May 16 11:46:07 brian-laptop kernel: [25070.763094]  [<ffffffff81616395>]=
 call_netdevice_notifiers_info+0x35/0x60
May 16 11:46:07 brian-laptop kernel: [25070.763098]  [<ffffffff81616489>]=
 __dev_close_many+0x49/0xe0
May 16 11:46:07 brian-laptop kernel: [25070.763102]  [<ffffffff8161656d>]=
 __dev_close+0x4d/0x90
May 16 11:46:07 brian-laptop kernel: [25070.763108]  [<ffffffff8161db8d>]=
 __dev_change_flags+0x9d/0x170
May 16 11:46:07 brian-laptop kernel: [25070.763112]  [<ffffffff8161dc89>]=
 dev_change_flags+0x29/0x60
May 16 11:46:07 brian-laptop kernel: [25070.763130]  [<ffffffff8162b782>]=
 do_setlink+0x312/0x9e0
May 16 11:46:07 brian-laptop kernel: [25070.763139]  [<ffffffff81384ea2>]=
 ? nla_parse+0x32/0xe0
May 16 11:46:07 brian-laptop kernel: [25070.763144]  [<ffffffff8162cab4>]=
 rtnl_newlink+0x394/0x5d0
May 16 11:46:07 brian-laptop kernel: [25070.763152]  [<ffffffff81365a62>]=
 ? put_dec+0x72/0x90
May 16 11:46:07 brian-laptop kernel: [25070.763160]  [<ffffffff8130d74d>]=
 ? apparmor_capable+0x1d/0x130
May 16 11:46:07 brian-laptop kernel: [25070.763164]  [<ffffffff81629539>]=
 rtnetlink_rcv_msg+0x99/0x260
May 16 11:46:07 brian-laptop kernel: [25070.763172]  [<ffffffff811a2778>]=
 ? __kmalloc_node_track_caller+0x58/0x1e0
May 16 11:46:07 brian-laptop kernel: [25070.763179]  [<ffffffff8116c409>]=
 ? zone_statistics+0x89/0xa0
May 16 11:46:07 brian-laptop kernel: [25070.763185]  [<ffffffff8160b45e>]=
 ? __alloc_skb+0x7e/0x2b0
May 16 11:46:07 brian-laptop kernel: [25070.763189]  [<ffffffff816294a0>]=
 ? rtnetlink_rcv+0x30/0x30
May 16 11:46:07 brian-laptop kernel: [25070.763195]  [<ffffffff81647a89>]=
 netlink_rcv_skb+0xa9/0xc0
May 16 11:46:07 brian-laptop kernel: [25070.763199]  [<ffffffff81629498>]=
 rtnetlink_rcv+0x28/0x30
May 16 11:46:07 brian-laptop kernel: [25070.763204]  [<ffffffff816470b5>]=
 netlink_unicast+0xd5/0x1b0
May 16 11:46:07 brian-laptop kernel: [25070.763208]  [<ffffffff8164748f>]=
 netlink_sendmsg+0x2ff/0x740
May 16 11:46:07 brian-laptop kernel: [25070.763214]  [<ffffffff8160254b>]=
 sock_sendmsg+0x8b/0xc0
May 16 11:46:07 brian-laptop kernel: [25070.763222]  [<ffffffff811af0f6>]=
 ? __mem_cgroup_commit_charge+0x156/0x3d0
May 16 11:46:07 brian-laptop kernel: [25070.763227]  [<ffffffff8160223e>]=
 ? move_addr_to_kernel.part.16+0x1e/0x60
May 16 11:46:07 brian-laptop kernel: [25070.763232]  [<ffffffff81602df1>]=
 ? move_addr_to_kernel+0x21/0x30
May 16 11:46:07 brian-laptop kernel: [25070.763237]  [<ffffffff81602db9>]=
 ___sys_sendmsg+0x3a9/0x3c0
May 16 11:46:07 brian-laptop kernel: [25070.763242]  [<ffffffff81721aa4>]=
 ? __do_page_fault+0x204/0x560
May 16 11:46:07 brian-laptop kernel: [25070.763251]  [<ffffffff811112fc>]=
 ? acct_account_cputime+0x1c/0x20
May 16 11:46:07 brian-laptop kernel: [25070.763256]  [<ffffffff8109d76b>]=
 ? account_user_time+0x8b/0xa0
May 16 11:46:07 brian-laptop kernel: [25070.763261]  [<ffffffff816034c2>]=
 __sys_sendmsg+0x42/0x80
May 16 11:46:07 brian-laptop kernel: [25070.763267]  [<ffffffff81603512>]=
 SyS_sendmsg+0x12/0x20
May 16 11:46:07 brian-laptop kernel: [25070.763272]  [<ffffffff817266bf>]=
 tracesys+0xe1/0xe6
May 16 11:46:07 brian-laptop kernel: [25070.763275] ---[ end trace f79bbc=
826d0c6d87 ]---
May 16 11:46:07 brian-laptop kernel: [25070.763278] ------------[ cut her=
e ]------------
May 16 11:46:07 brian-laptop kernel: [25070.763292] WARNING: CPU: 0 PID: =
14026 at /build/buildd/linux-3.13.0/net/mac80211/sta_info.c:856 __sta_inf=
o_destroy+0x1be/0x360 [mac80211]()
May 16 11:46:07 brian-laptop kernel: [25070.763294] Modules linked in: cd=
c_acm ctr ccm hid_sensor_als hid_sensor_magn_3d hid_sensor_gyro_3d hid_se=
nsor_accel_3d hid_sensor_trigger industrialio_triggered_buffer kfifo_buf =
industrialio hid_sensor_iio_common hid_multitouch hid_sensor_hub uvcvideo=
 videobuf2_vmalloc videobuf2_memops videobuf2_core usbhid hid videodev bt=
usb snd_hda_codec_hdmi snd_hda_codec_realtek joydev arc4 intel_rapl x86_p=
kg_temp_thermal intel_powerclamp coretemp kvm bnep rfcomm crct10dif_pclmu=
l bluetooth crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw g=
f128mul glue_helper ablk_helper cryptd iwlmvm mac80211 psmouse serio_raw =
snd_hda_intel iwlwifi snd_hda_codec snd_hwdep cfg80211 snd_pcm snd_page_a=
lloc snd_seq_midi snd_seq_midi_event snd_rawmidi i915 intel_smartconnect =
snd_seq snd_seq_device mac_hid video snd_timer drm_kms_helper parport_pc =
drm snd i2c_algo_bit mei_me ppdev nls_iso8859_1 mei soundcore lpc_ich lp =
parport ahci libahci
May 16 11:46:07 brian-laptop kernel: [25070.763365] CPU: 0 PID: 14026 Com=
m: ip Tainted: G        W    3.13.0-24-generic #47-Ubuntu
May 16 11:46:07 brian-laptop kernel: [25070.763367] Hardware name: LENOVO=
 20266/Yoga2, BIOS 76CN27WW 09/17/2013
May 16 11:46:07 brian-laptop kernel: [25070.763369]  0000000000000009 fff=
f8801eda8d458 ffffffff81715ac4 0000000000000000
May 16 11:46:07 brian-laptop kernel: [25070.763375]  ffff8801eda8d490 fff=
fffff810676bd ffff880251640600 ffff880251c60880
May 16 11:46:07 brian-laptop kernel: [25070.763380]  ffff880251640820 fff=
f880251640858 ffff880251110000 ffff8801eda8d4a0
May 16 11:46:07 brian-laptop kernel: [25070.763385] Call Trace:
May 16 11:46:07 brian-laptop kernel: [25070.763390]  [<ffffffff81715ac4>]=
 dump_stack+0x45/0x56
May 16 11:46:07 brian-laptop kernel: [25070.763395]  [<ffffffff810676bd>]=
 warn_slowpath_common+0x7d/0xa0
May 16 11:46:07 brian-laptop kernel: [25070.763399]  [<ffffffff8106779a>]=
 warn_slowpath_null+0x1a/0x20
May 16 11:46:07 brian-laptop kernel: [25070.763415]  [<ffffffffa036497e>]=
 __sta_info_destroy+0x1be/0x360 [mac80211]
May 16 11:46:07 brian-laptop kernel: [25070.763430]  [<ffffffffa0364c65>]=
 sta_info_flush_defer+0x85/0xb0 [mac80211]
May 16 11:46:07 brian-laptop kernel: [25070.763452]  [<ffffffffa03a1600>]=
 ieee80211_set_disassoc+0xb0/0x3d0 [mac80211]
May 16 11:46:07 brian-laptop kernel: [25070.763473]  [<ffffffffa03a5903>]=
 ieee80211_mgd_deauth+0x1d3/0x240 [mac80211]
May 16 11:46:07 brian-laptop kernel: [25070.763492]  [<ffffffffa0377c38>]=
 ieee80211_deauth+0x18/0x20 [mac80211]
May 16 11:46:07 brian-laptop kernel: [25070.763511]  [<ffffffffa025695c>]=
 cfg80211_mlme_deauth+0x9c/0x140 [cfg80211]
May 16 11:46:07 brian-laptop kernel: [25070.763528]  [<ffffffffa0256c0b>]=
 cfg80211_mlme_down+0x6b/0x90 [cfg80211]
May 16 11:46:07 brian-laptop kernel: [25070.763546]  [<ffffffffa025a94b>]=
 cfg80211_disconnect+0x18b/0x1b0 [cfg80211]
May 16 11:46:07 brian-laptop kernel: [25070.763563]  [<ffffffffa023e77c>]=
 ? __cfg80211_stop_sched_scan+0x1c/0x130 [cfg80211]
May 16 11:46:07 brian-laptop kernel: [25070.763577]  [<ffffffffa0235a84>]=
 cfg80211_leave+0xc4/0xe0 [cfg80211]
May 16 11:46:07 brian-laptop kernel: [25070.763591]  [<ffffffffa0235e3b>]=
 cfg80211_netdev_notifier_call+0x39b/0x610 [cfg80211]
May 16 11:46:07 brian-laptop kernel: [25070.763595]  [<ffffffff816861c8>]=
 ? inetdev_event+0x38/0x510
May 16 11:46:07 brian-laptop kernel: [25070.763601]  [<ffffffff81721fbc>]=
 notifier_call_chain+0x4c/0x70
May 16 11:46:07 brian-laptop kernel: [25070.763607]  [<ffffffff8108fb46>]=
 raw_notifier_call_chain+0x16/0x20
May 16 11:46:07 brian-laptop kernel: [25070.763631]  [<ffffffff81616395>]=
 call_netdevice_notifiers_info+0x35/0x60
May 16 11:46:07 brian-laptop kernel: [25070.763635]  [<ffffffff81616489>]=
 __dev_close_many+0x49/0xe0
May 16 11:46:07 brian-laptop kernel: [25070.763638]  [<ffffffff8161656d>]=
 __dev_close+0x4d/0x90
May 16 11:46:07 brian-laptop kernel: [25070.763643]  [<ffffffff8161db8d>]=
 __dev_change_flags+0x9d/0x170
May 16 11:46:07 brian-laptop kernel: [25070.763648]  [<ffffffff8161dc89>]=
 dev_change_flags+0x29/0x60
May 16 11:46:07 brian-laptop kernel: [25070.763653]  [<ffffffff8162b782>]=
 do_setlink+0x312/0x9e0
May 16 11:46:07 brian-laptop kernel: [25070.763666]  [<ffffffff81384ea2>]=
 ? nla_parse+0x32/0xe0
May 16 11:46:07 brian-laptop kernel: [25070.763685]  [<ffffffff8162cab4>]=
 rtnl_newlink+0x394/0x5d0
May 16 11:46:07 brian-laptop kernel: [25070.763704]  [<ffffffff81365a62>]=
 ? put_dec+0x72/0x90
May 16 11:46:07 brian-laptop kernel: [25070.763723]  [<ffffffff8130d74d>]=
 ? apparmor_capable+0x1d/0x130
May 16 11:46:07 brian-laptop kernel: [25070.763740]  [<ffffffff81629539>]=
 rtnetlink_rcv_msg+0x99/0x260
May 16 11:46:07 brian-laptop kernel: [25070.763759]  [<ffffffff811a2778>]=
 ? __kmalloc_node_track_caller+0x58/0x1e0
May 16 11:46:07 brian-laptop kernel: [25070.763777]  [<ffffffff8116c409>]=
 ? zone_statistics+0x89/0xa0
May 16 11:46:07 brian-laptop kernel: [25070.763794]  [<ffffffff8160b45e>]=
 ? __alloc_skb+0x7e/0x2b0
May 16 11:46:07 brian-laptop kernel: [25070.763812]  [<ffffffff816294a0>]=
 ? rtnetlink_rcv+0x30/0x30
May 16 11:46:07 brian-laptop kernel: [25070.763829]  [<ffffffff81647a89>]=
 netlink_rcv_skb+0xa9/0xc0
May 16 11:46:07 brian-laptop kernel: [25070.763837]  [<ffffffff81629498>]=
 rtnetlink_rcv+0x28/0x30
May 16 11:46:07 brian-laptop kernel: [25070.763842]  [<ffffffff816470b5>]=
 netlink_unicast+0xd5/0x1b0
May 16 11:46:07 brian-laptop kernel: [25070.763847]  [<ffffffff8164748f>]=
 netlink_sendmsg+0x2ff/0x740
May 16 11:46:07 brian-laptop kernel: [25070.763852]  [<ffffffff8160254b>]=
 sock_sendmsg+0x8b/0xc0
May 16 11:46:07 brian-laptop kernel: [25070.763858]  [<ffffffff811af0f6>]=
 ? __mem_cgroup_commit_charge+0x156/0x3d0
May 16 11:46:07 brian-laptop kernel: [25070.763863]  [<ffffffff8160223e>]=
 ? move_addr_to_kernel.part.16+0x1e/0x60
May 16 11:46:07 brian-laptop kernel: [25070.763870]  [<ffffffff81602df1>]=
 ? move_addr_to_kernel+0x21/0x30
May 16 11:46:07 brian-laptop kernel: [25070.763877]  [<ffffffff81602db9>]=
 ___sys_sendmsg+0x3a9/0x3c0
May 16 11:46:07 brian-laptop kernel: [25070.763884]  [<ffffffff81721aa4>]=
 ? __do_page_fault+0x204/0x560
May 16 11:46:07 brian-laptop kernel: [25070.763892]  [<ffffffff811112fc>]=
 ? acct_account_cputime+0x1c/0x20
May 16 11:46:07 brian-laptop kernel: [25070.763899]  [<ffffffff8109d76b>]=
 ? account_user_time+0x8b/0xa0
May 16 11:46:07 brian-laptop kernel: [25070.763906]  [<ffffffff816034c2>]=
 __sys_sendmsg+0x42/0x80
May 16 11:46:07 brian-laptop kernel: [25070.763927]  [<ffffffff81603512>]=
 SyS_sendmsg+0x12/0x20
May 16 11:46:07 brian-laptop kernel: [25070.763937]  [<ffffffff817266bf>]=
 tracesys+0xe1/0xe6
May 16 11:46:07 brian-laptop kernel: [25070.763943] ---[ end trace f79bbc=
826d0c6d88 ]---
May 16 11:46:07 brian-laptop kernel: [25070.763970] ------------[ cut her=
e ]------------
May 16 11:46:07 brian-laptop kernel: [25070.764001] WARNING: CPU: 0 PID: =
14026 at /build/buildd/linux-3.13.0/net/mac80211/sta_info.c:864 __sta_inf=
o_destroy+0x265/0x360 [mac80211]()
May 16 11:46:07 brian-laptop kernel: [25070.764006] Modules linked in: cd=
c_acm ctr ccm hid_sensor_als hid_sensor_magn_3d hid_sensor_gyro_3d hid_se=
nsor_accel_3d hid_sensor_trigger industrialio_triggered_buffer kfifo_buf =
industrialio hid_sensor_iio_common hid_multitouch hid_sensor_hub uvcvideo=
 videobuf2_vmalloc videobuf2_memops videobuf2_core usbhid hid videodev bt=
usb snd_hda_codec_hdmi snd_hda_codec_realtek joydev arc4 intel_rapl x86_p=
kg_temp_thermal intel_powerclamp coretemp kvm bnep rfcomm crct10dif_pclmu=
l bluetooth crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw g=
f128mul glue_helper ablk_helper cryptd iwlmvm mac80211 psmouse serio_raw =
snd_hda_intel iwlwifi snd_hda_codec snd_hwdep cfg80211 snd_pcm snd_page_a=
lloc snd_seq_midi snd_seq_midi_event snd_rawmidi i915 intel_smartconnect =
snd_seq snd_seq_device mac_hid video snd_timer drm_kms_helper parport_pc =
drm snd i2c_algo_bit mei_me ppdev nls_iso8859_1 mei soundcore lpc_ich lp =
parport ahci libahci
May 16 11:46:07 brian-laptop kernel: [25070.764269] CPU: 0 PID: 14026 Com=
m: ip Tainted: G        W    3.13.0-24-generic #47-Ubuntu
May 16 11:46:07 brian-laptop kernel: [25070.764274] Hardware name: LENOVO=
 20266/Yoga2, BIOS 76CN27WW 09/17/2013
May 16 11:46:07 brian-laptop kernel: [25070.764278]  0000000000000009 fff=
f8801eda8d458 ffffffff81715ac4 0000000000000000
May 16 11:46:07 brian-laptop kernel: [25070.764290]  ffff8801eda8d490 fff=
fffff810676bd ffff880251640600 ffff880251c60880
May 16 11:46:07 brian-laptop kernel: [25070.764301]  ffff880251c60880 000=
00000ffffffea ffff880251110000 ffff8801eda8d4a0
May 16 11:46:07 brian-laptop kernel: [25070.764313] Call Trace:
May 16 11:46:07 brian-laptop kernel: [25070.764335]  [<ffffffff81715ac4>]=
 dump_stack+0x45/0x56
May 16 11:46:07 brian-laptop kernel: [25070.764345]  [<ffffffff810676bd>]=
 warn_slowpath_common+0x7d/0xa0
May 16 11:46:07 brian-laptop kernel: [25070.764354]  [<ffffffff8106779a>]=
 warn_slowpath_null+0x1a/0x20
May 16 11:46:07 brian-laptop kernel: [25070.764384]  [<ffffffffa0364a25>]=
 __sta_info_destroy+0x265/0x360 [mac80211]
May 16 11:46:07 brian-laptop kernel: [25070.764435]  [<ffffffffa0364c65>]=
 sta_info_flush_defer+0x85/0xb0 [mac80211]
May 16 10:53:43 brian-laptop wpa_supplicant[2784]: wlan0: WPA: Group reke=
ying completed with 00:22:6b:54:68:d2 [GTK=3DTKIP]
May 16 11:46:07 brian-laptop wpa_supplicant[2784]: wlan0: CTRL-EVENT-DISC=
ONNECTED bssid=3D00:22:6b:54:68:d2 reason=3D3 locally_generated=3D1
May 16 11:46:07 brian-laptop kernel: [25070.764485]  [<ffffffffa03a1600>]=
 ieee80211_set_disassoc+0xb0/0x3d0 [mac80211]
May 16 11:46:07 brian-laptop kernel: [25070.764526]  [<ffffffffa03a5903>]=
 ieee80211_mgd_deauth+0x1d3/0x240 [mac80211]
May 16 11:46:07 brian-laptop kernel: [25070.764563]  [<ffffffffa0377c38>]=
 ieee80211_deauth+0x18/0x20 [mac80211]
May 16 11:46:07 brian-laptop kernel: [25070.764598]  [<ffffffffa025695c>]=
 cfg80211_mlme_deauth+0x9c/0x140 [cfg80211]
May 16 11:46:07 brian-laptop kernel: [25070.764631]  [<ffffffffa0256c0b>]=
 cfg80211_mlme_down+0x6b/0x90 [cfg80211]
May 16 11:46:07 brian-laptop kernel: [25070.764665]  [<ffffffffa025a94b>]=
 cfg80211_disconnect+0x18b/0x1b0 [cfg80211]
May 16 11:46:07 brian-laptop kernel: [25070.764698]  [<ffffffffa023e77c>]=
 ? __cfg80211_stop_sched_scan+0x1c/0x130 [cfg80211]
May 16 11:46:07 brian-laptop kernel: [25070.764726]  [<ffffffffa0235a84>]=
 cfg80211_leave+0xc4/0xe0 [cfg80211]
May 16 11:46:07 brian-laptop kernel: [25070.764754]  [<ffffffffa0235e3b>]=
 cfg80211_netdev_notifier_call+0x39b/0x610 [cfg80211]
May 16 11:46:07 brian-laptop kernel: [25070.764763]  [<ffffffff816861c8>]=
 ? inetdev_event+0x38/0x510
May 16 11:46:07 brian-laptop kernel: [25070.764775]  [<ffffffff81721fbc>]=
 notifier_call_chain+0x4c/0x70
May 16 11:46:07 brian-laptop kernel: [25070.764787]  [<ffffffff8108fb46>]=
 raw_notifier_call_chain+0x16/0x20
May 16 11:46:07 brian-laptop kernel: [25070.764797]  [<ffffffff81616395>]=
 call_netdevice_notifiers_info+0x35/0x60
May 16 11:46:07 brian-laptop kernel: [25070.764805]  [<ffffffff81616489>]=
 __dev_close_many+0x49/0xe0
May 16 11:46:07 brian-laptop kernel: [25070.764814]  [<ffffffff8161656d>]=
 __dev_close+0x4d/0x90
May 16 11:46:07 brian-laptop kernel: [25070.764825]  [<ffffffff8161db8d>]=
 __dev_change_flags+0x9d/0x170
May 16 11:46:07 brian-laptop kernel: [25070.764835]  [<ffffffff8161dc89>]=
 dev_change_flags+0x29/0x60
May 16 11:46:07 brian-laptop kernel: [25070.764845]  [<ffffffff8162b782>]=
 do_setlink+0x312/0x9e0
May 16 11:46:07 brian-laptop kernel: [25070.764860]  [<ffffffff81384ea2>]=
 ? nla_parse+0x32/0xe0
May 16 11:46:07 brian-laptop kernel: [25070.764870]  [<ffffffff8162cab4>]=
 rtnl_newlink+0x394/0x5d0
May 16 11:46:07 brian-laptop kernel: [25070.764884]  [<ffffffff81365a62>]=
 ? put_dec+0x72/0x90
May 16 11:46:07 brian-laptop kernel: [25070.764896]  [<ffffffff8130d74d>]=
 ? apparmor_capable+0x1d/0x130
May 16 11:46:07 brian-laptop kernel: [25070.764906]  [<ffffffff81629539>]=
 rtnetlink_rcv_msg+0x99/0x260
May 16 11:46:07 brian-laptop kernel: [25070.764918]  [<ffffffff811a2778>]=
 ? __kmalloc_node_track_caller+0x58/0x1e0
May 16 11:46:07 brian-laptop kernel: [25070.764929]  [<ffffffff8116c409>]=
 ? zone_statistics+0x89/0xa0
May 16 11:46:07 brian-laptop kernel: [25070.764939]  [<ffffffff8160b45e>]=
 ? __alloc_skb+0x7e/0x2b0
May 16 11:46:07 brian-laptop kernel: [25070.764949]  [<ffffffff816294a0>]=
 ? rtnetlink_rcv+0x30/0x30
May 16 11:46:07 brian-laptop kernel: [25070.764959]  [<ffffffff81647a89>]=
 netlink_rcv_skb+0xa9/0xc0
May 16 11:46:07 brian-laptop kernel: [25070.764968]  [<ffffffff81629498>]=
 rtnetlink_rcv+0x28/0x30
May 16 11:46:07 brian-laptop kernel: [25070.764978]  [<ffffffff816470b5>]=
 netlink_unicast+0xd5/0x1b0
May 16 11:46:07 brian-laptop kernel: [25070.764988]  [<ffffffff8164748f>]=
 netlink_sendmsg+0x2ff/0x740
May 16 11:46:07 brian-laptop kernel: [25070.764999]  [<ffffffff8160254b>]=
 sock_sendmsg+0x8b/0xc0
May 16 11:46:07 brian-laptop kernel: [25070.765010]  [<ffffffff811af0f6>]=
 ? __mem_cgroup_commit_charge+0x156/0x3d0
May 16 11:46:07 brian-laptop kernel: [25070.765021]  [<ffffffff8160223e>]=
 ? move_addr_to_kernel.part.16+0x1e/0x60
May 16 11:46:07 brian-laptop kernel: [25070.765031]  [<ffffffff81602df1>]=
 ? move_addr_to_kernel+0x21/0x30
May 16 11:46:07 brian-laptop kernel: [25070.765042]  [<ffffffff81602db9>]=
 ___sys_sendmsg+0x3a9/0x3c0
May 16 11:46:07 brian-laptop kernel: [25070.765053]  [<ffffffff81721aa4>]=
 ? __do_page_fault+0x204/0x560
May 16 11:46:07 brian-laptop kernel: [25070.765066]  [<ffffffff811112fc>]=
 ? acct_account_cputime+0x1c/0x20
May 16 11:46:07 brian-laptop kernel: [25070.765075]  [<ffffffff8109d76b>]=
 ? account_user_time+0x8b/0xa0
May 16 11:46:07 brian-laptop kernel: [25070.765087]  [<ffffffff816034c2>]=
 __sys_sendmsg+0x42/0x80
May 16 11:46:07 brian-laptop kernel: [25070.765097]  [<ffffffff81603512>]=
 SyS_sendmsg+0x12/0x20
May 16 11:46:07 brian-laptop kernel: [25070.765108]  [<ffffffff817266bf>]=
 tracesys+0xe1/0xe6
May 16 11:46:07 brian-laptop kernel: [25070.765115] ---[ end trace f79bbc=
826d0c6d89 ]---
May 16 11:46:07 brian-laptop kernel: [25070.765288] ------------[ cut her=
e ]------------
May 16 11:46:07 brian-laptop kernel: [25070.765309] WARNING: CPU: 0 PID: =
14026 at /build/buildd/linux-3.13.0/drivers/net/wireless/iwlwifi/mvm/mac-=
ctxt.c:1097 iwl_mvm_mac_ctxt_changed+0x6e/0x80 [iwlmvm]()
May 16 11:46:07 brian-laptop kernel: [25070.765315] Changing inactive MAC=
 5c:51:4f:63:1e:10/2
May 16 11:46:07 brian-laptop kernel: [25070.765318] Modules linked in: cd=
c_acm ctr ccm hid_sensor_als hid_sensor_magn_3d hid_sensor_gyro_3d hid_se=
nsor_accel_3d hid_sensor_trigger industrialio_triggered_buffer kfifo_buf =
industrialio hid_sensor_iio_common hid_multitouch hid_sensor_hub uvcvideo=
 videobuf2_vmalloc videobuf2_memops videobuf2_core usbhid hid videodev bt=
usb snd_hda_codec_hdmi snd_hda_codec_realtek joydev arc4 intel_rapl x86_p=
kg_temp_thermal intel_powerclamp coretemp kvm bnep rfcomm crct10dif_pclmu=
l bluetooth crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw g=
f128mul glue_helper ablk_helper cryptd iwlmvm mac80211 psmouse serio_raw =
snd_hda_intel iwlwifi snd_hda_codec snd_hwdep cfg80211 snd_pcm snd_page_a=
lloc snd_seq_midi snd_seq_midi_event snd_rawmidi i915 intel_smartconnect =
snd_seq snd_seq_device mac_hid video snd_timer drm_kms_helper parport_pc =
drm snd i2c_algo_bit mei_me ppdev nls_iso8859_1 mei soundcore lpc_ich lp =
parport ahci libahci
May 16 11:46:07 brian-laptop kernel: [25070.765455] CPU: 0 PID: 14026 Com=
m: ip Tainted: G        W    3.13.0-24-generic #47-Ubuntu
May 16 11:46:07 brian-laptop kernel: [25070.765460] Hardware name: LENOVO=
 20266/Yoga2, BIOS 76CN27WW 09/17/2013
May 16 11:46:07 brian-laptop kernel: [25070.765464]  0000000000000009 fff=
f8801eda8d3e0 ffffffff81715ac4 ffff8801eda8d428
May 16 11:46:07 brian-laptop kernel: [25070.765474]  ffff8801eda8d418 fff=
fffff810676bd ffff8802516417c0 ffff880251c612b8
May 16 11:46:07 brian-laptop kernel: [25070.765485]  ffff880251641800 000=
000000000209f ffff8802516417d0 ffff8801eda8d478
May 16 11:46:07 brian-laptop kernel: [25070.765495] Call Trace:
May 16 11:46:07 brian-laptop kernel: [25070.765506]  [<ffffffff81715ac4>]=
 dump_stack+0x45/0x56
May 16 11:46:07 brian-laptop kernel: [25070.765537]  [<ffffffff810676bd>]=
 warn_slowpath_common+0x7d/0xa0
May 16 11:46:07 brian-laptop kernel: [25070.765546]  [<ffffffff8106772c>]=
 warn_slowpath_fmt+0x4c/0x50
May 16 11:46:07 brian-laptop kernel: [25070.765567]  [<ffffffffa04295de>]=
 iwl_mvm_mac_ctxt_changed+0x6e/0x80 [iwlmvm]
May 16 11:46:07 brian-laptop kernel: [25070.765582]  [<ffffffffa042571b>]=
 iwl_mvm_bss_info_changed+0xcb/0x420 [iwlmvm]
May 16 11:46:07 brian-laptop kernel: [25070.765609]  [<ffffffffa0360bf7>]=
 ieee80211_bss_info_change_notify+0x97/0x1c0 [mac80211]
May 16 11:46:07 brian-laptop kernel: [25070.765638]  [<ffffffffa03a174f>]=
 ieee80211_set_disassoc+0x1ff/0x3d0 [mac80211]
May 16 11:46:07 brian-laptop kernel: [25070.765664]  [<ffffffffa03a5903>]=
 ieee80211_mgd_deauth+0x1d3/0x240 [mac80211]
May 16 11:46:07 brian-laptop kernel: [25070.765687]  [<ffffffffa0377c38>]=
 ieee80211_deauth+0x18/0x20 [mac80211]
May 16 11:46:07 brian-laptop kernel: [25070.765711]  [<ffffffffa025695c>]=
 cfg80211_mlme_deauth+0x9c/0x140 [cfg80211]
May 16 11:46:07 brian-laptop kernel: [25070.765732]  [<ffffffffa0256c0b>]=
 cfg80211_mlme_down+0x6b/0x90 [cfg80211]
May 16 11:46:07 brian-laptop kernel: [25070.765755]  [<ffffffffa025a94b>]=
 cfg80211_disconnect+0x18b/0x1b0 [cfg80211]
May 16 11:46:07 brian-laptop kernel: [25070.765776]  [<ffffffffa023e77c>]=
 ? __cfg80211_stop_sched_scan+0x1c/0x130 [cfg80211]
May 16 11:46:07 brian-laptop kernel: [25070.765793]  [<ffffffffa0235a84>]=
 cfg80211_leave+0xc4/0xe0 [cfg80211]
May 16 11:46:07 brian-laptop kernel: [25070.765810]  [<ffffffffa0235e3b>]=
 cfg80211_netdev_notifier_call+0x39b/0x610 [cfg80211]
May 16 11:46:07 brian-laptop kernel: [25070.765816]  [<ffffffff816861c8>]=
 ? inetdev_event+0x38/0x510
May 16 11:46:07 brian-laptop kernel: [25070.765823]  [<ffffffff81721fbc>]=
 notifier_call_chain+0x4c/0x70
May 16 11:46:07 brian-laptop kernel: [25070.765830]  [<ffffffff8108fb46>]=
 raw_notifier_call_chain+0x16/0x20
May 16 11:46:07 brian-laptop kernel: [25070.765835]  [<ffffffff81616395>]=
 call_netdevice_notifiers_info+0x35/0x60
May 16 11:46:07 brian-laptop kernel: [25070.765840]  [<ffffffff81616489>]=
 __dev_close_many+0x49/0xe0
May 16 11:46:07 brian-laptop kernel: [25070.765845]  [<ffffffff8161656d>]=
 __dev_close+0x4d/0x90
May 16 11:46:07 brian-laptop kernel: [25070.765851]  [<ffffffff8161db8d>]=
 __dev_change_flags+0x9d/0x170
May 16 11:46:07 brian-laptop kernel: [25070.765857]  [<ffffffff8161dc89>]=
 dev_change_flags+0x29/0x60
May 16 11:46:07 brian-laptop kernel: [25070.765862]  [<ffffffff8162b782>]=
 do_setlink+0x312/0x9e0
May 16 11:46:07 brian-laptop kernel: [25070.765871]  [<ffffffff81384ea2>]=
 ? nla_parse+0x32/0xe0
May 16 11:46:07 brian-laptop kernel: [25070.765877]  [<ffffffff8162cab4>]=
 rtnl_newlink+0x394/0x5d0
May 16 11:46:07 brian-laptop kernel: [25070.765884]  [<ffffffff81365a62>]=
 ? put_dec+0x72/0x90
May 16 11:46:07 brian-laptop kernel: [25070.765891]  [<ffffffff8130d74d>]=
 ? apparmor_capable+0x1d/0x130
May 16 11:46:07 brian-laptop kernel: [25070.765897]  [<ffffffff81629539>]=
 rtnetlink_rcv_msg+0x99/0x260
May 16 11:46:07 brian-laptop kernel: [25070.765905]  [<ffffffff811a2778>]=
 ? __kmalloc_node_track_caller+0x58/0x1e0
May 16 11:46:07 brian-laptop kernel: [25070.765912]  [<ffffffff8116c409>]=
 ? zone_statistics+0x89/0xa0
May 16 11:46:07 brian-laptop kernel: [25070.765918]  [<ffffffff8160b45e>]=
 ? __alloc_skb+0x7e/0x2b0
May 16 11:46:07 brian-laptop kernel: [25070.765923]  [<ffffffff816294a0>]=
 ? rtnetlink_rcv+0x30/0x30
May 16 11:46:07 brian-laptop kernel: [25070.765928]  [<ffffffff81647a89>]=
 netlink_rcv_skb+0xa9/0xc0
May 16 11:46:07 brian-laptop kernel: [25070.765933]  [<ffffffff81629498>]=
 rtnetlink_rcv+0x28/0x30
May 16 11:46:07 brian-laptop kernel: [25070.765939]  [<ffffffff816470b5>]=
 netlink_unicast+0xd5/0x1b0
May 16 11:46:07 brian-laptop kernel: [25070.765944]  [<ffffffff8164748f>]=
 netlink_sendmsg+0x2ff/0x740
May 16 11:46:07 brian-laptop kernel: [25070.765951]  [<ffffffff8160254b>]=
 sock_sendmsg+0x8b/0xc0
May 16 11:46:07 brian-laptop kernel: [25070.765958]  [<ffffffff811af0f6>]=
 ? __mem_cgroup_commit_charge+0x156/0x3d0
May 16 11:46:07 brian-laptop kernel: [25070.765965]  [<ffffffff8160223e>]=
 ? move_addr_to_kernel.part.16+0x1e/0x60
May 16 11:46:07 brian-laptop kernel: [25070.765971]  [<ffffffff81602df1>]=
 ? move_addr_to_kernel+0x21/0x30
May 16 11:46:07 brian-laptop kernel: [25070.765977]  [<ffffffff81602db9>]=
 ___sys_sendmsg+0x3a9/0x3c0
May 16 11:46:07 brian-laptop kernel: [25070.765983]  [<ffffffff81721aa4>]=
 ? __do_page_fault+0x204/0x560
May 16 11:46:07 brian-laptop kernel: [25070.765990]  [<ffffffff811112fc>]=
 ? acct_account_cputime+0x1c/0x20
May 16 11:46:07 brian-laptop kernel: [25070.765995]  [<ffffffff8109d76b>]=
 ? account_user_time+0x8b/0xa0
May 16 11:46:07 brian-laptop kernel: [25070.766002]  [<ffffffff816034c2>]=
 __sys_sendmsg+0x42/0x80
May 16 11:46:07 brian-laptop kernel: [25070.766009]  [<ffffffff81603512>]=
 SyS_sendmsg+0x12/0x20
May 16 11:46:07 brian-laptop kernel: [25070.766014]  [<ffffffff817266bf>]=
 tracesys+0xe1/0xe6
May 16 11:46:07 brian-laptop kernel: [25070.766018] ---[ end trace f79bbc=
826d0c6d8a ]---
May 16 11:46:07 brian-laptop kernel: [25070.766024] iwlwifi 0000:01:00.0:=
 failed to update MAC 5c:51:4f:63:1e:10
May 16 11:46:07 brian-laptop kernel: [25070.766031] iwlwifi 0000:01:00.0:=
 iwl_trans_send_cmd bad state =3D 0
May 16 11:46:07 brian-laptop kernel: [25070.766035] iwlwifi 0000:01:00.0:=
 Failed to send BT_CI cmd
May 16 11:46:07 brian-laptop kernel: [25070.766039] iwlwifi 0000:01:00.0:=
 iwl_trans_send_cmd bad state =3D 0
May 16 11:46:07 brian-laptop kernel: [25070.766043] iwlwifi 0000:01:00.0:=
 Failed to update the ctrl_kill_msk
May 16 11:46:07 brian-laptop kernel: [25070.766049] iwlwifi 0000:01:00.0:=
 failed to update MAC 5c:51:4f:63:1e:10
May 16 11:46:07 brian-laptop kernel: [25070.766053] ------------[ cut her=
e ]------------
May 16 11:46:07 brian-laptop kernel: [25070.766066] WARNING: CPU: 0 PID: =
14026 at /build/buildd/linux-3.13.0/drivers/net/wireless/iwlwifi/mvm/bind=
ing.c:193 iwl_mvm_binding_remove_vif+0x3f/0x50 [iwlmvm]()
May 16 11:46:07 brian-laptop kernel: [25070.766068] Modules linked in: cd=
c_acm ctr ccm hid_sensor_als hid_sensor_magn_3d hid_sensor_gyro_3d hid_se=
nsor_accel_3d hid_sensor_trigger industrialio_triggered_buffer kfifo_buf =
industrialio hid_sensor_iio_common hid_multitouch hid_sensor_hub uvcvideo=
 videobuf2_vmalloc videobuf2_memops videobuf2_core usbhid hid videodev bt=
usb snd_hda_codec_hdmi snd_hda_codec_realtek joydev arc4 intel_rapl x86_p=
kg_temp_thermal intel_powerclamp coretemp kvm bnep rfcomm crct10dif_pclmu=
l bluetooth crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw g=
f128mul glue_helper ablk_helper cryptd iwlmvm mac80211 psmouse serio_raw =
snd_hda_intel iwlwifi snd_hda_codec snd_hwdep cfg80211 snd_pcm snd_page_a=
lloc snd_seq_midi snd_seq_midi_event snd_rawmidi i915 intel_smartconnect =
snd_seq snd_seq_device mac_hid video snd_timer drm_kms_helper parport_pc =
drm snd i2c_algo_bit mei_me ppdev nls_iso8859_1 mei soundcore lpc_ich lp =
parport ahci libahci
May 16 11:46:07 brian-laptop kernel: [25070.766154] CPU: 0 PID: 14026 Com=
m: ip Tainted: G        W    3.13.0-24-generic #47-Ubuntu
May 16 11:46:07 brian-laptop kernel: [25070.766157] Hardware name: LENOVO=
 20266/Yoga2, BIOS 76CN27WW 09/17/2013
May 16 11:46:07 brian-laptop kernel: [25070.766160]  0000000000000009 fff=
f8801eda8d448 ffffffff81715ac4 0000000000000000
May 16 11:46:07 brian-laptop kernel: [25070.766166]  ffff8801eda8d480 fff=
fffff810676bd ffff880251c612b8 ffff880251641800
May 16 11:46:07 brian-laptop kernel: [25070.766172]  ffff8802516417d0 fff=
f8802392c29c0 ffff8802392c29f0 ffff8801eda8d490
May 16 11:46:07 brian-laptop kernel: [25070.766178] Call Trace:
May 16 11:46:07 brian-laptop kernel: [25070.766184]  [<ffffffff81715ac4>]=
 dump_stack+0x45/0x56
May 16 11:46:07 brian-laptop kernel: [25070.766190]  [<ffffffff810676bd>]=
 warn_slowpath_common+0x7d/0xa0
May 16 11:46:07 brian-laptop kernel: [25070.766195]  [<ffffffff8106779a>]=
 warn_slowpath_null+0x1a/0x20
May 16 11:46:07 brian-laptop kernel: [25070.766207]  [<ffffffffa042cb0f>]=
 iwl_mvm_binding_remove_vif+0x3f/0x50 [iwlmvm]
May 16 11:46:07 brian-laptop kernel: [25070.766218]  [<ffffffffa0423d17>]=
 iwl_mvm_unassign_vif_chanctx+0x57/0x90 [iwlmvm]
May 16 11:46:07 brian-laptop kernel: [25070.766245]  [<ffffffffa038f3aa>]=
 __ieee80211_vif_release_channel+0x9a/0x1e0 [mac80211]
May 16 11:46:07 brian-laptop kernel: [25070.766269]  [<ffffffffa038fbed>]=
 ieee80211_vif_release_channel+0x4d/0x70 [mac80211]
May 16 11:46:07 brian-laptop kernel: [25070.766293]  [<ffffffffa03a17b7>]=
 ieee80211_set_disassoc+0x267/0x3d0 [mac80211]
May 16 11:46:07 brian-laptop kernel: [25070.766317]  [<ffffffffa03a5903>]=
 ieee80211_mgd_deauth+0x1d3/0x240 [mac80211]
May 16 11:46:07 brian-laptop kernel: [25070.766340]  [<ffffffffa0377c38>]=
 ieee80211_deauth+0x18/0x20 [mac80211]
May 16 11:46:07 brian-laptop kernel: [25070.766366]  [<ffffffffa025695c>]=
 cfg80211_mlme_deauth+0x9c/0x140 [cfg80211]
May 16 11:46:07 brian-laptop kernel: [25070.766393]  [<ffffffffa0256c0b>]=
 cfg80211_mlme_down+0x6b/0x90 [cfg80211]
May 16 11:46:07 brian-laptop kernel: [25070.766421]  [<ffffffffa025a94b>]=
 cfg80211_disconnect+0x18b/0x1b0 [cfg80211]
May 16 11:46:07 brian-laptop kernel: [25070.766445]  [<ffffffffa023e77c>]=
 ? __cfg80211_stop_sched_scan+0x1c/0x130 [cfg80211]
May 16 11:46:07 brian-laptop kernel: [25070.766466]  [<ffffffffa0235a84>]=
 cfg80211_leave+0xc4/0xe0 [cfg80211]
May 16 11:46:07 brian-laptop kernel: [25070.766487]  [<ffffffffa0235e3b>]=
 cfg80211_netdev_notifier_call+0x39b/0x610 [cfg80211]
May 16 11:46:07 brian-laptop kernel: [25070.766494]  [<ffffffff816861c8>]=
 ? inetdev_event+0x38/0x510
May 16 11:46:07 brian-laptop kernel: [25070.766502]  [<ffffffff81721fbc>]=
 notifier_call_chain+0x4c/0x70
May 16 11:46:07 brian-laptop kernel: [25070.766510]  [<ffffffff8108fb46>]=
 raw_notifier_call_chain+0x16/0x20
May 16 11:46:07 brian-laptop kernel: [25070.766515]  [<ffffffff81616395>]=
 call_netdevice_notifiers_info+0x35/0x60
May 16 11:46:07 brian-laptop kernel: [25070.766520]  [<ffffffff81616489>]=
 __dev_close_many+0x49/0xe0
May 16 11:46:07 brian-laptop kernel: [25070.766526]  [<ffffffff8161656d>]=
 __dev_close+0x4d/0x90
May 16 11:46:07 brian-laptop kernel: [25070.766532]  [<ffffffff8161db8d>]=
 __dev_change_flags+0x9d/0x170
May 16 11:46:07 brian-laptop kernel: [25070.766538]  [<ffffffff8161dc89>]=
 dev_change_flags+0x29/0x60
May 16 11:46:07 brian-laptop kernel: [25070.766544]  [<ffffffff8162b782>]=
 do_setlink+0x312/0x9e0
May 16 11:46:07 brian-laptop kernel: [25070.766554]  [<ffffffff81384ea2>]=
 ? nla_parse+0x32/0xe0
May 16 11:46:07 brian-laptop kernel: [25070.766560]  [<ffffffff8162cab4>]=
 rtnl_newlink+0x394/0x5d0
May 16 11:46:07 brian-laptop kernel: [25070.766568]  [<ffffffff81365a62>]=
 ? put_dec+0x72/0x90
May 16 11:46:07 brian-laptop kernel: [25070.766575]  [<ffffffff8130d74d>]=
 ? apparmor_capable+0x1d/0x130
May 16 11:46:07 brian-laptop kernel: [25070.766581]  [<ffffffff81629539>]=
 rtnetlink_rcv_msg+0x99/0x260
May 16 11:46:07 brian-laptop kernel: [25070.766589]  [<ffffffff811a2778>]=
 ? __kmalloc_node_track_caller+0x58/0x1e0
May 16 11:46:07 brian-laptop kernel: [25070.766597]  [<ffffffff8116c409>]=
 ? zone_statistics+0x89/0xa0
May 16 11:46:07 brian-laptop kernel: [25070.766602]  [<ffffffff8160b45e>]=
 ? __alloc_skb+0x7e/0x2b0
May 16 11:46:07 brian-laptop kernel: [25070.766608]  [<ffffffff816294a0>]=
 ? rtnetlink_rcv+0x30/0x30
May 16 11:46:07 brian-laptop kernel: [25070.766614]  [<ffffffff81647a89>]=
 netlink_rcv_skb+0xa9/0xc0
May 16 11:46:07 brian-laptop kernel: [25070.766620]  [<ffffffff81629498>]=
 rtnetlink_rcv+0x28/0x30
May 16 11:46:07 brian-laptop kernel: [25070.766626]  [<ffffffff816470b5>]=
 netlink_unicast+0xd5/0x1b0
May 16 11:46:07 brian-laptop kernel: [25070.766632]  [<ffffffff8164748f>]=
 netlink_sendmsg+0x2ff/0x740
May 16 11:46:07 brian-laptop kernel: [25070.766638]  [<ffffffff8160254b>]=
 sock_sendmsg+0x8b/0xc0
May 16 11:46:07 brian-laptop kernel: [25070.766646]  [<ffffffff811af0f6>]=
 ? __mem_cgroup_commit_charge+0x156/0x3d0
May 16 11:46:07 brian-laptop kernel: [25070.766653]  [<ffffffff8160223e>]=
 ? move_addr_to_kernel.part.16+0x1e/0x60
May 16 11:46:07 brian-laptop kernel: [25070.766660]  [<ffffffff81602df1>]=
 ? move_addr_to_kernel+0x21/0x30
May 16 11:46:07 brian-laptop kernel: [25070.766666]  [<ffffffff81602db9>]=
 ___sys_sendmsg+0x3a9/0x3c0
May 16 11:46:07 brian-laptop kernel: [25070.766672]  [<ffffffff81721aa4>]=
 ? __do_page_fault+0x204/0x560
May 16 11:46:07 brian-laptop kernel: [25070.766680]  [<ffffffff811112fc>]=
 ? acct_account_cputime+0x1c/0x20
May 16 11:46:07 brian-laptop kernel: [25070.766686]  [<ffffffff8109d76b>]=
 ? account_user_time+0x8b/0xa0
May 16 11:46:07 brian-laptop kernel: [25070.766693]  [<ffffffff816034c2>]=
 __sys_sendmsg+0x42/0x80
May 16 11:46:07 brian-laptop kernel: [25070.766708]  [<ffffffff81603512>]=
 SyS_sendmsg+0x12/0x20
May 16 11:46:07 brian-laptop kernel: [25070.766714]  [<ffffffff817266bf>]=
 tracesys+0xe1/0xe6
May 16 11:46:07 brian-laptop kernel: [25070.766718] ---[ end trace f79bbc=
826d0c6d8b ]---
May 16 11:46:07 brian-laptop kernel: [25070.766791] iwlwifi 0000:01:00.0:=
 offset 1 not used in fw key table.
May 16 11:46:07 brian-laptop kernel: [25070.766796] wlan0: failed to remo=
ve key (1, ff:ff:ff:ff:ff:ff) from hardware (-2)
May 16 11:46:07 brian-laptop kernel: [25070.766869] iwlwifi 0000:01:00.0:=
 offset 2 not used in fw key table.
May 16 11:46:07 brian-laptop kernel: [25070.766874] wlan0: failed to remo=
ve key (2, ff:ff:ff:ff:ff:ff) from hardware (-2)
May 16 11:46:07 brian-laptop kernel: [25070.795740] iwlwifi 0000:01:00.0:=
 iwl_trans_send_cmd bad state =3D 0
May 16 11:46:07 brian-laptop kernel: [25070.795750] iwlwifi 0000:01:00.0:=
 Failed to send flush command (-5)
May 16 11:46:07 brian-laptop kernel: [25070.795778] ------------[ cut her=
e ]------------
May 16 11:46:07 brian-laptop kernel: [25070.795806] WARNING: CPU: 2 PID: =
14026 at /build/buildd/linux-3.13.0/drivers/net/wireless/iwlwifi/mvm/mac-=
ctxt.c:1110 iwl_mvm_mac_ctxt_remove+0x171/0x190 [iwlmvm]()
May 16 11:46:07 brian-laptop kernel: [25070.795809] Removing inactive MAC=
 5c:51:4f:63:1e:10/2
May 16 11:46:07 brian-laptop kernel: [25070.795812] Modules linked in: cd=
c_acm ctr ccm hid_sensor_als hid_sensor_magn_3d hid_sensor_gyro_3d hid_se=
nsor_accel_3d hid_sensor_trigger industrialio_triggered_buffer kfifo_buf =
industrialio hid_sensor_iio_common hid_multitouch hid_sensor_hub uvcvideo=
 videobuf2_vmalloc videobuf2_memops videobuf2_core usbhid hid videodev bt=
usb snd_hda_codec_hdmi snd_hda_codec_realtek joydev arc4 intel_rapl x86_p=
kg_temp_thermal intel_powerclamp coretemp kvm bnep rfcomm crct10dif_pclmu=
l bluetooth crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw g=
f128mul glue_helper ablk_helper cryptd iwlmvm mac80211 psmouse serio_raw =
snd_hda_intel iwlwifi snd_hda_codec snd_hwdep cfg80211 snd_pcm snd_page_a=
lloc snd_seq_midi snd_seq_midi_event snd_rawmidi i915 intel_smartconnect =
snd_seq snd_seq_device mac_hid video snd_timer drm_kms_helper parport_pc =
drm snd i2c_algo_bit mei_me ppdev nls_iso8859_1 mei soundcore lpc_ich lp =
parport ahci libahci
May 16 11:46:07 brian-laptop kernel: [25070.795910] CPU: 2 PID: 14026 Com=
m: ip Tainted: G        W    3.13.0-24-generic #47-Ubuntu
May 16 11:46:07 brian-laptop kernel: [25070.795913] Hardware name: LENOVO=
 20266/Yoga2, BIOS 76CN27WW 09/17/2013
May 16 11:46:07 brian-laptop kernel: [25070.795917]  0000000000000009 fff=
f8801eda8d5b8 ffffffff81715ac4 ffff8801eda8d600
May 16 11:46:07 brian-laptop kernel: [25070.795924]  ffff8801eda8d5f0 fff=
fffff810676bd ffff880251c612b8 ffff8802516417c0
May 16 11:46:07 brian-laptop kernel: [25070.795930]  ffff8802516417d0 fff=
f880251641800 ffff880251c612b8 ffff8801eda8d650
May 16 11:46:07 brian-laptop kernel: [25070.795937] Call Trace:
May 16 11:46:07 brian-laptop kernel: [25070.795950]  [<ffffffff81715ac4>]=
 dump_stack+0x45/0x56
May 16 11:46:07 brian-laptop kernel: [25070.795958]  [<ffffffff810676bd>]=
 warn_slowpath_common+0x7d/0xa0
May 16 11:46:07 brian-laptop kernel: [25070.795964]  [<ffffffff8106772c>]=
 warn_slowpath_fmt+0x4c/0x50
May 16 11:46:07 brian-laptop kernel: [25070.795974]  [<ffffffff811d47db>]=
 ? evict+0x11b/0x1b0
May 16 11:46:07 brian-laptop kernel: [25070.795988]  [<ffffffffa0429761>]=
 iwl_mvm_mac_ctxt_remove+0x171/0x190 [iwlmvm]
May 16 11:46:07 brian-laptop kernel: [25070.795994]  [<ffffffff811d8fe9>]=
 ? mntput_no_expire+0x109/0x170
May 16 11:46:07 brian-laptop kernel: [25070.795998]  [<ffffffff811d9074>]=
 ? mntput+0x24/0x40
May 16 11:46:07 brian-laptop kernel: [25070.796007]  [<ffffffff812b4976>]=
 ? debugfs_remove_recursive+0x116/0x1c0
May 16 11:46:07 brian-laptop kernel: [25070.796018]  [<ffffffffa0425155>]=
 iwl_mvm_mac_remove_interface+0xb5/0x190 [iwlmvm]
May 16 11:46:07 brian-laptop kernel: [25070.796046]  [<ffffffffa0373031>]=
 ieee80211_do_stop+0x4c1/0x830 [mac80211]
May 16 11:46:07 brian-laptop kernel: [25070.796069]  [<ffffffffa03733ba>]=
 ieee80211_stop+0x1a/0x20 [mac80211]
May 16 11:46:07 brian-laptop kernel: [25070.796075]  [<ffffffff816164cd>]=
 __dev_close_many+0x8d/0xe0
May 16 11:46:07 brian-laptop kernel: [25070.796080]  [<ffffffff8161656d>]=
 __dev_close+0x4d/0x90
May 16 11:46:07 brian-laptop kernel: [25070.796087]  [<ffffffff8161db8d>]=
 __dev_change_flags+0x9d/0x170
May 16 11:46:07 brian-laptop kernel: [25070.796093]  [<ffffffff8161dc89>]=
 dev_change_flags+0x29/0x60
May 16 11:46:07 brian-laptop kernel: [25070.796100]  [<ffffffff8162b782>]=
 do_setlink+0x312/0x9e0
May 16 11:46:07 brian-laptop kernel: [25070.796111]  [<ffffffff81384ea2>]=
 ? nla_parse+0x32/0xe0
May 16 11:46:07 brian-laptop kernel: [25070.796116]  [<ffffffff8162cab4>]=
 rtnl_newlink+0x394/0x5d0
May 16 11:46:07 brian-laptop kernel: [25070.796125]  [<ffffffff81365a62>]=
 ? put_dec+0x72/0x90
May 16 11:46:07 brian-laptop kernel: [25070.796132]  [<ffffffff8130d74d>]=
 ? apparmor_capable+0x1d/0x130
May 16 11:46:07 brian-laptop kernel: [25070.796138]  [<ffffffff81629539>]=
 rtnetlink_rcv_msg+0x99/0x260
May 16 11:46:07 brian-laptop kernel: [25070.796146]  [<ffffffff811a2778>]=
 ? __kmalloc_node_track_caller+0x58/0x1e0
May 16 11:46:07 brian-laptop kernel: [25070.796154]  [<ffffffff8116c409>]=
 ? zone_statistics+0x89/0xa0
May 16 11:46:07 brian-laptop kernel: [25070.796160]  [<ffffffff8160b45e>]=
 ? __alloc_skb+0x7e/0x2b0
May 16 11:46:07 brian-laptop kernel: [25070.796165]  [<ffffffff816294a0>]=
 ? rtnetlink_rcv+0x30/0x30
May 16 11:46:07 brian-laptop kernel: [25070.796172]  [<ffffffff81647a89>]=
 netlink_rcv_skb+0xa9/0xc0
May 16 11:46:07 brian-laptop kernel: [25070.796177]  [<ffffffff81629498>]=
 rtnetlink_rcv+0x28/0x30
May 16 11:46:07 brian-laptop kernel: [25070.796183]  [<ffffffff816470b5>]=
 netlink_unicast+0xd5/0x1b0
May 16 11:46:07 brian-laptop kernel: [25070.796188]  [<ffffffff8164748f>]=
 netlink_sendmsg+0x2ff/0x740
May 16 11:46:07 brian-laptop kernel: [25070.796195]  [<ffffffff8160254b>]=
 sock_sendmsg+0x8b/0xc0
May 16 11:46:07 brian-laptop kernel: [25070.796203]  [<ffffffff811af0f6>]=
 ? __mem_cgroup_commit_charge+0x156/0x3d0
May 16 11:46:07 brian-laptop kernel: [25070.796209]  [<ffffffff8160223e>]=
 ? move_addr_to_kernel.part.16+0x1e/0x60
May 16 11:46:07 brian-laptop kernel: [25070.796215]  [<ffffffff81602df1>]=
 ? move_addr_to_kernel+0x21/0x30
May 16 11:46:07 brian-laptop kernel: [25070.796222]  [<ffffffff81602db9>]=
 ___sys_sendmsg+0x3a9/0x3c0
May 16 11:46:07 brian-laptop kernel: [25070.796228]  [<ffffffff81721aa4>]=
 ? __do_page_fault+0x204/0x560
May 16 11:46:07 brian-laptop kernel: [25070.796237]  [<ffffffff811112fc>]=
 ? acct_account_cputime+0x1c/0x20
May 16 11:46:07 brian-laptop kernel: [25070.796242]  [<ffffffff8109d76b>]=
 ? account_user_time+0x8b/0xa0
May 16 11:46:07 brian-laptop kernel: [25070.796249]  [<ffffffff816034c2>]=
 __sys_sendmsg+0x42/0x80
May 16 11:46:07 brian-laptop kernel: [25070.796256]  [<ffffffff81603512>]=
 SyS_sendmsg+0x12/0x20
May 16 11:46:07 brian-laptop kernel: [25070.796262]  [<ffffffff817266bf>]=
 tracesys+0xe1/0xe6
May 16 11:46:07 brian-laptop kernel: [25070.796266] ---[ end trace f79bbc=
826d0c6d8c ]---
May 16 11:46:07 brian-laptop kernel: [25070.796271] iwlwifi 0000:01:00.0:=
 iwl_trans_txq_disable bad state =3D 0
May 16 11:46:07 brian-laptop kernel: [25070.831510] iwlwifi 0000:01:00.0:=
 iwl_trans_txq_disable bad state =3D 0
May 16 11:46:07 brian-laptop kernel: [25070.866607] iwlwifi 0000:01:00.0:=
 iwl_trans_txq_disable bad state =3D 0
May 16 11:46:07 brian-laptop kernel: [25070.901800] iwlwifi 0000:01:00.0:=
 iwl_trans_txq_disable bad state =3D 0
May 16 11:46:07 brian-laptop avahi-daemon[558]: Interface wlan0.IPv6 no l=
onger relevant for mDNS.
May 16 11:46:07 brian-laptop avahi-daemon[558]: Leaving mDNS multicast gr=
oup on interface wlan0.IPv6 with address fe80::5e51:4fff:fe63:1e10.
May 16 11:46:07 brian-laptop avahi-daemon[558]: Withdrawing address recor=
d for fe80::5e51:4fff:fe63:1e10 on wlan0.
May 16 11:46:07 brian-laptop kernel: [25070.937796] cfg80211: Calling CRD=
A to update world regulatory domain
May 16 11:46:07 brian-laptop kernel: [25070.940133] cfg80211: World regul=
atory domain updated:
May 16 11:46:07 brian-laptop kernel: [25070.940136] cfg80211:   (start_fr=
eq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
May 16 11:46:07 brian-laptop kernel: [25070.940138] cfg80211:   (2402000 =
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 11:46:07 brian-laptop kernel: [25070.940140] cfg80211:   (2457000 =
KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 11:46:07 brian-laptop kernel: [25070.940141] cfg80211:   (2474000 =
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
May 16 11:46:07 brian-laptop kernel: [25070.940143] cfg80211:   (5170000 =
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 11:46:07 brian-laptop kernel: [25070.940145] cfg80211:   (5735000 =
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 11:46:07 brian-laptop wpa_supplicant[2784]: wlan0: CTRL-EVENT-TERM=
INATING=20
May 16 11:46:37 brian-laptop kernel: [25100.361263] iwlwifi 0000:01:00.0:=
 L1 Disabled; Enabling L0S
May 16 11:46:37 brian-laptop kernel: [25100.502895] iwlwifi 0000:01:00.0:=
 L1 Disabled; Enabling L0S
May 16 11:46:50 brian-laptop kernel: [25106.308452] iwlwifi 0000:01:00.0:=
 Failed to load firmware chunk!
May 16 11:46:50 brian-laptop kernel: [25106.308463] iwlwifi 0000:01:00.0:=
 Could not load the [0] uCode section
May 16 11:46:50 brian-laptop kernel: [25106.308475] iwlwifi 0000:01:00.0:=
 Failed to start RT ucode: -110
May 16 11:46:50 brian-laptop kernel: [25108.130512] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 0 [0x5a5a5a5a]
May 16 11:46:50 brian-laptop kernel: [25109.970254] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 2 [0x5a5a5a5a]
May 16 11:46:50 brian-laptop kernel: [25111.845365] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 5 [0x5a5a5a5a]
May 16 11:46:50 brian-laptop kernel: [25113.685117] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 7 [0x5a5a5a5a]
May 16 11:46:56 brian-laptop kernel: [25119.747579] iwlwifi 0000:01:00.0:=
 L1 Disabled; Enabling L0S
May 16 11:46:56 brian-laptop kernel: [25119.887212] iwlwifi 0000:01:00.0:=
 L1 Disabled; Enabling L0S
May 16 11:47:07 brian-laptop rtkit-daemon[1483]: The canary thread is app=
arently starving. Taking action.
May 16 11:47:07 brian-laptop rtkit-daemon[1483]: Demoting known real-time=
 threads.
May 16 11:47:07 brian-laptop rtkit-daemon[1483]: Successfully demoted thr=
ead 2047 of process 2031 (n/a).
May 16 11:47:07 brian-laptop rtkit-daemon[1483]: Successfully demoted thr=
ead 2046 of process 2031 (n/a).
May 16 11:47:07 brian-laptop rtkit-daemon[1483]: Successfully demoted thr=
ead 2041 of process 2031 (n/a).
May 16 11:47:07 brian-laptop rtkit-daemon[1483]: Successfully demoted thr=
ead 2031 of process 2031 (n/a).
May 16 11:47:07 brian-laptop rtkit-daemon[1483]: Demoted 4 threads.
May 16 11:47:09 brian-laptop kernel: [25125.692106] iwlwifi 0000:01:00.0:=
 Failed to load firmware chunk!
May 16 11:47:09 brian-laptop kernel: [25125.692120] iwlwifi 0000:01:00.0:=
 Could not load the [0] uCode section
May 16 11:47:09 brian-laptop kernel: [25125.692133] iwlwifi 0000:01:00.0:=
 Failed to start RT ucode: -110
May 16 11:47:09 brian-laptop kernel: [25127.514282] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 0 [0x5a5a5a5a]
May 16 11:47:09 brian-laptop kernel: [25129.354095] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 2 [0x5a5a5a5a]
May 16 11:47:09 brian-laptop kernel: [25131.229265] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 5 [0x5a5a5a5a]
May 16 11:47:09 brian-laptop kernel: [25133.069079] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 7 [0x5a5a5a5a]
May 16 11:48:14 brian-laptop avahi-daemon[558]: Withdrawing workstation s=
ervice for wlan0.
May 16 11:48:14 brian-laptop NetworkManager[1040]:    SCPlugin-Ifupdown: =
devices removed (path: /sys/devices/pci0000:00/0000:00:1c.0/0000:01:00.0/=
net/wlan0, iface: wlan0)
May 16 11:48:14 brian-laptop NetworkManager[1040]:    Ifupdown: get unman=
aged devices count: 0
May 16 11:48:14 brian-laptop NetworkManager[1040]: <info> (wlan0): device=
 state change: unmanaged -> unavailable (reason 'managed') [10 20 2]
May 16 11:48:14 brian-laptop NetworkManager[1040]: <warn> (2) failed to f=
ind interface name for index
May 16 11:48:14 brian-laptop NetworkManager[1040]: (nm-system.c:766):nm_s=
ystem_iface_get_flags: runtime check failed: (iface !=3D NULL)
May 16 11:48:14 brian-laptop NetworkManager[1040]: <error> [1400262494.23=
3107] [nm-system.c:768] nm_system_iface_get_flags(): (unknown): failed to=
 get interface link object
May 16 11:48:14 brian-laptop NetworkManager[1040]: <info> (wlan0): bringi=
ng up device.
May 16 11:48:14 brian-laptop NetworkManager[1040]: <info> (wlan0): deacti=
vating device (reason 'managed') [2]
May 16 11:48:14 brian-laptop NetworkManager[1040]: <warn> sysctl: failed =
to open '/proc/sys/net/ipv6/conf/wlan0/accept_ra': (2) No such file or di=
rectory
May 16 11:48:14 brian-laptop NetworkManager[1040]: <warn> sysctl: failed =
to open '/proc/sys/net/ipv6/conf/wlan0/use_tempaddr': (2) No such file or=
 directory
May 16 11:48:14 brian-laptop NetworkManager[1040]: <warn> (2) failed to f=
ind interface name for index
May 16 11:48:14 brian-laptop NetworkManager[1040]: (nm-system.c:766):nm_s=
ystem_iface_get_flags: runtime check failed: (iface !=3D NULL)
May 16 11:48:14 brian-laptop NetworkManager[1040]: <error> [1400262494.23=
5145] [nm-system.c:768] nm_system_iface_get_flags(): (unknown): failed to=
 get interface link object
May 16 11:48:14 brian-laptop NetworkManager[1040]: <warn> (2) failed to f=
ind interface name for index
May 16 11:48:14 brian-laptop NetworkManager[1040]: (nm-system.c:766):nm_s=
ystem_iface_get_flags: runtime check failed: (iface !=3D NULL)
May 16 11:48:14 brian-laptop NetworkManager[1040]: <error> [1400262494.23=
5333] [nm-system.c:768] nm_system_iface_get_flags(): (unknown): failed to=
 get interface link object
May 16 11:48:14 brian-laptop NetworkManager[1040]: <info> (wlan0): bringi=
ng up device.
May 16 11:48:14 brian-laptop NetworkManager[1040]: <warn> (2) failed to f=
ind interface name for index
May 16 11:48:14 brian-laptop NetworkManager[1040]: nm_system_iface_flush_=
routes: assertion 'iface !=3D NULL' failed
May 16 11:48:14 brian-laptop NetworkManager[1040]: <warn> (2) failed to f=
ind interface name for index
May 16 11:48:14 brian-laptop NetworkManager[1040]: <info> NetworkManager =
state is now DISCONNECTED
May 16 11:48:14 brian-laptop NetworkManager[1040]: <info> (wlan0): device=
 state change: unavailable -> unmanaged (reason 'removed') [20 10 36]
May 16 11:48:14 brian-laptop NetworkManager[1040]: <warn> (2) failed to f=
ind interface name for index
May 16 11:48:14 brian-laptop NetworkManager[1040]: (nm-system.c:766):nm_s=
ystem_iface_get_flags: runtime check failed: (iface !=3D NULL)
May 16 11:48:14 brian-laptop NetworkManager[1040]: <error> [1400262494.23=
6699] [nm-system.c:768] nm_system_iface_get_flags(): (unknown): failed to=
 get interface link object
May 16 11:48:14 brian-laptop NetworkManager[1040]: <info> Unmanaged Devic=
e found; state CONNECTED forced. (see http://bugs.launchpad.net/bugs/1918=
89)
May 16 11:48:14 brian-laptop NetworkManager[1040]: <info> Unmanaged Devic=
e found; state CONNECTED forced. (see http://bugs.launchpad.net/bugs/1918=
89)
May 16 11:48:14 brian-laptop NetworkManager[1040]: <info> NetworkManager =
state is now CONNECTED_GLOBAL
May 16 11:48:14 brian-laptop NetworkManager[1040]: <info> Unmanaged Devic=
e found; state CONNECTED forced. (see http://bugs.launchpad.net/bugs/1918=
89)
May 16 11:48:14 brian-laptop dbus[479]: [system] Activating service name=3D=
'fi.w1.wpa_supplicant1' (using servicehelper)
May 16 11:48:14 brian-laptop NetworkManager[1040]: <info> radio killswitc=
h /sys/devices/pci0000:00/0000:00:1c.0/0000:01:00.0/ieee80211/phy0/rfkill=
0 disappeared
May 16 11:48:14 brian-laptop dbus[479]: [system] Successfully activated s=
ervice 'fi.w1.wpa_supplicant1'
May 16 11:48:14 brian-laptop NetworkManager[1040]: <info> wpa_supplicant =
started
May 16 11:48:14 brian-laptop wpa_supplicant[14123]: Successfully initiali=
zed wpa_supplicant
May 16 11:48:14 brian-laptop wpa_supplicant[14131]: Could not read interf=
ace wlan0 flags: No such device
May 16 11:48:14 brian-laptop wpa_supplicant[14131]: nl80211: Driver does =
not support authentication/association or connect commands
May 16 11:48:14 brian-laptop wpa_supplicant[14131]: Could not read interf=
ace wlan0 flags: No such device
May 16 11:48:14 brian-laptop wpa_supplicant[14131]: Could not read interf=
ace wlan0 flags: No such device
May 16 11:48:14 brian-laptop wpa_supplicant[14131]: WEXT: Could not set i=
nterface 'wlan0' UP
May 16 11:48:14 brian-laptop wpa_supplicant[14131]: wlan0: Failed to init=
ialize driver interface
May 16 11:48:14 brian-laptop NetworkManager[1040]: <error> [1400262494.27=
4948] [nm-supplicant-interface.c:997] interface_add_cb(): (wlan0): error =
adding interface: wpa_supplicant couldn't grab this interface.
May 16 11:48:14 brian-laptop NetworkManager[1040]: dbus_g_proxy_cancel_ca=
ll: assertion 'pending !=3D NULL' failed
May 16 11:48:14 brian-laptop NetworkManager[1040]: <warn> Trying to remov=
e a non-existant call id.
May 16 11:48:14 brian-laptop dhclient: Internet Systems Consortium DHCP C=
lient 4.2.4
May 16 11:48:14 brian-laptop dhclient: Copyright 2004-2012 Internet Syste=
ms Consortium.
May 16 11:48:14 brian-laptop dhclient: All rights reserved.
May 16 11:48:14 brian-laptop dhclient: For info, please visit https://www=
=2Eisc.org/software/dhcp/
May 16 11:48:14 brian-laptop dhclient:=20
May 16 11:48:14 brian-laptop dhclient: Error getting hardware address for=
 "wlan0": No such device
May 16 11:48:14 brian-laptop kernel: [25197.613061] waiting module remova=
l not supported: please upgrade
May 16 11:48:27 brian-laptop kernel: [25197.635506] waiting module remova=
l not supported: please upgrade<6>[25210.771367] cfg80211: Calling CRDA t=
o update world regulatory domain
May 16 11:48:27 brian-laptop kernel: [25210.774215] cfg80211: World regul=
atory domain updated:
May 16 11:48:27 brian-laptop kernel: [25210.774218] cfg80211:   (start_fr=
eq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
May 16 11:48:27 brian-laptop kernel: [25210.774219] cfg80211:   (2402000 =
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 11:48:27 brian-laptop kernel: [25210.774221] cfg80211:   (2457000 =
KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 11:48:27 brian-laptop kernel: [25210.774222] cfg80211:   (2474000 =
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
May 16 11:48:27 brian-laptop kernel: [25210.774223] cfg80211:   (5170000 =
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 11:48:27 brian-laptop kernel: [25210.774224] cfg80211:   (5735000 =
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 11:48:27 brian-laptop kernel: [25210.775371] Intel(R) Wireless WiF=
i driver for Linux, in-tree:
May 16 11:48:27 brian-laptop kernel: [25210.775374] Copyright(c) 2003-201=
3 Intel Corporation
May 16 11:48:27 brian-laptop kernel: [25210.775408] iwlwifi 0000:01:00.0:=
 enabling device (0000 -> 0002)
May 16 11:48:27 brian-laptop kernel: [25210.775511] iwlwifi 0000:01:00.0:=
 irq 61 for MSI/MSI-X
May 16 11:48:27 brian-laptop kernel: [25210.775879] iwlwifi 0000:01:00.0:=
 loaded firmware version 22.24.8.0 op_mode iwlmvm
May 16 11:48:27 brian-laptop kernel: [25210.787918] iwlwifi 0000:01:00.0:=
 Detected Intel(R) Wireless N 7260, REV=3D0xFFFFFFFF
May 16 11:48:27 brian-laptop kernel: [25210.787961] iwlwifi 0000:01:00.0:=
 L1 Disabled; Enabling L0S
May 16 11:48:27 brian-laptop kernel: [25210.805508] ------------[ cut her=
e ]------------
May 16 11:48:27 brian-laptop kernel: [25210.805517] WARNING: CPU: 2 PID: =
14182 at /build/buildd/linux-3.13.0/drivers/net/wireless/iwlwifi/pcie/tra=
ns.c:1002 iwl_trans_pcie_grab_nic_access+0xcb/0xe0 [iwlwifi]()
May 16 11:48:27 brian-laptop kernel: [25210.805519] Timeout waiting for h=
ardware access (CSR_GP_CNTRL 0xffffffff)
May 16 11:48:27 brian-laptop kernel: [25210.805519] Modules linked in: iw=
lmvm(+) mac80211 iwlwifi cfg80211 cdc_acm ctr ccm hid_sensor_als hid_sens=
or_magn_3d hid_sensor_gyro_3d hid_sensor_accel_3d hid_sensor_trigger indu=
strialio_triggered_buffer kfifo_buf industrialio hid_sensor_iio_common hi=
d_multitouch hid_sensor_hub uvcvideo videobuf2_vmalloc videobuf2_memops v=
ideobuf2_core usbhid hid videodev btusb snd_hda_codec_hdmi snd_hda_codec_=
realtek joydev arc4 intel_rapl x86_pkg_temp_thermal intel_powerclamp core=
temp kvm bnep rfcomm crct10dif_pclmul bluetooth crc32_pclmul ghash_clmuln=
i_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper crypt=
d psmouse serio_raw snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_pag=
e_alloc snd_seq_midi snd_seq_midi_event snd_rawmidi i915 intel_smartconne=
ct snd_seq snd_seq_device mac_hid video snd_timer drm_kms_helper parport_=
pc drm snd i2c_algo_bit mei_me ppdev nls_iso8859_1 mei soundcore lpc_ich =
lp parport ahci libahci [last unloaded: cfg80211]
May 16 11:48:27 brian-laptop kernel: [25210.805560] CPU: 2 PID: 14182 Com=
m: modprobe Tainted: G        W    3.13.0-24-generic #47-Ubuntu
May 16 11:48:27 brian-laptop kernel: [25210.805561] Hardware name: LENOVO=
 20266/Yoga2, BIOS 76CN27WW 09/17/2013
May 16 11:48:27 brian-laptop kernel: [25210.805562]  0000000000000009 fff=
f880252755af8 ffffffff81715ac4 ffff880252755b40
May 16 11:48:27 brian-laptop kernel: [25210.805565]  ffff880252755b30 fff=
fffff810676bd ffff8801f5a1c000 ffff8801f5a1f258
May 16 11:48:27 brian-laptop kernel: [25210.805567]  ffff880252755bd0 000=
0000000000000 ffff880035ed97c0 ffff880252755b90
May 16 11:48:27 brian-laptop kernel: [25210.805569] Call Trace:
May 16 11:48:27 brian-laptop kernel: [25210.805574]  [<ffffffff81715ac4>]=
 dump_stack+0x45/0x56
May 16 11:48:27 brian-laptop kernel: [25210.805577]  [<ffffffff810676bd>]=
 warn_slowpath_common+0x7d/0xa0
May 16 11:48:27 brian-laptop kernel: [25210.805579]  [<ffffffff8106772c>]=
 warn_slowpath_fmt+0x4c/0x50
May 16 11:48:27 brian-laptop kernel: [25210.805584]  [<ffffffffa023feda>]=
 ? iwl_read32+0x1a/0x80 [iwlwifi]
May 16 11:48:27 brian-laptop kernel: [25210.805587]  [<ffffffffa024132b>]=
 iwl_trans_pcie_grab_nic_access+0xcb/0xe0 [iwlwifi]
May 16 11:48:27 brian-laptop kernel: [25210.805590]  [<ffffffffa023441b>]=
 iwl_read_prph+0x2b/0xb0 [iwlwifi]
May 16 11:48:27 brian-laptop kernel: [25210.805594]  [<ffffffffa0240e0d>]=
 iwl_pcie_apm_init+0x20d/0x280 [iwlwifi]
May 16 11:48:27 brian-laptop kernel: [25210.805597]  [<ffffffffa02417a5>]=
 iwl_trans_pcie_start_hw+0x55/0x1b0 [iwlwifi]
May 16 11:48:27 brian-laptop kernel: [25210.805603]  [<ffffffffa042358a>]=
 iwl_op_mode_mvm_start+0x43a/0x570 [iwlmvm]
May 16 11:48:27 brian-laptop kernel: [25210.805606]  [<ffffffffa0234b2a>]=
 _iwl_op_mode_start.isra.2+0x4a/0xb0 [iwlwifi]
May 16 11:48:27 brian-laptop kernel: [25210.805609]  [<ffffffffa0234c51>]=
 iwl_opmode_register+0xc1/0xf0 [iwlwifi]
May 16 11:48:27 brian-laptop kernel: [25210.805613]  [<ffffffffa025f000>]=
 ? 0xffffffffa025efff
May 16 11:48:27 brian-laptop kernel: [25210.805617]  [<ffffffffa025f037>]=
 iwl_mvm_init+0x37/0x1000 [iwlmvm]
May 16 11:48:27 brian-laptop kernel: [25210.805621]  [<ffffffff8100214a>]=
 do_one_initcall+0xfa/0x1b0
May 16 11:48:27 brian-laptop kernel: [25210.805623]  [<ffffffff810598d3>]=
 ? set_memory_nx+0x43/0x50
May 16 11:48:27 brian-laptop kernel: [25210.805628]  [<ffffffff810e1d4d>]=
 load_module+0x12dd/0x1b40
May 16 11:48:27 brian-laptop kernel: [25210.805631]  [<ffffffff810dd7d0>]=
 ? store_uevent+0x40/0x40
May 16 11:48:27 brian-laptop kernel: [25210.805633]  [<ffffffff810e2726>]=
 SyS_finit_module+0x86/0xb0
May 16 11:48:27 brian-laptop kernel: [25210.805635]  [<ffffffff817266bf>]=
 tracesys+0xe1/0xe6
May 16 11:48:27 brian-laptop kernel: [25210.805637] ---[ end trace f79bbc=
826d0c6d8d ]---
May 16 11:48:27 brian-laptop kernel: [25210.929073] iwlwifi 0000:01:00.0:=
 L1 Disabled; Enabling L0S
May 16 11:48:40 brian-laptop kernel: [25216.745641] iwlwifi 0000:01:00.0:=
 Failed to load firmware chunk!
May 16 11:48:40 brian-laptop kernel: [25216.745653] iwlwifi 0000:01:00.0:=
 Could not load the [0] uCode section
May 16 11:48:40 brian-laptop kernel: [25216.745666] iwlwifi 0000:01:00.0:=
 Failed to start INIT ucode: -110
May 16 11:48:40 brian-laptop kernel: [25218.587831] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 0 [0x5a5a5a5a]
May 16 11:48:40 brian-laptop kernel: [25220.447890] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 2 [0x5a5a5a5a]
May 16 11:48:40 brian-laptop kernel: [25222.322727] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 5 [0x5a5a5a5a]
May 16 11:48:40 brian-laptop kernel: [25224.151011] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 7 [0x5a5a5a5a]
May 16 11:48:42 brian-laptop kernel: [25225.976022] iwlwifi 0000:01:00.0:=
 Failed to run INIT ucode: -110
May 16 11:49:50 brian-laptop wpa_supplicant[14289]: Successfully initiali=
zed wpa_supplicant
May 16 11:49:50 brian-laptop wpa_supplicant[14289]: Could not read interf=
ace wlan0 flags: No such device
May 16 11:49:50 brian-laptop wpa_supplicant[14289]: nl80211: Driver does =
not support authentication/association or connect commands
May 16 11:49:50 brian-laptop wpa_supplicant[14289]: Could not read interf=
ace wlan0 flags: No such device
May 16 11:49:50 brian-laptop wpa_supplicant[14289]: Could not read interf=
ace wlan0 flags: No such device
May 16 11:49:50 brian-laptop wpa_supplicant[14289]: WEXT: Could not set i=
nterface 'wlan0' UP
May 16 11:49:50 brian-laptop wpa_supplicant[14289]: wlan0: Failed to init=
ialize driver interface
May 16 11:49:50 brian-laptop dhclient: Internet Systems Consortium DHCP C=
lient 4.2.4
May 16 11:49:50 brian-laptop dhclient: Copyright 2004-2012 Internet Syste=
ms Consortium.
May 16 11:49:50 brian-laptop dhclient: All rights reserved.
May 16 11:49:50 brian-laptop dhclient: For info, please visit https://www=
=2Eisc.org/software/dhcp/
May 16 11:49:50 brian-laptop dhclient:=20
May 16 11:49:50 brian-laptop dhclient: Error getting hardware address for=
 "wlan0": No such device
May 16 11:49:50 brian-laptop ntpdate[14356]: Can't find host ntp.ubuntu.c=
om: Name or service not known (-2)
May 16 11:49:50 brian-laptop ntpdate[14356]: no servers can be used, exit=
ing
May 16 11:51:11 brian-laptop dbus[479]: [system] Activating service name=3D=
'org.freedesktop.systemd1' (using servicehelper)
May 16 11:51:11 brian-laptop dbus[479]: [system] Successfully activated s=
ervice 'org.freedesktop.systemd1'
May 16 11:51:12 brian-laptop rsyslogd: [origin software=3D"rsyslogd" swVe=
rsion=3D"7.4.4" x-pid=3D"526" x-info=3D"http://www.rsyslog.com"] exiting =
on signal 15.
May 16 11:52:01 brian-laptop rsyslogd: [origin software=3D"rsyslogd" swVe=
rsion=3D"7.4.4" x-pid=3D"483" x-info=3D"http://www.rsyslog.com"] start
May 16 11:52:01 brian-laptop rsyslogd: rsyslogd's groupid changed to 103
May 16 11:52:01 brian-laptop rsyslogd: rsyslogd's userid changed to 101
May 16 11:52:01 brian-laptop kernel: [    0.000000] Initializing cgroup s=
ubsys cpuset
May 16 11:52:01 brian-laptop kernel: [    0.000000] Initializing cgroup s=
ubsys cpu
May 16 11:52:01 brian-laptop kernel: [    0.000000] Initializing cgroup s=
ubsys cpuacct
May 16 11:52:01 brian-laptop kernel: [    0.000000] Linux version 3.13.0-=
24-generic (buildd@batsu) (gcc version 4.8.2 (Ubuntu 4.8.2-19ubuntu1) ) #=
47-Ubuntu SMP Fri May 2 23:30:00 UTC 2014 (Ubuntu 3.13.0-24.47-generic 3.=
13.9)
May 16 11:52:01 brian-laptop kernel: [    0.000000] Command line: BOOT_IM=
AGE=3D/boot/vmlinuz-3.13.0-24-generic.efi.signed root=3DUUID=3D8e47fdb9-a=
ff2-414b-a81c-2df6486162cd ro acpi_backlight=3Dvendor quiet splash vt.han=
doff=3D7
May 16 11:52:01 brian-laptop kernel: [    0.000000] KERNEL supported cpus=
:
May 16 11:52:01 brian-laptop kernel: [    0.000000]   Intel GenuineIntel
May 16 11:52:01 brian-laptop kernel: [    0.000000]   AMD AuthenticAMD
May 16 11:52:01 brian-laptop kernel: [    0.000000]   Centaur CentaurHaul=
s
May 16 11:52:01 brian-laptop kernel: [    0.000000] e820: BIOS-provided p=
hysical RAM map:
May 16 11:52:01 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
0000000000000-0x000000000006efff] usable
May 16 11:52:01 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
000000006f000-0x000000000006ffff] reserved
May 16 11:52:01 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
0000000070000-0x0000000000087fff] usable
May 16 11:52:01 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
0000000088000-0x00000000000bffff] reserved
May 16 11:52:01 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
0000000100000-0x000000007a8fffff] usable
May 16 11:52:01 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
000007a900000-0x000000007bcfffff] reserved
May 16 11:52:01 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
000007bd00000-0x000000009c6befff] usable
May 16 11:52:01 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
000009c6bf000-0x000000009c8befff] type 20
May 16 11:52:01 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
000009c8bf000-0x000000009cebefff] reserved
May 16 11:52:01 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
000009cebf000-0x000000009cfbefff] ACPI NVS
May 16 11:52:01 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
000009cfbf000-0x000000009cffefff] ACPI data
May 16 11:52:01 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
000009cfff000-0x000000009cffffff] usable
May 16 11:52:01 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
000009d000000-0x000000009f9fffff] reserved
May 16 11:52:01 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
00000e0000000-0x00000000efffffff] reserved
May 16 11:52:01 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
00000fe101000-0x00000000fe112fff] reserved
May 16 11:52:01 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
00000feb00000-0x00000000feb0ffff] reserved
May 16 11:52:01 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
00000fec00000-0x00000000fec00fff] reserved
May 16 11:52:01 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
00000fed00000-0x00000000fee00fff] reserved
May 16 11:52:01 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
00000ffc00000-0x00000000ffffffff] reserved
May 16 11:52:01 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
0000100000000-0x000000025f5fffff] usable
May 16 11:52:01 brian-laptop kernel: [    0.000000] NX (Execute Disable) =
protection: active
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: EFI v2.31 by INS=
YDE Corp.
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi:  ACPI=3D0x9cffe0=
00  ACPI 2.0=3D0x9cffe014  SMBIOS=3D0x9cebef98=20
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem00: type=3D3,=
 attr=3D0xf, range=3D[0x0000000000000000-0x0000000000001000) (0MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem01: type=3D7,=
 attr=3D0xf, range=3D[0x0000000000001000-0x000000000000e000) (0MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem02: type=3D3,=
 attr=3D0xf, range=3D[0x000000000000e000-0x0000000000010000) (0MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem03: type=3D7,=
 attr=3D0xf, range=3D[0x0000000000010000-0x000000000002e000) (0MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem04: type=3D3,=
 attr=3D0xf, range=3D[0x000000000002e000-0x000000000002f000) (0MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem05: type=3D4,=
 attr=3D0xf, range=3D[0x000000000002f000-0x0000000000030000) (0MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem06: type=3D3,=
 attr=3D0xf, range=3D[0x0000000000030000-0x000000000006f000) (0MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem07: type=3D0,=
 attr=3D0xf, range=3D[0x000000000006f000-0x0000000000070000) (0MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem08: type=3D3,=
 attr=3D0xf, range=3D[0x0000000000070000-0x0000000000088000) (0MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem09: type=3D6,=
 attr=3D0x800000000000000f, range=3D[0x0000000000088000-0x000000000009e00=
0) (0MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem10: type=3D0,=
 attr=3D0xf, range=3D[0x000000000009e000-0x000000000009f000) (0MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem11: type=3D6,=
 attr=3D0x800000000000000f, range=3D[0x000000000009f000-0x00000000000a000=
0) (0MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem12: type=3D2,=
 attr=3D0xf, range=3D[0x0000000000100000-0x00000000014ff000) (19MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem13: type=3D7,=
 attr=3D0xf, range=3D[0x00000000014ff000-0x0000000002000000) (11MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem14: type=3D2,=
 attr=3D0xf, range=3D[0x0000000002000000-0x00000000033ff000) (19MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem15: type=3D7,=
 attr=3D0xf, range=3D[0x00000000033ff000-0x0000000035b9c000) (807MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem16: type=3D2,=
 attr=3D0xf, range=3D[0x0000000035b9c000-0x0000000036dc6000) (18MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem17: type=3D7,=
 attr=3D0xf, range=3D[0x0000000036dc6000-0x0000000053db5000) (463MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem18: type=3D2,=
 attr=3D0xf, range=3D[0x0000000053db5000-0x0000000078d10000) (591MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem19: type=3D4,=
 attr=3D0xf, range=3D[0x0000000078d10000-0x0000000078d30000) (0MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem20: type=3D7,=
 attr=3D0xf, range=3D[0x0000000078d30000-0x00000000798a4000) (11MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem21: type=3D2,=
 attr=3D0xf, range=3D[0x00000000798a4000-0x0000000079a78000) (1MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem22: type=3D4,=
 attr=3D0xf, range=3D[0x0000000079a78000-0x000000007a900000) (14MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem23: type=3D0,=
 attr=3D0xf, range=3D[0x000000007a900000-0x000000007bd00000) (20MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem24: type=3D7,=
 attr=3D0xf, range=3D[0x000000007bd00000-0x000000007bd0d000) (0MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem25: type=3D2,=
 attr=3D0xf, range=3D[0x000000007bd0d000-0x000000007bd0f000) (0MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem26: type=3D7,=
 attr=3D0xf, range=3D[0x000000007bd0f000-0x000000007bddb000) (0MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem27: type=3D1,=
 attr=3D0xf, range=3D[0x000000007bddb000-0x000000007bf0f000) (1MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem28: type=3D7,=
 attr=3D0xf, range=3D[0x000000007bf0f000-0x000000007e1c3000) (34MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem29: type=3D4,=
 attr=3D0xf, range=3D[0x000000007e1c3000-0x000000007e1cf000) (0MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem30: type=3D7,=
 attr=3D0xf, range=3D[0x000000007e1cf000-0x000000007e20b000) (0MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem31: type=3D4,=
 attr=3D0xf, range=3D[0x000000007e20b000-0x000000007eee1000) (12MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem32: type=3D7,=
 attr=3D0xf, range=3D[0x000000007eee1000-0x000000007eee3000) (0MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem33: type=3D4,=
 attr=3D0xf, range=3D[0x000000007eee3000-0x0000000081f91000) (48MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem34: type=3D7,=
 attr=3D0xf, range=3D[0x0000000081f91000-0x0000000081f94000) (0MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem35: type=3D4,=
 attr=3D0xf, range=3D[0x0000000081f94000-0x0000000081fbd000) (0MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem36: type=3D7,=
 attr=3D0xf, range=3D[0x0000000081fbd000-0x0000000081fbe000) (0MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem37: type=3D4,=
 attr=3D0xf, range=3D[0x0000000081fbe000-0x0000000082161000) (1MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem38: type=3D7,=
 attr=3D0xf, range=3D[0x0000000082161000-0x0000000082165000) (0MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem39: type=3D4,=
 attr=3D0xf, range=3D[0x0000000082165000-0x000000008216a000) (0MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem40: type=3D7,=
 attr=3D0xf, range=3D[0x000000008216a000-0x000000008216b000) (0MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem41: type=3D4,=
 attr=3D0xf, range=3D[0x000000008216b000-0x00000000821d9000) (0MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem42: type=3D7,=
 attr=3D0xf, range=3D[0x00000000821d9000-0x00000000821da000) (0MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem43: type=3D4,=
 attr=3D0xf, range=3D[0x00000000821da000-0x00000000821e1000) (0MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem44: type=3D7,=
 attr=3D0xf, range=3D[0x00000000821e1000-0x00000000821e4000) (0MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem45: type=3D4,=
 attr=3D0xf, range=3D[0x00000000821e4000-0x00000000821e6000) (0MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem46: type=3D7,=
 attr=3D0xf, range=3D[0x00000000821e6000-0x00000000821e8000) (0MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem47: type=3D4,=
 attr=3D0xf, range=3D[0x00000000821e8000-0x000000008408f000) (30MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem48: type=3D7,=
 attr=3D0xf, range=3D[0x000000008408f000-0x000000008c2a5000) (130MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem49: type=3D3,=
 attr=3D0xf, range=3D[0x000000008c2a5000-0x000000008c2c6000) (0MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem50: type=3D7,=
 attr=3D0xf, range=3D[0x000000008c2c6000-0x000000009c2bc000) (255MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem51: type=3D2,=
 attr=3D0xf, range=3D[0x000000009c2bc000-0x000000009c2c6000) (0MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem52: type=3D3,=
 attr=3D0xf, range=3D[0x000000009c2c6000-0x000000009c6bf000) (3MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem53: type=3D5,=
 attr=3D0x800000000000000f, range=3D[0x000000009c6bf000-0x000000009c8bf00=
0) (2MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem54: type=3D6,=
 attr=3D0x800000000000000f, range=3D[0x000000009c8bf000-0x000000009cabf00=
0) (2MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem55: type=3D0,=
 attr=3D0xf, range=3D[0x000000009cabf000-0x000000009cebf000) (4MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem56: type=3D10=
, attr=3D0xf, range=3D[0x000000009cebf000-0x000000009cfbf000) (1MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem57: type=3D9,=
 attr=3D0xf, range=3D[0x000000009cfbf000-0x000000009cfff000) (0MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem58: type=3D4,=
 attr=3D0xf, range=3D[0x000000009cfff000-0x000000009d000000) (0MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem59: type=3D7,=
 attr=3D0xf, range=3D[0x0000000100000000-0x000000025f600000) (5622MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem60: type=3D0,=
 attr=3D0x0, range=3D[0x00000000000a0000-0x00000000000c0000) (0MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem61: type=3D0,=
 attr=3D0x0, range=3D[0x000000009d000000-0x000000009fa00000) (42MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem62: type=3D11=
, attr=3D0x8000000000000001, range=3D[0x00000000e0000000-0x00000000f00000=
00) (256MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem63: type=3D0,=
 attr=3D0x0, range=3D[0x00000000fe101000-0x00000000fe113000) (0MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem64: type=3D11=
, attr=3D0x8000000000000001, range=3D[0x00000000feb00000-0x00000000feb100=
00) (0MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem65: type=3D11=
, attr=3D0x8000000000000001, range=3D[0x00000000fec00000-0x00000000fec010=
00) (0MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem66: type=3D11=
, attr=3D0x8000000000000001, range=3D[0x00000000fed00000-0x00000000fed1c0=
00) (0MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem67: type=3D11=
, attr=3D0x8000000000000000, range=3D[0x00000000fed1c000-0x00000000fed200=
00) (0MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem68: type=3D11=
, attr=3D0x8000000000000001, range=3D[0x00000000fed20000-0x00000000fee010=
00) (0MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] efi: mem69: type=3D11=
, attr=3D0x8000000000000000, range=3D[0x00000000ffc00000-0x00000001000000=
00) (4MB)
May 16 11:52:01 brian-laptop kernel: [    0.000000] SMBIOS 2.7 present.
May 16 11:52:01 brian-laptop kernel: [    0.000000] DMI: LENOVO 20266/Yog=
a2, BIOS 76CN27WW 09/17/2013
May 16 11:52:01 brian-laptop kernel: [    0.000000] e820: update [mem 0x0=
0000000-0x00000fff] usable =3D=3D> reserved
May 16 11:52:01 brian-laptop kernel: [    0.000000] e820: remove [mem 0x0=
00a0000-0x000fffff] usable
May 16 11:52:01 brian-laptop kernel: [    0.000000] No AGP bridge found
May 16 11:52:01 brian-laptop kernel: [    0.000000] e820: last_pfn =3D 0x=
25f600 max_arch_pfn =3D 0x400000000
May 16 11:52:01 brian-laptop kernel: [    0.000000] MTRR default type: un=
cachable
May 16 11:52:01 brian-laptop kernel: [    0.000000] MTRR fixed ranges ena=
bled:
May 16 11:52:01 brian-laptop kernel: [    0.000000]   00000-9FFFF write-b=
ack
May 16 11:52:01 brian-laptop kernel: [    0.000000]   A0000-BFFFF uncacha=
ble
May 16 11:52:01 brian-laptop kernel: [    0.000000]   C0000-E7FFF write-p=
rotect
May 16 11:52:01 brian-laptop kernel: [    0.000000]   E8000-EFFFF write-c=
ombining
May 16 11:52:01 brian-laptop kernel: [    0.000000]   F0000-FFFFF write-p=
rotect
May 16 11:52:01 brian-laptop kernel: [    0.000000] MTRR variable ranges =
enabled:
May 16 11:52:01 brian-laptop kernel: [    0.000000]   0 base 0000000000 m=
ask 7F80000000 write-back
May 16 11:52:01 brian-laptop kernel: [    0.000000]   1 base 0080000000 m=
ask 7FE0000000 write-back
May 16 11:52:01 brian-laptop kernel: [    0.000000]   2 base 009D000000 m=
ask 7FFF000000 uncachable
May 16 11:52:01 brian-laptop kernel: [    0.000000]   3 base 009E000000 m=
ask 7FFE000000 uncachable
May 16 11:52:01 brian-laptop kernel: [    0.000000]   4 base 00FFC00000 m=
ask 7FFFC00000 write-protect
May 16 11:52:01 brian-laptop kernel: [    0.000000]   5 base 0100000000 m=
ask 7F00000000 write-back
May 16 11:52:01 brian-laptop kernel: [    0.000000]   6 base 0200000000 m=
ask 7F80000000 write-back
May 16 11:52:01 brian-laptop kernel: [    0.000000]   7 base 025F600000 m=
ask 7FFFE00000 uncachable
May 16 11:52:01 brian-laptop kernel: [    0.000000]   8 base 025F800000 m=
ask 7FFF800000 uncachable
May 16 11:52:01 brian-laptop kernel: [    0.000000]   9 base 0260000000 m=
ask 7FE0000000 uncachable
May 16 11:52:01 brian-laptop kernel: [    0.000000] x86 PAT enabled: cpu =
0, old 0x7040600070406, new 0x7010600070106
May 16 11:52:01 brian-laptop kernel: [    0.000000] e820: last_pfn =3D 0x=
9d000 max_arch_pfn =3D 0x400000000
May 16 11:52:01 brian-laptop kernel: [    0.000000] found SMP MP-table at=
 [mem 0x000fe1b0-0x000fe1bf] mapped at [ffff8800000fe1b0]
May 16 11:52:01 brian-laptop kernel: [    0.000000] Scanning 1 areas for =
low memory corruption
May 16 11:52:01 brian-laptop kernel: [    0.000000] Base memory trampolin=
e at [ffff880000024000] 24000 size 24576
May 16 11:52:01 brian-laptop kernel: [    0.000000] Using GB pages for di=
rect mapping
May 16 11:52:01 brian-laptop kernel: [    0.000000] init_memory_mapping: =
[mem 0x00000000-0x000fffff]
May 16 11:52:01 brian-laptop kernel: [    0.000000]  [mem 0x00000000-0x00=
0fffff] page 4k
May 16 11:52:01 brian-laptop kernel: [    0.000000] BRK [0x02fdd000, 0x02=
fddfff] PGTABLE
May 16 11:52:01 brian-laptop kernel: [    0.000000] BRK [0x02fde000, 0x02=
fdefff] PGTABLE
May 16 11:52:01 brian-laptop kernel: [    0.000000] BRK [0x02fdf000, 0x02=
fdffff] PGTABLE
May 16 11:52:01 brian-laptop kernel: [    0.000000] init_memory_mapping: =
[mem 0x25f400000-0x25f5fffff]
May 16 11:52:01 brian-laptop kernel: [    0.000000]  [mem 0x25f400000-0x2=
5f5fffff] page 2M
May 16 11:52:01 brian-laptop kernel: [    0.000000] BRK [0x02fe0000, 0x02=
fe0fff] PGTABLE
May 16 11:52:01 brian-laptop kernel: [    0.000000] init_memory_mapping: =
[mem 0x25c000000-0x25f3fffff]
May 16 11:52:01 brian-laptop kernel: [    0.000000]  [mem 0x25c000000-0x2=
5f3fffff] page 2M
May 16 11:52:01 brian-laptop kernel: [    0.000000] init_memory_mapping: =
[mem 0x200000000-0x25bffffff]
May 16 11:52:01 brian-laptop kernel: [    0.000000]  [mem 0x200000000-0x2=
3fffffff] page 1G
May 16 11:52:01 brian-laptop kernel: [    0.000000]  [mem 0x240000000-0x2=
5bffffff] page 2M
May 16 11:52:01 brian-laptop kernel: [    0.000000] init_memory_mapping: =
[mem 0x00100000-0x7a8fffff]
May 16 11:52:01 brian-laptop kernel: [    0.000000]  [mem 0x00100000-0x00=
1fffff] page 4k
May 16 11:52:01 brian-laptop kernel: [    0.000000]  [mem 0x00200000-0x7a=
7fffff] page 2M
May 16 11:52:01 brian-laptop kernel: [    0.000000]  [mem 0x7a800000-0x7a=
8fffff] page 4k
May 16 11:52:01 brian-laptop kernel: [    0.000000] init_memory_mapping: =
[mem 0x7bd00000-0x9c6befff]
May 16 11:52:01 brian-laptop kernel: [    0.000000]  [mem 0x7bd00000-0x7b=
dfffff] page 4k
May 16 11:52:01 brian-laptop kernel: [    0.000000]  [mem 0x7be00000-0x9c=
5fffff] page 2M
May 16 11:52:01 brian-laptop kernel: [    0.000000]  [mem 0x9c600000-0x9c=
6befff] page 4k
May 16 11:52:01 brian-laptop kernel: [    0.000000] BRK [0x02fe1000, 0x02=
fe1fff] PGTABLE
May 16 11:52:01 brian-laptop kernel: [    0.000000] BRK [0x02fe2000, 0x02=
fe2fff] PGTABLE
May 16 11:52:01 brian-laptop kernel: [    0.000000] init_memory_mapping: =
[mem 0x9cfff000-0x9cffffff]
May 16 11:52:01 brian-laptop kernel: [    0.000000]  [mem 0x9cfff000-0x9c=
ffffff] page 4k
May 16 11:52:01 brian-laptop kernel: [    0.000000] init_memory_mapping: =
[mem 0x100000000-0x1ffffffff]
May 16 11:52:01 brian-laptop kernel: [    0.000000]  [mem 0x100000000-0x1=
ffffffff] page 1G
May 16 11:52:01 brian-laptop kernel: [    0.000000] RAMDISK: [mem 0x35b9c=
000-0x36dc5fff]
May 16 11:52:01 brian-laptop kernel: [    0.000000] ACPI: RSDP 000000009c=
ffe014 000024 (v02 LENOVO)
May 16 11:52:01 brian-laptop kernel: [    0.000000] ACPI: XSDT 000000009c=
ffe210 0000C4 (v01 LENOVO CB-01    00000001      01000013)
May 16 11:52:01 brian-laptop kernel: [    0.000000] ACPI: FACP 000000009c=
feb000 00010C (v05 LENOVO CB-01    00000001 ACPI 00040000)
May 16 11:52:01 brian-laptop kernel: [    0.000000] ACPI Error: Gpe0Block=
 - 32-bit FADT register is too long (32 bytes, 256 bits) to convert to GA=
S struct - 255 bits max, truncating (20131115/tbfadt-202)
May 16 11:52:01 brian-laptop kernel: [    0.000000] ACPI: DSDT 000000009c=
fda000 00D0CA (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 11:52:01 brian-laptop kernel: [    0.000000] ACPI: FACS 000000009c=
fba000 000040
May 16 11:52:01 brian-laptop kernel: [    0.000000] ACPI: SLIC 000000009c=
ffd000 000176 (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 11:52:01 brian-laptop kernel: [    0.000000] ACPI: UEFI 000000009c=
ffc000 000236 (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 11:52:01 brian-laptop kernel: [    0.000000] ACPI: SSDT 000000009c=
ff0000 00B0FA (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 11:52:01 brian-laptop kernel: [    0.000000] ACPI: FPDT 000000009c=
fee000 000044 (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 11:52:01 brian-laptop kernel: [    0.000000] ACPI: MSDM 000000009c=
fed000 000055 (v03 LENOVO CB-01    00000001 ACPI 00040000)
May 16 11:52:01 brian-laptop kernel: [    0.000000] ACPI: ASF! 000000009c=
fec000 0000A5 (v32 LENOVO CB-01    00000001 ACPI 00040000)
May 16 11:52:01 brian-laptop kernel: [    0.000000] ACPI: HPET 000000009c=
fea000 000038 (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 11:52:01 brian-laptop kernel: [    0.000000] ACPI: APIC 000000009c=
fe9000 00008C (v03 LENOVO CB-01    00000001 ACPI 00040000)
May 16 11:52:01 brian-laptop kernel: [    0.000000] ACPI: MCFG 000000009c=
fe8000 00003C (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 11:52:01 brian-laptop kernel: [    0.000000] ACPI: SSDT 000000009c=
fd7000 002028 (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 11:52:01 brian-laptop kernel: [    0.000000] ACPI: BOOT 000000009c=
fd5000 000028 (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 11:52:01 brian-laptop kernel: [    0.000000] ACPI: LPIT 000000009c=
fd4000 000094 (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 11:52:01 brian-laptop kernel: [    0.000000] ACPI: ASPT 000000009c=
fd2000 000034 (v07 LENOVO CB-01    00000001 ACPI 00040000)
May 16 11:52:01 brian-laptop kernel: [    0.000000] ACPI: DBGP 000000009c=
fd1000 000034 (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 11:52:01 brian-laptop kernel: [    0.000000] ACPI: SSDT 000000009c=
fce000 000539 (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 11:52:01 brian-laptop kernel: [    0.000000] ACPI: SSDT 000000009c=
fcd000 000AD8 (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 11:52:01 brian-laptop kernel: [    0.000000] ACPI: SSDT 000000009c=
fc9000 003496 (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 11:52:01 brian-laptop kernel: [    0.000000] ACPI: SSDT 000000009c=
fc8000 0007C7 (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 11:52:01 brian-laptop kernel: [    0.000000] ACPI: BGRT 000000009c=
fc7000 000038 (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 11:52:01 brian-laptop kernel: [    0.000000] ACPI: Local APIC addr=
ess 0xfee00000
May 16 11:52:01 brian-laptop kernel: [    0.000000] No NUMA configuration=
 found
May 16 11:52:01 brian-laptop kernel: [    0.000000] Faking a node at [mem=
 0x0000000000000000-0x000000025f5fffff]
May 16 11:52:01 brian-laptop kernel: [    0.000000] Initmem setup node 0 =
[mem 0x00000000-0x25f5fffff]
May 16 11:52:01 brian-laptop kernel: [    0.000000]   NODE_DATA [mem 0x25=
f5f7000-0x25f5fbfff]
May 16 11:52:01 brian-laptop kernel: [    0.000000]  [ffffea0000000000-ff=
ffea00097fffff] PMD -> [ffff880256c00000-ffff88025ebfffff] on node 0
May 16 11:52:01 brian-laptop kernel: [    0.000000] Zone ranges:
May 16 11:52:01 brian-laptop kernel: [    0.000000]   DMA      [mem 0x000=
01000-0x00ffffff]
May 16 11:52:01 brian-laptop kernel: [    0.000000]   DMA32    [mem 0x010=
00000-0xffffffff]
May 16 11:52:01 brian-laptop kernel: [    0.000000]   Normal   [mem 0x100=
000000-0x25f5fffff]
May 16 11:52:01 brian-laptop kernel: [    0.000000] Movable zone start fo=
r each node
May 16 11:52:01 brian-laptop kernel: [    0.000000] Early memory node ran=
ges
May 16 11:52:01 brian-laptop kernel: [    0.000000]   node   0: [mem 0x00=
001000-0x0006efff]
May 16 11:52:01 brian-laptop kernel: [    0.000000]   node   0: [mem 0x00=
070000-0x00087fff]
May 16 11:52:01 brian-laptop kernel: [    0.000000]   node   0: [mem 0x00=
100000-0x7a8fffff]
May 16 11:52:01 brian-laptop kernel: [    0.000000]   node   0: [mem 0x7b=
d00000-0x9c6befff]
May 16 11:52:01 brian-laptop kernel: [    0.000000]   node   0: [mem 0x9c=
fff000-0x9cffffff]
May 16 11:52:01 brian-laptop kernel: [    0.000000]   node   0: [mem 0x10=
0000000-0x25f5fffff]
May 16 11:52:01 brian-laptop kernel: [    0.000000] On node 0 totalpages:=
 2074694
May 16 11:52:01 brian-laptop kernel: [    0.000000]   DMA zone: 64 pages =
used for memmap
May 16 11:52:01 brian-laptop kernel: [    0.000000]   DMA zone: 111 pages=
 reserved
May 16 11:52:01 brian-laptop kernel: [    0.000000]   DMA zone: 3974 page=
s, LIFO batch:0
May 16 11:52:01 brian-laptop kernel: [    0.000000]   DMA32 zone: 9867 pa=
ges used for memmap
May 16 11:52:01 brian-laptop kernel: [    0.000000]   DMA32 zone: 631488 =
pages, LIFO batch:31
May 16 11:52:01 brian-laptop kernel: [    0.000000]   Normal zone: 22488 =
pages used for memmap
May 16 11:52:01 brian-laptop kernel: [    0.000000]   Normal zone: 143923=
2 pages, LIFO batch:31
May 16 11:52:01 brian-laptop kernel: [    0.000000] ACPI: PM-Timer IO Por=
t: 0x1808
May 16 11:52:01 brian-laptop kernel: [    0.000000] ACPI: Local APIC addr=
ess 0xfee00000
May 16 11:52:01 brian-laptop kernel: [    0.000000] ACPI: LAPIC (acpi_id[=
0x01] lapic_id[0x00] enabled)
May 16 11:52:01 brian-laptop kernel: [    0.000000] ACPI: LAPIC (acpi_id[=
0x02] lapic_id[0x01] enabled)
May 16 11:52:01 brian-laptop kernel: [    0.000000] ACPI: LAPIC (acpi_id[=
0x03] lapic_id[0x02] enabled)
May 16 11:52:01 brian-laptop kernel: [    0.000000] ACPI: LAPIC (acpi_id[=
0x04] lapic_id[0x03] enabled)
May 16 11:52:01 brian-laptop kernel: [    0.000000] ACPI: LAPIC (acpi_id[=
0x05] lapic_id[0x00] disabled)
May 16 11:52:01 brian-laptop kernel: [    0.000000] ACPI: LAPIC (acpi_id[=
0x06] lapic_id[0x00] disabled)
May 16 11:52:01 brian-laptop kernel: [    0.000000] ACPI: LAPIC (acpi_id[=
0x07] lapic_id[0x00] disabled)
May 16 11:52:01 brian-laptop kernel: [    0.000000] ACPI: LAPIC (acpi_id[=
0x08] lapic_id[0x00] disabled)
May 16 11:52:01 brian-laptop kernel: [    0.000000] ACPI: IOAPIC (id[0x02=
] address[0xfec00000] gsi_base[0])
May 16 11:52:01 brian-laptop kernel: [    0.000000] IOAPIC[0]: apic_id 2,=
 version 32, address 0xfec00000, GSI 0-39
May 16 11:52:01 brian-laptop kernel: [    0.000000] ACPI: INT_SRC_OVR (bu=
s 0 bus_irq 0 global_irq 2 dfl dfl)
May 16 11:52:01 brian-laptop kernel: [    0.000000] ACPI: INT_SRC_OVR (bu=
s 0 bus_irq 9 global_irq 9 high level)
May 16 11:52:01 brian-laptop kernel: [    0.000000] ACPI: IRQ0 used by ov=
erride.
May 16 11:52:01 brian-laptop kernel: [    0.000000] ACPI: IRQ2 used by ov=
erride.
May 16 11:52:01 brian-laptop kernel: [    0.000000] ACPI: IRQ9 used by ov=
erride.
May 16 11:52:01 brian-laptop kernel: [    0.000000] Using ACPI (MADT) for=
 SMP configuration information
May 16 11:52:01 brian-laptop kernel: [    0.000000] ACPI: HPET id: 0x8086=
a201 base: 0xfed00000
May 16 11:52:01 brian-laptop kernel: [    0.000000] smpboot: Allowing 8 C=
PUs, 4 hotplug CPUs
May 16 11:52:01 brian-laptop kernel: [    0.000000] nr_irqs_gsi: 56
May 16 11:52:01 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0x0006f000-0x0006ffff]
May 16 11:52:01 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0x00088000-0x000bffff]
May 16 11:52:01 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0x000c0000-0x000fffff]
May 16 11:52:01 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0x7a900000-0x7bcfffff]
May 16 11:52:01 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0x9c6bf000-0x9c8befff]
May 16 11:52:01 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0x9c8bf000-0x9cebefff]
May 16 11:52:01 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0x9cebf000-0x9cfbefff]
May 16 11:52:01 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0x9cfbf000-0x9cffefff]
May 16 11:52:01 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0x9d000000-0x9f9fffff]
May 16 11:52:01 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0x9fa00000-0xdfffffff]
May 16 11:52:01 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0xe0000000-0xefffffff]
May 16 11:52:01 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0xf0000000-0xfe100fff]
May 16 11:52:01 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0xfe101000-0xfe112fff]
May 16 11:52:01 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0xfe113000-0xfeafffff]
May 16 11:52:01 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0xfeb00000-0xfeb0ffff]
May 16 11:52:01 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0xfeb10000-0xfebfffff]
May 16 11:52:01 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0xfec00000-0xfec00fff]
May 16 11:52:01 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0xfec01000-0xfecfffff]
May 16 11:52:01 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0xfed00000-0xfee00fff]
May 16 11:52:01 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0xfee01000-0xffbfffff]
May 16 11:52:01 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0xffc00000-0xffffffff]
May 16 11:52:01 brian-laptop kernel: [    0.000000] e820: [mem 0x9fa00000=
-0xdfffffff] available for PCI devices
May 16 11:52:01 brian-laptop kernel: [    0.000000] Booting paravirtualiz=
ed kernel on bare hardware
May 16 11:52:01 brian-laptop kernel: [    0.000000] setup_percpu: NR_CPUS=
:256 nr_cpumask_bits:256 nr_cpu_ids:8 nr_node_ids:1
May 16 11:52:01 brian-laptop kernel: [    0.000000] PERCPU: Embedded 29 p=
ages/cpu @ffff88025f200000 s86336 r8192 d24256 u262144
May 16 11:52:01 brian-laptop kernel: [    0.000000] pcpu-alloc: s86336 r8=
192 d24256 u262144 alloc=3D1*2097152
May 16 11:52:01 brian-laptop kernel: [    0.000000] pcpu-alloc: [0] 0 1 2=
 3 4 5 6 7=20
May 16 11:52:01 brian-laptop kernel: [    0.000000] Built 1 zonelists in =
Zone order, mobility grouping on.  Total pages: 2042164
May 16 11:52:01 brian-laptop kernel: [    0.000000] Policy zone: Normal
May 16 11:52:01 brian-laptop kernel: [    0.000000] Kernel command line: =
BOOT_IMAGE=3D/boot/vmlinuz-3.13.0-24-generic.efi.signed root=3DUUID=3D8e4=
7fdb9-aff2-414b-a81c-2df6486162cd ro acpi_backlight=3Dvendor quiet splash=
 vt.handoff=3D7
May 16 11:52:01 brian-laptop kernel: [    0.000000] PID hash table entrie=
s: 4096 (order: 3, 32768 bytes)
May 16 11:52:01 brian-laptop kernel: [    0.000000] xsave: enabled xstate=
_bv 0x7, cntxt size 0x340
May 16 11:52:01 brian-laptop kernel: [    0.000000] Checking aperture...
May 16 11:52:01 brian-laptop kernel: [    0.000000] No AGP bridge found
May 16 11:52:01 brian-laptop kernel: [    0.000000] Calgary: detecting Ca=
lgary via BIOS EBDA area
May 16 11:52:01 brian-laptop kernel: [    0.000000] Calgary: Unable to lo=
cate Rio Grande table in EBDA - bailing!
May 16 11:52:01 brian-laptop kernel: [    0.000000] Memory: 7949148K/8298=
776K available (7338K kernel code, 1138K rwdata, 3388K rodata, 1332K init=
, 1440K bss, 349628K reserved)
May 16 11:52:01 brian-laptop kernel: [    0.000000] SLUB: HWalign=3D64, O=
rder=3D0-3, MinObjects=3D0, CPUs=3D8, Nodes=3D1
May 16 11:52:01 brian-laptop kernel: [    0.000000] Hierarchical RCU impl=
ementation.
May 16 11:52:01 brian-laptop kernel: [    0.000000] 	RCU dyntick-idle gra=
ce-period acceleration is enabled.
May 16 11:52:01 brian-laptop kernel: [    0.000000] 	RCU restricting CPUs=
 from NR_CPUS=3D256 to nr_cpu_ids=3D8.
May 16 11:52:01 brian-laptop kernel: [    0.000000] 	Offload RCU callback=
s from all CPUs
May 16 11:52:01 brian-laptop kernel: [    0.000000] 	Offload RCU callback=
s from CPUs: 0-7.
May 16 11:52:01 brian-laptop kernel: [    0.000000] NR_IRQS:16640 nr_irqs=
:1016 16
May 16 11:52:01 brian-laptop kernel: [    0.000000] Console: colour dummy=
 device 80x25
May 16 11:52:01 brian-laptop kernel: [    0.000000] console [tty0] enable=
d
May 16 11:52:01 brian-laptop kernel: [    0.000000] allocated 33554432 by=
tes of page_cgroup
May 16 11:52:01 brian-laptop kernel: [    0.000000] please try 'cgroup_di=
sable=3Dmemory' option if you don't want memory cgroups
May 16 11:52:01 brian-laptop kernel: [    0.000000] hpet clockevent regis=
tered
May 16 11:52:01 brian-laptop kernel: [    0.000000] tsc: Fast TSC calibra=
tion failed
May 16 11:52:01 brian-laptop kernel: [    0.008000] tsc: PIT calibration =
matches HPET. 1 loops
May 16 11:52:01 brian-laptop kernel: [    0.008000] tsc: Detected 2394.46=
7 MHz processor
May 16 11:52:01 brian-laptop kernel: [    0.000003] Calibrating delay loo=
p (skipped), value calculated using timer frequency.. 4788.93 BogoMIPS (l=
pj=3D9577868)
May 16 11:52:01 brian-laptop kernel: [    0.000006] pid_max: default: 327=
68 minimum: 301
May 16 11:52:01 brian-laptop kernel: [    0.023259] Security Framework in=
itialized
May 16 11:52:01 brian-laptop kernel: [    0.023283] AppArmor: AppArmor in=
itialized
May 16 11:52:01 brian-laptop kernel: [    0.023284] Yama: becoming mindfu=
l.
May 16 11:52:01 brian-laptop kernel: [    0.024050] Dentry cache hash tab=
le entries: 1048576 (order: 11, 8388608 bytes)
May 16 11:52:01 brian-laptop kernel: [    0.026086] Inode-cache hash tabl=
e entries: 524288 (order: 10, 4194304 bytes)
May 16 11:52:01 brian-laptop kernel: [    0.026944] Mount-cache hash tabl=
e entries: 16384 (order: 5, 131072 bytes)
May 16 11:52:01 brian-laptop kernel: [    0.026957] Mountpoint-cache hash=
 table entries: 16384 (order: 5, 131072 bytes)
May 16 11:52:01 brian-laptop kernel: [    0.027193] Initializing cgroup s=
ubsys memory
May 16 11:52:01 brian-laptop kernel: [    0.027199] Initializing cgroup s=
ubsys devices
May 16 11:52:01 brian-laptop kernel: [    0.027201] Initializing cgroup s=
ubsys freezer
May 16 11:52:01 brian-laptop kernel: [    0.027203] Initializing cgroup s=
ubsys blkio
May 16 11:52:01 brian-laptop kernel: [    0.027204] Initializing cgroup s=
ubsys perf_event
May 16 11:52:01 brian-laptop kernel: [    0.027207] Initializing cgroup s=
ubsys hugetlb
May 16 11:52:01 brian-laptop kernel: [    0.027234] CPU: Physical Process=
or ID: 0
May 16 11:52:01 brian-laptop kernel: [    0.027235] CPU: Processor Core I=
D: 0
May 16 11:52:01 brian-laptop kernel: [    0.027240] ENERGY_PERF_BIAS: Set=
 to 'normal', was 'performance'
May 16 11:52:01 brian-laptop kernel: [    0.027240] ENERGY_PERF_BIAS: Vie=
w and update with x86_energy_perf_policy(8)
May 16 11:52:01 brian-laptop kernel: [    0.028435] mce: CPU supports 7 M=
CE banks
May 16 11:52:01 brian-laptop kernel: [    0.028453] CPU0: Thermal monitor=
ing enabled (TM1)
May 16 11:52:01 brian-laptop kernel: [    0.028466] Last level iTLB entri=
es: 4KB 0, 2MB 0, 4MB 0
May 16 11:52:01 brian-laptop kernel: [    0.028466] Last level dTLB entri=
es: 4KB 64, 2MB 0, 4MB 0
May 16 11:52:01 brian-laptop kernel: [    0.028466] tlb_flushall_shift: 6=

May 16 11:52:01 brian-laptop kernel: [    0.028598] Freeing SMP alternati=
ves memory: 32K (ffffffff81e6b000 - ffffffff81e73000)
May 16 11:52:01 brian-laptop kernel: [    0.029801] ACPI: Core revision 2=
0131115
May 16 11:52:01 brian-laptop kernel: [    0.043476] ACPI: All ACPI Tables=
 successfully acquired
May 16 11:52:01 brian-laptop kernel: [    0.050757] ftrace: allocating 28=
408 entries in 111 pages
May 16 11:52:01 brian-laptop kernel: [    0.066895] ..TIMER: vector=3D0x3=
0 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
May 16 11:52:01 brian-laptop kernel: [    0.106614] smpboot: CPU0: Intel(=
R) Core(TM) i7-4500U CPU @ 1.80GHz (fam: 06, model: 45, stepping: 01)
May 16 11:52:01 brian-laptop kernel: [    0.106624] TSC deadline timer en=
abled
May 16 11:52:01 brian-laptop kernel: [    0.109059] Performance Events: P=
EBS fmt2+, 16-deep LBR, Haswell events, full-width counters, Intel PMU dr=
iver.
May 16 11:52:01 brian-laptop kernel: [    0.109068] ... version:         =
       3
May 16 11:52:01 brian-laptop kernel: [    0.109070] ... bit width:       =
       48
May 16 11:52:01 brian-laptop kernel: [    0.109071] ... generic registers=
:      4
May 16 11:52:01 brian-laptop kernel: [    0.109072] ... value mask:      =
       0000ffffffffffff
May 16 11:52:01 brian-laptop kernel: [    0.109073] ... max period:      =
       0000ffffffffffff
May 16 11:52:01 brian-laptop kernel: [    0.109074] ... fixed-purpose eve=
nts:   3
May 16 11:52:01 brian-laptop kernel: [    0.109076] ... event mask:      =
       000000070000000f
May 16 11:52:01 brian-laptop kernel: [    0.111131] x86: Booting SMP conf=
iguration:
May 16 11:52:01 brian-laptop kernel: [    0.125782] NMI watchdog: enabled=
 on all CPUs, permanently consumes one hw-PMU counter.
May 16 11:52:01 brian-laptop kernel: [    0.111134] .... node  #0, CPUs: =
     #1 #2 #3
May 16 11:52:01 brian-laptop kernel: [    0.154693] x86: Booted up 1 node=
, 4 CPUs
May 16 11:52:01 brian-laptop kernel: [    0.154696] smpboot: Total of 4 p=
rocessors activated (19155.73 BogoMIPS)
May 16 11:52:01 brian-laptop kernel: [    0.160393] devtmpfs: initialized=

May 16 11:52:01 brian-laptop kernel: [    0.163261] EVM: security.selinux=

May 16 11:52:01 brian-laptop kernel: [    0.163262] EVM: security.SMACK64=

May 16 11:52:01 brian-laptop kernel: [    0.163264] EVM: security.ima
May 16 11:52:01 brian-laptop kernel: [    0.163265] EVM: security.capabil=
ity
May 16 11:52:01 brian-laptop kernel: [    0.163324] PM: Registering ACPI =
NVS region [mem 0x9cebf000-0x9cfbefff] (1048576 bytes)
May 16 11:52:01 brian-laptop kernel: [    0.164217] pinctrl core: initial=
ized pinctrl subsystem
May 16 11:52:01 brian-laptop kernel: [    0.164280] regulator-dummy: no p=
arameters
May 16 11:52:01 brian-laptop kernel: [    0.164342] RTC time: 11:51:59, d=
ate: 05/16/14
May 16 11:52:01 brian-laptop kernel: [    0.164379] NET: Registered proto=
col family 16
May 16 11:52:01 brian-laptop kernel: [    0.164491] cpuidle: using govern=
or ladder
May 16 11:52:01 brian-laptop kernel: [    0.164493] cpuidle: using govern=
or menu
May 16 11:52:01 brian-laptop kernel: [    0.164540] ACPI FADT declares th=
e system doesn't support PCIe ASPM, so disable it
May 16 11:52:01 brian-laptop kernel: [    0.164543] ACPI: bus type PCI re=
gistered
May 16 11:52:01 brian-laptop kernel: [    0.164545] acpiphp: ACPI Hot Plu=
g PCI Controller Driver version: 0.5
May 16 11:52:01 brian-laptop kernel: [    0.164615] PCI: MMCONFIG for dom=
ain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
May 16 11:52:01 brian-laptop kernel: [    0.164617] PCI: MMCONFIG at [mem=
 0xe0000000-0xefffffff] reserved in E820
May 16 11:52:01 brian-laptop kernel: [    0.197814] PCI: Using configurat=
ion type 1 for base access
May 16 11:52:01 brian-laptop kernel: [    0.198857] bio: create slab <bio=
-0> at 0
May 16 11:52:01 brian-laptop kernel: [    0.199023] ACPI: Added _OSI(Modu=
le Device)
May 16 11:52:01 brian-laptop kernel: [    0.199025] ACPI: Added _OSI(Proc=
essor Device)
May 16 11:52:01 brian-laptop kernel: [    0.199027] ACPI: Added _OSI(3.0 =
_SCP Extensions)
May 16 11:52:01 brian-laptop kernel: [    0.199029] ACPI: Added _OSI(Proc=
essor Aggregator Device)
May 16 11:52:01 brian-laptop kernel: [    0.206330] ACPI: Executed 1 bloc=
ks of module-level executable AML code
May 16 11:52:01 brian-laptop kernel: [    0.220264] [Firmware Bug]: ACPI:=
 BIOS _OSI(Linux) query ignored
May 16 11:52:01 brian-laptop kernel: [    0.221377] ACPI: SSDT 000000009c=
e7cc18 0003D3 (v01  PmRef  Cpu0Cst 00003001 INTL 20121220)
May 16 11:52:01 brian-laptop kernel: [    0.222275] ACPI: Dynamic OEM Tab=
le Load:
May 16 11:52:01 brian-laptop kernel: [    0.222277] ACPI: SSDT           =
(null) 0003D3 (v01  PmRef  Cpu0Cst 00003001 INTL 20121220)
May 16 11:52:01 brian-laptop kernel: [    0.224536] ACPI: SSDT 000000009c=
e7c618 0005AA (v01  PmRef    ApIst 00003000 INTL 20121220)
May 16 11:52:01 brian-laptop kernel: [    0.225519] ACPI: Dynamic OEM Tab=
le Load:
May 16 11:52:01 brian-laptop kernel: [    0.225521] ACPI: SSDT           =
(null) 0005AA (v01  PmRef    ApIst 00003000 INTL 20121220)
May 16 11:52:01 brian-laptop kernel: [    0.228359] ACPI: SSDT 000000009c=
e86c18 000119 (v01  PmRef    ApCst 00003000 INTL 20121220)
May 16 11:52:01 brian-laptop kernel: [    0.229254] ACPI: Dynamic OEM Tab=
le Load:
May 16 11:52:01 brian-laptop kernel: [    0.229256] ACPI: SSDT           =
(null) 000119 (v01  PmRef    ApCst 00003000 INTL 20121220)
May 16 11:52:01 brian-laptop kernel: [    0.235257] ACPI: Interpreter ena=
bled
May 16 11:52:01 brian-laptop kernel: [    0.235266] ACPI Exception: AE_NO=
T_FOUND, While evaluating Sleep State [\_S1_] (20131115/hwxface-580)
May 16 11:52:01 brian-laptop kernel: [    0.235274] ACPI Exception: AE_NO=
T_FOUND, While evaluating Sleep State [\_S2_] (20131115/hwxface-580)
May 16 11:52:01 brian-laptop kernel: [    0.235296] ACPI: (supports S0 S3=
 S4 S5)
May 16 11:52:01 brian-laptop kernel: [    0.235298] ACPI: Using IOAPIC fo=
r interrupt routing
May 16 11:52:01 brian-laptop kernel: [    0.235330] PCI: Using host bridg=
e windows from ACPI; if necessary, use "pci=3Dnocrs" and report a bug
May 16 11:52:01 brian-laptop kernel: [    0.235613] ACPI: No dock devices=
 found.
May 16 11:52:01 brian-laptop kernel: [    0.247463] ACPI: PCI Root Bridge=
 [PCI0] (domain 0000 [bus 00-fe])
May 16 11:52:01 brian-laptop kernel: [    0.247470] acpi PNP0A08:00: _OSC=
: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
May 16 11:52:01 brian-laptop kernel: [    0.248241] acpi PNP0A08:00: _OSC=
: OS now controls [PCIeHotplug PME AER PCIeCapability]
May 16 11:52:01 brian-laptop kernel: [    0.249248] PCI host bridge to bu=
s 0000:00
May 16 11:52:01 brian-laptop kernel: [    0.249252] pci_bus 0000:00: root=
 bus resource [bus 00-fe]
May 16 11:52:01 brian-laptop kernel: [    0.249255] pci_bus 0000:00: root=
 bus resource [io  0x0000-0x0cf7]
May 16 11:52:01 brian-laptop kernel: [    0.249257] pci_bus 0000:00: root=
 bus resource [io  0x0d00-0xffff]
May 16 11:52:01 brian-laptop kernel: [    0.249259] pci_bus 0000:00: root=
 bus resource [mem 0x000a0000-0x000bffff]
May 16 11:52:01 brian-laptop kernel: [    0.249261] pci_bus 0000:00: root=
 bus resource [mem 0x9fa00000-0xfeafffff]
May 16 11:52:01 brian-laptop kernel: [    0.249271] pci 0000:00:00.0: [80=
86:0a04] type 00 class 0x060000
May 16 11:52:01 brian-laptop kernel: [    0.249473] pci 0000:00:02.0: [80=
86:0a16] type 00 class 0x030000
May 16 11:52:01 brian-laptop kernel: [    0.249489] pci 0000:00:02.0: reg=
 0x10: [mem 0xb0000000-0xb03fffff 64bit]
May 16 11:52:01 brian-laptop kernel: [    0.249498] pci 0000:00:02.0: reg=
 0x18: [mem 0xa0000000-0xafffffff 64bit pref]
May 16 11:52:01 brian-laptop kernel: [    0.249504] pci 0000:00:02.0: reg=
 0x20: [io  0x3000-0x303f]
May 16 11:52:01 brian-laptop kernel: [    0.249694] pci 0000:00:03.0: [80=
86:0a0c] type 00 class 0x040300
May 16 11:52:01 brian-laptop kernel: [    0.249705] pci 0000:00:03.0: reg=
 0x10: [mem 0xb0518000-0xb051bfff 64bit]
May 16 11:52:01 brian-laptop kernel: [    0.249906] pci 0000:00:04.0: [80=
86:0a03] type 00 class 0x118000
May 16 11:52:01 brian-laptop kernel: [    0.249922] pci 0000:00:04.0: reg=
 0x10: [mem 0xb0510000-0xb0517fff 64bit]
May 16 11:52:01 brian-laptop kernel: [    0.250179] pci 0000:00:14.0: [80=
86:9c31] type 00 class 0x0c0330
May 16 11:52:01 brian-laptop kernel: [    0.250228] pci 0000:00:14.0: reg=
 0x10: [mem 0xb0500000-0xb050ffff 64bit]
May 16 11:52:01 brian-laptop kernel: [    0.250391] pci 0000:00:14.0: PME=
# supported from D3hot D3cold
May 16 11:52:01 brian-laptop kernel: [    0.250547] pci 0000:00:14.0: Sys=
tem wakeup disabled by ACPI
May 16 11:52:01 brian-laptop kernel: [    0.250596] pci 0000:00:16.0: [80=
86:9c3a] type 00 class 0x078000
May 16 11:52:01 brian-laptop kernel: [    0.250647] pci 0000:00:16.0: reg=
 0x10: [mem 0xb0520000-0xb052001f 64bit]
May 16 11:52:01 brian-laptop kernel: [    0.250821] pci 0000:00:16.0: PME=
# supported from D0 D3hot D3cold
May 16 11:52:01 brian-laptop kernel: [    0.251049] pci 0000:00:1b.0: [80=
86:9c20] type 00 class 0x040300
May 16 11:52:01 brian-laptop kernel: [    0.251085] pci 0000:00:1b.0: reg=
 0x10: [mem 0xb051c000-0xb051ffff 64bit]
May 16 11:52:01 brian-laptop kernel: [    0.251259] pci 0000:00:1b.0: PME=
# supported from D0 D3hot D3cold
May 16 11:52:01 brian-laptop kernel: [    0.251421] pci 0000:00:1b.0: Sys=
tem wakeup disabled by ACPI
May 16 11:52:01 brian-laptop kernel: [    0.251470] pci 0000:00:1c.0: [80=
86:9c10] type 01 class 0x060400
May 16 11:52:01 brian-laptop kernel: [    0.251662] pci 0000:00:1c.0: PME=
# supported from D0 D3hot D3cold
May 16 11:52:01 brian-laptop kernel: [    0.251831] pci 0000:00:1c.0: Sys=
tem wakeup disabled by ACPI
May 16 11:52:01 brian-laptop kernel: [    0.251899] pci 0000:00:1d.0: [80=
86:9c26] type 00 class 0x0c0320
May 16 11:52:01 brian-laptop kernel: [    0.251947] pci 0000:00:1d.0: reg=
 0x10: [mem 0xb0524000-0xb05243ff]
May 16 11:52:01 brian-laptop kernel: [    0.252164] pci 0000:00:1d.0: PME=
# supported from D0 D3hot D3cold
May 16 11:52:01 brian-laptop kernel: [    0.252349] pci 0000:00:1d.0: Sys=
tem wakeup disabled by ACPI
May 16 11:52:01 brian-laptop kernel: [    0.252399] pci 0000:00:1f.0: [80=
86:9c43] type 00 class 0x060100
May 16 11:52:01 brian-laptop kernel: [    0.252819] pci 0000:00:1f.2: [80=
86:9c03] type 00 class 0x010601
May 16 11:52:01 brian-laptop kernel: [    0.252861] pci 0000:00:1f.2: reg=
 0x10: [io  0x3088-0x308f]
May 16 11:52:01 brian-laptop kernel: [    0.252880] pci 0000:00:1f.2: reg=
 0x14: [io  0x3094-0x3097]
May 16 11:52:01 brian-laptop kernel: [    0.252898] pci 0000:00:1f.2: reg=
 0x18: [io  0x3080-0x3087]
May 16 11:52:01 brian-laptop kernel: [    0.252917] pci 0000:00:1f.2: reg=
 0x1c: [io  0x3090-0x3093]
May 16 11:52:01 brian-laptop kernel: [    0.252935] pci 0000:00:1f.2: reg=
 0x20: [io  0x3060-0x307f]
May 16 11:52:01 brian-laptop kernel: [    0.252954] pci 0000:00:1f.2: reg=
 0x24: [mem 0xb0523000-0xb05237ff]
May 16 11:52:01 brian-laptop kernel: [    0.253060] pci 0000:00:1f.2: PME=
# supported from D3hot
May 16 11:52:01 brian-laptop kernel: [    0.253245] pci 0000:00:1f.3: [80=
86:9c22] type 00 class 0x0c0500
May 16 11:52:01 brian-laptop kernel: [    0.253281] pci 0000:00:1f.3: reg=
 0x10: [mem 0xb0521000-0xb05210ff 64bit]
May 16 11:52:01 brian-laptop kernel: [    0.253333] pci 0000:00:1f.3: reg=
 0x20: [io  0x3040-0x305f]
May 16 11:52:01 brian-laptop kernel: [    0.253567] pci 0000:00:1f.6: [80=
86:9c24] type 00 class 0x118000
May 16 11:52:01 brian-laptop kernel: [    0.253628] pci 0000:00:1f.6: reg=
 0x10: [mem 0xb0522000-0xb0522fff 64bit]
May 16 11:52:01 brian-laptop kernel: [    0.254342] pci 0000:01:00.0: [80=
86:08b2] type 00 class 0x028000
May 16 11:52:01 brian-laptop kernel: [    0.254428] pci 0000:01:00.0: reg=
 0x10: [mem 0xb0400000-0xb0401fff 64bit]
May 16 11:52:01 brian-laptop kernel: [    0.254647] pci 0000:01:00.0: PME=
# supported from D0 D3hot D3cold
May 16 11:52:01 brian-laptop kernel: [    0.254738] pci 0000:01:00.0: Sys=
tem wakeup disabled by ACPI
May 16 11:52:01 brian-laptop kernel: [    0.260466] pci 0000:00:1c.0: PCI=
 bridge to [bus 01]
May 16 11:52:01 brian-laptop kernel: [    0.260477] pci 0000:00:1c.0:   b=
ridge window [mem 0xb0400000-0xb04fffff]
May 16 11:52:01 brian-laptop kernel: [    0.260643] acpi PNP0A08:00: Disa=
bling ASPM (FADT indicates it is unsupported)
May 16 11:52:01 brian-laptop kernel: [    0.261967] ACPI: PCI Interrupt L=
ink [LNKA] (IRQs 3 4 5 6 10 11 12 14 15) *7
May 16 11:52:01 brian-laptop kernel: [    0.262026] ACPI: PCI Interrupt L=
ink [LNKB] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
May 16 11:52:01 brian-laptop kernel: [    0.262082] ACPI: PCI Interrupt L=
ink [LNKC] (IRQs 3 4 5 6 10 *11 12 14 15)
May 16 11:52:01 brian-laptop kernel: [    0.262137] ACPI: PCI Interrupt L=
ink [LNKD] (IRQs 3 4 5 6 *10 11 12 14 15)
May 16 11:52:01 brian-laptop kernel: [    0.262191] ACPI: PCI Interrupt L=
ink [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
May 16 11:52:01 brian-laptop kernel: [    0.262245] ACPI: PCI Interrupt L=
ink [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
May 16 11:52:01 brian-laptop kernel: [    0.262299] ACPI: PCI Interrupt L=
ink [LNKG] (IRQs 3 4 5 6 *10 11 12 14 15)
May 16 11:52:01 brian-laptop kernel: [    0.262353] ACPI: PCI Interrupt L=
ink [LNKH] (IRQs 3 4 5 6 10 *11 12 14 15)
May 16 11:52:01 brian-laptop kernel: [    0.263027] ACPI: Enabled 5 GPEs =
in block 00 to 7F
May 16 11:52:01 brian-laptop kernel: [    0.263035] ACPI: \_SB_.PCI0: not=
ify handler is installed
May 16 11:52:01 brian-laptop kernel: [    0.263144] Found 1 acpi root dev=
ices
May 16 11:52:01 brian-laptop kernel: [    0.263202] ACPI : EC: GPE =3D 0x=
a, I/O: command/status =3D 0x66, data =3D 0x62
May 16 11:52:01 brian-laptop kernel: [    0.263303] vgaarb: device added:=
 PCI:0000:00:02.0,decodes=3Dio+mem,owns=3Dio+mem,locks=3Dnone
May 16 11:52:01 brian-laptop kernel: [    0.263307] vgaarb: loaded
May 16 11:52:01 brian-laptop kernel: [    0.263308] vgaarb: bridge contro=
l possible 0000:00:02.0
May 16 11:52:01 brian-laptop kernel: [    0.263470] SCSI subsystem initia=
lized
May 16 11:52:01 brian-laptop kernel: [    0.263522] libata version 3.00 l=
oaded.
May 16 11:52:01 brian-laptop kernel: [    0.263541] ACPI: bus type USB re=
gistered
May 16 11:52:01 brian-laptop kernel: [    0.263556] usbcore: registered n=
ew interface driver usbfs
May 16 11:52:01 brian-laptop kernel: [    0.263565] usbcore: registered n=
ew interface driver hub
May 16 11:52:01 brian-laptop kernel: [    0.263588] usbcore: registered n=
ew device driver usb
May 16 11:52:01 brian-laptop kernel: [    0.263703] PCI: Using ACPI for I=
RQ routing
May 16 11:52:01 brian-laptop kernel: [    0.269637] PCI: pci_cache_line_s=
ize set to 64 bytes
May 16 11:52:01 brian-laptop kernel: [    0.269677] e820: reserve RAM buf=
fer [mem 0x0006f000-0x0006ffff]
May 16 11:52:01 brian-laptop kernel: [    0.269679] e820: reserve RAM buf=
fer [mem 0x00088000-0x0008ffff]
May 16 11:52:01 brian-laptop kernel: [    0.269681] e820: reserve RAM buf=
fer [mem 0x7a900000-0x7bffffff]
May 16 11:52:01 brian-laptop kernel: [    0.269683] e820: reserve RAM buf=
fer [mem 0x9c6bf000-0x9fffffff]
May 16 11:52:01 brian-laptop kernel: [    0.269685] e820: reserve RAM buf=
fer [mem 0x9d000000-0x9fffffff]
May 16 11:52:01 brian-laptop kernel: [    0.269686] e820: reserve RAM buf=
fer [mem 0x25f600000-0x25fffffff]
May 16 11:52:01 brian-laptop kernel: [    0.269768] NetLabel: Initializin=
g
May 16 11:52:01 brian-laptop kernel: [    0.269769] NetLabel:  domain has=
h size =3D 128
May 16 11:52:01 brian-laptop kernel: [    0.269770] NetLabel:  protocols =
=3D UNLABELED CIPSOv4
May 16 11:52:01 brian-laptop kernel: [    0.269784] NetLabel:  unlabeled =
traffic allowed by default
May 16 11:52:01 brian-laptop kernel: [    0.269842] hpet0: at MMIO 0xfed0=
0000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
May 16 11:52:01 brian-laptop kernel: [    0.269849] hpet0: 8 comparators,=
 64-bit 14.318180 MHz counter
May 16 11:52:01 brian-laptop kernel: [    0.271882] Switched to clocksour=
ce hpet
May 16 11:52:01 brian-laptop kernel: [    0.277373] AppArmor: AppArmor Fi=
lesystem Enabled
May 16 11:52:01 brian-laptop kernel: [    0.277394] pnp: PnP ACPI init
May 16 11:52:01 brian-laptop kernel: [    0.277406] ACPI: bus type PNP re=
gistered
May 16 11:52:01 brian-laptop kernel: [    0.277618] pnp 00:00: [dma 4]
May 16 11:52:01 brian-laptop kernel: [    0.277642] pnp 00:00: Plug and P=
lay ACPI device, IDs PNP0200 (active)
May 16 11:52:01 brian-laptop kernel: [    0.277662] pnp 00:01: Plug and P=
lay ACPI device, IDs INT0800 (active)
May 16 11:52:01 brian-laptop kernel: [    0.277767] pnp 00:02: Plug and P=
lay ACPI device, IDs PNP0103 (active)
May 16 11:52:01 brian-laptop kernel: [    0.277828] system 00:03: [io  0x=
0680-0x069f] has been reserved
May 16 11:52:01 brian-laptop kernel: [    0.277832] system 00:03: [io  0x=
ffff] has been reserved
May 16 11:52:01 brian-laptop kernel: [    0.277834] system 00:03: [io  0x=
ffff] has been reserved
May 16 11:52:01 brian-laptop kernel: [    0.277836] system 00:03: [io  0x=
ffff] has been reserved
May 16 11:52:01 brian-laptop kernel: [    0.277839] system 00:03: [io  0x=
1800-0x18fe] could not be reserved
May 16 11:52:01 brian-laptop kernel: [    0.277841] system 00:03: [io  0x=
164e-0x164f] has been reserved
May 16 11:52:01 brian-laptop kernel: [    0.277844] system 00:03: Plug an=
d Play ACPI device, IDs PNP0c02 (active)
May 16 11:52:01 brian-laptop kernel: [    0.277889] pnp 00:04: Plug and P=
lay ACPI device, IDs PNP0b00 (active)
May 16 11:52:01 brian-laptop kernel: [    0.277936] system 00:05: [io  0x=
1854-0x1857] has been reserved
May 16 11:52:01 brian-laptop kernel: [    0.277939] system 00:05: Plug an=
d Play ACPI device, IDs INT3f0d PNP0c02 (active)
May 16 11:52:01 brian-laptop kernel: [    0.277977] pnp 00:06: Plug and P=
lay ACPI device, IDs PNP0303 (active)
May 16 11:52:01 brian-laptop kernel: [    0.278008] pnp 00:07: Plug and P=
lay ACPI device, IDs SYN2b2c SYN2b00 SYN0002 PNP0f13 (active)
May 16 11:52:01 brian-laptop kernel: [    0.278154] system 00:08: [mem 0x=
fed1c000-0xfed1ffff] has been reserved
May 16 11:52:01 brian-laptop kernel: [    0.278159] system 00:08: [mem 0x=
fed10000-0xfed17fff] has been reserved
May 16 11:52:01 brian-laptop kernel: [    0.278161] system 00:08: [mem 0x=
fed18000-0xfed18fff] has been reserved
May 16 11:52:01 brian-laptop kernel: [    0.278163] system 00:08: [mem 0x=
fed19000-0xfed19fff] has been reserved
May 16 11:52:01 brian-laptop kernel: [    0.278166] system 00:08: [mem 0x=
e0000000-0xefffffff] has been reserved
May 16 11:52:01 brian-laptop kernel: [    0.278168] system 00:08: [mem 0x=
fed20000-0xfed3ffff] has been reserved
May 16 11:52:01 brian-laptop kernel: [    0.278170] system 00:08: [mem 0x=
fed90000-0xfed93fff] has been reserved
May 16 11:52:01 brian-laptop kernel: [    0.278172] system 00:08: [mem 0x=
ff000000-0xffffffff] could not be reserved
May 16 11:52:01 brian-laptop kernel: [    0.278174] system 00:08: [mem 0x=
fee00000-0xfeefffff] could not be reserved
May 16 11:52:01 brian-laptop kernel: [    0.278177] system 00:08: [mem 0x=
9fa20000-0x9fa20fff] has been reserved
May 16 11:52:01 brian-laptop kernel: [    0.278179] system 00:08: [mem 0x=
9fa10000-0x9fa1ffff] has been reserved
May 16 11:52:01 brian-laptop kernel: [    0.278181] system 00:08: Plug an=
d Play ACPI device, IDs PNP0c02 (active)
May 16 11:52:01 brian-laptop kernel: [    0.278500] system 00:09: Plug an=
d Play ACPI device, IDs PNP0c02 (active)
May 16 11:52:01 brian-laptop kernel: [    0.279042] pnp: PnP ACPI: found =
10 devices
May 16 11:52:01 brian-laptop kernel: [    0.279044] ACPI: bus type PNP un=
registered
May 16 11:52:01 brian-laptop kernel: [    0.285253] pci 0000:00:1c.0: PCI=
 bridge to [bus 01]
May 16 11:52:01 brian-laptop kernel: [    0.285260] pci 0000:00:1c.0:   b=
ridge window [mem 0xb0400000-0xb04fffff]
May 16 11:52:01 brian-laptop kernel: [    0.285268] pci_bus 0000:00: reso=
urce 4 [io  0x0000-0x0cf7]
May 16 11:52:01 brian-laptop kernel: [    0.285271] pci_bus 0000:00: reso=
urce 5 [io  0x0d00-0xffff]
May 16 11:52:01 brian-laptop kernel: [    0.285273] pci_bus 0000:00: reso=
urce 6 [mem 0x000a0000-0x000bffff]
May 16 11:52:01 brian-laptop kernel: [    0.285275] pci_bus 0000:00: reso=
urce 7 [mem 0x9fa00000-0xfeafffff]
May 16 11:52:01 brian-laptop kernel: [    0.285277] pci_bus 0000:01: reso=
urce 1 [mem 0xb0400000-0xb04fffff]
May 16 11:52:01 brian-laptop kernel: [    0.285309] NET: Registered proto=
col family 2
May 16 11:52:01 brian-laptop kernel: [    0.285504] TCP established hash =
table entries: 65536 (order: 7, 524288 bytes)
May 16 11:52:01 brian-laptop kernel: [    0.285683] TCP bind hash table e=
ntries: 65536 (order: 8, 1048576 bytes)
May 16 11:52:01 brian-laptop kernel: [    0.285814] TCP: Hash tables conf=
igured (established 65536 bind 65536)
May 16 11:52:01 brian-laptop kernel: [    0.285833] TCP: reno registered
May 16 11:52:01 brian-laptop kernel: [    0.285848] UDP hash table entrie=
s: 4096 (order: 5, 131072 bytes)
May 16 11:52:01 brian-laptop kernel: [    0.285879] UDP-Lite hash table e=
ntries: 4096 (order: 5, 131072 bytes)
May 16 11:52:01 brian-laptop kernel: [    0.285954] NET: Registered proto=
col family 1
May 16 11:52:01 brian-laptop kernel: [    0.285967] pci 0000:00:02.0: Boo=
t video device
May 16 11:52:01 brian-laptop kernel: [    0.300036] PCI: CLS 64 bytes, de=
fault 64
May 16 11:52:01 brian-laptop kernel: [    0.300095] Trying to unpack root=
fs image as initramfs...
May 16 11:52:01 brian-laptop kernel: [    0.678951] Freeing initrd memory=
: 18600K (ffff880035b9c000 - ffff880036dc6000)
May 16 11:52:01 brian-laptop kernel: [    0.678956] PCI-DMA: Using softwa=
re bounce buffering for IO (SWIOTLB)
May 16 11:52:01 brian-laptop kernel: [    0.678959] software IO TLB [mem =
0x982c6000-0x9c2c6000] (64MB) mapped at [ffff8800982c6000-ffff88009c2c5ff=
f]
May 16 11:52:01 brian-laptop kernel: [    0.678998] Simple Boot Flag at 0=
x44 set to 0x1
May 16 11:52:01 brian-laptop kernel: [    0.679156] microcode: CPU0 sig=3D=
0x40651, pf=3D0x40, revision=3D0x14
May 16 11:52:01 brian-laptop kernel: [    0.679162] microcode: CPU1 sig=3D=
0x40651, pf=3D0x40, revision=3D0x14
May 16 11:52:01 brian-laptop kernel: [    0.679170] microcode: CPU2 sig=3D=
0x40651, pf=3D0x40, revision=3D0x14
May 16 11:52:01 brian-laptop kernel: [    0.679178] microcode: CPU3 sig=3D=
0x40651, pf=3D0x40, revision=3D0x14
May 16 11:52:01 brian-laptop kernel: [    0.679224] microcode: Microcode =
Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
May 16 11:52:01 brian-laptop kernel: [    0.679226] Scanning for low memo=
ry corruption every 60 seconds
May 16 11:52:01 brian-laptop kernel: [    0.679499] Initialise system tru=
sted keyring
May 16 11:52:01 brian-laptop kernel: [    0.679545] audit: initializing n=
etlink socket (disabled)
May 16 11:52:01 brian-laptop kernel: [    0.679555] type=3D2000 audit(140=
0241119.668:1): initialized
May 16 11:52:01 brian-laptop kernel: [    0.713714] HugeTLB registered 2 =
MB page size, pre-allocated 0 pages
May 16 11:52:01 brian-laptop kernel: [    0.715093] VFS: Disk quotas dquo=
t_6.5.2
May 16 11:52:01 brian-laptop kernel: [    0.715135] Dquot-cache hash tabl=
e entries: 512 (order 0, 4096 bytes)
May 16 11:52:01 brian-laptop kernel: [    0.715548] fuse init (API versio=
n 7.22)
May 16 11:52:01 brian-laptop kernel: [    0.715620] msgmni has been set t=
o 15789
May 16 11:52:01 brian-laptop kernel: [    0.715673] Key type big_key regi=
stered
May 16 11:52:01 brian-laptop kernel: [    0.716012] Key type asymmetric r=
egistered
May 16 11:52:01 brian-laptop kernel: [    0.716015] Asymmetric key parser=
 'x509' registered
May 16 11:52:01 brian-laptop kernel: [    0.716046] Block layer SCSI gene=
ric (bsg) driver version 0.4 loaded (major 252)
May 16 11:52:01 brian-laptop kernel: [    0.716082] io scheduler noop reg=
istered
May 16 11:52:01 brian-laptop kernel: [    0.716084] io scheduler deadline=
 registered (default)
May 16 11:52:01 brian-laptop kernel: [    0.716107] io scheduler cfq regi=
stered
May 16 11:52:01 brian-laptop kernel: [    0.716340] pcieport 0000:00:1c.0=
: irq 56 for MSI/MSI-X
May 16 11:52:01 brian-laptop kernel: [    0.716426] pcieport 0000:00:1c.0=
: Signaling PME through PCIe PME interrupt
May 16 11:52:01 brian-laptop kernel: [    0.716428] pci 0000:01:00.0: Sig=
naling PME through PCIe PME interrupt
May 16 11:52:01 brian-laptop kernel: [    0.716432] pcie_pme 0000:00:1c.0=
:pcie01: service driver pcie_pme loaded
May 16 11:52:01 brian-laptop kernel: [    0.716443] pci_hotplug: PCI Hot =
Plug PCI Core version: 0.5
May 16 11:52:01 brian-laptop kernel: [    0.716456] pciehp: PCI Express H=
ot Plug Controller Driver version: 0.4
May 16 11:52:01 brian-laptop kernel: [    0.716497] efifb: probing for ef=
ifb
May 16 11:52:01 brian-laptop kernel: [    0.719414] efifb: framebuffer at=
 0xa0000000, mapped to 0xffffc90010f00000, using 22528k, total 22528k
May 16 11:52:01 brian-laptop kernel: [    0.719416] efifb: mode is 3200x1=
800x32, linelength=3D12800, pages=3D1
May 16 11:52:01 brian-laptop kernel: [    0.719417] efifb: scrolling: red=
raw
May 16 11:52:01 brian-laptop kernel: [    0.719419] efifb: Truecolor: siz=
e=3D8:8:8:8, shift=3D24:16:8:0
May 16 11:52:01 brian-laptop kernel: [    0.737174] Console: switching to=
 colour frame buffer device 400x112
May 16 11:52:01 brian-laptop kernel: [    0.754125] fb0: EFI VGA frame bu=
ffer device
May 16 11:52:01 brian-laptop kernel: [    0.754139] intel_idle: MWAIT sub=
states: 0x11142120
May 16 11:52:01 brian-laptop kernel: [    0.754140] intel_idle: v0.4 mode=
l 0x45
May 16 11:52:01 brian-laptop kernel: [    0.754142] intel_idle: lapic_tim=
er_reliable_states 0xffffffff
May 16 11:52:01 brian-laptop kernel: [    0.754289] ipmi message handler =
version 39.2
May 16 11:52:01 brian-laptop kernel: [    0.754370] ACPI: AC Adapter [ADP=
1] (off-line)
May 16 11:52:01 brian-laptop kernel: [    0.754464] input: Lid Switch as =
/devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
May 16 11:52:01 brian-laptop kernel: [    0.754486] ACPI: Lid Switch [LID=
0]
May 16 11:52:01 brian-laptop kernel: [    0.754518] input: Power Button a=
s /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
May 16 11:52:01 brian-laptop kernel: [    0.754522] ACPI: Power Button [P=
WRB]
May 16 11:52:01 brian-laptop kernel: [    0.754553] input: Power Button a=
s /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
May 16 11:52:01 brian-laptop kernel: [    0.754555] ACPI: Power Button [P=
WRF]
May 16 11:52:01 brian-laptop kernel: [    0.756114] thermal LNXTHERM:00: =
registered as thermal_zone0
May 16 11:52:01 brian-laptop kernel: [    0.756116] ACPI: Thermal Zone [T=
Z01] (52 C)
May 16 11:52:01 brian-laptop kernel: [    0.756149] GHES: HEST is not ena=
bled!
May 16 11:52:01 brian-laptop kernel: [    0.756231] Serial: 8250/16550 dr=
iver, 32 ports, IRQ sharing enabled
May 16 11:52:01 brian-laptop kernel: [    0.758440] Linux agpgart interfa=
ce v0.103
May 16 11:52:01 brian-laptop kernel: [    0.759837] brd: module loaded
May 16 11:52:01 brian-laptop kernel: [    0.760528] loop: module loaded
May 16 11:52:01 brian-laptop kernel: [    0.760883] libphy: Fixed MDIO Bu=
s: probed
May 16 11:52:01 brian-laptop kernel: [    0.760973] tun: Universal TUN/TA=
P device driver, 1.6
May 16 11:52:01 brian-laptop kernel: [    0.760975] tun: (C) 1999-2004 Ma=
x Krasnyansky <maxk@qualcomm.com>
May 16 11:52:01 brian-laptop kernel: [    0.761024] PPP generic driver ve=
rsion 2.4.2
May 16 11:52:01 brian-laptop kernel: [    0.761059] ehci_hcd: USB 2.0 'En=
hanced' Host Controller (EHCI) Driver
May 16 11:52:01 brian-laptop kernel: [    0.761063] ehci-pci: EHCI PCI pl=
atform driver
May 16 11:52:01 brian-laptop kernel: [    0.761199] ehci-pci 0000:00:1d.0=
: EHCI Host Controller
May 16 11:52:01 brian-laptop kernel: [    0.761205] ehci-pci 0000:00:1d.0=
: new USB bus registered, assigned bus number 1
May 16 11:52:01 brian-laptop kernel: [    0.761218] ehci-pci 0000:00:1d.0=
: debug port 2
May 16 11:52:01 brian-laptop kernel: [    0.762613] ACPI: Battery Slot [B=
AT1] (battery present)
May 16 11:52:01 brian-laptop kernel: [    0.765132] ehci-pci 0000:00:1d.0=
: cache line size of 64 is not supported
May 16 11:52:01 brian-laptop kernel: [    0.765155] ehci-pci 0000:00:1d.0=
: irq 23, io mem 0xb0524000
May 16 11:52:01 brian-laptop kernel: [    0.776296] ehci-pci 0000:00:1d.0=
: USB 2.0 started, EHCI 1.00
May 16 11:52:01 brian-laptop kernel: [    0.776341] usb usb1: New USB dev=
ice found, idVendor=3D1d6b, idProduct=3D0002
May 16 11:52:01 brian-laptop kernel: [    0.776343] usb usb1: New USB dev=
ice strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
May 16 11:52:01 brian-laptop kernel: [    0.776346] usb usb1: Product: EH=
CI Host Controller
May 16 11:52:01 brian-laptop kernel: [    0.776347] usb usb1: Manufacture=
r: Linux 3.13.0-24-generic ehci_hcd
May 16 11:52:01 brian-laptop kernel: [    0.776349] usb usb1: SerialNumbe=
r: 0000:00:1d.0
May 16 11:52:01 brian-laptop kernel: [    0.776530] hub 1-0:1.0: USB hub =
found
May 16 11:52:01 brian-laptop kernel: [    0.776538] hub 1-0:1.0: 2 ports =
detected
May 16 11:52:01 brian-laptop kernel: [    0.776662] ehci-platform: EHCI g=
eneric platform driver
May 16 11:52:01 brian-laptop kernel: [    0.776670] ohci_hcd: USB 1.1 'Op=
en' Host Controller (OHCI) Driver
May 16 11:52:01 brian-laptop kernel: [    0.776672] ohci-pci: OHCI PCI pl=
atform driver
May 16 11:52:01 brian-laptop kernel: [    0.776680] ohci-platform: OHCI g=
eneric platform driver
May 16 11:52:01 brian-laptop kernel: [    0.776687] uhci_hcd: USB Univers=
al Host Controller Interface driver
May 16 11:52:01 brian-laptop kernel: [    0.776828] xhci_hcd 0000:00:14.0=
: xHCI Host Controller
May 16 11:52:01 brian-laptop kernel: [    0.776833] xhci_hcd 0000:00:14.0=
: new USB bus registered, assigned bus number 2
May 16 11:52:01 brian-laptop kernel: [    0.776911] xhci_hcd 0000:00:14.0=
: cache line size of 64 is not supported
May 16 11:52:01 brian-laptop kernel: [    0.776930] xhci_hcd 0000:00:14.0=
: irq 57 for MSI/MSI-X
May 16 11:52:01 brian-laptop kernel: [    0.776993] usb usb2: New USB dev=
ice found, idVendor=3D1d6b, idProduct=3D0002
May 16 11:52:01 brian-laptop kernel: [    0.776996] usb usb2: New USB dev=
ice strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
May 16 11:52:01 brian-laptop kernel: [    0.776998] usb usb2: Product: xH=
CI Host Controller
May 16 11:52:01 brian-laptop kernel: [    0.777000] usb usb2: Manufacture=
r: Linux 3.13.0-24-generic xhci_hcd
May 16 11:52:01 brian-laptop kernel: [    0.777001] usb usb2: SerialNumbe=
r: 0000:00:14.0
May 16 11:52:01 brian-laptop kernel: [    0.777207] hub 2-0:1.0: USB hub =
found
May 16 11:52:01 brian-laptop kernel: [    0.777221] hub 2-0:1.0: 9 ports =
detected
May 16 11:52:01 brian-laptop kernel: [    0.779541] xhci_hcd 0000:00:14.0=
: xHCI Host Controller
May 16 11:52:01 brian-laptop kernel: [    0.779546] xhci_hcd 0000:00:14.0=
: new USB bus registered, assigned bus number 3
May 16 11:52:01 brian-laptop kernel: [    0.779587] usb usb3: New USB dev=
ice found, idVendor=3D1d6b, idProduct=3D0003
May 16 11:52:01 brian-laptop kernel: [    0.779589] usb usb3: New USB dev=
ice strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
May 16 11:52:01 brian-laptop kernel: [    0.779591] usb usb3: Product: xH=
CI Host Controller
May 16 11:52:01 brian-laptop kernel: [    0.779593] usb usb3: Manufacture=
r: Linux 3.13.0-24-generic xhci_hcd
May 16 11:52:01 brian-laptop kernel: [    0.779595] usb usb3: SerialNumbe=
r: 0000:00:14.0
May 16 11:52:01 brian-laptop kernel: [    0.779708] hub 3-0:1.0: USB hub =
found
May 16 11:52:01 brian-laptop kernel: [    0.779717] hub 3-0:1.0: 4 ports =
detected
May 16 11:52:01 brian-laptop kernel: [    0.788473] i8042: PNP: PS/2 Cont=
roller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
May 16 11:52:01 brian-laptop kernel: [    0.801009] serio: i8042 KBD port=
 at 0x60,0x64 irq 1
May 16 11:52:01 brian-laptop kernel: [    0.801015] serio: i8042 AUX port=
 at 0x60,0x64 irq 12
May 16 11:52:01 brian-laptop kernel: [    0.801308] mousedev: PS/2 mouse =
device common for all mice
May 16 11:52:01 brian-laptop kernel: [    0.801791] rtc_cmos 00:04: RTC c=
an wake from S4
May 16 11:52:01 brian-laptop kernel: [    0.801946] rtc_cmos 00:04: rtc c=
ore: registered rtc_cmos as rtc0
May 16 11:52:01 brian-laptop kernel: [    0.801976] rtc_cmos 00:04: alarm=
s up to one month, 242 bytes nvram, hpet irqs
May 16 11:52:01 brian-laptop kernel: [    0.802044] device-mapper: uevent=
: version 1.0.3
May 16 11:52:01 brian-laptop kernel: [    0.802155] device-mapper: ioctl:=
 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
May 16 11:52:01 brian-laptop kernel: [    0.802163] ledtrig-cpu: register=
ed to indicate activity on CPUs
May 16 11:52:01 brian-laptop kernel: [    0.802165] EFI Variables Facilit=
y v0.08 2004-May-17
May 16 11:52:01 brian-laptop kernel: [    0.813294] input: AT Translated =
Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
May 16 11:52:01 brian-laptop kernel: [    0.843979] TCP: cubic registered=

May 16 11:52:01 brian-laptop kernel: [    0.844082] NET: Registered proto=
col family 10
May 16 11:52:01 brian-laptop kernel: [    0.844269] NET: Registered proto=
col family 17
May 16 11:52:01 brian-laptop kernel: [    0.844282] Key type dns_resolver=
 registered
May 16 11:52:01 brian-laptop kernel: [    0.844935] Loading compiled-in X=
=2E509 certificates
May 16 11:52:01 brian-laptop kernel: [    0.845983] Loaded X.509 cert 'Ma=
grathea: Glacier signing key: 69b0d0a79b85d90621706e8d06604d730b359fc0'
May 16 11:52:01 brian-laptop kernel: [    0.845998] registered taskstats =
version 1
May 16 11:52:01 brian-laptop kernel: [    0.848795] Key type trusted regi=
stered
May 16 11:52:01 brian-laptop kernel: [    0.850982] Key type encrypted re=
gistered
May 16 11:52:01 brian-laptop kernel: [    0.853178] AppArmor: AppArmor sh=
a1 policy hashing enabled
May 16 11:52:01 brian-laptop kernel: [    0.853183] IMA: No TPM chip foun=
d, activating TPM-bypass!
May 16 11:52:01 brian-laptop kernel: [    0.853440] regulator-dummy: disa=
bling
May 16 11:52:01 brian-laptop kernel: [    0.853491]   Magic number: 14:69=
9:883
May 16 11:52:01 brian-laptop kernel: [    0.853597] rtc_cmos 00:04: setti=
ng system clock to 2014-05-16 11:52:00 UTC (1400241120)
May 16 11:52:01 brian-laptop kernel: [    0.854488] BIOS EDD facility v0.=
16 2004-Jun-25, 0 devices found
May 16 11:52:01 brian-laptop kernel: [    0.854490] EDD information not a=
vailable.
May 16 11:52:01 brian-laptop kernel: [    0.854526] PM: Hibernation image=
 not present or could not be loaded.
May 16 11:52:01 brian-laptop kernel: [    0.855271] Freeing unused kernel=
 memory: 1332K (ffffffff81d1e000 - ffffffff81e6b000)
May 16 11:52:01 brian-laptop kernel: [    0.855273] Write protecting the =
kernel read-only data: 12288k
May 16 11:52:01 brian-laptop kernel: [    0.856856] Freeing unused kernel=
 memory: 844K (ffff88000272d000 - ffff880002800000)
May 16 11:52:01 brian-laptop kernel: [    0.858055] Freeing unused kernel=
 memory: 708K (ffff880002b4f000 - ffff880002c00000)
May 16 11:52:01 brian-laptop kernel: [    0.893156] ahci 0000:00:1f.2: ve=
rsion 3.0
May 16 11:52:01 brian-laptop kernel: [    0.893303] ahci 0000:00:1f.2: ir=
q 58 for MSI/MSI-X
May 16 11:52:01 brian-laptop kernel: [    0.908433] ahci 0000:00:1f.2: AH=
CI 0001.0300 32 slots 1 ports 6 Gbps 0x2 impl SATA mode
May 16 11:52:01 brian-laptop kernel: [    0.908439] ahci 0000:00:1f.2: fl=
ags: 64bit ncq pm led clo only pio slum part deso sadm sds apst=20
May 16 11:52:01 brian-laptop kernel: [    0.908717] scsi0 : ahci
May 16 11:52:01 brian-laptop kernel: [    0.908793] scsi1 : ahci
May 16 11:52:01 brian-laptop kernel: [    0.908830] ata1: DUMMY
May 16 11:52:01 brian-laptop kernel: [    0.908832] ata2: SATA max UDMA/1=
33 abar m2048@0xb0523000 port 0xb0523180 irq 58
May 16 11:52:01 brian-laptop kernel: [    1.088646] usb 1-1: new high-spe=
ed USB device number 2 using ehci-pci
May 16 11:52:01 brian-laptop kernel: [    1.221125] usb 1-1: New USB devi=
ce found, idVendor=3D8087, idProduct=3D8000
May 16 11:52:01 brian-laptop kernel: [    1.221129] usb 1-1: New USB devi=
ce strings: Mfr=3D0, Product=3D0, SerialNumber=3D0
May 16 11:52:01 brian-laptop kernel: [    1.221381] hub 1-1:1.0: USB hub =
found
May 16 11:52:01 brian-laptop kernel: [    1.221451] hub 1-1:1.0: 8 ports =
detected
May 16 11:52:01 brian-laptop kernel: [    1.228723] ata2: SATA link up 6.=
0 Gbps (SStatus 133 SControl 300)
May 16 11:52:01 brian-laptop kernel: [    1.229544] ata2.00: ACPI cmd ef/=
10:09:00:00:00:b0 (SET FEATURES) succeeded
May 16 11:52:01 brian-laptop kernel: [    1.229848] ata2.00: failed to ge=
t NCQ Send/Recv Log Emask 0x1
May 16 11:52:01 brian-laptop kernel: [    1.229852] ata2.00: ATA-9: SAMSU=
NG MZMTD256HAGM-000L1, DXT43L0Q, max UDMA/133
May 16 11:52:01 brian-laptop kernel: [    1.229854] ata2.00: 500118192 se=
ctors, multi 16: LBA48 NCQ (depth 31/32), AA
May 16 11:52:01 brian-laptop kernel: [    1.230263] ata2.00: ACPI cmd ef/=
10:09:00:00:00:b0 (SET FEATURES) succeeded
May 16 11:52:01 brian-laptop kernel: [    1.230435] ata2.00: failed to ge=
t NCQ Send/Recv Log Emask 0x1
May 16 11:52:01 brian-laptop kernel: [    1.230492] ata2.00: configured f=
or UDMA/133
May 16 11:52:01 brian-laptop kernel: [    1.230665] scsi 1:0:0:0: Direct-=
Access     ATA      SAMSUNG MZMTD256 DXT4 PQ: 0 ANSI: 5
May 16 11:52:01 brian-laptop kernel: [    1.230812] sd 1:0:0:0: [sda] 500=
118192 512-byte logical blocks: (256 GB/238 GiB)
May 16 11:52:01 brian-laptop kernel: [    1.230838] sd 1:0:0:0: Attached =
scsi generic sg0 type 0
May 16 11:52:01 brian-laptop kernel: [    1.230866] sd 1:0:0:0: [sda] Wri=
te Protect is off
May 16 11:52:01 brian-laptop kernel: [    1.230870] sd 1:0:0:0: [sda] Mod=
e Sense: 00 3a 00 00
May 16 11:52:01 brian-laptop kernel: [    1.230891] sd 1:0:0:0: [sda] Wri=
te cache: enabled, read cache: enabled, doesn't support DPO or FUA
May 16 11:52:01 brian-laptop kernel: [    1.232545]  sda: sda1 sda2 sda3 =
sda4 sda5 sda6 sda7 sda8 sda9
May 16 11:52:01 brian-laptop kernel: [    1.233218] sd 1:0:0:0: [sda] Att=
ached SCSI disk
May 16 11:52:01 brian-laptop kernel: [    1.270996] EXT4-fs (sda9): INFO:=
 recovery required on readonly filesystem
May 16 11:52:01 brian-laptop kernel: [    1.270999] EXT4-fs (sda9): write=
 access will be enabled during recovery
May 16 11:52:01 brian-laptop kernel: [    1.388857] usb 2-4: new full-spe=
ed USB device number 2 using xhci_hcd
May 16 11:52:01 brian-laptop kernel: [    1.390171] random: nonblocking p=
ool is initialized
May 16 11:52:01 brian-laptop kernel: [    1.405908] usb 2-4: New USB devi=
ce found, idVendor=3D8087, idProduct=3D07dc
May 16 11:52:01 brian-laptop kernel: [    1.405920] usb 2-4: New USB devi=
ce strings: Mfr=3D0, Product=3D0, SerialNumber=3D0
May 16 11:52:01 brian-laptop kernel: [    1.437322] EXT4-fs (sda9): orpha=
n cleanup on readonly fs
May 16 11:52:01 brian-laptop kernel: [    1.437609] EXT4-fs (sda9): 2 orp=
han inodes deleted
May 16 11:52:01 brian-laptop kernel: [    1.437613] EXT4-fs (sda9): recov=
ery complete
May 16 11:52:01 brian-laptop kernel: [    1.454643] EXT4-fs (sda9): mount=
ed filesystem with ordered data mode. Opts: (null)
May 16 11:52:01 brian-laptop kernel: [    1.572975] usb 2-6: new full-spe=
ed USB device number 3 using xhci_hcd
May 16 11:52:01 brian-laptop kernel: [    1.593445] usb 2-6: New USB devi=
ce found, idVendor=3D2047, idProduct=3D0855
May 16 11:52:01 brian-laptop kernel: [    1.593449] usb 2-6: New USB devi=
ce strings: Mfr=3D1, Product=3D2, SerialNumber=3D3
May 16 11:52:01 brian-laptop kernel: [    1.593452] usb 2-6: Product: Len=
ovo Yoga        =20
May 16 11:52:01 brian-laptop kernel: [    1.593454] usb 2-6: Manufacturer=
: Invensense
May 16 11:52:01 brian-laptop kernel: [    1.593456] usb 2-6: SerialNumber=
: 71F8806F10000000
May 16 11:52:01 brian-laptop kernel: [    1.593541] usb 2-6: ep 0x81 - ro=
unding interval to 128 microframes, ep desc says 160 microframes
May 16 11:52:01 brian-laptop kernel: [    1.593546] usb 2-6: ep 0x1 - rou=
nding interval to 128 microframes, ep desc says 160 microframes
May 16 11:52:01 brian-laptop kernel: [    1.677035] tsc: Refined TSC cloc=
ksource calibration: 2394.457 MHz
May 16 11:52:01 brian-laptop kernel: [    1.684619] Adding 7812092k swap =
on /dev/sda8.  Priority:-1 extents:1 across:7812092k SSFS
May 16 11:52:01 brian-laptop kernel: [    1.709069] usb 2-7: new full-spe=
ed USB device number 4 using xhci_hcd
May 16 11:52:01 brian-laptop kernel: [    1.789942] lp: driver loaded but=
 no devices found
May 16 11:52:01 brian-laptop kernel: [    1.800869] ppdev: user-space par=
allel port driver
May 16 11:52:01 brian-laptop kernel: [    1.822033] EXT4-fs (sda9): re-mo=
unted. Opts: errors=3Dremount-ro
May 16 11:52:01 brian-laptop kernel: [    1.951647] Bluetooth: Core ver 2=
=2E17
May 16 11:52:01 brian-laptop kernel: [    1.951668] NET: Registered proto=
col family 31
May 16 11:52:01 brian-laptop kernel: [    1.951670] Bluetooth: HCI device=
 and connection manager initialized
May 16 11:52:01 brian-laptop kernel: [    1.951677] Bluetooth: HCI socket=
 layer initialized
May 16 11:52:01 brian-laptop kernel: [    1.951679] Bluetooth: L2CAP sock=
et layer initialized
May 16 11:52:01 brian-laptop kernel: [    1.951684] Bluetooth: SCO socket=
 layer initialized
May 16 11:52:01 brian-laptop kernel: [    1.955249] Bluetooth: BNEP (Ethe=
rnet Emulation) ver 1.3
May 16 11:52:01 brian-laptop kernel: [    1.955252] Bluetooth: BNEP filte=
rs: protocol multicast
May 16 11:52:01 brian-laptop kernel: [    1.955259] Bluetooth: BNEP socke=
t layer initialized
May 16 11:52:01 brian-laptop kernel: [    1.957936] Bluetooth: RFCOMM TTY=
 layer initialized
May 16 11:52:01 brian-laptop kernel: [    1.957946] Bluetooth: RFCOMM soc=
ket layer initialized
May 16 11:52:01 brian-laptop kernel: [    1.957951] Bluetooth: RFCOMM ver=
 1.11
May 16 11:52:01 brian-laptop kernel: [    1.959089] type=3D1400 audit(140=
0262721.601:2): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"/usr/lib/cups/backend/cups-pdf" pid=3D477 comm=3D"ap=
parmor_parser"
May 16 11:52:01 brian-laptop kernel: [    1.959094] type=3D1400 audit(140=
0262721.601:3): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"/usr/sbin/cupsd" pid=3D477 comm=3D"apparmor_parser"
May 16 11:52:01 brian-laptop kernel: [    1.959408] type=3D1400 audit(140=
0262721.601:4): apparmor=3D"STATUS" operation=3D"profile_replace" profile=
=3D"unconfined" name=3D"/usr/sbin/cupsd" pid=3D477 comm=3D"apparmor_parse=
r"
May 16 11:52:01 brian-laptop rsyslogd-2039: Could no open output pipe '/d=
ev/xconsole': No such file or directory [try http://www.rsyslog.com/e/203=
9 ]
May 16 11:52:01 brian-laptop avahi-daemon[491]: Found user 'avahi' (UID 1=
10) and group 'avahi' (GID 116).
May 16 11:52:01 brian-laptop avahi-daemon[491]: Successfully dropped root=
 privileges.
May 16 11:52:01 brian-laptop avahi-daemon[491]: avahi-daemon 0.6.31 start=
ing up.
May 16 11:52:01 brian-laptop avahi-daemon[491]: Successfully called chroo=
t().
May 16 11:52:01 brian-laptop avahi-daemon[491]: Successfully dropped rema=
ining capabilities.
May 16 11:52:01 brian-laptop avahi-daemon[491]: Loading service file /ser=
vices/udisks.service.
May 16 11:52:01 brian-laptop avahi-daemon[491]: Network interface enumera=
tion completed.
May 16 11:52:01 brian-laptop avahi-daemon[491]: Registering HINFO record =
with values 'X86_64'/'LINUX'.
May 16 11:52:01 brian-laptop avahi-daemon[491]: Server startup complete. =
Host name is brian-laptop.local. Local service cookie is 3886738020.
May 16 11:52:01 brian-laptop avahi-daemon[491]: Service "brian-laptop" (/=
services/udisks.service) successfully established.
May 16 11:52:01 brian-laptop kernel: [    2.295209] mei_me 0000:00:16.0: =
irq 59 for MSI/MSI-X
May 16 11:52:01 brian-laptop kernel: [    2.302462] [drm] Initialized drm=
 1.1.0 20060810
May 16 11:52:01 brian-laptop kernel: [    2.308621] cfg80211: Calling CRD=
A to update world regulatory domain
May 16 11:52:01 brian-laptop kernel: [    2.316163] ACPI Warning: 0x00000=
00000001828-0x000000000000182f SystemIO conflicts with Region \PMIO 1 (20=
131115/utaddress-251)
May 16 11:52:01 brian-laptop kernel: [    2.316170] ACPI: If an ACPI driv=
er is available for this device, you should use it instead of the native =
driver
May 16 11:52:01 brian-laptop kernel: [    2.316174] ACPI Warning: 0x00000=
00000000830-0x000000000000083f SystemIO conflicts with Region \GPRL 1 (20=
131115/utaddress-251)
May 16 11:52:01 brian-laptop kernel: [    2.316178] ACPI Warning: 0x00000=
00000000830-0x000000000000083f SystemIO conflicts with Region \GPR_ 2 (20=
131115/utaddress-251)
May 16 11:52:01 brian-laptop kernel: [    2.316181] ACPI: If an ACPI driv=
er is available for this device, you should use it instead of the native =
driver
May 16 11:52:01 brian-laptop kernel: [    2.316183] ACPI Warning: 0x00000=
00000000800-0x000000000000082f SystemIO conflicts with Region \GPRL 1 (20=
131115/utaddress-251)
May 16 11:52:01 brian-laptop kernel: [    2.316186] ACPI Warning: 0x00000=
00000000800-0x000000000000082f SystemIO conflicts with Region \GPR_ 2 (20=
131115/utaddress-251)
May 16 11:52:01 brian-laptop kernel: [    2.316189] ACPI Warning: 0x00000=
00000000800-0x000000000000082f SystemIO conflicts with Region \IO_D 3 (20=
131115/utaddress-251)
May 16 11:52:01 brian-laptop kernel: [    2.316193] ACPI: If an ACPI driv=
er is available for this device, you should use it instead of the native =
driver
May 16 11:52:01 brian-laptop kernel: [    2.316194] lpc_ich: Resource con=
flict(s) found affecting gpio_ich
May 16 11:52:01 brian-laptop kernel: [    2.323191] [drm] Memory usable b=
y graphics device =3D 2048M
May 16 11:52:01 brian-laptop kernel: [    2.323196] checking generic (a00=
00000 1600000) vs hw (a0000000 10000000)
May 16 11:52:01 brian-laptop kernel: [    2.323199] fb: conflicting fb hw=
 usage inteldrmfb vs EFI VGA - removing generic driver
May 16 11:52:01 brian-laptop kernel: [    2.323304] Console: switching to=
 colour dummy device 80x25
May 16 11:52:01 brian-laptop kernel: [    2.326347] Intel(R) Wireless WiF=
i driver for Linux, in-tree:
May 16 11:52:01 brian-laptop kernel: [    2.326350] Copyright(c) 2003-201=
3 Intel Corporation
May 16 11:52:01 brian-laptop kernel: [    2.326491] iwlwifi 0000:01:00.0:=
 irq 60 for MSI/MSI-X
May 16 11:52:01 brian-laptop kernel: [    2.342503] iwlwifi 0000:01:00.0:=
 loaded firmware version 22.24.8.0 op_mode iwlmvm
May 16 11:52:02 brian-laptop kernel: [    2.370151] iwlwifi 0000:01:00.0:=
 Detected Intel(R) Wireless N 7260, REV=3D0x144
May 16 11:52:02 brian-laptop kernel: [    2.373616] iwlwifi 0000:01:00.0:=
 L1 Disabled; Enabling L0S
May 16 11:52:02 brian-laptop kernel: [    2.373834] iwlwifi 0000:01:00.0:=
 L1 Disabled; Enabling L0S
May 16 11:52:02 brian-laptop kernel: [    2.376036] i915 0000:00:02.0: ir=
q 61 for MSI/MSI-X
May 16 11:52:02 brian-laptop kernel: [    2.376048] [drm] Supports vblank=
 timestamp caching Rev 2 (21.10.2013).
May 16 11:52:02 brian-laptop kernel: [    2.376049] [drm] Driver supports=
 precise vblank timestamp query.
May 16 11:52:02 brian-laptop kernel: [    2.376252] vgaarb: device change=
d decodes: PCI:0000:00:02.0,olddecodes=3Dio+mem,decodes=3Dio+mem:owns=3Di=
o+mem
May 16 11:52:02 brian-laptop kernel: [    2.378409] kvm: disabled by bios=

May 16 11:52:03 brian-laptop kernel: [    2.430523] fbcon: inteldrmfb (fb=
0) is primary device
May 16 11:52:03 brian-laptop kernel: [    2.478564] cfg80211: World regul=
atory domain updated:
May 16 11:52:03 brian-laptop kernel: [    2.478565] cfg80211:   (start_fr=
eq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
May 16 11:52:03 brian-laptop kernel: [    2.478566] cfg80211:   (2402000 =
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 11:52:03 brian-laptop kernel: [    2.478567] cfg80211:   (2457000 =
KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 11:52:03 brian-laptop kernel: [    2.478567] cfg80211:   (2474000 =
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
May 16 11:52:03 brian-laptop kernel: [    2.478568] cfg80211:   (5170000 =
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 11:52:03 brian-laptop kernel: [    2.478568] cfg80211:   (5735000 =
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 11:52:03 brian-laptop kernel: [    2.577918] ieee80211 phy0: Selec=
ted rate control algorithm 'iwl-mvm-rs'
May 16 11:52:03 brian-laptop kernel: [    2.677879] Switched to clocksour=
ce tsc
May 16 11:52:03 brian-laptop kernel: [    2.948041] psmouse serio1: synap=
tics: Touchpad model: 1, fw: 8.1, id: 0x1e2b1, caps: 0xd00123/0x840300/0x=
126c00, board id: 2132, fw id: 1180104
May 16 11:52:03 brian-laptop kernel: [    3.002340] input: SynPS/2 Synapt=
ics TouchPad as /devices/platform/i8042/serio1/input/input5
May 16 11:52:03 brian-laptop kernel: [    3.788513] usb 2-7: unable to re=
ad config index 0 descriptor/start: -71
May 16 11:52:03 brian-laptop kernel: [    3.788514] usb 2-7: can't read c=
onfigurations, error -71
May 16 11:52:03 brian-laptop kernel: [    3.814844] [drm] Enabling RC6 st=
ates: RC6 on, RC6p off, RC6pp off
May 16 11:52:03 brian-laptop kernel: [    3.954872] usb 2-7: new full-spe=
ed USB device number 5 using xhci_hcd
May 16 11:52:03 brian-laptop kernel: [    4.063124] Console: switching to=
 colour frame buffer device 400x112
May 16 11:52:03 brian-laptop kernel: [    4.086842] i915 0000:00:02.0: fb=
0: inteldrmfb frame buffer device
May 16 11:52:03 brian-laptop kernel: [    4.086843] i915 0000:00:02.0: re=
gistered panic notifier
May 16 11:52:03 brian-laptop kernel: [    4.105935] ACPI: Video Device [G=
FX0] (multi-head: yes  rom: no  post: no)
May 16 11:52:03 brian-laptop kernel: [    4.106164] input: Video Bus as /=
devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input6
May 16 11:52:03 brian-laptop kernel: [    4.106247] [drm] Initialized i91=
5 1.6.0 20080730 for 0000:00:02.0 on minor 0
May 16 11:52:03 brian-laptop kernel: [    4.106638] HDA driver get symbol=
 successfully from i915 module
May 16 11:52:03 brian-laptop kernel: [    4.106766] snd_hda_intel 0000:00=
:1b.0: irq 62 for MSI/MSI-X
May 16 11:52:03 brian-laptop kernel: [    4.111011] snd_hda_intel 0000:00=
:03.0: irq 63 for MSI/MSI-X
May 16 11:52:03 brian-laptop kernel: [    4.119689] SKU: Nid=3D0x1d sku_c=
fg=3D0x40189e2d
May 16 11:52:03 brian-laptop kernel: [    4.119689] SKU: port_connectivit=
y=3D0x1
May 16 11:52:03 brian-laptop kernel: [    4.119690] SKU: enable_pcbeep=3D=
0x1
May 16 11:52:03 brian-laptop kernel: [    4.119690] SKU: check_sum=3D0x00=
000008
May 16 11:52:03 brian-laptop kernel: [    4.119691] SKU: customization=3D=
0x0000009e
May 16 11:52:03 brian-laptop kernel: [    4.119691] SKU: external_amp=3D0=
x5
May 16 11:52:03 brian-laptop kernel: [    4.119692] SKU: platform_type=3D=
0x1
May 16 11:52:03 brian-laptop kernel: [    4.119692] SKU: swap=3D0x0
May 16 11:52:03 brian-laptop kernel: [    4.119692] SKU: override=3D0x1
May 16 11:52:03 brian-laptop kernel: [    4.119895] autoconfig: line_outs=
=3D1 (0x14/0x0/0x0/0x0/0x0) type:speaker
May 16 11:52:03 brian-laptop kernel: [    4.119896]    speaker_outs=3D0 (=
0x0/0x0/0x0/0x0/0x0)
May 16 11:52:03 brian-laptop kernel: [    4.119897]    hp_outs=3D1 (0x21/=
0x0/0x0/0x0/0x0)
May 16 11:52:03 brian-laptop kernel: [    4.119897]    mono: mono_out=3D0=
x0
May 16 11:52:03 brian-laptop kernel: [    4.119897]    inputs:
May 16 11:52:03 brian-laptop kernel: [    4.119899]      Mic=3D0x19
May 16 11:52:03 brian-laptop kernel: [    4.119899]      Internal Mic=3D0=
x12
May 16 11:52:03 brian-laptop kernel: [    4.119900] realtek: No valid SSI=
D, checking pincfg 0x40189e2d for NID 0x1d
May 16 11:52:03 brian-laptop kernel: [    4.119901] realtek: Enabling ini=
t ASM_ID=3D0x9e2d CODEC_ID=3D10ec0283
May 16 11:52:03 brian-laptop kernel: [    4.121918] type=3D1400 audit(140=
0262723.758:5): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"/sbin/dhclient" pid=3D624 comm=3D"apparmor_parser"
May 16 11:52:03 brian-laptop kernel: [    4.121924] type=3D1400 audit(140=
0262723.758:6): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"/usr/lib/NetworkManager/nm-dhcp-client.action" pid=3D=
624 comm=3D"apparmor_parser"
May 16 11:52:03 brian-laptop kernel: [    4.121929] type=3D1400 audit(140=
0262723.758:7): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"/usr/lib/connman/scripts/dhclient-script" pid=3D624 =
comm=3D"apparmor_parser"
May 16 11:52:03 brian-laptop kernel: [    4.122386] type=3D1400 audit(140=
0262723.758:8): apparmor=3D"STATUS" operation=3D"profile_replace" profile=
=3D"unconfined" name=3D"/usr/lib/NetworkManager/nm-dhcp-client.action" pi=
d=3D624 comm=3D"apparmor_parser"
May 16 11:52:03 brian-laptop kernel: [    4.122392] type=3D1400 audit(140=
0262723.758:9): apparmor=3D"STATUS" operation=3D"profile_replace" profile=
=3D"unconfined" name=3D"/usr/lib/connman/scripts/dhclient-script" pid=3D6=
24 comm=3D"apparmor_parser"
May 16 11:52:03 brian-laptop kernel: [    4.122631] type=3D1400 audit(140=
0262723.758:10): apparmor=3D"STATUS" operation=3D"profile_replace" profil=
e=3D"unconfined" name=3D"/usr/lib/connman/scripts/dhclient-script" pid=3D=
624 comm=3D"apparmor_parser"
May 16 11:52:03 brian-laptop kernel: [    4.127190] input: HDA Intel PCH =
Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card1/input8
May 16 11:52:03 brian-laptop kernel: [    4.127616] input: HDA Intel PCH =
Mic as /devices/pci0000:00/0000:00:1b.0/sound/card1/input7
May 16 11:52:03 brian-laptop kernel: [    4.128589] input: HDA Intel HDMI=
 HDMI/DP,pcm=3D8 as /devices/pci0000:00/0000:00:03.0/sound/card0/input11
May 16 11:52:03 brian-laptop kernel: [    4.129170] input: HDA Intel HDMI=
 HDMI/DP,pcm=3D7 as /devices/pci0000:00/0000:00:03.0/sound/card0/input10
May 16 11:52:03 brian-laptop kernel: [    4.129791] input: HDA Intel HDMI=
 HDMI/DP,pcm=3D3 as /devices/pci0000:00/0000:00:03.0/sound/card0/input9
May 16 11:52:03 brian-laptop failsafe: Failsafe of 120 seconds reached.
May 16 11:52:03 brian-laptop wpa_supplicant[739]: Successfully initialize=
d wpa_supplicant
May 16 11:52:03 brian-laptop kernel: [    4.250553] iwlwifi 0000:01:00.0:=
 L1 Disabled; Enabling L0S
May 16 11:52:03 brian-laptop kernel: [    4.250771] iwlwifi 0000:01:00.0:=
 L1 Disabled; Enabling L0S
May 16 11:52:03 brian-laptop kernel: [    4.262818] IPv6: ADDRCONF(NETDEV=
_UP): wlan0: link is not ready
May 16 11:52:03 brian-laptop wpa_supplicant[752]: wlan0: CTRL-EVENT-SCAN-=
STARTED=20
May 16 11:52:03 brian-laptop dhclient: Internet Systems Consortium DHCP C=
lient 4.2.4
May 16 11:52:03 brian-laptop dhclient: Copyright 2004-2012 Internet Syste=
ms Consortium.
May 16 11:52:03 brian-laptop dhclient: All rights reserved.
May 16 11:52:03 brian-laptop dhclient: For info, please visit https://www=
=2Eisc.org/software/dhcp/
May 16 11:52:03 brian-laptop dhclient:=20
May 16 11:52:03 brian-laptop dhclient: Listening on LPF/wlan0/5c:51:4f:63=
:1e:10
May 16 11:52:03 brian-laptop dhclient: Sending on   LPF/wlan0/5c:51:4f:63=
:1e:10
May 16 11:52:03 brian-laptop dhclient: Sending on   Socket/fallback
May 16 11:52:03 brian-laptop dhclient: DHCPDISCOVER on wlan0 to 255.255.2=
55.255 port 67 interval 3 (xid=3D0xfe8a884)
May 16 11:52:04 brian-laptop wpa_supplicant[752]: wlan0: SME: Trying to a=
uthenticate with 00:22:6b:54:68:d2 (SSID=3D'BJONES' freq=3D2437 MHz)
May 16 11:52:04 brian-laptop kernel: [    5.024570] wlan0: authenticate w=
ith 00:22:6b:54:68:d2
May 16 11:52:04 brian-laptop kernel: [    5.026490] wlan0: send auth to 0=
0:22:6b:54:68:d2 (try 1/3)
May 16 11:52:04 brian-laptop wpa_supplicant[752]: wlan0: Trying to associ=
ate with 00:22:6b:54:68:d2 (SSID=3D'BJONES' freq=3D2437 MHz)
May 16 11:52:04 brian-laptop kernel: [    5.028409] wlan0: authenticated
May 16 11:52:04 brian-laptop kernel: [    5.031734] wlan0: associate with=
 00:22:6b:54:68:d2 (try 1/3)
May 16 11:52:04 brian-laptop kernel: [    5.035580] wlan0: RX AssocResp f=
rom 00:22:6b:54:68:d2 (capab=3D0x411 status=3D0 aid=3D4)
May 16 11:52:04 brian-laptop wpa_supplicant[752]: wlan0: Associated with =
00:22:6b:54:68:d2
May 16 11:52:04 brian-laptop kernel: [    5.037344] wlan0: associated
May 16 11:52:04 brian-laptop kernel: [    5.037361] IPv6: ADDRCONF(NETDEV=
_CHANGE): wlan0: link becomes ready
May 16 11:52:04 brian-laptop wpa_supplicant[752]: wlan0: WPA: Key negotia=
tion completed with 00:22:6b:54:68:d2 [PTK=3DCCMP GTK=3DTKIP]
May 16 11:52:04 brian-laptop wpa_supplicant[752]: wlan0: CTRL-EVENT-CONNE=
CTED - Connection to 00:22:6b:54:68:d2 completed [id=3D0 id_str=3D]
May 16 11:52:05 brian-laptop kernel: [    6.034277] usb 2-7: unable to re=
ad config index 0 descriptor/start: -71
May 16 11:52:05 brian-laptop kernel: [    6.034282] usb 2-7: can't read c=
onfigurations, error -71
May 16 11:52:05 brian-laptop kernel: [    6.200788] usb 2-7: new full-spe=
ed USB device number 6 using xhci_hcd
May 16 11:52:06 brian-laptop avahi-daemon[491]: Joining mDNS multicast gr=
oup on interface wlan0.IPv6 with address 2002:d1b5:5206:0:5e51:4fff:fe63:=
1e10.
May 16 11:52:06 brian-laptop avahi-daemon[491]: New relevant interface wl=
an0.IPv6 for mDNS.
May 16 11:52:06 brian-laptop avahi-daemon[491]: Registering new address r=
ecord for 2002:d1b5:5206:0:5e51:4fff:fe63:1e10 on wlan0.*.
May 16 11:52:06 brian-laptop avahi-daemon[491]: Registering new address r=
ecord for 2002:d1b5:5206:0:ec65:a08f:3a2c:7e62 on wlan0.*.
May 16 11:52:06 brian-laptop dhclient: DHCPDISCOVER on wlan0 to 255.255.2=
55.255 port 67 interval 3 (xid=3D0xfe8a884)
May 16 11:52:07 brian-laptop dhclient: DHCPREQUEST of 192.168.3.107 on wl=
an0 to 255.255.255.255 port 67 (xid=3D0xfe8a884)
May 16 11:52:07 brian-laptop dhclient: DHCPOFFER of 192.168.3.107 from 19=
2.168.3.1
May 16 11:52:07 brian-laptop dhclient: DHCPACK of 192.168.3.107 from 192.=
168.3.1
May 16 11:52:07 brian-laptop avahi-daemon[491]: Joining mDNS multicast gr=
oup on interface wlan0.IPv4 with address 192.168.3.107.
May 16 11:52:07 brian-laptop avahi-daemon[491]: New relevant interface wl=
an0.IPv4 for mDNS.
May 16 11:52:07 brian-laptop avahi-daemon[491]: Registering new address r=
ecord for 192.168.3.107 on wlan0.IPv4.
May 16 11:52:07 brian-laptop dhclient: bound to 192.168.3.107 -- renewal =
in 41500 seconds.
May 16 11:52:07 brian-laptop kernel: [    8.280109] usb 2-7: unable to re=
ad config index 0 descriptor/start: -71
May 16 11:52:07 brian-laptop kernel: [    8.280115] usb 2-7: can't read c=
onfigurations, error -71
May 16 11:52:07 brian-laptop ModemManager[929]: <info>  ModemManager (ver=
sion 1.0.0) starting...
May 16 11:52:08 brian-laptop NetworkManager[961]: <info> NetworkManager (=
version 0.9.8.8) is starting...
May 16 11:52:08 brian-laptop NetworkManager[961]: <info> Read config file=
 /etc/NetworkManager/NetworkManager.conf
May 16 11:52:08 brian-laptop NetworkManager[961]: <info> WEXT support is =
enabled
May 16 11:52:08 brian-laptop NetworkManager[961]: <info> VPN: loaded org.=
freedesktop.NetworkManager.pptp
May 16 11:52:08 brian-laptop NetworkManager[961]: <info> DNS: loaded plug=
in dnsmasq
May 16 11:52:08 brian-laptop dbus[450]: [system] Activating service name=3D=
'org.freedesktop.PolicyKit1' (using servicehelper)
May 16 11:52:08 brian-laptop polkitd[976]: started daemon version 0.105 u=
sing authority implementation `local' version `0.105'
May 16 11:52:08 brian-laptop dbus[450]: [system] Successfully activated s=
ervice 'org.freedesktop.PolicyKit1'
May 16 11:52:08 brian-laptop NetworkManager[961]:    SCPlugin-Ifupdown: i=
nit!
May 16 11:52:08 brian-laptop NetworkManager[961]:    SCPlugin-Ifupdown: u=
pdate_system_hostname
May 16 11:52:08 brian-laptop NetworkManager[961]:       interface-parser:=
 parsing file /etc/network/interfaces
May 16 11:52:08 brian-laptop NetworkManager[961]:       interface-parser:=
 finished parsing file /etc/network/interfaces
May 16 11:52:08 brian-laptop NetworkManager[961]:    SCPluginIfupdown: gu=
essed connection type (wlan0) =3D 802-11-wireless
May 16 11:52:08 brian-laptop NetworkManager[961]:    SCPlugin-Ifupdown: u=
pdate_connection_setting_from_if_block: name:wlan0, type:802-11-wireless,=
 id:Ifupdown (wlan0), uuid: 5391eba4-6426-faca-338e-5828034ff9d1
May 16 11:52:08 brian-laptop NetworkManager[961]:    SCPlugin-Ifupdown: u=
pdate wireless settings (wlan0).
May 16 11:52:08 brian-laptop NetworkManager[961]:    SCPlugin-Ifupdown: s=
etting wpa ssid =3D 6
May 16 11:52:08 brian-laptop NetworkManager[961]:    SCPlugin-Ifupdown: u=
pdate wireless security settings (wlan0).
May 16 11:52:08 brian-laptop NetworkManager[961]:    SCPlugin-Ifupdown: s=
etting wpa security key: psk=3D<omitted>
May 16 11:52:08 brian-laptop NetworkManager[961]: nm-ifupdown-connection.=
c.100 - invalid connection read from /etc/network/interfaces: (2) key-mgm=
t
May 16 11:52:08 brian-laptop NetworkManager[961]:    SCPlugin-Ifupdown: a=
dding iface wlan0 to eni_ifaces
May 16 11:52:08 brian-laptop NetworkManager[961]:    SCPluginIfupdown: ma=
nagement mode: unmanaged
May 16 11:52:08 brian-laptop NetworkManager[961]:    SCPlugin-Ifupdown: d=
evices added (path: /sys/devices/pci0000:00/0000:00:1c.0/0000:01:00.0/net=
/wlan0, iface: wlan0)
May 16 11:52:08 brian-laptop NetworkManager[961]:    SCPlugin-Ifupdown: d=
evices added (path: /sys/devices/virtual/net/lo, iface: lo)
May 16 11:52:08 brian-laptop NetworkManager[961]:    SCPlugin-Ifupdown: d=
evice added (path: /sys/devices/virtual/net/lo, iface: lo): no ifupdown c=
onfiguration found.
May 16 11:52:08 brian-laptop NetworkManager[961]:    SCPlugin-Ifupdown: e=
nd _init.
May 16 11:52:08 brian-laptop NetworkManager[961]: <info> Loaded plugin if=
updown: (C) 2008 Canonical Ltd.  To report bugs please use the NetworkMan=
ager mailing list.
May 16 11:52:08 brian-laptop NetworkManager[961]: <info> Loaded plugin ke=
yfile: (c) 2007 - 2010 Red Hat, Inc.  To report bugs please use the Netwo=
rkManager mailing list.
May 16 11:52:08 brian-laptop NetworkManager[961]:    SCPlugin-Ofono: Acqu=
ired D-Bus service com.canonical.NMOfono
May 16 11:52:08 brian-laptop NetworkManager[961]:    SCPlugin-Ofono: init=
!
May 16 11:52:08 brian-laptop NetworkManager[961]:    SCPlugin-Ofono: end =
_init.
May 16 11:52:08 brian-laptop NetworkManager[961]: <info> Loaded plugin (n=
ull): (null)
May 16 11:52:08 brian-laptop NetworkManager[961]:    Ifupdown: get unmana=
ged devices count: 1
May 16 11:52:08 brian-laptop NetworkManager[961]:    SCPlugin-Ifupdown: (=
35880496) ... get_connections.
May 16 11:52:08 brian-laptop NetworkManager[961]:    SCPlugin-Ifupdown: (=
35880496) ... get_connections (managed=3Dfalse): return empty list.
May 16 11:52:08 brian-laptop NetworkManager[961]:    keyfile: parsing bri=
anspot ...=20
May 16 11:52:08 brian-laptop kernel: [    8.397041] audit_printk_skb: 3 c=
allbacks suppressed
May 16 11:52:08 brian-laptop kernel: [    8.397043] type=3D1400 audit(140=
0262728.030:12): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"/usr/lib/lightdm/lightdm-guest-session" pid=3D1000 c=
omm=3D"apparmor_parser"
May 16 11:52:08 brian-laptop kernel: [    8.397048] type=3D1400 audit(140=
0262728.030:13): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"chromium" pid=3D1000 comm=3D"apparmor_parser"
May 16 11:52:08 brian-laptop kernel: [    8.397234] type=3D1400 audit(140=
0262728.030:14): apparmor=3D"STATUS" operation=3D"profile_replace" profil=
e=3D"unconfined" name=3D"chromium" pid=3D1000 comm=3D"apparmor_parser"
May 16 11:52:08 brian-laptop kernel: [    8.398088] type=3D1400 audit(140=
0262728.030:15): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"/usr/lib/x86_64-linux-gnu/lightdm-remote-session-fre=
erdp/freerdp-session-wrapper" pid=3D1001 comm=3D"apparmor_parser"
May 16 11:52:08 brian-laptop kernel: [    8.398095] type=3D1400 audit(140=
0262728.030:16): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"chromium" pid=3D1001 comm=3D"apparmor_parser"
May 16 11:52:08 brian-laptop kernel: [    8.398423] type=3D1400 audit(140=
0262728.030:17): apparmor=3D"STATUS" operation=3D"profile_replace" profil=
e=3D"unconfined" name=3D"chromium" pid=3D1001 comm=3D"apparmor_parser"
May 16 11:52:08 brian-laptop kernel: [    8.400130] type=3D1400 audit(140=
0262728.034:18): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"/usr/lib/x86_64-linux-gnu/lightdm-remote-session-ucc=
sconfigure/uccsconfigure-session-wrapper" pid=3D1002 comm=3D"apparmor_par=
ser"
May 16 11:52:08 brian-laptop kernel: [    8.400135] type=3D1400 audit(140=
0262728.034:19): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"chromium" pid=3D1002 comm=3D"apparmor_parser"
May 16 11:52:08 brian-laptop kernel: [    8.400345] type=3D1400 audit(140=
0262728.034:20): apparmor=3D"STATUS" operation=3D"profile_replace" profil=
e=3D"unconfined" name=3D"chromium" pid=3D1002 comm=3D"apparmor_parser"
May 16 11:52:08 brian-laptop kernel: [    8.401644] type=3D1400 audit(140=
0262728.034:21): apparmor=3D"STATUS" operation=3D"profile_replace" profil=
e=3D"unconfined" name=3D"/sbin/dhclient" pid=3D1003 comm=3D"apparmor_pars=
er"
May 16 11:52:08 brian-laptop NetworkManager[961]:    keyfile:     read co=
nnection 'brianspot'
May 16 11:52:08 brian-laptop NetworkManager[961]:    keyfile: parsing kne=
aders ...=20
May 16 11:52:08 brian-laptop NetworkManager[961]:    keyfile:     read co=
nnection 'kneaders'
May 16 11:52:08 brian-laptop NetworkManager[961]:    keyfile: parsing BJO=
NES ...=20
May 16 11:52:08 brian-laptop NetworkManager[961]:    keyfile:     read co=
nnection 'BJONES'
May 16 11:52:08 brian-laptop NetworkManager[961]:    SCPlugin-Ofono: (-33=
5528592) ... get_connections.
May 16 11:52:08 brian-laptop NetworkManager[961]:    SCPlugin-Ofono: (-33=
5528592) connections count: 0
May 16 11:52:08 brian-laptop NetworkManager[961]:    Ifupdown: get unmana=
ged devices count: 1
May 16 11:52:08 brian-laptop NetworkManager[961]: <info> monitoring kerne=
l firmware directory '/lib/firmware'.
May 16 11:52:08 brian-laptop NetworkManager[961]: <info> rfkill0: found W=
iFi radio killswitch (at /sys/devices/pci0000:00/0000:00:1c.0/0000:01:00.=
0/ieee80211/phy0/rfkill0) (driver iwlwifi)
May 16 11:52:08 brian-laptop NetworkManager[961]: <info> WiFi enabled by =
radio killswitch; enabled by state file
May 16 11:52:08 brian-laptop NetworkManager[961]: <info> WWAN enabled by =
radio killswitch; enabled by state file
May 16 11:52:08 brian-laptop NetworkManager[961]: <info> WiMAX enabled by=
 radio killswitch; enabled by state file
May 16 11:52:08 brian-laptop NetworkManager[961]: <info> Networking is en=
abled by state file
May 16 11:52:08 brian-laptop NetworkManager[961]: <info> (wlan0): using n=
l80211 for WiFi device control
May 16 11:52:08 brian-laptop NetworkManager[961]: <info> (wlan0): driver =
supports Access Point (AP) mode
May 16 11:52:08 brian-laptop NetworkManager[961]: <info> (wlan0): new 802=
=2E11 WiFi device (driver: 'iwlwifi' ifindex: 2)
May 16 11:52:08 brian-laptop NetworkManager[961]: <info> (wlan0): exporte=
d as /org/freedesktop/NetworkManager/Devices/0
May 16 11:52:08 brian-laptop NetworkManager[961]: <warn> /sys/devices/vir=
tual/net/lo: couldn't determine device driver; ignoring...
May 16 11:52:08 brian-laptop NetworkManager[961]: <warn> /sys/devices/vir=
tual/net/lo: couldn't determine device driver; ignoring...
May 16 11:52:08 brian-laptop NetworkManager[961]: <info> urfkill disappea=
red from the bus
May 16 11:52:08 brian-laptop NetworkManager[961]: <info> ModemManager ava=
ilable in the bus
May 16 11:52:08 brian-laptop kernel: [    8.450598] usb 2-7: new full-spe=
ed USB device number 7 using xhci_hcd
May 16 11:52:08 brian-laptop anacron[1125]: Anacron 2.3 started on 2014-0=
5-16
May 16 11:52:08 brian-laptop cron[1063]: (CRON) INFO (pidfile fd =3D 3)
May 16 11:52:08 brian-laptop anacron[1125]: Normal exit (0 jobs run)
May 16 11:52:08 brian-laptop whoopsie[1110]: whoopsie 0.2.24.5 starting u=
p.
May 16 11:52:08 brian-laptop whoopsie[1110]: Using lock path: /var/lock/w=
hoopsie/lock
May 16 11:52:08 brian-laptop acpid: starting up with netlink and the inpu=
t layer
May 16 11:52:08 brian-laptop cron[1126]: (CRON) STARTUP (fork ok)
May 16 11:52:08 brian-laptop acpid: 9 rules loaded
May 16 11:52:08 brian-laptop acpid: waiting for events: event logging is =
off
May 16 11:52:08 brian-laptop cron[1126]: (CRON) INFO (Running @reboot job=
s)
May 16 11:52:08 brian-laptop dbus[450]: [system] Activating service name=3D=
'org.freedesktop.Accounts' (using servicehelper)
May 16 11:52:08 brian-laptop accounts-daemon[1253]: started daemon versio=
n 0.6.35
May 16 11:52:08 brian-laptop dbus[450]: [system] Successfully activated s=
ervice 'org.freedesktop.Accounts'
May 16 11:52:08 brian-laptop acpid: client connected from 1250[0:0]
May 16 11:52:08 brian-laptop acpid: 1 client rule loaded
May 16 11:52:08 brian-laptop NetworkManager[961]: <info> Unmanaged Device=
 found; state CONNECTED forced. (see http://bugs.launchpad.net/bugs/19188=
9)
May 16 11:52:08 brian-laptop NetworkManager[961]: <info> Unmanaged Device=
 found; state CONNECTED forced. (see http://bugs.launchpad.net/bugs/19188=
9)
May 16 11:52:08 brian-laptop NetworkManager[961]: <info> NetworkManager s=
tate is now CONNECTED_GLOBAL
May 16 11:52:08 brian-laptop NetworkManager[961]: <info> Unmanaged Device=
 found; state CONNECTED forced. (see http://bugs.launchpad.net/bugs/19188=
9)
May 16 11:52:08 brian-laptop whoopsie[1133]: offline
May 16 11:52:08 brian-laptop kernel: [    8.814799] drm: not enough stole=
n space for compressed buffer (need 23142400 more bytes), disabling. Hint=
: you may be able to increase stolen memory size in the BIOS to avoid thi=
s.
May 16 11:52:08 brian-laptop dbus[450]: [system] Activating service name=3D=
'org.freedesktop.UPower' (using servicehelper)
May 16 11:52:08 brian-laptop dbus[450]: [system] Successfully activated s=
ervice 'org.freedesktop.UPower'
May 16 11:52:08 brian-laptop dbus[450]: [system] Activating service name=3D=
'org.freedesktop.RealtimeKit1' (using servicehelper)
May 16 11:52:08 brian-laptop dbus[450]: [system] Successfully activated s=
ervice 'org.freedesktop.RealtimeKit1'
May 16 11:52:08 brian-laptop rtkit-daemon[1447]: Successfully called chro=
ot.
May 16 11:52:08 brian-laptop rtkit-daemon[1447]: Successfully dropped pri=
vileges.
May 16 11:52:08 brian-laptop rtkit-daemon[1447]: Successfully limited res=
ources.
May 16 11:52:08 brian-laptop rtkit-daemon[1447]: Running.
May 16 11:52:08 brian-laptop rtkit-daemon[1447]: Watchdog thread running.=

May 16 11:52:08 brian-laptop rtkit-daemon[1447]: Canary thread running.
May 16 11:52:08 brian-laptop rtkit-daemon[1447]: Successfully made thread=
 1443 of process 1443 (n/a) owned by '111' high priority at nice level -1=
1.
May 16 11:52:08 brian-laptop rtkit-daemon[1447]: Supervising 1 threads of=
 1 processes of 1 users.
May 16 11:52:08 brian-laptop rtkit-daemon[1447]: Successfully made thread=
 1483 of process 1443 (n/a) owned by '111' RT at priority 5.
May 16 11:52:08 brian-laptop rtkit-daemon[1447]: Supervising 2 threads of=
 1 processes of 1 users.
May 16 11:52:08 brian-laptop rtkit-daemon[1447]: Successfully made thread=
 1484 of process 1443 (n/a) owned by '111' RT at priority 5.
May 16 11:52:08 brian-laptop rtkit-daemon[1447]: Supervising 3 threads of=
 1 processes of 1 users.
May 16 11:52:08 brian-laptop rtkit-daemon[1447]: Successfully made thread=
 1485 of process 1443 (n/a) owned by '111' RT at priority 5.
May 16 11:52:08 brian-laptop rtkit-daemon[1447]: Supervising 4 threads of=
 1 processes of 1 users.
May 16 11:52:10 brian-laptop ModemManager[929]: <warn>  Couldn't find sup=
port for device at '/sys/devices/pci0000:00/0000:00:1c.0/0000:01:00.0': n=
ot supported by any plugin
May 16 11:52:13 brian-laptop dbus[450]: [system] Activating service name=3D=
'org.freedesktop.UDisks2' (using servicehelper)
May 16 11:52:13 brian-laptop udisksd[1753]: udisks daemon version 2.1.3 s=
tarting
May 16 11:52:13 brian-laptop dbus[450]: [system] Successfully activated s=
ervice 'org.freedesktop.UDisks2'
May 16 11:52:13 brian-laptop udisksd[1753]: Acquired the name org.freedes=
ktop.UDisks2 on the system message bus
May 16 11:52:14 brian-laptop rtkit-daemon[1447]: Successfully made thread=
 1861 of process 1861 (n/a) owned by '1000' high priority at nice level -=
11.
May 16 11:52:14 brian-laptop rtkit-daemon[1447]: Supervising 5 threads of=
 2 processes of 2 users.
May 16 11:52:14 brian-laptop rtkit-daemon[1447]: Successfully made thread=
 1873 of process 1861 (n/a) owned by '1000' RT at priority 5.
May 16 11:52:14 brian-laptop rtkit-daemon[1447]: Supervising 6 threads of=
 2 processes of 2 users.
May 16 11:52:14 brian-laptop rtkit-daemon[1447]: Successfully made thread=
 1882 of process 1861 (n/a) owned by '1000' RT at priority 5.
May 16 11:52:14 brian-laptop rtkit-daemon[1447]: Supervising 7 threads of=
 2 processes of 2 users.
May 16 11:52:14 brian-laptop rtkit-daemon[1447]: Successfully made thread=
 1884 of process 1861 (n/a) owned by '1000' RT at priority 5.
May 16 11:52:14 brian-laptop rtkit-daemon[1447]: Supervising 8 threads of=
 2 processes of 2 users.
May 16 11:52:14 brian-laptop ntpdate[903]: adjust time server 91.189.94.4=
 offset -0.323511 sec
May 16 11:52:15 brian-laptop kernel: [   15.532346] usb 2-7: unable to re=
ad config index 0 descriptor/start: -110
May 16 11:52:15 brian-laptop kernel: [   15.532350] usb 2-7: can't read c=
onfigurations, error -110
May 16 11:52:15 brian-laptop kernel: [   15.532392] hub 2-0:1.0: unable t=
o enumerate USB device on port 7
May 16 11:52:15 brian-laptop kernel: [   15.644478] usb 2-8: new high-spe=
ed USB device number 8 using xhci_hcd
May 16 11:52:15 brian-laptop kernel: [   15.695584] usb 2-8: New USB devi=
ce found, idVendor=3D5986, idProduct=3D0535
May 16 11:52:15 brian-laptop kernel: [   15.695587] usb 2-8: New USB devi=
ce strings: Mfr=3D3, Product=3D1, SerialNumber=3D2
May 16 11:52:15 brian-laptop kernel: [   15.695590] usb 2-8: Product: Len=
ovo EasyCamera
May 16 11:52:15 brian-laptop kernel: [   15.695592] usb 2-8: Manufacturer=
: Generic
May 16 11:52:15 brian-laptop kernel: [   15.695593] usb 2-8: SerialNumber=
: 200901010001
May 16 11:52:15 brian-laptop kernel: [   15.936857] usb 2-7: new full-spe=
ed USB device number 9 using xhci_hcd
May 16 11:52:17 brian-laptop kernel: [   18.016935] usb 2-7: unable to re=
ad config index 0 descriptor/start: -71
May 16 11:52:17 brian-laptop kernel: [   18.016940] usb 2-7: can't read c=
onfigurations, error -71
May 16 11:52:17 brian-laptop kernel: [   18.183781] usb 2-7: new full-spe=
ed USB device number 10 using xhci_hcd
May 16 11:52:14 brian-laptop NetworkManager[961]: message repeated 3 time=
s: [ <info> Unmanaged Device found; state CONNECTED forced. (see http://b=
ugs.launchpad.net/bugs/191889)]
May 16 11:52:18 brian-laptop NetworkManager[961]: <info> WiFi hardware ra=
dio set enabled
May 16 11:52:19 brian-laptop kernel: [   20.264462] usb 2-7: unable to re=
ad config index 0 descriptor/start: -71
May 16 11:52:19 brian-laptop kernel: [   20.264465] usb 2-7: can't read c=
onfigurations, error -71
May 16 11:52:20 brian-laptop kernel: [   20.430713] usb 2-7: new full-spe=
ed USB device number 11 using xhci_hcd
May 16 11:52:22 brian-laptop kernel: [   22.510647] usb 2-7: unable to re=
ad config index 0 descriptor/start: -71
May 16 11:52:22 brian-laptop kernel: [   22.510651] usb 2-7: can't read c=
onfigurations, error -71
May 16 11:52:22 brian-laptop kernel: [   22.677650] usb 2-7: new full-spe=
ed USB device number 12 using xhci_hcd
May 16 11:52:22 brian-laptop kernel: [   22.695021] usb 2-7: New USB devi=
ce found, idVendor=3D04f3, idProduct=3D016f
May 16 11:52:22 brian-laptop kernel: [   22.695024] usb 2-7: New USB devi=
ce strings: Mfr=3D4, Product=3D14, SerialNumber=3D0
May 16 11:52:22 brian-laptop kernel: [   22.695025] usb 2-7: Product: Tou=
chscreen
May 16 11:52:22 brian-laptop kernel: [   22.695027] usb 2-7: Manufacturer=
: ELAN
May 16 11:52:22 brian-laptop kernel: [   22.695111] usb 2-7: ep 0x2 - rou=
nding interval to 64 microframes, ep desc says 80 microframes
May 16 11:52:22 brian-laptop mtp-probe: checking bus 2, device 3: "/sys/d=
evices/pci0000:00/0000:00:14.0/usb2/2-6"
May 16 11:52:22 brian-laptop mtp-probe: bus: 2, device: 3 was not an MTP =
device
May 16 11:52:22 brian-laptop mtp-probe: checking bus 2, device 12: "/sys/=
devices/pci0000:00/0000:00:14.0/usb2/2-7"
May 16 11:52:22 brian-laptop kernel: [   22.716694] usbcore: registered n=
ew interface driver btusb
May 16 11:52:22 brian-laptop kernel: [   22.722632] hidraw: raw HID event=
s driver (C) Jiri Kosina
May 16 11:52:22 brian-laptop mtp-probe: checking bus 2, device 8: "/sys/d=
evices/pci0000:00/0000:00:14.0/usb2/2-8"
May 16 11:52:22 brian-laptop mtp-probe: bus: 2, device: 8 was not an MTP =
device
May 16 11:52:22 brian-laptop mtp-probe: bus: 2, device: 12 was not an MTP=
 device
May 16 11:52:22 brian-laptop kernel: [   22.735278] Bluetooth: hci0: read=
 Intel version: 370710018002030d00
May 16 11:52:22 brian-laptop kernel: [   22.736237] Bluetooth: hci0: Inte=
l Bluetooth firmware file: intel/ibt-hw-37.7.10-fw-1.80.2.3.d.bseq
May 16 11:52:22 brian-laptop kernel: [   22.738194] Linux video capture i=
nterface: v2.00
May 16 11:52:22 brian-laptop kernel: [   22.745812] uvcvideo: Found UVC 1=
=2E00 device Lenovo EasyCamera (5986:0535)
May 16 11:52:22 brian-laptop kernel: [   22.750712] usbcore: registered n=
ew interface driver usbhid
May 16 11:52:22 brian-laptop kernel: [   22.750715] usbhid: USB HID core =
driver
May 16 11:52:22 brian-laptop kernel: [   22.757328] input: Lenovo EasyCam=
era as /devices/pci0000:00/0000:00:14.0/usb2/2-8/2-8:1.0/input/input12
May 16 11:52:22 brian-laptop kernel: [   22.757467] usbcore: registered n=
ew interface driver uvcvideo
May 16 11:52:22 brian-laptop kernel: [   22.757470] USB Video Class drive=
r (1.1.1)
May 16 11:52:22 brian-laptop kernel: [   22.759011] input: ELAN Touchscre=
en as /devices/pci0000:00/0000:00:14.0/usb2/2-7/2-7:1.0/input/input13
May 16 11:52:22 brian-laptop kernel: [   22.761246] hid-multitouch 0003:0=
4F3:016F.0002: input,hiddev0,hidraw0: USB HID v1.10 Device [ELAN Touchscr=
een] on usb-0000:00:14.0-7/input0
May 16 11:52:22 brian-laptop kernel: [   22.844230] Bluetooth: hci0: Inte=
l Bluetooth firmware patch completed and activated
May 16 11:52:22 brian-laptop bluetoothd[463]: Unknown command complete fo=
r opcode 19
May 16 11:52:22 brian-laptop bluetoothd[463]: Endpoint registered: sender=
=3D:1.54 path=3D/MediaEndpoint/HFPAG
May 16 11:52:22 brian-laptop bluetoothd[463]: Endpoint registered: sender=
=3D:1.54 path=3D/MediaEndpoint/HFPHS
May 16 11:52:22 brian-laptop bluetoothd[463]: Endpoint registered: sender=
=3D:1.54 path=3D/MediaEndpoint/A2DPSource
May 16 11:52:22 brian-laptop bluetoothd[463]: Endpoint registered: sender=
=3D:1.54 path=3D/MediaEndpoint/A2DPSink
May 16 11:52:22 brian-laptop bluetoothd[463]: Endpoint registered: sender=
=3D:1.31 path=3D/MediaEndpoint/HFPAG
May 16 11:52:22 brian-laptop bluetoothd[463]: Endpoint registered: sender=
=3D:1.31 path=3D/MediaEndpoint/HFPHS
May 16 11:52:22 brian-laptop bluetoothd[463]: Endpoint registered: sender=
=3D:1.31 path=3D/MediaEndpoint/A2DPSource
May 16 11:52:22 brian-laptop bluetoothd[463]: Endpoint registered: sender=
=3D:1.31 path=3D/MediaEndpoint/A2DPSink
May 16 11:52:22 brian-laptop bluetoothd[463]: Adapter /org/bluez/463/hci0=
 has been enabled
May 16 11:52:32 brian-laptop bluetoothd[463]: Endpoint unregistered: send=
er=3D:1.31 path=3D/MediaEndpoint/HFPAG
May 16 11:52:32 brian-laptop bluetoothd[463]: Endpoint unregistered: send=
er=3D:1.31 path=3D/MediaEndpoint/HFPHS
May 16 11:52:32 brian-laptop bluetoothd[463]: Endpoint unregistered: send=
er=3D:1.31 path=3D/MediaEndpoint/A2DPSource
May 16 11:52:32 brian-laptop bluetoothd[463]: Endpoint unregistered: send=
er=3D:1.31 path=3D/MediaEndpoint/A2DPSink
May 16 11:52:32 brian-laptop ntpdate[2233]: adjust time server 91.189.89.=
199 offset -0.312122 sec
May 16 11:53:09 brian-laptop wpa_supplicant[752]: wlan0: WPA: Group rekey=
ing completed with 00:22:6b:54:68:d2 [GTK=3DTKIP]
May 16 11:53:58 brian-laptop kernel: [  118.602373] wlan0: deauthenticate=
d from 00:22:6b:54:68:d2 (Reason: 7)
May 16 11:53:09 brian-laptop wpa_supplicant[752]: message repeated 3 time=
s: [ wlan0: WPA: Group rekeying completed with 00:22:6b:54:68:d2 [GTK=3DT=
KIP]]
May 16 11:53:58 brian-laptop wpa_supplicant[752]: wlan0: CTRL-EVENT-DISCO=
NNECTED bssid=3D00:22:6b:54:68:d2 reason=3D7
May 16 11:53:58 brian-laptop wpa_supplicant[752]: wlan0: SME: Trying to a=
uthenticate with 00:22:6b:54:68:d2 (SSID=3D'BJONES' freq=3D2437 MHz)
May 16 11:53:58 brian-laptop wpa_supplicant[752]: wlan0: CTRL-EVENT-SCAN-=
STARTED=20
May 16 11:53:58 brian-laptop kernel: [  118.619517] cfg80211: Calling CRD=
A to update world regulatory domain
May 16 11:53:58 brian-laptop kernel: [  118.626341] cfg80211: World regul=
atory domain updated:
May 16 11:53:58 brian-laptop kernel: [  118.626347] cfg80211:   (start_fr=
eq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
May 16 11:53:58 brian-laptop kernel: [  118.626352] cfg80211:   (2402000 =
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 11:53:58 brian-laptop kernel: [  118.626356] cfg80211:   (2457000 =
KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 11:53:58 brian-laptop kernel: [  118.626360] cfg80211:   (2474000 =
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
May 16 11:53:58 brian-laptop kernel: [  118.626363] cfg80211:   (5170000 =
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 11:53:58 brian-laptop kernel: [  118.626366] cfg80211:   (5735000 =
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 11:53:58 brian-laptop kernel: [  118.661595] wlan0: authenticate w=
ith 00:22:6b:54:68:d2
May 16 11:53:58 brian-laptop wpa_supplicant[752]: wlan0: Trying to associ=
ate with 00:22:6b:54:68:d2 (SSID=3D'BJONES' freq=3D2437 MHz)
May 16 11:53:58 brian-laptop kernel: [  118.663483] wlan0: send auth to 0=
0:22:6b:54:68:d2 (try 1/3)
May 16 11:53:58 brian-laptop kernel: [  118.665470] wlan0: authenticated
May 16 11:53:58 brian-laptop kernel: [  118.667161] wlan0: associate with=
 00:22:6b:54:68:d2 (try 1/3)
May 16 11:53:58 brian-laptop kernel: [  118.673893] wlan0: RX AssocResp f=
rom 00:22:6b:54:68:d2 (capab=3D0x411 status=3D0 aid=3D4)
May 16 11:53:58 brian-laptop wpa_supplicant[752]: wlan0: Associated with =
00:22:6b:54:68:d2
May 16 11:53:58 brian-laptop kernel: [  118.676025] wlan0: associated
May 16 11:53:58 brian-laptop wpa_supplicant[752]: wlan0: WPA: Key negotia=
tion completed with 00:22:6b:54:68:d2 [PTK=3DCCMP GTK=3DTKIP]
May 16 11:53:58 brian-laptop wpa_supplicant[752]: wlan0: CTRL-EVENT-CONNE=
CTED - Connection to 00:22:6b:54:68:d2 completed [id=3D0 id_str=3D]
May 16 11:54:21 brian-laptop bluetoothd[463]: Adapter /org/bluez/463/hci0=
 has been disabled
May 16 11:54:59 brian-laptop wpa_supplicant[752]: wlan0: CTRL-EVENT-DISCO=
NNECTED bssid=3D00:22:6b:54:68:d2 reason=3D3 locally_generated=3D1
May 16 11:54:59 brian-laptop kernel: [  179.647079] wlan0: deauthenticati=
ng from 00:22:6b:54:68:d2 by local choice (reason=3D3)
May 16 11:54:59 brian-laptop avahi-daemon[491]: Interface wlan0.IPv6 no l=
onger relevant for mDNS.
May 16 11:54:59 brian-laptop avahi-daemon[491]: Leaving mDNS multicast gr=
oup on interface wlan0.IPv6 with address 2002:d1b5:5206:0:5e51:4fff:fe63:=
1e10.
May 16 11:54:59 brian-laptop dhclient: receive_packet failed on wlan0: Ne=
twork is down
May 16 11:54:59 brian-laptop avahi-daemon[491]: Interface wlan0.IPv4 no l=
onger relevant for mDNS.
May 16 11:54:59 brian-laptop avahi-daemon[491]: Leaving mDNS multicast gr=
oup on interface wlan0.IPv4 with address 192.168.3.107.
May 16 11:54:59 brian-laptop kernel: [  179.709653] cfg80211: Calling CRD=
A to update world regulatory domain
May 16 11:54:59 brian-laptop NetworkManager[961]:    SCPlugin-Ifupdown: d=
evices removed (path: /sys/devices/pci0000:00/0000:00:1c.0/0000:01:00.0/n=
et/wlan0, iface: wlan0)
May 16 11:54:59 brian-laptop NetworkManager[961]:    Ifupdown: get unmana=
ged devices count: 0
May 16 11:54:59 brian-laptop avahi-daemon[491]: Withdrawing address recor=
d for 2002:d1b5:5206:0:ec65:a08f:3a2c:7e62 on wlan0.
May 16 11:54:59 brian-laptop avahi-daemon[491]: Withdrawing address recor=
d for 2002:d1b5:5206:0:5e51:4fff:fe63:1e10 on wlan0.
May 16 11:54:59 brian-laptop avahi-daemon[491]: Withdrawing address recor=
d for 192.168.3.107 on wlan0.
May 16 11:54:59 brian-laptop avahi-daemon[491]: Withdrawing workstation s=
ervice for wlan0.
May 16 11:54:59 brian-laptop kernel: [  179.718608] cfg80211: World regul=
atory domain updated:
May 16 11:54:59 brian-laptop kernel: [  179.718619] cfg80211:   (start_fr=
eq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
May 16 11:54:59 brian-laptop kernel: [  179.718628] cfg80211:   (2402000 =
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 11:54:59 brian-laptop kernel: [  179.718635] cfg80211:   (2457000 =
KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 11:54:59 brian-laptop kernel: [  179.718641] cfg80211:   (2474000 =
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
May 16 11:54:59 brian-laptop kernel: [  179.718647] cfg80211:   (5170000 =
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 11:54:59 brian-laptop kernel: [  179.718654] cfg80211:   (5735000 =
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 11:54:59 brian-laptop NetworkManager[961]: <info> radio killswitch=
 /sys/devices/pci0000:00/0000:00:1c.0/0000:01:00.0/ieee80211/phy0/rfkill0=
 disappeared
May 16 11:54:59 brian-laptop dhclient: Internet Systems Consortium DHCP C=
lient 4.2.4
May 16 11:54:59 brian-laptop dhclient: Copyright 2004-2012 Internet Syste=
ms Consortium.
May 16 11:54:59 brian-laptop dhclient: All rights reserved.
May 16 11:54:59 brian-laptop dhclient: For info, please visit https://www=
=2Eisc.org/software/dhcp/
May 16 11:54:59 brian-laptop dhclient:=20
May 16 11:54:59 brian-laptop dhclient: Error getting hardware address for=
 "wlan0": No such device
May 16 11:54:59 brian-laptop kernel: [  179.738033] waiting module remova=
l not supported: please upgrade
May 16 11:55:23 brian-laptop kernel: [  179.761856] waiting module remova=
l not supported: please upgrade<6>[  204.466418] cfg80211: Calling CRDA t=
o update world regulatory domain
May 16 11:55:23 brian-laptop kernel: [  204.470679] cfg80211: World regul=
atory domain updated:
May 16 11:55:23 brian-laptop kernel: [  204.470683] cfg80211:   (start_fr=
eq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
May 16 11:55:23 brian-laptop kernel: [  204.470686] cfg80211:   (2402000 =
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 11:55:23 brian-laptop kernel: [  204.470688] cfg80211:   (2457000 =
KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 11:55:23 brian-laptop kernel: [  204.470690] cfg80211:   (2474000 =
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
May 16 11:55:23 brian-laptop kernel: [  204.470691] cfg80211:   (5170000 =
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 11:55:23 brian-laptop kernel: [  204.470693] cfg80211:   (5735000 =
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 11:55:23 brian-laptop kernel: [  204.472862] Intel(R) Wireless WiF=
i driver for Linux, in-tree:
May 16 11:55:23 brian-laptop kernel: [  204.472866] Copyright(c) 2003-201=
3 Intel Corporation
May 16 11:55:23 brian-laptop kernel: [  204.473021] iwlwifi 0000:01:00.0:=
 irq 60 for MSI/MSI-X
May 16 11:55:23 brian-laptop kernel: [  204.473798] iwlwifi 0000:01:00.0:=
 loaded firmware version 22.24.8.0 op_mode iwlmvm
May 16 11:55:23 brian-laptop kernel: [  204.486426] iwlwifi 0000:01:00.0:=
 Detected Intel(R) Wireless N 7260, REV=3D0x144
May 16 11:55:23 brian-laptop kernel: [  204.486474] iwlwifi 0000:01:00.0:=
 L1 Disabled; Enabling L0S
May 16 11:55:23 brian-laptop kernel: [  204.486686] iwlwifi 0000:01:00.0:=
 L1 Disabled; Enabling L0S
May 16 11:55:24 brian-laptop kernel: [  204.682900] ieee80211 phy0: Selec=
ted rate control algorithm 'iwl-mvm-rs'
May 16 11:55:24 brian-laptop kernel: [  204.684997] iwlwifi 0000:01:00.0:=
 L1 Disabled; Enabling L0S
May 16 11:55:24 brian-laptop kernel: [  204.685234] iwlwifi 0000:01:00.0:=
 L1 Disabled; Enabling L0S
May 16 11:55:24 brian-laptop NetworkManager[961]:    SCPlugin-Ifupdown: d=
evices added (path: /sys/devices/pci0000:00/0000:00:1c.0/0000:01:00.0/net=
/wlan0, iface: wlan0)
May 16 11:55:24 brian-laptop NetworkManager[961]:    Ifupdown: get unmana=
ged devices count: 1
May 16 11:55:24 brian-laptop NetworkManager[961]: <info> (wlan0): using n=
l80211 for WiFi device control
May 16 11:55:24 brian-laptop NetworkManager[961]: <info> (wlan0): driver =
supports Access Point (AP) mode
May 16 11:55:24 brian-laptop NetworkManager[961]: <info> (wlan0): new 802=
=2E11 WiFi device (driver: 'iwlwifi' ifindex: 3)
May 16 11:55:24 brian-laptop kernel: [  204.698290] IPv6: ADDRCONF(NETDEV=
_UP): wlan0: link is not ready
May 16 11:55:24 brian-laptop NetworkManager[961]: <info> (wlan0): exporte=
d as /org/freedesktop/NetworkManager/Devices/1
May 16 11:55:24 brian-laptop NetworkManager[961]: <info> rfkill2: found W=
iFi radio killswitch (at /sys/devices/pci0000:00/0000:00:1c.0/0000:01:00.=
0/ieee80211/phy0/rfkill2) (driver iwlwifi)
May 16 11:55:24 brian-laptop wpa_supplicant[2657]: Successfully initializ=
ed wpa_supplicant
May 16 11:55:24 brian-laptop wpa_supplicant[2657]: ctrl_iface exists and =
seems to be in use - cannot override it
May 16 11:55:24 brian-laptop wpa_supplicant[2657]: Delete '/var/run/wpa_s=
upplicant/wlan0' manually if it is not used anymore
May 16 11:55:24 brian-laptop wpa_supplicant[2657]: Failed to initialize c=
ontrol interface '/var/run/wpa_supplicant'.#012You may have another wpa_s=
upplicant process already running or the file was#012left by an unclean t=
ermination of wpa_supplicant in which case you will need#012to manually r=
emove this file before starting wpa_supplicant again.
May 16 11:55:24 brian-laptop wpa_supplicant[752]: wlan0: CTRL-EVENT-TERMI=
NATING=20
May 16 11:55:24 brian-laptop dhclient: Internet Systems Consortium DHCP C=
lient 4.2.4
May 16 11:55:24 brian-laptop dhclient: Copyright 2004-2012 Internet Syste=
ms Consortium.
May 16 11:55:24 brian-laptop dhclient: All rights reserved.
May 16 11:55:24 brian-laptop dhclient: For info, please visit https://www=
=2Eisc.org/software/dhcp/
May 16 11:55:24 brian-laptop dhclient:=20
May 16 11:55:24 brian-laptop kernel: [  204.788425] iwlwifi 0000:01:00.0:=
 L1 Disabled; Enabling L0S
May 16 11:55:24 brian-laptop kernel: [  204.788638] iwlwifi 0000:01:00.0:=
 L1 Disabled; Enabling L0S
May 16 11:55:24 brian-laptop kernel: [  204.801782] IPv6: ADDRCONF(NETDEV=
_UP): wlan0: link is not ready
May 16 11:55:24 brian-laptop dhclient: Listening on LPF/wlan0/5c:51:4f:63=
:1e:10
May 16 11:55:24 brian-laptop dhclient: Sending on   LPF/wlan0/5c:51:4f:63=
:1e:10
May 16 11:55:24 brian-laptop dhclient: Sending on   Socket/fallback
May 16 11:55:24 brian-laptop dhclient: DHCPREQUEST of 192.168.3.107 on wl=
an0 to 255.255.255.255 port 67 (xid=3D0x539fa1ad)
May 16 11:55:32 brian-laptop dhclient: message repeated 2 times: [ DHCPRE=
QUEST of 192.168.3.107 on wlan0 to 255.255.255.255 port 67 (xid=3D0x539fa=
1ad)]
May 16 11:55:37 brian-laptop dhclient: DHCPDISCOVER on wlan0 to 255.255.2=
55.255 port 67 interval 3 (xid=3D0x297ab321)
May 16 11:55:40 brian-laptop dhclient: DHCPDISCOVER on wlan0 to 255.255.2=
55.255 port 67 interval 5 (xid=3D0x297ab321)
May 16 11:55:45 brian-laptop dhclient: DHCPDISCOVER on wlan0 to 255.255.2=
55.255 port 67 interval 8 (xid=3D0x297ab321)
May 16 11:55:53 brian-laptop dhclient: DHCPDISCOVER on wlan0 to 255.255.2=
55.255 port 67 interval 13 (xid=3D0x297ab321)
May 16 11:55:54 brian-laptop ntpdate[2714]: Can't find host ntp.ubuntu.co=
m: Name or service not known (-2)
May 16 11:55:54 brian-laptop ntpdate[2714]: no servers can be used, exiti=
ng
May 16 11:56:06 brian-laptop dhclient: DHCPDISCOVER on wlan0 to 255.255.2=
55.255 port 67 interval 18 (xid=3D0x297ab321)
May 16 11:56:17 brian-laptop dhclient: Internet Systems Consortium DHCP C=
lient 4.2.4
May 16 11:56:17 brian-laptop dhclient: Internet Systems Consortium DHCP C=
lient 4.2.4
May 16 11:56:17 brian-laptop dhclient: Copyright 2004-2012 Internet Syste=
ms Consortium.
May 16 11:56:17 brian-laptop dhclient: All rights reserved.
May 16 11:56:17 brian-laptop dhclient: For info, please visit https://www=
=2Eisc.org/software/dhcp/
May 16 11:56:17 brian-laptop dhclient:=20
May 16 11:56:17 brian-laptop dhclient: Copyright 2004-2012 Internet Syste=
ms Consortium.
May 16 11:56:17 brian-laptop dhclient: All rights reserved.
May 16 11:56:17 brian-laptop dhclient: For info, please visit https://www=
=2Eisc.org/software/dhcp/
May 16 11:56:17 brian-laptop dhclient:=20
May 16 11:56:17 brian-laptop dhclient: Listening on LPF/wlan0/5c:51:4f:63=
:1e:10
May 16 11:56:17 brian-laptop dhclient: Sending on   LPF/wlan0/5c:51:4f:63=
:1e:10
May 16 11:56:17 brian-laptop dhclient: Sending on   Socket/fallback
May 16 11:56:17 brian-laptop dhclient: Listening on LPF/wlan0/5c:51:4f:63=
:1e:10
May 16 11:56:17 brian-laptop dhclient: Sending on   LPF/wlan0/5c:51:4f:63=
:1e:10
May 16 11:56:17 brian-laptop dhclient: Sending on   Socket/fallback
May 16 11:56:18 brian-laptop dhclient: DHCPRELEASE on wlan0 to 192.168.3.=
1 port 67 (xid=3D0x6cff0721)
May 16 11:56:18 brian-laptop dhclient: send_packet: Network is unreachabl=
e
May 16 11:56:18 brian-laptop dhclient: send_packet: please consult README=
 file regarding broadcast address.
May 16 11:56:18 brian-laptop dhclient: dhclient.c:2365: Failed to send 30=
0 byte long packet over fallback interface.
May 16 11:56:29 brian-laptop kernel: [  270.180190] iwlwifi 0000:01:00.0:=
 L1 Disabled; Enabling L0S
May 16 11:56:29 brian-laptop kernel: [  270.180405] iwlwifi 0000:01:00.0:=
 L1 Disabled; Enabling L0S
May 16 11:56:29 brian-laptop kernel: [  270.192105] IPv6: ADDRCONF(NETDEV=
_UP): wlan0: link is not ready
May 16 11:56:59 brian-laptop kernel: [  300.204455] mce: [Hardware Error]=
: Machine check events logged
May 16 11:57:01 brian-laptop wpa_supplicant[2934]: Successfully initializ=
ed wpa_supplicant
May 16 11:57:02 brian-laptop wpa_supplicant[2935]: wlan0: CTRL-EVENT-SCAN=
-STARTED=20
May 16 11:57:02 brian-laptop dhclient: Internet Systems Consortium DHCP C=
lient 4.2.4
May 16 11:57:02 brian-laptop dhclient: Copyright 2004-2012 Internet Syste=
ms Consortium.
May 16 11:57:02 brian-laptop dhclient: All rights reserved.
May 16 11:57:02 brian-laptop dhclient: For info, please visit https://www=
=2Eisc.org/software/dhcp/
May 16 11:57:02 brian-laptop dhclient:=20
May 16 11:57:02 brian-laptop dhclient: Listening on LPF/wlan0/5c:51:4f:63=
:1e:10
May 16 11:57:02 brian-laptop dhclient: Sending on   LPF/wlan0/5c:51:4f:63=
:1e:10
May 16 11:57:02 brian-laptop dhclient: Sending on   Socket/fallback
May 16 11:57:02 brian-laptop dhclient: DHCPDISCOVER on wlan0 to 255.255.2=
55.255 port 67 interval 3 (xid=3D0x340b6b14)
May 16 11:57:03 brian-laptop wpa_supplicant[2935]: wlan0: SME: Trying to =
authenticate with 00:22:6b:54:68:d2 (SSID=3D'BJONES' freq=3D2437 MHz)
May 16 11:57:03 brian-laptop kernel: [  303.775748] wlan0: authenticate w=
ith 00:22:6b:54:68:d2
May 16 11:57:03 brian-laptop wpa_supplicant[2935]: wlan0: Trying to assoc=
iate with 00:22:6b:54:68:d2 (SSID=3D'BJONES' freq=3D2437 MHz)
May 16 11:57:03 brian-laptop kernel: [  303.778059] wlan0: send auth to 0=
0:22:6b:54:68:d2 (try 1/3)
May 16 11:57:03 brian-laptop kernel: [  303.779996] wlan0: authenticated
May 16 11:57:03 brian-laptop kernel: [  303.781221] wlan0: associate with=
 00:22:6b:54:68:d2 (try 1/3)
May 16 11:57:03 brian-laptop wpa_supplicant[2935]: wlan0: Associated with=
 00:22:6b:54:68:d2
May 16 11:57:03 brian-laptop kernel: [  303.785240] wlan0: RX AssocResp f=
rom 00:22:6b:54:68:d2 (capab=3D0x411 status=3D0 aid=3D4)
May 16 11:57:03 brian-laptop kernel: [  303.788146] wlan0: associated
May 16 11:57:03 brian-laptop kernel: [  303.788174] IPv6: ADDRCONF(NETDEV=
_CHANGE): wlan0: link becomes ready
May 16 11:57:03 brian-laptop wpa_supplicant[2935]: wlan0: WPA: Key negoti=
ation completed with 00:22:6b:54:68:d2 [PTK=3DCCMP GTK=3DTKIP]
May 16 11:57:03 brian-laptop wpa_supplicant[2935]: wlan0: CTRL-EVENT-CONN=
ECTED - Connection to 00:22:6b:54:68:d2 completed [id=3D0 id_str=3D]
May 16 11:57:04 brian-laptop avahi-daemon[491]: Joining mDNS multicast gr=
oup on interface wlan0.IPv6 with address fe80::5e51:4fff:fe63:1e10.
May 16 11:57:04 brian-laptop avahi-daemon[491]: New relevant interface wl=
an0.IPv6 for mDNS.
May 16 11:57:04 brian-laptop avahi-daemon[491]: Registering new address r=
ecord for fe80::5e51:4fff:fe63:1e10 on wlan0.*.
May 16 11:57:05 brian-laptop dhclient: DHCPDISCOVER on wlan0 to 255.255.2=
55.255 port 67 interval 8 (xid=3D0x340b6b14)
May 16 11:57:06 brian-laptop avahi-daemon[491]: Leaving mDNS multicast gr=
oup on interface wlan0.IPv6 with address fe80::5e51:4fff:fe63:1e10.
May 16 11:57:06 brian-laptop avahi-daemon[491]: Joining mDNS multicast gr=
oup on interface wlan0.IPv6 with address 2002:d1b5:5206:0:d4f2:217:c898:1=
4ce.
May 16 11:57:06 brian-laptop avahi-daemon[491]: Registering new address r=
ecord for 2002:d1b5:5206:0:d4f2:217:c898:14ce on wlan0.*.
May 16 11:57:06 brian-laptop avahi-daemon[491]: Withdrawing address recor=
d for fe80::5e51:4fff:fe63:1e10 on wlan0.
May 16 11:57:06 brian-laptop avahi-daemon[491]: Registering new address r=
ecord for 2002:d1b5:5206:0:5e51:4fff:fe63:1e10 on wlan0.*.
May 16 11:57:06 brian-laptop dhclient: DHCPREQUEST of 192.168.3.107 on wl=
an0 to 255.255.255.255 port 67 (xid=3D0x340b6b14)
May 16 11:57:06 brian-laptop dhclient: DHCPOFFER of 192.168.3.107 from 19=
2.168.3.1
May 16 11:57:06 brian-laptop dhclient: DHCPACK of 192.168.3.107 from 192.=
168.3.1
May 16 11:57:06 brian-laptop avahi-daemon[491]: Joining mDNS multicast gr=
oup on interface wlan0.IPv4 with address 192.168.3.107.
May 16 11:57:06 brian-laptop avahi-daemon[491]: New relevant interface wl=
an0.IPv4 for mDNS.
May 16 11:57:06 brian-laptop avahi-daemon[491]: Registering new address r=
ecord for 192.168.3.107 on wlan0.IPv4.
May 16 11:57:06 brian-laptop dhclient: bound to 192.168.3.107 -- renewal =
in 40271 seconds.
May 16 11:57:13 brian-laptop ntpdate[3061]: adjust time server 91.189.94.=
4 offset -0.182549 sec
May 16 11:57:22 brian-laptop NetworkManager[961]: <info> Unmanaged Device=
 found; state CONNECTED forced. (see http://bugs.launchpad.net/bugs/19188=
9)
May 16 11:57:28 brian-laptop ntpdate[3204]: adjust time server 91.189.94.=
4 offset -0.178000 sec
May 16 12:03:39 brian-laptop avahi-daemon[491]: Registering new address r=
ecord for 2002:d1b5:5206:0:48cc:f54a:da28:526b on wlan0.*.
May 16 12:09:01 brian-laptop CRON[3290]: (root) CMD (  [ -x /usr/lib/php5=
/maxlifetime ] && [ -x /usr/lib/php5/sessionclean ] && [ -d /var/lib/php5=
 ] && /usr/lib/php5/sessionclean /var/lib/php5 $(/usr/lib/php5/maxlifetim=
e))
May 16 12:17:01 brian-laptop CRON[3319]: (root) CMD (   cd / && run-parts=
 --report /etc/cron.hourly)
May 16 12:18:34 brian-laptop kernel: [ 1596.072761] audit_printk_skb: 138=
 callbacks suppressed
May 16 12:18:34 brian-laptop kernel: [ 1596.072764] type=3D1400 audit(140=
0264314.029:68): apparmor=3D"DENIED" operation=3D"open" profile=3D"/usr/b=
in/evince" name=3D"/etc/xfce4/defaults.list" pid=3D3494 comm=3D"evince" r=
equested_mask=3D"r" denied_mask=3D"r" fsuid=3D1000 ouid=3D0
May 16 12:26:13 brian-laptop avahi-daemon[491]: Registering new address r=
ecord for 2002:d1b5:5206:0:a1c8:dc8d:52a4:417c on wlan0.*.
May 16 12:39:01 brian-laptop CRON[3677]: (root) CMD (  [ -x /usr/lib/php5=
/maxlifetime ] && [ -x /usr/lib/php5/sessionclean ] && [ -d /var/lib/php5=
 ] && /usr/lib/php5/sessionclean /var/lib/php5 $(/usr/lib/php5/maxlifetim=
e))
May 16 12:52:33 brian-laptop wpa_supplicant[2935]: wlan0: WPA: Group reke=
ying completed with 00:22:6b:54:68:d2 [GTK=3DTKIP]
May 16 13:09:01 brian-laptop CRON[4504]: (root) CMD (  [ -x /usr/lib/php5=
/maxlifetime ] && [ -x /usr/lib/php5/sessionclean ] && [ -d /var/lib/php5=
 ] && /usr/lib/php5/sessionclean /var/lib/php5 $(/usr/lib/php5/maxlifetim=
e))
May 16 13:17:01 brian-laptop CRON[4555]: (root) CMD (   cd / && run-parts=
 --report /etc/cron.hourly)
May 16 13:28:41 brian-laptop avahi-daemon[491]: Registering new address r=
ecord for 2002:d1b5:5206:0:a0d7:3b4c:3e20:fa1 on wlan0.*.
May 16 13:28:42 brian-laptop avahi-daemon[491]: Withdrawing address recor=
d for 2002:d1b5:5206:0:d4f2:217:c898:14ce on wlan0.
May 16 13:28:42 brian-laptop avahi-daemon[491]: Withdrawing address recor=
d for 2002:d1b5:5206:0:48cc:f54a:da28:526b on wlan0.
May 16 13:28:42 brian-laptop avahi-daemon[491]: Withdrawing address recor=
d for 2002:d1b5:5206:0:a1c8:dc8d:52a4:417c on wlan0.
May 16 13:28:42 brian-laptop avahi-daemon[491]: Withdrawing address recor=
d for 2002:d1b5:5206:0:a0d7:3b4c:3e20:fa1 on wlan0.
May 16 13:28:42 brian-laptop avahi-daemon[491]: Registering new address r=
ecord for 2002:d1b5:5206:0:a0d7:3b4c:3e20:fa1 on wlan0.*.
May 16 13:28:42 brian-laptop avahi-daemon[491]: Registering new address r=
ecord for 2002:d1b5:5206:0:a1c8:dc8d:52a4:417c on wlan0.*.
May 16 13:28:42 brian-laptop avahi-daemon[491]: Registering new address r=
ecord for 2002:d1b5:5206:0:48cc:f54a:da28:526b on wlan0.*.
May 16 13:28:42 brian-laptop avahi-daemon[491]: Registering new address r=
ecord for 2002:d1b5:5206:0:d4f2:217:c898:14ce on wlan0.*.
May 16 13:28:42 brian-laptop avahi-daemon[491]: Registering new address r=
ecord for fe80::5e51:4fff:fe63:1e10 on wlan0.*.
May 16 13:28:43 brian-laptop avahi-daemon[491]: Withdrawing address recor=
d for 2002:d1b5:5206:0:a0d7:3b4c:3e20:fa1 on wlan0.
May 16 13:28:43 brian-laptop avahi-daemon[491]: Withdrawing address recor=
d for 2002:d1b5:5206:0:a1c8:dc8d:52a4:417c on wlan0.
May 16 13:28:43 brian-laptop avahi-daemon[491]: Withdrawing address recor=
d for 2002:d1b5:5206:0:48cc:f54a:da28:526b on wlan0.
May 16 13:28:43 brian-laptop avahi-daemon[491]: Withdrawing address recor=
d for 2002:d1b5:5206:0:d4f2:217:c898:14ce on wlan0.
May 16 13:28:43 brian-laptop avahi-daemon[491]: Withdrawing address recor=
d for fe80::5e51:4fff:fe63:1e10 on wlan0.
May 16 13:28:43 brian-laptop avahi-daemon[491]: Registering new address r=
ecord for 2002:d1b5:5206:0:a0d7:3b4c:3e20:fa1 on wlan0.*.
May 16 13:28:43 brian-laptop avahi-daemon[491]: Registering new address r=
ecord for 2002:d1b5:5206:0:a1c8:dc8d:52a4:417c on wlan0.*.
May 16 13:28:43 brian-laptop avahi-daemon[491]: Registering new address r=
ecord for 2002:d1b5:5206:0:48cc:f54a:da28:526b on wlan0.*.
May 16 13:28:43 brian-laptop avahi-daemon[491]: Registering new address r=
ecord for 2002:d1b5:5206:0:d4f2:217:c898:14ce on wlan0.*.
May 16 13:39:01 brian-laptop CRON[4673]: (root) CMD (  [ -x /usr/lib/php5=
/maxlifetime ] && [ -x /usr/lib/php5/sessionclean ] && [ -d /var/lib/php5=
 ] && /usr/lib/php5/sessionclean /var/lib/php5 $(/usr/lib/php5/maxlifetim=
e))
May 16 13:47:42 brian-laptop avahi-daemon[491]: Registering new address r=
ecord for 2002:d1b5:5206:0:cc62:1f5d:df1a:931e on wlan0.*.
May 16 14:09:01 brian-laptop CRON[4850]: (root) CMD (  [ -x /usr/lib/php5=
/maxlifetime ] && [ -x /usr/lib/php5/sessionclean ] && [ -d /var/lib/php5=
 ] && /usr/lib/php5/sessionclean /var/lib/php5 $(/usr/lib/php5/maxlifetim=
e))
May 16 14:10:06 brian-laptop avahi-daemon[491]: Registering new address r=
ecord for 2002:d1b5:5206:0:5ca5:f943:a7ae:7fb2 on wlan0.*.
May 16 14:15:43 brian-laptop avahi-daemon[491]: Registering new address r=
ecord for 2002:d1b5:5206:0:d476:7126:1643:c5cf on wlan0.*.
May 16 14:17:01 brian-laptop CRON[4947]: (root) CMD (   cd / && run-parts=
 --report /etc/cron.hourly)
May 16 14:30:10 brian-laptop avahi-daemon[491]: Registering new address r=
ecord for 2002:d1b5:5206:0:509c:6305:a431:2ccd on wlan0.*.
May 16 14:30:11 brian-laptop avahi-daemon[491]: Withdrawing address recor=
d for 2002:d1b5:5206:0:d4f2:217:c898:14ce on wlan0.
May 16 14:30:11 brian-laptop avahi-daemon[491]: Withdrawing address recor=
d for 2002:d1b5:5206:0:5ca5:f943:a7ae:7fb2 on wlan0.
May 16 14:30:11 brian-laptop avahi-daemon[491]: Withdrawing address recor=
d for 2002:d1b5:5206:0:48cc:f54a:da28:526b on wlan0.
May 16 14:30:11 brian-laptop avahi-daemon[491]: Withdrawing address recor=
d for 2002:d1b5:5206:0:a1c8:dc8d:52a4:417c on wlan0.
May 16 14:30:11 brian-laptop avahi-daemon[491]: Withdrawing address recor=
d for 2002:d1b5:5206:0:a0d7:3b4c:3e20:fa1 on wlan0.
May 16 14:30:11 brian-laptop avahi-daemon[491]: Withdrawing address recor=
d for 2002:d1b5:5206:0:cc62:1f5d:df1a:931e on wlan0.
May 16 14:30:11 brian-laptop avahi-daemon[491]: Withdrawing address recor=
d for 2002:d1b5:5206:0:509c:6305:a431:2ccd on wlan0.
May 16 14:30:11 brian-laptop avahi-daemon[491]: Withdrawing address recor=
d for 2002:d1b5:5206:0:d476:7126:1643:c5cf on wlan0.
May 16 14:30:11 brian-laptop avahi-daemon[491]: Registering new address r=
ecord for 2002:d1b5:5206:0:509c:6305:a431:2ccd on wlan0.*.
May 16 14:30:11 brian-laptop avahi-daemon[491]: Registering new address r=
ecord for 2002:d1b5:5206:0:d476:7126:1643:c5cf on wlan0.*.
May 16 14:30:11 brian-laptop avahi-daemon[491]: Registering new address r=
ecord for 2002:d1b5:5206:0:5ca5:f943:a7ae:7fb2 on wlan0.*.
May 16 14:30:11 brian-laptop avahi-daemon[491]: Registering new address r=
ecord for 2002:d1b5:5206:0:cc62:1f5d:df1a:931e on wlan0.*.
May 16 14:30:11 brian-laptop avahi-daemon[491]: Registering new address r=
ecord for 2002:d1b5:5206:0:a0d7:3b4c:3e20:fa1 on wlan0.*.
May 16 14:30:11 brian-laptop avahi-daemon[491]: Registering new address r=
ecord for 2002:d1b5:5206:0:a1c8:dc8d:52a4:417c on wlan0.*.
May 16 14:30:11 brian-laptop avahi-daemon[491]: Registering new address r=
ecord for 2002:d1b5:5206:0:48cc:f54a:da28:526b on wlan0.*.
May 16 14:30:11 brian-laptop avahi-daemon[491]: Registering new address r=
ecord for 2002:d1b5:5206:0:d4f2:217:c898:14ce on wlan0.*.
May 16 14:30:11 brian-laptop avahi-daemon[491]: Registering new address r=
ecord for fe80::5e51:4fff:fe63:1e10 on wlan0.*.
May 16 14:30:21 brian-laptop avahi-daemon[491]: Withdrawing address recor=
d for 2002:d1b5:5206:0:d4f2:217:c898:14ce on wlan0.
May 16 14:30:21 brian-laptop avahi-daemon[491]: Leaving mDNS multicast gr=
oup on interface wlan0.IPv6 with address 2002:d1b5:5206:0:d4f2:217:c898:1=
4ce.
May 16 14:30:21 brian-laptop avahi-daemon[491]: Joining mDNS multicast gr=
oup on interface wlan0.IPv6 with address 2002:d1b5:5206:0:509c:6305:a431:=
2ccd.
May 16 14:30:21 brian-laptop avahi-daemon[491]: Withdrawing address recor=
d for 2002:d1b5:5206:0:5ca5:f943:a7ae:7fb2 on wlan0.
May 16 14:30:21 brian-laptop avahi-daemon[491]: Withdrawing address recor=
d for 2002:d1b5:5206:0:48cc:f54a:da28:526b on wlan0.
May 16 14:30:21 brian-laptop avahi-daemon[491]: Withdrawing address recor=
d for 2002:d1b5:5206:0:a1c8:dc8d:52a4:417c on wlan0.
May 16 14:30:21 brian-laptop avahi-daemon[491]: Withdrawing address recor=
d for 2002:d1b5:5206:0:a0d7:3b4c:3e20:fa1 on wlan0.
May 16 14:30:21 brian-laptop avahi-daemon[491]: Withdrawing address recor=
d for 2002:d1b5:5206:0:cc62:1f5d:df1a:931e on wlan0.
May 16 14:30:21 brian-laptop avahi-daemon[491]: Withdrawing address recor=
d for 2002:d1b5:5206:0:509c:6305:a431:2ccd on wlan0.
May 16 14:30:21 brian-laptop avahi-daemon[491]: Leaving mDNS multicast gr=
oup on interface wlan0.IPv6 with address 2002:d1b5:5206:0:509c:6305:a431:=
2ccd.
May 16 14:30:21 brian-laptop avahi-daemon[491]: Joining mDNS multicast gr=
oup on interface wlan0.IPv6 with address 2002:d1b5:5206:0:d476:7126:1643:=
c5cf.
May 16 14:30:21 brian-laptop avahi-daemon[491]: Withdrawing address recor=
d for 2002:d1b5:5206:0:d476:7126:1643:c5cf on wlan0.
May 16 14:30:21 brian-laptop avahi-daemon[491]: Leaving mDNS multicast gr=
oup on interface wlan0.IPv6 with address 2002:d1b5:5206:0:d476:7126:1643:=
c5cf.
May 16 14:30:21 brian-laptop avahi-daemon[491]: Joining mDNS multicast gr=
oup on interface wlan0.IPv6 with address 2002:d1b5:5206:0:5e51:4fff:fe63:=
1e10.
May 16 14:30:21 brian-laptop avahi-daemon[491]: Withdrawing address recor=
d for 2002:d1b5:5206:0:5e51:4fff:fe63:1e10 on wlan0.
May 16 14:30:21 brian-laptop avahi-daemon[491]: Leaving mDNS multicast gr=
oup on interface wlan0.IPv6 with address 2002:d1b5:5206:0:5e51:4fff:fe63:=
1e10.
May 16 14:30:21 brian-laptop avahi-daemon[491]: Joining mDNS multicast gr=
oup on interface wlan0.IPv6 with address fe80::5e51:4fff:fe63:1e10.
May 16 14:39:01 brian-laptop CRON[5075]: (root) CMD (  [ -x /usr/lib/php5=
/maxlifetime ] && [ -x /usr/lib/php5/sessionclean ] && [ -d /var/lib/php5=
 ] && /usr/lib/php5/sessionclean /var/lib/php5 $(/usr/lib/php5/maxlifetim=
e))
May 16 14:39:41 brian-laptop dhclient: Internet Systems Consortium DHCP C=
lient 4.2.4
May 16 14:39:41 brian-laptop dhclient: Copyright 2004-2012 Internet Syste=
ms Consortium.
May 16 14:39:41 brian-laptop dhclient: All rights reserved.
May 16 14:39:41 brian-laptop dhclient: For info, please visit https://www=
=2Eisc.org/software/dhcp/
May 16 14:39:41 brian-laptop dhclient:=20
May 16 14:39:41 brian-laptop dhclient: Listening on LPF/wlan0/5c:51:4f:63=
:1e:10
May 16 14:39:41 brian-laptop dhclient: Sending on   LPF/wlan0/5c:51:4f:63=
:1e:10
May 16 14:39:41 brian-laptop dhclient: Sending on   Socket/fallback
May 16 14:39:41 brian-laptop dhclient: DHCPRELEASE on wlan0 to 192.168.3.=
1 port 67 (xid=3D0x4c09f03c)
May 16 14:39:41 brian-laptop avahi-daemon[491]: Withdrawing address recor=
d for 192.168.3.107 on wlan0.
May 16 14:39:41 brian-laptop avahi-daemon[491]: Leaving mDNS multicast gr=
oup on interface wlan0.IPv4 with address 192.168.3.107.
May 16 14:39:43 brian-laptop kernel: [10072.381390] iwlwifi 0000:01:00.0:=
 Error sending MAC_CONTEXT_CMD: time out after 2000ms.
May 16 14:39:43 brian-laptop kernel: [10072.381401] iwlwifi 0000:01:00.0:=
 Current CMD queue read_ptr 26 write_ptr 27
May 16 14:39:43 brian-laptop kernel: [10072.399109] ------------[ cut her=
e ]------------
May 16 14:39:43 brian-laptop kernel: [10072.399130] WARNING: CPU: 0 PID: =
5143 at /build/buildd/linux-3.13.0/drivers/net/wireless/iwlwifi/pcie/tran=
s.c:1002 iwl_trans_pcie_grab_nic_access+0xcb/0xe0 [iwlwifi]()
May 16 14:39:43 brian-laptop kernel: [10072.399134] Timeout waiting for h=
ardware access (CSR_GP_CNTRL 0xffffffff)
May 16 14:39:43 brian-laptop kernel: [10072.399137] Modules linked in: iw=
lmvm mac80211 iwlwifi cfg80211 hid_sensor_accel_3d hid_sensor_gyro_3d hid=
_sensor_als hid_sensor_magn_3d hid_sensor_trigger industrialio_triggered_=
buffer kfifo_buf industrialio hid_sensor_iio_common hid_multitouch hid_se=
nsor_hub uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core video=
dev usbhid hid btusb ctr ccm snd_hda_codec_hdmi snd_hda_codec_realtek joy=
dev arc4 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_page_alloc snd=
_seq_midi snd_seq_midi_event intel_rapl x86_pkg_temp_thermal intel_powerc=
lamp coretemp snd_rawmidi kvm crct10dif_pclmul snd_seq crc32_pclmul ghash=
_clmulni_intel snd_seq_device snd_timer aesni_intel snd aes_x86_64 lrw gf=
128mul glue_helper ablk_helper cryptd i915 psmouse serio_raw drm_kms_help=
er lpc_ich drm mei_me mei soundcore i2c_algo_bit rfcomm bnep bluetooth nl=
s_iso8859_1 parport_pc ppdev video intel_smartconnect lp parport mac_hid =
ahci libahci [last unloaded: cfg80211]
May 16 14:39:43 brian-laptop kernel: [10072.399255] CPU: 0 PID: 5143 Comm=
: ip Not tainted 3.13.0-24-generic #47-Ubuntu
May 16 14:39:43 brian-laptop kernel: [10072.399258] Hardware name: LENOVO=
 20266/Yoga2, BIOS 76CN27WW 09/17/2013
May 16 14:39:43 brian-laptop kernel: [10072.399262]  0000000000000009 fff=
f8802034b3548 ffffffff81715ac4 ffff8802034b3590
May 16 14:39:43 brian-laptop kernel: [10072.399270]  ffff8802034b3580 fff=
fffff810676bd ffff8800367f8000 ffff8800367fb258
May 16 14:39:43 brian-laptop kernel: [10072.399277]  ffff8802034b3628 000=
0000000000000 0000000000000025 ffff8802034b35e0
May 16 14:39:43 brian-laptop kernel: [10072.399285] Call Trace:
May 16 14:39:43 brian-laptop kernel: [10072.399299]  [<ffffffff81715ac4>]=
 dump_stack+0x45/0x56
May 16 14:39:43 brian-laptop kernel: [10072.399308]  [<ffffffff810676bd>]=
 warn_slowpath_common+0x7d/0xa0
May 16 14:39:43 brian-laptop kernel: [10072.399314]  [<ffffffff8106772c>]=
 warn_slowpath_fmt+0x4c/0x50
May 16 14:39:43 brian-laptop kernel: [10072.399328]  [<ffffffffa018beda>]=
 ? iwl_read32+0x1a/0x80 [iwlwifi]
May 16 14:39:43 brian-laptop kernel: [10072.399340]  [<ffffffffa018d32b>]=
 iwl_trans_pcie_grab_nic_access+0xcb/0xe0 [iwlwifi]
May 16 14:39:43 brian-laptop kernel: [10072.399351]  [<ffffffffa018e3c1>]=
 iwl_trans_pcie_read_mem+0x31/0x130 [iwlwifi]
May 16 14:39:43 brian-laptop kernel: [10072.399366]  [<ffffffffa04efda7>]=
 iwl_mvm_dump_nic_error_log+0xc7/0x6b0 [iwlmvm]
May 16 14:39:43 brian-laptop kernel: [10072.399374]  [<ffffffff8109df24>]=
 ? arch_vtime_task_switch+0x94/0xa0
May 16 14:39:43 brian-laptop kernel: [10072.399383]  [<ffffffff8148a7ee>]=
 ? dev_printk_emit+0x3e/0x40
May 16 14:39:43 brian-laptop kernel: [10072.399391]  [<ffffffff8107457b>]=
 ? lock_timer_base.isra.35+0x2b/0x50
May 16 14:39:43 brian-laptop kernel: [10072.399398]  [<ffffffff8148ac0e>]=
 ? __dev_printk+0x3e/0x90
May 16 14:39:43 brian-laptop kernel: [10072.399404]  [<ffffffff8148ae2c>]=
 ? dev_err+0x5c/0x60
May 16 14:39:43 brian-laptop kernel: [10072.399415]  [<ffffffff813697aa>]=
 ? delay_tsc+0x4a/0x80
May 16 14:39:43 brian-laptop kernel: [10072.399427]  [<ffffffffa04ecef6>]=
 iwl_mvm_nic_error+0x16/0x30 [iwlmvm]
May 16 14:39:43 brian-laptop kernel: [10072.399439]  [<ffffffffa018b5b0>]=
 iwl_trans_pcie_send_hcmd+0x5b0/0x690 [iwlwifi]
May 16 14:39:43 brian-laptop kernel: [10072.399449]  [<ffffffff810aae90>]=
 ? prepare_to_wait_event+0x100/0x100
May 16 14:39:43 brian-laptop kernel: [10072.399460]  [<ffffffffa04ef88d>]=
 iwl_mvm_send_cmd+0x2d/0x90 [iwlmvm]
May 16 14:39:43 brian-laptop kernel: [10072.399470]  [<ffffffffa04ef931>]=
 iwl_mvm_send_cmd_pdu+0x41/0x50 [iwlmvm]
May 16 14:39:43 brian-laptop kernel: [10072.399480]  [<ffffffffa04edc98>]=
 iwl_mvm_mac_ctxt_send_cmd+0x28/0x60 [iwlmvm]
May 16 14:39:43 brian-laptop kernel: [10072.399489]  [<ffffffffa04eebc8>]=
 iwl_mvm_mac_ctxt_cmd_station+0xd8/0x140 [iwlmvm]
May 16 14:39:43 brian-laptop kernel: [10072.399499]  [<ffffffffa04eed9e>]=
 iwl_mvm_mac_ctx_send+0x4e/0xa0 [iwlmvm]
May 16 14:39:43 brian-laptop kernel: [10072.399509]  [<ffffffffa04ef58c>]=
 iwl_mvm_mac_ctxt_changed+0x1c/0x80 [iwlmvm]
May 16 14:39:43 brian-laptop kernel: [10072.399518]  [<ffffffffa04eb71b>]=
 iwl_mvm_bss_info_changed+0xcb/0x420 [iwlmvm]
May 16 14:39:43 brian-laptop kernel: [10072.399538]  [<ffffffffa062b457>]=
 ieee80211_ifa_changed+0x127/0x220 [mac80211]
May 16 14:39:43 brian-laptop kernel: [10072.399545]  [<ffffffff81721fbc>]=
 notifier_call_chain+0x4c/0x70
May 16 14:39:43 brian-laptop kernel: [10072.399556]  [<ffffffff8108fd1d>]=
 __blocking_notifier_call_chain+0x4d/0x70
May 16 14:39:43 brian-laptop kernel: [10072.399563]  [<ffffffff8108fd56>]=
 blocking_notifier_call_chain+0x16/0x20
May 16 14:39:43 brian-laptop kernel: [10072.399571]  [<ffffffff81684c94>]=
 __inet_del_ifa+0x154/0x2b0
May 16 14:39:43 brian-laptop kernel: [10072.399577]  [<ffffffff81684f02>]=
 inet_rtm_deladdr+0x112/0x170
May 16 14:39:43 brian-laptop kernel: [10072.399585]  [<ffffffff81629539>]=
 rtnetlink_rcv_msg+0x99/0x260
May 16 14:39:43 brian-laptop kernel: [10072.399595]  [<ffffffff811a2778>]=
 ? __kmalloc_node_track_caller+0x58/0x1e0
May 16 14:39:43 brian-laptop kernel: [10072.399602]  [<ffffffff8160b45e>]=
 ? __alloc_skb+0x7e/0x2b0
May 16 14:39:43 brian-laptop kernel: [10072.399608]  [<ffffffff816294a0>]=
 ? rtnetlink_rcv+0x30/0x30
May 16 14:39:43 brian-laptop kernel: [10072.399615]  [<ffffffff81647a89>]=
 netlink_rcv_skb+0xa9/0xc0
May 16 14:39:43 brian-laptop kernel: [10072.399621]  [<ffffffff81629498>]=
 rtnetlink_rcv+0x28/0x30
May 16 14:39:43 brian-laptop kernel: [10072.399627]  [<ffffffff816470b5>]=
 netlink_unicast+0xd5/0x1b0
May 16 14:39:43 brian-laptop kernel: [10072.399633]  [<ffffffff8164748f>]=
 netlink_sendmsg+0x2ff/0x740
May 16 14:39:43 brian-laptop kernel: [10072.399641]  [<ffffffff8160254b>]=
 sock_sendmsg+0x8b/0xc0
May 16 14:39:43 brian-laptop kernel: [10072.399648]  [<ffffffff81721aa4>]=
 ? __do_page_fault+0x204/0x560
May 16 14:39:43 brian-laptop kernel: [10072.399655]  [<ffffffff816026f1>]=
 SYSC_sendto+0x121/0x1c0
May 16 14:39:43 brian-laptop kernel: [10072.399661]  [<ffffffff8109dd84>]=
 ? vtime_account_user+0x54/0x60
May 16 14:39:43 brian-laptop kernel: [10072.399670]  [<ffffffff81020d35>]=
 ? syscall_trace_enter+0x145/0x250
May 16 14:39:43 brian-laptop kernel: [10072.399678]  [<ffffffff816031fe>]=
 SyS_sendto+0xe/0x10
May 16 14:39:43 brian-laptop kernel: [10072.399685]  [<ffffffff817266bf>]=
 tracesys+0xe1/0xe6
May 16 14:39:43 brian-laptop kernel: [10072.399689] ---[ end trace 6e41db=
04d0be7021 ]---
May 16 14:39:43 brian-laptop kernel: [10072.399728] iwlwifi 0000:01:00.0:=
 Start IWL Error Log Dump:
May 16 14:39:43 brian-laptop kernel: [10072.399747] iwlwifi 0000:01:00.0:=
 Status: 0x00000000, count: -1
May 16 14:39:43 brian-laptop kernel: [10072.399761] iwlwifi 0000:01:00.0:=
 Loaded firmware version: 22.24.8.0
May 16 14:39:43 brian-laptop kernel: [10072.399775] iwlwifi 0000:01:00.0:=
 0xA019933D | ADVANCED_SYSASSERT         =20
May 16 14:39:43 brian-laptop kernel: [10072.399788] iwlwifi 0000:01:00.0:=
 0xFFFFFFFF | uPc
May 16 14:39:43 brian-laptop kernel: [10072.399801] iwlwifi 0000:01:00.0:=
 0x034B3728 | branchlink1
May 16 14:39:43 brian-laptop kernel: [10072.399814] iwlwifi 0000:01:00.0:=
 0xFFFF8802 | branchlink2
May 16 14:39:43 brian-laptop kernel: [10072.399827] iwlwifi 0000:01:00.0:=
 0x00000010 | interruptlink1
May 16 14:39:43 brian-laptop kernel: [10072.399839] iwlwifi 0000:01:00.0:=
 0xFFFF8802 | interruptlink2
May 16 14:39:43 brian-laptop kernel: [10072.399852] iwlwifi 0000:01:00.0:=
 0x034B3780 | data1
May 16 14:39:43 brian-laptop kernel: [10072.399865] iwlwifi 0000:01:00.0:=
 0xFFFF8802 | data2
May 16 14:39:43 brian-laptop kernel: [10072.399877] iwlwifi 0000:01:00.0:=
 0x034B3740 | data3
May 16 14:39:43 brian-laptop kernel: [10072.399890] iwlwifi 0000:01:00.0:=
 0xFFFF8802 | beacon time
May 16 14:39:43 brian-laptop kernel: [10072.399903] iwlwifi 0000:01:00.0:=
 0x813697AA | tsf low
May 16 14:39:43 brian-laptop kernel: [10072.399914] iwlwifi 0000:01:00.0:=
 0xFFFFFFFF | tsf hi
May 16 14:39:43 brian-laptop kernel: [10072.399919] iwlwifi 0000:01:00.0:=
 0x00000005 | time gp1
May 16 14:39:43 brian-laptop kernel: [10072.399923] iwlwifi 0000:01:00.0:=
 0x00000000 | time gp2
May 16 14:39:43 brian-laptop kernel: [10072.399927] iwlwifi 0000:01:00.0:=
 0x034B3780 | time gp3
May 16 14:39:43 brian-laptop kernel: [10072.399930] iwlwifi 0000:01:00.0:=
 0xFFFF8802 | uCode version
May 16 14:39:43 brian-laptop kernel: [10072.399934] iwlwifi 0000:01:00.0:=
 0xA019BA30 | hw version
May 16 14:39:43 brian-laptop kernel: [10072.399938] iwlwifi 0000:01:00.0:=
 0xFFFFFFFF | board version
May 16 14:39:43 brian-laptop kernel: [10072.399942] iwlwifi 0000:01:00.0:=
 0x00000000 | hcmd
May 16 14:39:43 brian-laptop kernel: [10072.399945] iwlwifi 0000:01:00.0:=
 0xA019B8E0 | isr0
May 16 14:39:43 brian-laptop kernel: [10072.399949] iwlwifi 0000:01:00.0:=
 0xFFFFFFFF | isr1
May 16 14:39:43 brian-laptop kernel: [10072.399953] iwlwifi 0000:01:00.0:=
 0x034B3780 | isr2
May 16 14:39:43 brian-laptop kernel: [10072.399957] iwlwifi 0000:01:00.0:=
 0xFFFF8802 | isr3
May 16 14:39:43 brian-laptop kernel: [10072.399960] iwlwifi 0000:01:00.0:=
 0x00000028 | isr4
May 16 14:39:43 brian-laptop kernel: [10072.399964] iwlwifi 0000:01:00.0:=
 0xFFFFFFFF | isr_pref
May 16 14:39:43 brian-laptop kernel: [10072.399968] iwlwifi 0000:01:00.0:=
 0x034B37F8 | wait_event
May 16 14:39:43 brian-laptop kernel: [10072.399972] iwlwifi 0000:01:00.0:=
 0xFFFF8802 | l2p_control
May 16 14:39:43 brian-laptop kernel: [10072.399976] iwlwifi 0000:01:00.0:=
 0x034B3798 | l2p_duration
May 16 14:39:43 brian-laptop kernel: [10072.399979] iwlwifi 0000:01:00.0:=
 0xFFFF8802 | l2p_mhvalid
May 16 14:39:43 brian-laptop kernel: [10072.399983] iwlwifi 0000:01:00.0:=
 0x034B37F8 | l2p_addr_match
May 16 14:39:43 brian-laptop kernel: [10072.399987] iwlwifi 0000:01:00.0:=
 0xFFFF8802 | lmpm_pmg_sel
May 16 14:39:43 brian-laptop kernel: [10072.399991] iwlwifi 0000:01:00.0:=
 0x034B37A8 | timestamp
May 16 14:39:43 brian-laptop kernel: [10072.399995] iwlwifi 0000:01:00.0:=
 0xFFFF8802 | flow_handler
May 16 14:39:50 brian-laptop kernel: [10072.417728] ieee80211 phy0: Hardw=
are restart was requested
May 16 14:39:50 brian-laptop kernel: [10072.417743] iwlwifi 0000:01:00.0:=
 Failed to send MAC context (action:2): -110
May 16 14:39:50 brian-laptop kernel: [10072.417752] iwlwifi 0000:01:00.0:=
 failed to update MAC 5c:51:4f:63:1e:10
May 16 14:39:50 brian-laptop kernel: [10074.205359] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 0 [0x5a5a5a5a]
May 16 14:39:50 brian-laptop kernel: [10076.010116] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 2 [0x5a5a5a5a]
May 16 14:39:50 brian-laptop kernel: [10077.849589] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 5 [0x5a5a5a5a]
May 16 14:39:50 brian-laptop kernel: [10079.654371] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 7 [0x5a5a5a5a]
May 16 14:39:52 brian-laptop kernel: [10081.425084] iwlwifi 0000:01:00.0:=
 L1 Disabled; Enabling L0S
May 16 14:39:52 brian-laptop kernel: [10081.442439] [sched_delayed] sched=
: RT throttling activated
May 16 14:39:52 brian-laptop kernel: [10081.563925] iwlwifi 0000:01:00.0:=
 L1 Disabled; Enabling L0S
May 16 14:40:05 brian-laptop kernel: [10087.363744] iwlwifi 0000:01:00.0:=
 Failed to load firmware chunk!
May 16 14:40:05 brian-laptop kernel: [10087.363749] iwlwifi 0000:01:00.0:=
 Could not load the [0] uCode section
May 16 14:40:05 brian-laptop kernel: [10087.363755] iwlwifi 0000:01:00.0:=
 Failed to start RT ucode: -110
May 16 14:40:05 brian-laptop kernel: [10089.167825] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 0 [0x5a5a5a5a]
May 16 14:40:05 brian-laptop kernel: [10090.985080] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 2 [0x5a5a5a5a]
May 16 14:40:05 brian-laptop kernel: [10092.862405] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 5 [0x5a5a5a5a]
May 16 14:40:05 brian-laptop kernel: [10094.702150] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 7 [0x5a5a5a5a]
May 16 14:40:05 brian-laptop kernel: [10094.702236] psmouse serio1: Touch=
Pad at isa0060/serio1/input0 lost synchronization, throwing 5 bytes away.=

May 16 14:40:07 brian-laptop avahi-daemon[491]: Interface wlan0.IPv4 no l=
onger relevant for mDNS.
May 16 14:40:07 brian-laptop kernel: [10096.516208] wlan0: deauthenticati=
ng from 00:22:6b:54:68:d2 by local choice (reason=3D3)
May 16 14:40:07 brian-laptop kernel: [10096.516223] iwlwifi 0000:01:00.0:=
 iwl_trans_send_cmd bad state =3D 0
May 16 14:40:07 brian-laptop kernel: [10096.516225] iwlwifi 0000:01:00.0:=
 Failed to send flush command (-5)
May 16 14:40:07 brian-laptop kernel: [10096.516227] iwlwifi 0000:01:00.0:=
 Couldn't flush the AGG queue
May 16 14:40:07 brian-laptop kernel: [10096.516228] iwlwifi 0000:01:00.0:=
 iwl_trans_txq_disable bad state =3D 0
May 16 14:40:07 brian-laptop kernel: [10096.550971] iwlwifi 0000:01:00.0:=
 iwl_trans_send_cmd bad state =3D 0
May 16 14:40:07 brian-laptop kernel: [10096.550975] wlan0: HW problem - c=
an not stop rx aggregation for 00:22:6b:54:68:d2 tid 0
May 16 14:40:07 brian-laptop kernel: [10096.550978] iwlwifi 0000:01:00.0:=
 iwl_trans_send_cmd bad state =3D 0
May 16 14:40:07 brian-laptop kernel: [10096.550979] wlan0: HW problem - c=
an not stop rx aggregation for 00:22:6b:54:68:d2 tid 4
May 16 14:40:07 brian-laptop kernel: [10096.550998] iwlwifi 0000:01:00.0:=
 offset 0 not used in fw key table.
May 16 14:40:07 brian-laptop kernel: [10096.551000] wlan0: failed to remo=
ve key (0, 00:22:6b:54:68:d2) from hardware (-2)
May 16 14:40:07 brian-laptop kernel: [10096.551035] ------------[ cut her=
e ]------------
May 16 14:40:07 brian-laptop kernel: [10096.551041] WARNING: CPU: 1 PID: =
5153 at /build/buildd/linux-3.13.0/drivers/net/wireless/iwlwifi/mvm/mac80=
211.c:1145 iwl_mvm_mac_sta_state+0x27c/0x290 [iwlmvm]()
May 16 14:40:07 brian-laptop kernel: [10096.551042] Modules linked in: iw=
lmvm mac80211 iwlwifi cfg80211 hid_sensor_accel_3d hid_sensor_gyro_3d hid=
_sensor_als hid_sensor_magn_3d hid_sensor_trigger industrialio_triggered_=
buffer kfifo_buf industrialio hid_sensor_iio_common hid_multitouch hid_se=
nsor_hub uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core video=
dev usbhid hid btusb ctr ccm snd_hda_codec_hdmi snd_hda_codec_realtek joy=
dev arc4 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_page_alloc snd=
_seq_midi snd_seq_midi_event intel_rapl x86_pkg_temp_thermal intel_powerc=
lamp coretemp snd_rawmidi kvm crct10dif_pclmul snd_seq crc32_pclmul ghash=
_clmulni_intel snd_seq_device snd_timer aesni_intel snd aes_x86_64 lrw gf=
128mul glue_helper ablk_helper cryptd i915 psmouse serio_raw drm_kms_help=
er lpc_ich drm mei_me mei soundcore i2c_algo_bit rfcomm bnep bluetooth nl=
s_iso8859_1 parport_pc ppdev video intel_smartconnect lp parport mac_hid =
ahci libahci [last unloaded: cfg80211]
May 16 14:40:07 brian-laptop kernel: [10096.551106] CPU: 1 PID: 5153 Comm=
: ip Tainted: G        W    3.13.0-24-generic #47-Ubuntu
May 16 14:40:07 brian-laptop kernel: [10096.551108] Hardware name: LENOVO=
 20266/Yoga2, BIOS 76CN27WW 09/17/2013
May 16 14:40:07 brian-laptop kernel: [10096.551109]  0000000000000009 fff=
f8802036493b0 ffffffff81715ac4 0000000000000000
May 16 14:40:07 brian-laptop kernel: [10096.551113]  ffff8802036493e8 fff=
fffff810676bd ffff8800815c77c0 0000000000000004
May 16 14:40:07 brian-laptop kernel: [10096.551115]  0000000000000003 fff=
f8800815d72b8 ffff8802524a2000 ffff8802036493f8
May 16 14:40:07 brian-laptop kernel: [10096.551117] Call Trace:
May 16 14:40:07 brian-laptop kernel: [10096.551122]  [<ffffffff81715ac4>]=
 dump_stack+0x45/0x56
May 16 14:40:07 brian-laptop kernel: [10096.551133]  [<ffffffff810676bd>]=
 warn_slowpath_common+0x7d/0xa0
May 16 14:40:07 brian-laptop kernel: [10096.551136]  [<ffffffff8106779a>]=
 warn_slowpath_null+0x1a/0x20
May 16 14:40:07 brian-laptop kernel: [10096.551140]  [<ffffffffa04ea93c>]=
 iwl_mvm_mac_sta_state+0x27c/0x290 [iwlmvm]
May 16 14:40:07 brian-laptop kernel: [10096.551150]  [<ffffffffa062f2ff>]=
 sta_info_move_state+0x1bf/0x680 [mac80211]
May 16 13:52:12 brian-laptop wpa_supplicant[2935]: message repeated 2 tim=
es: [ wlan0: WPA: Group rekeying completed with 00:22:6b:54:68:d2 [GTK=3D=
TKIP]]
May 16 14:40:07 brian-laptop wpa_supplicant[2935]: wlan0: CTRL-EVENT-DISC=
ONNECTED bssid=3D00:22:6b:54:68:d2 reason=3D3 locally_generated=3D1
May 16 14:40:07 brian-laptop kernel: [10096.551159]  [<ffffffffa062f8bb>]=
 __sta_info_destroy+0xfb/0x360 [mac80211]
May 16 14:40:07 brian-laptop kernel: [10096.551164]  [<ffffffffa062fc65>]=
 sta_info_flush_defer+0x85/0xb0 [mac80211]
May 16 14:40:07 brian-laptop kernel: [10096.551174]  [<ffffffffa066c600>]=
 ieee80211_set_disassoc+0xb0/0x3d0 [mac80211]
May 16 14:40:07 brian-laptop kernel: [10096.551183]  [<ffffffffa0670903>]=
 ieee80211_mgd_deauth+0x1d3/0x240 [mac80211]
May 16 14:40:07 brian-laptop kernel: [10096.551190]  [<ffffffffa0642c38>]=
 ieee80211_deauth+0x18/0x20 [mac80211]
May 16 14:40:07 brian-laptop kernel: [10096.551202]  [<ffffffffa03b795c>]=
 cfg80211_mlme_deauth+0x9c/0x140 [cfg80211]
May 16 14:40:07 brian-laptop kernel: [10096.551208]  [<ffffffffa03b7c0b>]=
 cfg80211_mlme_down+0x6b/0x90 [cfg80211]
May 16 14:40:07 brian-laptop kernel: [10096.551214]  [<ffffffffa03bb94b>]=
 cfg80211_disconnect+0x18b/0x1b0 [cfg80211]
May 16 14:40:07 brian-laptop kernel: [10096.551221]  [<ffffffffa039f77c>]=
 ? __cfg80211_stop_sched_scan+0x1c/0x130 [cfg80211]
May 16 14:40:07 brian-laptop kernel: [10096.551228]  [<ffffffffa0396a84>]=
 cfg80211_leave+0xc4/0xe0 [cfg80211]
May 16 14:40:07 brian-laptop kernel: [10096.551234]  [<ffffffffa0396e3b>]=
 cfg80211_netdev_notifier_call+0x39b/0x610 [cfg80211]
May 16 14:40:07 brian-laptop kernel: [10096.551238]  [<ffffffff816861c8>]=
 ? inetdev_event+0x38/0x510
May 16 14:40:07 brian-laptop kernel: [10096.551241]  [<ffffffff81721fbc>]=
 notifier_call_chain+0x4c/0x70
May 16 14:40:07 brian-laptop kernel: [10096.551245]  [<ffffffff8108fb46>]=
 raw_notifier_call_chain+0x16/0x20
May 16 14:40:07 brian-laptop kernel: [10096.551248]  [<ffffffff81616395>]=
 call_netdevice_notifiers_info+0x35/0x60
May 16 14:40:07 brian-laptop kernel: [10096.551250]  [<ffffffff81616489>]=
 __dev_close_many+0x49/0xe0
May 16 14:40:07 brian-laptop kernel: [10096.551253]  [<ffffffff8161656d>]=
 __dev_close+0x4d/0x90
May 16 14:40:07 brian-laptop kernel: [10096.551256]  [<ffffffff8161db8d>]=
 __dev_change_flags+0x9d/0x170
May 16 14:40:07 brian-laptop kernel: [10096.551258]  [<ffffffff8161dc89>]=
 dev_change_flags+0x29/0x60
May 16 14:40:07 brian-laptop kernel: [10096.551261]  [<ffffffff8162b782>]=
 do_setlink+0x312/0x9e0
May 16 14:40:07 brian-laptop kernel: [10096.551265]  [<ffffffff81384ea2>]=
 ? nla_parse+0x32/0xe0
May 16 14:40:07 brian-laptop kernel: [10096.551267]  [<ffffffff8162cab4>]=
 rtnl_newlink+0x394/0x5d0
May 16 14:40:07 brian-laptop kernel: [10096.551270]  [<ffffffff81365a62>]=
 ? put_dec+0x72/0x90
May 16 14:40:07 brian-laptop kernel: [10096.551274]  [<ffffffff8130d74d>]=
 ? apparmor_capable+0x1d/0x130
May 16 14:40:07 brian-laptop kernel: [10096.551276]  [<ffffffff81629539>]=
 rtnetlink_rcv_msg+0x99/0x260
May 16 14:40:07 brian-laptop kernel: [10096.551280]  [<ffffffff811a2778>]=
 ? __kmalloc_node_track_caller+0x58/0x1e0
May 16 14:40:07 brian-laptop kernel: [10096.551283]  [<ffffffff8116c409>]=
 ? zone_statistics+0x89/0xa0
May 16 14:40:07 brian-laptop kernel: [10096.551286]  [<ffffffff8160b45e>]=
 ? __alloc_skb+0x7e/0x2b0
May 16 14:40:07 brian-laptop kernel: [10096.551288]  [<ffffffff816294a0>]=
 ? rtnetlink_rcv+0x30/0x30
May 16 14:40:07 brian-laptop kernel: [10096.551291]  [<ffffffff81647a89>]=
 netlink_rcv_skb+0xa9/0xc0
May 16 14:40:07 brian-laptop kernel: [10096.551292]  [<ffffffff81629498>]=
 rtnetlink_rcv+0x28/0x30
May 16 14:40:07 brian-laptop kernel: [10096.551294]  [<ffffffff816470b5>]=
 netlink_unicast+0xd5/0x1b0
May 16 14:40:07 brian-laptop kernel: [10096.551296]  [<ffffffff8164748f>]=
 netlink_sendmsg+0x2ff/0x740
May 16 14:40:07 brian-laptop kernel: [10096.551299]  [<ffffffff8160254b>]=
 sock_sendmsg+0x8b/0xc0
May 16 14:40:07 brian-laptop kernel: [10096.551302]  [<ffffffff811af0f6>]=
 ? __mem_cgroup_commit_charge+0x156/0x3d0
May 16 14:40:07 brian-laptop kernel: [10096.551304]  [<ffffffff8160223e>]=
 ? move_addr_to_kernel.part.16+0x1e/0x60
May 16 14:40:07 brian-laptop kernel: [10096.551307]  [<ffffffff81602df1>]=
 ? move_addr_to_kernel+0x21/0x30
May 16 14:40:07 brian-laptop kernel: [10096.551309]  [<ffffffff81602db9>]=
 ___sys_sendmsg+0x3a9/0x3c0
May 16 14:40:07 brian-laptop kernel: [10096.551311]  [<ffffffff81721aa4>]=
 ? __do_page_fault+0x204/0x560
May 16 14:40:07 brian-laptop kernel: [10096.551315]  [<ffffffff811112fc>]=
 ? acct_account_cputime+0x1c/0x20
May 16 14:40:07 brian-laptop kernel: [10096.551318]  [<ffffffff8109d76b>]=
 ? account_user_time+0x8b/0xa0
May 16 14:40:07 brian-laptop kernel: [10096.551320]  [<ffffffff816034c2>]=
 __sys_sendmsg+0x42/0x80
May 16 14:40:07 brian-laptop kernel: [10096.551322]  [<ffffffff81603512>]=
 SyS_sendmsg+0x12/0x20
May 16 14:40:07 brian-laptop kernel: [10096.551324]  [<ffffffff817266bf>]=
 tracesys+0xe1/0xe6
May 16 14:40:07 brian-laptop kernel: [10096.551326] ---[ end trace 6e41db=
04d0be7022 ]---
May 16 14:40:07 brian-laptop kernel: [10096.551327] ------------[ cut her=
e ]------------
May 16 14:40:07 brian-laptop kernel: [10096.551333] WARNING: CPU: 1 PID: =
5153 at /build/buildd/linux-3.13.0/net/mac80211/sta_info.c:856 __sta_info=
_destroy+0x1be/0x360 [mac80211]()
May 16 14:40:07 brian-laptop kernel: [10096.551333] Modules linked in: iw=
lmvm mac80211 iwlwifi cfg80211 hid_sensor_accel_3d hid_sensor_gyro_3d hid=
_sensor_als hid_sensor_magn_3d hid_sensor_trigger industrialio_triggered_=
buffer kfifo_buf industrialio hid_sensor_iio_common hid_multitouch hid_se=
nsor_hub uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core video=
dev usbhid hid btusb ctr ccm snd_hda_codec_hdmi snd_hda_codec_realtek joy=
dev arc4 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_page_alloc snd=
_seq_midi snd_seq_midi_event intel_rapl x86_pkg_temp_thermal intel_powerc=
lamp coretemp snd_rawmidi kvm crct10dif_pclmul snd_seq crc32_pclmul ghash=
_clmulni_intel snd_seq_device snd_timer aesni_intel snd aes_x86_64 lrw gf=
128mul glue_helper ablk_helper cryptd i915 psmouse serio_raw drm_kms_help=
er lpc_ich drm mei_me mei soundcore i2c_algo_bit rfcomm bnep bluetooth nl=
s_iso8859_1 parport_pc ppdev video intel_smartconnect lp parport mac_hid =
ahci libahci [last unloaded: cfg80211]
May 16 14:40:07 brian-laptop kernel: [10096.551364] CPU: 1 PID: 5153 Comm=
: ip Tainted: G        W    3.13.0-24-generic #47-Ubuntu
May 16 14:40:07 brian-laptop kernel: [10096.551365] Hardware name: LENOVO=
 20266/Yoga2, BIOS 76CN27WW 09/17/2013
May 16 14:40:07 brian-laptop kernel: [10096.551365]  0000000000000009 fff=
f880203649458 ffffffff81715ac4 0000000000000000
May 16 14:40:07 brian-laptop kernel: [10096.551367]  ffff880203649490 fff=
fffff810676bd ffff8800815c6600 ffff8800815d6880
May 16 14:40:07 brian-laptop kernel: [10096.551369]  ffff8800815c6820 fff=
f8800815c6858 ffff8802524a2000 ffff8802036494a0
May 16 14:40:07 brian-laptop kernel: [10096.551372] Call Trace:
May 16 14:40:07 brian-laptop kernel: [10096.551374]  [<ffffffff81715ac4>]=
 dump_stack+0x45/0x56
May 16 14:40:07 brian-laptop kernel: [10096.551376]  [<ffffffff810676bd>]=
 warn_slowpath_common+0x7d/0xa0
May 16 14:40:07 brian-laptop kernel: [10096.551377]  [<ffffffff8106779a>]=
 warn_slowpath_null+0x1a/0x20
May 16 14:40:07 brian-laptop kernel: [10096.551383]  [<ffffffffa062f97e>]=
 __sta_info_destroy+0x1be/0x360 [mac80211]
May 16 14:40:07 brian-laptop kernel: [10096.551388]  [<ffffffffa062fc65>]=
 sta_info_flush_defer+0x85/0xb0 [mac80211]
May 16 14:40:07 brian-laptop kernel: [10096.551397]  [<ffffffffa066c600>]=
 ieee80211_set_disassoc+0xb0/0x3d0 [mac80211]
May 16 14:40:07 brian-laptop kernel: [10096.551405]  [<ffffffffa0670903>]=
 ieee80211_mgd_deauth+0x1d3/0x240 [mac80211]
May 16 14:40:07 brian-laptop kernel: [10096.551412]  [<ffffffffa0642c38>]=
 ieee80211_deauth+0x18/0x20 [mac80211]
May 16 14:40:07 brian-laptop kernel: [10096.551419]  [<ffffffffa03b795c>]=
 cfg80211_mlme_deauth+0x9c/0x140 [cfg80211]
May 16 14:40:07 brian-laptop kernel: [10096.551425]  [<ffffffffa03b7c0b>]=
 cfg80211_mlme_down+0x6b/0x90 [cfg80211]
May 16 14:40:07 brian-laptop kernel: [10096.551431]  [<ffffffffa03bb94b>]=
 cfg80211_disconnect+0x18b/0x1b0 [cfg80211]
May 16 14:40:07 brian-laptop kernel: [10096.551436]  [<ffffffffa039f77c>]=
 ? __cfg80211_stop_sched_scan+0x1c/0x130 [cfg80211]
May 16 14:40:07 brian-laptop kernel: [10096.551441]  [<ffffffffa0396a84>]=
 cfg80211_leave+0xc4/0xe0 [cfg80211]
May 16 14:40:07 brian-laptop kernel: [10096.551446]  [<ffffffffa0396e3b>]=
 cfg80211_netdev_notifier_call+0x39b/0x610 [cfg80211]
May 16 14:40:07 brian-laptop kernel: [10096.551448]  [<ffffffff816861c8>]=
 ? inetdev_event+0x38/0x510
May 16 14:40:07 brian-laptop kernel: [10096.551450]  [<ffffffff81721fbc>]=
 notifier_call_chain+0x4c/0x70
May 16 14:40:07 brian-laptop kernel: [10096.551452]  [<ffffffff8108fb46>]=
 raw_notifier_call_chain+0x16/0x20
May 16 14:40:07 brian-laptop kernel: [10096.551454]  [<ffffffff81616395>]=
 call_netdevice_notifiers_info+0x35/0x60
May 16 14:40:07 brian-laptop kernel: [10096.551455]  [<ffffffff81616489>]=
 __dev_close_many+0x49/0xe0
May 16 14:40:07 brian-laptop kernel: [10096.551457]  [<ffffffff8161656d>]=
 __dev_close+0x4d/0x90
May 16 14:40:07 brian-laptop kernel: [10096.551459]  [<ffffffff8161db8d>]=
 __dev_change_flags+0x9d/0x170
May 16 14:40:07 brian-laptop kernel: [10096.551461]  [<ffffffff8161dc89>]=
 dev_change_flags+0x29/0x60
May 16 14:40:07 brian-laptop kernel: [10096.551463]  [<ffffffff8162b782>]=
 do_setlink+0x312/0x9e0
May 16 14:40:07 brian-laptop kernel: [10096.551465]  [<ffffffff81384ea2>]=
 ? nla_parse+0x32/0xe0
May 16 14:40:07 brian-laptop kernel: [10096.551467]  [<ffffffff8162cab4>]=
 rtnl_newlink+0x394/0x5d0
May 16 14:40:07 brian-laptop kernel: [10096.551470]  [<ffffffff81365a62>]=
 ? put_dec+0x72/0x90
May 16 14:40:07 brian-laptop kernel: [10096.551472]  [<ffffffff8130d74d>]=
 ? apparmor_capable+0x1d/0x130
May 16 14:40:07 brian-laptop kernel: [10096.551474]  [<ffffffff81629539>]=
 rtnetlink_rcv_msg+0x99/0x260
May 16 14:40:07 brian-laptop kernel: [10096.551476]  [<ffffffff811a2778>]=
 ? __kmalloc_node_track_caller+0x58/0x1e0
May 16 14:40:07 brian-laptop kernel: [10096.551479]  [<ffffffff8116c409>]=
 ? zone_statistics+0x89/0xa0
May 16 14:40:07 brian-laptop kernel: [10096.551481]  [<ffffffff8160b45e>]=
 ? __alloc_skb+0x7e/0x2b0
May 16 14:40:07 brian-laptop kernel: [10096.551482]  [<ffffffff816294a0>]=
 ? rtnetlink_rcv+0x30/0x30
May 16 14:40:07 brian-laptop kernel: [10096.551484]  [<ffffffff81647a89>]=
 netlink_rcv_skb+0xa9/0xc0
May 16 14:40:07 brian-laptop kernel: [10096.551486]  [<ffffffff81629498>]=
 rtnetlink_rcv+0x28/0x30
May 16 14:40:07 brian-laptop kernel: [10096.551488]  [<ffffffff816470b5>]=
 netlink_unicast+0xd5/0x1b0
May 16 14:40:07 brian-laptop kernel: [10096.551490]  [<ffffffff8164748f>]=
 netlink_sendmsg+0x2ff/0x740
May 16 14:40:07 brian-laptop kernel: [10096.551492]  [<ffffffff8160254b>]=
 sock_sendmsg+0x8b/0xc0
May 16 14:40:07 brian-laptop kernel: [10096.551494]  [<ffffffff811af0f6>]=
 ? __mem_cgroup_commit_charge+0x156/0x3d0
May 16 14:40:07 brian-laptop kernel: [10096.551497]  [<ffffffff8160223e>]=
 ? move_addr_to_kernel.part.16+0x1e/0x60
May 16 14:40:07 brian-laptop kernel: [10096.551499]  [<ffffffff81602df1>]=
 ? move_addr_to_kernel+0x21/0x30
May 16 14:40:07 brian-laptop kernel: [10096.551501]  [<ffffffff81602db9>]=
 ___sys_sendmsg+0x3a9/0x3c0
May 16 14:40:07 brian-laptop kernel: [10096.551503]  [<ffffffff81721aa4>]=
 ? __do_page_fault+0x204/0x560
May 16 14:40:07 brian-laptop kernel: [10096.551505]  [<ffffffff811112fc>]=
 ? acct_account_cputime+0x1c/0x20
May 16 14:40:07 brian-laptop kernel: [10096.551507]  [<ffffffff8109d76b>]=
 ? account_user_time+0x8b/0xa0
May 16 14:40:07 brian-laptop kernel: [10096.551509]  [<ffffffff816034c2>]=
 __sys_sendmsg+0x42/0x80
May 16 14:40:07 brian-laptop kernel: [10096.551511]  [<ffffffff81603512>]=
 SyS_sendmsg+0x12/0x20
May 16 14:40:07 brian-laptop kernel: [10096.551514]  [<ffffffff817266bf>]=
 tracesys+0xe1/0xe6
May 16 14:40:07 brian-laptop kernel: [10096.551515] ---[ end trace 6e41db=
04d0be7023 ]---
May 16 14:40:07 brian-laptop kernel: [10096.551516] ------------[ cut her=
e ]------------
May 16 14:40:07 brian-laptop kernel: [10096.551521] WARNING: CPU: 1 PID: =
5153 at /build/buildd/linux-3.13.0/net/mac80211/sta_info.c:864 __sta_info=
_destroy+0x265/0x360 [mac80211]()
May 16 14:40:07 brian-laptop kernel: [10096.551522] Modules linked in: iw=
lmvm mac80211 iwlwifi cfg80211 hid_sensor_accel_3d hid_sensor_gyro_3d hid=
_sensor_als hid_sensor_magn_3d hid_sensor_trigger industrialio_triggered_=
buffer kfifo_buf industrialio hid_sensor_iio_common hid_multitouch hid_se=
nsor_hub uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core video=
dev usbhid hid btusb ctr ccm snd_hda_codec_hdmi snd_hda_codec_realtek joy=
dev arc4 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_page_alloc snd=
_seq_midi snd_seq_midi_event intel_rapl x86_pkg_temp_thermal intel_powerc=
lamp coretemp snd_rawmidi kvm crct10dif_pclmul snd_seq crc32_pclmul ghash=
_clmulni_intel snd_seq_device snd_timer aesni_intel snd aes_x86_64 lrw gf=
128mul glue_helper ablk_helper cryptd i915 psmouse serio_raw drm_kms_help=
er lpc_ich drm mei_me mei soundcore i2c_algo_bit rfcomm bnep bluetooth nl=
s_iso8859_1 parport_pc ppdev video intel_smartconnect lp parport mac_hid =
ahci libahci [last unloaded: cfg80211]
May 16 14:40:07 brian-laptop kernel: [10096.551551] CPU: 1 PID: 5153 Comm=
: ip Tainted: G        W    3.13.0-24-generic #47-Ubuntu
May 16 14:40:07 brian-laptop kernel: [10096.551552] Hardware name: LENOVO=
 20266/Yoga2, BIOS 76CN27WW 09/17/2013
May 16 14:40:07 brian-laptop kernel: [10096.551552]  0000000000000009 fff=
f880203649458 ffffffff81715ac4 0000000000000000
May 16 14:40:07 brian-laptop kernel: [10096.551554]  ffff880203649490 fff=
fffff810676bd ffff8800815c6600 ffff8800815d6880
May 16 14:40:07 brian-laptop kernel: [10096.551556]  ffff8800815d6880 000=
00000ffffffea ffff8802524a2000 ffff8802036494a0
May 16 14:40:07 brian-laptop kernel: [10096.551558] Call Trace:
May 16 14:40:07 brian-laptop kernel: [10096.551561]  [<ffffffff81715ac4>]=
 dump_stack+0x45/0x56
May 16 14:40:07 brian-laptop kernel: [10096.551562]  [<ffffffff810676bd>]=
 warn_slowpath_common+0x7d/0xa0
May 16 14:40:07 brian-laptop kernel: [10096.551564]  [<ffffffff8106779a>]=
 warn_slowpath_null+0x1a/0x20
May 16 14:40:07 brian-laptop kernel: [10096.551570]  [<ffffffffa062fa25>]=
 __sta_info_destroy+0x265/0x360 [mac80211]
May 16 14:40:07 brian-laptop kernel: [10096.551575]  [<ffffffffa062fc65>]=
 sta_info_flush_defer+0x85/0xb0 [mac80211]
May 16 14:40:07 brian-laptop kernel: [10096.551583]  [<ffffffffa066c600>]=
 ieee80211_set_disassoc+0xb0/0x3d0 [mac80211]
May 16 14:40:07 brian-laptop kernel: [10096.551590]  [<ffffffffa0670903>]=
 ieee80211_mgd_deauth+0x1d3/0x240 [mac80211]
May 16 14:40:07 brian-laptop kernel: [10096.551597]  [<ffffffffa0642c38>]=
 ieee80211_deauth+0x18/0x20 [mac80211]
May 16 14:40:07 brian-laptop kernel: [10096.551603]  [<ffffffffa03b795c>]=
 cfg80211_mlme_deauth+0x9c/0x140 [cfg80211]
May 16 14:40:07 brian-laptop kernel: [10096.551609]  [<ffffffffa03b7c0b>]=
 cfg80211_mlme_down+0x6b/0x90 [cfg80211]
May 16 14:40:07 brian-laptop kernel: [10096.551615]  [<ffffffffa03bb94b>]=
 cfg80211_disconnect+0x18b/0x1b0 [cfg80211]
May 16 14:40:07 brian-laptop kernel: [10096.551621]  [<ffffffffa039f77c>]=
 ? __cfg80211_stop_sched_scan+0x1c/0x130 [cfg80211]
May 16 14:40:07 brian-laptop kernel: [10096.551626]  [<ffffffffa0396a84>]=
 cfg80211_leave+0xc4/0xe0 [cfg80211]
May 16 14:40:07 brian-laptop kernel: [10096.551630]  [<ffffffffa0396e3b>]=
 cfg80211_netdev_notifier_call+0x39b/0x610 [cfg80211]
May 16 14:40:07 brian-laptop kernel: [10096.551632]  [<ffffffff816861c8>]=
 ? inetdev_event+0x38/0x510
May 16 14:40:07 brian-laptop kernel: [10096.551634]  [<ffffffff81721fbc>]=
 notifier_call_chain+0x4c/0x70
May 16 14:40:07 brian-laptop kernel: [10096.551636]  [<ffffffff8108fb46>]=
 raw_notifier_call_chain+0x16/0x20
May 16 14:40:07 brian-laptop kernel: [10096.551638]  [<ffffffff81616395>]=
 call_netdevice_notifiers_info+0x35/0x60
May 16 14:40:07 brian-laptop kernel: [10096.551640]  [<ffffffff81616489>]=
 __dev_close_many+0x49/0xe0
May 16 14:40:07 brian-laptop kernel: [10096.551641]  [<ffffffff8161656d>]=
 __dev_close+0x4d/0x90
May 16 14:40:07 brian-laptop kernel: [10096.551643]  [<ffffffff8161db8d>]=
 __dev_change_flags+0x9d/0x170
May 16 14:40:07 brian-laptop kernel: [10096.551645]  [<ffffffff8161dc89>]=
 dev_change_flags+0x29/0x60
May 16 14:40:07 brian-laptop kernel: [10096.551647]  [<ffffffff8162b782>]=
 do_setlink+0x312/0x9e0
May 16 14:40:07 brian-laptop kernel: [10096.551649]  [<ffffffff81384ea2>]=
 ? nla_parse+0x32/0xe0
May 16 14:40:07 brian-laptop kernel: [10096.551651]  [<ffffffff8162cab4>]=
 rtnl_newlink+0x394/0x5d0
May 16 14:40:07 brian-laptop kernel: [10096.551654]  [<ffffffff81365a62>]=
 ? put_dec+0x72/0x90
May 16 14:40:07 brian-laptop kernel: [10096.551656]  [<ffffffff8130d74d>]=
 ? apparmor_capable+0x1d/0x130
May 16 14:40:07 brian-laptop kernel: [10096.551658]  [<ffffffff81629539>]=
 rtnetlink_rcv_msg+0x99/0x260
May 16 14:40:07 brian-laptop kernel: [10096.551660]  [<ffffffff811a2778>]=
 ? __kmalloc_node_track_caller+0x58/0x1e0
May 16 14:40:07 brian-laptop kernel: [10096.551663]  [<ffffffff8116c409>]=
 ? zone_statistics+0x89/0xa0
May 16 14:40:07 brian-laptop kernel: [10096.551664]  [<ffffffff8160b45e>]=
 ? __alloc_skb+0x7e/0x2b0
May 16 14:40:07 brian-laptop kernel: [10096.551666]  [<ffffffff816294a0>]=
 ? rtnetlink_rcv+0x30/0x30
May 16 14:40:07 brian-laptop kernel: [10096.551668]  [<ffffffff81647a89>]=
 netlink_rcv_skb+0xa9/0xc0
May 16 14:40:07 brian-laptop kernel: [10096.551670]  [<ffffffff81629498>]=
 rtnetlink_rcv+0x28/0x30
May 16 14:40:07 brian-laptop kernel: [10096.551671]  [<ffffffff816470b5>]=
 netlink_unicast+0xd5/0x1b0
May 16 14:40:07 brian-laptop kernel: [10096.551673]  [<ffffffff8164748f>]=
 netlink_sendmsg+0x2ff/0x740
May 16 14:40:07 brian-laptop kernel: [10096.551675]  [<ffffffff8160254b>]=
 sock_sendmsg+0x8b/0xc0
May 16 14:40:07 brian-laptop kernel: [10096.551678]  [<ffffffff811af0f6>]=
 ? __mem_cgroup_commit_charge+0x156/0x3d0
May 16 14:40:07 brian-laptop kernel: [10096.551680]  [<ffffffff8160223e>]=
 ? move_addr_to_kernel.part.16+0x1e/0x60
May 16 14:40:07 brian-laptop kernel: [10096.551682]  [<ffffffff81602df1>]=
 ? move_addr_to_kernel+0x21/0x30
May 16 14:40:07 brian-laptop kernel: [10096.551684]  [<ffffffff81602db9>]=
 ___sys_sendmsg+0x3a9/0x3c0
May 16 14:40:07 brian-laptop kernel: [10096.551686]  [<ffffffff81721aa4>]=
 ? __do_page_fault+0x204/0x560
May 16 14:40:07 brian-laptop kernel: [10096.551688]  [<ffffffff811112fc>]=
 ? acct_account_cputime+0x1c/0x20
May 16 14:40:07 brian-laptop kernel: [10096.551690]  [<ffffffff8109d76b>]=
 ? account_user_time+0x8b/0xa0
May 16 14:40:07 brian-laptop kernel: [10096.551692]  [<ffffffff816034c2>]=
 __sys_sendmsg+0x42/0x80
May 16 14:40:07 brian-laptop kernel: [10096.551694]  [<ffffffff81603512>]=
 SyS_sendmsg+0x12/0x20
May 16 14:40:07 brian-laptop kernel: [10096.551696]  [<ffffffff817266bf>]=
 tracesys+0xe1/0xe6
May 16 14:40:07 brian-laptop kernel: [10096.551698] ---[ end trace 6e41db=
04d0be7024 ]---
May 16 14:40:07 brian-laptop kernel: [10096.551740] ------------[ cut her=
e ]------------
May 16 14:40:07 brian-laptop kernel: [10096.551745] WARNING: CPU: 1 PID: =
5153 at /build/buildd/linux-3.13.0/drivers/net/wireless/iwlwifi/mvm/mac-c=
txt.c:1097 iwl_mvm_mac_ctxt_changed+0x6e/0x80 [iwlmvm]()
May 16 14:40:07 brian-laptop kernel: [10096.551746] Changing inactive MAC=
 5c:51:4f:63:1e:10/2
May 16 14:40:07 brian-laptop kernel: [10096.551747] Modules linked in: iw=
lmvm mac80211 iwlwifi cfg80211 hid_sensor_accel_3d hid_sensor_gyro_3d hid=
_sensor_als hid_sensor_magn_3d hid_sensor_trigger industrialio_triggered_=
buffer kfifo_buf industrialio hid_sensor_iio_common hid_multitouch hid_se=
nsor_hub uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core video=
dev usbhid hid btusb ctr ccm snd_hda_codec_hdmi snd_hda_codec_realtek joy=
dev arc4 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_page_alloc snd=
_seq_midi snd_seq_midi_event intel_rapl x86_pkg_temp_thermal intel_powerc=
lamp coretemp snd_rawmidi kvm crct10dif_pclmul snd_seq crc32_pclmul ghash=
_clmulni_intel snd_seq_device snd_timer aesni_intel snd aes_x86_64 lrw gf=
128mul glue_helper ablk_helper cryptd i915 psmouse serio_raw drm_kms_help=
er lpc_ich drm mei_me mei soundcore i2c_algo_bit rfcomm bnep bluetooth nl=
s_iso8859_1 parport_pc ppdev video intel_smartconnect lp parport mac_hid =
ahci libahci [last unloaded: cfg80211]
May 16 14:40:07 brian-laptop kernel: [10096.551776] CPU: 1 PID: 5153 Comm=
: ip Tainted: G        W    3.13.0-24-generic #47-Ubuntu
May 16 14:40:07 brian-laptop kernel: [10096.551777] Hardware name: LENOVO=
 20266/Yoga2, BIOS 76CN27WW 09/17/2013
May 16 14:40:07 brian-laptop kernel: [10096.551777]  0000000000000009 fff=
f8802036493e0 ffffffff81715ac4 ffff880203649428
May 16 14:40:07 brian-laptop kernel: [10096.551779]  ffff880203649418 fff=
fffff810676bd ffff8800815c77c0 ffff8800815d72b8
May 16 14:40:07 brian-laptop kernel: [10096.551781]  ffff8800815c7800 000=
000000000209f ffff8800815c77d0 ffff880203649478
May 16 14:40:07 brian-laptop kernel: [10096.551783] Call Trace:
May 16 14:40:07 brian-laptop kernel: [10096.551786]  [<ffffffff81715ac4>]=
 dump_stack+0x45/0x56
May 16 14:40:07 brian-laptop kernel: [10096.551787]  [<ffffffff810676bd>]=
 warn_slowpath_common+0x7d/0xa0
May 16 14:40:07 brian-laptop kernel: [10096.551789]  [<ffffffff8106772c>]=
 warn_slowpath_fmt+0x4c/0x50
May 16 14:40:07 brian-laptop kernel: [10096.551792]  [<ffffffffa04ef5de>]=
 iwl_mvm_mac_ctxt_changed+0x6e/0x80 [iwlmvm]
May 16 14:40:07 brian-laptop kernel: [10096.551795]  [<ffffffffa04eb71b>]=
 iwl_mvm_bss_info_changed+0xcb/0x420 [iwlmvm]
May 16 14:40:07 brian-laptop kernel: [10096.551801]  [<ffffffffa062bbf7>]=
 ieee80211_bss_info_change_notify+0x97/0x1c0 [mac80211]
May 16 14:40:07 brian-laptop kernel: [10096.551809]  [<ffffffffa066c74f>]=
 ieee80211_set_disassoc+0x1ff/0x3d0 [mac80211]
May 16 14:40:07 brian-laptop kernel: [10096.551817]  [<ffffffffa0670903>]=
 ieee80211_mgd_deauth+0x1d3/0x240 [mac80211]
May 16 14:40:07 brian-laptop kernel: [10096.551824]  [<ffffffffa0642c38>]=
 ieee80211_deauth+0x18/0x20 [mac80211]
May 16 14:40:07 brian-laptop kernel: [10096.551830]  [<ffffffffa03b795c>]=
 cfg80211_mlme_deauth+0x9c/0x140 [cfg80211]
May 16 14:40:07 brian-laptop kernel: [10096.551836]  [<ffffffffa03b7c0b>]=
 cfg80211_mlme_down+0x6b/0x90 [cfg80211]
May 16 14:40:07 brian-laptop kernel: [10096.551842]  [<ffffffffa03bb94b>]=
 cfg80211_disconnect+0x18b/0x1b0 [cfg80211]
May 16 14:40:07 brian-laptop kernel: [10096.551848]  [<ffffffffa039f77c>]=
 ? __cfg80211_stop_sched_scan+0x1c/0x130 [cfg80211]
May 16 14:40:07 brian-laptop kernel: [10096.551853]  [<ffffffffa0396a84>]=
 cfg80211_leave+0xc4/0xe0 [cfg80211]
May 16 14:40:07 brian-laptop kernel: [10096.551857]  [<ffffffffa0396e3b>]=
 cfg80211_netdev_notifier_call+0x39b/0x610 [cfg80211]
May 16 14:40:07 brian-laptop kernel: [10096.551859]  [<ffffffff816861c8>]=
 ? inetdev_event+0x38/0x510
May 16 14:40:07 brian-laptop kernel: [10096.551861]  [<ffffffff81721fbc>]=
 notifier_call_chain+0x4c/0x70
May 16 14:40:07 brian-laptop kernel: [10096.551863]  [<ffffffff8108fb46>]=
 raw_notifier_call_chain+0x16/0x20
May 16 14:40:07 brian-laptop kernel: [10096.551865]  [<ffffffff81616395>]=
 call_netdevice_notifiers_info+0x35/0x60
May 16 14:40:07 brian-laptop kernel: [10096.551866]  [<ffffffff81616489>]=
 __dev_close_many+0x49/0xe0
May 16 14:40:07 brian-laptop kernel: [10096.551868]  [<ffffffff8161656d>]=
 __dev_close+0x4d/0x90
May 16 14:40:07 brian-laptop kernel: [10096.551870]  [<ffffffff8161db8d>]=
 __dev_change_flags+0x9d/0x170
May 16 14:40:07 brian-laptop kernel: [10096.551872]  [<ffffffff8161dc89>]=
 dev_change_flags+0x29/0x60
May 16 14:40:07 brian-laptop kernel: [10096.551874]  [<ffffffff8162b782>]=
 do_setlink+0x312/0x9e0
May 16 14:40:07 brian-laptop kernel: [10096.551876]  [<ffffffff81384ea2>]=
 ? nla_parse+0x32/0xe0
May 16 14:40:07 brian-laptop kernel: [10096.551878]  [<ffffffff8162cab4>]=
 rtnl_newlink+0x394/0x5d0
May 16 14:40:07 brian-laptop kernel: [10096.551881]  [<ffffffff81365a62>]=
 ? put_dec+0x72/0x90
May 16 14:40:07 brian-laptop kernel: [10096.551883]  [<ffffffff8130d74d>]=
 ? apparmor_capable+0x1d/0x130
May 16 14:40:07 brian-laptop kernel: [10096.551885]  [<ffffffff81629539>]=
 rtnetlink_rcv_msg+0x99/0x260
May 16 14:40:07 brian-laptop kernel: [10096.551887]  [<ffffffff811a2778>]=
 ? __kmalloc_node_track_caller+0x58/0x1e0
May 16 14:40:07 brian-laptop kernel: [10096.551890]  [<ffffffff8116c409>]=
 ? zone_statistics+0x89/0xa0
May 16 14:40:07 brian-laptop kernel: [10096.551892]  [<ffffffff8160b45e>]=
 ? __alloc_skb+0x7e/0x2b0
May 16 14:40:07 brian-laptop kernel: [10096.551893]  [<ffffffff816294a0>]=
 ? rtnetlink_rcv+0x30/0x30
May 16 14:40:07 brian-laptop kernel: [10096.551895]  [<ffffffff81647a89>]=
 netlink_rcv_skb+0xa9/0xc0
May 16 14:40:07 brian-laptop kernel: [10096.551897]  [<ffffffff81629498>]=
 rtnetlink_rcv+0x28/0x30
May 16 14:40:07 brian-laptop kernel: [10096.551899]  [<ffffffff816470b5>]=
 netlink_unicast+0xd5/0x1b0
May 16 14:40:07 brian-laptop kernel: [10096.551900]  [<ffffffff8164748f>]=
 netlink_sendmsg+0x2ff/0x740
May 16 14:40:07 brian-laptop kernel: [10096.551903]  [<ffffffff8160254b>]=
 sock_sendmsg+0x8b/0xc0
May 16 14:40:07 brian-laptop kernel: [10096.551905]  [<ffffffff811af0f6>]=
 ? __mem_cgroup_commit_charge+0x156/0x3d0
May 16 14:40:07 brian-laptop kernel: [10096.551907]  [<ffffffff8160223e>]=
 ? move_addr_to_kernel.part.16+0x1e/0x60
May 16 14:40:07 brian-laptop kernel: [10096.551909]  [<ffffffff81602df1>]=
 ? move_addr_to_kernel+0x21/0x30
May 16 14:40:07 brian-laptop kernel: [10096.551911]  [<ffffffff81602db9>]=
 ___sys_sendmsg+0x3a9/0x3c0
May 16 14:40:07 brian-laptop kernel: [10096.551913]  [<ffffffff81721aa4>]=
 ? __do_page_fault+0x204/0x560
May 16 14:40:07 brian-laptop kernel: [10096.551915]  [<ffffffff811112fc>]=
 ? acct_account_cputime+0x1c/0x20
May 16 14:40:07 brian-laptop kernel: [10096.551917]  [<ffffffff8109d76b>]=
 ? account_user_time+0x8b/0xa0
May 16 14:40:07 brian-laptop kernel: [10096.551919]  [<ffffffff816034c2>]=
 __sys_sendmsg+0x42/0x80
May 16 14:40:07 brian-laptop kernel: [10096.551922]  [<ffffffff81603512>]=
 SyS_sendmsg+0x12/0x20
May 16 14:40:07 brian-laptop kernel: [10096.551923]  [<ffffffff817266bf>]=
 tracesys+0xe1/0xe6
May 16 14:40:07 brian-laptop kernel: [10096.551925] ---[ end trace 6e41db=
04d0be7025 ]---
May 16 14:40:07 brian-laptop kernel: [10096.551927] iwlwifi 0000:01:00.0:=
 failed to update MAC 5c:51:4f:63:1e:10
May 16 14:40:07 brian-laptop kernel: [10096.551930] iwlwifi 0000:01:00.0:=
 iwl_trans_send_cmd bad state =3D 0
May 16 14:40:07 brian-laptop kernel: [10096.551931] iwlwifi 0000:01:00.0:=
 Failed to send BT_CI cmd
May 16 14:40:07 brian-laptop kernel: [10096.551933] iwlwifi 0000:01:00.0:=
 failed to update MAC 5c:51:4f:63:1e:10
May 16 14:40:07 brian-laptop kernel: [10096.551935] ------------[ cut her=
e ]------------
May 16 14:40:07 brian-laptop kernel: [10096.551939] WARNING: CPU: 1 PID: =
5153 at /build/buildd/linux-3.13.0/drivers/net/wireless/iwlwifi/mvm/bindi=
ng.c:193 iwl_mvm_binding_remove_vif+0x3f/0x50 [iwlmvm]()
May 16 14:40:07 brian-laptop kernel: [10096.551940] Modules linked in: iw=
lmvm mac80211 iwlwifi cfg80211 hid_sensor_accel_3d hid_sensor_gyro_3d hid=
_sensor_als hid_sensor_magn_3d hid_sensor_trigger industrialio_triggered_=
buffer kfifo_buf industrialio hid_sensor_iio_common hid_multitouch hid_se=
nsor_hub uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core video=
dev usbhid hid btusb ctr ccm snd_hda_codec_hdmi snd_hda_codec_realtek joy=
dev arc4 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_page_alloc snd=
_seq_midi snd_seq_midi_event intel_rapl x86_pkg_temp_thermal intel_powerc=
lamp coretemp snd_rawmidi kvm crct10dif_pclmul snd_seq crc32_pclmul ghash=
_clmulni_intel snd_seq_device snd_timer aesni_intel snd aes_x86_64 lrw gf=
128mul glue_helper ablk_helper cryptd i915 psmouse serio_raw drm_kms_help=
er lpc_ich drm mei_me mei soundcore i2c_algo_bit rfcomm bnep bluetooth nl=
s_iso8859_1 parport_pc ppdev video intel_smartconnect lp parport mac_hid =
ahci libahci [last unloaded: cfg80211]
May 16 14:40:07 brian-laptop kernel: [10096.551969] CPU: 1 PID: 5153 Comm=
: ip Tainted: G        W    3.13.0-24-generic #47-Ubuntu
May 16 14:40:07 brian-laptop kernel: [10096.551970] Hardware name: LENOVO=
 20266/Yoga2, BIOS 76CN27WW 09/17/2013
May 16 14:40:07 brian-laptop kernel: [10096.551971]  0000000000000009 fff=
f880203649448 ffffffff81715ac4 0000000000000000
May 16 14:40:07 brian-laptop kernel: [10096.551972]  ffff880203649480 fff=
fffff810676bd ffff8800815d72b8 ffff8800815c7800
May 16 14:40:07 brian-laptop kernel: [10096.551974]  ffff8800815c77d0 fff=
f88023e0d8840 ffff88023e0d8870 ffff880203649490
May 16 14:40:07 brian-laptop kernel: [10096.551976] Call Trace:
May 16 14:40:07 brian-laptop kernel: [10096.551979]  [<ffffffff81715ac4>]=
 dump_stack+0x45/0x56
May 16 14:40:07 brian-laptop kernel: [10096.551980]  [<ffffffff810676bd>]=
 warn_slowpath_common+0x7d/0xa0
May 16 14:40:07 brian-laptop kernel: [10096.551982]  [<ffffffff8106779a>]=
 warn_slowpath_null+0x1a/0x20
May 16 14:40:07 brian-laptop kernel: [10096.551985]  [<ffffffffa04f2b0f>]=
 iwl_mvm_binding_remove_vif+0x3f/0x50 [iwlmvm]
May 16 14:40:07 brian-laptop kernel: [10096.551988]  [<ffffffffa04e9d17>]=
 iwl_mvm_unassign_vif_chanctx+0x57/0x90 [iwlmvm]
May 16 14:40:07 brian-laptop kernel: [10096.551996]  [<ffffffffa065a3aa>]=
 __ieee80211_vif_release_channel+0x9a/0x1e0 [mac80211]
May 16 14:40:07 brian-laptop kernel: [10096.552003]  [<ffffffffa065abed>]=
 ieee80211_vif_release_channel+0x4d/0x70 [mac80211]
May 16 14:40:07 brian-laptop kernel: [10096.552010]  [<ffffffffa066c7b7>]=
 ieee80211_set_disassoc+0x267/0x3d0 [mac80211]
May 16 14:40:07 brian-laptop kernel: [10096.552017]  [<ffffffffa0670903>]=
 ieee80211_mgd_deauth+0x1d3/0x240 [mac80211]
May 16 14:40:07 brian-laptop kernel: [10096.552024]  [<ffffffffa0642c38>]=
 ieee80211_deauth+0x18/0x20 [mac80211]
May 16 14:40:07 brian-laptop kernel: [10096.552031]  [<ffffffffa03b795c>]=
 cfg80211_mlme_deauth+0x9c/0x140 [cfg80211]
May 16 14:40:07 brian-laptop kernel: [10096.552036]  [<ffffffffa03b7c0b>]=
 cfg80211_mlme_down+0x6b/0x90 [cfg80211]
May 16 14:40:07 brian-laptop kernel: [10096.552043]  [<ffffffffa03bb94b>]=
 cfg80211_disconnect+0x18b/0x1b0 [cfg80211]
May 16 14:40:07 brian-laptop kernel: [10096.552048]  [<ffffffffa039f77c>]=
 ? __cfg80211_stop_sched_scan+0x1c/0x130 [cfg80211]
May 16 14:40:07 brian-laptop kernel: [10096.552053]  [<ffffffffa0396a84>]=
 cfg80211_leave+0xc4/0xe0 [cfg80211]
May 16 14:40:07 brian-laptop kernel: [10096.552058]  [<ffffffffa0396e3b>]=
 cfg80211_netdev_notifier_call+0x39b/0x610 [cfg80211]
May 16 14:40:07 brian-laptop kernel: [10096.552060]  [<ffffffff816861c8>]=
 ? inetdev_event+0x38/0x510
May 16 14:40:07 brian-laptop kernel: [10096.552061]  [<ffffffff81721fbc>]=
 notifier_call_chain+0x4c/0x70
May 16 14:40:07 brian-laptop kernel: [10096.552064]  [<ffffffff8108fb46>]=
 raw_notifier_call_chain+0x16/0x20
May 16 14:40:07 brian-laptop kernel: [10096.552066]  [<ffffffff81616395>]=
 call_netdevice_notifiers_info+0x35/0x60
May 16 14:40:07 brian-laptop kernel: [10096.552067]  [<ffffffff81616489>]=
 __dev_close_many+0x49/0xe0
May 16 14:40:07 brian-laptop kernel: [10096.552069]  [<ffffffff8161656d>]=
 __dev_close+0x4d/0x90
May 16 14:40:07 brian-laptop kernel: [10096.552071]  [<ffffffff8161db8d>]=
 __dev_change_flags+0x9d/0x170
May 16 14:40:07 brian-laptop kernel: [10096.552072]  [<ffffffff8161dc89>]=
 dev_change_flags+0x29/0x60
May 16 14:40:07 brian-laptop kernel: [10096.552074]  [<ffffffff8162b782>]=
 do_setlink+0x312/0x9e0
May 16 14:40:07 brian-laptop kernel: [10096.552077]  [<ffffffff81384ea2>]=
 ? nla_parse+0x32/0xe0
May 16 14:40:07 brian-laptop kernel: [10096.552079]  [<ffffffff8162cab4>]=
 rtnl_newlink+0x394/0x5d0
May 16 14:40:07 brian-laptop kernel: [10096.552081]  [<ffffffff81365a62>]=
 ? put_dec+0x72/0x90
May 16 14:40:07 brian-laptop kernel: [10096.552083]  [<ffffffff8130d74d>]=
 ? apparmor_capable+0x1d/0x130
May 16 14:40:07 brian-laptop kernel: [10096.552085]  [<ffffffff81629539>]=
 rtnetlink_rcv_msg+0x99/0x260
May 16 14:40:07 brian-laptop kernel: [10096.552088]  [<ffffffff811a2778>]=
 ? __kmalloc_node_track_caller+0x58/0x1e0
May 16 14:40:07 brian-laptop kernel: [10096.552090]  [<ffffffff8116c409>]=
 ? zone_statistics+0x89/0xa0
May 16 14:40:07 brian-laptop kernel: [10096.552092]  [<ffffffff8160b45e>]=
 ? __alloc_skb+0x7e/0x2b0
May 16 14:40:07 brian-laptop kernel: [10096.552093]  [<ffffffff816294a0>]=
 ? rtnetlink_rcv+0x30/0x30
May 16 14:40:07 brian-laptop kernel: [10096.552095]  [<ffffffff81647a89>]=
 netlink_rcv_skb+0xa9/0xc0
May 16 14:40:07 brian-laptop kernel: [10096.552097]  [<ffffffff81629498>]=
 rtnetlink_rcv+0x28/0x30
May 16 14:40:07 brian-laptop kernel: [10096.552099]  [<ffffffff816470b5>]=
 netlink_unicast+0xd5/0x1b0
May 16 14:40:07 brian-laptop kernel: [10096.552101]  [<ffffffff8164748f>]=
 netlink_sendmsg+0x2ff/0x740
May 16 14:40:07 brian-laptop kernel: [10096.552103]  [<ffffffff8160254b>]=
 sock_sendmsg+0x8b/0xc0
May 16 14:40:07 brian-laptop kernel: [10096.552105]  [<ffffffff811af0f6>]=
 ? __mem_cgroup_commit_charge+0x156/0x3d0
May 16 14:40:07 brian-laptop kernel: [10096.552107]  [<ffffffff8160223e>]=
 ? move_addr_to_kernel.part.16+0x1e/0x60
May 16 14:40:07 brian-laptop kernel: [10096.552109]  [<ffffffff81602df1>]=
 ? move_addr_to_kernel+0x21/0x30
May 16 14:40:07 brian-laptop kernel: [10096.552111]  [<ffffffff81602db9>]=
 ___sys_sendmsg+0x3a9/0x3c0
May 16 14:40:07 brian-laptop kernel: [10096.552113]  [<ffffffff81721aa4>]=
 ? __do_page_fault+0x204/0x560
May 16 14:40:07 brian-laptop kernel: [10096.552116]  [<ffffffff811112fc>]=
 ? acct_account_cputime+0x1c/0x20
May 16 14:40:07 brian-laptop kernel: [10096.552117]  [<ffffffff8109d76b>]=
 ? account_user_time+0x8b/0xa0
May 16 14:40:07 brian-laptop kernel: [10096.552119]  [<ffffffff816034c2>]=
 __sys_sendmsg+0x42/0x80
May 16 14:40:07 brian-laptop kernel: [10096.552122]  [<ffffffff81603512>]=
 SyS_sendmsg+0x12/0x20
May 16 14:40:07 brian-laptop kernel: [10096.552124]  [<ffffffff817266bf>]=
 tracesys+0xe1/0xe6
May 16 14:40:07 brian-laptop kernel: [10096.552125] ---[ end trace 6e41db=
04d0be7026 ]---
May 16 14:40:07 brian-laptop kernel: [10096.552156] iwlwifi 0000:01:00.0:=
 offset 2 not used in fw key table.
May 16 14:40:07 brian-laptop kernel: [10096.552158] wlan0: failed to remo=
ve key (1, ff:ff:ff:ff:ff:ff) from hardware (-2)
May 16 14:40:07 brian-laptop kernel: [10096.552182] iwlwifi 0000:01:00.0:=
 offset 1 not used in fw key table.
May 16 14:40:07 brian-laptop kernel: [10096.552184] wlan0: failed to remo=
ve key (2, ff:ff:ff:ff:ff:ff) from hardware (-2)
May 16 14:40:07 brian-laptop kernel: [10096.591171] iwlwifi 0000:01:00.0:=
 iwl_trans_send_cmd bad state =3D 0
May 16 14:40:07 brian-laptop kernel: [10096.591177] iwlwifi 0000:01:00.0:=
 Failed to send flush command (-5)
May 16 14:40:07 brian-laptop kernel: [10096.591193] ------------[ cut her=
e ]------------
May 16 14:40:07 brian-laptop kernel: [10096.591204] WARNING: CPU: 1 PID: =
5153 at /build/buildd/linux-3.13.0/drivers/net/wireless/iwlwifi/mvm/mac-c=
txt.c:1110 iwl_mvm_mac_ctxt_remove+0x171/0x190 [iwlmvm]()
May 16 14:40:07 brian-laptop kernel: [10096.591206] Removing inactive MAC=
 5c:51:4f:63:1e:10/2
May 16 14:40:07 brian-laptop kernel: [10096.591208] Modules linked in: iw=
lmvm mac80211 iwlwifi cfg80211 hid_sensor_accel_3d hid_sensor_gyro_3d hid=
_sensor_als hid_sensor_magn_3d hid_sensor_trigger industrialio_triggered_=
buffer kfifo_buf industrialio hid_sensor_iio_common hid_multitouch hid_se=
nsor_hub uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core video=
dev usbhid hid btusb ctr ccm snd_hda_codec_hdmi snd_hda_codec_realtek joy=
dev arc4 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_page_alloc snd=
_seq_midi snd_seq_midi_event intel_rapl x86_pkg_temp_thermal intel_powerc=
lamp coretemp snd_rawmidi kvm crct10dif_pclmul snd_seq crc32_pclmul ghash=
_clmulni_intel snd_seq_device snd_timer aesni_intel snd aes_x86_64 lrw gf=
128mul glue_helper ablk_helper cryptd i915 psmouse serio_raw drm_kms_help=
er lpc_ich drm mei_me mei soundcore i2c_algo_bit rfcomm bnep bluetooth nl=
s_iso8859_1 parport_pc ppdev video intel_smartconnect lp parport mac_hid =
ahci libahci [last unloaded: cfg80211]
May 16 14:40:07 brian-laptop kernel: [10096.591264] CPU: 1 PID: 5153 Comm=
: ip Tainted: G        W    3.13.0-24-generic #47-Ubuntu
May 16 14:40:07 brian-laptop kernel: [10096.591265] Hardware name: LENOVO=
 20266/Yoga2, BIOS 76CN27WW 09/17/2013
May 16 14:40:07 brian-laptop kernel: [10096.591267]  0000000000000009 fff=
f8802036495b8 ffffffff81715ac4 ffff880203649600
May 16 14:40:07 brian-laptop kernel: [10096.591270]  ffff8802036495f0 fff=
fffff810676bd ffff8800815d72b8 ffff8800815c77c0
May 16 14:40:07 brian-laptop kernel: [10096.591273]  ffff8800815c77d0 fff=
f8800815c7800 ffff8800815d72b8 ffff880203649650
May 16 14:40:07 brian-laptop kernel: [10096.591276] Call Trace:
May 16 14:40:07 brian-laptop kernel: [10096.591283]  [<ffffffff81715ac4>]=
 dump_stack+0x45/0x56
May 16 14:40:07 brian-laptop kernel: [10096.591287]  [<ffffffff810676bd>]=
 warn_slowpath_common+0x7d/0xa0
May 16 14:40:07 brian-laptop kernel: [10096.591290]  [<ffffffff8106772c>]=
 warn_slowpath_fmt+0x4c/0x50
May 16 14:40:07 brian-laptop kernel: [10096.591294]  [<ffffffff811d47db>]=
 ? evict+0x11b/0x1b0
May 16 14:40:07 brian-laptop kernel: [10096.591299]  [<ffffffffa04ef761>]=
 iwl_mvm_mac_ctxt_remove+0x171/0x190 [iwlmvm]
May 16 14:40:07 brian-laptop kernel: [10096.591302]  [<ffffffff811d8fe9>]=
 ? mntput_no_expire+0x109/0x170
May 16 14:40:07 brian-laptop kernel: [10096.591305]  [<ffffffff811d9074>]=
 ? mntput+0x24/0x40
May 16 14:40:07 brian-laptop kernel: [10096.591308]  [<ffffffff812b4976>]=
 ? debugfs_remove_recursive+0x116/0x1c0
May 16 14:40:07 brian-laptop kernel: [10096.591313]  [<ffffffffa04eb155>]=
 iwl_mvm_mac_remove_interface+0xb5/0x190 [iwlmvm]
May 16 14:40:07 brian-laptop kernel: [10096.591325]  [<ffffffffa063e031>]=
 ieee80211_do_stop+0x4c1/0x830 [mac80211]
May 16 14:40:07 brian-laptop kernel: [10096.591335]  [<ffffffffa063e3ba>]=
 ieee80211_stop+0x1a/0x20 [mac80211]
May 16 14:40:07 brian-laptop kernel: [10096.591339]  [<ffffffff816164cd>]=
 __dev_close_many+0x8d/0xe0
May 16 14:40:07 brian-laptop kernel: [10096.591341]  [<ffffffff8161656d>]=
 __dev_close+0x4d/0x90
May 16 14:40:07 brian-laptop kernel: [10096.591344]  [<ffffffff8161db8d>]=
 __dev_change_flags+0x9d/0x170
May 16 14:40:07 brian-laptop kernel: [10096.591347]  [<ffffffff8161dc89>]=
 dev_change_flags+0x29/0x60
May 16 14:40:07 brian-laptop kernel: [10096.591350]  [<ffffffff8162b782>]=
 do_setlink+0x312/0x9e0
May 16 14:40:07 brian-laptop kernel: [10096.591355]  [<ffffffff81384ea2>]=
 ? nla_parse+0x32/0xe0
May 16 14:40:07 brian-laptop kernel: [10096.591357]  [<ffffffff8162cab4>]=
 rtnl_newlink+0x394/0x5d0
May 16 14:40:07 brian-laptop kernel: [10096.591362]  [<ffffffff81365a62>]=
 ? put_dec+0x72/0x90
May 16 14:40:07 brian-laptop kernel: [10096.591366]  [<ffffffff8130d74d>]=
 ? apparmor_capable+0x1d/0x130
May 16 14:40:07 brian-laptop kernel: [10096.591368]  [<ffffffff81629539>]=
 rtnetlink_rcv_msg+0x99/0x260
May 16 14:40:07 brian-laptop kernel: [10096.591373]  [<ffffffff811a2778>]=
 ? __kmalloc_node_track_caller+0x58/0x1e0
May 16 14:40:07 brian-laptop kernel: [10096.591376]  [<ffffffff8116c409>]=
 ? zone_statistics+0x89/0xa0
May 16 14:40:07 brian-laptop kernel: [10096.591379]  [<ffffffff8160b45e>]=
 ? __alloc_skb+0x7e/0x2b0
May 16 14:40:07 brian-laptop kernel: [10096.591382]  [<ffffffff816294a0>]=
 ? rtnetlink_rcv+0x30/0x30
May 16 14:40:07 brian-laptop kernel: [10096.591385]  [<ffffffff81647a89>]=
 netlink_rcv_skb+0xa9/0xc0
May 16 14:40:07 brian-laptop kernel: [10096.591388]  [<ffffffff81629498>]=
 rtnetlink_rcv+0x28/0x30
May 16 14:40:07 brian-laptop kernel: [10096.591391]  [<ffffffff816470b5>]=
 netlink_unicast+0xd5/0x1b0
May 16 14:40:07 brian-laptop kernel: [10096.591393]  [<ffffffff8164748f>]=
 netlink_sendmsg+0x2ff/0x740
May 16 14:40:07 brian-laptop kernel: [10096.591397]  [<ffffffff8160254b>]=
 sock_sendmsg+0x8b/0xc0
May 16 14:40:07 brian-laptop kernel: [10096.591401]  [<ffffffff811af0f6>]=
 ? __mem_cgroup_commit_charge+0x156/0x3d0
May 16 14:40:07 brian-laptop kernel: [10096.591404]  [<ffffffff8160223e>]=
 ? move_addr_to_kernel.part.16+0x1e/0x60
May 16 14:40:07 brian-laptop kernel: [10096.591407]  [<ffffffff81602df1>]=
 ? move_addr_to_kernel+0x21/0x30
May 16 14:40:07 brian-laptop kernel: [10096.591410]  [<ffffffff81602db9>]=
 ___sys_sendmsg+0x3a9/0x3c0
May 16 14:40:07 brian-laptop kernel: [10096.591413]  [<ffffffff81721aa4>]=
 ? __do_page_fault+0x204/0x560
May 16 14:40:07 brian-laptop kernel: [10096.591418]  [<ffffffff811112fc>]=
 ? acct_account_cputime+0x1c/0x20
May 16 14:40:07 brian-laptop kernel: [10096.591421]  [<ffffffff8109d76b>]=
 ? account_user_time+0x8b/0xa0
May 16 14:40:07 brian-laptop kernel: [10096.591424]  [<ffffffff816034c2>]=
 __sys_sendmsg+0x42/0x80
May 16 14:40:07 brian-laptop kernel: [10096.591427]  [<ffffffff81603512>]=
 SyS_sendmsg+0x12/0x20
May 16 14:40:07 brian-laptop kernel: [10096.591430]  [<ffffffff817266bf>]=
 tracesys+0xe1/0xe6
May 16 14:40:07 brian-laptop kernel: [10096.591432] ---[ end trace 6e41db=
04d0be7027 ]---
May 16 14:40:07 brian-laptop kernel: [10096.591435] iwlwifi 0000:01:00.0:=
 iwl_trans_txq_disable bad state =3D 0
May 16 14:40:07 brian-laptop kernel: [10096.626167] iwlwifi 0000:01:00.0:=
 iwl_trans_txq_disable bad state =3D 0
May 16 14:40:07 brian-laptop kernel: [10096.661078] iwlwifi 0000:01:00.0:=
 iwl_trans_txq_disable bad state =3D 0
May 16 14:40:07 brian-laptop kernel: [10096.696278] iwlwifi 0000:01:00.0:=
 iwl_trans_txq_disable bad state =3D 0
May 16 14:40:07 brian-laptop avahi-daemon[491]: Interface wlan0.IPv6 no l=
onger relevant for mDNS.
May 16 14:40:07 brian-laptop avahi-daemon[491]: Leaving mDNS multicast gr=
oup on interface wlan0.IPv6 with address fe80::5e51:4fff:fe63:1e10.
May 16 14:40:07 brian-laptop avahi-daemon[491]: Withdrawing address recor=
d for fe80::5e51:4fff:fe63:1e10 on wlan0.
May 16 14:40:07 brian-laptop kernel: [10096.732094] cfg80211: Calling CRD=
A to update world regulatory domain
May 16 14:40:07 brian-laptop kernel: [10096.734432] cfg80211: World regul=
atory domain updated:
May 16 14:40:07 brian-laptop kernel: [10096.734436] cfg80211:   (start_fr=
eq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
May 16 14:40:07 brian-laptop kernel: [10096.734438] cfg80211:   (2402000 =
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 14:40:07 brian-laptop kernel: [10096.734440] cfg80211:   (2457000 =
KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 14:40:07 brian-laptop kernel: [10096.734442] cfg80211:   (2474000 =
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
May 16 14:40:07 brian-laptop kernel: [10096.734443] cfg80211:   (5170000 =
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 14:40:07 brian-laptop kernel: [10096.734445] cfg80211:   (5735000 =
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 14:40:07 brian-laptop wpa_supplicant[2935]: wlan0: CTRL-EVENT-TERM=
INATING=20
May 16 14:40:27 brian-laptop kernel: [10116.030496] iwlwifi 0000:01:00.0:=
 L1 Disabled; Enabling L0S
May 16 14:40:27 brian-laptop kernel: [10116.172175] iwlwifi 0000:01:00.0:=
 L1 Disabled; Enabling L0S
May 16 14:40:36 brian-laptop rtkit-daemon[1447]: The canary thread is app=
arently starving. Taking action.
May 16 14:40:36 brian-laptop rtkit-daemon[1447]: Demoting known real-time=
 threads.
May 16 14:40:36 brian-laptop rtkit-daemon[1447]: Successfully demoted thr=
ead 1884 of process 1861 (n/a).
May 16 14:40:36 brian-laptop rtkit-daemon[1447]: Successfully demoted thr=
ead 1882 of process 1861 (n/a).
May 16 14:40:36 brian-laptop rtkit-daemon[1447]: Successfully demoted thr=
ead 1873 of process 1861 (n/a).
May 16 14:40:36 brian-laptop rtkit-daemon[1447]: Successfully demoted thr=
ead 1861 of process 1861 (n/a).
May 16 14:40:36 brian-laptop rtkit-daemon[1447]: Demoted 4 threads.
May 16 14:40:40 brian-laptop kernel: [10121.979749] iwlwifi 0000:01:00.0:=
 Failed to load firmware chunk!
May 16 14:40:40 brian-laptop kernel: [10121.979761] iwlwifi 0000:01:00.0:=
 Could not load the [0] uCode section
May 16 14:40:40 brian-laptop kernel: [10121.979772] iwlwifi 0000:01:00.0:=
 Failed to start RT ucode: -110
May 16 14:40:40 brian-laptop kernel: [10123.780746] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 0 [0x5a5a5a5a]
May 16 14:40:40 brian-laptop kernel: [10125.589854] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 2 [0x5a5a5a5a]
May 16 14:40:40 brian-laptop kernel: [10127.465712] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 5 [0x5a5a5a5a]
May 16 14:40:40 brian-laptop kernel: [10129.306172] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 7 [0x5a5a5a5a]
May 16 14:40:51 brian-laptop wpa_supplicant[5285]: Successfully initializ=
ed wpa_supplicant
May 16 14:40:51 brian-laptop kernel: [10140.753450] iwlwifi 0000:01:00.0:=
 L1 Disabled; Enabling L0S
May 16 14:40:52 brian-laptop kernel: [10140.893728] iwlwifi 0000:01:00.0:=
 L1 Disabled; Enabling L0S
May 16 14:41:05 brian-laptop kernel: [10146.699687] iwlwifi 0000:01:00.0:=
 Failed to load firmware chunk!
May 16 14:41:05 brian-laptop kernel: [10146.699692] iwlwifi 0000:01:00.0:=
 Could not load the [0] uCode section
May 16 14:41:05 brian-laptop kernel: [10146.699697] iwlwifi 0000:01:00.0:=
 Failed to start RT ucode: -110
May 16 14:41:05 brian-laptop kernel: [10148.492852] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 0 [0x5a5a5a5a]
May 16 14:41:05 brian-laptop kernel: [10150.303519] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 2 [0x5a5a5a5a]
May 16 14:41:05 brian-laptop kernel: [10152.148957] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 5 [0x5a5a5a5a]
May 16 14:41:05 brian-laptop kernel: [10153.959639] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 7 [0x5a5a5a5a]
May 16 14:41:06 brian-laptop wpa_supplicant[5285]: Could not set interfac=
e wlan0 flags (UP): Connection timed out
May 16 14:41:06 brian-laptop wpa_supplicant[5285]: nl80211: Could not set=
 interface 'wlan0' UP
May 16 14:41:06 brian-laptop kernel: [10155.737623] iwlwifi 0000:01:00.0:=
 L1 Disabled; Enabling L0S
May 16 14:41:07 brian-laptop kernel: [10155.878773] iwlwifi 0000:01:00.0:=
 L1 Disabled; Enabling L0S
May 16 14:41:20 brian-laptop kernel: [10161.683821] iwlwifi 0000:01:00.0:=
 Failed to load firmware chunk!
May 16 14:41:20 brian-laptop kernel: [10161.683835] iwlwifi 0000:01:00.0:=
 Could not load the [0] uCode section
May 16 14:41:20 brian-laptop kernel: [10161.683848] iwlwifi 0000:01:00.0:=
 Failed to start RT ucode: -110
May 16 14:41:20 brian-laptop kernel: [10163.494501] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 0 [0x5a5a5a5a]
May 16 14:41:20 brian-laptop kernel: [10165.335127] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 2 [0x5a5a5a5a]
May 16 14:41:20 brian-laptop kernel: [10167.210999] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 5 [0x5a5a5a5a]
May 16 14:41:20 brian-laptop kernel: [10169.050002] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 7 [0x5a5a5a5a]
May 16 14:41:20 brian-laptop kernel: [10169.050088] psmouse serio1: Touch=
Pad at isa0060/serio1/input0 lost synchronization, throwing 3 bytes away.=

May 16 14:41:21 brian-laptop wpa_supplicant[5285]: Could not set interfac=
e wlan0 flags (UP): Connection timed out
May 16 14:41:21 brian-laptop wpa_supplicant[5285]: WEXT: Could not set in=
terface 'wlan0' UP
May 16 14:41:21 brian-laptop wpa_supplicant[5285]: wlan0: Failed to initi=
alize driver interface
May 16 14:41:21 brian-laptop dhclient: Internet Systems Consortium DHCP C=
lient 4.2.4
May 16 14:41:21 brian-laptop dhclient: Copyright 2004-2012 Internet Syste=
ms Consortium.
May 16 14:41:21 brian-laptop dhclient: All rights reserved.
May 16 14:41:21 brian-laptop dhclient: For info, please visit https://www=
=2Eisc.org/software/dhcp/
May 16 14:41:21 brian-laptop dhclient:=20
May 16 14:41:21 brian-laptop kernel: [10170.883828] iwlwifi 0000:01:00.0:=
 L1 Disabled; Enabling L0S
May 16 14:41:22 brian-laptop kernel: [10171.025392] iwlwifi 0000:01:00.0:=
 L1 Disabled; Enabling L0S
May 16 14:41:35 brian-laptop kernel: [10176.836016] iwlwifi 0000:01:00.0:=
 Failed to load firmware chunk!
May 16 14:41:35 brian-laptop kernel: [10176.836022] iwlwifi 0000:01:00.0:=
 Could not load the [0] uCode section
May 16 14:41:35 brian-laptop kernel: [10176.836028] iwlwifi 0000:01:00.0:=
 Failed to start RT ucode: -110
May 16 14:41:35 brian-laptop kernel: [10178.649852] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 0 [0x5a5a5a5a]
May 16 14:41:35 brian-laptop kernel: [10180.490357] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 2 [0x5a5a5a5a]
May 16 14:41:35 brian-laptop kernel: [10182.364674] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 5 [0x5a5a5a5a]
May 16 14:41:35 brian-laptop kernel: [10184.205077] iwlwifi 0000:01:00.0:=
 Failing on timeout while stopping DMA channel 7 [0x5a5a5a5a]
May 16 14:41:37 brian-laptop dhclient: Listening on LPF/wlan0/5c:51:4f:63=
:1e:10
May 16 14:41:37 brian-laptop dhclient: Sending on   LPF/wlan0/5c:51:4f:63=
:1e:10
May 16 14:41:37 brian-laptop dhclient: Sending on   Socket/fallback
May 16 14:41:37 brian-laptop dhclient: DHCPDISCOVER on wlan0 to 255.255.2=
55.255 port 67 interval 3 (xid=3D0x49c91128)
May 16 14:41:37 brian-laptop dhclient: send_packet: Network is down
May 16 14:41:37 brian-laptop dhclient: dhclient.c:1993: Failed to send 30=
0 byte long packet over wlan0 interface.
May 16 14:41:37 brian-laptop dhclient: receive_packet failed on wlan0: Ne=
twork is down
May 16 14:41:40 brian-laptop dhclient: DHCPDISCOVER on wlan0 to 255.255.2=
55.255 port 67 interval 4 (xid=3D0x49c91128)
May 16 14:41:40 brian-laptop dhclient: send_packet: Network is down
May 16 14:41:40 brian-laptop dhclient: dhclient.c:1993: Failed to send 30=
0 byte long packet over wlan0 interface.
May 16 14:41:44 brian-laptop dhclient: DHCPDISCOVER on wlan0 to 255.255.2=
55.255 port 67 interval 11 (xid=3D0x49c91128)
May 16 14:41:44 brian-laptop dhclient: send_packet: Network is down
May 16 14:41:44 brian-laptop dhclient: dhclient.c:1993: Failed to send 30=
0 byte long packet over wlan0 interface.
May 16 14:41:52 brian-laptop dhclient: Internet Systems Consortium DHCP C=
lient 4.2.4
May 16 14:41:52 brian-laptop dhclient: Copyright 2004-2012 Internet Syste=
ms Consortium.
May 16 14:41:52 brian-laptop dhclient: All rights reserved.
May 16 14:41:52 brian-laptop dhclient: For info, please visit https://www=
=2Eisc.org/software/dhcp/
May 16 14:41:52 brian-laptop dhclient:=20
May 16 14:41:52 brian-laptop dhclient: Listening on LPF/wlan0/5c:51:4f:63=
:1e:10
May 16 14:41:52 brian-laptop dhclient: Sending on   LPF/wlan0/5c:51:4f:63=
:1e:10
May 16 14:41:52 brian-laptop dhclient: Sending on   Socket/fallback
May 16 14:41:52 brian-laptop dhclient: DHCPRELEASE on wlan0 to 192.168.3.=
1 port 67 (xid=3D0x2d550291)
May 16 14:41:52 brian-laptop dhclient: send_packet: Network is unreachabl=
e
May 16 14:41:52 brian-laptop dhclient: send_packet: please consult README=
 file regarding broadcast address.
May 16 14:41:52 brian-laptop dhclient: dhclient.c:2365: Failed to send 30=
0 byte long packet over fallback interface.
May 16 14:45:57 brian-laptop dbus[450]: [system] Activating service name=3D=
'org.freedesktop.systemd1' (using servicehelper)
May 16 14:45:57 brian-laptop dbus[450]: [system] Successfully activated s=
ervice 'org.freedesktop.systemd1'
May 16 14:45:57 brian-laptop rsyslogd: [origin software=3D"rsyslogd" swVe=
rsion=3D"7.4.4" x-pid=3D"483" x-info=3D"http://www.rsyslog.com"] exiting =
on signal 15.
May 16 14:46:43 brian-laptop rsyslogd: [origin software=3D"rsyslogd" swVe=
rsion=3D"7.4.4" x-pid=3D"607" x-info=3D"http://www.rsyslog.com"] start
May 16 14:46:43 brian-laptop rsyslogd: rsyslogd's groupid changed to 103
May 16 14:46:43 brian-laptop rsyslogd: rsyslogd's userid changed to 101
May 16 14:46:43 brian-laptop kernel: [    0.000000] Initializing cgroup s=
ubsys cpuset
May 16 14:46:43 brian-laptop kernel: [    0.000000] Initializing cgroup s=
ubsys cpu
May 16 14:46:43 brian-laptop kernel: [    0.000000] Initializing cgroup s=
ubsys cpuacct
May 16 14:46:43 brian-laptop kernel: [    0.000000] Linux version 3.13.0-=
24-generic (buildd@batsu) (gcc version 4.8.2 (Ubuntu 4.8.2-19ubuntu1) ) #=
47-Ubuntu SMP Fri May 2 23:30:00 UTC 2014 (Ubuntu 3.13.0-24.47-generic 3.=
13.9)
May 16 14:46:43 brian-laptop kernel: [    0.000000] Command line: BOOT_IM=
AGE=3D/boot/vmlinuz-3.13.0-24-generic.efi.signed root=3DUUID=3D8e47fdb9-a=
ff2-414b-a81c-2df6486162cd ro acpi_backlight=3Dvendor quiet splash vt.han=
doff=3D7
May 16 14:46:43 brian-laptop kernel: [    0.000000] KERNEL supported cpus=
:
May 16 14:46:43 brian-laptop kernel: [    0.000000]   Intel GenuineIntel
May 16 14:46:43 brian-laptop kernel: [    0.000000]   AMD AuthenticAMD
May 16 14:46:43 brian-laptop kernel: [    0.000000]   Centaur CentaurHaul=
s
May 16 14:46:43 brian-laptop kernel: [    0.000000] e820: BIOS-provided p=
hysical RAM map:
May 16 14:46:43 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
0000000000000-0x000000000006efff] usable
May 16 14:46:43 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
000000006f000-0x000000000006ffff] reserved
May 16 14:46:43 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
0000000070000-0x0000000000087fff] usable
May 16 14:46:43 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
0000000088000-0x00000000000bffff] reserved
May 16 14:46:43 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
0000000100000-0x000000007a8fffff] usable
May 16 14:46:43 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
000007a900000-0x000000007bcfffff] reserved
May 16 14:46:43 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
000007bd00000-0x000000009c6befff] usable
May 16 14:46:43 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
000009c6bf000-0x000000009c8befff] type 20
May 16 14:46:43 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
000009c8bf000-0x000000009cebefff] reserved
May 16 14:46:43 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
000009cebf000-0x000000009cfbefff] ACPI NVS
May 16 14:46:43 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
000009cfbf000-0x000000009cffefff] ACPI data
May 16 14:46:43 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
000009cfff000-0x000000009cffffff] usable
May 16 14:46:43 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
000009d000000-0x000000009f9fffff] reserved
May 16 14:46:43 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
00000e0000000-0x00000000efffffff] reserved
May 16 14:46:43 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
00000fe101000-0x00000000fe112fff] reserved
May 16 14:46:43 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
00000feb00000-0x00000000feb0ffff] reserved
May 16 14:46:43 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
00000fec00000-0x00000000fec00fff] reserved
May 16 14:46:43 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
00000fed00000-0x00000000fee00fff] reserved
May 16 14:46:43 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
00000ffc00000-0x00000000ffffffff] reserved
May 16 14:46:43 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
0000100000000-0x000000025f5fffff] usable
May 16 14:46:43 brian-laptop kernel: [    0.000000] NX (Execute Disable) =
protection: active
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: EFI v2.31 by INS=
YDE Corp.
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi:  ACPI=3D0x9cffe0=
00  ACPI 2.0=3D0x9cffe014  SMBIOS=3D0x9cebef98=20
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem00: type=3D3,=
 attr=3D0xf, range=3D[0x0000000000000000-0x0000000000001000) (0MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem01: type=3D7,=
 attr=3D0xf, range=3D[0x0000000000001000-0x000000000000e000) (0MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem02: type=3D3,=
 attr=3D0xf, range=3D[0x000000000000e000-0x0000000000010000) (0MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem03: type=3D7,=
 attr=3D0xf, range=3D[0x0000000000010000-0x000000000002e000) (0MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem04: type=3D3,=
 attr=3D0xf, range=3D[0x000000000002e000-0x000000000002f000) (0MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem05: type=3D4,=
 attr=3D0xf, range=3D[0x000000000002f000-0x0000000000030000) (0MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem06: type=3D3,=
 attr=3D0xf, range=3D[0x0000000000030000-0x000000000006f000) (0MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem07: type=3D0,=
 attr=3D0xf, range=3D[0x000000000006f000-0x0000000000070000) (0MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem08: type=3D3,=
 attr=3D0xf, range=3D[0x0000000000070000-0x0000000000088000) (0MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem09: type=3D6,=
 attr=3D0x800000000000000f, range=3D[0x0000000000088000-0x000000000009e00=
0) (0MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem10: type=3D0,=
 attr=3D0xf, range=3D[0x000000000009e000-0x000000000009f000) (0MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem11: type=3D6,=
 attr=3D0x800000000000000f, range=3D[0x000000000009f000-0x00000000000a000=
0) (0MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem12: type=3D2,=
 attr=3D0xf, range=3D[0x0000000000100000-0x00000000014ff000) (19MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem13: type=3D7,=
 attr=3D0xf, range=3D[0x00000000014ff000-0x0000000002000000) (11MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem14: type=3D2,=
 attr=3D0xf, range=3D[0x0000000002000000-0x00000000033ff000) (19MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem15: type=3D7,=
 attr=3D0xf, range=3D[0x00000000033ff000-0x0000000035b9c000) (807MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem16: type=3D2,=
 attr=3D0xf, range=3D[0x0000000035b9c000-0x0000000036dc6000) (18MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem17: type=3D7,=
 attr=3D0xf, range=3D[0x0000000036dc6000-0x0000000053db5000) (463MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem18: type=3D2,=
 attr=3D0xf, range=3D[0x0000000053db5000-0x0000000078d10000) (591MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem19: type=3D4,=
 attr=3D0xf, range=3D[0x0000000078d10000-0x0000000078d30000) (0MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem20: type=3D7,=
 attr=3D0xf, range=3D[0x0000000078d30000-0x00000000798a4000) (11MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem21: type=3D2,=
 attr=3D0xf, range=3D[0x00000000798a4000-0x0000000079a78000) (1MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem22: type=3D4,=
 attr=3D0xf, range=3D[0x0000000079a78000-0x000000007a900000) (14MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem23: type=3D0,=
 attr=3D0xf, range=3D[0x000000007a900000-0x000000007bd00000) (20MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem24: type=3D7,=
 attr=3D0xf, range=3D[0x000000007bd00000-0x000000007bd0d000) (0MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem25: type=3D2,=
 attr=3D0xf, range=3D[0x000000007bd0d000-0x000000007bd0f000) (0MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem26: type=3D7,=
 attr=3D0xf, range=3D[0x000000007bd0f000-0x000000007bddb000) (0MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem27: type=3D1,=
 attr=3D0xf, range=3D[0x000000007bddb000-0x000000007bf0f000) (1MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem28: type=3D7,=
 attr=3D0xf, range=3D[0x000000007bf0f000-0x000000007e1c3000) (34MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem29: type=3D4,=
 attr=3D0xf, range=3D[0x000000007e1c3000-0x000000007e1cf000) (0MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem30: type=3D7,=
 attr=3D0xf, range=3D[0x000000007e1cf000-0x000000007e20b000) (0MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem31: type=3D4,=
 attr=3D0xf, range=3D[0x000000007e20b000-0x000000007eee1000) (12MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem32: type=3D7,=
 attr=3D0xf, range=3D[0x000000007eee1000-0x000000007eee3000) (0MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem33: type=3D4,=
 attr=3D0xf, range=3D[0x000000007eee3000-0x0000000081f91000) (48MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem34: type=3D7,=
 attr=3D0xf, range=3D[0x0000000081f91000-0x0000000081f94000) (0MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem35: type=3D4,=
 attr=3D0xf, range=3D[0x0000000081f94000-0x0000000081fbd000) (0MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem36: type=3D7,=
 attr=3D0xf, range=3D[0x0000000081fbd000-0x0000000081fbe000) (0MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem37: type=3D4,=
 attr=3D0xf, range=3D[0x0000000081fbe000-0x0000000082161000) (1MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem38: type=3D7,=
 attr=3D0xf, range=3D[0x0000000082161000-0x0000000082165000) (0MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem39: type=3D4,=
 attr=3D0xf, range=3D[0x0000000082165000-0x000000008216a000) (0MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem40: type=3D7,=
 attr=3D0xf, range=3D[0x000000008216a000-0x000000008216b000) (0MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem41: type=3D4,=
 attr=3D0xf, range=3D[0x000000008216b000-0x00000000821d9000) (0MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem42: type=3D7,=
 attr=3D0xf, range=3D[0x00000000821d9000-0x00000000821da000) (0MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem43: type=3D4,=
 attr=3D0xf, range=3D[0x00000000821da000-0x00000000821e1000) (0MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem44: type=3D7,=
 attr=3D0xf, range=3D[0x00000000821e1000-0x00000000821e4000) (0MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem45: type=3D4,=
 attr=3D0xf, range=3D[0x00000000821e4000-0x00000000821e6000) (0MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem46: type=3D7,=
 attr=3D0xf, range=3D[0x00000000821e6000-0x00000000821e8000) (0MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem47: type=3D4,=
 attr=3D0xf, range=3D[0x00000000821e8000-0x000000008408f000) (30MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem48: type=3D7,=
 attr=3D0xf, range=3D[0x000000008408f000-0x000000008c2a5000) (130MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem49: type=3D3,=
 attr=3D0xf, range=3D[0x000000008c2a5000-0x000000008c2c6000) (0MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem50: type=3D7,=
 attr=3D0xf, range=3D[0x000000008c2c6000-0x000000009c2bc000) (255MB)
May 16 14:46:43 brian-laptop rsyslogd-2039: Could no open output pipe '/d=
ev/xconsole': No such file or directory [try http://www.rsyslog.com/e/203=
9 ]
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem51: type=3D2,=
 attr=3D0xf, range=3D[0x000000009c2bc000-0x000000009c2c6000) (0MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem52: type=3D3,=
 attr=3D0xf, range=3D[0x000000009c2c6000-0x000000009c6bf000) (3MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem53: type=3D5,=
 attr=3D0x800000000000000f, range=3D[0x000000009c6bf000-0x000000009c8bf00=
0) (2MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem54: type=3D6,=
 attr=3D0x800000000000000f, range=3D[0x000000009c8bf000-0x000000009cabf00=
0) (2MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem55: type=3D0,=
 attr=3D0xf, range=3D[0x000000009cabf000-0x000000009cebf000) (4MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem56: type=3D10=
, attr=3D0xf, range=3D[0x000000009cebf000-0x000000009cfbf000) (1MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem57: type=3D9,=
 attr=3D0xf, range=3D[0x000000009cfbf000-0x000000009cfff000) (0MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem58: type=3D4,=
 attr=3D0xf, range=3D[0x000000009cfff000-0x000000009d000000) (0MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem59: type=3D7,=
 attr=3D0xf, range=3D[0x0000000100000000-0x000000025f600000) (5622MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem60: type=3D0,=
 attr=3D0x0, range=3D[0x00000000000a0000-0x00000000000c0000) (0MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem61: type=3D0,=
 attr=3D0x0, range=3D[0x000000009d000000-0x000000009fa00000) (42MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem62: type=3D11=
, attr=3D0x8000000000000001, range=3D[0x00000000e0000000-0x00000000f00000=
00) (256MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem63: type=3D0,=
 attr=3D0x0, range=3D[0x00000000fe101000-0x00000000fe113000) (0MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem64: type=3D11=
, attr=3D0x8000000000000001, range=3D[0x00000000feb00000-0x00000000feb100=
00) (0MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem65: type=3D11=
, attr=3D0x8000000000000001, range=3D[0x00000000fec00000-0x00000000fec010=
00) (0MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem66: type=3D11=
, attr=3D0x8000000000000001, range=3D[0x00000000fed00000-0x00000000fed1c0=
00) (0MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem67: type=3D11=
, attr=3D0x8000000000000000, range=3D[0x00000000fed1c000-0x00000000fed200=
00) (0MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem68: type=3D11=
, attr=3D0x8000000000000001, range=3D[0x00000000fed20000-0x00000000fee010=
00) (0MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] efi: mem69: type=3D11=
, attr=3D0x8000000000000000, range=3D[0x00000000ffc00000-0x00000001000000=
00) (4MB)
May 16 14:46:43 brian-laptop kernel: [    0.000000] SMBIOS 2.7 present.
May 16 14:46:43 brian-laptop kernel: [    0.000000] DMI: LENOVO 20266/Yog=
a2, BIOS 76CN27WW 09/17/2013
May 16 14:46:43 brian-laptop kernel: [    0.000000] e820: update [mem 0x0=
0000000-0x00000fff] usable =3D=3D> reserved
May 16 14:46:43 brian-laptop kernel: [    0.000000] e820: remove [mem 0x0=
00a0000-0x000fffff] usable
May 16 14:46:43 brian-laptop kernel: [    0.000000] No AGP bridge found
May 16 14:46:43 brian-laptop kernel: [    0.000000] e820: last_pfn =3D 0x=
25f600 max_arch_pfn =3D 0x400000000
May 16 14:46:43 brian-laptop kernel: [    0.000000] MTRR default type: un=
cachable
May 16 14:46:43 brian-laptop kernel: [    0.000000] MTRR fixed ranges ena=
bled:
May 16 14:46:43 brian-laptop kernel: [    0.000000]   00000-9FFFF write-b=
ack
May 16 14:46:43 brian-laptop kernel: [    0.000000]   A0000-BFFFF uncacha=
ble
May 16 14:46:43 brian-laptop kernel: [    0.000000]   C0000-E7FFF write-p=
rotect
May 16 14:46:43 brian-laptop kernel: [    0.000000]   E8000-EFFFF write-c=
ombining
May 16 14:46:43 brian-laptop kernel: [    0.000000]   F0000-FFFFF write-p=
rotect
May 16 14:46:43 brian-laptop kernel: [    0.000000] MTRR variable ranges =
enabled:
May 16 14:46:43 brian-laptop kernel: [    0.000000]   0 base 0000000000 m=
ask 7F80000000 write-back
May 16 14:46:43 brian-laptop kernel: [    0.000000]   1 base 0080000000 m=
ask 7FE0000000 write-back
May 16 14:46:43 brian-laptop kernel: [    0.000000]   2 base 009D000000 m=
ask 7FFF000000 uncachable
May 16 14:46:43 brian-laptop kernel: [    0.000000]   3 base 009E000000 m=
ask 7FFE000000 uncachable
May 16 14:46:43 brian-laptop kernel: [    0.000000]   4 base 00FFC00000 m=
ask 7FFFC00000 write-protect
May 16 14:46:43 brian-laptop kernel: [    0.000000]   5 base 0100000000 m=
ask 7F00000000 write-back
May 16 14:46:43 brian-laptop kernel: [    0.000000]   6 base 0200000000 m=
ask 7F80000000 write-back
May 16 14:46:43 brian-laptop kernel: [    0.000000]   7 base 025F600000 m=
ask 7FFFE00000 uncachable
May 16 14:46:43 brian-laptop kernel: [    0.000000]   8 base 025F800000 m=
ask 7FFF800000 uncachable
May 16 14:46:43 brian-laptop kernel: [    0.000000]   9 base 0260000000 m=
ask 7FE0000000 uncachable
May 16 14:46:43 brian-laptop kernel: [    0.000000] x86 PAT enabled: cpu =
0, old 0x7040600070406, new 0x7010600070106
May 16 14:46:43 brian-laptop kernel: [    0.000000] e820: last_pfn =3D 0x=
9d000 max_arch_pfn =3D 0x400000000
May 16 14:46:43 brian-laptop kernel: [    0.000000] found SMP MP-table at=
 [mem 0x000fe1b0-0x000fe1bf] mapped at [ffff8800000fe1b0]
May 16 14:46:43 brian-laptop kernel: [    0.000000] Scanning 1 areas for =
low memory corruption
May 16 14:46:43 brian-laptop kernel: [    0.000000] Base memory trampolin=
e at [ffff880000024000] 24000 size 24576
May 16 14:46:43 brian-laptop kernel: [    0.000000] Using GB pages for di=
rect mapping
May 16 14:46:43 brian-laptop kernel: [    0.000000] init_memory_mapping: =
[mem 0x00000000-0x000fffff]
May 16 14:46:43 brian-laptop kernel: [    0.000000]  [mem 0x00000000-0x00=
0fffff] page 4k
May 16 14:46:43 brian-laptop kernel: [    0.000000] BRK [0x02fdd000, 0x02=
fddfff] PGTABLE
May 16 14:46:43 brian-laptop kernel: [    0.000000] BRK [0x02fde000, 0x02=
fdefff] PGTABLE
May 16 14:46:43 brian-laptop kernel: [    0.000000] BRK [0x02fdf000, 0x02=
fdffff] PGTABLE
May 16 14:46:43 brian-laptop kernel: [    0.000000] init_memory_mapping: =
[mem 0x25f400000-0x25f5fffff]
May 16 14:46:43 brian-laptop kernel: [    0.000000]  [mem 0x25f400000-0x2=
5f5fffff] page 2M
May 16 14:46:43 brian-laptop kernel: [    0.000000] BRK [0x02fe0000, 0x02=
fe0fff] PGTABLE
May 16 14:46:43 brian-laptop kernel: [    0.000000] init_memory_mapping: =
[mem 0x25c000000-0x25f3fffff]
May 16 14:46:43 brian-laptop kernel: [    0.000000]  [mem 0x25c000000-0x2=
5f3fffff] page 2M
May 16 14:46:43 brian-laptop kernel: [    0.000000] init_memory_mapping: =
[mem 0x200000000-0x25bffffff]
May 16 14:46:43 brian-laptop kernel: [    0.000000]  [mem 0x200000000-0x2=
3fffffff] page 1G
May 16 14:46:43 brian-laptop kernel: [    0.000000]  [mem 0x240000000-0x2=
5bffffff] page 2M
May 16 14:46:43 brian-laptop kernel: [    0.000000] init_memory_mapping: =
[mem 0x00100000-0x7a8fffff]
May 16 14:46:43 brian-laptop kernel: [    0.000000]  [mem 0x00100000-0x00=
1fffff] page 4k
May 16 14:46:43 brian-laptop kernel: [    0.000000]  [mem 0x00200000-0x7a=
7fffff] page 2M
May 16 14:46:43 brian-laptop kernel: [    0.000000]  [mem 0x7a800000-0x7a=
8fffff] page 4k
May 16 14:46:43 brian-laptop kernel: [    0.000000] init_memory_mapping: =
[mem 0x7bd00000-0x9c6befff]
May 16 14:46:43 brian-laptop kernel: [    0.000000]  [mem 0x7bd00000-0x7b=
dfffff] page 4k
May 16 14:46:43 brian-laptop kernel: [    0.000000]  [mem 0x7be00000-0x9c=
5fffff] page 2M
May 16 14:46:43 brian-laptop kernel: [    0.000000]  [mem 0x9c600000-0x9c=
6befff] page 4k
May 16 14:46:43 brian-laptop kernel: [    0.000000] BRK [0x02fe1000, 0x02=
fe1fff] PGTABLE
May 16 14:46:43 brian-laptop kernel: [    0.000000] BRK [0x02fe2000, 0x02=
fe2fff] PGTABLE
May 16 14:46:43 brian-laptop kernel: [    0.000000] init_memory_mapping: =
[mem 0x9cfff000-0x9cffffff]
May 16 14:46:43 brian-laptop kernel: [    0.000000]  [mem 0x9cfff000-0x9c=
ffffff] page 4k
May 16 14:46:43 brian-laptop kernel: [    0.000000] init_memory_mapping: =
[mem 0x100000000-0x1ffffffff]
May 16 14:46:43 brian-laptop kernel: [    0.000000]  [mem 0x100000000-0x1=
ffffffff] page 1G
May 16 14:46:43 brian-laptop kernel: [    0.000000] RAMDISK: [mem 0x35b9c=
000-0x36dc5fff]
May 16 14:46:43 brian-laptop kernel: [    0.000000] ACPI: RSDP 000000009c=
ffe014 000024 (v02 LENOVO)
May 16 14:46:43 brian-laptop kernel: [    0.000000] ACPI: XSDT 000000009c=
ffe210 0000C4 (v01 LENOVO CB-01    00000001      01000013)
May 16 14:46:43 brian-laptop kernel: [    0.000000] ACPI: FACP 000000009c=
feb000 00010C (v05 LENOVO CB-01    00000001 ACPI 00040000)
May 16 14:46:43 brian-laptop kernel: [    0.000000] ACPI Error: Gpe0Block=
 - 32-bit FADT register is too long (32 bytes, 256 bits) to convert to GA=
S struct - 255 bits max, truncating (20131115/tbfadt-202)
May 16 14:46:43 brian-laptop kernel: [    0.000000] ACPI: DSDT 000000009c=
fda000 00D0CA (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 14:46:43 brian-laptop kernel: [    0.000000] ACPI: FACS 000000009c=
fba000 000040
May 16 14:46:43 brian-laptop kernel: [    0.000000] ACPI: SLIC 000000009c=
ffd000 000176 (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 14:46:43 brian-laptop kernel: [    0.000000] ACPI: UEFI 000000009c=
ffc000 000236 (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 14:46:43 brian-laptop kernel: [    0.000000] ACPI: SSDT 000000009c=
ff0000 00B0FA (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 14:46:43 brian-laptop kernel: [    0.000000] ACPI: FPDT 000000009c=
fee000 000044 (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 14:46:43 brian-laptop kernel: [    0.000000] ACPI: MSDM 000000009c=
fed000 000055 (v03 LENOVO CB-01    00000001 ACPI 00040000)
May 16 14:46:43 brian-laptop kernel: [    0.000000] ACPI: ASF! 000000009c=
fec000 0000A5 (v32 LENOVO CB-01    00000001 ACPI 00040000)
May 16 14:46:43 brian-laptop kernel: [    0.000000] ACPI: HPET 000000009c=
fea000 000038 (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 14:46:43 brian-laptop kernel: [    0.000000] ACPI: APIC 000000009c=
fe9000 00008C (v03 LENOVO CB-01    00000001 ACPI 00040000)
May 16 14:46:43 brian-laptop kernel: [    0.000000] ACPI: MCFG 000000009c=
fe8000 00003C (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 14:46:43 brian-laptop kernel: [    0.000000] ACPI: SSDT 000000009c=
fd7000 002028 (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 14:46:43 brian-laptop kernel: [    0.000000] ACPI: BOOT 000000009c=
fd5000 000028 (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 14:46:43 brian-laptop kernel: [    0.000000] ACPI: LPIT 000000009c=
fd4000 000094 (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 14:46:43 brian-laptop kernel: [    0.000000] ACPI: ASPT 000000009c=
fd2000 000034 (v07 LENOVO CB-01    00000001 ACPI 00040000)
May 16 14:46:43 brian-laptop kernel: [    0.000000] ACPI: DBGP 000000009c=
fd1000 000034 (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 14:46:43 brian-laptop kernel: [    0.000000] ACPI: SSDT 000000009c=
fce000 000539 (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 14:46:43 brian-laptop kernel: [    0.000000] ACPI: SSDT 000000009c=
fcd000 000AD8 (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 14:46:43 brian-laptop kernel: [    0.000000] ACPI: SSDT 000000009c=
fc9000 003496 (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 14:46:43 brian-laptop kernel: [    0.000000] ACPI: SSDT 000000009c=
fc8000 0007C7 (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 14:46:43 brian-laptop kernel: [    0.000000] ACPI: BGRT 000000009c=
fc7000 000038 (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 14:46:43 brian-laptop kernel: [    0.000000] ACPI: Local APIC addr=
ess 0xfee00000
May 16 14:46:43 brian-laptop kernel: [    0.000000] No NUMA configuration=
 found
May 16 14:46:43 brian-laptop kernel: [    0.000000] Faking a node at [mem=
 0x0000000000000000-0x000000025f5fffff]
May 16 14:46:43 brian-laptop kernel: [    0.000000] Initmem setup node 0 =
[mem 0x00000000-0x25f5fffff]
May 16 14:46:43 brian-laptop kernel: [    0.000000]   NODE_DATA [mem 0x25=
f5f7000-0x25f5fbfff]
May 16 14:46:43 brian-laptop kernel: [    0.000000]  [ffffea0000000000-ff=
ffea00097fffff] PMD -> [ffff880256c00000-ffff88025ebfffff] on node 0
May 16 14:46:43 brian-laptop kernel: [    0.000000] Zone ranges:
May 16 14:46:43 brian-laptop kernel: [    0.000000]   DMA      [mem 0x000=
01000-0x00ffffff]
May 16 14:46:43 brian-laptop kernel: [    0.000000]   DMA32    [mem 0x010=
00000-0xffffffff]
May 16 14:46:43 brian-laptop kernel: [    0.000000]   Normal   [mem 0x100=
000000-0x25f5fffff]
May 16 14:46:43 brian-laptop kernel: [    0.000000] Movable zone start fo=
r each node
May 16 14:46:43 brian-laptop kernel: [    0.000000] Early memory node ran=
ges
May 16 14:46:43 brian-laptop kernel: [    0.000000]   node   0: [mem 0x00=
001000-0x0006efff]
May 16 14:46:43 brian-laptop kernel: [    0.000000]   node   0: [mem 0x00=
070000-0x00087fff]
May 16 14:46:43 brian-laptop kernel: [    0.000000]   node   0: [mem 0x00=
100000-0x7a8fffff]
May 16 14:46:43 brian-laptop kernel: [    0.000000]   node   0: [mem 0x7b=
d00000-0x9c6befff]
May 16 14:46:43 brian-laptop kernel: [    0.000000]   node   0: [mem 0x9c=
fff000-0x9cffffff]
May 16 14:46:43 brian-laptop kernel: [    0.000000]   node   0: [mem 0x10=
0000000-0x25f5fffff]
May 16 14:46:43 brian-laptop kernel: [    0.000000] On node 0 totalpages:=
 2074694
May 16 14:46:43 brian-laptop kernel: [    0.000000]   DMA zone: 64 pages =
used for memmap
May 16 14:46:43 brian-laptop kernel: [    0.000000]   DMA zone: 111 pages=
 reserved
May 16 14:46:43 brian-laptop kernel: [    0.000000]   DMA zone: 3974 page=
s, LIFO batch:0
May 16 14:46:43 brian-laptop kernel: [    0.000000]   DMA32 zone: 9867 pa=
ges used for memmap
May 16 14:46:43 brian-laptop kernel: [    0.000000]   DMA32 zone: 631488 =
pages, LIFO batch:31
May 16 14:46:43 brian-laptop kernel: [    0.000000]   Normal zone: 22488 =
pages used for memmap
May 16 14:46:43 brian-laptop kernel: [    0.000000]   Normal zone: 143923=
2 pages, LIFO batch:31
May 16 14:46:43 brian-laptop kernel: [    0.000000] ACPI: PM-Timer IO Por=
t: 0x1808
May 16 14:46:43 brian-laptop kernel: [    0.000000] ACPI: Local APIC addr=
ess 0xfee00000
May 16 14:46:43 brian-laptop kernel: [    0.000000] ACPI: LAPIC (acpi_id[=
0x01] lapic_id[0x00] enabled)
May 16 14:46:43 brian-laptop kernel: [    0.000000] ACPI: LAPIC (acpi_id[=
0x02] lapic_id[0x01] enabled)
May 16 14:46:43 brian-laptop kernel: [    0.000000] ACPI: LAPIC (acpi_id[=
0x03] lapic_id[0x02] enabled)
May 16 14:46:43 brian-laptop kernel: [    0.000000] ACPI: LAPIC (acpi_id[=
0x04] lapic_id[0x03] enabled)
May 16 14:46:43 brian-laptop kernel: [    0.000000] ACPI: LAPIC (acpi_id[=
0x05] lapic_id[0x00] disabled)
May 16 14:46:43 brian-laptop kernel: [    0.000000] ACPI: LAPIC (acpi_id[=
0x06] lapic_id[0x00] disabled)
May 16 14:46:43 brian-laptop kernel: [    0.000000] ACPI: LAPIC (acpi_id[=
0x07] lapic_id[0x00] disabled)
May 16 14:46:43 brian-laptop kernel: [    0.000000] ACPI: LAPIC (acpi_id[=
0x08] lapic_id[0x00] disabled)
May 16 14:46:43 brian-laptop kernel: [    0.000000] ACPI: IOAPIC (id[0x02=
] address[0xfec00000] gsi_base[0])
May 16 14:46:43 brian-laptop kernel: [    0.000000] IOAPIC[0]: apic_id 2,=
 version 32, address 0xfec00000, GSI 0-39
May 16 14:46:43 brian-laptop kernel: [    0.000000] ACPI: INT_SRC_OVR (bu=
s 0 bus_irq 0 global_irq 2 dfl dfl)
May 16 14:46:43 brian-laptop kernel: [    0.000000] ACPI: INT_SRC_OVR (bu=
s 0 bus_irq 9 global_irq 9 high level)
May 16 14:46:43 brian-laptop kernel: [    0.000000] ACPI: IRQ0 used by ov=
erride.
May 16 14:46:43 brian-laptop kernel: [    0.000000] ACPI: IRQ2 used by ov=
erride.
May 16 14:46:43 brian-laptop kernel: [    0.000000] ACPI: IRQ9 used by ov=
erride.
May 16 14:46:43 brian-laptop kernel: [    0.000000] Using ACPI (MADT) for=
 SMP configuration information
May 16 14:46:43 brian-laptop kernel: [    0.000000] ACPI: HPET id: 0x8086=
a201 base: 0xfed00000
May 16 14:46:43 brian-laptop kernel: [    0.000000] smpboot: Allowing 8 C=
PUs, 4 hotplug CPUs
May 16 14:46:43 brian-laptop kernel: [    0.000000] nr_irqs_gsi: 56
May 16 14:46:43 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0x0006f000-0x0006ffff]
May 16 14:46:43 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0x00088000-0x000bffff]
May 16 14:46:43 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0x000c0000-0x000fffff]
May 16 14:46:43 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0x7a900000-0x7bcfffff]
May 16 14:46:43 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0x9c6bf000-0x9c8befff]
May 16 14:46:43 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0x9c8bf000-0x9cebefff]
May 16 14:46:43 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0x9cebf000-0x9cfbefff]
May 16 14:46:43 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0x9cfbf000-0x9cffefff]
May 16 14:46:43 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0x9d000000-0x9f9fffff]
May 16 14:46:43 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0x9fa00000-0xdfffffff]
May 16 14:46:43 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0xe0000000-0xefffffff]
May 16 14:46:43 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0xf0000000-0xfe100fff]
May 16 14:46:43 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0xfe101000-0xfe112fff]
May 16 14:46:43 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0xfe113000-0xfeafffff]
May 16 14:46:43 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0xfeb00000-0xfeb0ffff]
May 16 14:46:43 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0xfeb10000-0xfebfffff]
May 16 14:46:43 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0xfec00000-0xfec00fff]
May 16 14:46:43 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0xfec01000-0xfecfffff]
May 16 14:46:43 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0xfed00000-0xfee00fff]
May 16 14:46:43 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0xfee01000-0xffbfffff]
May 16 14:46:43 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0xffc00000-0xffffffff]
May 16 14:46:43 brian-laptop kernel: [    0.000000] e820: [mem 0x9fa00000=
-0xdfffffff] available for PCI devices
May 16 14:46:43 brian-laptop kernel: [    0.000000] Booting paravirtualiz=
ed kernel on bare hardware
May 16 14:46:43 brian-laptop kernel: [    0.000000] setup_percpu: NR_CPUS=
:256 nr_cpumask_bits:256 nr_cpu_ids:8 nr_node_ids:1
May 16 14:46:43 brian-laptop kernel: [    0.000000] PERCPU: Embedded 29 p=
ages/cpu @ffff88025f200000 s86336 r8192 d24256 u262144
May 16 14:46:43 brian-laptop kernel: [    0.000000] pcpu-alloc: s86336 r8=
192 d24256 u262144 alloc=3D1*2097152
May 16 14:46:43 brian-laptop kernel: [    0.000000] pcpu-alloc: [0] 0 1 2=
 3 4 5 6 7=20
May 16 14:46:43 brian-laptop kernel: [    0.000000] Built 1 zonelists in =
Zone order, mobility grouping on.  Total pages: 2042164
May 16 14:46:43 brian-laptop kernel: [    0.000000] Policy zone: Normal
May 16 14:46:43 brian-laptop kernel: [    0.000000] Kernel command line: =
BOOT_IMAGE=3D/boot/vmlinuz-3.13.0-24-generic.efi.signed root=3DUUID=3D8e4=
7fdb9-aff2-414b-a81c-2df6486162cd ro acpi_backlight=3Dvendor quiet splash=
 vt.handoff=3D7
May 16 14:46:43 brian-laptop kernel: [    0.000000] PID hash table entrie=
s: 4096 (order: 3, 32768 bytes)
May 16 14:46:43 brian-laptop kernel: [    0.000000] xsave: enabled xstate=
_bv 0x7, cntxt size 0x340
May 16 14:46:43 brian-laptop kernel: [    0.000000] Checking aperture...
May 16 14:46:43 brian-laptop kernel: [    0.000000] No AGP bridge found
May 16 14:46:43 brian-laptop kernel: [    0.000000] Calgary: detecting Ca=
lgary via BIOS EBDA area
May 16 14:46:43 brian-laptop kernel: [    0.000000] Calgary: Unable to lo=
cate Rio Grande table in EBDA - bailing!
May 16 14:46:43 brian-laptop kernel: [    0.000000] Memory: 7949148K/8298=
776K available (7338K kernel code, 1138K rwdata, 3388K rodata, 1332K init=
, 1440K bss, 349628K reserved)
May 16 14:46:43 brian-laptop kernel: [    0.000000] SLUB: HWalign=3D64, O=
rder=3D0-3, MinObjects=3D0, CPUs=3D8, Nodes=3D1
May 16 14:46:43 brian-laptop kernel: [    0.000000] Hierarchical RCU impl=
ementation.
May 16 14:46:43 brian-laptop kernel: [    0.000000] 	RCU dyntick-idle gra=
ce-period acceleration is enabled.
May 16 14:46:43 brian-laptop kernel: [    0.000000] 	RCU restricting CPUs=
 from NR_CPUS=3D256 to nr_cpu_ids=3D8.
May 16 14:46:43 brian-laptop kernel: [    0.000000] 	Offload RCU callback=
s from all CPUs
May 16 14:46:43 brian-laptop kernel: [    0.000000] 	Offload RCU callback=
s from CPUs: 0-7.
May 16 14:46:43 brian-laptop kernel: [    0.000000] NR_IRQS:16640 nr_irqs=
:1016 16
May 16 14:46:43 brian-laptop kernel: [    0.000000] Console: colour dummy=
 device 80x25
May 16 14:46:43 brian-laptop kernel: [    0.000000] console [tty0] enable=
d
May 16 14:46:43 brian-laptop kernel: [    0.000000] allocated 33554432 by=
tes of page_cgroup
May 16 14:46:43 brian-laptop kernel: [    0.000000] please try 'cgroup_di=
sable=3Dmemory' option if you don't want memory cgroups
May 16 14:46:43 brian-laptop kernel: [    0.000000] hpet clockevent regis=
tered
May 16 14:46:43 brian-laptop kernel: [    0.000000] tsc: Fast TSC calibra=
tion failed
May 16 14:46:43 brian-laptop kernel: [    0.008000] tsc: PIT calibration =
matches HPET. 1 loops
May 16 14:46:43 brian-laptop kernel: [    0.008000] tsc: Detected 2394.44=
7 MHz processor
May 16 14:46:43 brian-laptop kernel: [    0.000003] Calibrating delay loo=
p (skipped), value calculated using timer frequency.. 4788.89 BogoMIPS (l=
pj=3D9577788)
May 16 14:46:43 brian-laptop kernel: [    0.000006] pid_max: default: 327=
68 minimum: 301
May 16 14:46:43 brian-laptop kernel: [    0.023269] Security Framework in=
itialized
May 16 14:46:43 brian-laptop kernel: [    0.023293] AppArmor: AppArmor in=
itialized
May 16 14:46:43 brian-laptop kernel: [    0.023294] Yama: becoming mindfu=
l.
May 16 14:46:43 brian-laptop kernel: [    0.024063] Dentry cache hash tab=
le entries: 1048576 (order: 11, 8388608 bytes)
May 16 14:46:43 brian-laptop kernel: [    0.026101] Inode-cache hash tabl=
e entries: 524288 (order: 10, 4194304 bytes)
May 16 14:46:43 brian-laptop kernel: [    0.026958] Mount-cache hash tabl=
e entries: 16384 (order: 5, 131072 bytes)
May 16 14:46:43 brian-laptop kernel: [    0.026973] Mountpoint-cache hash=
 table entries: 16384 (order: 5, 131072 bytes)
May 16 14:46:43 brian-laptop kernel: [    0.027208] Initializing cgroup s=
ubsys memory
May 16 14:46:43 brian-laptop kernel: [    0.027214] Initializing cgroup s=
ubsys devices
May 16 14:46:43 brian-laptop kernel: [    0.027216] Initializing cgroup s=
ubsys freezer
May 16 14:46:43 brian-laptop kernel: [    0.027218] Initializing cgroup s=
ubsys blkio
May 16 14:46:43 brian-laptop kernel: [    0.027219] Initializing cgroup s=
ubsys perf_event
May 16 14:46:43 brian-laptop kernel: [    0.027222] Initializing cgroup s=
ubsys hugetlb
May 16 14:46:43 brian-laptop kernel: [    0.027248] CPU: Physical Process=
or ID: 0
May 16 14:46:43 brian-laptop kernel: [    0.027250] CPU: Processor Core I=
D: 0
May 16 14:46:43 brian-laptop kernel: [    0.027254] ENERGY_PERF_BIAS: Set=
 to 'normal', was 'performance'
May 16 14:46:43 brian-laptop kernel: [    0.027254] ENERGY_PERF_BIAS: Vie=
w and update with x86_energy_perf_policy(8)
May 16 14:46:43 brian-laptop kernel: [    0.028450] mce: CPU supports 7 M=
CE banks
May 16 14:46:43 brian-laptop kernel: [    0.028469] CPU0: Thermal monitor=
ing enabled (TM1)
May 16 14:46:43 brian-laptop kernel: [    0.028481] Last level iTLB entri=
es: 4KB 0, 2MB 0, 4MB 0
May 16 14:46:43 brian-laptop kernel: [    0.028481] Last level dTLB entri=
es: 4KB 64, 2MB 0, 4MB 0
May 16 14:46:43 brian-laptop kernel: [    0.028481] tlb_flushall_shift: 6=

May 16 14:46:43 brian-laptop kernel: [    0.028614] Freeing SMP alternati=
ves memory: 32K (ffffffff81e6b000 - ffffffff81e73000)
May 16 14:46:43 brian-laptop kernel: [    0.029825] ACPI: Core revision 2=
0131115
May 16 14:46:43 brian-laptop kernel: [    0.043447] ACPI: All ACPI Tables=
 successfully acquired
May 16 14:46:43 brian-laptop kernel: [    0.051098] ftrace: allocating 28=
408 entries in 111 pages
May 16 14:46:43 brian-laptop kernel: [    0.067239] ..TIMER: vector=3D0x3=
0 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
May 16 14:46:43 brian-laptop kernel: [    0.106957] smpboot: CPU0: Intel(=
R) Core(TM) i7-4500U CPU @ 1.80GHz (fam: 06, model: 45, stepping: 01)
May 16 14:46:43 brian-laptop kernel: [    0.106967] TSC deadline timer en=
abled
May 16 14:46:43 brian-laptop kernel: [    0.109401] Performance Events: P=
EBS fmt2+, 16-deep LBR, Haswell events, full-width counters, Intel PMU dr=
iver.
May 16 14:46:43 brian-laptop kernel: [    0.109410] ... version:         =
       3
May 16 14:46:43 brian-laptop kernel: [    0.109411] ... bit width:       =
       48
May 16 14:46:43 brian-laptop kernel: [    0.109412] ... generic registers=
:      4
May 16 14:46:43 brian-laptop kernel: [    0.109413] ... value mask:      =
       0000ffffffffffff
May 16 14:46:43 brian-laptop kernel: [    0.109415] ... max period:      =
       0000ffffffffffff
May 16 14:46:43 brian-laptop kernel: [    0.109416] ... fixed-purpose eve=
nts:   3
May 16 14:46:43 brian-laptop kernel: [    0.109417] ... event mask:      =
       000000070000000f
May 16 14:46:43 brian-laptop kernel: [    0.111497] x86: Booting SMP conf=
iguration:
May 16 14:46:43 brian-laptop kernel: [    0.125984] NMI watchdog: enabled=
 on all CPUs, permanently consumes one hw-PMU counter.
May 16 14:46:43 brian-laptop kernel: [    0.111499] .... node  #0, CPUs: =
     #1 #2 #3
May 16 14:46:43 brian-laptop kernel: [    0.154897] x86: Booted up 1 node=
, 4 CPUs
May 16 14:46:43 brian-laptop kernel: [    0.154900] smpboot: Total of 4 p=
rocessors activated (19155.57 BogoMIPS)
May 16 14:46:43 brian-laptop kernel: [    0.160592] devtmpfs: initialized=

May 16 14:46:43 brian-laptop kernel: [    0.163458] EVM: security.selinux=

May 16 14:46:43 brian-laptop kernel: [    0.163459] EVM: security.SMACK64=

May 16 14:46:43 brian-laptop kernel: [    0.163461] EVM: security.ima
May 16 14:46:43 brian-laptop kernel: [    0.163462] EVM: security.capabil=
ity
May 16 14:46:43 brian-laptop kernel: [    0.163519] PM: Registering ACPI =
NVS region [mem 0x9cebf000-0x9cfbefff] (1048576 bytes)
May 16 14:46:43 brian-laptop kernel: [    0.164408] pinctrl core: initial=
ized pinctrl subsystem
May 16 14:46:43 brian-laptop kernel: [    0.164470] regulator-dummy: no p=
arameters
May 16 14:46:43 brian-laptop kernel: [    0.164533] RTC time: 14:46:39, d=
ate: 05/16/14
May 16 14:46:43 brian-laptop kernel: [    0.164569] NET: Registered proto=
col family 16
May 16 14:46:43 brian-laptop kernel: [    0.164682] cpuidle: using govern=
or ladder
May 16 14:46:43 brian-laptop kernel: [    0.164683] cpuidle: using govern=
or menu
May 16 14:46:43 brian-laptop kernel: [    0.164730] ACPI FADT declares th=
e system doesn't support PCIe ASPM, so disable it
May 16 14:46:43 brian-laptop kernel: [    0.164732] ACPI: bus type PCI re=
gistered
May 16 14:46:43 brian-laptop kernel: [    0.164734] acpiphp: ACPI Hot Plu=
g PCI Controller Driver version: 0.5
May 16 14:46:43 brian-laptop kernel: [    0.164806] PCI: MMCONFIG for dom=
ain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
May 16 14:46:43 brian-laptop kernel: [    0.164808] PCI: MMCONFIG at [mem=
 0xe0000000-0xefffffff] reserved in E820
May 16 14:46:43 brian-laptop kernel: [    0.197975] PCI: Using configurat=
ion type 1 for base access
May 16 14:46:43 brian-laptop kernel: [    0.199018] bio: create slab <bio=
-0> at 0
May 16 14:46:43 brian-laptop kernel: [    0.199184] ACPI: Added _OSI(Modu=
le Device)
May 16 14:46:43 brian-laptop kernel: [    0.199186] ACPI: Added _OSI(Proc=
essor Device)
May 16 14:46:43 brian-laptop kernel: [    0.199188] ACPI: Added _OSI(3.0 =
_SCP Extensions)
May 16 14:46:43 brian-laptop kernel: [    0.199190] ACPI: Added _OSI(Proc=
essor Aggregator Device)
May 16 14:46:43 brian-laptop kernel: [    0.206493] ACPI: Executed 1 bloc=
ks of module-level executable AML code
May 16 14:46:43 brian-laptop kernel: [    0.220463] [Firmware Bug]: ACPI:=
 BIOS _OSI(Linux) query ignored
May 16 14:46:43 brian-laptop kernel: [    0.221575] ACPI: SSDT 000000009c=
e7cc18 0003D3 (v01  PmRef  Cpu0Cst 00003001 INTL 20121220)
May 16 14:46:43 brian-laptop kernel: [    0.222473] ACPI: Dynamic OEM Tab=
le Load:
May 16 14:46:43 brian-laptop kernel: [    0.222476] ACPI: SSDT           =
(null) 0003D3 (v01  PmRef  Cpu0Cst 00003001 INTL 20121220)
May 16 14:46:43 brian-laptop kernel: [    0.224733] ACPI: SSDT 000000009c=
e7c618 0005AA (v01  PmRef    ApIst 00003000 INTL 20121220)
May 16 14:46:43 brian-laptop kernel: [    0.225716] ACPI: Dynamic OEM Tab=
le Load:
May 16 14:46:43 brian-laptop kernel: [    0.225719] ACPI: SSDT           =
(null) 0005AA (v01  PmRef    ApIst 00003000 INTL 20121220)
May 16 14:46:43 brian-laptop kernel: [    0.228556] ACPI: SSDT 000000009c=
e86c18 000119 (v01  PmRef    ApCst 00003000 INTL 20121220)
May 16 14:46:43 brian-laptop kernel: [    0.229451] ACPI: Dynamic OEM Tab=
le Load:
May 16 14:46:43 brian-laptop kernel: [    0.229453] ACPI: SSDT           =
(null) 000119 (v01  PmRef    ApCst 00003000 INTL 20121220)
May 16 14:46:43 brian-laptop kernel: [    0.292925] ACPI: Interpreter ena=
bled
May 16 14:46:43 brian-laptop kernel: [    0.292934] ACPI Exception: AE_NO=
T_FOUND, While evaluating Sleep State [\_S1_] (20131115/hwxface-580)
May 16 14:46:43 brian-laptop kernel: [    0.292941] ACPI Exception: AE_NO=
T_FOUND, While evaluating Sleep State [\_S2_] (20131115/hwxface-580)
May 16 14:46:43 brian-laptop kernel: [    0.292963] ACPI: (supports S0 S3=
 S4 S5)
May 16 14:46:43 brian-laptop kernel: [    0.292965] ACPI: Using IOAPIC fo=
r interrupt routing
May 16 14:46:43 brian-laptop kernel: [    0.292997] PCI: Using host bridg=
e windows from ACPI; if necessary, use "pci=3Dnocrs" and report a bug
May 16 14:46:43 brian-laptop kernel: [    0.293280] ACPI: No dock devices=
 found.
May 16 14:46:43 brian-laptop kernel: [    0.305158] ACPI: PCI Root Bridge=
 [PCI0] (domain 0000 [bus 00-fe])
May 16 14:46:43 brian-laptop kernel: [    0.305165] acpi PNP0A08:00: _OSC=
: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
May 16 14:46:43 brian-laptop kernel: [    0.305940] acpi PNP0A08:00: _OSC=
: OS now controls [PCIeHotplug PME AER PCIeCapability]
May 16 14:46:43 brian-laptop kernel: [    0.306938] PCI host bridge to bu=
s 0000:00
May 16 14:46:43 brian-laptop kernel: [    0.306941] pci_bus 0000:00: root=
 bus resource [bus 00-fe]
May 16 14:46:43 brian-laptop kernel: [    0.306943] pci_bus 0000:00: root=
 bus resource [io  0x0000-0x0cf7]
May 16 14:46:43 brian-laptop kernel: [    0.306945] pci_bus 0000:00: root=
 bus resource [io  0x0d00-0xffff]
May 16 14:46:43 brian-laptop kernel: [    0.306948] pci_bus 0000:00: root=
 bus resource [mem 0x000a0000-0x000bffff]
May 16 14:46:43 brian-laptop kernel: [    0.306949] pci_bus 0000:00: root=
 bus resource [mem 0x9fa00000-0xfeafffff]
May 16 14:46:43 brian-laptop kernel: [    0.306959] pci 0000:00:00.0: [80=
86:0a04] type 00 class 0x060000
May 16 14:46:43 brian-laptop kernel: [    0.307161] pci 0000:00:02.0: [80=
86:0a16] type 00 class 0x030000
May 16 14:46:43 brian-laptop kernel: [    0.307177] pci 0000:00:02.0: reg=
 0x10: [mem 0xb0000000-0xb03fffff 64bit]
May 16 14:46:43 brian-laptop kernel: [    0.307185] pci 0000:00:02.0: reg=
 0x18: [mem 0xa0000000-0xafffffff 64bit pref]
May 16 14:46:43 brian-laptop kernel: [    0.307191] pci 0000:00:02.0: reg=
 0x20: [io  0x3000-0x303f]
May 16 14:46:43 brian-laptop kernel: [    0.307381] pci 0000:00:03.0: [80=
86:0a0c] type 00 class 0x040300
May 16 14:46:43 brian-laptop kernel: [    0.307392] pci 0000:00:03.0: reg=
 0x10: [mem 0xb0518000-0xb051bfff 64bit]
May 16 14:46:43 brian-laptop kernel: [    0.307592] pci 0000:00:04.0: [80=
86:0a03] type 00 class 0x118000
May 16 14:46:43 brian-laptop kernel: [    0.307607] pci 0000:00:04.0: reg=
 0x10: [mem 0xb0510000-0xb0517fff 64bit]
May 16 14:46:43 brian-laptop kernel: [    0.307863] pci 0000:00:14.0: [80=
86:9c31] type 00 class 0x0c0330
May 16 14:46:43 brian-laptop kernel: [    0.307912] pci 0000:00:14.0: reg=
 0x10: [mem 0xb0500000-0xb050ffff 64bit]
May 16 14:46:43 brian-laptop kernel: [    0.308075] pci 0000:00:14.0: PME=
# supported from D3hot D3cold
May 16 14:46:43 brian-laptop kernel: [    0.308231] pci 0000:00:14.0: Sys=
tem wakeup disabled by ACPI
May 16 14:46:43 brian-laptop kernel: [    0.308281] pci 0000:00:16.0: [80=
86:9c3a] type 00 class 0x078000
May 16 14:46:43 brian-laptop kernel: [    0.308332] pci 0000:00:16.0: reg=
 0x10: [mem 0xb0520000-0xb052001f 64bit]
May 16 14:46:43 brian-laptop kernel: [    0.308506] pci 0000:00:16.0: PME=
# supported from D0 D3hot D3cold
May 16 14:46:43 brian-laptop kernel: [    0.308743] pci 0000:00:1b.0: [80=
86:9c20] type 00 class 0x040300
May 16 14:46:43 brian-laptop kernel: [    0.308780] pci 0000:00:1b.0: reg=
 0x10: [mem 0xb051c000-0xb051ffff 64bit]
May 16 14:46:43 brian-laptop kernel: [    0.308954] pci 0000:00:1b.0: PME=
# supported from D0 D3hot D3cold
May 16 14:46:43 brian-laptop kernel: [    0.309118] pci 0000:00:1b.0: Sys=
tem wakeup disabled by ACPI
May 16 14:46:43 brian-laptop kernel: [    0.309168] pci 0000:00:1c.0: [80=
86:9c10] type 01 class 0x060400
May 16 14:46:43 brian-laptop kernel: [    0.309358] pci 0000:00:1c.0: PME=
# supported from D0 D3hot D3cold
May 16 14:46:43 brian-laptop kernel: [    0.309528] pci 0000:00:1c.0: Sys=
tem wakeup disabled by ACPI
May 16 14:46:43 brian-laptop kernel: [    0.309597] pci 0000:00:1d.0: [80=
86:9c26] type 00 class 0x0c0320
May 16 14:46:43 brian-laptop kernel: [    0.309645] pci 0000:00:1d.0: reg=
 0x10: [mem 0xb0524000-0xb05243ff]
May 16 14:46:43 brian-laptop kernel: [    0.309862] pci 0000:00:1d.0: PME=
# supported from D0 D3hot D3cold
May 16 14:46:43 brian-laptop kernel: [    0.310039] pci 0000:00:1d.0: Sys=
tem wakeup disabled by ACPI
May 16 14:46:43 brian-laptop kernel: [    0.310089] pci 0000:00:1f.0: [80=
86:9c43] type 00 class 0x060100
May 16 14:46:43 brian-laptop kernel: [    0.310507] pci 0000:00:1f.2: [80=
86:9c03] type 00 class 0x010601
May 16 14:46:43 brian-laptop kernel: [    0.310550] pci 0000:00:1f.2: reg=
 0x10: [io  0x3088-0x308f]
May 16 14:46:43 brian-laptop kernel: [    0.310569] pci 0000:00:1f.2: reg=
 0x14: [io  0x3094-0x3097]
May 16 14:46:43 brian-laptop kernel: [    0.310587] pci 0000:00:1f.2: reg=
 0x18: [io  0x3080-0x3087]
May 16 14:46:43 brian-laptop kernel: [    0.310606] pci 0000:00:1f.2: reg=
 0x1c: [io  0x3090-0x3093]
May 16 14:46:43 brian-laptop kernel: [    0.310624] pci 0000:00:1f.2: reg=
 0x20: [io  0x3060-0x307f]
May 16 14:46:43 brian-laptop kernel: [    0.310643] pci 0000:00:1f.2: reg=
 0x24: [mem 0xb0523000-0xb05237ff]
May 16 14:46:43 brian-laptop kernel: [    0.310750] pci 0000:00:1f.2: PME=
# supported from D3hot
May 16 14:46:43 brian-laptop kernel: [    0.310934] pci 0000:00:1f.3: [80=
86:9c22] type 00 class 0x0c0500
May 16 14:46:43 brian-laptop kernel: [    0.310970] pci 0000:00:1f.3: reg=
 0x10: [mem 0xb0521000-0xb05210ff 64bit]
May 16 14:46:43 brian-laptop kernel: [    0.311023] pci 0000:00:1f.3: reg=
 0x20: [io  0x3040-0x305f]
May 16 14:46:43 brian-laptop kernel: [    0.311257] pci 0000:00:1f.6: [80=
86:9c24] type 00 class 0x118000
May 16 14:46:43 brian-laptop kernel: [    0.311318] pci 0000:00:1f.6: reg=
 0x10: [mem 0xb0522000-0xb0522fff 64bit]
May 16 14:46:43 brian-laptop kernel: [    0.312033] pci 0000:01:00.0: [80=
86:08b2] type 00 class 0x028000
May 16 14:46:43 brian-laptop kernel: [    0.312119] pci 0000:01:00.0: reg=
 0x10: [mem 0xb0400000-0xb0401fff 64bit]
May 16 14:46:43 brian-laptop kernel: [    0.312338] pci 0000:01:00.0: PME=
# supported from D0 D3hot D3cold
May 16 14:46:43 brian-laptop kernel: [    0.312429] pci 0000:01:00.0: Sys=
tem wakeup disabled by ACPI
May 16 14:46:43 brian-laptop kernel: [    0.320782] pci 0000:00:1c.0: PCI=
 bridge to [bus 01]
May 16 14:46:43 brian-laptop kernel: [    0.320793] pci 0000:00:1c.0:   b=
ridge window [mem 0xb0400000-0xb04fffff]
May 16 14:46:43 brian-laptop kernel: [    0.320959] acpi PNP0A08:00: Disa=
bling ASPM (FADT indicates it is unsupported)
May 16 14:46:43 brian-laptop kernel: [    0.322282] ACPI: PCI Interrupt L=
ink [LNKA] (IRQs 3 4 5 6 10 11 12 14 15) *7
May 16 14:46:43 brian-laptop kernel: [    0.322341] ACPI: PCI Interrupt L=
ink [LNKB] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
May 16 14:46:43 brian-laptop kernel: [    0.322397] ACPI: PCI Interrupt L=
ink [LNKC] (IRQs 3 4 5 6 10 *11 12 14 15)
May 16 14:46:43 brian-laptop kernel: [    0.322451] ACPI: PCI Interrupt L=
ink [LNKD] (IRQs 3 4 5 6 *10 11 12 14 15)
May 16 14:46:43 brian-laptop kernel: [    0.322504] ACPI: PCI Interrupt L=
ink [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
May 16 14:46:43 brian-laptop kernel: [    0.322559] ACPI: PCI Interrupt L=
ink [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
May 16 14:46:43 brian-laptop kernel: [    0.322613] ACPI: PCI Interrupt L=
ink [LNKG] (IRQs 3 4 5 6 *10 11 12 14 15)
May 16 14:46:43 brian-laptop kernel: [    0.322667] ACPI: PCI Interrupt L=
ink [LNKH] (IRQs 3 4 5 6 10 *11 12 14 15)
May 16 14:46:43 brian-laptop kernel: [    0.323343] ACPI: Enabled 5 GPEs =
in block 00 to 7F
May 16 14:46:43 brian-laptop kernel: [    0.323351] ACPI: \_SB_.PCI0: not=
ify handler is installed
May 16 14:46:43 brian-laptop kernel: [    0.323460] Found 1 acpi root dev=
ices
May 16 14:46:43 brian-laptop kernel: [    0.323519] ACPI : EC: GPE =3D 0x=
a, I/O: command/status =3D 0x66, data =3D 0x62
May 16 14:46:43 brian-laptop kernel: [    0.323617] vgaarb: device added:=
 PCI:0000:00:02.0,decodes=3Dio+mem,owns=3Dio+mem,locks=3Dnone
May 16 14:46:43 brian-laptop kernel: [    0.323621] vgaarb: loaded
May 16 14:46:43 brian-laptop kernel: [    0.323622] vgaarb: bridge contro=
l possible 0000:00:02.0
May 16 14:46:43 brian-laptop kernel: [    0.323784] SCSI subsystem initia=
lized
May 16 14:46:43 brian-laptop kernel: [    0.323836] libata version 3.00 l=
oaded.
May 16 14:46:43 brian-laptop kernel: [    0.323855] ACPI: bus type USB re=
gistered
May 16 14:46:43 brian-laptop kernel: [    0.323870] usbcore: registered n=
ew interface driver usbfs
May 16 14:46:43 brian-laptop kernel: [    0.323878] usbcore: registered n=
ew interface driver hub
May 16 14:46:43 brian-laptop kernel: [    0.323902] usbcore: registered n=
ew device driver usb
May 16 14:46:43 brian-laptop kernel: [    0.324018] PCI: Using ACPI for I=
RQ routing
May 16 14:46:43 brian-laptop kernel: [    0.329978] PCI: pci_cache_line_s=
ize set to 64 bytes
May 16 14:46:43 brian-laptop kernel: [    0.330018] e820: reserve RAM buf=
fer [mem 0x0006f000-0x0006ffff]
May 16 14:46:43 brian-laptop kernel: [    0.330020] e820: reserve RAM buf=
fer [mem 0x00088000-0x0008ffff]
May 16 14:46:43 brian-laptop kernel: [    0.330021] e820: reserve RAM buf=
fer [mem 0x7a900000-0x7bffffff]
May 16 14:46:43 brian-laptop kernel: [    0.330023] e820: reserve RAM buf=
fer [mem 0x9c6bf000-0x9fffffff]
May 16 14:46:43 brian-laptop kernel: [    0.330025] e820: reserve RAM buf=
fer [mem 0x9d000000-0x9fffffff]
May 16 14:46:43 brian-laptop kernel: [    0.330027] e820: reserve RAM buf=
fer [mem 0x25f600000-0x25fffffff]
May 16 14:46:43 brian-laptop kernel: [    0.330110] NetLabel: Initializin=
g
May 16 14:46:43 brian-laptop kernel: [    0.330111] NetLabel:  domain has=
h size =3D 128
May 16 14:46:43 brian-laptop kernel: [    0.330112] NetLabel:  protocols =
=3D UNLABELED CIPSOv4
May 16 14:46:43 brian-laptop kernel: [    0.330126] NetLabel:  unlabeled =
traffic allowed by default
May 16 14:46:43 brian-laptop kernel: [    0.330185] hpet0: at MMIO 0xfed0=
0000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
May 16 14:46:43 brian-laptop kernel: [    0.330192] hpet0: 8 comparators,=
 64-bit 14.318180 MHz counter
May 16 14:46:43 brian-laptop kernel: [    0.332225] Switched to clocksour=
ce hpet
May 16 14:46:43 brian-laptop kernel: [    0.337720] AppArmor: AppArmor Fi=
lesystem Enabled
May 16 14:46:43 brian-laptop kernel: [    0.337741] pnp: PnP ACPI init
May 16 14:46:43 brian-laptop kernel: [    0.337752] ACPI: bus type PNP re=
gistered
May 16 14:46:43 brian-laptop kernel: [    0.337965] pnp 00:00: [dma 4]
May 16 14:46:43 brian-laptop kernel: [    0.337988] pnp 00:00: Plug and P=
lay ACPI device, IDs PNP0200 (active)
May 16 14:46:43 brian-laptop kernel: [    0.338010] pnp 00:01: Plug and P=
lay ACPI device, IDs INT0800 (active)
May 16 14:46:43 brian-laptop kernel: [    0.338113] pnp 00:02: Plug and P=
lay ACPI device, IDs PNP0103 (active)
May 16 14:46:43 brian-laptop kernel: [    0.338174] system 00:03: [io  0x=
0680-0x069f] has been reserved
May 16 14:46:43 brian-laptop kernel: [    0.338179] system 00:03: [io  0x=
ffff] has been reserved
May 16 14:46:43 brian-laptop kernel: [    0.338181] system 00:03: [io  0x=
ffff] has been reserved
May 16 14:46:43 brian-laptop kernel: [    0.338183] system 00:03: [io  0x=
ffff] has been reserved
May 16 14:46:43 brian-laptop kernel: [    0.338185] system 00:03: [io  0x=
1800-0x18fe] could not be reserved
May 16 14:46:43 brian-laptop kernel: [    0.338187] system 00:03: [io  0x=
164e-0x164f] has been reserved
May 16 14:46:43 brian-laptop kernel: [    0.338190] system 00:03: Plug an=
d Play ACPI device, IDs PNP0c02 (active)
May 16 14:46:43 brian-laptop kernel: [    0.338235] pnp 00:04: Plug and P=
lay ACPI device, IDs PNP0b00 (active)
May 16 14:46:43 brian-laptop kernel: [    0.338282] system 00:05: [io  0x=
1854-0x1857] has been reserved
May 16 14:46:43 brian-laptop kernel: [    0.338285] system 00:05: Plug an=
d Play ACPI device, IDs INT3f0d PNP0c02 (active)
May 16 14:46:43 brian-laptop kernel: [    0.338324] pnp 00:06: Plug and P=
lay ACPI device, IDs PNP0303 (active)
May 16 14:46:43 brian-laptop kernel: [    0.338354] pnp 00:07: Plug and P=
lay ACPI device, IDs SYN2b2c SYN2b00 SYN0002 PNP0f13 (active)
May 16 14:46:43 brian-laptop kernel: [    0.338500] system 00:08: [mem 0x=
fed1c000-0xfed1ffff] has been reserved
May 16 14:46:43 brian-laptop kernel: [    0.338505] system 00:08: [mem 0x=
fed10000-0xfed17fff] has been reserved
May 16 14:46:43 brian-laptop kernel: [    0.338507] system 00:08: [mem 0x=
fed18000-0xfed18fff] has been reserved
May 16 14:46:43 brian-laptop kernel: [    0.338509] system 00:08: [mem 0x=
fed19000-0xfed19fff] has been reserved
May 16 14:46:43 brian-laptop kernel: [    0.338512] system 00:08: [mem 0x=
e0000000-0xefffffff] has been reserved
May 16 14:46:43 brian-laptop kernel: [    0.338514] system 00:08: [mem 0x=
fed20000-0xfed3ffff] has been reserved
May 16 14:46:43 brian-laptop kernel: [    0.338516] system 00:08: [mem 0x=
fed90000-0xfed93fff] has been reserved
May 16 14:46:43 brian-laptop kernel: [    0.338518] system 00:08: [mem 0x=
ff000000-0xffffffff] could not be reserved
May 16 14:46:43 brian-laptop kernel: [    0.338521] system 00:08: [mem 0x=
fee00000-0xfeefffff] could not be reserved
May 16 14:46:43 brian-laptop kernel: [    0.338523] system 00:08: [mem 0x=
9fa20000-0x9fa20fff] has been reserved
May 16 14:46:43 brian-laptop kernel: [    0.338525] system 00:08: [mem 0x=
9fa10000-0x9fa1ffff] has been reserved
May 16 14:46:43 brian-laptop kernel: [    0.338528] system 00:08: Plug an=
d Play ACPI device, IDs PNP0c02 (active)
May 16 14:46:43 brian-laptop kernel: [    0.338846] system 00:09: Plug an=
d Play ACPI device, IDs PNP0c02 (active)
May 16 14:46:43 brian-laptop kernel: [    0.339388] pnp: PnP ACPI: found =
10 devices
May 16 14:46:43 brian-laptop kernel: [    0.339390] ACPI: bus type PNP un=
registered
May 16 14:46:43 brian-laptop kernel: [    0.345598] pci 0000:00:1c.0: PCI=
 bridge to [bus 01]
May 16 14:46:43 brian-laptop kernel: [    0.345604] pci 0000:00:1c.0:   b=
ridge window [mem 0xb0400000-0xb04fffff]
May 16 14:46:43 brian-laptop kernel: [    0.345613] pci_bus 0000:00: reso=
urce 4 [io  0x0000-0x0cf7]
May 16 14:46:43 brian-laptop kernel: [    0.345615] pci_bus 0000:00: reso=
urce 5 [io  0x0d00-0xffff]
May 16 14:46:43 brian-laptop kernel: [    0.345617] pci_bus 0000:00: reso=
urce 6 [mem 0x000a0000-0x000bffff]
May 16 14:46:43 brian-laptop kernel: [    0.345619] pci_bus 0000:00: reso=
urce 7 [mem 0x9fa00000-0xfeafffff]
May 16 14:46:43 brian-laptop kernel: [    0.345622] pci_bus 0000:01: reso=
urce 1 [mem 0xb0400000-0xb04fffff]
May 16 14:46:43 brian-laptop kernel: [    0.345654] NET: Registered proto=
col family 2
May 16 14:46:43 brian-laptop kernel: [    0.345848] TCP established hash =
table entries: 65536 (order: 7, 524288 bytes)
May 16 14:46:43 brian-laptop kernel: [    0.346026] TCP bind hash table e=
ntries: 65536 (order: 8, 1048576 bytes)
May 16 14:46:43 brian-laptop kernel: [    0.346156] TCP: Hash tables conf=
igured (established 65536 bind 65536)
May 16 14:46:43 brian-laptop kernel: [    0.346175] TCP: reno registered
May 16 14:46:43 brian-laptop kernel: [    0.346190] UDP hash table entrie=
s: 4096 (order: 5, 131072 bytes)
May 16 14:46:43 brian-laptop kernel: [    0.346223] UDP-Lite hash table e=
ntries: 4096 (order: 5, 131072 bytes)
May 16 14:46:43 brian-laptop kernel: [    0.346296] NET: Registered proto=
col family 1
May 16 14:46:43 brian-laptop kernel: [    0.346309] pci 0000:00:02.0: Boo=
t video device
May 16 14:46:43 brian-laptop kernel: [    0.360378] PCI: CLS 64 bytes, de=
fault 64
May 16 14:46:43 brian-laptop kernel: [    0.360437] Trying to unpack root=
fs image as initramfs...
May 16 14:46:43 brian-laptop kernel: [    0.739414] Freeing initrd memory=
: 18600K (ffff880035b9c000 - ffff880036dc6000)
May 16 14:46:43 brian-laptop kernel: [    0.739419] PCI-DMA: Using softwa=
re bounce buffering for IO (SWIOTLB)
May 16 14:46:43 brian-laptop kernel: [    0.739422] software IO TLB [mem =
0x982c6000-0x9c2c6000] (64MB) mapped at [ffff8800982c6000-ffff88009c2c5ff=
f]
May 16 14:46:43 brian-laptop kernel: [    0.739461] Simple Boot Flag at 0=
x44 set to 0x1
May 16 14:46:43 brian-laptop kernel: [    0.739621] microcode: CPU0 sig=3D=
0x40651, pf=3D0x40, revision=3D0x14
May 16 14:46:43 brian-laptop kernel: [    0.739627] microcode: CPU1 sig=3D=
0x40651, pf=3D0x40, revision=3D0x14
May 16 14:46:43 brian-laptop kernel: [    0.739635] microcode: CPU2 sig=3D=
0x40651, pf=3D0x40, revision=3D0x14
May 16 14:46:43 brian-laptop kernel: [    0.739643] microcode: CPU3 sig=3D=
0x40651, pf=3D0x40, revision=3D0x14
May 16 14:46:43 brian-laptop kernel: [    0.739689] microcode: Microcode =
Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
May 16 14:46:43 brian-laptop kernel: [    0.739691] Scanning for low memo=
ry corruption every 60 seconds
May 16 14:46:43 brian-laptop kernel: [    0.739965] Initialise system tru=
sted keyring
May 16 14:46:43 brian-laptop kernel: [    0.740011] audit: initializing n=
etlink socket (disabled)
May 16 14:46:43 brian-laptop kernel: [    0.740021] type=3D2000 audit(140=
0251599.728:1): initialized
May 16 14:46:43 brian-laptop kernel: [    0.774168] HugeTLB registered 2 =
MB page size, pre-allocated 0 pages
May 16 14:46:43 brian-laptop kernel: [    0.775550] VFS: Disk quotas dquo=
t_6.5.2
May 16 14:46:43 brian-laptop kernel: [    0.775592] Dquot-cache hash tabl=
e entries: 512 (order 0, 4096 bytes)
May 16 14:46:43 brian-laptop kernel: [    0.776007] fuse init (API versio=
n 7.22)
May 16 14:46:43 brian-laptop kernel: [    0.776079] msgmni has been set t=
o 15789
May 16 14:46:43 brian-laptop kernel: [    0.776132] Key type big_key regi=
stered
May 16 14:46:43 brian-laptop kernel: [    0.776474] Key type asymmetric r=
egistered
May 16 14:46:43 brian-laptop kernel: [    0.776476] Asymmetric key parser=
 'x509' registered
May 16 14:46:43 brian-laptop kernel: [    0.776507] Block layer SCSI gene=
ric (bsg) driver version 0.4 loaded (major 252)
May 16 14:46:43 brian-laptop kernel: [    0.776542] io scheduler noop reg=
istered
May 16 14:46:43 brian-laptop kernel: [    0.776545] io scheduler deadline=
 registered (default)
May 16 14:46:43 brian-laptop kernel: [    0.776567] io scheduler cfq regi=
stered
May 16 14:46:43 brian-laptop kernel: [    0.776799] pcieport 0000:00:1c.0=
: irq 56 for MSI/MSI-X
May 16 14:46:43 brian-laptop kernel: [    0.776884] pcieport 0000:00:1c.0=
: Signaling PME through PCIe PME interrupt
May 16 14:46:43 brian-laptop kernel: [    0.776886] pci 0000:01:00.0: Sig=
naling PME through PCIe PME interrupt
May 16 14:46:43 brian-laptop kernel: [    0.776890] pcie_pme 0000:00:1c.0=
:pcie01: service driver pcie_pme loaded
May 16 14:46:43 brian-laptop kernel: [    0.776901] pci_hotplug: PCI Hot =
Plug PCI Core version: 0.5
May 16 14:46:43 brian-laptop kernel: [    0.776915] pciehp: PCI Express H=
ot Plug Controller Driver version: 0.4
May 16 14:46:43 brian-laptop kernel: [    0.776957] efifb: probing for ef=
ifb
May 16 14:46:43 brian-laptop kernel: [    0.779872] efifb: framebuffer at=
 0xa0000000, mapped to 0xffffc90010f00000, using 22528k, total 22528k
May 16 14:46:43 brian-laptop kernel: [    0.779874] efifb: mode is 3200x1=
800x32, linelength=3D12800, pages=3D1
May 16 14:46:43 brian-laptop kernel: [    0.779875] efifb: scrolling: red=
raw
May 16 14:46:43 brian-laptop kernel: [    0.779878] efifb: Truecolor: siz=
e=3D8:8:8:8, shift=3D24:16:8:0
May 16 14:46:43 brian-laptop kernel: [    0.796926] Console: switching to=
 colour frame buffer device 400x112
May 16 14:46:43 brian-laptop kernel: [    0.814272] fb0: EFI VGA frame bu=
ffer device
May 16 14:46:43 brian-laptop kernel: [    0.814286] intel_idle: MWAIT sub=
states: 0x11142120
May 16 14:46:43 brian-laptop kernel: [    0.814288] intel_idle: v0.4 mode=
l 0x45
May 16 14:46:43 brian-laptop kernel: [    0.814289] intel_idle: lapic_tim=
er_reliable_states 0xffffffff
May 16 14:46:43 brian-laptop kernel: [    0.814436] ipmi message handler =
version 39.2
May 16 14:46:43 brian-laptop kernel: [    0.814518] ACPI: AC Adapter [ADP=
1] (on-line)
May 16 14:46:43 brian-laptop kernel: [    0.814610] input: Lid Switch as =
/devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
May 16 14:46:43 brian-laptop kernel: [    0.814631] ACPI: Lid Switch [LID=
0]
May 16 14:46:43 brian-laptop kernel: [    0.814664] input: Power Button a=
s /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
May 16 14:46:43 brian-laptop kernel: [    0.814668] ACPI: Power Button [P=
WRB]
May 16 14:46:43 brian-laptop kernel: [    0.814698] input: Power Button a=
s /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
May 16 14:46:43 brian-laptop kernel: [    0.814701] ACPI: Power Button [P=
WRF]
May 16 14:46:43 brian-laptop kernel: [    0.816585] thermal LNXTHERM:00: =
registered as thermal_zone0
May 16 14:46:43 brian-laptop kernel: [    0.816589] ACPI: Thermal Zone [T=
Z01] (55 C)
May 16 14:46:43 brian-laptop kernel: [    0.816640] GHES: HEST is not ena=
bled!
May 16 14:46:43 brian-laptop kernel: [    0.816727] Serial: 8250/16550 dr=
iver, 32 ports, IRQ sharing enabled
May 16 14:46:43 brian-laptop kernel: [    0.818678] Linux agpgart interfa=
ce v0.103
May 16 14:46:43 brian-laptop kernel: [    0.819935] brd: module loaded
May 16 14:46:43 brian-laptop kernel: [    0.820820] loop: module loaded
May 16 14:46:43 brian-laptop kernel: [    0.821173] libphy: Fixed MDIO Bu=
s: probed
May 16 14:46:43 brian-laptop kernel: [    0.821267] tun: Universal TUN/TA=
P device driver, 1.6
May 16 14:46:43 brian-laptop kernel: [    0.821269] tun: (C) 1999-2004 Ma=
x Krasnyansky <maxk@qualcomm.com>
May 16 14:46:43 brian-laptop kernel: [    0.821313] PPP generic driver ve=
rsion 2.4.2
May 16 14:46:43 brian-laptop kernel: [    0.821353] ehci_hcd: USB 2.0 'En=
hanced' Host Controller (EHCI) Driver
May 16 14:46:43 brian-laptop kernel: [    0.821357] ehci-pci: EHCI PCI pl=
atform driver
May 16 14:46:43 brian-laptop kernel: [    0.821503] ehci-pci 0000:00:1d.0=
: EHCI Host Controller
May 16 14:46:43 brian-laptop kernel: [    0.821509] ehci-pci 0000:00:1d.0=
: new USB bus registered, assigned bus number 1
May 16 14:46:43 brian-laptop kernel: [    0.821522] ehci-pci 0000:00:1d.0=
: debug port 2
May 16 14:46:43 brian-laptop kernel: [    0.821864] ACPI: Battery Slot [B=
AT1] (battery present)
May 16 14:46:43 brian-laptop kernel: [    0.825431] ehci-pci 0000:00:1d.0=
: cache line size of 64 is not supported
May 16 14:46:43 brian-laptop kernel: [    0.825457] ehci-pci 0000:00:1d.0=
: irq 23, io mem 0xb0524000
May 16 14:46:43 brian-laptop kernel: [    0.836644] ehci-pci 0000:00:1d.0=
: USB 2.0 started, EHCI 1.00
May 16 14:46:43 brian-laptop kernel: [    0.836693] usb usb1: New USB dev=
ice found, idVendor=3D1d6b, idProduct=3D0002
May 16 14:46:43 brian-laptop kernel: [    0.836695] usb usb1: New USB dev=
ice strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
May 16 14:46:43 brian-laptop kernel: [    0.836697] usb usb1: Product: EH=
CI Host Controller
May 16 14:46:43 brian-laptop kernel: [    0.836699] usb usb1: Manufacture=
r: Linux 3.13.0-24-generic ehci_hcd
May 16 14:46:43 brian-laptop kernel: [    0.836701] usb usb1: SerialNumbe=
r: 0000:00:1d.0
May 16 14:46:43 brian-laptop kernel: [    0.836815] hub 1-0:1.0: USB hub =
found
May 16 14:46:43 brian-laptop kernel: [    0.836823] hub 1-0:1.0: 2 ports =
detected
May 16 14:46:43 brian-laptop kernel: [    0.836938] ehci-platform: EHCI g=
eneric platform driver
May 16 14:46:43 brian-laptop kernel: [    0.836945] ohci_hcd: USB 1.1 'Op=
en' Host Controller (OHCI) Driver
May 16 14:46:43 brian-laptop kernel: [    0.836947] ohci-pci: OHCI PCI pl=
atform driver
May 16 14:46:43 brian-laptop kernel: [    0.836955] ohci-platform: OHCI g=
eneric platform driver
May 16 14:46:43 brian-laptop kernel: [    0.836962] uhci_hcd: USB Univers=
al Host Controller Interface driver
May 16 14:46:43 brian-laptop kernel: [    0.837100] xhci_hcd 0000:00:14.0=
: xHCI Host Controller
May 16 14:46:43 brian-laptop kernel: [    0.837105] xhci_hcd 0000:00:14.0=
: new USB bus registered, assigned bus number 2
May 16 14:46:43 brian-laptop kernel: [    0.837184] xhci_hcd 0000:00:14.0=
: cache line size of 64 is not supported
May 16 14:46:43 brian-laptop kernel: [    0.837203] xhci_hcd 0000:00:14.0=
: irq 57 for MSI/MSI-X
May 16 14:46:43 brian-laptop kernel: [    0.837266] usb usb2: New USB dev=
ice found, idVendor=3D1d6b, idProduct=3D0002
May 16 14:46:43 brian-laptop kernel: [    0.837268] usb usb2: New USB dev=
ice strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
May 16 14:46:43 brian-laptop kernel: [    0.837270] usb usb2: Product: xH=
CI Host Controller
May 16 14:46:43 brian-laptop kernel: [    0.837272] usb usb2: Manufacture=
r: Linux 3.13.0-24-generic xhci_hcd
May 16 14:46:43 brian-laptop kernel: [    0.837273] usb usb2: SerialNumbe=
r: 0000:00:14.0
May 16 14:46:43 brian-laptop kernel: [    0.837386] hub 2-0:1.0: USB hub =
found
May 16 14:46:43 brian-laptop kernel: [    0.837398] hub 2-0:1.0: 9 ports =
detected
May 16 14:46:43 brian-laptop kernel: [    0.839684] xhci_hcd 0000:00:14.0=
: xHCI Host Controller
May 16 14:46:43 brian-laptop kernel: [    0.839689] xhci_hcd 0000:00:14.0=
: new USB bus registered, assigned bus number 3
May 16 14:46:43 brian-laptop kernel: [    0.839729] usb usb3: New USB dev=
ice found, idVendor=3D1d6b, idProduct=3D0003
May 16 14:46:43 brian-laptop kernel: [    0.839731] usb usb3: New USB dev=
ice strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
May 16 14:46:43 brian-laptop kernel: [    0.839733] usb usb3: Product: xH=
CI Host Controller
May 16 14:46:43 brian-laptop kernel: [    0.839735] usb usb3: Manufacture=
r: Linux 3.13.0-24-generic xhci_hcd
May 16 14:46:43 brian-laptop kernel: [    0.839737] usb usb3: SerialNumbe=
r: 0000:00:14.0
May 16 14:46:43 brian-laptop kernel: [    0.839840] hub 3-0:1.0: USB hub =
found
May 16 14:46:43 brian-laptop kernel: [    0.839849] hub 3-0:1.0: 4 ports =
detected
May 16 14:46:43 brian-laptop kernel: [    0.848757] i8042: PNP: PS/2 Cont=
roller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
May 16 14:46:43 brian-laptop kernel: [    0.861084] serio: i8042 KBD port=
 at 0x60,0x64 irq 1
May 16 14:46:43 brian-laptop kernel: [    0.861090] serio: i8042 AUX port=
 at 0x60,0x64 irq 12
May 16 14:46:43 brian-laptop kernel: [    0.861365] mousedev: PS/2 mouse =
device common for all mice
May 16 14:46:43 brian-laptop kernel: [    0.861936] rtc_cmos 00:04: RTC c=
an wake from S4
May 16 14:46:43 brian-laptop kernel: [    0.862163] rtc_cmos 00:04: rtc c=
ore: registered rtc_cmos as rtc0
May 16 14:46:43 brian-laptop kernel: [    0.862194] rtc_cmos 00:04: alarm=
s up to one month, 242 bytes nvram, hpet irqs
May 16 14:46:43 brian-laptop kernel: [    0.862254] device-mapper: uevent=
: version 1.0.3
May 16 14:46:43 brian-laptop kernel: [    0.862334] device-mapper: ioctl:=
 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
May 16 14:46:43 brian-laptop kernel: [    0.862341] ledtrig-cpu: register=
ed to indicate activity on CPUs
May 16 14:46:43 brian-laptop kernel: [    0.862343] EFI Variables Facilit=
y v0.08 2004-May-17
May 16 14:46:43 brian-laptop kernel: [    0.874554] input: AT Translated =
Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
May 16 14:46:43 brian-laptop kernel: [    0.904338] TCP: cubic registered=

May 16 14:46:43 brian-laptop kernel: [    0.904430] NET: Registered proto=
col family 10
May 16 14:46:43 brian-laptop kernel: [    0.904604] NET: Registered proto=
col family 17
May 16 14:46:43 brian-laptop kernel: [    0.904613] Key type dns_resolver=
 registered
May 16 14:46:43 brian-laptop kernel: [    0.904920] Loading compiled-in X=
=2E509 certificates
May 16 14:46:43 brian-laptop kernel: [    0.905965] Loaded X.509 cert 'Ma=
grathea: Glacier signing key: 69b0d0a79b85d90621706e8d06604d730b359fc0'
May 16 14:46:43 brian-laptop kernel: [    0.905976] registered taskstats =
version 1
May 16 14:46:43 brian-laptop kernel: [    0.908658] Key type trusted regi=
stered
May 16 14:46:43 brian-laptop kernel: [    0.910889] Key type encrypted re=
gistered
May 16 14:46:43 brian-laptop kernel: [    0.913083] AppArmor: AppArmor sh=
a1 policy hashing enabled
May 16 14:46:43 brian-laptop kernel: [    0.913088] IMA: No TPM chip foun=
d, activating TPM-bypass!
May 16 14:46:43 brian-laptop kernel: [    0.913352] regulator-dummy: disa=
bling
May 16 14:46:43 brian-laptop kernel: [    0.913410]   Magic number: 14:91=
4:788
May 16 14:46:43 brian-laptop kernel: [    0.913508] rtc_cmos 00:04: setti=
ng system clock to 2014-05-16 14:46:40 UTC (1400251600)
May 16 14:46:43 brian-laptop kernel: [    0.914401] BIOS EDD facility v0.=
16 2004-Jun-25, 0 devices found
May 16 14:46:43 brian-laptop kernel: [    0.914403] EDD information not a=
vailable.
May 16 14:46:43 brian-laptop kernel: [    0.914445] PM: Hibernation image=
 not present or could not be loaded.
May 16 14:46:43 brian-laptop kernel: [    0.915180] Freeing unused kernel=
 memory: 1332K (ffffffff81d1e000 - ffffffff81e6b000)
May 16 14:46:43 brian-laptop kernel: [    0.915182] Write protecting the =
kernel read-only data: 12288k
May 16 14:46:43 brian-laptop kernel: [    0.916762] Freeing unused kernel=
 memory: 844K (ffff88000272d000 - ffff880002800000)
May 16 14:46:43 brian-laptop kernel: [    0.917957] Freeing unused kernel=
 memory: 708K (ffff880002b4f000 - ffff880002c00000)
May 16 14:46:43 brian-laptop kernel: [    0.951242] ahci 0000:00:1f.2: ve=
rsion 3.0
May 16 14:46:43 brian-laptop kernel: [    0.951358] ahci 0000:00:1f.2: ir=
q 58 for MSI/MSI-X
May 16 14:46:43 brian-laptop kernel: [    0.964762] ahci 0000:00:1f.2: AH=
CI 0001.0300 32 slots 1 ports 6 Gbps 0x2 impl SATA mode
May 16 14:46:43 brian-laptop kernel: [    0.964767] ahci 0000:00:1f.2: fl=
ags: 64bit ncq pm led clo only pio slum part deso sadm sds apst=20
May 16 14:46:43 brian-laptop kernel: [    0.965003] scsi0 : ahci
May 16 14:46:43 brian-laptop kernel: [    0.965076] scsi1 : ahci
May 16 14:46:43 brian-laptop kernel: [    0.965114] ata1: DUMMY
May 16 14:46:43 brian-laptop kernel: [    0.965117] ata2: SATA max UDMA/1=
33 abar m2048@0xb0523000 port 0xb0523180 irq 58
May 16 14:46:43 brian-laptop kernel: [    1.148989] usb 1-1: new high-spe=
ed USB device number 2 using ehci-pci
May 16 14:46:43 brian-laptop kernel: [    1.281427] usb 1-1: New USB devi=
ce found, idVendor=3D8087, idProduct=3D8000
May 16 14:46:43 brian-laptop kernel: [    1.281431] usb 1-1: New USB devi=
ce strings: Mfr=3D0, Product=3D0, SerialNumber=3D0
May 16 14:46:43 brian-laptop kernel: [    1.281682] hub 1-1:1.0: USB hub =
found
May 16 14:46:43 brian-laptop kernel: [    1.281754] hub 1-1:1.0: 8 ports =
detected
May 16 14:46:43 brian-laptop kernel: [    1.289052] ata2: SATA link up 6.=
0 Gbps (SStatus 133 SControl 300)
May 16 14:46:43 brian-laptop kernel: [    1.289970] ata2.00: ACPI cmd ef/=
10:09:00:00:00:b0 (SET FEATURES) succeeded
May 16 14:46:43 brian-laptop kernel: [    1.290279] ata2.00: failed to ge=
t NCQ Send/Recv Log Emask 0x1
May 16 14:46:43 brian-laptop kernel: [    1.290282] ata2.00: ATA-9: SAMSU=
NG MZMTD256HAGM-000L1, DXT43L0Q, max UDMA/133
May 16 14:46:43 brian-laptop kernel: [    1.290285] ata2.00: 500118192 se=
ctors, multi 16: LBA48 NCQ (depth 31/32), AA
May 16 14:46:43 brian-laptop kernel: [    1.290694] ata2.00: ACPI cmd ef/=
10:09:00:00:00:b0 (SET FEATURES) succeeded
May 16 14:46:43 brian-laptop kernel: [    1.290876] ata2.00: failed to ge=
t NCQ Send/Recv Log Emask 0x1
May 16 14:46:43 brian-laptop kernel: [    1.290933] ata2.00: configured f=
or UDMA/133
May 16 14:46:43 brian-laptop kernel: [    1.291105] scsi 1:0:0:0: Direct-=
Access     ATA      SAMSUNG MZMTD256 DXT4 PQ: 0 ANSI: 5
May 16 14:46:43 brian-laptop kernel: [    1.291253] sd 1:0:0:0: [sda] 500=
118192 512-byte logical blocks: (256 GB/238 GiB)
May 16 14:46:43 brian-laptop kernel: [    1.291278] sd 1:0:0:0: Attached =
scsi generic sg0 type 0
May 16 14:46:43 brian-laptop kernel: [    1.291351] sd 1:0:0:0: [sda] Wri=
te Protect is off
May 16 14:46:43 brian-laptop kernel: [    1.291356] sd 1:0:0:0: [sda] Mod=
e Sense: 00 3a 00 00
May 16 14:46:43 brian-laptop kernel: [    1.291420] sd 1:0:0:0: [sda] Wri=
te cache: enabled, read cache: enabled, doesn't support DPO or FUA
May 16 14:46:43 brian-laptop kernel: [    1.293003]  sda: sda1 sda2 sda3 =
sda4 sda5 sda6 sda7 sda8 sda9
May 16 14:46:43 brian-laptop kernel: [    1.293673] sd 1:0:0:0: [sda] Att=
ached SCSI disk
May 16 14:46:43 brian-laptop kernel: [    1.329215] EXT4-fs (sda9): INFO:=
 recovery required on readonly filesystem
May 16 14:46:43 brian-laptop kernel: [    1.329219] EXT4-fs (sda9): write=
 access will be enabled during recovery
May 16 14:46:43 brian-laptop kernel: [    1.381044] EXT4-fs (sda9): recov=
ery complete
May 16 14:46:43 brian-laptop kernel: [    1.382656] EXT4-fs (sda9): mount=
ed filesystem with ordered data mode. Opts: (null)
May 16 14:46:43 brian-laptop kernel: [    1.446183] random: init urandom =
read with 64 bits of entropy available
May 16 14:46:43 brian-laptop kernel: [    1.453188] usb 2-4: new full-spe=
ed USB device number 2 using xhci_hcd
May 16 14:46:43 brian-laptop kernel: [    1.470227] usb 2-4: New USB devi=
ce found, idVendor=3D8087, idProduct=3D07dc
May 16 14:46:43 brian-laptop kernel: [    1.470231] usb 2-4: New USB devi=
ce strings: Mfr=3D0, Product=3D0, SerialNumber=3D0
May 16 14:46:43 brian-laptop kernel: [    1.617877] Adding 7812092k swap =
on /dev/sda8.  Priority:-1 extents:1 across:7812092k SSFS
May 16 14:46:43 brian-laptop kernel: [    1.637318] usb 2-6: new full-spe=
ed USB device number 3 using xhci_hcd
May 16 14:46:43 brian-laptop kernel: [    1.656984] usb 2-6: New USB devi=
ce found, idVendor=3D2047, idProduct=3D0855
May 16 14:46:43 brian-laptop kernel: [    1.656988] usb 2-6: New USB devi=
ce strings: Mfr=3D1, Product=3D2, SerialNumber=3D3
May 16 14:46:43 brian-laptop kernel: [    1.656991] usb 2-6: Product: Len=
ovo Yoga        =20
May 16 14:46:43 brian-laptop kernel: [    1.656993] usb 2-6: Manufacturer=
: Invensense
May 16 14:46:43 brian-laptop kernel: [    1.656995] usb 2-6: SerialNumber=
: 71F8806F10000000
May 16 14:46:43 brian-laptop kernel: [    1.657084] usb 2-6: ep 0x81 - ro=
unding interval to 128 microframes, ep desc says 160 microframes
May 16 14:46:43 brian-laptop kernel: [    1.657089] usb 2-6: ep 0x1 - rou=
nding interval to 128 microframes, ep desc says 160 microframes
May 16 14:46:43 brian-laptop kernel: [    1.661960] random: nonblocking p=
ool is initialized
May 16 14:46:43 brian-laptop kernel: [    1.693697] lp: driver loaded but=
 no devices found
May 16 14:46:43 brian-laptop kernel: [    1.700058] ppdev: user-space par=
allel port driver
May 16 14:46:43 brian-laptop kernel: [    1.717976] [drm] Initialized drm=
 1.1.0 20060810
May 16 14:46:43 brian-laptop kernel: [    1.737377] tsc: Refined TSC cloc=
ksource calibration: 2394.457 MHz
May 16 14:46:43 brian-laptop kernel: [    1.742545] [drm] Memory usable b=
y graphics device =3D 2048M
May 16 14:46:43 brian-laptop kernel: [    1.742549] checking generic (a00=
00000 1600000) vs hw (a0000000 10000000)
May 16 14:46:43 brian-laptop kernel: [    1.742551] fb: conflicting fb hw=
 usage inteldrmfb vs EFI VGA - removing generic driver
May 16 14:46:43 brian-laptop kernel: [    1.742570] Console: switching to=
 colour dummy device 80x25
May 16 14:46:43 brian-laptop kernel: [    1.760700] EXT4-fs (sda9): re-mo=
unted. Opts: errors=3Dremount-ro
May 16 14:46:43 brian-laptop kernel: [    1.820157] cfg80211: Calling CRD=
A to update world regulatory domain
May 16 14:46:43 brian-laptop kernel: [    1.825459] usb 2-7: new full-spe=
ed USB device number 4 using xhci_hcd
May 16 14:46:43 brian-laptop kernel: [    1.830450] Intel(R) Wireless WiF=
i driver for Linux, in-tree:
May 16 14:46:43 brian-laptop kernel: [    1.830454] Copyright(c) 2003-201=
3 Intel Corporation
May 16 14:46:43 brian-laptop kernel: [    1.830605] iwlwifi 0000:01:00.0:=
 irq 59 for MSI/MSI-X
May 16 14:46:43 brian-laptop kernel: [    1.831375] i915 0000:00:02.0: ir=
q 60 for MSI/MSI-X
May 16 14:46:43 brian-laptop kernel: [    1.831385] [drm] Supports vblank=
 timestamp caching Rev 2 (21.10.2013).
May 16 14:46:43 brian-laptop kernel: [    1.831386] [drm] Driver supports=
 precise vblank timestamp query.
May 16 14:46:43 brian-laptop kernel: [    1.831460] vgaarb: device change=
d decodes: PCI:0000:00:02.0,olddecodes=3Dio+mem,decodes=3Dio+mem:owns=3Di=
o+mem
May 16 14:46:43 brian-laptop kernel: [    1.840466] iwlwifi 0000:01:00.0:=
 loaded firmware version 22.24.8.0 op_mode iwlmvm
May 16 14:46:43 brian-laptop kernel: [    1.864160] iwlwifi 0000:01:00.0:=
 Detected Intel(R) Wireless N 7260, REV=3D0x144
May 16 14:46:43 brian-laptop kernel: [    1.866255] iwlwifi 0000:01:00.0:=
 L1 Disabled; Enabling L0S
May 16 14:46:43 brian-laptop kernel: [    1.866550] iwlwifi 0000:01:00.0:=
 L1 Disabled; Enabling L0S
May 16 14:46:43 brian-laptop kernel: [    1.918880] fbcon: inteldrmfb (fb=
0) is primary device
May 16 14:46:43 brian-laptop kernel: [    1.982106] kvm: disabled by bios=

May 16 14:46:43 brian-laptop kernel: [    2.012977] Bluetooth: Core ver 2=
=2E17
May 16 14:46:43 brian-laptop kernel: [    2.012993] NET: Registered proto=
col family 31
May 16 14:46:43 brian-laptop kernel: [    2.012994] Bluetooth: HCI device=
 and connection manager initialized
May 16 14:46:43 brian-laptop kernel: [    2.013000] Bluetooth: HCI socket=
 layer initialized
May 16 14:46:43 brian-laptop kernel: [    2.013002] Bluetooth: L2CAP sock=
et layer initialized
May 16 14:46:43 brian-laptop kernel: [    2.013005] Bluetooth: SCO socket=
 layer initialized
May 16 14:46:43 brian-laptop kernel: [    2.028924] Bluetooth: BNEP (Ethe=
rnet Emulation) ver 1.3
May 16 14:46:43 brian-laptop kernel: [    2.028925] Bluetooth: BNEP filte=
rs: protocol multicast
May 16 14:46:43 brian-laptop kernel: [    2.028932] Bluetooth: BNEP socke=
t layer initialized
May 16 14:46:43 brian-laptop kernel: [    2.082857] ieee80211 phy0: Selec=
ted rate control algorithm 'iwl-mvm-rs'
May 16 14:46:43 brian-laptop kernel: [    2.145701] intel_rapl: domain un=
core energy ctr 10301:10301 not working, skip
May 16 14:46:43 brian-laptop kernel: [    2.213017] cfg80211: World regul=
atory domain updated:
May 16 14:46:43 brian-laptop kernel: [    2.213018] cfg80211:   (start_fr=
eq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
May 16 14:46:43 brian-laptop kernel: [    2.213019] cfg80211:   (2402000 =
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 14:46:43 brian-laptop kernel: [    2.213020] cfg80211:   (2457000 =
KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 14:46:43 brian-laptop kernel: [    2.213021] cfg80211:   (2474000 =
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
May 16 14:46:43 brian-laptop kernel: [    2.213022] cfg80211:   (5170000 =
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 14:46:43 brian-laptop kernel: [    2.213022] cfg80211:   (5735000 =
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 14:46:43 brian-laptop kernel: [    2.467387] psmouse serio1: synap=
tics: Touchpad model: 1, fw: 8.1, id: 0x1e2b1, caps: 0xd00123/0x840300/0x=
126c00, board id: 2132, fw id: 1180104
May 16 14:46:43 brian-laptop kernel: [    2.521736] input: SynPS/2 Synapt=
ics TouchPad as /devices/platform/i8042/serio1/input/input5
May 16 14:46:43 brian-laptop kernel: [    2.738246] Switched to clocksour=
ce tsc
May 16 14:46:43 brian-laptop kernel: [    3.482822] Console: switching to=
 colour frame buffer device 400x112
May 16 14:46:43 brian-laptop kernel: [    3.506470] i915 0000:00:02.0: fb=
0: inteldrmfb frame buffer device
May 16 14:46:43 brian-laptop kernel: [    3.506471] i915 0000:00:02.0: re=
gistered panic notifier
May 16 14:46:43 brian-laptop kernel: [    3.507516] Bluetooth: RFCOMM TTY=
 layer initialized
May 16 14:46:43 brian-laptop kernel: [    3.507526] Bluetooth: RFCOMM soc=
ket layer initialized
May 16 14:46:43 brian-laptop kernel: [    3.507530] Bluetooth: RFCOMM ver=
 1.11
May 16 14:46:43 brian-laptop kernel: [    3.540280] ACPI: Video Device [G=
FX0] (multi-head: yes  rom: no  post: no)
May 16 14:46:43 brian-laptop kernel: [    3.540510] input: Video Bus as /=
devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input6
May 16 14:46:43 brian-laptop kernel: [    3.542351] [drm] Initialized i91=
5 1.6.0 20080730 for 0000:00:02.0 on minor 0
May 16 14:46:43 brian-laptop kernel: [    3.542760] mei_me 0000:00:16.0: =
irq 61 for MSI/MSI-X
May 16 14:46:43 brian-laptop kernel: [    3.546014] ACPI Warning: 0x00000=
00000001828-0x000000000000182f SystemIO conflicts with Region \PMIO 1 (20=
131115/utaddress-251)
May 16 14:46:43 brian-laptop kernel: [    3.546021] ACPI: If an ACPI driv=
er is available for this device, you should use it instead of the native =
driver
May 16 14:46:43 brian-laptop kernel: [    3.546067] ACPI Warning: 0x00000=
00000000830-0x000000000000083f SystemIO conflicts with Region \GPRL 1 (20=
131115/utaddress-251)
May 16 14:46:43 brian-laptop kernel: [    3.546072] ACPI Warning: 0x00000=
00000000830-0x000000000000083f SystemIO conflicts with Region \GPR_ 2 (20=
131115/utaddress-251)
May 16 14:46:43 brian-laptop kernel: [    3.546076] ACPI: If an ACPI driv=
er is available for this device, you should use it instead of the native =
driver
May 16 14:46:43 brian-laptop kernel: [    3.546077] ACPI Warning: 0x00000=
00000000800-0x000000000000082f SystemIO conflicts with Region \GPRL 1 (20=
131115/utaddress-251)
May 16 14:46:43 brian-laptop kernel: [    3.546081] ACPI Warning: 0x00000=
00000000800-0x000000000000082f SystemIO conflicts with Region \GPR_ 2 (20=
131115/utaddress-251)
May 16 14:46:43 brian-laptop kernel: [    3.546084] ACPI Warning: 0x00000=
00000000800-0x000000000000082f SystemIO conflicts with Region \IO_D 3 (20=
131115/utaddress-251)
May 16 14:46:43 brian-laptop kernel: [    3.546087] ACPI: If an ACPI driv=
er is available for this device, you should use it instead of the native =
driver
May 16 14:46:43 brian-laptop kernel: [    3.546089] lpc_ich: Resource con=
flict(s) found affecting gpio_ich
May 16 14:46:43 brian-laptop kernel: [    3.546276] HDA driver get symbol=
 successfully from i915 module
May 16 14:46:43 brian-laptop kernel: [    3.546427] snd_hda_intel 0000:00=
:1b.0: irq 62 for MSI/MSI-X
May 16 14:46:43 brian-laptop kernel: [    3.550863] snd_hda_intel 0000:00=
:03.0: irq 63 for MSI/MSI-X
May 16 14:46:43 brian-laptop kernel: [    3.556806] SKU: Nid=3D0x1d sku_c=
fg=3D0x40189e2d
May 16 14:46:43 brian-laptop kernel: [    3.556808] SKU: port_connectivit=
y=3D0x1
May 16 14:46:43 brian-laptop kernel: [    3.556809] SKU: enable_pcbeep=3D=
0x1
May 16 14:46:43 brian-laptop kernel: [    3.556810] SKU: check_sum=3D0x00=
000008
May 16 14:46:43 brian-laptop kernel: [    3.556811] SKU: customization=3D=
0x0000009e
May 16 14:46:43 brian-laptop kernel: [    3.556812] SKU: external_amp=3D0=
x5
May 16 14:46:43 brian-laptop kernel: [    3.556812] SKU: platform_type=3D=
0x1
May 16 14:46:43 brian-laptop kernel: [    3.556813] SKU: swap=3D0x0
May 16 14:46:43 brian-laptop kernel: [    3.556814] SKU: override=3D0x1
May 16 14:46:43 brian-laptop kernel: [    3.557016] autoconfig: line_outs=
=3D1 (0x14/0x0/0x0/0x0/0x0) type:speaker
May 16 14:46:43 brian-laptop kernel: [    3.557019]    speaker_outs=3D0 (=
0x0/0x0/0x0/0x0/0x0)
May 16 14:46:43 brian-laptop kernel: [    3.557020]    hp_outs=3D1 (0x21/=
0x0/0x0/0x0/0x0)
May 16 14:46:43 brian-laptop kernel: [    3.557021]    mono: mono_out=3D0=
x0
May 16 14:46:43 brian-laptop kernel: [    3.557022]    inputs:
May 16 14:46:43 brian-laptop kernel: [    3.557024]      Mic=3D0x19
May 16 14:46:43 brian-laptop kernel: [    3.557026]      Internal Mic=3D0=
x12
May 16 14:46:43 brian-laptop kernel: [    3.557027] realtek: No valid SSI=
D, checking pincfg 0x40189e2d for NID 0x1d
May 16 14:46:43 brian-laptop kernel: [    3.557029] realtek: Enabling ini=
t ASM_ID=3D0x9e2d CODEC_ID=3D10ec0283
May 16 14:46:43 brian-laptop kernel: [    3.561951] input: HDA Intel PCH =
Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card1/input8
May 16 14:46:43 brian-laptop kernel: [    3.562018] input: HDA Intel PCH =
Mic as /devices/pci0000:00/0000:00:1b.0/sound/card1/input7
May 16 14:46:43 brian-laptop kernel: [    3.565385] type=3D1400 audit(140=
0273203.143:2): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"/usr/lib/cups/backend/cups-pdf" pid=3D619 comm=3D"ap=
parmor_parser"
May 16 14:46:43 brian-laptop kernel: [    3.565392] type=3D1400 audit(140=
0273203.143:3): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"/usr/sbin/cupsd" pid=3D619 comm=3D"apparmor_parser"
May 16 14:46:43 brian-laptop kernel: [    3.565788] type=3D1400 audit(140=
0273203.143:4): apparmor=3D"STATUS" operation=3D"profile_replace" profile=
=3D"unconfined" name=3D"/usr/sbin/cupsd" pid=3D619 comm=3D"apparmor_parse=
r"
May 16 14:46:43 brian-laptop kernel: [    3.566687] input: HDA Intel HDMI=
 HDMI/DP,pcm=3D8 as /devices/pci0000:00/0000:00:03.0/sound/card0/input11
May 16 14:46:43 brian-laptop kernel: [    3.566790] input: HDA Intel HDMI=
 HDMI/DP,pcm=3D7 as /devices/pci0000:00/0000:00:03.0/sound/card0/input10
May 16 14:46:43 brian-laptop kernel: [    3.566892] input: HDA Intel HDMI=
 HDMI/DP,pcm=3D3 as /devices/pci0000:00/0000:00:03.0/sound/card0/input9
May 16 14:46:43 brian-laptop avahi-daemon[626]: Found user 'avahi' (UID 1=
10) and group 'avahi' (GID 116).
May 16 14:46:43 brian-laptop avahi-daemon[626]: Successfully dropped root=
 privileges.
May 16 14:46:43 brian-laptop avahi-daemon[626]: avahi-daemon 0.6.31 start=
ing up.
May 16 14:46:43 brian-laptop avahi-daemon[626]: Successfully called chroo=
t().
May 16 14:46:43 brian-laptop avahi-daemon[626]: Successfully dropped rema=
ining capabilities.
May 16 14:46:43 brian-laptop avahi-daemon[626]: Loading service file /ser=
vices/udisks.service.
May 16 14:46:43 brian-laptop avahi-daemon[626]: Network interface enumera=
tion completed.
May 16 14:46:43 brian-laptop avahi-daemon[626]: Registering HINFO record =
with values 'X86_64'/'LINUX'.
May 16 14:46:43 brian-laptop avahi-daemon[626]: Server startup complete. =
Host name is brian-laptop.local. Local service cookie is 1060241260.
May 16 14:46:43 brian-laptop avahi-daemon[626]: Service "brian-laptop" (/=
services/udisks.service) successfully established.
May 16 14:46:43 brian-laptop kernel: [    3.624366] type=3D1400 audit(140=
0273203.203:5): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"/sbin/dhclient" pid=3D635 comm=3D"apparmor_parser"
May 16 14:46:43 brian-laptop kernel: [    3.624371] type=3D1400 audit(140=
0273203.203:6): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"/usr/lib/NetworkManager/nm-dhcp-client.action" pid=3D=
635 comm=3D"apparmor_parser"
May 16 14:46:43 brian-laptop kernel: [    3.624374] type=3D1400 audit(140=
0273203.203:7): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"/usr/lib/connman/scripts/dhclient-script" pid=3D635 =
comm=3D"apparmor_parser"
May 16 14:46:43 brian-laptop kernel: [    3.624685] type=3D1400 audit(140=
0273203.203:8): apparmor=3D"STATUS" operation=3D"profile_replace" profile=
=3D"unconfined" name=3D"/usr/lib/NetworkManager/nm-dhcp-client.action" pi=
d=3D635 comm=3D"apparmor_parser"
May 16 14:46:43 brian-laptop kernel: [    3.624689] type=3D1400 audit(140=
0273203.203:9): apparmor=3D"STATUS" operation=3D"profile_replace" profile=
=3D"unconfined" name=3D"/usr/lib/connman/scripts/dhclient-script" pid=3D6=
35 comm=3D"apparmor_parser"
May 16 14:46:43 brian-laptop kernel: [    3.624853] type=3D1400 audit(140=
0273203.203:10): apparmor=3D"STATUS" operation=3D"profile_replace" profil=
e=3D"unconfined" name=3D"/usr/lib/connman/scripts/dhclient-script" pid=3D=
635 comm=3D"apparmor_parser"
May 16 14:46:43 brian-laptop failsafe: Failsafe of 120 seconds reached.
May 16 14:46:43 brian-laptop wpa_supplicant[716]: Successfully initialize=
d wpa_supplicant
May 16 14:46:43 brian-laptop kernel: [    3.707865] iwlwifi 0000:01:00.0:=
 L1 Disabled; Enabling L0S
May 16 14:46:43 brian-laptop kernel: [    3.708081] iwlwifi 0000:01:00.0:=
 L1 Disabled; Enabling L0S
May 16 14:46:43 brian-laptop kernel: [    3.720425] IPv6: ADDRCONF(NETDEV=
_UP): wlan0: link is not ready
May 16 14:46:43 brian-laptop kernel: [    3.827174] [drm] Enabling RC6 st=
ates: RC6 on, RC6p off, RC6pp off
May 16 14:46:43 brian-laptop kernel: [    3.898821] usb 2-7: unable to re=
ad config index 0 descriptor/start: -71
May 16 14:46:43 brian-laptop kernel: [    3.898864] usb 2-7: can't read c=
onfigurations, error -71
May 16 14:46:43 brian-laptop kernel: [    4.063291] usb 2-7: new full-spe=
ed USB device number 5 using xhci_hcd
May 16 14:46:44 brian-laptop wpa_supplicant[735]: wlan0: CTRL-EVENT-SCAN-=
STARTED=20
May 16 14:46:44 brian-laptop dhclient: Internet Systems Consortium DHCP C=
lient 4.2.4
May 16 14:46:44 brian-laptop dhclient: Copyright 2004-2012 Internet Syste=
ms Consortium.
May 16 14:46:44 brian-laptop dhclient: All rights reserved.
May 16 14:46:44 brian-laptop dhclient: For info, please visit https://www=
=2Eisc.org/software/dhcp/
May 16 14:46:44 brian-laptop dhclient:=20
May 16 14:46:44 brian-laptop dhclient: Listening on LPF/wlan0/5c:51:4f:63=
:1e:10
May 16 14:46:44 brian-laptop dhclient: Sending on   LPF/wlan0/5c:51:4f:63=
:1e:10
May 16 14:46:44 brian-laptop dhclient: Sending on   Socket/fallback
May 16 14:46:44 brian-laptop dhclient: DHCPDISCOVER on wlan0 to 255.255.2=
55.255 port 67 interval 3 (xid=3D0x430c01fb)
May 16 14:46:45 brian-laptop wpa_supplicant[735]: wlan0: SME: Trying to a=
uthenticate with 00:22:6b:54:68:d2 (SSID=3D'BJONES' freq=3D2437 MHz)
May 16 14:46:45 brian-laptop kernel: [    5.476139] wlan0: authenticate w=
ith 00:22:6b:54:68:d2
May 16 14:46:45 brian-laptop wpa_supplicant[735]: wlan0: Trying to associ=
ate with 00:22:6b:54:68:d2 (SSID=3D'BJONES' freq=3D2437 MHz)
May 16 14:46:45 brian-laptop kernel: [    5.478104] wlan0: send auth to 0=
0:22:6b:54:68:d2 (try 1/3)
May 16 14:46:45 brian-laptop kernel: [    5.480023] wlan0: authenticated
May 16 14:46:45 brian-laptop kernel: [    5.480405] wlan0: associate with=
 00:22:6b:54:68:d2 (try 1/3)
May 16 14:46:45 brian-laptop kernel: [    5.484337] wlan0: RX AssocResp f=
rom 00:22:6b:54:68:d2 (capab=3D0x411 status=3D0 aid=3D4)
May 16 14:46:45 brian-laptop wpa_supplicant[735]: wlan0: Associated with =
00:22:6b:54:68:d2
May 16 14:46:45 brian-laptop kernel: [    5.486522] wlan0: associated
May 16 14:46:45 brian-laptop kernel: [    5.486561] IPv6: ADDRCONF(NETDEV=
_CHANGE): wlan0: link becomes ready
May 16 14:46:45 brian-laptop wpa_supplicant[735]: wlan0: WPA: Key negotia=
tion completed with 00:22:6b:54:68:d2 [PTK=3DCCMP GTK=3DTKIP]
May 16 14:46:45 brian-laptop wpa_supplicant[735]: wlan0: CTRL-EVENT-CONNE=
CTED - Connection to 00:22:6b:54:68:d2 completed [id=3D0 id_str=3D]
May 16 14:46:45 brian-laptop kernel: [    6.136720] usb 2-7: unable to re=
ad config index 0 descriptor/start: -71
May 16 14:46:45 brian-laptop kernel: [    6.136725] usb 2-7: can't read c=
onfigurations, error -71
May 16 14:46:45 brian-laptop kernel: [    6.301158] usb 2-7: new full-spe=
ed USB device number 6 using xhci_hcd
May 16 14:46:45 brian-laptop kernel: [    6.318780] usb 2-7: New USB devi=
ce found, idVendor=3D04f3, idProduct=3D016f
May 16 14:46:45 brian-laptop kernel: [    6.318786] usb 2-7: New USB devi=
ce strings: Mfr=3D4, Product=3D14, SerialNumber=3D0
May 16 14:46:45 brian-laptop kernel: [    6.318789] usb 2-7: Product: Tou=
chscreen
May 16 14:46:45 brian-laptop kernel: [    6.318792] usb 2-7: Manufacturer=
: ELAN
May 16 14:46:45 brian-laptop kernel: [    6.318945] usb 2-7: ep 0x2 - rou=
nding interval to 64 microframes, ep desc says 80 microframes
May 16 14:46:46 brian-laptop kernel: [    6.485316] usb 2-8: new high-spe=
ed USB device number 7 using xhci_hcd
May 16 14:46:46 brian-laptop kernel: [    6.536671] usb 2-8: New USB devi=
ce found, idVendor=3D5986, idProduct=3D0535
May 16 14:46:46 brian-laptop kernel: [    6.536676] usb 2-8: New USB devi=
ce strings: Mfr=3D3, Product=3D1, SerialNumber=3D2
May 16 14:46:46 brian-laptop kernel: [    6.536678] usb 2-8: Product: Len=
ovo EasyCamera
May 16 14:46:46 brian-laptop kernel: [    6.536680] usb 2-8: Manufacturer=
: Generic
May 16 14:46:46 brian-laptop kernel: [    6.536681] usb 2-8: SerialNumber=
: 200901010001
May 16 14:46:46 brian-laptop mtp-probe: checking bus 2, device 7: "/sys/d=
evices/pci0000:00/0000:00:14.0/usb2/2-8"
May 16 14:46:46 brian-laptop mtp-probe: checking bus 2, device 3: "/sys/d=
evices/pci0000:00/0000:00:14.0/usb2/2-6"
May 16 14:46:46 brian-laptop mtp-probe: bus: 2, device: 3 was not an MTP =
device
May 16 14:46:46 brian-laptop mtp-probe: bus: 2, device: 7 was not an MTP =
device
May 16 14:46:46 brian-laptop kernel: [    6.545592] usbcore: registered n=
ew interface driver btusb
May 16 14:46:46 brian-laptop mtp-probe: checking bus 2, device 6: "/sys/d=
evices/pci0000:00/0000:00:14.0/usb2/2-7"
May 16 14:46:46 brian-laptop mtp-probe: bus: 2, device: 6 was not an MTP =
device
May 16 14:46:46 brian-laptop kernel: [    6.552194] Linux video capture i=
nterface: v2.00
May 16 14:46:46 brian-laptop kernel: [    6.552581] hidraw: raw HID event=
s driver (C) Jiri Kosina
May 16 14:46:46 brian-laptop kernel: [    6.557891] uvcvideo: Found UVC 1=
=2E00 device Lenovo EasyCamera (5986:0535)
May 16 14:46:46 brian-laptop kernel: [    6.561420] Bluetooth: hci0: read=
 Intel version: 370710018002030d00
May 16 14:46:46 brian-laptop kernel: [    6.561936] Bluetooth: hci0: Inte=
l Bluetooth firmware file: intel/ibt-hw-37.7.10-fw-1.80.2.3.d.bseq
May 16 14:46:46 brian-laptop kernel: [    6.562309] input: Lenovo EasyCam=
era as /devices/pci0000:00/0000:00:14.0/usb2/2-8/2-8:1.0/input/input12
May 16 14:46:46 brian-laptop kernel: [    6.562459] usbcore: registered n=
ew interface driver uvcvideo
May 16 14:46:46 brian-laptop kernel: [    6.562462] USB Video Class drive=
r (1.1.1)
May 16 14:46:46 brian-laptop kernel: [    6.577208] usbcore: registered n=
ew interface driver usbhid
May 16 14:46:46 brian-laptop kernel: [    6.577212] usbhid: USB HID core =
driver
May 16 14:46:46 brian-laptop kernel: [    6.582246] input: ELAN Touchscre=
en as /devices/pci0000:00/0000:00:14.0/usb2/2-7/2-7:1.0/input/input13
May 16 14:46:46 brian-laptop kernel: [    6.582476] hid-multitouch 0003:0=
4F3:016F.0002: input,hiddev0,hidraw0: USB HID v1.10 Device [ELAN Touchscr=
een] on usb-0000:00:14.0-7/input0
May 16 14:46:46 brian-laptop ntpdate[849]: Can't find host ntp.ubuntu.com=
: Name or service not known (-2)
May 16 14:46:46 brian-laptop ntpdate[849]: no servers can be used, exitin=
g
May 16 14:46:46 brian-laptop kernel: [    6.672502] Bluetooth: hci0: Inte=
l Bluetooth firmware patch completed and activated
May 16 14:46:46 brian-laptop bluetoothd[514]: Unknown command complete fo=
r opcode 19
May 16 14:46:46 brian-laptop bluetoothd[514]: Adapter /org/bluez/514/hci0=
 has been enabled
May 16 14:46:46 brian-laptop avahi-daemon[626]: Joining mDNS multicast gr=
oup on interface wlan0.IPv6 with address fe80::5e51:4fff:fe63:1e10.
May 16 14:46:46 brian-laptop avahi-daemon[626]: New relevant interface wl=
an0.IPv6 for mDNS.
May 16 14:46:46 brian-laptop avahi-daemon[626]: Registering new address r=
ecord for fe80::5e51:4fff:fe63:1e10 on wlan0.*.
May 16 14:46:47 brian-laptop dhclient: DHCPDISCOVER on wlan0 to 255.255.2=
55.255 port 67 interval 8 (xid=3D0x430c01fb)
May 16 14:46:47 brian-laptop kernel: [    8.375281] usb 2-7: USB disconne=
ct, device number 6
May 16 14:46:48 brian-laptop kernel: [    8.667083] usb 2-7: new full-spe=
ed USB device number 8 using xhci_hcd
May 16 14:46:48 brian-laptop dhclient: DHCPREQUEST of 192.168.3.107 on wl=
an0 to 255.255.255.255 port 67 (xid=3D0x430c01fb)
May 16 14:46:48 brian-laptop dhclient: DHCPOFFER of 192.168.3.107 from 19=
2.168.3.1
May 16 14:46:48 brian-laptop dhclient: DHCPACK of 192.168.3.107 from 192.=
168.3.1
May 16 14:46:48 brian-laptop avahi-daemon[626]: Joining mDNS multicast gr=
oup on interface wlan0.IPv4 with address 192.168.3.107.
May 16 14:46:48 brian-laptop avahi-daemon[626]: New relevant interface wl=
an0.IPv4 for mDNS.
May 16 14:46:48 brian-laptop avahi-daemon[626]: Registering new address r=
ecord for 192.168.3.107 on wlan0.IPv4.
May 16 14:46:48 brian-laptop dhclient: bound to 192.168.3.107 -- renewal =
in 35951 seconds.
May 16 14:46:48 brian-laptop ModemManager[995]: <info>  ModemManager (ver=
sion 1.0.0) starting...
May 16 14:46:48 brian-laptop NetworkManager[1025]: <info> NetworkManager =
(version 0.9.8.8) is starting...
May 16 14:46:48 brian-laptop NetworkManager[1025]: <info> Read config fil=
e /etc/NetworkManager/NetworkManager.conf
May 16 14:46:48 brian-laptop NetworkManager[1025]: <info> WEXT support is=
 enabled
May 16 14:46:48 brian-laptop NetworkManager[1025]: <info> VPN: loaded org=
=2Efreedesktop.NetworkManager.pptp
May 16 14:46:48 brian-laptop NetworkManager[1025]: <info> DNS: loaded plu=
gin dnsmasq
May 16 14:46:48 brian-laptop dbus[471]: [system] Activating service name=3D=
'org.freedesktop.PolicyKit1' (using servicehelper)
May 16 14:46:48 brian-laptop polkitd[1036]: started daemon version 0.105 =
using authority implementation `local' version `0.105'
May 16 14:46:48 brian-laptop dbus[471]: [system] Successfully activated s=
ervice 'org.freedesktop.PolicyKit1'
May 16 14:46:48 brian-laptop NetworkManager[1025]:    SCPlugin-Ifupdown: =
init!
May 16 14:46:48 brian-laptop NetworkManager[1025]:    SCPlugin-Ifupdown: =
update_system_hostname
May 16 14:46:48 brian-laptop NetworkManager[1025]:       interface-parser=
: parsing file /etc/network/interfaces
May 16 14:46:48 brian-laptop NetworkManager[1025]:       interface-parser=
: finished parsing file /etc/network/interfaces
May 16 14:46:48 brian-laptop NetworkManager[1025]:    SCPluginIfupdown: g=
uessed connection type (wlan0) =3D 802-11-wireless
May 16 14:46:48 brian-laptop NetworkManager[1025]:    SCPlugin-Ifupdown: =
update_connection_setting_from_if_block: name:wlan0, type:802-11-wireless=
, id:Ifupdown (wlan0), uuid: 5391eba4-6426-faca-338e-5828034ff9d1
May 16 14:46:48 brian-laptop NetworkManager[1025]:    SCPlugin-Ifupdown: =
update wireless settings (wlan0).
May 16 14:46:48 brian-laptop NetworkManager[1025]:    SCPlugin-Ifupdown: =
setting wpa ssid =3D 6
May 16 14:46:48 brian-laptop NetworkManager[1025]:    SCPlugin-Ifupdown: =
update wireless security settings (wlan0).
May 16 14:46:48 brian-laptop NetworkManager[1025]:    SCPlugin-Ifupdown: =
setting wpa security key: psk=3D<omitted>
May 16 14:46:48 brian-laptop NetworkManager[1025]: nm-ifupdown-connection=
=2Ec.100 - invalid connection read from /etc/network/interfaces: (2) key-=
mgmt
May 16 14:46:48 brian-laptop NetworkManager[1025]:    SCPlugin-Ifupdown: =
adding iface wlan0 to eni_ifaces
May 16 14:46:48 brian-laptop NetworkManager[1025]:    SCPluginIfupdown: m=
anagement mode: unmanaged
May 16 14:46:48 brian-laptop NetworkManager[1025]:    SCPlugin-Ifupdown: =
devices added (path: /sys/devices/pci0000:00/0000:00:1c.0/0000:01:00.0/ne=
t/wlan0, iface: wlan0)
May 16 14:46:48 brian-laptop NetworkManager[1025]:    SCPlugin-Ifupdown: =
devices added (path: /sys/devices/virtual/net/lo, iface: lo)
May 16 14:46:48 brian-laptop NetworkManager[1025]:    SCPlugin-Ifupdown: =
device added (path: /sys/devices/virtual/net/lo, iface: lo): no ifupdown =
configuration found.
May 16 14:46:48 brian-laptop NetworkManager[1025]:    SCPlugin-Ifupdown: =
end _init.
May 16 14:46:48 brian-laptop NetworkManager[1025]: <info> Loaded plugin i=
fupdown: (C) 2008 Canonical Ltd.  To report bugs please use the NetworkMa=
nager mailing list.
May 16 14:46:48 brian-laptop NetworkManager[1025]: <info> Loaded plugin k=
eyfile: (c) 2007 - 2010 Red Hat, Inc.  To report bugs please use the Netw=
orkManager mailing list.
May 16 14:46:48 brian-laptop NetworkManager[1025]:    SCPlugin-Ofono: Acq=
uired D-Bus service com.canonical.NMOfono
May 16 14:46:48 brian-laptop NetworkManager[1025]:    SCPlugin-Ofono: ini=
t!
May 16 14:46:48 brian-laptop NetworkManager[1025]:    SCPlugin-Ofono: end=
 _init.
May 16 14:46:48 brian-laptop NetworkManager[1025]: <info> Loaded plugin (=
null): (null)
May 16 14:46:48 brian-laptop NetworkManager[1025]:    Ifupdown: get unman=
aged devices count: 1
May 16 14:46:48 brian-laptop NetworkManager[1025]:    SCPlugin-Ifupdown: =
(27135520) ... get_connections.
May 16 14:46:48 brian-laptop NetworkManager[1025]:    SCPlugin-Ifupdown: =
(27135520) ... get_connections (managed=3Dfalse): return empty list.
May 16 14:46:48 brian-laptop NetworkManager[1025]:    keyfile: parsing br=
ianspot ...=20
May 16 14:46:48 brian-laptop kernel: [    8.984292] audit_printk_skb: 3 c=
allbacks suppressed
May 16 14:46:48 brian-laptop kernel: [    8.984296] type=3D1400 audit(140=
0273208.559:12): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"/usr/lib/lightdm/lightdm-guest-session" pid=3D1066 c=
omm=3D"apparmor_parser"
May 16 14:46:48 brian-laptop kernel: [    8.984303] type=3D1400 audit(140=
0273208.559:13): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"chromium" pid=3D1066 comm=3D"apparmor_parser"
May 16 14:46:48 brian-laptop kernel: [    8.984598] type=3D1400 audit(140=
0273208.559:14): apparmor=3D"STATUS" operation=3D"profile_replace" profil=
e=3D"unconfined" name=3D"chromium" pid=3D1066 comm=3D"apparmor_parser"
May 16 14:46:48 brian-laptop kernel: [    8.986256] type=3D1400 audit(140=
0273208.559:15): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"/usr/lib/x86_64-linux-gnu/lightdm-remote-session-ucc=
sconfigure/uccsconfigure-session-wrapper" pid=3D1068 comm=3D"apparmor_par=
ser"
May 16 14:46:48 brian-laptop kernel: [    8.986261] type=3D1400 audit(140=
0273208.559:16): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"chromium" pid=3D1068 comm=3D"apparmor_parser"
May 16 14:46:48 brian-laptop kernel: [    8.986472] type=3D1400 audit(140=
0273208.559:17): apparmor=3D"STATUS" operation=3D"profile_replace" profil=
e=3D"unconfined" name=3D"chromium" pid=3D1068 comm=3D"apparmor_parser"
May 16 14:46:48 brian-laptop kernel: [    8.989338] type=3D1400 audit(140=
0273208.563:18): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"/usr/lib/x86_64-linux-gnu/lightdm-remote-session-fre=
erdp/freerdp-session-wrapper" pid=3D1067 comm=3D"apparmor_parser"
May 16 14:46:48 brian-laptop kernel: [    8.989343] type=3D1400 audit(140=
0273208.563:19): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"chromium" pid=3D1067 comm=3D"apparmor_parser"
May 16 14:46:48 brian-laptop kernel: [    8.989549] type=3D1400 audit(140=
0273208.563:20): apparmor=3D"STATUS" operation=3D"profile_replace" profil=
e=3D"unconfined" name=3D"chromium" pid=3D1067 comm=3D"apparmor_parser"
May 16 14:46:48 brian-laptop NetworkManager[1025]:    keyfile:     read c=
onnection 'brianspot'
May 16 14:46:48 brian-laptop kernel: [    8.994077] type=3D1400 audit(140=
0273208.567:21): apparmor=3D"STATUS" operation=3D"profile_replace" profil=
e=3D"unconfined" name=3D"/sbin/dhclient" pid=3D1069 comm=3D"apparmor_pars=
er"
May 16 14:46:48 brian-laptop NetworkManager[1025]:    keyfile: parsing kn=
eaders ...=20
May 16 14:46:48 brian-laptop NetworkManager[1025]:    keyfile:     read c=
onnection 'kneaders'
May 16 14:46:48 brian-laptop NetworkManager[1025]:    keyfile: parsing BJ=
ONES ...=20
May 16 14:46:48 brian-laptop NetworkManager[1025]:    keyfile:     read c=
onnection 'BJONES'
May 16 14:46:48 brian-laptop NetworkManager[1025]:    SCPlugin-Ofono: (93=
9539824) ... get_connections.
May 16 14:46:48 brian-laptop NetworkManager[1025]:    SCPlugin-Ofono: (93=
9539824) connections count: 0
May 16 14:46:48 brian-laptop NetworkManager[1025]:    Ifupdown: get unman=
aged devices count: 1
May 16 14:46:48 brian-laptop NetworkManager[1025]: <info> monitoring kern=
el firmware directory '/lib/firmware'.
May 16 14:46:48 brian-laptop NetworkManager[1025]: <info> rfkill0: found =
WiFi radio killswitch (at /sys/devices/pci0000:00/0000:00:1c.0/0000:01:00=
=2E0/ieee80211/phy0/rfkill0) (driver iwlwifi)
May 16 14:46:48 brian-laptop NetworkManager[1025]: <info> WiFi enabled by=
 radio killswitch; enabled by state file
May 16 14:46:48 brian-laptop NetworkManager[1025]: <info> WWAN enabled by=
 radio killswitch; enabled by state file
May 16 14:46:48 brian-laptop NetworkManager[1025]: <info> WiMAX enabled b=
y radio killswitch; enabled by state file
May 16 14:46:48 brian-laptop NetworkManager[1025]: <info> Networking is e=
nabled by state file
May 16 14:46:48 brian-laptop NetworkManager[1025]: <info> (wlan0): using =
nl80211 for WiFi device control
May 16 14:46:48 brian-laptop NetworkManager[1025]: <info> (wlan0): driver=
 supports Access Point (AP) mode
May 16 14:46:48 brian-laptop NetworkManager[1025]: <info> (wlan0): new 80=
2.11 WiFi device (driver: 'iwlwifi' ifindex: 2)
May 16 14:46:48 brian-laptop NetworkManager[1025]: <info> (wlan0): export=
ed as /org/freedesktop/NetworkManager/Devices/0
May 16 14:46:48 brian-laptop NetworkManager[1025]: <warn> /sys/devices/vi=
rtual/net/lo: couldn't determine device driver; ignoring...
May 16 14:46:48 brian-laptop NetworkManager[1025]: <warn> /sys/devices/vi=
rtual/net/lo: couldn't determine device driver; ignoring...
May 16 14:46:48 brian-laptop NetworkManager[1025]: <info> urfkill disappe=
ared from the bus
May 16 14:46:48 brian-laptop NetworkManager[1025]: <info> ModemManager av=
ailable in the bus
May 16 14:46:48 brian-laptop anacron[1187]: Anacron 2.3 started on 2014-0=
5-16
May 16 14:46:48 brian-laptop anacron[1187]: Normal exit (0 jobs run)
May 16 14:46:48 brian-laptop cron[1129]: (CRON) INFO (pidfile fd =3D 3)
May 16 14:46:48 brian-laptop whoopsie[1170]: whoopsie 0.2.24.5 starting u=
p.
May 16 14:46:48 brian-laptop whoopsie[1170]: Using lock path: /var/lock/w=
hoopsie/lock
May 16 14:46:48 brian-laptop avahi-daemon[626]: Leaving mDNS multicast gr=
oup on interface wlan0.IPv6 with address fe80::5e51:4fff:fe63:1e10.
May 16 14:46:48 brian-laptop avahi-daemon[626]: Joining mDNS multicast gr=
oup on interface wlan0.IPv6 with address 2002:d1b5:5206:0:f8e1:e894:66b3:=
1294.
May 16 14:46:48 brian-laptop avahi-daemon[626]: Registering new address r=
ecord for 2002:d1b5:5206:0:f8e1:e894:66b3:1294 on wlan0.*.
May 16 14:46:48 brian-laptop avahi-daemon[626]: Withdrawing address recor=
d for fe80::5e51:4fff:fe63:1e10 on wlan0.
May 16 14:46:48 brian-laptop cron[1193]: (CRON) STARTUP (fork ok)
May 16 14:46:48 brian-laptop cron[1193]: (CRON) INFO (Running @reboot job=
s)
May 16 14:46:48 brian-laptop dbus[471]: [system] Activating service name=3D=
'org.freedesktop.Accounts' (using servicehelper)
May 16 14:46:48 brian-laptop acpid: starting up with netlink and the inpu=
t layer
May 16 14:46:48 brian-laptop acpid: 9 rules loaded
May 16 14:46:48 brian-laptop acpid: waiting for events: event logging is =
off
May 16 14:46:48 brian-laptop accounts-daemon[1289]: started daemon versio=
n 0.6.35
May 16 14:46:48 brian-laptop dbus[471]: [system] Successfully activated s=
ervice 'org.freedesktop.Accounts'
May 16 14:46:48 brian-laptop NetworkManager[1025]: <info> Unmanaged Devic=
e found; state CONNECTED forced. (see http://bugs.launchpad.net/bugs/1918=
89)
May 16 14:46:48 brian-laptop NetworkManager[1025]: <info> Unmanaged Devic=
e found; state CONNECTED forced. (see http://bugs.launchpad.net/bugs/1918=
89)
May 16 14:46:48 brian-laptop NetworkManager[1025]: <info> NetworkManager =
state is now CONNECTED_GLOBAL
May 16 14:46:48 brian-laptop NetworkManager[1025]: <info> Unmanaged Devic=
e found; state CONNECTED forced. (see http://bugs.launchpad.net/bugs/1918=
89)
May 16 14:46:48 brian-laptop acpid: client connected from 1284[0:0]
May 16 14:46:48 brian-laptop acpid: 1 client rule loaded
May 16 14:46:48 brian-laptop whoopsie[1202]: offline
May 16 14:46:48 brian-laptop kernel: [    9.399561] drm: not enough stole=
n space for compressed buffer (need 23142400 more bytes), disabling. Hint=
: you may be able to increase stolen memory size in the BIOS to avoid thi=
s.
May 16 14:46:49 brian-laptop dbus[471]: [system] Activating service name=3D=
'org.freedesktop.UPower' (using servicehelper)
May 16 14:46:49 brian-laptop dbus[471]: [system] Successfully activated s=
ervice 'org.freedesktop.UPower'
May 16 14:46:49 brian-laptop dbus[471]: [system] Activating service name=3D=
'org.freedesktop.RealtimeKit1' (using servicehelper)
May 16 14:46:49 brian-laptop dbus[471]: [system] Successfully activated s=
ervice 'org.freedesktop.RealtimeKit1'
May 16 14:46:49 brian-laptop rtkit-daemon[1470]: Successfully called chro=
ot.
May 16 14:46:49 brian-laptop rtkit-daemon[1470]: Successfully dropped pri=
vileges.
May 16 14:46:49 brian-laptop rtkit-daemon[1470]: Successfully limited res=
ources.
May 16 14:46:49 brian-laptop rtkit-daemon[1470]: Running.
May 16 14:46:49 brian-laptop rtkit-daemon[1470]: Canary thread running.
May 16 14:46:49 brian-laptop rtkit-daemon[1470]: Watchdog thread running.=

May 16 14:46:49 brian-laptop rtkit-daemon[1470]: Successfully made thread=
 1467 of process 1467 (n/a) owned by '111' high priority at nice level -1=
1.
May 16 14:46:49 brian-laptop rtkit-daemon[1470]: Supervising 1 threads of=
 1 processes of 1 users.
May 16 14:46:49 brian-laptop rtkit-daemon[1470]: Successfully made thread=
 1507 of process 1467 (n/a) owned by '111' RT at priority 5.
May 16 14:46:49 brian-laptop rtkit-daemon[1470]: Supervising 2 threads of=
 1 processes of 1 users.
May 16 14:46:49 brian-laptop rtkit-daemon[1470]: Successfully made thread=
 1508 of process 1467 (n/a) owned by '111' RT at priority 5.
May 16 14:46:49 brian-laptop rtkit-daemon[1470]: Supervising 3 threads of=
 1 processes of 1 users.
May 16 14:46:49 brian-laptop rtkit-daemon[1470]: Successfully made thread=
 1509 of process 1467 (n/a) owned by '111' RT at priority 5.
May 16 14:46:49 brian-laptop rtkit-daemon[1470]: Supervising 4 threads of=
 1 processes of 1 users.
May 16 14:46:49 brian-laptop bluetoothd[514]: Endpoint registered: sender=
=3D:1.31 path=3D/MediaEndpoint/HFPAG
May 16 14:46:49 brian-laptop bluetoothd[514]: Endpoint registered: sender=
=3D:1.31 path=3D/MediaEndpoint/HFPHS
May 16 14:46:49 brian-laptop bluetoothd[514]: Endpoint registered: sender=
=3D:1.31 path=3D/MediaEndpoint/A2DPSource
May 16 14:46:49 brian-laptop bluetoothd[514]: Endpoint registered: sender=
=3D:1.31 path=3D/MediaEndpoint/A2DPSink
May 16 14:46:49 brian-laptop avahi-daemon[626]: Registering new address r=
ecord for 2002:d1b5:5206:0:5e51:4fff:fe63:1e10 on wlan0.*.
May 16 14:46:50 brian-laptop kernel: [   10.741058] usb 2-7: unable to re=
ad config index 0 descriptor/start: -71
May 16 14:46:50 brian-laptop kernel: [   10.741063] usb 2-7: can't read c=
onfigurations, error -71
May 16 14:46:50 brian-laptop kernel: [   10.852772] usb 2-7: new full-spe=
ed USB device number 9 using xhci_hcd
May 16 14:46:50 brian-laptop ModemManager[995]: <warn>  Couldn't find sup=
port for device at '/sys/devices/pci0000:00/0000:00:1c.0/0000:01:00.0': n=
ot supported by any plugin
May 16 14:46:52 brian-laptop kernel: [   12.926707] usb 2-7: unable to re=
ad config index 0 descriptor/start: -71
May 16 14:46:52 brian-laptop kernel: [   12.926712] usb 2-7: can't read c=
onfigurations, error -71
May 16 14:46:52 brian-laptop kernel: [   13.038610] usb 2-7: new full-spe=
ed USB device number 10 using xhci_hcd
May 16 14:46:54 brian-laptop dbus[471]: [system] Activating service name=3D=
'org.freedesktop.UDisks2' (using servicehelper)
May 16 14:46:54 brian-laptop udisksd[1796]: udisks daemon version 2.1.3 s=
tarting
May 16 14:46:54 brian-laptop dbus[471]: [system] Successfully activated s=
ervice 'org.freedesktop.UDisks2'
May 16 14:46:54 brian-laptop udisksd[1796]: Acquired the name org.freedes=
ktop.UDisks2 on the system message bus
May 16 14:46:54 brian-laptop kernel: [   15.112398] usb 2-7: unable to re=
ad config index 0 descriptor/start: -71
May 16 14:46:54 brian-laptop kernel: [   15.112403] usb 2-7: can't read c=
onfigurations, error -71
May 16 14:46:54 brian-laptop rtkit-daemon[1470]: Successfully made thread=
 1870 of process 1870 (n/a) owned by '1000' high priority at nice level -=
11.
May 16 14:46:54 brian-laptop rtkit-daemon[1470]: Supervising 5 threads of=
 2 processes of 2 users.
May 16 14:46:54 brian-laptop rtkit-daemon[1470]: Successfully made thread=
 1891 of process 1870 (n/a) owned by '1000' RT at priority 5.
May 16 14:46:54 brian-laptop rtkit-daemon[1470]: Supervising 6 threads of=
 2 processes of 2 users.
May 16 14:46:54 brian-laptop kernel: [   15.224282] usb 2-7: new full-spe=
ed USB device number 11 using xhci_hcd
May 16 14:46:54 brian-laptop rtkit-daemon[1470]: Successfully made thread=
 1904 of process 1870 (n/a) owned by '1000' RT at priority 5.
May 16 14:46:54 brian-laptop rtkit-daemon[1470]: Supervising 7 threads of=
 2 processes of 2 users.
May 16 14:46:54 brian-laptop rtkit-daemon[1470]: Successfully made thread=
 1906 of process 1870 (n/a) owned by '1000' RT at priority 5.
May 16 14:46:54 brian-laptop rtkit-daemon[1470]: Supervising 8 threads of=
 2 processes of 2 users.
May 16 14:46:54 brian-laptop bluetoothd[514]: Endpoint registered: sender=
=3D:1.57 path=3D/MediaEndpoint/HFPAG
May 16 14:46:54 brian-laptop bluetoothd[514]: Endpoint registered: sender=
=3D:1.57 path=3D/MediaEndpoint/HFPHS
May 16 14:46:54 brian-laptop bluetoothd[514]: Endpoint registered: sender=
=3D:1.57 path=3D/MediaEndpoint/A2DPSource
May 16 14:46:54 brian-laptop bluetoothd[514]: Endpoint registered: sender=
=3D:1.57 path=3D/MediaEndpoint/A2DPSink
May 16 14:46:54 brian-laptop rtkit-daemon[1470]: Successfully made thread=
 1962 of process 1962 (n/a) owned by '1000' high priority at nice level -=
11.
May 16 14:46:54 brian-laptop rtkit-daemon[1470]: Supervising 9 threads of=
 3 processes of 2 users.
May 16 14:46:54 brian-laptop pulseaudio[1962]: [pulseaudio] pid.c: Daemon=
 already running.
May 16 14:46:54 brian-laptop ntpdate[969]: step time server 91.189.94.4 o=
ffset -0.688826 sec
May 16 14:46:56 brian-laptop kernel: [   17.298145] usb 2-7: unable to re=
ad config index 0 descriptor/start: -71
May 16 14:46:56 brian-laptop kernel: [   17.298149] usb 2-7: can't read c=
onfigurations, error -71
May 16 14:46:56 brian-laptop kernel: [   17.298190] hub 2-0:1.0: unable t=
o enumerate USB device on port 7
May 16 14:46:56 brian-laptop kernel: [   17.574192] usb 2-7: new full-spe=
ed USB device number 12 using xhci_hcd
May 16 14:46:54 brian-laptop NetworkManager[1025]: message repeated 3 tim=
es: [ <info> Unmanaged Device found; state CONNECTED forced. (see http://=
bugs.launchpad.net/bugs/191889)]
May 16 14:46:57 brian-laptop NetworkManager[1025]: <info> WiFi hardware r=
adio set enabled
May 16 14:46:58 brian-laptop kernel: [   19.648324] usb 2-7: unable to re=
ad config index 0 descriptor/start: -71
May 16 14:46:58 brian-laptop kernel: [   19.648328] usb 2-7: can't read c=
onfigurations, error -71
May 16 14:46:58 brian-laptop kernel: [   19.759957] usb 2-7: new full-spe=
ed USB device number 13 using xhci_hcd
May 16 14:47:00 brian-laptop kernel: [   21.834207] usb 2-7: unable to re=
ad config index 0 descriptor/start: -71
May 16 14:47:00 brian-laptop kernel: [   21.834210] usb 2-7: can't read c=
onfigurations, error -71
May 16 14:47:00 brian-laptop kernel: [   21.945719] usb 2-7: new full-spe=
ed USB device number 14 using xhci_hcd
May 16 14:47:02 brian-laptop kernel: [   24.020042] usb 2-7: unable to re=
ad config index 0 descriptor/start: -71
May 16 14:47:02 brian-laptop kernel: [   24.020046] usb 2-7: can't read c=
onfigurations, error -71
May 16 14:47:03 brian-laptop kernel: [   24.131466] usb 2-7: new full-spe=
ed USB device number 15 using xhci_hcd
May 16 14:47:05 brian-laptop kernel: [   26.205795] usb 2-7: unable to re=
ad config index 0 descriptor/start: -71
May 16 14:47:05 brian-laptop kernel: [   26.205798] usb 2-7: can't read c=
onfigurations, error -71
May 16 14:47:05 brian-laptop kernel: [   26.205820] hub 2-0:1.0: unable t=
o enumerate USB device on port 7
May 16 14:47:05 brian-laptop kernel: [   26.481364] usb 2-7: new full-spe=
ed USB device number 16 using xhci_hcd
May 16 14:47:07 brian-laptop kernel: [   28.556060] usb 2-7: unable to re=
ad config index 0 descriptor/start: -71
May 16 14:47:07 brian-laptop kernel: [   28.556063] usb 2-7: can't read c=
onfigurations, error -71
May 16 14:47:07 brian-laptop kernel: [   28.723194] usb 2-7: new full-spe=
ed USB device number 17 using xhci_hcd
May 16 14:47:07 brian-laptop kernel: [   28.740614] usb 2-7: New USB devi=
ce found, idVendor=3D04f3, idProduct=3D016f
May 16 14:47:07 brian-laptop kernel: [   28.740616] usb 2-7: New USB devi=
ce strings: Mfr=3D4, Product=3D14, SerialNumber=3D0
May 16 14:47:07 brian-laptop kernel: [   28.740618] usb 2-7: Product: Tou=
chscreen
May 16 14:47:07 brian-laptop kernel: [   28.740619] usb 2-7: Manufacturer=
: ELAN
May 16 14:47:07 brian-laptop kernel: [   28.740692] usb 2-7: ep 0x2 - rou=
nding interval to 64 microframes, ep desc says 80 microframes
May 16 14:47:07 brian-laptop mtp-probe: checking bus 2, device 17: "/sys/=
devices/pci0000:00/0000:00:14.0/usb2/2-7"
May 16 14:47:07 brian-laptop kernel: [   28.748209] input: ELAN Touchscre=
en as /devices/pci0000:00/0000:00:14.0/usb2/2-7/2-7:1.0/input/input15
May 16 14:47:07 brian-laptop kernel: [   28.748818] hid-multitouch 0003:0=
4F3:016F.0003: input,hiddev0,hidraw0: USB HID v1.10 Device [ELAN Touchscr=
een] on usb-0000:00:14.0-7/input0
May 16 14:47:07 brian-laptop mtp-probe: bus: 2, device: 17 was not an MTP=
 device
May 16 14:47:07 brian-laptop anacron[2178]: Anacron 2.3 started on 2014-0=
5-16
May 16 14:47:07 brian-laptop anacron[2178]: Normal exit (0 jobs run)
May 16 14:47:12 brian-laptop bluetoothd[514]: Endpoint unregistered: send=
er=3D:1.31 path=3D/MediaEndpoint/HFPAG
May 16 14:47:12 brian-laptop bluetoothd[514]: Endpoint unregistered: send=
er=3D:1.31 path=3D/MediaEndpoint/HFPHS
May 16 14:47:12 brian-laptop bluetoothd[514]: Endpoint unregistered: send=
er=3D:1.31 path=3D/MediaEndpoint/A2DPSource
May 16 14:47:12 brian-laptop bluetoothd[514]: Endpoint unregistered: send=
er=3D:1.31 path=3D/MediaEndpoint/A2DPSink
May 16 14:47:50 brian-laptop avahi-daemon[626]: Registering new address r=
ecord for 2002:d1b5:5206:0:25ef:565e:8d71:8ba5 on wlan0.*.
May 16 14:47:51 brian-laptop avahi-daemon[626]: Withdrawing address recor=
d for 2002:d1b5:5206:0:f8e1:e894:66b3:1294 on wlan0.
May 16 14:47:51 brian-laptop avahi-daemon[626]: Withdrawing address recor=
d for 2002:d1b5:5206:0:25ef:565e:8d71:8ba5 on wlan0.
May 16 14:47:51 brian-laptop avahi-daemon[626]: Registering new address r=
ecord for 2002:d1b5:5206:0:25ef:565e:8d71:8ba5 on wlan0.*.
May 16 14:47:51 brian-laptop avahi-daemon[626]: Registering new address r=
ecord for 2002:d1b5:5206:0:f8e1:e894:66b3:1294 on wlan0.*.
May 16 14:47:51 brian-laptop avahi-daemon[626]: Registering new address r=
ecord for fe80::5e51:4fff:fe63:1e10 on wlan0.*.
May 16 14:47:54 brian-laptop avahi-daemon[626]: Withdrawing address recor=
d for 2002:d1b5:5206:0:25ef:565e:8d71:8ba5 on wlan0.
May 16 14:47:54 brian-laptop avahi-daemon[626]: Withdrawing address recor=
d for 2002:d1b5:5206:0:f8e1:e894:66b3:1294 on wlan0.
May 16 14:47:54 brian-laptop avahi-daemon[626]: Withdrawing address recor=
d for fe80::5e51:4fff:fe63:1e10 on wlan0.
May 16 14:47:54 brian-laptop avahi-daemon[626]: Registering new address r=
ecord for 2002:d1b5:5206:0:25ef:565e:8d71:8ba5 on wlan0.*.
May 16 14:47:54 brian-laptop avahi-daemon[626]: Registering new address r=
ecord for 2002:d1b5:5206:0:f8e1:e894:66b3:1294 on wlan0.*.
May 16 14:50:03 brian-laptop kernel: [  204.992311] wlan0: deauthenticate=
d from 00:22:6b:54:68:d2 (Reason: 7)
May 16 14:50:03 brian-laptop wpa_supplicant[735]: wlan0: CTRL-EVENT-DISCO=
NNECTED bssid=3D00:22:6b:54:68:d2 reason=3D7
May 16 14:50:03 brian-laptop wpa_supplicant[735]: wlan0: SME: Trying to a=
uthenticate with 00:22:6b:54:68:d2 (SSID=3D'BJONES' freq=3D2437 MHz)
May 16 14:50:03 brian-laptop wpa_supplicant[735]: wlan0: CTRL-EVENT-SCAN-=
STARTED=20
May 16 14:50:03 brian-laptop kernel: [  205.013895] cfg80211: Calling CRD=
A to update world regulatory domain
May 16 14:50:03 brian-laptop kernel: [  205.020554] cfg80211: World regul=
atory domain updated:
May 16 14:50:03 brian-laptop kernel: [  205.020561] cfg80211:   (start_fr=
eq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
May 16 14:50:03 brian-laptop kernel: [  205.020567] cfg80211:   (2402000 =
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 14:50:03 brian-laptop kernel: [  205.020571] cfg80211:   (2457000 =
KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 14:50:03 brian-laptop kernel: [  205.020574] cfg80211:   (2474000 =
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
May 16 14:50:03 brian-laptop kernel: [  205.020578] cfg80211:   (5170000 =
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 14:50:03 brian-laptop kernel: [  205.020581] cfg80211:   (5735000 =
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 14:50:03 brian-laptop kernel: [  205.055815] wlan0: authenticate w=
ith 00:22:6b:54:68:d2
May 16 14:50:03 brian-laptop kernel: [  205.057503] wlan0: send auth to 0=
0:22:6b:54:68:d2 (try 1/3)
May 16 14:50:03 brian-laptop wpa_supplicant[735]: wlan0: Trying to associ=
ate with 00:22:6b:54:68:d2 (SSID=3D'BJONES' freq=3D2437 MHz)
May 16 14:50:03 brian-laptop kernel: [  205.059979] wlan0: authenticated
May 16 14:50:03 brian-laptop kernel: [  205.061673] wlan0: associate with=
 00:22:6b:54:68:d2 (try 1/3)
May 16 14:50:03 brian-laptop wpa_supplicant[735]: wlan0: Associated with =
00:22:6b:54:68:d2
May 16 14:50:03 brian-laptop kernel: [  205.065710] wlan0: RX AssocResp f=
rom 00:22:6b:54:68:d2 (capab=3D0x411 status=3D0 aid=3D4)
May 16 14:50:03 brian-laptop kernel: [  205.066924] wlan0: associated
May 16 14:50:03 brian-laptop wpa_supplicant[735]: wlan0: WPA: Key negotia=
tion completed with 00:22:6b:54:68:d2 [PTK=3DCCMP GTK=3DTKIP]
May 16 14:50:03 brian-laptop wpa_supplicant[735]: wlan0: CTRL-EVENT-CONNE=
CTED - Connection to 00:22:6b:54:68:d2 completed [id=3D0 id_str=3D]
May 16 14:50:48 brian-laptop kernel: [  250.018443] wlan0: deauthenticate=
d from 00:22:6b:54:68:d2 (Reason: 7)
May 16 14:50:48 brian-laptop wpa_supplicant[735]: wlan0: CTRL-EVENT-DISCO=
NNECTED bssid=3D00:22:6b:54:68:d2 reason=3D7
May 16 14:50:48 brian-laptop kernel: [  250.054368] cfg80211: Calling CRD=
A to update world regulatory domain
May 16 14:50:48 brian-laptop kernel: [  250.061254] cfg80211: World regul=
atory domain updated:
May 16 14:50:48 brian-laptop kernel: [  250.061262] cfg80211:   (start_fr=
eq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
May 16 14:50:48 brian-laptop kernel: [  250.061267] cfg80211:   (2402000 =
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 14:50:48 brian-laptop kernel: [  250.061271] cfg80211:   (2457000 =
KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 14:50:48 brian-laptop kernel: [  250.061275] cfg80211:   (2474000 =
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
May 16 14:50:48 brian-laptop kernel: [  250.061278] cfg80211:   (5170000 =
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 14:50:48 brian-laptop kernel: [  250.061281] cfg80211:   (5735000 =
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 14:51:02 brian-laptop avahi-daemon[626]: Registering new address r=
ecord for 2002:d1b5:5206:0:7866:c339:eb0:8b67 on wlan0.*.
May 16 14:51:03 brian-laptop avahi-daemon[626]: Withdrawing address recor=
d for 2002:d1b5:5206:0:f8e1:e894:66b3:1294 on wlan0.
May 16 14:51:03 brian-laptop avahi-daemon[626]: Withdrawing address recor=
d for 2002:d1b5:5206:0:25ef:565e:8d71:8ba5 on wlan0.
May 16 14:51:03 brian-laptop avahi-daemon[626]: Withdrawing address recor=
d for 2002:d1b5:5206:0:7866:c339:eb0:8b67 on wlan0.
May 16 14:51:03 brian-laptop avahi-daemon[626]: Registering new address r=
ecord for 2002:d1b5:5206:0:7866:c339:eb0:8b67 on wlan0.*.
May 16 14:51:03 brian-laptop avahi-daemon[626]: Registering new address r=
ecord for 2002:d1b5:5206:0:25ef:565e:8d71:8ba5 on wlan0.*.
May 16 14:51:03 brian-laptop avahi-daemon[626]: Registering new address r=
ecord for 2002:d1b5:5206:0:f8e1:e894:66b3:1294 on wlan0.*.
May 16 14:51:03 brian-laptop avahi-daemon[626]: Registering new address r=
ecord for fe80::5e51:4fff:fe63:1e10 on wlan0.*.
May 16 14:51:11 brian-laptop NetworkManager[1025]: <info> Unmanaged Devic=
e found; state CONNECTED forced. (see http://bugs.launchpad.net/bugs/1918=
89)
May 16 14:51:13 brian-laptop avahi-daemon[626]: Withdrawing address recor=
d for 2002:d1b5:5206:0:f8e1:e894:66b3:1294 on wlan0.
May 16 14:51:13 brian-laptop avahi-daemon[626]: Leaving mDNS multicast gr=
oup on interface wlan0.IPv6 with address 2002:d1b5:5206:0:f8e1:e894:66b3:=
1294.
May 16 14:51:13 brian-laptop avahi-daemon[626]: Joining mDNS multicast gr=
oup on interface wlan0.IPv6 with address 2002:d1b5:5206:0:7866:c339:eb0:8=
b67.
May 16 14:51:13 brian-laptop avahi-daemon[626]: Withdrawing address recor=
d for 2002:d1b5:5206:0:25ef:565e:8d71:8ba5 on wlan0.
May 16 14:51:13 brian-laptop avahi-daemon[626]: Withdrawing address recor=
d for 2002:d1b5:5206:0:7866:c339:eb0:8b67 on wlan0.
May 16 14:51:13 brian-laptop avahi-daemon[626]: Leaving mDNS multicast gr=
oup on interface wlan0.IPv6 with address 2002:d1b5:5206:0:7866:c339:eb0:8=
b67.
May 16 14:51:13 brian-laptop avahi-daemon[626]: Joining mDNS multicast gr=
oup on interface wlan0.IPv6 with address 2002:d1b5:5206:0:5e51:4fff:fe63:=
1e10.
May 16 14:51:13 brian-laptop avahi-daemon[626]: Withdrawing address recor=
d for 2002:d1b5:5206:0:5e51:4fff:fe63:1e10 on wlan0.
May 16 14:51:13 brian-laptop avahi-daemon[626]: Leaving mDNS multicast gr=
oup on interface wlan0.IPv6 with address 2002:d1b5:5206:0:5e51:4fff:fe63:=
1e10.
May 16 14:51:13 brian-laptop avahi-daemon[626]: Joining mDNS multicast gr=
oup on interface wlan0.IPv6 with address fe80::5e51:4fff:fe63:1e10.
May 16 14:51:38 brian-laptop kernel: [  300.062307] mce: [Hardware Error]=
: Machine check events logged
May 16 14:55:31 brian-laptop rsyslogd: [origin software=3D"rsyslogd" swVe=
rsion=3D"7.4.4" x-pid=3D"607" x-info=3D"http://www.rsyslog.com"] exiting =
on signal 15.
May 16 14:56:26 brian-laptop rsyslogd: [origin software=3D"rsyslogd" swVe=
rsion=3D"7.4.4" x-pid=3D"565" x-info=3D"http://www.rsyslog.com"] start
May 16 14:56:26 brian-laptop rsyslogd: rsyslogd's groupid changed to 103
May 16 14:56:26 brian-laptop rsyslogd: rsyslogd's userid changed to 101
May 16 14:56:26 brian-laptop kernel: [    0.000000] Initializing cgroup s=
ubsys cpuset
May 16 14:56:26 brian-laptop kernel: [    0.000000] Initializing cgroup s=
ubsys cpu
May 16 14:56:26 brian-laptop kernel: [    0.000000] Initializing cgroup s=
ubsys cpuacct
May 16 14:56:26 brian-laptop kernel: [    0.000000] Linux version 3.13.0-=
24-generic (buildd@batsu) (gcc version 4.8.2 (Ubuntu 4.8.2-19ubuntu1) ) #=
47-Ubuntu SMP Fri May 2 23:30:00 UTC 2014 (Ubuntu 3.13.0-24.47-generic 3.=
13.9)
May 16 14:56:26 brian-laptop kernel: [    0.000000] Command line: BOOT_IM=
AGE=3D/boot/vmlinuz-3.13.0-24-generic.efi.signed root=3DUUID=3D8e47fdb9-a=
ff2-414b-a81c-2df6486162cd ro acpi_backlight=3Dvendor quiet splash vt.han=
doff=3D7
May 16 14:56:26 brian-laptop kernel: [    0.000000] KERNEL supported cpus=
:
May 16 14:56:26 brian-laptop kernel: [    0.000000]   Intel GenuineIntel
May 16 14:56:26 brian-laptop kernel: [    0.000000]   AMD AuthenticAMD
May 16 14:56:26 brian-laptop kernel: [    0.000000]   Centaur CentaurHaul=
s
May 16 14:56:26 brian-laptop kernel: [    0.000000] e820: BIOS-provided p=
hysical RAM map:
May 16 14:56:26 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
0000000000000-0x000000000006efff] usable
May 16 14:56:26 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
000000006f000-0x000000000006ffff] reserved
May 16 14:56:26 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
0000000070000-0x0000000000087fff] usable
May 16 14:56:26 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
0000000088000-0x00000000000bffff] reserved
May 16 14:56:26 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
0000000100000-0x000000007a8fffff] usable
May 16 14:56:26 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
000007a900000-0x000000007bcfffff] reserved
May 16 14:56:26 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
000007bd00000-0x000000009c6befff] usable
May 16 14:56:26 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
000009c6bf000-0x000000009c8befff] type 20
May 16 14:56:26 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
000009c8bf000-0x000000009cebefff] reserved
May 16 14:56:26 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
000009cebf000-0x000000009cfbefff] ACPI NVS
May 16 14:56:26 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
000009cfbf000-0x000000009cffefff] ACPI data
May 16 14:56:26 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
000009cfff000-0x000000009cffffff] usable
May 16 14:56:26 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
000009d000000-0x000000009f9fffff] reserved
May 16 14:56:26 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
00000e0000000-0x00000000efffffff] reserved
May 16 14:56:26 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
00000fe101000-0x00000000fe112fff] reserved
May 16 14:56:26 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
00000feb00000-0x00000000feb0ffff] reserved
May 16 14:56:26 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
00000fec00000-0x00000000fec00fff] reserved
May 16 14:56:26 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
00000fed00000-0x00000000fee00fff] reserved
May 16 14:56:26 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
00000ffc00000-0x00000000ffffffff] reserved
May 16 14:56:26 brian-laptop kernel: [    0.000000] BIOS-e820: [mem 0x000=
0000100000000-0x000000025f5fffff] usable
May 16 14:56:26 brian-laptop kernel: [    0.000000] NX (Execute Disable) =
protection: active
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: EFI v2.31 by INS=
YDE Corp.
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi:  ACPI=3D0x9cffe0=
00  ACPI 2.0=3D0x9cffe014  SMBIOS=3D0x9cebef98=20
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem00: type=3D3,=
 attr=3D0xf, range=3D[0x0000000000000000-0x0000000000001000) (0MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem01: type=3D7,=
 attr=3D0xf, range=3D[0x0000000000001000-0x000000000000e000) (0MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem02: type=3D3,=
 attr=3D0xf, range=3D[0x000000000000e000-0x0000000000010000) (0MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem03: type=3D7,=
 attr=3D0xf, range=3D[0x0000000000010000-0x000000000002e000) (0MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem04: type=3D3,=
 attr=3D0xf, range=3D[0x000000000002e000-0x000000000002f000) (0MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem05: type=3D4,=
 attr=3D0xf, range=3D[0x000000000002f000-0x0000000000030000) (0MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem06: type=3D3,=
 attr=3D0xf, range=3D[0x0000000000030000-0x000000000006f000) (0MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem07: type=3D0,=
 attr=3D0xf, range=3D[0x000000000006f000-0x0000000000070000) (0MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem08: type=3D3,=
 attr=3D0xf, range=3D[0x0000000000070000-0x0000000000088000) (0MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem09: type=3D6,=
 attr=3D0x800000000000000f, range=3D[0x0000000000088000-0x000000000009e00=
0) (0MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem10: type=3D0,=
 attr=3D0xf, range=3D[0x000000000009e000-0x000000000009f000) (0MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem11: type=3D6,=
 attr=3D0x800000000000000f, range=3D[0x000000000009f000-0x00000000000a000=
0) (0MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem12: type=3D2,=
 attr=3D0xf, range=3D[0x0000000000100000-0x00000000014ff000) (19MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem13: type=3D7,=
 attr=3D0xf, range=3D[0x00000000014ff000-0x0000000002000000) (11MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem14: type=3D2,=
 attr=3D0xf, range=3D[0x0000000002000000-0x00000000033ff000) (19MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem15: type=3D7,=
 attr=3D0xf, range=3D[0x00000000033ff000-0x0000000035b9c000) (807MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem16: type=3D2,=
 attr=3D0xf, range=3D[0x0000000035b9c000-0x0000000036dc6000) (18MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem17: type=3D7,=
 attr=3D0xf, range=3D[0x0000000036dc6000-0x0000000053db5000) (463MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem18: type=3D2,=
 attr=3D0xf, range=3D[0x0000000053db5000-0x0000000078d10000) (591MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem19: type=3D4,=
 attr=3D0xf, range=3D[0x0000000078d10000-0x0000000078d30000) (0MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem20: type=3D7,=
 attr=3D0xf, range=3D[0x0000000078d30000-0x00000000798a4000) (11MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem21: type=3D2,=
 attr=3D0xf, range=3D[0x00000000798a4000-0x0000000079a78000) (1MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem22: type=3D4,=
 attr=3D0xf, range=3D[0x0000000079a78000-0x000000007a900000) (14MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem23: type=3D0,=
 attr=3D0xf, range=3D[0x000000007a900000-0x000000007bd00000) (20MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem24: type=3D7,=
 attr=3D0xf, range=3D[0x000000007bd00000-0x000000007bd0d000) (0MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem25: type=3D2,=
 attr=3D0xf, range=3D[0x000000007bd0d000-0x000000007bd0f000) (0MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem26: type=3D7,=
 attr=3D0xf, range=3D[0x000000007bd0f000-0x000000007bddb000) (0MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem27: type=3D1,=
 attr=3D0xf, range=3D[0x000000007bddb000-0x000000007bf0f000) (1MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem28: type=3D7,=
 attr=3D0xf, range=3D[0x000000007bf0f000-0x000000007e1c3000) (34MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem29: type=3D4,=
 attr=3D0xf, range=3D[0x000000007e1c3000-0x000000007e1cf000) (0MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem30: type=3D7,=
 attr=3D0xf, range=3D[0x000000007e1cf000-0x000000007e20b000) (0MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem31: type=3D4,=
 attr=3D0xf, range=3D[0x000000007e20b000-0x000000007eee1000) (12MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem32: type=3D7,=
 attr=3D0xf, range=3D[0x000000007eee1000-0x000000007eee3000) (0MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem33: type=3D4,=
 attr=3D0xf, range=3D[0x000000007eee3000-0x0000000081f91000) (48MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem34: type=3D7,=
 attr=3D0xf, range=3D[0x0000000081f91000-0x0000000081f94000) (0MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem35: type=3D4,=
 attr=3D0xf, range=3D[0x0000000081f94000-0x0000000081fbd000) (0MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem36: type=3D7,=
 attr=3D0xf, range=3D[0x0000000081fbd000-0x0000000081fbe000) (0MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem37: type=3D4,=
 attr=3D0xf, range=3D[0x0000000081fbe000-0x0000000082161000) (1MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem38: type=3D7,=
 attr=3D0xf, range=3D[0x0000000082161000-0x0000000082165000) (0MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem39: type=3D4,=
 attr=3D0xf, range=3D[0x0000000082165000-0x000000008216a000) (0MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem40: type=3D7,=
 attr=3D0xf, range=3D[0x000000008216a000-0x000000008216b000) (0MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem41: type=3D4,=
 attr=3D0xf, range=3D[0x000000008216b000-0x00000000821d9000) (0MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem42: type=3D7,=
 attr=3D0xf, range=3D[0x00000000821d9000-0x00000000821da000) (0MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem43: type=3D4,=
 attr=3D0xf, range=3D[0x00000000821da000-0x00000000821e1000) (0MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem44: type=3D7,=
 attr=3D0xf, range=3D[0x00000000821e1000-0x00000000821e4000) (0MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem45: type=3D4,=
 attr=3D0xf, range=3D[0x00000000821e4000-0x00000000821e6000) (0MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem46: type=3D7,=
 attr=3D0xf, range=3D[0x00000000821e6000-0x00000000821e8000) (0MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem47: type=3D4,=
 attr=3D0xf, range=3D[0x00000000821e8000-0x000000008408f000) (30MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem48: type=3D7,=
 attr=3D0xf, range=3D[0x000000008408f000-0x000000008c2a5000) (130MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem49: type=3D3,=
 attr=3D0xf, range=3D[0x000000008c2a5000-0x000000008c2c6000) (0MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem50: type=3D7,=
 attr=3D0xf, range=3D[0x000000008c2c6000-0x000000009c2bc000) (255MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem51: type=3D2,=
 attr=3D0xf, range=3D[0x000000009c2bc000-0x000000009c2c6000) (0MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem52: type=3D3,=
 attr=3D0xf, range=3D[0x000000009c2c6000-0x000000009c6bf000) (3MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem53: type=3D5,=
 attr=3D0x800000000000000f, range=3D[0x000000009c6bf000-0x000000009c8bf00=
0) (2MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem54: type=3D6,=
 attr=3D0x800000000000000f, range=3D[0x000000009c8bf000-0x000000009cabf00=
0) (2MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem55: type=3D0,=
 attr=3D0xf, range=3D[0x000000009cabf000-0x000000009cebf000) (4MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem56: type=3D10=
, attr=3D0xf, range=3D[0x000000009cebf000-0x000000009cfbf000) (1MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem57: type=3D9,=
 attr=3D0xf, range=3D[0x000000009cfbf000-0x000000009cfff000) (0MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem58: type=3D4,=
 attr=3D0xf, range=3D[0x000000009cfff000-0x000000009d000000) (0MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem59: type=3D7,=
 attr=3D0xf, range=3D[0x0000000100000000-0x000000025f600000) (5622MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem60: type=3D0,=
 attr=3D0x0, range=3D[0x00000000000a0000-0x00000000000c0000) (0MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem61: type=3D0,=
 attr=3D0x0, range=3D[0x000000009d000000-0x000000009fa00000) (42MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem62: type=3D11=
, attr=3D0x8000000000000001, range=3D[0x00000000e0000000-0x00000000f00000=
00) (256MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem63: type=3D0,=
 attr=3D0x0, range=3D[0x00000000fe101000-0x00000000fe113000) (0MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem64: type=3D11=
, attr=3D0x8000000000000001, range=3D[0x00000000feb00000-0x00000000feb100=
00) (0MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem65: type=3D11=
, attr=3D0x8000000000000001, range=3D[0x00000000fec00000-0x00000000fec010=
00) (0MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem66: type=3D11=
, attr=3D0x8000000000000001, range=3D[0x00000000fed00000-0x00000000fed1c0=
00) (0MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem67: type=3D11=
, attr=3D0x8000000000000000, range=3D[0x00000000fed1c000-0x00000000fed200=
00) (0MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem68: type=3D11=
, attr=3D0x8000000000000001, range=3D[0x00000000fed20000-0x00000000fee010=
00) (0MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] efi: mem69: type=3D11=
, attr=3D0x8000000000000000, range=3D[0x00000000ffc00000-0x00000001000000=
00) (4MB)
May 16 14:56:26 brian-laptop kernel: [    0.000000] SMBIOS 2.7 present.
May 16 14:56:26 brian-laptop kernel: [    0.000000] DMI: LENOVO 20266/Yog=
a2, BIOS 76CN27WW 09/17/2013
May 16 14:56:26 brian-laptop kernel: [    0.000000] e820: update [mem 0x0=
0000000-0x00000fff] usable =3D=3D> reserved
May 16 14:56:26 brian-laptop kernel: [    0.000000] e820: remove [mem 0x0=
00a0000-0x000fffff] usable
May 16 14:56:26 brian-laptop kernel: [    0.000000] No AGP bridge found
May 16 14:56:26 brian-laptop kernel: [    0.000000] e820: last_pfn =3D 0x=
25f600 max_arch_pfn =3D 0x400000000
May 16 14:56:26 brian-laptop kernel: [    0.000000] MTRR default type: un=
cachable
May 16 14:56:26 brian-laptop kernel: [    0.000000] MTRR fixed ranges ena=
bled:
May 16 14:56:26 brian-laptop kernel: [    0.000000]   00000-9FFFF write-b=
ack
May 16 14:56:26 brian-laptop kernel: [    0.000000]   A0000-BFFFF uncacha=
ble
May 16 14:56:26 brian-laptop kernel: [    0.000000]   C0000-E7FFF write-p=
rotect
May 16 14:56:26 brian-laptop kernel: [    0.000000]   E8000-EFFFF write-c=
ombining
May 16 14:56:26 brian-laptop kernel: [    0.000000]   F0000-FFFFF write-p=
rotect
May 16 14:56:26 brian-laptop kernel: [    0.000000] MTRR variable ranges =
enabled:
May 16 14:56:26 brian-laptop kernel: [    0.000000]   0 base 0000000000 m=
ask 7F80000000 write-back
May 16 14:56:26 brian-laptop kernel: [    0.000000]   1 base 0080000000 m=
ask 7FE0000000 write-back
May 16 14:56:26 brian-laptop kernel: [    0.000000]   2 base 009D000000 m=
ask 7FFF000000 uncachable
May 16 14:56:26 brian-laptop kernel: [    0.000000]   3 base 009E000000 m=
ask 7FFE000000 uncachable
May 16 14:56:26 brian-laptop kernel: [    0.000000]   4 base 00FFC00000 m=
ask 7FFFC00000 write-protect
May 16 14:56:26 brian-laptop kernel: [    0.000000]   5 base 0100000000 m=
ask 7F00000000 write-back
May 16 14:56:26 brian-laptop kernel: [    0.000000]   6 base 0200000000 m=
ask 7F80000000 write-back
May 16 14:56:26 brian-laptop kernel: [    0.000000]   7 base 025F600000 m=
ask 7FFFE00000 uncachable
May 16 14:56:26 brian-laptop kernel: [    0.000000]   8 base 025F800000 m=
ask 7FFF800000 uncachable
May 16 14:56:26 brian-laptop kernel: [    0.000000]   9 base 0260000000 m=
ask 7FE0000000 uncachable
May 16 14:56:26 brian-laptop kernel: [    0.000000] x86 PAT enabled: cpu =
0, old 0x7040600070406, new 0x7010600070106
May 16 14:56:26 brian-laptop kernel: [    0.000000] e820: last_pfn =3D 0x=
9d000 max_arch_pfn =3D 0x400000000
May 16 14:56:26 brian-laptop kernel: [    0.000000] found SMP MP-table at=
 [mem 0x000fe1b0-0x000fe1bf] mapped at [ffff8800000fe1b0]
May 16 14:56:26 brian-laptop kernel: [    0.000000] Scanning 1 areas for =
low memory corruption
May 16 14:56:26 brian-laptop kernel: [    0.000000] Base memory trampolin=
e at [ffff880000024000] 24000 size 24576
May 16 14:56:26 brian-laptop kernel: [    0.000000] Using GB pages for di=
rect mapping
May 16 14:56:26 brian-laptop kernel: [    0.000000] init_memory_mapping: =
[mem 0x00000000-0x000fffff]
May 16 14:56:26 brian-laptop kernel: [    0.000000]  [mem 0x00000000-0x00=
0fffff] page 4k
May 16 14:56:26 brian-laptop kernel: [    0.000000] BRK [0x02fdd000, 0x02=
fddfff] PGTABLE
May 16 14:56:26 brian-laptop kernel: [    0.000000] BRK [0x02fde000, 0x02=
fdefff] PGTABLE
May 16 14:56:26 brian-laptop kernel: [    0.000000] BRK [0x02fdf000, 0x02=
fdffff] PGTABLE
May 16 14:56:26 brian-laptop kernel: [    0.000000] init_memory_mapping: =
[mem 0x25f400000-0x25f5fffff]
May 16 14:56:26 brian-laptop kernel: [    0.000000]  [mem 0x25f400000-0x2=
5f5fffff] page 2M
May 16 14:56:26 brian-laptop kernel: [    0.000000] BRK [0x02fe0000, 0x02=
fe0fff] PGTABLE
May 16 14:56:26 brian-laptop kernel: [    0.000000] init_memory_mapping: =
[mem 0x25c000000-0x25f3fffff]
May 16 14:56:26 brian-laptop kernel: [    0.000000]  [mem 0x25c000000-0x2=
5f3fffff] page 2M
May 16 14:56:26 brian-laptop kernel: [    0.000000] init_memory_mapping: =
[mem 0x200000000-0x25bffffff]
May 16 14:56:26 brian-laptop kernel: [    0.000000]  [mem 0x200000000-0x2=
3fffffff] page 1G
May 16 14:56:26 brian-laptop kernel: [    0.000000]  [mem 0x240000000-0x2=
5bffffff] page 2M
May 16 14:56:26 brian-laptop kernel: [    0.000000] init_memory_mapping: =
[mem 0x00100000-0x7a8fffff]
May 16 14:56:26 brian-laptop kernel: [    0.000000]  [mem 0x00100000-0x00=
1fffff] page 4k
May 16 14:56:26 brian-laptop kernel: [    0.000000]  [mem 0x00200000-0x7a=
7fffff] page 2M
May 16 14:56:26 brian-laptop kernel: [    0.000000]  [mem 0x7a800000-0x7a=
8fffff] page 4k
May 16 14:56:26 brian-laptop kernel: [    0.000000] init_memory_mapping: =
[mem 0x7bd00000-0x9c6befff]
May 16 14:56:26 brian-laptop kernel: [    0.000000]  [mem 0x7bd00000-0x7b=
dfffff] page 4k
May 16 14:56:26 brian-laptop kernel: [    0.000000]  [mem 0x7be00000-0x9c=
5fffff] page 2M
May 16 14:56:26 brian-laptop kernel: [    0.000000]  [mem 0x9c600000-0x9c=
6befff] page 4k
May 16 14:56:26 brian-laptop kernel: [    0.000000] BRK [0x02fe1000, 0x02=
fe1fff] PGTABLE
May 16 14:56:26 brian-laptop kernel: [    0.000000] BRK [0x02fe2000, 0x02=
fe2fff] PGTABLE
May 16 14:56:26 brian-laptop kernel: [    0.000000] init_memory_mapping: =
[mem 0x9cfff000-0x9cffffff]
May 16 14:56:26 brian-laptop kernel: [    0.000000]  [mem 0x9cfff000-0x9c=
ffffff] page 4k
May 16 14:56:26 brian-laptop kernel: [    0.000000] init_memory_mapping: =
[mem 0x100000000-0x1ffffffff]
May 16 14:56:26 brian-laptop kernel: [    0.000000]  [mem 0x100000000-0x1=
ffffffff] page 1G
May 16 14:56:26 brian-laptop kernel: [    0.000000] RAMDISK: [mem 0x35b9c=
000-0x36dc5fff]
May 16 14:56:26 brian-laptop kernel: [    0.000000] ACPI: RSDP 000000009c=
ffe014 000024 (v02 LENOVO)
May 16 14:56:26 brian-laptop kernel: [    0.000000] ACPI: XSDT 000000009c=
ffe210 0000C4 (v01 LENOVO CB-01    00000001      01000013)
May 16 14:56:26 brian-laptop kernel: [    0.000000] ACPI: FACP 000000009c=
feb000 00010C (v05 LENOVO CB-01    00000001 ACPI 00040000)
May 16 14:56:26 brian-laptop kernel: [    0.000000] ACPI Error: Gpe0Block=
 - 32-bit FADT register is too long (32 bytes, 256 bits) to convert to GA=
S struct - 255 bits max, truncating (20131115/tbfadt-202)
May 16 14:56:26 brian-laptop kernel: [    0.000000] ACPI: DSDT 000000009c=
fda000 00D0CA (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 14:56:26 brian-laptop kernel: [    0.000000] ACPI: FACS 000000009c=
fba000 000040
May 16 14:56:26 brian-laptop kernel: [    0.000000] ACPI: SLIC 000000009c=
ffd000 000176 (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 14:56:26 brian-laptop kernel: [    0.000000] ACPI: UEFI 000000009c=
ffc000 000236 (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 14:56:26 brian-laptop kernel: [    0.000000] ACPI: SSDT 000000009c=
ff0000 00B0FA (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 14:56:26 brian-laptop kernel: [    0.000000] ACPI: FPDT 000000009c=
fee000 000044 (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 14:56:26 brian-laptop kernel: [    0.000000] ACPI: MSDM 000000009c=
fed000 000055 (v03 LENOVO CB-01    00000001 ACPI 00040000)
May 16 14:56:26 brian-laptop kernel: [    0.000000] ACPI: ASF! 000000009c=
fec000 0000A5 (v32 LENOVO CB-01    00000001 ACPI 00040000)
May 16 14:56:26 brian-laptop kernel: [    0.000000] ACPI: HPET 000000009c=
fea000 000038 (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 14:56:26 brian-laptop kernel: [    0.000000] ACPI: APIC 000000009c=
fe9000 00008C (v03 LENOVO CB-01    00000001 ACPI 00040000)
May 16 14:56:26 brian-laptop kernel: [    0.000000] ACPI: MCFG 000000009c=
fe8000 00003C (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 14:56:26 brian-laptop kernel: [    0.000000] ACPI: SSDT 000000009c=
fd7000 002028 (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 14:56:26 brian-laptop kernel: [    0.000000] ACPI: BOOT 000000009c=
fd5000 000028 (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 14:56:26 brian-laptop kernel: [    0.000000] ACPI: LPIT 000000009c=
fd4000 000094 (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 14:56:26 brian-laptop kernel: [    0.000000] ACPI: ASPT 000000009c=
fd2000 000034 (v07 LENOVO CB-01    00000001 ACPI 00040000)
May 16 14:56:26 brian-laptop kernel: [    0.000000] ACPI: DBGP 000000009c=
fd1000 000034 (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 14:56:26 brian-laptop kernel: [    0.000000] ACPI: SSDT 000000009c=
fce000 000539 (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 14:56:26 brian-laptop kernel: [    0.000000] ACPI: SSDT 000000009c=
fcd000 000AD8 (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 14:56:26 brian-laptop kernel: [    0.000000] ACPI: SSDT 000000009c=
fc9000 003496 (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 14:56:26 brian-laptop kernel: [    0.000000] ACPI: SSDT 000000009c=
fc8000 0007C7 (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 14:56:26 brian-laptop kernel: [    0.000000] ACPI: BGRT 000000009c=
fc7000 000038 (v01 LENOVO CB-01    00000001 ACPI 00040000)
May 16 14:56:26 brian-laptop kernel: [    0.000000] ACPI: Local APIC addr=
ess 0xfee00000
May 16 14:56:26 brian-laptop kernel: [    0.000000] No NUMA configuration=
 found
May 16 14:56:26 brian-laptop kernel: [    0.000000] Faking a node at [mem=
 0x0000000000000000-0x000000025f5fffff]
May 16 14:56:26 brian-laptop kernel: [    0.000000] Initmem setup node 0 =
[mem 0x00000000-0x25f5fffff]
May 16 14:56:26 brian-laptop kernel: [    0.000000]   NODE_DATA [mem 0x25=
f5f7000-0x25f5fbfff]
May 16 14:56:26 brian-laptop kernel: [    0.000000]  [ffffea0000000000-ff=
ffea00097fffff] PMD -> [ffff880256c00000-ffff88025ebfffff] on node 0
May 16 14:56:26 brian-laptop kernel: [    0.000000] Zone ranges:
May 16 14:56:26 brian-laptop kernel: [    0.000000]   DMA      [mem 0x000=
01000-0x00ffffff]
May 16 14:56:26 brian-laptop kernel: [    0.000000]   DMA32    [mem 0x010=
00000-0xffffffff]
May 16 14:56:26 brian-laptop kernel: [    0.000000]   Normal   [mem 0x100=
000000-0x25f5fffff]
May 16 14:56:26 brian-laptop kernel: [    0.000000] Movable zone start fo=
r each node
May 16 14:56:26 brian-laptop kernel: [    0.000000] Early memory node ran=
ges
May 16 14:56:26 brian-laptop kernel: [    0.000000]   node   0: [mem 0x00=
001000-0x0006efff]
May 16 14:56:26 brian-laptop kernel: [    0.000000]   node   0: [mem 0x00=
070000-0x00087fff]
May 16 14:56:26 brian-laptop kernel: [    0.000000]   node   0: [mem 0x00=
100000-0x7a8fffff]
May 16 14:56:26 brian-laptop kernel: [    0.000000]   node   0: [mem 0x7b=
d00000-0x9c6befff]
May 16 14:56:26 brian-laptop kernel: [    0.000000]   node   0: [mem 0x9c=
fff000-0x9cffffff]
May 16 14:56:26 brian-laptop kernel: [    0.000000]   node   0: [mem 0x10=
0000000-0x25f5fffff]
May 16 14:56:26 brian-laptop kernel: [    0.000000] On node 0 totalpages:=
 2074694
May 16 14:56:26 brian-laptop kernel: [    0.000000]   DMA zone: 64 pages =
used for memmap
May 16 14:56:26 brian-laptop kernel: [    0.000000]   DMA zone: 111 pages=
 reserved
May 16 14:56:26 brian-laptop kernel: [    0.000000]   DMA zone: 3974 page=
s, LIFO batch:0
May 16 14:56:26 brian-laptop kernel: [    0.000000]   DMA32 zone: 9867 pa=
ges used for memmap
May 16 14:56:26 brian-laptop kernel: [    0.000000]   DMA32 zone: 631488 =
pages, LIFO batch:31
May 16 14:56:26 brian-laptop kernel: [    0.000000]   Normal zone: 22488 =
pages used for memmap
May 16 14:56:26 brian-laptop kernel: [    0.000000]   Normal zone: 143923=
2 pages, LIFO batch:31
May 16 14:56:26 brian-laptop kernel: [    0.000000] ACPI: PM-Timer IO Por=
t: 0x1808
May 16 14:56:26 brian-laptop kernel: [    0.000000] ACPI: Local APIC addr=
ess 0xfee00000
May 16 14:56:26 brian-laptop kernel: [    0.000000] ACPI: LAPIC (acpi_id[=
0x01] lapic_id[0x00] enabled)
May 16 14:56:26 brian-laptop kernel: [    0.000000] ACPI: LAPIC (acpi_id[=
0x02] lapic_id[0x01] enabled)
May 16 14:56:26 brian-laptop kernel: [    0.000000] ACPI: LAPIC (acpi_id[=
0x03] lapic_id[0x02] enabled)
May 16 14:56:26 brian-laptop kernel: [    0.000000] ACPI: LAPIC (acpi_id[=
0x04] lapic_id[0x03] enabled)
May 16 14:56:26 brian-laptop kernel: [    0.000000] ACPI: LAPIC (acpi_id[=
0x05] lapic_id[0x00] disabled)
May 16 14:56:26 brian-laptop kernel: [    0.000000] ACPI: LAPIC (acpi_id[=
0x06] lapic_id[0x00] disabled)
May 16 14:56:26 brian-laptop kernel: [    0.000000] ACPI: LAPIC (acpi_id[=
0x07] lapic_id[0x00] disabled)
May 16 14:56:26 brian-laptop kernel: [    0.000000] ACPI: LAPIC (acpi_id[=
0x08] lapic_id[0x00] disabled)
May 16 14:56:26 brian-laptop kernel: [    0.000000] ACPI: IOAPIC (id[0x02=
] address[0xfec00000] gsi_base[0])
May 16 14:56:26 brian-laptop kernel: [    0.000000] IOAPIC[0]: apic_id 2,=
 version 32, address 0xfec00000, GSI 0-39
May 16 14:56:26 brian-laptop kernel: [    0.000000] ACPI: INT_SRC_OVR (bu=
s 0 bus_irq 0 global_irq 2 dfl dfl)
May 16 14:56:26 brian-laptop kernel: [    0.000000] ACPI: INT_SRC_OVR (bu=
s 0 bus_irq 9 global_irq 9 high level)
May 16 14:56:26 brian-laptop kernel: [    0.000000] ACPI: IRQ0 used by ov=
erride.
May 16 14:56:26 brian-laptop kernel: [    0.000000] ACPI: IRQ2 used by ov=
erride.
May 16 14:56:26 brian-laptop kernel: [    0.000000] ACPI: IRQ9 used by ov=
erride.
May 16 14:56:26 brian-laptop kernel: [    0.000000] Using ACPI (MADT) for=
 SMP configuration information
May 16 14:56:26 brian-laptop kernel: [    0.000000] ACPI: HPET id: 0x8086=
a201 base: 0xfed00000
May 16 14:56:26 brian-laptop kernel: [    0.000000] smpboot: Allowing 8 C=
PUs, 4 hotplug CPUs
May 16 14:56:26 brian-laptop kernel: [    0.000000] nr_irqs_gsi: 56
May 16 14:56:26 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0x0006f000-0x0006ffff]
May 16 14:56:26 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0x00088000-0x000bffff]
May 16 14:56:26 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0x000c0000-0x000fffff]
May 16 14:56:26 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0x7a900000-0x7bcfffff]
May 16 14:56:26 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0x9c6bf000-0x9c8befff]
May 16 14:56:26 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0x9c8bf000-0x9cebefff]
May 16 14:56:26 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0x9cebf000-0x9cfbefff]
May 16 14:56:26 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0x9cfbf000-0x9cffefff]
May 16 14:56:26 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0x9d000000-0x9f9fffff]
May 16 14:56:26 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0x9fa00000-0xdfffffff]
May 16 14:56:26 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0xe0000000-0xefffffff]
May 16 14:56:26 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0xf0000000-0xfe100fff]
May 16 14:56:26 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0xfe101000-0xfe112fff]
May 16 14:56:26 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0xfe113000-0xfeafffff]
May 16 14:56:26 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0xfeb00000-0xfeb0ffff]
May 16 14:56:26 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0xfeb10000-0xfebfffff]
May 16 14:56:26 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0xfec00000-0xfec00fff]
May 16 14:56:26 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0xfec01000-0xfecfffff]
May 16 14:56:26 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0xfed00000-0xfee00fff]
May 16 14:56:26 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0xfee01000-0xffbfffff]
May 16 14:56:26 brian-laptop kernel: [    0.000000] PM: Registered nosave=
 memory: [mem 0xffc00000-0xffffffff]
May 16 14:56:26 brian-laptop kernel: [    0.000000] e820: [mem 0x9fa00000=
-0xdfffffff] available for PCI devices
May 16 14:56:26 brian-laptop kernel: [    0.000000] Booting paravirtualiz=
ed kernel on bare hardware
May 16 14:56:26 brian-laptop kernel: [    0.000000] setup_percpu: NR_CPUS=
:256 nr_cpumask_bits:256 nr_cpu_ids:8 nr_node_ids:1
May 16 14:56:26 brian-laptop kernel: [    0.000000] PERCPU: Embedded 29 p=
ages/cpu @ffff88025f200000 s86336 r8192 d24256 u262144
May 16 14:56:26 brian-laptop kernel: [    0.000000] pcpu-alloc: s86336 r8=
192 d24256 u262144 alloc=3D1*2097152
May 16 14:56:26 brian-laptop kernel: [    0.000000] pcpu-alloc: [0] 0 1 2=
 3 4 5 6 7=20
May 16 14:56:26 brian-laptop kernel: [    0.000000] Built 1 zonelists in =
Zone order, mobility grouping on.  Total pages: 2042164
May 16 14:56:26 brian-laptop kernel: [    0.000000] Policy zone: Normal
May 16 14:56:26 brian-laptop kernel: [    0.000000] Kernel command line: =
BOOT_IMAGE=3D/boot/vmlinuz-3.13.0-24-generic.efi.signed root=3DUUID=3D8e4=
7fdb9-aff2-414b-a81c-2df6486162cd ro acpi_backlight=3Dvendor quiet splash=
 vt.handoff=3D7
May 16 14:56:26 brian-laptop kernel: [    0.000000] PID hash table entrie=
s: 4096 (order: 3, 32768 bytes)
May 16 14:56:26 brian-laptop kernel: [    0.000000] xsave: enabled xstate=
_bv 0x7, cntxt size 0x340
May 16 14:56:26 brian-laptop kernel: [    0.000000] Checking aperture...
May 16 14:56:26 brian-laptop kernel: [    0.000000] No AGP bridge found
May 16 14:56:26 brian-laptop kernel: [    0.000000] Calgary: detecting Ca=
lgary via BIOS EBDA area
May 16 14:56:26 brian-laptop kernel: [    0.000000] Calgary: Unable to lo=
cate Rio Grande table in EBDA - bailing!
May 16 14:56:26 brian-laptop kernel: [    0.000000] Memory: 7949148K/8298=
776K available (7338K kernel code, 1138K rwdata, 3388K rodata, 1332K init=
, 1440K bss, 349628K reserved)
May 16 14:56:26 brian-laptop kernel: [    0.000000] SLUB: HWalign=3D64, O=
rder=3D0-3, MinObjects=3D0, CPUs=3D8, Nodes=3D1
May 16 14:56:26 brian-laptop kernel: [    0.000000] Hierarchical RCU impl=
ementation.
May 16 14:56:26 brian-laptop kernel: [    0.000000] 	RCU dyntick-idle gra=
ce-period acceleration is enabled.
May 16 14:56:26 brian-laptop kernel: [    0.000000] 	RCU restricting CPUs=
 from NR_CPUS=3D256 to nr_cpu_ids=3D8.
May 16 14:56:26 brian-laptop kernel: [    0.000000] 	Offload RCU callback=
s from all CPUs
May 16 14:56:26 brian-laptop kernel: [    0.000000] 	Offload RCU callback=
s from CPUs: 0-7.
May 16 14:56:26 brian-laptop kernel: [    0.000000] NR_IRQS:16640 nr_irqs=
:1016 16
May 16 14:56:26 brian-laptop kernel: [    0.000000] Console: colour dummy=
 device 80x25
May 16 14:56:26 brian-laptop kernel: [    0.000000] console [tty0] enable=
d
May 16 14:56:26 brian-laptop kernel: [    0.000000] allocated 33554432 by=
tes of page_cgroup
May 16 14:56:26 brian-laptop kernel: [    0.000000] please try 'cgroup_di=
sable=3Dmemory' option if you don't want memory cgroups
May 16 14:56:26 brian-laptop kernel: [    0.000000] hpet clockevent regis=
tered
May 16 14:56:26 brian-laptop kernel: [    0.000000] tsc: Fast TSC calibra=
tion failed
May 16 14:56:26 brian-laptop kernel: [    0.008000] tsc: PIT calibration =
matches HPET. 1 loops
May 16 14:56:26 brian-laptop kernel: [    0.008000] tsc: Detected 2394.45=
5 MHz processor
May 16 14:56:26 brian-laptop kernel: [    0.000002] Calibrating delay loo=
p (skipped), value calculated using timer frequency.. 4788.91 BogoMIPS (l=
pj=3D9577820)
May 16 14:56:26 brian-laptop kernel: [    0.000006] pid_max: default: 327=
68 minimum: 301
May 16 14:56:26 brian-laptop kernel: [    0.023264] Security Framework in=
itialized
May 16 14:56:26 brian-laptop kernel: [    0.023287] AppArmor: AppArmor in=
itialized
May 16 14:56:26 brian-laptop kernel: [    0.023288] Yama: becoming mindfu=
l.
May 16 14:56:26 brian-laptop kernel: [    0.024056] Dentry cache hash tab=
le entries: 1048576 (order: 11, 8388608 bytes)
May 16 14:56:26 brian-laptop kernel: [    0.026097] Inode-cache hash tabl=
e entries: 524288 (order: 10, 4194304 bytes)
May 16 14:56:26 brian-laptop kernel: [    0.026955] Mount-cache hash tabl=
e entries: 16384 (order: 5, 131072 bytes)
May 16 14:56:26 brian-laptop kernel: [    0.026968] Mountpoint-cache hash=
 table entries: 16384 (order: 5, 131072 bytes)
May 16 14:56:26 brian-laptop kernel: [    0.027207] Initializing cgroup s=
ubsys memory
May 16 14:56:26 brian-laptop kernel: [    0.027214] Initializing cgroup s=
ubsys devices
May 16 14:56:26 brian-laptop kernel: [    0.027216] Initializing cgroup s=
ubsys freezer
May 16 14:56:26 brian-laptop kernel: [    0.027218] Initializing cgroup s=
ubsys blkio
May 16 14:56:26 brian-laptop kernel: [    0.027220] Initializing cgroup s=
ubsys perf_event
May 16 14:56:26 brian-laptop kernel: [    0.027223] Initializing cgroup s=
ubsys hugetlb
May 16 14:56:26 brian-laptop kernel: [    0.027249] CPU: Physical Process=
or ID: 0
May 16 14:56:26 brian-laptop kernel: [    0.027250] CPU: Processor Core I=
D: 0
May 16 14:56:26 brian-laptop kernel: [    0.027255] ENERGY_PERF_BIAS: Set=
 to 'normal', was 'performance'
May 16 14:56:26 brian-laptop kernel: [    0.027255] ENERGY_PERF_BIAS: Vie=
w and update with x86_energy_perf_policy(8)
May 16 14:56:26 brian-laptop kernel: [    0.028452] mce: CPU supports 7 M=
CE banks
May 16 14:56:26 brian-laptop kernel: [    0.028471] CPU0: Thermal monitor=
ing enabled (TM1)
May 16 14:56:26 brian-laptop kernel: [    0.028484] Last level iTLB entri=
es: 4KB 0, 2MB 0, 4MB 0
May 16 14:56:26 brian-laptop kernel: [    0.028484] Last level dTLB entri=
es: 4KB 64, 2MB 0, 4MB 0
May 16 14:56:26 brian-laptop kernel: [    0.028484] tlb_flushall_shift: 6=

May 16 14:56:26 brian-laptop kernel: [    0.028618] Freeing SMP alternati=
ves memory: 32K (ffffffff81e6b000 - ffffffff81e73000)
May 16 14:56:26 brian-laptop kernel: [    0.029828] ACPI: Core revision 2=
0131115
May 16 14:56:26 brian-laptop kernel: [    0.043450] ACPI: All ACPI Tables=
 successfully acquired
May 16 14:56:26 brian-laptop kernel: [    0.050714] ftrace: allocating 28=
408 entries in 111 pages
May 16 14:56:26 brian-laptop kernel: [    0.066861] ..TIMER: vector=3D0x3=
0 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
May 16 14:56:26 brian-laptop kernel: [    0.106580] smpboot: CPU0: Intel(=
R) Core(TM) i7-4500U CPU @ 1.80GHz (fam: 06, model: 45, stepping: 01)
May 16 14:56:26 brian-laptop kernel: [    0.106590] TSC deadline timer en=
abled
May 16 14:56:26 brian-laptop kernel: [    0.109025] Performance Events: P=
EBS fmt2+, 16-deep LBR, Haswell events, full-width counters, Intel PMU dr=
iver.
May 16 14:56:26 brian-laptop kernel: [    0.109033] ... version:         =
       3
May 16 14:56:26 brian-laptop kernel: [    0.109035] ... bit width:       =
       48
May 16 14:56:26 brian-laptop kernel: [    0.109036] ... generic registers=
:      4
May 16 14:56:26 brian-laptop kernel: [    0.109037] ... value mask:      =
       0000ffffffffffff
May 16 14:56:26 brian-laptop kernel: [    0.109039] ... max period:      =
       0000ffffffffffff
May 16 14:56:26 brian-laptop kernel: [    0.109040] ... fixed-purpose eve=
nts:   3
May 16 14:56:26 brian-laptop kernel: [    0.109041] ... event mask:      =
       000000070000000f
May 16 14:56:26 brian-laptop kernel: [    0.111096] x86: Booting SMP conf=
iguration:
May 16 14:56:26 brian-laptop kernel: [    0.125735] NMI watchdog: enabled=
 on all CPUs, permanently consumes one hw-PMU counter.
May 16 14:56:26 brian-laptop kernel: [    0.111098] .... node  #0, CPUs: =
     #1 #2 #3
May 16 14:56:26 brian-laptop kernel: [    0.154640] x86: Booted up 1 node=
, 4 CPUs
May 16 14:56:26 brian-laptop kernel: [    0.154644] smpboot: Total of 4 p=
rocessors activated (19155.64 BogoMIPS)
May 16 14:56:26 brian-laptop kernel: [    0.160304] devtmpfs: initialized=

May 16 14:56:26 brian-laptop kernel: [    0.162862] EVM: security.selinux=

May 16 14:56:26 brian-laptop kernel: [    0.162864] EVM: security.SMACK64=

May 16 14:56:26 brian-laptop kernel: [    0.162865] EVM: security.ima
May 16 14:56:26 brian-laptop kernel: [    0.162866] EVM: security.capabil=
ity
May 16 14:56:26 brian-laptop kernel: [    0.162924] PM: Registering ACPI =
NVS region [mem 0x9cebf000-0x9cfbefff] (1048576 bytes)
May 16 14:56:26 brian-laptop kernel: [    0.163806] pinctrl core: initial=
ized pinctrl subsystem
May 16 14:56:26 brian-laptop kernel: [    0.163868] regulator-dummy: no p=
arameters
May 16 14:56:26 brian-laptop kernel: [    0.163930] RTC time: 14:56:24, d=
ate: 05/16/14
May 16 14:56:26 brian-laptop kernel: [    0.163967] NET: Registered proto=
col family 16
May 16 14:56:26 brian-laptop kernel: [    0.164087] cpuidle: using govern=
or ladder
May 16 14:56:26 brian-laptop kernel: [    0.164089] cpuidle: using govern=
or menu
May 16 14:56:26 brian-laptop kernel: [    0.164137] ACPI FADT declares th=
e system doesn't support PCIe ASPM, so disable it
May 16 14:56:26 brian-laptop kernel: [    0.164139] ACPI: bus type PCI re=
gistered
May 16 14:56:26 brian-laptop kernel: [    0.164141] acpiphp: ACPI Hot Plu=
g PCI Controller Driver version: 0.5
May 16 14:56:26 brian-laptop kernel: [    0.164213] PCI: MMCONFIG for dom=
ain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
May 16 14:56:26 brian-laptop kernel: [    0.164216] PCI: MMCONFIG at [mem=
 0xe0000000-0xefffffff] reserved in E820
May 16 14:56:26 brian-laptop kernel: [    0.197367] PCI: Using configurat=
ion type 1 for base access
May 16 14:56:26 brian-laptop kernel: [    0.198410] bio: create slab <bio=
-0> at 0
May 16 14:56:26 brian-laptop kernel: [    0.198576] ACPI: Added _OSI(Modu=
le Device)
May 16 14:56:26 brian-laptop kernel: [    0.198579] ACPI: Added _OSI(Proc=
essor Device)
May 16 14:56:26 brian-laptop kernel: [    0.198580] ACPI: Added _OSI(3.0 =
_SCP Extensions)
May 16 14:56:26 brian-laptop kernel: [    0.198582] ACPI: Added _OSI(Proc=
essor Aggregator Device)
May 16 14:56:26 brian-laptop kernel: [    0.205884] ACPI: Executed 1 bloc=
ks of module-level executable AML code
May 16 14:56:26 brian-laptop kernel: [    0.220172] [Firmware Bug]: ACPI:=
 BIOS _OSI(Linux) query ignored
May 16 14:56:26 brian-laptop kernel: [    0.221285] ACPI: SSDT 000000009c=
e7cc18 0003D3 (v01  PmRef  Cpu0Cst 00003001 INTL 20121220)
May 16 14:56:26 brian-laptop kernel: [    0.222183] ACPI: Dynamic OEM Tab=
le Load:
May 16 14:56:26 brian-laptop kernel: [    0.222185] ACPI: SSDT           =
(null) 0003D3 (v01  PmRef  Cpu0Cst 00003001 INTL 20121220)
May 16 14:56:26 brian-laptop kernel: [    0.224444] ACPI: SSDT 000000009c=
e7c618 0005AA (v01  PmRef    ApIst 00003000 INTL 20121220)
May 16 14:56:26 brian-laptop kernel: [    0.225427] ACPI: Dynamic OEM Tab=
le Load:
May 16 14:56:26 brian-laptop kernel: [    0.225429] ACPI: SSDT           =
(null) 0005AA (v01  PmRef    ApIst 00003000 INTL 20121220)
May 16 14:56:26 brian-laptop kernel: [    0.228266] ACPI: SSDT 000000009c=
e86c18 000119 (v01  PmRef    ApCst 00003000 INTL 20121220)
May 16 14:56:26 brian-laptop kernel: [    0.229161] ACPI: Dynamic OEM Tab=
le Load:
May 16 14:56:26 brian-laptop kernel: [    0.229163] ACPI: SSDT           =
(null) 000119 (v01  PmRef    ApCst 00003000 INTL 20121220)
May 16 14:56:26 brian-laptop kernel: [    0.235655] ACPI: Interpreter ena=
bled
May 16 14:56:26 brian-laptop kernel: [    0.235663] ACPI Exception: AE_NO=
T_FOUND, While evaluating Sleep State [\_S1_] (20131115/hwxface-580)
May 16 14:56:26 brian-laptop kernel: [    0.235671] ACPI Exception: AE_NO=
T_FOUND, While evaluating Sleep State [\_S2_] (20131115/hwxface-580)
May 16 14:56:26 brian-laptop kernel: [    0.235693] ACPI: (supports S0 S3=
 S4 S5)
May 16 14:56:26 brian-laptop kernel: [    0.235694] ACPI: Using IOAPIC fo=
r interrupt routing
May 16 14:56:26 brian-laptop kernel: [    0.235726] PCI: Using host bridg=
e windows from ACPI; if necessary, use "pci=3Dnocrs" and report a bug
May 16 14:56:26 brian-laptop kernel: [    0.236009] ACPI: No dock devices=
 found.
May 16 14:56:26 brian-laptop kernel: [    0.247855] ACPI: PCI Root Bridge=
 [PCI0] (domain 0000 [bus 00-fe])
May 16 14:56:26 brian-laptop kernel: [    0.247861] acpi PNP0A08:00: _OSC=
: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
May 16 14:56:26 brian-laptop kernel: [    0.248644] acpi PNP0A08:00: _OSC=
: OS now controls [PCIeHotplug PME AER PCIeCapability]
May 16 14:56:26 brian-laptop kernel: [    0.249641] PCI host bridge to bu=
s 0000:00
May 16 14:56:26 brian-laptop kernel: [    0.249645] pci_bus 0000:00: root=
 bus resource [bus 00-fe]
May 16 14:56:26 brian-laptop kernel: [    0.249647] pci_bus 0000:00: root=
 bus resource [io  0x0000-0x0cf7]
May 16 14:56:26 brian-laptop kernel: [    0.249649] pci_bus 0000:00: root=
 bus resource [io  0x0d00-0xffff]
May 16 14:56:26 brian-laptop kernel: [    0.249651] pci_bus 0000:00: root=
 bus resource [mem 0x000a0000-0x000bffff]
May 16 14:56:26 brian-laptop kernel: [    0.249653] pci_bus 0000:00: root=
 bus resource [mem 0x9fa00000-0xfeafffff]
May 16 14:56:26 brian-laptop kernel: [    0.249663] pci 0000:00:00.0: [80=
86:0a04] type 00 class 0x060000
May 16 14:56:26 brian-laptop kernel: [    0.249864] pci 0000:00:02.0: [80=
86:0a16] type 00 class 0x030000
May 16 14:56:26 brian-laptop kernel: [    0.249879] pci 0000:00:02.0: reg=
 0x10: [mem 0xb0000000-0xb03fffff 64bit]
May 16 14:56:26 brian-laptop kernel: [    0.249888] pci 0000:00:02.0: reg=
 0x18: [mem 0xa0000000-0xafffffff 64bit pref]
May 16 14:56:26 brian-laptop kernel: [    0.249894] pci 0000:00:02.0: reg=
 0x20: [io  0x3000-0x303f]
May 16 14:56:26 brian-laptop kernel: [    0.250084] pci 0000:00:03.0: [80=
86:0a0c] type 00 class 0x040300
May 16 14:56:26 brian-laptop kernel: [    0.250094] pci 0000:00:03.0: reg=
 0x10: [mem 0xb0518000-0xb051bfff 64bit]
May 16 14:56:26 brian-laptop kernel: [    0.250294] pci 0000:00:04.0: [80=
86:0a03] type 00 class 0x118000
May 16 14:56:26 brian-laptop kernel: [    0.250309] pci 0000:00:04.0: reg=
 0x10: [mem 0xb0510000-0xb0517fff 64bit]
May 16 14:56:26 brian-laptop kernel: [    0.250565] pci 0000:00:14.0: [80=
86:9c31] type 00 class 0x0c0330
May 16 14:56:26 brian-laptop kernel: [    0.250613] pci 0000:00:14.0: reg=
 0x10: [mem 0xb0500000-0xb050ffff 64bit]
May 16 14:56:26 brian-laptop kernel: [    0.250777] pci 0000:00:14.0: PME=
# supported from D3hot D3cold
May 16 14:56:26 brian-laptop kernel: [    0.250933] pci 0000:00:14.0: Sys=
tem wakeup disabled by ACPI
May 16 14:56:26 brian-laptop kernel: [    0.250982] pci 0000:00:16.0: [80=
86:9c3a] type 00 class 0x078000
May 16 14:56:26 brian-laptop kernel: [    0.251033] pci 0000:00:16.0: reg=
 0x10: [mem 0xb0520000-0xb052001f 64bit]
May 16 14:56:26 brian-laptop kernel: [    0.251206] pci 0000:00:16.0: PME=
# supported from D0 D3hot D3cold
May 16 14:56:26 brian-laptop kernel: [    0.251432] pci 0000:00:1b.0: [80=
86:9c20] type 00 class 0x040300
May 16 14:56:26 brian-laptop kernel: [    0.251468] pci 0000:00:1b.0: reg=
 0x10: [mem 0xb051c000-0xb051ffff 64bit]
May 16 14:56:26 brian-laptop kernel: [    0.251642] pci 0000:00:1b.0: PME=
# supported from D0 D3hot D3cold
May 16 14:56:26 brian-laptop kernel: [    0.251805] pci 0000:00:1b.0: Sys=
tem wakeup disabled by ACPI
May 16 14:56:26 brian-laptop kernel: [    0.251855] pci 0000:00:1c.0: [80=
86:9c10] type 01 class 0x060400
May 16 14:56:26 brian-laptop kernel: [    0.252046] pci 0000:00:1c.0: PME=
# supported from D0 D3hot D3cold
May 16 14:56:26 brian-laptop kernel: [    0.252221] pci 0000:00:1c.0: Sys=
tem wakeup disabled by ACPI
May 16 14:56:26 brian-laptop kernel: [    0.252290] pci 0000:00:1d.0: [80=
86:9c26] type 00 class 0x0c0320
May 16 14:56:26 brian-laptop kernel: [    0.252338] pci 0000:00:1d.0: reg=
 0x10: [mem 0xb0524000-0xb05243ff]
May 16 14:56:26 brian-laptop kernel: [    0.252555] pci 0000:00:1d.0: PME=
# supported from D0 D3hot D3cold
May 16 14:56:26 brian-laptop kernel: [    0.252732] pci 0000:00:1d.0: Sys=
tem wakeup disabled by ACPI
May 16 14:56:26 brian-laptop kernel: [    0.252782] pci 0000:00:1f.0: [80=
86:9c43] type 00 class 0x060100
May 16 14:56:26 brian-laptop kernel: [    0.253200] pci 0000:00:1f.2: [80=
86:9c03] type 00 class 0x010601
May 16 14:56:26 brian-laptop kernel: [    0.253242] pci 0000:00:1f.2: reg=
 0x10: [io  0x3088-0x308f]
May 16 14:56:26 brian-laptop kernel: [    0.253261] pci 0000:00:1f.2: reg=
 0x14: [io  0x3094-0x3097]
May 16 14:56:26 brian-laptop kernel: [    0.253279] pci 0000:00:1f.2: reg=
 0x18: [io  0x3080-0x3087]
May 16 14:56:26 brian-laptop kernel: [    0.253298] pci 0000:00:1f.2: reg=
 0x1c: [io  0x3090-0x3093]
May 16 14:56:26 brian-laptop kernel: [    0.253316] pci 0000:00:1f.2: reg=
 0x20: [io  0x3060-0x307f]
May 16 14:56:26 brian-laptop kernel: [    0.253335] pci 0000:00:1f.2: reg=
 0x24: [mem 0xb0523000-0xb05237ff]
May 16 14:56:26 brian-laptop kernel: [    0.253441] pci 0000:00:1f.2: PME=
# supported from D3hot
May 16 14:56:26 brian-laptop kernel: [    0.253625] pci 0000:00:1f.3: [80=
86:9c22] type 00 class 0x0c0500
May 16 14:56:26 brian-laptop kernel: [    0.253661] pci 0000:00:1f.3: reg=
 0x10: [mem 0xb0521000-0xb05210ff 64bit]
May 16 14:56:26 brian-laptop kernel: [    0.253713] pci 0000:00:1f.3: reg=
 0x20: [io  0x3040-0x305f]
May 16 14:56:26 brian-laptop kernel: [    0.253945] pci 0000:00:1f.6: [80=
86:9c24] type 00 class 0x118000
May 16 14:56:26 brian-laptop kernel: [    0.254006] pci 0000:00:1f.6: reg=
 0x10: [mem 0xb0522000-0xb0522fff 64bit]
May 16 14:56:26 brian-laptop kernel: [    0.254721] pci 0000:01:00.0: [80=
86:08b2] type 00 class 0x028000
May 16 14:56:26 brian-laptop kernel: [    0.254806] pci 0000:01:00.0: reg=
 0x10: [mem 0xb0400000-0xb0401fff 64bit]
May 16 14:56:26 brian-laptop kernel: [    0.255026] pci 0000:01:00.0: PME=
# supported from D0 D3hot D3cold
May 16 14:56:26 brian-laptop kernel: [    0.255116] pci 0000:01:00.0: Sys=
tem wakeup disabled by ACPI
May 16 14:56:26 brian-laptop kernel: [    0.260374] pci 0000:00:1c.0: PCI=
 bridge to [bus 01]
May 16 14:56:26 brian-laptop kernel: [    0.260385] pci 0000:00:1c.0:   b=
ridge window [mem 0xb0400000-0xb04fffff]
May 16 14:56:26 brian-laptop kernel: [    0.260552] acpi PNP0A08:00: Disa=
bling ASPM (FADT indicates it is unsupported)
May 16 14:56:26 brian-laptop kernel: [    0.261874] ACPI: PCI Interrupt L=
ink [LNKA] (IRQs 3 4 5 6 10 11 12 14 15) *7
May 16 14:56:26 brian-laptop kernel: [    0.261933] ACPI: PCI Interrupt L=
ink [LNKB] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
May 16 14:56:26 brian-laptop kernel: [    0.261989] ACPI: PCI Interrupt L=
ink [LNKC] (IRQs 3 4 5 6 10 *11 12 14 15)
May 16 14:56:26 brian-laptop kernel: [    0.262043] ACPI: PCI Interrupt L=
ink [LNKD] (IRQs 3 4 5 6 *10 11 12 14 15)
May 16 14:56:26 brian-laptop kernel: [    0.262097] ACPI: PCI Interrupt L=
ink [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
May 16 14:56:26 brian-laptop kernel: [    0.262152] ACPI: PCI Interrupt L=
ink [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
May 16 14:56:26 brian-laptop kernel: [    0.262206] ACPI: PCI Interrupt L=
ink [LNKG] (IRQs 3 4 5 6 *10 11 12 14 15)
May 16 14:56:26 brian-laptop kernel: [    0.262260] ACPI: PCI Interrupt L=
ink [LNKH] (IRQs 3 4 5 6 10 *11 12 14 15)
May 16 14:56:26 brian-laptop kernel: [    0.262934] ACPI: Enabled 5 GPEs =
in block 00 to 7F
May 16 14:56:26 brian-laptop kernel: [    0.262942] ACPI: \_SB_.PCI0: not=
ify handler is installed
May 16 14:56:26 brian-laptop kernel: [    0.263052] Found 1 acpi root dev=
ices
May 16 14:56:26 brian-laptop kernel: [    0.263111] ACPI : EC: GPE =3D 0x=
a, I/O: command/status =3D 0x66, data =3D 0x62
May 16 14:56:26 brian-laptop kernel: [    0.263210] vgaarb: device added:=
 PCI:0000:00:02.0,decodes=3Dio+mem,owns=3Dio+mem,locks=3Dnone
May 16 14:56:26 brian-laptop kernel: [    0.263214] vgaarb: loaded
May 16 14:56:26 brian-laptop kernel: [    0.263215] vgaarb: bridge contro=
l possible 0000:00:02.0
May 16 14:56:26 brian-laptop kernel: [    0.263378] SCSI subsystem initia=
lized
May 16 14:56:26 brian-laptop kernel: [    0.263429] libata version 3.00 l=
oaded.
May 16 14:56:26 brian-laptop kernel: [    0.263448] ACPI: bus type USB re=
gistered
May 16 14:56:26 brian-laptop kernel: [    0.263464] usbcore: registered n=
ew interface driver usbfs
May 16 14:56:26 brian-laptop kernel: [    0.263473] usbcore: registered n=
ew interface driver hub
May 16 14:56:26 brian-laptop kernel: [    0.263496] usbcore: registered n=
ew device driver usb
May 16 14:56:26 brian-laptop kernel: [    0.263613] PCI: Using ACPI for I=
RQ routing
May 16 14:56:26 brian-laptop kernel: [    0.269544] PCI: pci_cache_line_s=
ize set to 64 bytes
May 16 14:56:26 brian-laptop kernel: [    0.269584] e820: reserve RAM buf=
fer [mem 0x0006f000-0x0006ffff]
May 16 14:56:26 brian-laptop kernel: [    0.269585] e820: reserve RAM buf=
fer [mem 0x00088000-0x0008ffff]
May 16 14:56:26 brian-laptop kernel: [    0.269587] e820: reserve RAM buf=
fer [mem 0x7a900000-0x7bffffff]
May 16 14:56:26 brian-laptop kernel: [    0.269589] e820: reserve RAM buf=
fer [mem 0x9c6bf000-0x9fffffff]
May 16 14:56:26 brian-laptop kernel: [    0.269591] e820: reserve RAM buf=
fer [mem 0x9d000000-0x9fffffff]
May 16 14:56:26 brian-laptop kernel: [    0.269592] e820: reserve RAM buf=
fer [mem 0x25f600000-0x25fffffff]
May 16 14:56:26 brian-laptop kernel: [    0.269674] NetLabel: Initializin=
g
May 16 14:56:26 brian-laptop kernel: [    0.269676] NetLabel:  domain has=
h size =3D 128
May 16 14:56:26 brian-laptop kernel: [    0.269677] NetLabel:  protocols =
=3D UNLABELED CIPSOv4
May 16 14:56:26 brian-laptop kernel: [    0.269690] NetLabel:  unlabeled =
traffic allowed by default
May 16 14:56:26 brian-laptop kernel: [    0.269748] hpet0: at MMIO 0xfed0=
0000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
May 16 14:56:26 brian-laptop kernel: [    0.269755] hpet0: 8 comparators,=
 64-bit 14.318180 MHz counter
May 16 14:56:26 brian-laptop kernel: [    0.271788] Switched to clocksour=
ce hpet
May 16 14:56:26 brian-laptop kernel: [    0.277286] AppArmor: AppArmor Fi=
lesystem Enabled
May 16 14:56:26 brian-laptop kernel: [    0.277307] pnp: PnP ACPI init
May 16 14:56:26 brian-laptop kernel: [    0.277319] ACPI: bus type PNP re=
gistered
May 16 14:56:26 brian-laptop kernel: [    0.277530] pnp 00:00: [dma 4]
May 16 14:56:26 brian-laptop kernel: [    0.277553] pnp 00:00: Plug and P=
lay ACPI device, IDs PNP0200 (active)
May 16 14:56:26 brian-laptop kernel: [    0.277574] pnp 00:01: Plug and P=
lay ACPI device, IDs INT0800 (active)
May 16 14:56:26 brian-laptop kernel: [    0.277679] pnp 00:02: Plug and P=
lay ACPI device, IDs PNP0103 (active)
May 16 14:56:26 brian-laptop kernel: [    0.277740] system 00:03: [io  0x=
0680-0x069f] has been reserved
May 16 14:56:26 brian-laptop kernel: [    0.277744] system 00:03: [io  0x=
ffff] has been reserved
May 16 14:56:26 brian-laptop kernel: [    0.277746] system 00:03: [io  0x=
ffff] has been reserved
May 16 14:56:26 brian-laptop kernel: [    0.277748] system 00:03: [io  0x=
ffff] has been reserved
May 16 14:56:26 brian-laptop kernel: [    0.277751] system 00:03: [io  0x=
1800-0x18fe] could not be reserved
May 16 14:56:26 brian-laptop kernel: [    0.277753] system 00:03: [io  0x=
164e-0x164f] has been reserved
May 16 14:56:26 brian-laptop kernel: [    0.277756] system 00:03: Plug an=
d Play ACPI device, IDs PNP0c02 (active)
May 16 14:56:26 brian-laptop kernel: [    0.277801] pnp 00:04: Plug and P=
lay ACPI device, IDs PNP0b00 (active)
May 16 14:56:26 brian-laptop kernel: [    0.277848] system 00:05: [io  0x=
1854-0x1857] has been reserved
May 16 14:56:26 brian-laptop kernel: [    0.277852] system 00:05: Plug an=
d Play ACPI device, IDs INT3f0d PNP0c02 (active)
May 16 14:56:26 brian-laptop kernel: [    0.277890] pnp 00:06: Plug and P=
lay ACPI device, IDs PNP0303 (active)
May 16 14:56:26 brian-laptop kernel: [    0.277921] pnp 00:07: Plug and P=
lay ACPI device, IDs SYN2b2c SYN2b00 SYN0002 PNP0f13 (active)
May 16 14:56:26 brian-laptop kernel: [    0.278068] system 00:08: [mem 0x=
fed1c000-0xfed1ffff] has been reserved
May 16 14:56:26 brian-laptop kernel: [    0.278073] system 00:08: [mem 0x=
fed10000-0xfed17fff] has been reserved
May 16 14:56:26 brian-laptop kernel: [    0.278075] system 00:08: [mem 0x=
fed18000-0xfed18fff] has been reserved
May 16 14:56:26 brian-laptop kernel: [    0.278077] system 00:08: [mem 0x=
fed19000-0xfed19fff] has been reserved
May 16 14:56:26 brian-laptop kernel: [    0.278079] system 00:08: [mem 0x=
e0000000-0xefffffff] has been reserved
May 16 14:56:26 brian-laptop kernel: [    0.278081] system 00:08: [mem 0x=
fed20000-0xfed3ffff] has been reserved
May 16 14:56:26 brian-laptop kernel: [    0.278083] system 00:08: [mem 0x=
fed90000-0xfed93fff] has been reserved
May 16 14:56:26 brian-laptop kernel: [    0.278086] system 00:08: [mem 0x=
ff000000-0xffffffff] could not be reserved
May 16 14:56:26 brian-laptop kernel: [    0.278088] system 00:08: [mem 0x=
fee00000-0xfeefffff] could not be reserved
May 16 14:56:26 brian-laptop kernel: [    0.278090] system 00:08: [mem 0x=
9fa20000-0x9fa20fff] has been reserved
May 16 14:56:26 brian-laptop kernel: [    0.278092] system 00:08: [mem 0x=
9fa10000-0x9fa1ffff] has been reserved
May 16 14:56:26 brian-laptop kernel: [    0.278095] system 00:08: Plug an=
d Play ACPI device, IDs PNP0c02 (active)
May 16 14:56:26 brian-laptop kernel: [    0.278415] system 00:09: Plug an=
d Play ACPI device, IDs PNP0c02 (active)
May 16 14:56:26 brian-laptop kernel: [    0.278957] pnp: PnP ACPI: found =
10 devices
May 16 14:56:26 brian-laptop kernel: [    0.278959] ACPI: bus type PNP un=
registered
May 16 14:56:26 brian-laptop kernel: [    0.285175] pci 0000:00:1c.0: PCI=
 bridge to [bus 01]
May 16 14:56:26 brian-laptop kernel: [    0.285181] pci 0000:00:1c.0:   b=
ridge window [mem 0xb0400000-0xb04fffff]
May 16 14:56:26 brian-laptop kernel: [    0.285190] pci_bus 0000:00: reso=
urce 4 [io  0x0000-0x0cf7]
May 16 14:56:26 brian-laptop kernel: [    0.285192] pci_bus 0000:00: reso=
urce 5 [io  0x0d00-0xffff]
May 16 14:56:26 brian-laptop kernel: [    0.285194] pci_bus 0000:00: reso=
urce 6 [mem 0x000a0000-0x000bffff]
May 16 14:56:26 brian-laptop kernel: [    0.285196] pci_bus 0000:00: reso=
urce 7 [mem 0x9fa00000-0xfeafffff]
May 16 14:56:26 brian-laptop kernel: [    0.285199] pci_bus 0000:01: reso=
urce 1 [mem 0xb0400000-0xb04fffff]
May 16 14:56:26 brian-laptop kernel: [    0.285231] NET: Registered proto=
col family 2
May 16 14:56:26 brian-laptop kernel: [    0.285426] TCP established hash =
table entries: 65536 (order: 7, 524288 bytes)
May 16 14:56:26 brian-laptop kernel: [    0.285605] TCP bind hash table e=
ntries: 65536 (order: 8, 1048576 bytes)
May 16 14:56:26 brian-laptop kernel: [    0.285735] TCP: Hash tables conf=
igured (established 65536 bind 65536)
May 16 14:56:26 brian-laptop kernel: [    0.285754] TCP: reno registered
May 16 14:56:26 brian-laptop kernel: [    0.285769] UDP hash table entrie=
s: 4096 (order: 5, 131072 bytes)
May 16 14:56:26 brian-laptop kernel: [    0.285803] UDP-Lite hash table e=
ntries: 4096 (order: 5, 131072 bytes)
May 16 14:56:26 brian-laptop kernel: [    0.285876] NET: Registered proto=
col family 1
May 16 14:56:26 brian-laptop kernel: [    0.285889] pci 0000:00:02.0: Boo=
t video device
May 16 14:56:26 brian-laptop kernel: [    0.299941] PCI: CLS 64 bytes, de=
fault 64
May 16 14:56:26 brian-laptop kernel: [    0.300001] Trying to unpack root=
fs image as initramfs...
May 16 14:56:26 brian-laptop kernel: [    0.678980] Freeing initrd memory=
: 18600K (ffff880035b9c000 - ffff880036dc6000)
May 16 14:56:26 brian-laptop kernel: [    0.678985] PCI-DMA: Using softwa=
re bounce buffering for IO (SWIOTLB)
May 16 14:56:26 brian-laptop kernel: [    0.678988] software IO TLB [mem =
0x982c6000-0x9c2c6000] (64MB) mapped at [ffff8800982c6000-ffff88009c2c5ff=
f]
May 16 14:56:26 brian-laptop kernel: [    0.679027] Simple Boot Flag at 0=
x44 set to 0x1
May 16 14:56:26 brian-laptop kernel: [    0.679187] microcode: CPU0 sig=3D=
0x40651, pf=3D0x40, revision=3D0x14
May 16 14:56:26 brian-laptop kernel: [    0.679193] microcode: CPU1 sig=3D=
0x40651, pf=3D0x40, revision=3D0x14
May 16 14:56:26 brian-laptop kernel: [    0.679201] microcode: CPU2 sig=3D=
0x40651, pf=3D0x40, revision=3D0x14
May 16 14:56:26 brian-laptop kernel: [    0.679209] microcode: CPU3 sig=3D=
0x40651, pf=3D0x40, revision=3D0x14
May 16 14:56:26 brian-laptop kernel: [    0.679255] microcode: Microcode =
Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
May 16 14:56:26 brian-laptop kernel: [    0.679257] Scanning for low memo=
ry corruption every 60 seconds
May 16 14:56:26 brian-laptop kernel: [    0.679531] Initialise system tru=
sted keyring
May 16 14:56:26 brian-laptop kernel: [    0.679582] audit: initializing n=
etlink socket (disabled)
May 16 14:56:26 brian-laptop kernel: [    0.679592] type=3D2000 audit(140=
0252183.668:1): initialized
May 16 14:56:26 brian-laptop kernel: [    0.713748] HugeTLB registered 2 =
MB page size, pre-allocated 0 pages
May 16 14:56:26 brian-laptop kernel: [    0.715130] VFS: Disk quotas dquo=
t_6.5.2
May 16 14:56:26 brian-laptop kernel: [    0.715172] Dquot-cache hash tabl=
e entries: 512 (order 0, 4096 bytes)
May 16 14:56:26 brian-laptop kernel: [    0.715586] fuse init (API versio=
n 7.22)
May 16 14:56:26 brian-laptop kernel: [    0.715659] msgmni has been set t=
o 15789
May 16 14:56:26 brian-laptop kernel: [    0.715711] Key type big_key regi=
stered
May 16 14:56:26 brian-laptop kernel: [    0.716050] Key type asymmetric r=
egistered
May 16 14:56:26 brian-laptop kernel: [    0.716053] Asymmetric key parser=
 'x509' registered
May 16 14:56:26 brian-laptop kernel: [    0.716084] Block layer SCSI gene=
ric (bsg) driver version 0.4 loaded (major 252)
May 16 14:56:26 brian-laptop kernel: [    0.716119] io scheduler noop reg=
istered
May 16 14:56:26 brian-laptop kernel: [    0.716122] io scheduler deadline=
 registered (default)
May 16 14:56:26 brian-laptop kernel: [    0.716154] io scheduler cfq regi=
stered
May 16 14:56:26 brian-laptop kernel: [    0.716376] pcieport 0000:00:1c.0=
: irq 56 for MSI/MSI-X
May 16 14:56:26 brian-laptop kernel: [    0.716460] pcieport 0000:00:1c.0=
: Signaling PME through PCIe PME interrupt
May 16 14:56:26 brian-laptop kernel: [    0.716462] pci 0000:01:00.0: Sig=
naling PME through PCIe PME interrupt
May 16 14:56:26 brian-laptop kernel: [    0.716466] pcie_pme 0000:00:1c.0=
:pcie01: service driver pcie_pme loaded
May 16 14:56:26 brian-laptop kernel: [    0.716478] pci_hotplug: PCI Hot =
Plug PCI Core version: 0.5
May 16 14:56:26 brian-laptop kernel: [    0.716491] pciehp: PCI Express H=
ot Plug Controller Driver version: 0.4
May 16 14:56:26 brian-laptop kernel: [    0.716533] efifb: probing for ef=
ifb
May 16 14:56:26 brian-laptop kernel: [    0.719450] efifb: framebuffer at=
 0xa0000000, mapped to 0xffffc90010f00000, using 22528k, total 22528k
May 16 14:56:26 brian-laptop kernel: [    0.719452] efifb: mode is 3200x1=
800x32, linelength=3D12800, pages=3D1
May 16 14:56:26 brian-laptop kernel: [    0.719453] efifb: scrolling: red=
raw
May 16 14:56:26 brian-laptop kernel: [    0.719455] efifb: Truecolor: siz=
e=3D8:8:8:8, shift=3D24:16:8:0
May 16 14:56:26 brian-laptop kernel: [    0.737061] Console: switching to=
 colour frame buffer device 400x112
May 16 14:56:26 brian-laptop kernel: [    0.754165] fb0: EFI VGA frame bu=
ffer device
May 16 14:56:26 brian-laptop kernel: [    0.754178] intel_idle: MWAIT sub=
states: 0x11142120
May 16 14:56:26 brian-laptop kernel: [    0.754180] intel_idle: v0.4 mode=
l 0x45
May 16 14:56:26 brian-laptop kernel: [    0.754181] intel_idle: lapic_tim=
er_reliable_states 0xffffffff
May 16 14:56:26 brian-laptop kernel: [    0.754328] ipmi message handler =
version 39.2
May 16 14:56:26 brian-laptop kernel: [    0.754408] ACPI: AC Adapter [ADP=
1] (on-line)
May 16 14:56:26 brian-laptop kernel: [    0.754502] input: Lid Switch as =
/devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
May 16 14:56:26 brian-laptop kernel: [    0.754523] ACPI: Lid Switch [LID=
0]
May 16 14:56:26 brian-laptop kernel: [    0.754555] input: Power Button a=
s /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
May 16 14:56:26 brian-laptop kernel: [    0.754559] ACPI: Power Button [P=
WRB]
May 16 14:56:26 brian-laptop kernel: [    0.754590] input: Power Button a=
s /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
May 16 14:56:26 brian-laptop kernel: [    0.754592] ACPI: Power Button [P=
WRF]
May 16 14:56:26 brian-laptop kernel: [    0.756200] thermal LNXTHERM:00: =
registered as thermal_zone0
May 16 14:56:26 brian-laptop kernel: [    0.756203] ACPI: Thermal Zone [T=
Z01] (56 C)
May 16 14:56:26 brian-laptop kernel: [    0.756236] GHES: HEST is not ena=
bled!
May 16 14:56:26 brian-laptop kernel: [    0.756317] Serial: 8250/16550 dr=
iver, 32 ports, IRQ sharing enabled
May 16 14:56:26 brian-laptop kernel: [    0.758940] Linux agpgart interfa=
ce v0.103
May 16 14:56:26 brian-laptop kernel: [    0.760369] brd: module loaded
May 16 14:56:26 brian-laptop kernel: [    0.761178] loop: module loaded
May 16 14:56:26 brian-laptop kernel: [    0.761566] libphy: Fixed MDIO Bu=
s: probed
May 16 14:56:26 brian-laptop kernel: [    0.761662] tun: Universal TUN/TA=
P device driver, 1.6
May 16 14:56:26 brian-laptop kernel: [    0.761664] tun: (C) 1999-2004 Ma=
x Krasnyansky <maxk@qualcomm.com>
May 16 14:56:26 brian-laptop kernel: [    0.761727] PPP generic driver ve=
rsion 2.4.2
May 16 14:56:26 brian-laptop kernel: [    0.761818] ehci_hcd: USB 2.0 'En=
hanced' Host Controller (EHCI) Driver
May 16 14:56:26 brian-laptop kernel: [    0.761822] ehci-pci: EHCI PCI pl=
atform driver
May 16 14:56:26 brian-laptop kernel: [    0.761965] ehci-pci 0000:00:1d.0=
: EHCI Host Controller
May 16 14:56:26 brian-laptop kernel: [    0.761972] ehci-pci 0000:00:1d.0=
: new USB bus registered, assigned bus number 1
May 16 14:56:26 brian-laptop kernel: [    0.761989] ehci-pci 0000:00:1d.0=
: debug port 2
May 16 14:56:26 brian-laptop kernel: [    0.763628] ACPI: Battery Slot [B=
AT1] (battery present)
May 16 14:56:26 brian-laptop kernel: [    0.765891] ehci-pci 0000:00:1d.0=
: cache line size of 64 is not supported
May 16 14:56:26 brian-laptop kernel: [    0.765918] ehci-pci 0000:00:1d.0=
: irq 23, io mem 0xb0524000
May 16 14:56:26 brian-laptop kernel: [    0.776216] ehci-pci 0000:00:1d.0=
: USB 2.0 started, EHCI 1.00
May 16 14:56:26 brian-laptop kernel: [    0.776265] usb usb1: New USB dev=
ice found, idVendor=3D1d6b, idProduct=3D0002
May 16 14:56:26 brian-laptop kernel: [    0.776267] usb usb1: New USB dev=
ice strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
May 16 14:56:26 brian-laptop kernel: [    0.776269] usb usb1: Product: EH=
CI Host Controller
May 16 14:56:26 brian-laptop kernel: [    0.776271] usb usb1: Manufacture=
r: Linux 3.13.0-24-generic ehci_hcd
May 16 14:56:26 brian-laptop kernel: [    0.776273] usb usb1: SerialNumbe=
r: 0000:00:1d.0
May 16 14:56:26 brian-laptop kernel: [    0.776404] hub 1-0:1.0: USB hub =
found
May 16 14:56:26 brian-laptop kernel: [    0.776410] hub 1-0:1.0: 2 ports =
detected
May 16 14:56:26 brian-laptop kernel: [    0.776526] ehci-platform: EHCI g=
eneric platform driver
May 16 14:56:26 brian-laptop kernel: [    0.776534] ohci_hcd: USB 1.1 'Op=
en' Host Controller (OHCI) Driver
May 16 14:56:26 brian-laptop kernel: [    0.776535] ohci-pci: OHCI PCI pl=
atform driver
May 16 14:56:26 brian-laptop kernel: [    0.776544] ohci-platform: OHCI g=
eneric platform driver
May 16 14:56:26 brian-laptop kernel: [    0.776550] uhci_hcd: USB Univers=
al Host Controller Interface driver
May 16 14:56:26 brian-laptop kernel: [    0.776690] xhci_hcd 0000:00:14.0=
: xHCI Host Controller
May 16 14:56:26 brian-laptop kernel: [    0.776695] xhci_hcd 0000:00:14.0=
: new USB bus registered, assigned bus number 2
May 16 14:56:26 brian-laptop kernel: [    0.776775] xhci_hcd 0000:00:14.0=
: cache line size of 64 is not supported
May 16 14:56:26 brian-laptop kernel: [    0.776794] xhci_hcd 0000:00:14.0=
: irq 57 for MSI/MSI-X
May 16 14:56:26 brian-laptop kernel: [    0.776857] usb usb2: New USB dev=
ice found, idVendor=3D1d6b, idProduct=3D0002
May 16 14:56:26 brian-laptop kernel: [    0.776859] usb usb2: New USB dev=
ice strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
May 16 14:56:26 brian-laptop kernel: [    0.776861] usb usb2: Product: xH=
CI Host Controller
May 16 14:56:26 brian-laptop kernel: [    0.776863] usb usb2: Manufacture=
r: Linux 3.13.0-24-generic xhci_hcd
May 16 14:56:26 brian-laptop kernel: [    0.776864] usb usb2: SerialNumbe=
r: 0000:00:14.0
May 16 14:56:26 brian-laptop kernel: [    0.777076] hub 2-0:1.0: USB hub =
found
May 16 14:56:26 brian-laptop kernel: [    0.777089] hub 2-0:1.0: 9 ports =
detected
May 16 14:56:26 brian-laptop kernel: [    0.779389] xhci_hcd 0000:00:14.0=
: xHCI Host Controller
May 16 14:56:26 brian-laptop kernel: [    0.779395] xhci_hcd 0000:00:14.0=
: new USB bus registered, assigned bus number 3
May 16 14:56:26 brian-laptop kernel: [    0.779441] usb usb3: New USB dev=
ice found, idVendor=3D1d6b, idProduct=3D0003
May 16 14:56:26 brian-laptop kernel: [    0.779443] usb usb3: New USB dev=
ice strings: Mfr=3D3, Product=3D2, SerialNumber=3D1
May 16 14:56:26 brian-laptop kernel: [    0.779445] usb usb3: Product: xH=
CI Host Controller
May 16 14:56:26 brian-laptop kernel: [    0.779447] usb usb3: Manufacture=
r: Linux 3.13.0-24-generic xhci_hcd
May 16 14:56:26 brian-laptop kernel: [    0.779449] usb usb3: SerialNumbe=
r: 0000:00:14.0
May 16 14:56:26 brian-laptop kernel: [    0.779597] hub 3-0:1.0: USB hub =
found
May 16 14:56:26 brian-laptop kernel: [    0.779606] hub 3-0:1.0: 4 ports =
detected
May 16 14:56:26 brian-laptop kernel: [    0.788373] i8042: PNP: PS/2 Cont=
roller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
May 16 14:56:26 brian-laptop kernel: [    0.801179] serio: i8042 KBD port=
 at 0x60,0x64 irq 1
May 16 14:56:26 brian-laptop kernel: [    0.801185] serio: i8042 AUX port=
 at 0x60,0x64 irq 12
May 16 14:56:26 brian-laptop kernel: [    0.801480] mousedev: PS/2 mouse =
device common for all mice
May 16 14:56:26 brian-laptop kernel: [    0.801870] rtc_cmos 00:04: RTC c=
an wake from S4
May 16 14:56:26 brian-laptop kernel: [    0.802022] rtc_cmos 00:04: rtc c=
ore: registered rtc_cmos as rtc0
May 16 14:56:26 brian-laptop kernel: [    0.802051] rtc_cmos 00:04: alarm=
s up to one month, 242 bytes nvram, hpet irqs
May 16 14:56:26 brian-laptop kernel: [    0.802129] device-mapper: uevent=
: version 1.0.3
May 16 14:56:26 brian-laptop kernel: [    0.802211] device-mapper: ioctl:=
 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
May 16 14:56:26 brian-laptop kernel: [    0.802220] ledtrig-cpu: register=
ed to indicate activity on CPUs
May 16 14:56:26 brian-laptop kernel: [    0.802222] EFI Variables Facilit=
y v0.08 2004-May-17
May 16 14:56:26 brian-laptop kernel: [    0.812753] input: AT Translated =
Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
May 16 14:56:26 brian-laptop kernel: [    0.844711] TCP: cubic registered=

May 16 14:56:26 brian-laptop kernel: [    0.844804] NET: Registered proto=
col family 10
May 16 14:56:26 brian-laptop kernel: [    0.844974] NET: Registered proto=
col family 17
May 16 14:56:26 brian-laptop kernel: [    0.844987] Key type dns_resolver=
 registered
May 16 14:56:26 brian-laptop kernel: [    0.845284] Loading compiled-in X=
=2E509 certificates
May 16 14:56:26 brian-laptop kernel: [    0.846332] Loaded X.509 cert 'Ma=
grathea: Glacier signing key: 69b0d0a79b85d90621706e8d06604d730b359fc0'
May 16 14:56:26 brian-laptop kernel: [    0.846344] registered taskstats =
version 1
May 16 14:56:26 brian-laptop kernel: [    0.849064] Key type trusted regi=
stered
May 16 14:56:26 brian-laptop kernel: [    0.851269] Key type encrypted re=
gistered
May 16 14:56:26 brian-laptop kernel: [    0.853477] AppArmor: AppArmor sh=
a1 policy hashing enabled
May 16 14:56:26 brian-laptop kernel: [    0.853481] IMA: No TPM chip foun=
d, activating TPM-bypass!
May 16 14:56:26 brian-laptop kernel: [    0.853743] regulator-dummy: disa=
bling
May 16 14:56:26 brian-laptop kernel: [    0.853820]   Magic number: 14:57=
0:940
May 16 14:56:26 brian-laptop kernel: [    0.853924] rtc_cmos 00:04: setti=
ng system clock to 2014-05-16 14:56:25 UTC (1400252185)
May 16 14:56:26 brian-laptop kernel: [    0.854835] BIOS EDD facility v0.=
16 2004-Jun-25, 0 devices found
May 16 14:56:26 brian-laptop kernel: [    0.854837] EDD information not a=
vailable.
May 16 14:56:26 brian-laptop kernel: [    0.854877] PM: Hibernation image=
 not present or could not be loaded.
May 16 14:56:26 brian-laptop kernel: [    0.855659] Freeing unused kernel=
 memory: 1332K (ffffffff81d1e000 - ffffffff81e6b000)
May 16 14:56:26 brian-laptop kernel: [    0.855660] Write protecting the =
kernel read-only data: 12288k
May 16 14:56:26 brian-laptop kernel: [    0.857251] Freeing unused kernel=
 memory: 844K (ffff88000272d000 - ffff880002800000)
May 16 14:56:26 brian-laptop kernel: [    0.858444] Freeing unused kernel=
 memory: 708K (ffff880002b4f000 - ffff880002c00000)
May 16 14:56:26 brian-laptop kernel: [    0.891267] ahci 0000:00:1f.2: ve=
rsion 3.0
May 16 14:56:26 brian-laptop kernel: [    0.891378] ahci 0000:00:1f.2: ir=
q 58 for MSI/MSI-X
May 16 14:56:26 brian-laptop kernel: [    0.904321] ahci 0000:00:1f.2: AH=
CI 0001.0300 32 slots 1 ports 6 Gbps 0x2 impl SATA mode
May 16 14:56:26 brian-laptop kernel: [    0.904326] ahci 0000:00:1f.2: fl=
ags: 64bit ncq pm led clo only pio slum part deso sadm sds apst=20
May 16 14:56:26 brian-laptop kernel: [    0.904681] scsi0 : ahci
May 16 14:56:26 brian-laptop kernel: [    0.904813] scsi1 : ahci
May 16 14:56:26 brian-laptop kernel: [    0.904841] ata1: DUMMY
May 16 14:56:26 brian-laptop kernel: [    0.904843] ata2: SATA max UDMA/1=
33 abar m2048@0xb0523000 port 0xb0523180 irq 58
May 16 14:56:26 brian-laptop kernel: [    1.088547] usb 1-1: new high-spe=
ed USB device number 2 using ehci-pci
May 16 14:56:26 brian-laptop kernel: [    1.221010] usb 1-1: New USB devi=
ce found, idVendor=3D8087, idProduct=3D8000
May 16 14:56:26 brian-laptop kernel: [    1.221015] usb 1-1: New USB devi=
ce strings: Mfr=3D0, Product=3D0, SerialNumber=3D0
May 16 14:56:26 brian-laptop kernel: [    1.221266] hub 1-1:1.0: USB hub =
found
May 16 14:56:26 brian-laptop kernel: [    1.221339] hub 1-1:1.0: 8 ports =
detected
May 16 14:56:26 brian-laptop kernel: [    1.224614] ata2: SATA link up 6.=
0 Gbps (SStatus 133 SControl 300)
May 16 14:56:26 brian-laptop kernel: [    1.225659] ata2.00: ACPI cmd ef/=
10:09:00:00:00:b0 (SET FEATURES) succeeded
May 16 14:56:26 brian-laptop kernel: [    1.225957] ata2.00: failed to ge=
t NCQ Send/Recv Log Emask 0x1
May 16 14:56:26 brian-laptop kernel: [    1.225959] ata2.00: ATA-9: SAMSU=
NG MZMTD256HAGM-000L1, DXT43L0Q, max UDMA/133
May 16 14:56:26 brian-laptop kernel: [    1.225961] ata2.00: 500118192 se=
ctors, multi 16: LBA48 NCQ (depth 31/32), AA
May 16 14:56:26 brian-laptop kernel: [    1.226274] ata2.00: ACPI cmd ef/=
10:09:00:00:00:b0 (SET FEATURES) succeeded
May 16 14:56:26 brian-laptop kernel: [    1.226447] ata2.00: failed to ge=
t NCQ Send/Recv Log Emask 0x1
May 16 14:56:26 brian-laptop kernel: [    1.226504] ata2.00: configured f=
or UDMA/133
May 16 14:56:26 brian-laptop kernel: [    1.226677] scsi 1:0:0:0: Direct-=
Access     ATA      SAMSUNG MZMTD256 DXT4 PQ: 0 ANSI: 5
May 16 14:56:26 brian-laptop kernel: [    1.226826] sd 1:0:0:0: [sda] 500=
118192 512-byte logical blocks: (256 GB/238 GiB)
May 16 14:56:26 brian-laptop kernel: [    1.226848] sd 1:0:0:0: Attached =
scsi generic sg0 type 0
May 16 14:56:26 brian-laptop kernel: [    1.226929] sd 1:0:0:0: [sda] Wri=
te Protect is off
May 16 14:56:26 brian-laptop kernel: [    1.226932] sd 1:0:0:0: [sda] Mod=
e Sense: 00 3a 00 00
May 16 14:56:26 brian-laptop kernel: [    1.226982] sd 1:0:0:0: [sda] Wri=
te cache: enabled, read cache: enabled, doesn't support DPO or FUA
May 16 14:56:26 brian-laptop kernel: [    1.228555]  sda: sda1 sda2 sda3 =
sda4 sda5 sda6 sda7 sda8 sda9
May 16 14:56:26 brian-laptop kernel: [    1.229375] sd 1:0:0:0: [sda] Att=
ached SCSI disk
May 16 14:56:26 brian-laptop kernel: [    1.264020] EXT4-fs (sda9): INFO:=
 recovery required on readonly filesystem
May 16 14:56:26 brian-laptop kernel: [    1.264024] EXT4-fs (sda9): write=
 access will be enabled during recovery
May 16 14:56:26 brian-laptop kernel: [    1.351661] EXT4-fs (sda9): recov=
ery complete
May 16 14:56:26 brian-laptop kernel: [    1.355913] EXT4-fs (sda9): mount=
ed filesystem with ordered data mode. Opts: (null)
May 16 14:56:26 brian-laptop kernel: [    1.388735] usb 2-4: new full-spe=
ed USB device number 2 using xhci_hcd
May 16 14:56:26 brian-laptop kernel: [    1.405722] usb 2-4: New USB devi=
ce found, idVendor=3D8087, idProduct=3D07dc
May 16 14:56:26 brian-laptop kernel: [    1.405726] usb 2-4: New USB devi=
ce strings: Mfr=3D0, Product=3D0, SerialNumber=3D0
May 16 14:56:26 brian-laptop kernel: [    1.418780] random: init urandom =
read with 94 bits of entropy available
May 16 14:56:26 brian-laptop kernel: [    1.539528] random: nonblocking p=
ool is initialized
May 16 14:56:26 brian-laptop kernel: [    1.572874] usb 2-6: new full-spe=
ed USB device number 3 using xhci_hcd
May 16 14:56:26 brian-laptop kernel: [    1.589001] Adding 7812092k swap =
on /dev/sda8.  Priority:-1 extents:1 across:7812092k SSFS
May 16 14:56:26 brian-laptop kernel: [    1.592553] usb 2-6: New USB devi=
ce found, idVendor=3D2047, idProduct=3D0855
May 16 14:56:26 brian-laptop kernel: [    1.592557] usb 2-6: New USB devi=
ce strings: Mfr=3D1, Product=3D2, SerialNumber=3D3
May 16 14:56:26 brian-laptop kernel: [    1.592560] usb 2-6: Product: Len=
ovo Yoga        =20
May 16 14:56:26 brian-laptop kernel: [    1.592562] usb 2-6: Manufacturer=
: Invensense
May 16 14:56:26 brian-laptop kernel: [    1.592563] usb 2-6: SerialNumber=
: 71F8806F10000000
May 16 14:56:26 brian-laptop kernel: [    1.592641] usb 2-6: ep 0x81 - ro=
unding interval to 128 microframes, ep desc says 160 microframes
May 16 14:56:26 brian-laptop kernel: [    1.592646] usb 2-6: ep 0x1 - rou=
nding interval to 128 microframes, ep desc says 160 microframes
May 16 14:56:26 brian-laptop kernel: [    1.676568] lp: driver loaded but=
 no devices found
May 16 14:56:26 brian-laptop kernel: [    1.676936] tsc: Refined TSC cloc=
ksource calibration: 2394.457 MHz
May 16 14:56:26 brian-laptop kernel: [    1.681771] ppdev: user-space par=
allel port driver
May 16 14:56:26 brian-laptop kernel: [    1.710155] EXT4-fs (sda9): re-mo=
unted. Opts: errors=3Dremount-ro
May 16 14:56:26 brian-laptop kernel: [    1.722590] mei_me 0000:00:16.0: =
irq 59 for MSI/MSI-X
May 16 14:56:26 brian-laptop kernel: [    1.723157] [drm] Initialized drm=
 1.1.0 20060810
May 16 14:56:26 brian-laptop kernel: [    1.761629] usb 2-7: new full-spe=
ed USB device number 4 using xhci_hcd
May 16 14:56:26 brian-laptop kernel: [    1.782186] [drm] Memory usable b=
y graphics device =3D 2048M
May 16 14:56:26 brian-laptop kernel: [    1.782191] checking generic (a00=
00000 1600000) vs hw (a0000000 10000000)
May 16 14:56:26 brian-laptop kernel: [    1.782193] fb: conflicting fb hw=
 usage inteldrmfb vs EFI VGA - removing generic driver
May 16 14:56:26 brian-laptop kernel: [    1.783223] Console: switching to=
 colour dummy device 80x25
May 16 14:56:26 brian-laptop kernel: [    1.814662] cfg80211: Calling CRD=
A to update world regulatory domain
May 16 14:56:26 brian-laptop kernel: [    1.823417] Intel(R) Wireless WiF=
i driver for Linux, in-tree:
May 16 14:56:26 brian-laptop kernel: [    1.823420] Copyright(c) 2003-201=
3 Intel Corporation
May 16 14:56:26 brian-laptop kernel: [    1.823560] iwlwifi 0000:01:00.0:=
 irq 60 for MSI/MSI-X
May 16 14:56:26 brian-laptop kernel: [    1.831662] iwlwifi 0000:01:00.0:=
 loaded firmware version 22.24.8.0 op_mode iwlmvm
May 16 14:56:26 brian-laptop kernel: [    1.837566] i915 0000:00:02.0: ir=
q 61 for MSI/MSI-X
May 16 14:56:26 brian-laptop kernel: [    1.837608] [drm] Supports vblank=
 timestamp caching Rev 2 (21.10.2013).
May 16 14:56:26 brian-laptop kernel: [    1.837610] [drm] Driver supports=
 precise vblank timestamp query.
May 16 14:56:26 brian-laptop kernel: [    1.838575] vgaarb: device change=
d decodes: PCI:0000:00:02.0,olddecodes=3Dio+mem,decodes=3Dio+mem:owns=3Di=
o+mem
May 16 14:56:26 brian-laptop kernel: [    1.861825] iwlwifi 0000:01:00.0:=
 Detected Intel(R) Wireless N 7260, REV=3D0x144
May 16 14:56:26 brian-laptop kernel: [    1.861886] iwlwifi 0000:01:00.0:=
 L1 Disabled; Enabling L0S
May 16 14:56:26 brian-laptop kernel: [    1.862108] iwlwifi 0000:01:00.0:=
 L1 Disabled; Enabling L0S
May 16 14:56:26 brian-laptop kernel: [    1.928993] kvm: disabled by bios=

May 16 14:56:26 brian-laptop kernel: [    1.935676] fbcon: inteldrmfb (fb=
0) is primary device
May 16 14:56:26 brian-laptop kernel: [    1.961583] Bluetooth: Core ver 2=
=2E17
May 16 14:56:26 brian-laptop kernel: [    1.961600] NET: Registered proto=
col family 31
May 16 14:56:26 brian-laptop kernel: [    1.961601] Bluetooth: HCI device=
 and connection manager initialized
May 16 14:56:26 brian-laptop kernel: [    1.961607] Bluetooth: HCI socket=
 layer initialized
May 16 14:56:26 brian-laptop kernel: [    1.961608] Bluetooth: L2CAP sock=
et layer initialized
May 16 14:56:26 brian-laptop kernel: [    1.961612] Bluetooth: SCO socket=
 layer initialized
May 16 14:56:26 brian-laptop kernel: [    1.966805] Bluetooth: BNEP (Ethe=
rnet Emulation) ver 1.3
May 16 14:56:26 brian-laptop kernel: [    1.966806] Bluetooth: BNEP filte=
rs: protocol multicast
May 16 14:56:26 brian-laptop kernel: [    1.966812] Bluetooth: BNEP socke=
t layer initialized
May 16 14:56:26 brian-laptop kernel: [    1.968331] Bluetooth: RFCOMM TTY=
 layer initialized
May 16 14:56:26 brian-laptop kernel: [    1.968338] Bluetooth: RFCOMM soc=
ket layer initialized
May 16 14:56:26 brian-laptop kernel: [    1.968342] Bluetooth: RFCOMM ver=
 1.11
May 16 14:56:26 brian-laptop rsyslogd-2039: Could no open output pipe '/d=
ev/xconsole': No such file or directory [try http://www.rsyslog.com/e/203=
9 ]
May 16 14:56:28 brian-laptop kernel: [    2.081617] ieee80211 phy0: Selec=
ted rate control algorithm 'iwl-mvm-rs'
May 16 14:56:28 brian-laptop kernel: [    2.087308] intel_rapl: domain un=
core energy ctr 11076:11076 not working, skip
May 16 14:56:28 brian-laptop kernel: [    2.118320] cfg80211: World regul=
atory domain updated:
May 16 14:56:28 brian-laptop kernel: [    2.118320] cfg80211:   (start_fr=
eq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
May 16 14:56:28 brian-laptop kernel: [    2.118322] cfg80211:   (2402000 =
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 14:56:28 brian-laptop kernel: [    2.118323] cfg80211:   (2457000 =
KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 14:56:28 brian-laptop kernel: [    2.118324] cfg80211:   (2474000 =
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
May 16 14:56:28 brian-laptop kernel: [    2.118324] cfg80211:   (5170000 =
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 14:56:28 brian-laptop kernel: [    2.118325] cfg80211:   (5735000 =
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 14:56:28 brian-laptop kernel: [    2.454099] psmouse serio1: synap=
tics: Touchpad model: 1, fw: 8.1, id: 0x1e2b1, caps: 0xd00123/0x840300/0x=
126c00, board id: 2132, fw id: 1180104
May 16 14:56:28 brian-laptop kernel: [    2.508467] input: SynPS/2 Synapt=
ics TouchPad as /devices/platform/i8042/serio1/input/input5
May 16 14:56:28 brian-laptop kernel: [    2.677804] Switched to clocksour=
ce tsc
May 16 14:56:28 brian-laptop kernel: [    3.534468] Console: switching to=
 colour frame buffer device 400x112
May 16 14:56:28 brian-laptop kernel: [    3.547666] i915 0000:00:02.0: fb=
0: inteldrmfb frame buffer device
May 16 14:56:28 brian-laptop kernel: [    3.547667] i915 0000:00:02.0: re=
gistered panic notifier
May 16 14:56:28 brian-laptop kernel: [    3.556179] type=3D1400 audit(140=
0273788.194:2): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"/usr/lib/cups/backend/cups-pdf" pid=3D607 comm=3D"ap=
parmor_parser"
May 16 14:56:28 brian-laptop kernel: [    3.556182] type=3D1400 audit(140=
0273788.194:3): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"/usr/sbin/cupsd" pid=3D607 comm=3D"apparmor_parser"
May 16 14:56:28 brian-laptop kernel: [    3.556479] type=3D1400 audit(140=
0273788.194:4): apparmor=3D"STATUS" operation=3D"profile_replace" profile=
=3D"unconfined" name=3D"/usr/sbin/cupsd" pid=3D607 comm=3D"apparmor_parse=
r"
May 16 14:56:28 brian-laptop kernel: [    3.576349] ACPI: Video Device [G=
FX0] (multi-head: yes  rom: no  post: no)
May 16 14:56:28 brian-laptop kernel: [    3.576661] input: Video Bus as /=
devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input6
May 16 14:56:28 brian-laptop kernel: [    3.577268] [drm] Initialized i91=
5 1.6.0 20080730 for 0000:00:02.0 on minor 0
May 16 14:56:28 brian-laptop kernel: [    3.577390] ACPI Warning: 0x00000=
00000001828-0x000000000000182f SystemIO conflicts with Region \PMIO 1 (20=
131115/utaddress-251)
May 16 14:56:28 brian-laptop kernel: [    3.577392] ACPI: If an ACPI driv=
er is available for this device, you should use it instead of the native =
driver
May 16 14:56:28 brian-laptop kernel: [    3.577396] ACPI Warning: 0x00000=
00000000830-0x000000000000083f SystemIO conflicts with Region \GPRL 1 (20=
131115/utaddress-251)
May 16 14:56:28 brian-laptop kernel: [    3.577399] ACPI Warning: 0x00000=
00000000830-0x000000000000083f SystemIO conflicts with Region \GPR_ 2 (20=
131115/utaddress-251)
May 16 14:56:28 brian-laptop kernel: [    3.577399] ACPI: If an ACPI driv=
er is available for this device, you should use it instead of the native =
driver
May 16 14:56:28 brian-laptop kernel: [    3.577402] ACPI Warning: 0x00000=
00000000800-0x000000000000082f SystemIO conflicts with Region \GPRL 1 (20=
131115/utaddress-251)
May 16 14:56:28 brian-laptop kernel: [    3.577404] ACPI Warning: 0x00000=
00000000800-0x000000000000082f SystemIO conflicts with Region \GPR_ 2 (20=
131115/utaddress-251)
May 16 14:56:28 brian-laptop kernel: [    3.577407] ACPI Warning: 0x00000=
00000000800-0x000000000000082f SystemIO conflicts with Region \IO_D 3 (20=
131115/utaddress-251)
May 16 14:56:28 brian-laptop kernel: [    3.577407] ACPI: If an ACPI driv=
er is available for this device, you should use it instead of the native =
driver
May 16 14:56:28 brian-laptop kernel: [    3.577408] lpc_ich: Resource con=
flict(s) found affecting gpio_ich
May 16 14:56:28 brian-laptop kernel: [    3.577696] HDA driver get symbol=
 successfully from i915 module
May 16 14:56:28 brian-laptop kernel: [    3.577842] snd_hda_intel 0000:00=
:1b.0: irq 62 for MSI/MSI-X
May 16 14:56:28 brian-laptop kernel: [    3.582491] snd_hda_intel 0000:00=
:03.0: irq 63 for MSI/MSI-X
May 16 14:56:28 brian-laptop kernel: [    3.587063] SKU: Nid=3D0x1d sku_c=
fg=3D0x40189e2d
May 16 14:56:28 brian-laptop kernel: [    3.587063] SKU: port_connectivit=
y=3D0x1
May 16 14:56:28 brian-laptop kernel: [    3.587064] SKU: enable_pcbeep=3D=
0x1
May 16 14:56:28 brian-laptop kernel: [    3.587064] SKU: check_sum=3D0x00=
000008
May 16 14:56:28 brian-laptop kernel: [    3.587065] SKU: customization=3D=
0x0000009e
May 16 14:56:28 brian-laptop kernel: [    3.587065] SKU: external_amp=3D0=
x5
May 16 14:56:28 brian-laptop kernel: [    3.587066] SKU: platform_type=3D=
0x1
May 16 14:56:28 brian-laptop kernel: [    3.587066] SKU: swap=3D0x0
May 16 14:56:28 brian-laptop kernel: [    3.587066] SKU: override=3D0x1
May 16 14:56:28 brian-laptop kernel: [    3.587289] autoconfig: line_outs=
=3D1 (0x14/0x0/0x0/0x0/0x0) type:speaker
May 16 14:56:28 brian-laptop kernel: [    3.587289]    speaker_outs=3D0 (=
0x0/0x0/0x0/0x0/0x0)
May 16 14:56:28 brian-laptop kernel: [    3.587290]    hp_outs=3D1 (0x21/=
0x0/0x0/0x0/0x0)
May 16 14:56:28 brian-laptop kernel: [    3.587290]    mono: mono_out=3D0=
x0
May 16 14:56:28 brian-laptop kernel: [    3.587290]    inputs:
May 16 14:56:28 brian-laptop kernel: [    3.587291]      Mic=3D0x19
May 16 14:56:28 brian-laptop kernel: [    3.587292]      Internal Mic=3D0=
x12
May 16 14:56:28 brian-laptop kernel: [    3.587293] realtek: No valid SSI=
D, checking pincfg 0x40189e2d for NID 0x1d
May 16 14:56:28 brian-laptop kernel: [    3.587293] realtek: Enabling ini=
t ASM_ID=3D0x9e2d CODEC_ID=3D10ec0283
May 16 14:56:28 brian-laptop kernel: [    3.592093] input: HDA Intel PCH =
Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card1/input8
May 16 14:56:28 brian-laptop kernel: [    3.592167] input: HDA Intel PCH =
Mic as /devices/pci0000:00/0000:00:1b.0/sound/card1/input7
May 16 14:56:28 brian-laptop kernel: [    3.595055] input: HDA Intel HDMI=
 HDMI/DP,pcm=3D8 as /devices/pci0000:00/0000:00:03.0/sound/card0/input11
May 16 14:56:28 brian-laptop kernel: [    3.595332] input: HDA Intel HDMI=
 HDMI/DP,pcm=3D7 as /devices/pci0000:00/0000:00:03.0/sound/card0/input10
May 16 14:56:28 brian-laptop kernel: [    3.595400] input: HDA Intel HDMI=
 HDMI/DP,pcm=3D3 as /devices/pci0000:00/0000:00:03.0/sound/card0/input9
May 16 14:56:28 brian-laptop avahi-daemon[627]: Found user 'avahi' (UID 1=
10) and group 'avahi' (GID 116).
May 16 14:56:28 brian-laptop avahi-daemon[627]: Successfully dropped root=
 privileges.
May 16 14:56:28 brian-laptop avahi-daemon[627]: avahi-daemon 0.6.31 start=
ing up.
May 16 14:56:28 brian-laptop avahi-daemon[627]: Successfully called chroo=
t().
May 16 14:56:28 brian-laptop avahi-daemon[627]: Successfully dropped rema=
ining capabilities.
May 16 14:56:28 brian-laptop avahi-daemon[627]: Loading service file /ser=
vices/udisks.service.
May 16 14:56:28 brian-laptop avahi-daemon[627]: Network interface enumera=
tion completed.
May 16 14:56:28 brian-laptop avahi-daemon[627]: Registering HINFO record =
with values 'X86_64'/'LINUX'.
May 16 14:56:28 brian-laptop avahi-daemon[627]: Server startup complete. =
Host name is brian-laptop.local. Local service cookie is 2074158465.
May 16 14:56:28 brian-laptop avahi-daemon[627]: Service "brian-laptop" (/=
services/udisks.service) successfully established.
May 16 14:56:28 brian-laptop kernel: [    3.639764] type=3D1400 audit(140=
0273788.278:5): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"/sbin/dhclient" pid=3D639 comm=3D"apparmor_parser"
May 16 14:56:28 brian-laptop kernel: [    3.639769] type=3D1400 audit(140=
0273788.278:6): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"/usr/lib/NetworkManager/nm-dhcp-client.action" pid=3D=
639 comm=3D"apparmor_parser"
May 16 14:56:28 brian-laptop kernel: [    3.639772] type=3D1400 audit(140=
0273788.278:7): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"/usr/lib/connman/scripts/dhclient-script" pid=3D639 =
comm=3D"apparmor_parser"
May 16 14:56:28 brian-laptop kernel: [    3.640089] type=3D1400 audit(140=
0273788.278:8): apparmor=3D"STATUS" operation=3D"profile_replace" profile=
=3D"unconfined" name=3D"/usr/lib/NetworkManager/nm-dhcp-client.action" pi=
d=3D639 comm=3D"apparmor_parser"
May 16 14:56:28 brian-laptop kernel: [    3.640093] type=3D1400 audit(140=
0273788.278:9): apparmor=3D"STATUS" operation=3D"profile_replace" profile=
=3D"unconfined" name=3D"/usr/lib/connman/scripts/dhclient-script" pid=3D6=
39 comm=3D"apparmor_parser"
May 16 14:56:28 brian-laptop kernel: [    3.640266] type=3D1400 audit(140=
0273788.278:10): apparmor=3D"STATUS" operation=3D"profile_replace" profil=
e=3D"unconfined" name=3D"/usr/lib/connman/scripts/dhclient-script" pid=3D=
639 comm=3D"apparmor_parser"
May 16 14:56:28 brian-laptop failsafe: Failsafe of 120 seconds reached.
May 16 14:56:28 brian-laptop wpa_supplicant[721]: Successfully initialize=
d wpa_supplicant
May 16 14:56:28 brian-laptop kernel: [    3.726915] iwlwifi 0000:01:00.0:=
 L1 Disabled; Enabling L0S
May 16 14:56:28 brian-laptop kernel: [    3.727133] iwlwifi 0000:01:00.0:=
 L1 Disabled; Enabling L0S
May 16 14:56:28 brian-laptop kernel: [    3.738105] IPv6: ADDRCONF(NETDEV=
_UP): wlan0: link is not ready
May 16 14:56:28 brian-laptop kernel: [    3.826783] [drm] Enabling RC6 st=
ates: RC6 on, RC6p off, RC6pp off
May 16 14:56:28 brian-laptop kernel: [    3.836148] usb 2-7: unable to re=
ad config index 0 descriptor/start: -71
May 16 14:56:28 brian-laptop kernel: [    3.836192] usb 2-7: can't read c=
onfigurations, error -71
May 16 14:56:28 brian-laptop kernel: [    4.002839] usb 2-7: new full-spe=
ed USB device number 5 using xhci_hcd
May 16 14:56:29 brian-laptop wpa_supplicant[741]: wlan0: CTRL-EVENT-SCAN-=
STARTED=20
May 16 14:56:29 brian-laptop dhclient: Internet Systems Consortium DHCP C=
lient 4.2.4
May 16 14:56:29 brian-laptop dhclient: Copyright 2004-2012 Internet Syste=
ms Consortium.
May 16 14:56:29 brian-laptop dhclient: All rights reserved.
May 16 14:56:29 brian-laptop dhclient: For info, please visit https://www=
=2Eisc.org/software/dhcp/
May 16 14:56:29 brian-laptop dhclient:=20
May 16 14:56:29 brian-laptop dhclient: Listening on LPF/wlan0/5c:51:4f:63=
:1e:10
May 16 14:56:29 brian-laptop dhclient: Sending on   LPF/wlan0/5c:51:4f:63=
:1e:10
May 16 14:56:29 brian-laptop dhclient: Sending on   Socket/fallback
May 16 14:56:29 brian-laptop dhclient: DHCPREQUEST of 192.168.3.107 on wl=
an0 to 255.255.255.255 port 67 (xid=3D0x3b98022b)
May 16 14:56:30 brian-laptop wpa_supplicant[741]: wlan0: SME: Trying to a=
uthenticate with 00:22:6b:54:68:d2 (SSID=3D'BJONES' freq=3D2437 MHz)
May 16 14:56:30 brian-laptop kernel: [    5.503685] wlan0: authenticate w=
ith 00:22:6b:54:68:d2
May 16 14:56:30 brian-laptop wpa_supplicant[741]: wlan0: Trying to associ=
ate with 00:22:6b:54:68:d2 (SSID=3D'BJONES' freq=3D2437 MHz)
May 16 14:56:30 brian-laptop kernel: [    5.505696] wlan0: send auth to 0=
0:22:6b:54:68:d2 (try 1/3)
May 16 14:56:30 brian-laptop kernel: [    5.507623] wlan0: authenticated
May 16 14:56:30 brian-laptop kernel: [    5.508039] wlan0: associate with=
 00:22:6b:54:68:d2 (try 1/3)
May 16 14:56:30 brian-laptop kernel: [    5.512021] wlan0: RX AssocResp f=
rom 00:22:6b:54:68:d2 (capab=3D0x411 status=3D0 aid=3D4)
May 16 14:56:30 brian-laptop wpa_supplicant[741]: wlan0: Associated with =
00:22:6b:54:68:d2
May 16 14:56:30 brian-laptop kernel: [    5.513353] wlan0: associated
May 16 14:56:30 brian-laptop kernel: [    5.513385] IPv6: ADDRCONF(NETDEV=
_CHANGE): wlan0: link becomes ready
May 16 14:56:30 brian-laptop wpa_supplicant[741]: wlan0: WPA: Key negotia=
tion completed with 00:22:6b:54:68:d2 [PTK=3DCCMP GTK=3DTKIP]
May 16 14:56:30 brian-laptop wpa_supplicant[741]: wlan0: CTRL-EVENT-CONNE=
CTED - Connection to 00:22:6b:54:68:d2 completed [id=3D0 id_str=3D]
May 16 14:56:30 brian-laptop kernel: [    6.077070] usb 2-7: unable to re=
ad config index 0 descriptor/start: -71
May 16 14:56:30 brian-laptop kernel: [    6.077075] usb 2-7: can't read c=
onfigurations, error -71
May 16 14:56:30 brian-laptop kernel: [    6.188678] usb 2-7: new full-spe=
ed USB device number 6 using xhci_hcd
May 16 14:56:31 brian-laptop avahi-daemon[627]: Joining mDNS multicast gr=
oup on interface wlan0.IPv6 with address fe80::5e51:4fff:fe63:1e10.
May 16 14:56:31 brian-laptop avahi-daemon[627]: New relevant interface wl=
an0.IPv6 for mDNS.
May 16 14:56:31 brian-laptop avahi-daemon[627]: Registering new address r=
ecord for fe80::5e51:4fff:fe63:1e10 on wlan0.*.
May 16 14:56:32 brian-laptop dhclient: DHCPREQUEST of 192.168.3.107 on wl=
an0 to 255.255.255.255 port 67 (xid=3D0x3b98022b)
May 16 14:56:32 brian-laptop dhclient: DHCPACK of 192.168.3.107 from 192.=
168.3.1
May 16 14:56:32 brian-laptop avahi-daemon[627]: Joining mDNS multicast gr=
oup on interface wlan0.IPv4 with address 192.168.3.107.
May 16 14:56:32 brian-laptop avahi-daemon[627]: New relevant interface wl=
an0.IPv4 for mDNS.
May 16 14:56:32 brian-laptop avahi-daemon[627]: Registering new address r=
ecord for 192.168.3.107 on wlan0.IPv4.
May 16 14:56:32 brian-laptop dhclient: bound to 192.168.3.107 -- renewal =
in 38064 seconds.
May 16 14:56:32 brian-laptop ModemManager[932]: <info>  ModemManager (ver=
sion 1.0.0) starting...
May 16 14:56:32 brian-laptop NetworkManager[960]: <info> NetworkManager (=
version 0.9.8.8) is starting...
May 16 14:56:32 brian-laptop NetworkManager[960]: <info> Read config file=
 /etc/NetworkManager/NetworkManager.conf
May 16 14:56:32 brian-laptop NetworkManager[960]: <info> WEXT support is =
enabled
May 16 14:56:32 brian-laptop NetworkManager[960]: <info> VPN: loaded org.=
freedesktop.NetworkManager.pptp
May 16 14:56:32 brian-laptop NetworkManager[960]: <info> DNS: loaded plug=
in dnsmasq
May 16 14:56:32 brian-laptop dbus[494]: [system] Activating service name=3D=
'org.freedesktop.PolicyKit1' (using servicehelper)
May 16 14:56:32 brian-laptop polkitd[969]: started daemon version 0.105 u=
sing authority implementation `local' version `0.105'
May 16 14:56:32 brian-laptop dbus[494]: [system] Successfully activated s=
ervice 'org.freedesktop.PolicyKit1'
May 16 14:56:32 brian-laptop NetworkManager[960]:    SCPlugin-Ifupdown: i=
nit!
May 16 14:56:32 brian-laptop NetworkManager[960]:    SCPlugin-Ifupdown: u=
pdate_system_hostname
May 16 14:56:32 brian-laptop NetworkManager[960]:       interface-parser:=
 parsing file /etc/network/interfaces
May 16 14:56:32 brian-laptop NetworkManager[960]:       interface-parser:=
 finished parsing file /etc/network/interfaces
May 16 14:56:32 brian-laptop NetworkManager[960]:    SCPluginIfupdown: gu=
essed connection type (wlan0) =3D 802-11-wireless
May 16 14:56:32 brian-laptop NetworkManager[960]:    SCPlugin-Ifupdown: u=
pdate_connection_setting_from_if_block: name:wlan0, type:802-11-wireless,=
 id:Ifupdown (wlan0), uuid: 5391eba4-6426-faca-338e-5828034ff9d1
May 16 14:56:32 brian-laptop NetworkManager[960]:    SCPlugin-Ifupdown: u=
pdate wireless settings (wlan0).
May 16 14:56:32 brian-laptop NetworkManager[960]:    SCPlugin-Ifupdown: s=
etting wpa ssid =3D 6
May 16 14:56:32 brian-laptop NetworkManager[960]:    SCPlugin-Ifupdown: u=
pdate wireless security settings (wlan0).
May 16 14:56:32 brian-laptop NetworkManager[960]:    SCPlugin-Ifupdown: s=
etting wpa security key: psk=3D<omitted>
May 16 14:56:32 brian-laptop NetworkManager[960]: nm-ifupdown-connection.=
c.100 - invalid connection read from /etc/network/interfaces: (2) key-mgm=
t
May 16 14:56:32 brian-laptop NetworkManager[960]:    SCPlugin-Ifupdown: a=
dding iface wlan0 to eni_ifaces
May 16 14:56:32 brian-laptop NetworkManager[960]:    SCPluginIfupdown: ma=
nagement mode: unmanaged
May 16 14:56:32 brian-laptop NetworkManager[960]:    SCPlugin-Ifupdown: d=
evices added (path: /sys/devices/pci0000:00/0000:00:1c.0/0000:01:00.0/net=
/wlan0, iface: wlan0)
May 16 14:56:32 brian-laptop NetworkManager[960]:    SCPlugin-Ifupdown: d=
evices added (path: /sys/devices/virtual/net/lo, iface: lo)
May 16 14:56:32 brian-laptop NetworkManager[960]:    SCPlugin-Ifupdown: d=
evice added (path: /sys/devices/virtual/net/lo, iface: lo): no ifupdown c=
onfiguration found.
May 16 14:56:32 brian-laptop NetworkManager[960]:    SCPlugin-Ifupdown: e=
nd _init.
May 16 14:56:32 brian-laptop NetworkManager[960]: <info> Loaded plugin if=
updown: (C) 2008 Canonical Ltd.  To report bugs please use the NetworkMan=
ager mailing list.
May 16 14:56:32 brian-laptop NetworkManager[960]: <info> Loaded plugin ke=
yfile: (c) 2007 - 2010 Red Hat, Inc.  To report bugs please use the Netwo=
rkManager mailing list.
May 16 14:56:32 brian-laptop NetworkManager[960]:    SCPlugin-Ofono: Acqu=
ired D-Bus service com.canonical.NMOfono
May 16 14:56:32 brian-laptop NetworkManager[960]:    SCPlugin-Ofono: init=
!
May 16 14:56:32 brian-laptop NetworkManager[960]:    SCPlugin-Ofono: end =
_init.
May 16 14:56:32 brian-laptop NetworkManager[960]: <info> Loaded plugin (n=
ull): (null)
May 16 14:56:32 brian-laptop NetworkManager[960]:    Ifupdown: get unmana=
ged devices count: 1
May 16 14:56:32 brian-laptop NetworkManager[960]:    SCPlugin-Ifupdown: (=
39689760) ... get_connections.
May 16 14:56:32 brian-laptop NetworkManager[960]:    SCPlugin-Ifupdown: (=
39689760) ... get_connections (managed=3Dfalse): return empty list.
May 16 14:56:32 brian-laptop NetworkManager[960]:    keyfile: parsing bri=
anspot ...=20
May 16 14:56:32 brian-laptop kernel: [    7.836398] audit_printk_skb: 3 c=
allbacks suppressed
May 16 14:56:32 brian-laptop kernel: [    7.836401] type=3D1400 audit(140=
0273792.470:12): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"/usr/lib/lightdm/lightdm-guest-session" pid=3D1006 c=
omm=3D"apparmor_parser"
May 16 14:56:32 brian-laptop kernel: [    7.836405] type=3D1400 audit(140=
0273792.470:13): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"chromium" pid=3D1006 comm=3D"apparmor_parser"
May 16 14:56:32 brian-laptop kernel: [    7.836593] type=3D1400 audit(140=
0273792.470:14): apparmor=3D"STATUS" operation=3D"profile_replace" profil=
e=3D"unconfined" name=3D"chromium" pid=3D1006 comm=3D"apparmor_parser"
May 16 14:56:32 brian-laptop kernel: [    7.837478] type=3D1400 audit(140=
0273792.470:15): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"/usr/lib/x86_64-linux-gnu/lightdm-remote-session-fre=
erdp/freerdp-session-wrapper" pid=3D1007 comm=3D"apparmor_parser"
May 16 14:56:32 brian-laptop kernel: [    7.837485] type=3D1400 audit(140=
0273792.470:16): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"chromium" pid=3D1007 comm=3D"apparmor_parser"
May 16 14:56:32 brian-laptop kernel: [    7.837812] type=3D1400 audit(140=
0273792.470:17): apparmor=3D"STATUS" operation=3D"profile_replace" profil=
e=3D"unconfined" name=3D"chromium" pid=3D1007 comm=3D"apparmor_parser"
May 16 14:56:32 brian-laptop NetworkManager[960]:    keyfile:     read co=
nnection 'brianspot'
May 16 14:56:32 brian-laptop NetworkManager[960]:    keyfile: parsing kne=
aders ...=20
May 16 14:56:32 brian-laptop kernel: [    7.839443] type=3D1400 audit(140=
0273792.474:18): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"/usr/lib/x86_64-linux-gnu/lightdm-remote-session-ucc=
sconfigure/uccsconfigure-session-wrapper" pid=3D1008 comm=3D"apparmor_par=
ser"
May 16 14:56:32 brian-laptop kernel: [    7.839448] type=3D1400 audit(140=
0273792.474:19): apparmor=3D"STATUS" operation=3D"profile_load" profile=3D=
"unconfined" name=3D"chromium" pid=3D1008 comm=3D"apparmor_parser"
May 16 14:56:32 brian-laptop kernel: [    7.839686] type=3D1400 audit(140=
0273792.474:20): apparmor=3D"STATUS" operation=3D"profile_replace" profil=
e=3D"unconfined" name=3D"chromium" pid=3D1008 comm=3D"apparmor_parser"
May 16 14:56:32 brian-laptop kernel: [    7.842858] type=3D1400 audit(140=
0273792.478:21): apparmor=3D"STATUS" operation=3D"profile_replace" profil=
e=3D"unconfined" name=3D"/sbin/dhclient" pid=3D1009 comm=3D"apparmor_pars=
er"
May 16 14:56:32 brian-laptop NetworkManager[960]:    keyfile:     read co=
nnection 'kneaders'
May 16 14:56:32 brian-laptop NetworkManager[960]:    keyfile: parsing BJO=
NES ...=20
May 16 14:56:32 brian-laptop NetworkManager[960]:    keyfile:     read co=
nnection 'BJONES'
May 16 14:56:32 brian-laptop NetworkManager[960]:    SCPlugin-Ofono: (127=
5084144) ... get_connections.
May 16 14:56:32 brian-laptop NetworkManager[960]:    SCPlugin-Ofono: (127=
5084144) connections count: 0
May 16 14:56:32 brian-laptop NetworkManager[960]:    Ifupdown: get unmana=
ged devices count: 1
May 16 14:56:32 brian-laptop NetworkManager[960]: <info> monitoring kerne=
l firmware directory '/lib/firmware'.
May 16 14:56:32 brian-laptop NetworkManager[960]: <info> rfkill0: found W=
iFi radio killswitch (at /sys/devices/pci0000:00/0000:00:1c.0/0000:01:00.=
0/ieee80211/phy0/rfkill0) (driver iwlwifi)
May 16 14:56:32 brian-laptop NetworkManager[960]: <info> WiFi enabled by =
radio killswitch; enabled by state file
May 16 14:56:32 brian-laptop NetworkManager[960]: <info> WWAN enabled by =
radio killswitch; enabled by state file
May 16 14:56:32 brian-laptop NetworkManager[960]: <info> WiMAX enabled by=
 radio killswitch; enabled by state file
May 16 14:56:32 brian-laptop NetworkManager[960]: <info> Networking is en=
abled by state file
May 16 14:56:32 brian-laptop NetworkManager[960]: <info> (wlan0): using n=
l80211 for WiFi device control
May 16 14:56:32 brian-laptop NetworkManager[960]: <info> (wlan0): driver =
supports Access Point (AP) mode
May 16 14:56:32 brian-laptop NetworkManager[960]: <info> (wlan0): new 802=
=2E11 WiFi device (driver: 'iwlwifi' ifindex: 2)
May 16 14:56:32 brian-laptop NetworkManager[960]: <info> (wlan0): exporte=
d as /org/freedesktop/NetworkManager/Devices/0
May 16 14:56:32 brian-laptop NetworkManager[960]: <warn> /sys/devices/vir=
tual/net/lo: couldn't determine device driver; ignoring...
May 16 14:56:32 brian-laptop NetworkManager[960]: <warn> /sys/devices/vir=
tual/net/lo: couldn't determine device driver; ignoring...
May 16 14:56:32 brian-laptop NetworkManager[960]: <info> urfkill disappea=
red from the bus
May 16 14:56:32 brian-laptop NetworkManager[960]: <info> ModemManager ava=
ilable in the bus
May 16 14:56:32 brian-laptop cron[1069]: (CRON) INFO (pidfile fd =3D 3)
May 16 14:56:32 brian-laptop whoopsie[1113]: whoopsie 0.2.24.5 starting u=
p.
May 16 14:56:32 brian-laptop whoopsie[1113]: Using lock path: /var/lock/w=
hoopsie/lock
May 16 14:56:32 brian-laptop anacron[1131]: Anacron 2.3 started on 2014-0=
5-16
May 16 14:56:32 brian-laptop anacron[1131]: Normal exit (0 jobs run)
May 16 14:56:32 brian-laptop acpid: starting up with netlink and the inpu=
t layer
May 16 14:56:32 brian-laptop cron[1133]: (CRON) STARTUP (fork ok)
May 16 14:56:32 brian-laptop acpid: 9 rules loaded
May 16 14:56:32 brian-laptop acpid: waiting for events: event logging is =
off
May 16 14:56:32 brian-laptop cron[1133]: (CRON) INFO (Running @reboot job=
s)
May 16 14:56:32 brian-laptop dbus[494]: [system] Activating service name=3D=
'org.freedesktop.Accounts' (using servicehelper)
May 16 14:56:32 brian-laptop accounts-daemon[1254]: started daemon versio=
n 0.6.35
May 16 14:56:32 brian-laptop dbus[494]: [system] Successfully activated s=
ervice 'org.freedesktop.Accounts'
May 16 14:56:32 brian-laptop acpid: client connected from 1250[0:0]
May 16 14:56:32 brian-laptop acpid: 1 client rule loaded
May 16 14:56:32 brian-laptop NetworkManager[960]: <info> Unmanaged Device=
 found; state CONNECTED forced. (see http://bugs.launchpad.net/bugs/19188=
9)
May 16 14:56:32 brian-laptop NetworkManager[960]: <info> Unmanaged Device=
 found; state CONNECTED forced. (see http://bugs.launchpad.net/bugs/19188=
9)
May 16 14:56:32 brian-laptop NetworkManager[960]: <info> NetworkManager s=
tate is now CONNECTED_GLOBAL
May 16 14:56:32 brian-laptop NetworkManager[960]: <info> Unmanaged Device=
 found; state CONNECTED forced. (see http://bugs.launchpad.net/bugs/19188=
9)
May 16 14:56:32 brian-laptop whoopsie[1151]: offline
May 16 14:56:32 brian-laptop kernel: [    8.234890] drm: not enough stole=
n space for compressed buffer (need 23142400 more bytes), disabling. Hint=
: you may be able to increase stolen memory size in the BIOS to avoid thi=
s.
May 16 14:56:32 brian-laptop kernel: [    8.262562] usb 2-7: unable to re=
ad config index 0 descriptor/start: -71
May 16 14:56:32 brian-laptop kernel: [    8.262566] usb 2-7: can't read c=
onfigurations, error -71
May 16 14:56:32 brian-laptop avahi-daemon[627]: Leaving mDNS multicast gr=
oup on interface wlan0.IPv6 with address fe80::5e51:4fff:fe63:1e10.
May 16 14:56:32 brian-laptop avahi-daemon[627]: Joining mDNS multicast gr=
oup on interface wlan0.IPv6 with address 2002:d1b5:5206:0:5e51:4fff:fe63:=
1e10.
May 16 14:56:32 brian-laptop avahi-daemon[627]: Registering new address r=
ecord for 2002:d1b5:5206:0:5e51:4fff:fe63:1e10 on wlan0.*.
May 16 14:56:32 brian-laptop avahi-daemon[627]: Withdrawing address recor=
d for fe80::5e51:4fff:fe63:1e10 on wlan0.
May 16 14:56:33 brian-laptop kernel: [    8.374411] usb 2-7: new full-spe=
ed USB device number 7 using xhci_hcd
May 16 14:56:33 brian-laptop avahi-daemon[627]: Registering new address r=
ecord for 2002:d1b5:5206:0:519e:a77b:4e37:55fb on wlan0.*.
May 16 14:56:33 brian-laptop dbus[494]: [system] Activating service name=3D=
'org.freedesktop.UPower' (using servicehelper)
May 16 14:56:33 brian-laptop dbus[494]: [system] Successfully activated s=
ervice 'org.freedesktop.UPower'
May 16 14:56:33 brian-laptop dbus[494]: [system] Activating service name=3D=
'org.freedesktop.RealtimeKit1' (using servicehelper)
May 16 14:56:33 brian-laptop dbus[494]: [system] Successfully activated s=
ervice 'org.freedesktop.RealtimeKit1'
May 16 14:56:33 brian-laptop rtkit-daemon[1451]: Successfully called chro=
ot.
May 16 14:56:33 brian-laptop rtkit-daemon[1451]: Successfully dropped pri=
vileges.
May 16 14:56:33 brian-laptop rtkit-daemon[1451]: Successfully limited res=
ources.
May 16 14:56:33 brian-laptop rtkit-daemon[1451]: Running.
May 16 14:56:33 brian-laptop rtkit-daemon[1451]: Watchdog thread running.=

May 16 14:56:33 brian-laptop rtkit-daemon[1451]: Canary thread running.
May 16 14:56:33 brian-laptop rtkit-daemon[1451]: Successfully made thread=
 1447 of process 1447 (n/a) owned by '111' high priority at nice level -1=
1.
May 16 14:56:33 brian-laptop rtkit-daemon[1451]: Supervising 1 threads of=
 1 processes of 1 users.
May 16 14:56:33 brian-laptop rtkit-daemon[1451]: Successfully made thread=
 1489 of process 1447 (n/a) owned by '111' RT at priority 5.
May 16 14:56:33 brian-laptop rtkit-daemon[1451]: Supervising 2 threads of=
 1 processes of 1 users.
May 16 14:56:33 brian-laptop rtkit-daemon[1451]: Successfully made thread=
 1490 of process 1447 (n/a) owned by '111' RT at priority 5.
May 16 14:56:33 brian-laptop rtkit-daemon[1451]: Supervising 3 threads of=
 1 processes of 1 users.
May 16 14:56:33 brian-laptop rtkit-daemon[1451]: Successfully made thread=
 1491 of process 1447 (n/a) owned by '111' RT at priority 5.
May 16 14:56:33 brian-laptop rtkit-daemon[1451]: Supervising 4 threads of=
 1 processes of 1 users.
May 16 14:56:34 brian-laptop ModemManager[932]: <warn>  Couldn't find sup=
port for device at '/sys/devices/pci0000:00/0000:00:1c.0/0000:01:00.0': n=
ot supported by any plugin
May 16 14:56:35 brian-laptop kernel: [   10.448771] usb 2-7: unable to re=
ad config index 0 descriptor/start: -71
May 16 14:56:35 brian-laptop kernel: [   10.448776] usb 2-7: can't read c=
onfigurations, error -71
May 16 14:56:35 brian-laptop kernel: [   10.448829] hub 2-0:1.0: unable t=
o enumerate USB device on port 7
May 16 14:56:35 brian-laptop kernel: [   10.560157] usb 2-8: new high-spe=
ed USB device number 8 using xhci_hcd
May 16 14:56:35 brian-laptop kernel: [   10.611745] usb 2-8: New USB devi=
ce found, idVendor=3D5986, idProduct=3D0535
May 16 14:56:35 brian-laptop kernel: [   10.611750] usb 2-8: New USB devi=
ce strings: Mfr=3D3, Product=3D1, SerialNumber=3D2
May 16 14:56:35 brian-laptop kernel: [   10.611752] usb 2-8: Product: Len=
ovo EasyCamera
May 16 14:56:35 brian-laptop kernel: [   10.611754] usb 2-8: Manufacturer=
: Generic
May 16 14:56:35 brian-laptop kernel: [   10.611756] usb 2-8: SerialNumber=
: 200901010001
May 16 14:56:35 brian-laptop kernel: [   10.852457] usb 2-7: new full-spe=
ed USB device number 9 using xhci_hcd
May 16 14:56:37 brian-laptop kernel: [   12.926455] usb 2-7: unable to re=
ad config index 0 descriptor/start: -71
May 16 14:56:37 brian-laptop kernel: [   12.926461] usb 2-7: can't read c=
onfigurations, error -71
May 16 14:56:37 brian-laptop kernel: [   13.038170] usb 2-7: new full-spe=
ed USB device number 10 using xhci_hcd
May 16 14:56:37 brian-laptop kernel: [   13.058025] usb 2-7: New USB devi=
ce found, idVendor=3D04f3, idProduct=3D016f
May 16 14:56:37 brian-laptop kernel: [   13.058030] usb 2-7: New USB devi=
ce strings: Mfr=3D4, Product=3D14, SerialNumber=3D0
May 16 14:56:37 brian-laptop kernel: [   13.058032] usb 2-7: Product: Tou=
chscreen
May 16 14:56:37 brian-laptop kernel: [   13.058034] usb 2-7: Manufacturer=
: ELAN
May 16 14:56:37 brian-laptop kernel: [   13.058144] usb 2-7: ep 0x2 - rou=
nding interval to 64 microframes, ep desc says 80 microframes
May 16 14:56:37 brian-laptop mtp-probe: checking bus 2, device 8: "/sys/d=
evices/pci0000:00/0000:00:14.0/usb2/2-8"
May 16 14:56:37 brian-laptop mtp-probe: checking bus 2, device 3: "/sys/d=
evices/pci0000:00/0000:00:14.0/usb2/2-6"
May 16 14:56:37 brian-laptop mtp-probe: bus: 2, device: 3 was not an MTP =
device
May 16 14:56:37 brian-laptop mtp-probe: checking bus 2, device 10: "/sys/=
devices/pci0000:00/0000:00:14.0/usb2/2-7"
May 16 14:56:37 brian-laptop mtp-probe: bus: 2, device: 8 was not an MTP =
device
May 16 14:56:37 brian-laptop kernel: [   13.090273] hidraw: raw HID event=
s driver (C) Jiri Kosina
May 16 14:56:37 brian-laptop kernel: [   13.102300] usbcore: registered n=
ew interface driver btusb
May 16 14:56:37 brian-laptop kernel: [   13.112023] Linux video capture i=
nterface: v2.00
May 16 14:56:37 brian-laptop kernel: [   13.121730] Bluetooth: hci0: read=
 Intel version: 370710018002030d00
May 16 14:56:37 brian-laptop mtp-probe: bus: 2, device: 10 was not an MTP=
 device
May 16 14:56:37 brian-laptop kernel: [   13.122282] Bluetooth: hci0: Inte=
l Bluetooth firmware file: intel/ibt-hw-37.7.10-fw-1.80.2.3.d.bseq
May 16 14:56:37 brian-laptop kernel: [   13.123561] uvcvideo: Found UVC 1=
=2E00 device Lenovo EasyCamera (5986:0535)
May 16 14:56:37 brian-laptop kernel: [   13.142931] input: Lenovo EasyCam=
era as /devices/pci0000:00/0000:00:14.0/usb2/2-8/2-8:1.0/input/input12
May 16 14:56:37 brian-laptop kernel: [   13.143527] usbcore: registered n=
ew interface driver uvcvideo
May 16 14:56:37 brian-laptop kernel: [   13.143530] USB Video Class drive=
r (1.1.1)
May 16 14:56:37 brian-laptop kernel: [   13.154446] usbcore: registered n=
ew interface driver usbhid
May 16 14:56:37 brian-laptop kernel: [   13.154450] usbhid: USB HID core =
driver
May 16 14:56:37 brian-laptop kernel: [   13.163652] input: ELAN Touchscre=
en as /devices/pci0000:00/0000:00:14.0/usb2/2-7/2-7:1.0/input/input13
May 16 14:56:37 brian-laptop kernel: [   13.170361] hid-multitouch 0003:0=
4F3:016F.0002: input,hiddev0,hidraw0: USB HID v1.10 Device [ELAN Touchscr=
een] on usb-0000:00:14.0-7/input0
May 16 14:56:37 brian-laptop kernel: [   13.239326] Bluetooth: hci0: Inte=
l Bluetooth firmware patch completed and activated
May 16 14:56:37 brian-laptop bluetoothd[523]: Unknown command complete fo=
r opcode 19
May 16 14:56:37 brian-laptop anacron[1885]: Anacron 2.3 started on 2014-0=
5-16
May 16 14:56:37 brian-laptop anacron[1885]: Normal exit (0 jobs run)
May 16 14:56:37 brian-laptop bluetoothd[523]: Adapter /org/bluez/523/hci0=
 has been enabled
May 16 14:56:37 brian-laptop bluetoothd[523]: Endpoint registered: sender=
=3D:1.31 path=3D/MediaEndpoint/HFPAG
May 16 14:56:37 brian-laptop bluetoothd[523]: Endpoint registered: sender=
=3D:1.31 path=3D/MediaEndpoint/HFPHS
May 16 14:56:37 brian-laptop bluetoothd[523]: Endpoint registered: sender=
=3D:1.31 path=3D/MediaEndpoint/A2DPSource
May 16 14:56:37 brian-laptop bluetoothd[523]: Endpoint registered: sender=
=3D:1.31 path=3D/MediaEndpoint/A2DPSink
May 16 14:56:40 brian-laptop ntpdate[918]: adjust time server 91.189.94.4=
 offset -0.274844 sec
May 16 14:56:42 brian-laptop NetworkManager[960]: <info> WiFi hardware ra=
dio set enabled
May 16 14:56:43 brian-laptop rtkit-daemon[1451]: Successfully made thread=
 2062 of process 2062 (n/a) owned by '1000' high priority at nice level -=
11.
May 16 14:56:43 brian-laptop rtkit-daemon[1451]: Supervising 5 threads of=
 2 processes of 2 users.
May 16 14:56:43 brian-laptop rtkit-daemon[1451]: Successfully made thread=
 2076 of process 2062 (n/a) owned by '1000' RT at priority 5.
May 16 14:56:43 brian-laptop rtkit-daemon[1451]: Supervising 6 threads of=
 2 processes of 2 users.
May 16 14:56:43 brian-laptop rtkit-daemon[1451]: Successfully made thread=
 2078 of process 2062 (n/a) owned by '1000' RT at priority 5.
May 16 14:56:43 brian-laptop rtkit-daemon[1451]: Supervising 7 threads of=
 2 processes of 2 users.
May 16 14:56:43 brian-laptop rtkit-daemon[1451]: Successfully made thread=
 2079 of process 2062 (n/a) owned by '1000' RT at priority 5.
May 16 14:56:43 brian-laptop rtkit-daemon[1451]: Supervising 8 threads of=
 2 processes of 2 users.
May 16 14:56:43 brian-laptop bluetoothd[523]: Endpoint registered: sender=
=3D:1.64 path=3D/MediaEndpoint/HFPAG
May 16 14:56:43 brian-laptop bluetoothd[523]: Endpoint registered: sender=
=3D:1.64 path=3D/MediaEndpoint/HFPHS
May 16 14:56:43 brian-laptop bluetoothd[523]: Endpoint registered: sender=
=3D:1.64 path=3D/MediaEndpoint/A2DPSource
May 16 14:56:43 brian-laptop bluetoothd[523]: Endpoint registered: sender=
=3D:1.64 path=3D/MediaEndpoint/A2DPSink
May 16 14:56:43 brian-laptop dbus[494]: [system] Activating service name=3D=
'org.freedesktop.UDisks2' (using servicehelper)
May 16 14:56:43 brian-laptop udisksd[2107]: udisks daemon version 2.1.3 s=
tarting
May 16 14:56:44 brian-laptop dbus[494]: [system] Successfully activated s=
ervice 'org.freedesktop.UDisks2'
May 16 14:56:44 brian-laptop udisksd[2107]: Acquired the name org.freedes=
ktop.UDisks2 on the system message bus
May 16 14:56:44 brian-laptop NetworkManager[960]: <info> Unmanaged Device=
 found; state CONNECTED forced. (see http://bugs.launchpad.net/bugs/19188=
9)
May 16 14:56:47 brian-laptop wpa_supplicant[741]: wlan0: CTRL-EVENT-DISCO=
NNECTED bssid=3D00:22:6b:54:68:d2 reason=3D4 locally_generated=3D1
May 16 14:56:47 brian-laptop kernel: [   22.781244] cfg80211: Calling CRD=
A to update world regulatory domain
May 16 14:56:47 brian-laptop kernel: [   22.783425] cfg80211: World regul=
atory domain updated:
May 16 14:56:47 brian-laptop kernel: [   22.783428] cfg80211:   (start_fr=
eq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
May 16 14:56:47 brian-laptop kernel: [   22.783430] cfg80211:   (2402000 =
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 14:56:47 brian-laptop kernel: [   22.783432] cfg80211:   (2457000 =
KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 14:56:47 brian-laptop kernel: [   22.783434] cfg80211:   (2474000 =
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
May 16 14:56:47 brian-laptop kernel: [   22.783435] cfg80211:   (5170000 =
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 14:56:47 brian-laptop kernel: [   22.783437] cfg80211:   (5735000 =
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May 16 14:56:47 brian-laptop wpa_supplicant[741]: wlan0: CTRL-EVENT-SCAN-=
STARTED=20
May 16 14:56:48 brian-laptop wpa_supplicant[741]: wlan0: SME: Trying to a=
uthenticate with 00:22:6b:54:68:d2 (SSID=3D'BJONES' freq=3D2437 MHz)
May 16 14:56:48 brian-laptop kernel: [   23.573471] wlan0: authenticate w=
ith 00:22:6b:54:68:d2
May 16 14:56:48 brian-laptop wpa_supplicant[741]: wlan0: Trying to associ=
ate with 00:22:6b:54:68:d2 (SSID=3D'BJONES' freq=3D2437 MHz)
May 16 14:56:48 brian-laptop kernel: [   23.574896] wlan0: send auth to 0=
0:22:6b:54:68:d2 (try 1/3)
May 16 14:56:48 brian-laptop kernel: [   23.576802] wlan0: authenticated
May 16 14:56:48 brian-laptop kernel: [   23.578238] wlan0: associate with=
 00:22:6b:54:68:d2 (try 1/3)
May 16 14:56:48 brian-laptop kernel: [   23.582086] wlan0: RX AssocResp f=
rom 00:22:6b:54:68:d2 (capab=3D0x411 status=3D0 aid=3D4)
May 16 14:56:48 brian-laptop wpa_supplicant[741]: wlan0: Associated with =
00:22:6b:54:68:d2
May 16 14:56:48 brian-laptop kernel: [   23.585842] wlan0: associated
May 16 14:56:48 brian-laptop wpa_supplicant[741]: wlan0: WPA: Key negotia=
tion completed with 00:22:6b:54:68:d2 [PTK=3DCCMP GTK=3DTKIP]
May 16 14:56:48 brian-laptop wpa_supplicant[741]: wlan0: CTRL-EVENT-CONNE=
CTED - Connection to 00:22:6b:54:68:d2 completed [id=3D0 id_str=3D]
May 16 14:57:01 brian-laptop ntpdate[2334]: adjust time server 91.189.94.=
4 offset -0.268980 sec

--------------010201020504080002020405--
