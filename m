Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailguard.fgan.de ([128.7.3.5]:34891 "EHLO mailguard.fgan.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756632AbZGIMmo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2009 08:42:44 -0400
Received: from rufsun5.fkie.fgan.de ([128.7.2.5] helo=mailhost.fgan.de)
	by mailguard.fgan.de with esmtps (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <wenzel@fgan.de>)
	id 1MOsHa-0002HO-Si
	for linux-wireless@vger.kernel.org; Thu, 09 Jul 2009 13:59:22 +0200
Received: from gustav.fkie.fgan.de ([128.7.5.95])
	by mailhost.fgan.de with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <wenzel@fgan.de>)
	id 1MOsHa-0002ES-DO
	for linux-wireless@vger.kernel.org; Thu, 09 Jul 2009 13:59:22 +0200
Message-ID: <4A55DB91.2070305@fgan.de>
Date: Thu, 09 Jul 2009 13:59:13 +0200
From: Alexander Wenzel <wenzel@fgan.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Problem with p54 driver and ibss mode
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!
I'm trying to get the latest p54 wireless drivers (ad-hoc mode)
to work on a Nokia N810... So far, without any success.

Some words about my scenario:
- Nokia N810 running a custom omap1 kernel
  (linux-omap-2.6.git / tag: "v2.6.29-omap1")
  Patched keyboard (board-n800.c) and usb driver (usb-tusb6010.c)
  to get it working...

- Installed Mer (Ubuntu 9.04) on an external mmc 4GB card
  Patched the bootmenu stuff to get rid of static /dev/ nodes problem
  which come up with the new kernel...

- compiled compat wireless drivers 2009-07-09
  disabled CONFIG_RFKILL_BACKPORT_LEDS because it didn't compile

- A second N810 running debian and nokias 2.6.21er kernel
  Ad-hoc mode is active. (ad-hoc is working, tested with some
  other N810 devices)

After all these preparations, patching and workaround stuff,
i finally inserted the wireless modules into the kernel
(rfkill_backport, cfg80211, mac80211, p54common, p54spi)
dmesg looks fine so far:
[ 3671.237365] cfg80211: Using static regulatory domain info
[ 3671.237396] cfg80211: Regulatory domain: US
[ 3671.237426] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[ 3671.237457] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[ 3671.237487] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[ 3671.237518] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[ 3671.237548] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[ 3671.237579] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[ 3671.237609] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[ 3671.238555] cfg80211: Calling CRDA for country: US
[ 3685.186523] cx3110x spi2.0: firmware: requesting 3826.arm
[ 3685.265045] phy0: p54 detected a LM20 firmware
[ 3685.265106] p54: rx_mtu reduced from 3240 to 2376
[ 3685.265106] phy0: FW rev 2.13.0.0.a.22.8 - Softmac protocol 5.6
[ 3685.265136] phy0: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
[ 3685.265197] cx3110x spi2.0: firmware: requesting 3826.eeprom
[ 3685.320800] cx3110x spi2.0: loading default eeprom...
[ 3685.320922] phy0: hwaddr 00:02:ee:c0:ff:ee, MAC:isl3820 RF:Longbow
[ 3685.455108] phy0: Selected rate control algorithm 'minstrel'
[ 3685.456787] Registered led device: p54-phy0::assoc
[ 3685.457031] Registered led device: p54-phy0::tx
[ 3685.457275] Registered led device: p54-phy0::rx
[ 3685.457489] Registered led device: p54-phy0::radio
[ 3685.457550] cx3110x spi2.0: is registered as 'phy0'

Monitor mode is also working. Here are some beacons from my second device:
00:01:37.463744 51669459us tsft 1.0 Mb/s 2462 MHz (0x00a0) 30dB signal -63dB noise antenna 0 [0x0000000e] Beacon (rita) [1.0* 2.0* 5.5 11.0 Mbit] IBSS CH: 11
00:01:37.566100 51771860us tsft 1.0 Mb/s 2462 MHz (0x00a0) 29dB signal -63dB noise antenna 0 [0x0000000e] Beacon (rita) [1.0* 2.0* 5.5 11.0 Mbit] IBSS CH: 11
00:01:37.668517 51874300us tsft 1.0 Mb/s 2462 MHz (0x00a0) 30dB signal -63dB noise antenna 0 [0x0000000e] Beacon (rita) [1.0* 2.0* 5.5 11.0 Mbit] IBSS CH: 11

