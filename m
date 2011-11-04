Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35528 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab1KDOGQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 10:06:16 -0400
Received: by iage36 with SMTP id e36so2578475iag.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 Nov 2011 07:06:15 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 4 Nov 2011 10:06:15 -0400
Message-ID: <CAAaUcVxoeOVqXBfSH0WivmOg32yoXMOZTkStg1HxECkAJsv6+Q@mail.gmail.com> (sfid-20111104_150619_435082_482D0478)
Subject: Open80211s on Android -- iw EOPNOTSUPP error when trying to join mesh network?
From: Kiran Karra <kiran.karra@gmail.com>
To: linux wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,
I have been trying to get open80211s working on the Android platform
using the Beagleboard.  I have a WiFi dongle, which works off the
p54usb driver, and have ported that successfully over to Android.  I
have also built libnl1.1 and iw3.1 into my Android distribution.
Additionally, my kernel configuration (kernel version 2.6.37) has the
following options enabled under the NETWORKING --> WIRELESS section (I
removed the options that were not set in order to save space) :
#
# Network testing
#
CONFIG_WIRELESS=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_CFG80211=y
CONFIG_NL80211_TESTMODE=y
CONFIG_CFG80211_DEVELOPER_
WARNINGS=y
CONFIG_CFG80211_DEFAULT_PS=y
CONFIG_CFG80211_WEXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_LIB80211=y
CONFIG_LIB80211_DEBUG=y
CONFIG_MAC80211=y
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_DEBUGFS=y
CONFIG_MAC80211_DEBUG_MENU=y

Ok, so I have all the tools above built, and I go to load up the
Android OS on the beagleboard.  Once the system comes up, I load the
p54usb wireless module as follows:

# cd /system/lib/modules
# insmod p54usb.ko
The wireless driver loads fine.  Next, if I type in:
# iw phy0 info
I get a lot of information about my wifi dongle's capabilities.  In
the "Supported interface modes" section, I see that "mesh point" is
supported.

After this, I do the command:
# iw phy0 init
After that, a wlan0 interface seems to be created.  To check, I do:
# iw wlan0 info, and I get the printout:
Interface wlan0
    ifindex 3
    type managed

Next, following the instructions on the o11s.org website for how-to
setup a mesh point network, I type in:
# iw dev wlan0 interface add mesh0 type mp
# ifconfig mesh0 192.168.3.80
After this, I do
# iw dev mesh0 mesh join mymesh
This is when I get my error: command failed: Operation not supported
on transport endpoint (-95)

However, in my netcfg output, I can see that mesh0 is an interface
that is UP and has the IP address that I assigned it.  I can also ping
the mesh0 interface from within the beagleboard on which the mesh
interface was created.  I'm not sure if that means anything, but I
figured I'd throw it out there.  The commands and the outputs of the
netcfg and the ping are shown below:

# netcfg
lo       UP    127.0.0.1       255.0.0.0       0x00000049
usb0     DOWN  0.0.0.0         0.0.0.0         0x00001002
wlan0    DOWN  0.0.0.0         0.0.0.0         0x00001002
mesh0    UP    192.168.3.80    255.255.255.0   0x00001043

# iw mesh0 info
Interface mesh0
    ifindex 4
    type mesh point

# ping 192.168.3.80
PING 192.168.3.80 (192.168.3.80) 56(84) bytes of data.
64 bytes from 192.168.3.80: icmp_seq=1 ttl=64 time=0.122 ms
64 bytes from 192.168.3.80: icmp_seq=2 ttl=64 time=0.061 ms
64 bytes from 192.168.3.80: icmp_seq=3 ttl=64 time=0.122 ms
64 bytes from 192.168.3.80: icmp_seq=4 ttl=64 time=0.122 ms
^C
--- 192.168.3.80 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 2999ms
rtt min/avg/max/mdev = 0.061/0.106/0.122/0.029 ms

# iw dev $MESH_IFACE station dump
** NO RESPONSES ** meaning that this device is not participating in
mesh network??

Can anybody shed light as to why I am unable to join the mesh network
and getting the EOPNOTSUPP error?  Any suggestions are greatly
appreciated.

Thanks in advance,
Kiran
