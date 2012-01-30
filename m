Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:45678 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab2A3K3L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 05:29:11 -0500
Received: by werb13 with SMTP id b13so3284508wer.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jan 2012 02:29:10 -0800 (PST)
Message-ID: <4F2670F4.3010706@gmail.com> (sfid-20120130_112915_295502_78FCB682)
Date: Mon, 30 Jan 2012 11:29:08 +0100
From: Lars Duesing <lars.duesing@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Virtual Interfaces; using hostapd AND wpa_supplicant on the same
 physical device
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi List,

I'd like to create a temporary hotspot using an other wireless network 
which is already there.
My kids have some devices (like Nintendo DS) which are only capable 
using WEP.
So I want to create a temporary hotspot which I can filter on my own.

Years ago I was able to do such a configuration, but this was before 
mac80211 (I was then often on trade fairs, with very costly 
wlan-tariffs...).

Problem is: I get an error about a network name already exist - either 
on hostapd and wpa_supplicant - everytime the last program started.

 > iw phy phy0 interface add net0 type managed
 > hostapd -dd hostapd.conf
 > wpa_supplicant -dd -Dwext -inet0 -cwpa_supplicant.conf

hostapd.conf:
 > interface=wlan0
 > driver=nl80211
 > bridge=br0
 > ssid=TEST
 > wme_enabled=0
 > channel=9
 > hw_mode=g

wpa_supplicant.conf
 > ctrl_interface=DIR=/var/run/wpa_supplicant
 > network={
 >         ssid="CRYPT_WLAN"
 >         scan_ssid=1
 >         key_mgmt=WPA-PSK
 >         psk="PSKpskPSK"
 > }

lsmod|grep 80211
 > mac80211              393459  1 ath5k
 > cfg80211                172427  3 ath5k,ath,mac80211


lspci -v
 > 0a:03.0 Ethernet controller: Atheros Communications Inc. AR2413 
802.11bg NIC (rev 01)
 >         Subsystem: AMBIT Microsystem Corp. Device 0418
 >         Flags: bus master, medium devsel, latency 168, IRQ 18
 >         Memory at d0000000 (32-bit, non-prefetchable) [size=64K]
 >         Capabilities: [44] Power Management version 2
 >         Kernel driver in use: ath5k
 >         Kernel modules: ath5k

/proc/version:
 > Linux version 3.0.0-15-generic (buildd@zirconium) (gcc version 4.6.1 
(Ubuntu/Linaro 4.6.1-9ubuntu3) ) #26-Ubuntu SMP Fri Jan 20 15:59:53 UTC 2012