After this short test, i switched the driver into ad-hoc mode,
setup the essid, channel and assigned an ip address... I tried
to ping, tcpdump, whatsoever... nothing happens. Driver statistics
are also frozen (in monitor mode the rx stats incr.).
The only hints to the problem are:
- this repeating kernel msg:
[...cut...]
[ 3905.535125] WARNING: at /home/wen/work/NokiaN810/compat-wireless-2009-07-09/net/mac80211/sta_info.c:339 sta_info_insert+0x7c/0x15c [mac80211]()
[ 3905.535186] Modules linked in: p54spi p54common mac80211 cfg80211 rfkill_backport
[ 3905.535247] [<c02b73a0>] (dump_stack+0x0/0x14) from [<c00541cc>] (warn_slowpath+0x70/0x8c)
[ 3905.535308] [<c005415c>] (warn_slowpath+0x0/0x8c) from [<bf02af40>] (sta_info_insert+0x7c/0x15c [mac80211])
[ 3905.535522]  r3:00000000 r2:00000000
[ 3905.535552]  r7:c53a4200 r6:c7e65800 r5:0000c0ee r4:c5303b60
[ 3905.535583] [<bf02aec4>] (sta_info_insert+0x0/0x15c [mac80211]) from [<bf02f220>] (ieee80211_ibss_add_sta+0x114/0x130 [mac80211])
[ 3905.535919]  r7:c7d9442e r6:c7e65800 r5:c53a4200 r4:c7e65800
[ 3905.535949] [<bf02f10c>] (ieee80211_ibss_add_sta+0x0/0x130 [mac80211]) from [<bf02f35c>] (ieee80211_rx_bss_info+0x120/0x160 [mac80211])
[ 3905.536407] [<bf02f23c>] (ieee80211_rx_bss_info+0x0/0x160 [mac80211]) from [<bf02f590>] (ieee80211_ibss_rx_queued_mgmt+0x1f4/0x274 [mac80211])
[ 3905.536743] [<bf02f39c>] (ieee80211_ibss_rx_queued_mgmt+0x0/0x274 [mac80211]) from [<bf02f684>] (ieee80211_ibss_work+0x74/0x198 [mac80211])
[ 3905.537048] [<bf02f610>] (ieee80211_ibss_work+0x0/0x198 [mac80211]) from [<c0064318>] (run_workqueue+0xac/0x124)
[ 3905.537261]  r5:c53ac000 r4:c53a7a80
[ 3905.537292] [<c006426c>] (run_workqueue+0x0/0x124) from [<c00649dc>] (worker_thread+0x104/0x118)
[ 3905.537353]  r7:c53a7a88 r6:c53adfa4 r5:c53ac000 r4:c53a7a80
[ 3905.537384] [<c00648d8>] (worker_thread+0x0/0x118) from [<c0067fe4>] (kthread+0x58/0x94)
[ 3905.537475]  r7:00000000 r6:c53a7a80 r5:c00648d8 r4:c53ac000
[ 3905.537506] [<c0067f8c>] (kthread+0x0/0x94) from [<c0057054>] (do_exit+0x0/0x67c)
[ 3905.537567]  r7:00000000 r6:00000000 r5:00000000 r4:00000000
[ 3905.537597] ---[ end trace 09523b411832988b ]---
[...cut...]

- and the fact, that the device is up, but not "running"
# ifconfig wlan0
wlan0     Link encap:Ethernet  HWaddr 00:02:ee:c0:ff:ee
          inet addr:10.0.59.34  Bcast:10.0.59.255  Mask:255.255.255.0
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:550 errors:0 dropped:0 overruns:0 frame:0
          TX packets:18 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:58779 (58.7 KB)  TX bytes:1080 (1.0 KB)

# iwconfig wlan0
wlan0     IEEE 802.11bg  ESSID:"rita"
          Mode:Ad-Hoc  Frequency:2.462 GHz  Cell: 1A:7E:4B:A7:14:45
          Tx-Power=27 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off

If you have any ideas, or patches or infos,
i'll be happy to try these and give some feedback :)

Regards,
AleX

ps: If you need further infos, just let me know...
-- 
**********************************************
Dipl.-Inform. (FH) Alexander Wenzel
Forschungsgesellschaft fuer
Angewandte Naturwissenschaften e. V. (FGAN)
Neuenahrer Str. 20, 53343 Wachtberg, Germany
Tel.  : 0049 (0)228 9435-263
Fax   : 0049 (0)228 9435-685
E-Mail: wenzel@fgan.de
Web   : http://www.fgan.de/
**********************************************
Sitz der Gesellschaft: Bonn
Registergericht: Amtsgericht Bonn VR 2530
Vorstand: Prof. Dr. Maurus Tacke (komm. Vors.)
          Prof. Dr. Joachim Ender (Stellv.)
