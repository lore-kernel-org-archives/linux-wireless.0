Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out11.libero.it ([212.52.84.111]:55490 "EHLO
	cp-out11.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754905Ab0AMVpw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2010 16:45:52 -0500
Received: from pcfabio2.localnet (151.48.50.224) by cp-out11.libero.it (8.5.119) (authenticated as rossi.f@inwind.it)
        id 4AE04A3D1177B12B for linux-wireless@vger.kernel.org; Wed, 13 Jan 2010 22:45:50 +0100
From: Fabio Rossi <rossi.f@inwind.it>
To: linux-wireless@vger.kernel.org
Subject: WARNING: at net/mac80211/work.c:980 ieee80211_work_purge
Date: Wed, 13 Jan 2010 22:45:33 +0100
MIME-Version: 1.0
Message-Id: <201001132245.33468.rossi.f@inwind.it>
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
today I have go the following warning several times but it's not
reproducible systematically. It happens at boot when the USB wireless card is
already connected and the wpa_supplicant is restarted to connect to the AP.
The kernel version is v2.6.33-rc2-47131-gc72a18c.

This are the kernel messages I get soon after boot

cfg80211: Calling CRDA to update world regulatory domain
cfg80211: World regulatory domain updated:
    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
    (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
phy0 -> rt73usb_validate_eeprom: EEPROM recovery - NIC: 0xffef
phy0 -> rt73usb_validate_eeprom: EEPROM recovery - Led: 0xe000
phy0 -> rt73usb_validate_eeprom: EEPROM recovery - RSSI OFFSET A: 0x0000
phy0 -> rt2x00_print_chip: Info - Chipset detected - rt: 1300, rf: 0002, rev: 
0002573a.
phy0: Selected rate control algorithm 'minstrel'
Registered led device: rt73usb-phy0::radio
Registered led device: rt73usb-phy0::assoc
Registered led device: rt73usb-phy0::quality
usbcore: registered new interface driver rt73usb
phy0 -> rt2x00lib_request_firmware: Info - Loading firmware file 'rt73.bin'.
rt73usb 1-1:1.0: firmware: requesting rt73.bin
phy0 -> rt2x00lib_request_firmware: Info - Firmware detected - version: 1.7.
phy0: device now idle
phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 3, CWmax: 4, 
Aifs: 2, TXop: 102.
phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 4, CWmax: 5, 
Aifs: 2, TXop: 188.
phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 5, CWmax: 10, 
Aifs: 3, TXop: 0.
ADDRCONF(NETDEV_UP): wlan0: link is not ready
phy0: device no longer idle - scanning
phy0: device now idle
phy0: device no longer idle - scanning
phy0: device now idle
phy0: device no longer idle - scanning
phy0: device now idle
phy0: device no longer idle - working
wlan0: direct probe to MM:AA:CC:MM:AA:CC (try 1)
wlan0: direct probe responded
wlan0: authenticate with MM:AA:CC:MM:AA:CC (try 1)
wlan0: authenticated
phy0: device now idle
phy0: device no longer idle - working

Then here I restart the service responsible for wpa_supplicant and I get

wlan0: deauthenticating from MM:AA:CC:MM:AA:CC by local choice (reason=3)
wlan0: direct probe to MM:AA:CC:MM:AA:CC (try -554920987)
------------[ cut here ]------------
WARNING: at net/mac80211/work.c:980 ieee80211_work_purge+0x9b/0xaf [mac80211]
()
Hardware name: Presario 2701EA 470020-401
Modules linked in: rt73usb rt2x00usb rt2x00lib led_class mac80211 cfg80211
Pid: 5213, comm: ifconfig Not tainted 2.6.33-rc2-wl #70
Call Trace:
 [<c147ded8>] ? printk+0x18/0x1a
 [<e1844b6c>] ? ieee80211_work_purge+0x9b/0xaf [mac80211]
 [<c101f37c>] warn_slowpath_common+0x66/0xb2
 [<e1844b6c>] ? ieee80211_work_purge+0x9b/0xaf [mac80211]
 [<c101f3dd>] warn_slowpath_null+0x15/0x17
 [<e1844b6c>] ieee80211_work_purge+0x9b/0xaf [mac80211]
 [<e18453e3>] ieee80211_stop+0x34/0x54e [mac80211]
 [<c13de3fd>] ? dev_deactivate+0x17c/0x194
 [<c13d129f>] dev_close+0x55/0x99
 [<c1023f6d>] ? local_bh_enable+0x73/0x96
 [<c13d0c23>] dev_change_flags+0x81/0x18f
 [<c141062f>] devinet_ioctl+0x64a/0x68b
 [<c13d208e>] ? dev_ioctl+0x251/0x4fd
 [<c141170e>] inet_ioctl+0x6d/0x7f
 [<c13c1d82>] sock_ioctl+0x5d/0x22d
 [<c13c1d25>] ? sock_ioctl+0x0/0x22d
 [<c107f47d>] vfs_ioctl+0x22/0x91
 [<c107f612>] do_vfs_ioctl+0x66/0x589
 [<c10619b4>] ? handle_mm_fault+0x111/0x592
 [<c10463f5>] ? call_rcu+0x8/0xa
 [<c1013ae6>] ? do_page_fault+0x177/0x2f1
 [<c107fb68>] sys_ioctl+0x33/0x57
 [<c1002990>] sysenter_do_call+0x12/0x26
---[ end trace 186661ad4c475d4c ]---
wlan0: direct probe to MM:AA:CC:MM:AA:CC (try -554920986)
wlan0: direct probe to MM:AA:CC:MM:AA:CC (try -554920985)
wlan0: direct probe to MM:AA:CC:MM:AA:CC (try -554920984)
wlan0: direct probe to MM:AA:CC:MM:AA:CC (try -554920983)
wlan0: direct probe to MM:AA:CC:MM:AA:CC (try -554920982)
