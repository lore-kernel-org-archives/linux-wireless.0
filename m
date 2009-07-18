Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:39983 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754339AbZGRB1x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2009 21:27:53 -0400
Message-ID: <4A612514.4050708@redfish-solutions.com>
Date: Fri, 17 Jul 2009 18:27:48 -0700
From: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Using compat-wireless w/ 2.6.27.26
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm the lead developer on the Astlinux project, which I might have
mentioned in a previous posting.  This means that I have my hands in
many pots, so I'm not an expert in the latest Linux kernel changes... be
patient with me.  Hard to keep track of 200+ individual projects.

I'm building 2.6.26.27 as I said for (amongst other things) an Alix 2D3
(GeodeLX) with EMP-8602 (AR-5413) as a test platform.

My kernel gets built with:

#
# Wireless
#
CONFIG_CFG80211=m
CONFIG_NL80211=y
CONFIG_WIRELESS_EXT=y
# CONFIG_WIRELESS_EXT_SYSFS is not set
CONFIG_MAC80211=m

#
# Rate control algorithm selection
#
CONFIG_MAC80211_RC_PID=y
CONFIG_MAC80211_RC_DEFAULT_PID=y
CONFIG_MAC80211_RC_DEFAULT="pid"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_IEEE80211 is not set
CONFIG_RFKILL=m
CONFIG_RFKILL_INPUT=m
CONFIG_RFKILL_LEDS=y
# CONFIG_NET_9P is not set


I build compat-wireless-2.6.30 into /lib/modules/2.6.27.26-astlinux/kernel/... as a Kbuild.

The system also has iw-0.9.15 and hostapd-0.6.9.

All of this is fairly straightforward.

On boot, our /etc/init.d scripts do the following:

+ modprobe ath5k
ath5k phy0: Atheros AR5413 chip found (MAC: 0xa4, PHY: 0x61)

+ iw dev wlan0 interface add ap0 type managed
+ ip link set ap0 up
+ iw dev ap0 connect xxxx
command failed: Operation not supported (-95)



So doing some sanity checks by hand I get:

pbx ~ # lsmod | head
Module                  Size  Used by
ath5k                 104772  0 
mac80211              153304  1 ath5k
cfg80211               54584  2 ath5k,mac80211
binfmt_misc             7112  1 
aes_i586                7456  0 
aes_generic            28968  1 aes_i586
lm90                   11944  0 
hwmon                   2324  1 lm90
scx200_acb              4356  0 
pbx ~ # iw dev ap0 info
Interface ap0
	ifindex 9
	type managed
pbx ~ # iw phy phy0 info
command failed: No buffer space available (-105)
pbx ~ # 


Not sure why the "phy ... info" command fails.

pbx ~ # hostapd -v
hostapd v0.6.9
User space daemon for IEEE 802.11 AP management,
IEEE 802.1X/WPA/WPA2/EAP/RADIUS Authenticator
Copyright (c) 2002-2009, Jouni Malinen <j@w1.fi> and contributors
pbx ~ # cat /etc/hostapd.conf
# automatically generated. do not edit!

logger_syslog=-1
logger_syslog_level=2
logger_stdout=--1
logger_stdout_level=2

debug=0

ctrl_interface_group=0

# should this be per-ssid?
macaddr_acl=0

dump_file=/tmp/hostapd.dump

# should this be an option?
hw_mode=b

bridge=br1
interface=ap0
driver=nl80211
ssid=xxxxx
channel=0

auth_algs=1

wpa_passphrase=yyyyy
wpa=2
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP

ignore_broadcast_ssid=1

wpa_strict_rekey=1
wpa_group_rekey=600
wpa_gmk_rekey=14400

pbx ~ # ip link show ap0
9: ap0: <BROADCAST,MULTICAST> mtu 1500 qdisc pfifo_fast state DOWN qlen 1000
    link/ether 00:02:6f:5a:d2:2b brd ff:ff:ff:ff:ff:ff
pbx ~ # brctl show
bridge name	bridge id		STP enabled	interfaces
br1		8000.00026f5ad22b	no		ap0
							eth0
pbx ~ # 
pbx ~ # hostapd -dddd -P /var/run/hostapd.pid /etc/hostapd.conf
Configuration file: /etc/hostapd.conf
Line 8: DEPRECATED: 'debug' configuration variable is not used anymore
ctrl_interface_group=0
Failed to set interface ap0 to master mode.
nl80211 driver initialization failed.
ap0: Unable to setup interface.
ELOOP: remaining socket: sock=5 eloop_data=0x8098028 user_data=(nil) handler=0x806f503
pbx ~ # 
pbx ~ # ldd /usr/bin/hostapd
	libnl.so.1 => /usr/lib/libnl.so.1 (0xb7f04000)
	libcrypto.so.0.9.8 => /lib/libcrypto.so.0.9.8 (0xb7df8000)
	libgcc_s.so.1 => /lib/libgcc_s.so.1 (0xb7def000)
	libc.so.0 => /lib/libc.so.0 (0xb7da5000)
	libm.so.0 => /lib/libm.so.0 (0xb7d97000)
	libdl.so.0 => /lib/libdl.so.0 (0xb7d94000)
	ld-uClibc.so.0 => /lib/ld-uClibc.so.0 (0xb7f3d000)
pbx ~ # 


And on the host that this was cross-compiled:

[philipp@builder ~/kernel]$ cat build_i586/hostapd-0.6.9/hostapd/.config 
CFLAGS+=-Os -Wall -Os -pipe -fomit-frame-pointer -march=k6-2 -fno-align-functions -fno-align-loops -fno-align-jumps -fno-align-labels 
CFLAGS+= -DUSE_KERNEL_HEADERS -I/home/philipp/kernel/build_i586/linux-2.6.27.26-astlinux/include
CONFIG_IEEE80211N=y
CONFIG_DRIVER_NL80211=y
CFLAGS+=-I/home/philipp/kernel/build_i586/staging_dir/usr/include
LIBS+=-L/home/philipp/kernel/build_i586/root/usr/lib
CONFIG_DRIVER_NONE=y
CONFIG_DRIVER_WIRED=y
CONFIG_IAPP=y
CONFIG_RSN_PREAUTH=y
CONFIG_PEERKEY=y
CONFIG_EAP=y
CONFIG_EAP_MD5=y
CONFIG_EAP_MSCHAPV2=y
CONFIG_EAP_GTC=y
CONFIG_EAP_SIM=y
CONFIG_EAP_AKA=y
CONFIG_EAP_AKA_PRIME=y
CONFIG_EAP_PAX=y
CONFIG_EAP_PSK=y
CONFIG_EAP_SAKE=y
CONFIG_EAP_GPSK=y
CONFIG_EAP_GPSK_SHA256=y
CONFIG_EAP_IKEV2=y
CONFIG_PKCS12=y
CONFIG_IPV6=y
CONFIG_IEEE80211R=y
CONFIG_IEEE80211N=y
[philipp@builder ~/kernel]$ 



What am I missing?

How should I go about debugging this?

Thanks,

-Philip


