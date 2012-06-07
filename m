Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58946 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351Ab2FGIUI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 04:20:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1ScXwq-0003ef-Sn
	for linux-wireless@vger.kernel.org; Thu, 07 Jun 2012 10:20:04 +0200
Received: from cph-ex1.sdesigns.com ([192.215.56.171])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 10:20:04 +0200
Received: from hanskroner by cph-ex1.sdesigns.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 10:20:04 +0200
To: linux-wireless@vger.kernel.org
From: Hans =?utf-8?b?S3LDtm5lcg==?= <hanskroner@gmail.com>
Subject: mwifiex:Testing AP functionality with hostapd
Date: Thu, 7 Jun 2012 08:18:35 +0000 (UTC)
Message-ID: <loom.20120607T100950-564@post.gmane.org> (sfid-20120607_102015_629221_9689D87F)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I wanted to test the new "AP mode" functionality in the mwifiex driver so I
built a kernel off the wireless-testing tree and hostapd v2.0-devel from git.
I tried this on a "DreamPlug" that uses the SD8787.

"Client mode" is working fine, but I can't seem to be able to get "AP mode"
working. No matter what I do I get this output from hostapd:

random: Trying to read entropy from /dev/random
Configuration file: hostapd-minimal.conf
nl80211: interface uap0 in phy phy0
rfkill: initial event: idx=0 type=2 op=0 soft=0 hard=0
rfkill: initial event: idx=1 type=1 op=0 soft=0 hard=0
nl80211: Disable use_monitor with device_ap_sme since no monitor mode support d
etected
nl80211: Add own interface ifindex 5
nl80211: Set mode ifindex 5 iftype 3 (AP)
nl80211: Setup AP - device_ap_sme=1 use_monitor=0
nl80211: Subscribe to mgmt frames with AP handle 0x74608 (device SME)
nl80211: Register frame type=0xd0 nl_handle=0x74608
nl80211: Register frame match - hexdump(len=0): [NULL]
nl80211: Register frame command failed (type=208): ret=-95 (Operation not suppo
rted)
nl80211: Register frame match - hexdump(len=0): [NULL]
nl80211: Failed to set interface uap0 into AP mode
netlink: Operstate: linkmode=0, operstate=6
nl80211: Set mode ifindex 5 iftype 2 (STATION)
nl80211: Failed to set interface 5 to mode 2: -16 (Device or resource busy)
nl80211: Try mode change after setting interface down
nl80211: Set mode ifindex 5 iftype 2 (STATION)
nl80211: Failed to set interface 5 to mode 2: -16 (Device or resource busy)
nl80211: Set mode ifindex 5 iftype 2 (STATION)
nl80211: Failed to set interface 5 to mode 2: -16 (Device or resource busy)
[ ... ]
nl80211: Interface mode change to 2 from 3 failed
nl80211 driver initialization failed.

I've tried bringing both mlan0 and uap0 interfaces down/up and different
combinations of both to no avail. The patches for "AP mode" support mention
that is has been tested against hostapd v2.0-devel. Is there anything I should
be aware of when building hostapd? I'm also not sure if I'm running the correct
firmware for the SD8787.

Thanks in advance for any input!!!

Hans


--- mwifiex_sdio firmware ---

mwifiex_sdio mmc0:0001:1: WLAN FW already running! Skip FW dnld
mwifiex_sdio mmc0:0001:1: WLAN FW is active
mwifiex_sdio mmc0:0001:1: driver_version = mwifiex 1.0 (14.57.5.p69)

--- hostapd .config ---

CONFIG_DRIVER_HOSTAP=y
CONFIG_DRIVER_NL80211=y
CONFIG_LIBNL32=y
CFLAGS += -I/usr/include/libnl3
CONFIG_IAPP=y
CONFIG_RSN_PREAUTH=y
CONFIG_PEERKEY=y
CONFIG_EAP=y
CONFIG_EAP_MD5=y
CONFIG_EAP_TLS=y
CONFIG_EAP_MSCHAPV2=y
CONFIG_EAP_PEAP=y
CONFIG_EAP_GTC=y
CONFIG_EAP_TTLS=y
CONFIG_PKCS12=y
CONFIG_IPV6=y
CONFIG_IEEE80211N=y

--- hostatp-minimal.conf ---

interface=uap0
driver=nl80211
ssid=DreamPlug
hw_mode=g
channel=1

