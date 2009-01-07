Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.179]:53571 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019AbZAGLB3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 06:01:29 -0500
Received: by ik-out-1112.google.com with SMTP id c29so1748914ika.5
        for <linux-wireless@vger.kernel.org>; Wed, 07 Jan 2009 03:01:27 -0800 (PST)
Message-ID: <2d0a357f0901070301ha31f71cma046bdc9590f0e33@mail.gmail.com> (sfid-20090107_120136_798598_E763D437)
Date: Wed, 7 Jan 2009 12:01:27 +0100
From: "Sedat Dilek" <sedat.dilek@googlemail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [wireless-testing] iwl3945: ErrMsgs "MAC is in deep sleep!" and "mac80211-phy0: failed to set key" and unused variables in build-log
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

with wireless-testing master-2009-01-06 I discovered some problems
with iwl3945-driver.

[1] While unloading the driver with modprobe I got the following
error-message "MAC is in deep sleep!":

# modprobe -r -v iwl3945
rmmod /lib/modules/2.6.28-wl-gcc44/kernel/drivers/net/wireless/iwlwifi/iwl3945.ko
rmmod /lib/modules/2.6.28-wl-gcc44/kernel/drivers/net/wireless/iwlwifi/iwlcore.ko
rmmod /lib/modules/2.6.28-wl-gcc44/kernel/net/mac80211/mac80211.ko
rmmod /lib/modules/2.6.28-wl-gcc44/kernel/net/rfkill/rfkill.ko
rmmod /lib/modules/2.6.28-wl-gcc44/kernel/net/wireless/cfg80211.ko

# tail -f /var/log/kern.log
[...]
Jan  7 11:37:58 seduxbox kernel: wlan0: deauthenticating by local
choice (reason=3)
Jan  7 11:37:58 seduxbox kernel: iwl3945 0000:10:00.0: MAC is in deep sleep!
Jan  7 11:37:58 seduxbox kernel: iwl3945 0000:10:00.0: MAC is in deep sleep!
Jan  7 11:37:58 seduxbox kernel: iwl3945 0000:10:00.0: MAC is in deep sleep!
[...]

Q: What does this mean in general "MAC is in deep sleep!"? Has this
something to do with power-management?

[2] Loading the driver with debug-options shows problems with
"mac80211-phy0: failed to set key":

# modprobe iwl3945 debug=0x43fff

# tail -f /var/log/kern.log
[...]
Jan  7 11:39:02 seduxbox kernel: cfg80211: Using static regulatory domain info
Jan  7 11:39:02 seduxbox kernel: cfg80211: Regulatory domain: US
Jan  7 11:39:02 seduxbox kernel: 	(start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
Jan  7 11:39:02 seduxbox kernel: 	(2402000 KHz - 2472000 KHz @ 40000
KHz), (600 mBi, 2700 mBm)
Jan  7 11:39:02 seduxbox kernel: 	(5170000 KHz - 5190000 KHz @ 40000
KHz), (600 mBi, 2300 mBm)
Jan  7 11:39:02 seduxbox kernel: 	(5190000 KHz - 5210000 KHz @ 40000
KHz), (600 mBi, 2300 mBm)
Jan  7 11:39:02 seduxbox kernel: 	(5210000 KHz - 5230000 KHz @ 40000
KHz), (600 mBi, 2300 mBm)
Jan  7 11:39:02 seduxbox kernel: 	(5230000 KHz - 5330000 KHz @ 40000
KHz), (600 mBi, 2300 mBm)
Jan  7 11:39:02 seduxbox kernel: 	(5735000 KHz - 5835000 KHz @ 40000
KHz), (600 mBi, 3000 mBm)
Jan  7 11:39:02 seduxbox kernel: cfg80211: Calling CRDA for country: US
Jan  7 11:39:02 seduxbox kernel: iwl3945: Intel(R) PRO/Wireless
3945ABG/BG Network Connection driver for Linux, 1.2.26ks
Jan  7 11:39:02 seduxbox kernel: iwl3945: Copyright(c) 2003-2008 Intel
Corporation
Jan  7 11:39:02 seduxbox kernel: iwl3945 0000:10:00.0: PCI INT A ->
GSI 17 (level, low) -> IRQ 17
Jan  7 11:39:02 seduxbox kernel: iwl3945 0000:10:00.0: setting latency
timer to 64
Jan  7 11:39:02 seduxbox kernel: iwl3945 0000:10:00.0: Tunable
channels: 13 802.11bg, 23 802.11a channels
Jan  7 11:39:02 seduxbox kernel: iwl3945 0000:10:00.0: Detected Intel
Wireless WiFi Link 3945ABG
Jan  7 11:39:02 seduxbox kernel: phy0: Selected rate control algorithm
'iwl-3945-rs'
Jan  7 11:39:02 seduxbox kernel: iwl3945 0000:10:00.0: PCI INT A ->
GSI 17 (level, low) -> IRQ 17
Jan  7 11:39:02 seduxbox kernel: iwl3945 0000:10:00.0: irq 1274 for MSI/MSI-X
Jan  7 11:39:02 seduxbox kernel: iwl3945 0000:10:00.0: firmware:
requesting iwlwifi-3945-2.ucode
Jan  7 11:39:02 seduxbox kernel: iwl3945 0000:10:00.0: loaded firmware
version 15.28.2.8
Jan  7 11:39:02 seduxbox kernel: Registered led device: iwl-phy0:radio
Jan  7 11:39:02 seduxbox kernel: Registered led device: iwl-phy0:assoc
Jan  7 11:39:02 seduxbox kernel: Registered led device: iwl-phy0:RX
Jan  7 11:39:02 seduxbox kernel: Registered led device: iwl-phy0:TX
Jan  7 11:39:02 seduxbox kernel: ADDRCONF(NETDEV_UP): wlan0: link is not ready
Jan  7 11:39:05 seduxbox kernel: wlan0: authenticate with AP 00:04:0e:e4:00:3d
Jan  7 11:39:05 seduxbox kernel: wlan0: authenticated
Jan  7 11:39:05 seduxbox kernel: wlan0: associate with AP 00:04:0e:e4:00:3d
Jan  7 11:39:05 seduxbox kernel: wlan0: RX AssocResp from
00:04:0e:e4:00:3d (capab=0x411 status=0 aid=1)
Jan  7 11:39:05 seduxbox kernel: wlan0: associated
Jan  7 11:39:05 seduxbox kernel: ADDRCONF(NETDEV_CHANGE): wlan0: link
becomes ready
Jan  7 11:39:06 seduxbox kernel: mac80211-phy0: failed to set key (0,
00:04:0e:e4:00:3d) to hardware (-22)
Jan  7 11:39:06 seduxbox kernel: mac80211-phy0: failed to set key (2,
ff:ff:ff:ff:ff:ff) to hardware (-22)
Jan  7 11:39:16 seduxbox kernel: wlan0: no IPv6 routers present
[...]

[3] Looking into the build-log of master-2009-01-06, I still see some
unused variables:

# zgrep iwl build.log_wireless-testing_master-2009-01-06.gz
  LD      drivers/net/wireless/iwlwifi/built-in.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl3945-base.o
drivers/net/wireless/iwlwifi/iwl3945-base.c: In function
'iwl3945_rx_reply_add_sta':
drivers/net/wireless/iwlwifi/iwl3945-base.c:2759: warning: unused variable 'pkt'
drivers/net/wireless/iwlwifi/iwl3945-base.c: In function
'iwl3945_rx_scan_results_notif':
drivers/net/wireless/iwlwifi/iwl3945-base.c:2914: warning: unused
variable 'notif'
drivers/net/wireless/iwlwifi/iwl3945-base.c: In function
'iwl3945_rx_scan_complete_notif':
drivers/net/wireless/iwlwifi/iwl3945-base.c:2939: warning: unused
variable 'scan_notif'
  CC [M]  drivers/net/wireless/iwlwifi/iwl-3945.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-3945-rs.o
drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function
'iwl3945_rate_scale_flush_windows':
drivers/net/wireless/iwlwifi/iwl-3945-rs.c:186: warning: unused variable 'priv'
drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function
'iwl3945_bg_rate_scale_flush':
drivers/net/wireless/iwlwifi/iwl-3945-rs.c:219: warning: unused variable 'priv'
drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function
'iwl3945_collect_tx_data':
drivers/net/wireless/iwlwifi/iwl-3945-rs.c:293: warning: unused variable 'priv'
drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function 'rs_free_sta':
drivers/net/wireless/iwlwifi/iwl-3945-rs.c:441: warning: unused variable 'priv'
drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function
'iwl3945_get_adjacent_rate':
drivers/net/wireless/iwlwifi/iwl-3945-rs.c:559: warning: unused variable 'priv'
  CC [M]  drivers/net/wireless/iwlwifi/iwl-3945-led.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-agn.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-agn-rs.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-agn-hcmd-check.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-4965.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-5000.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-core.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-eeprom.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-hcmd.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-power.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-rx.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-tx.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-sta.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-calib.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-scan.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-led.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-rfkill.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-spectrum.o
  LD [M]  drivers/net/wireless/iwlwifi/iwlcore.o
  LD [M]  drivers/net/wireless/iwlwifi/iwlagn.o
  LD [M]  drivers/net/wireless/iwlwifi/iwl3945.o
  CC      drivers/net/wireless/iwlwifi/iwl3945.mod.o
  CC      drivers/net/wireless/iwlwifi/iwlagn.mod.o
  CC      drivers/net/wireless/iwlwifi/iwlcore.mod.o
  LD [M]  drivers/net/wireless/iwlwifi/iwl3945.ko
  LD [M]  drivers/net/wireless/iwlwifi/iwlagn.ko
  LD [M]  drivers/net/wireless/iwlwifi/iwlcore.ko
  INSTALL drivers/net/wireless/iwlwifi/iwl3945.ko
  INSTALL drivers/net/wireless/iwlwifi/iwlagn.ko
  INSTALL drivers/net/wireless/iwlwifi/iwlcore.ko

Are these issues known? gcc-4.4-related?

My Internet access is so far OK (see below).
Just reporting - If there is a fix let me know.

Kind Regards,
Sedat

----- BEGIN Additional Informations -----

# dpkg -l | grep linux-image | grep 2.6.28 | grep "\-wl-"
ii  linux-image-2.6.28-wl-gcc44
2.6.28+wl~git20090106.10bc721~dileX+1            Linux kernel binary
image for version 2.6.28-wl-gcc44

# dpkg -l | grep gcc-snapshot
ii  gcc-snapshot                                          20081213-1
                                    A SNAPSHOT of the GNU Compiler
Collection

# /usr/lib/gcc-snapshot/bin/gcc --version
gcc (Debian 20081213-1) 4.4.0 20081212 (experimental) [trunk revision 142725]
Copyright (C) 2008 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

# dpkg -l | grep binutils
ii  binutils                                              2.19-1~exp2
                                    The GNU assembler, linker and
binary utilities

# /usr/bin/ld --version
GNU ld (GNU Binutils for Debian) 2.19
Copyright 2007 Free Software Foundation, Inc.
This program is free software; you may redistribute it under the terms of
the GNU General Public License version 3 or (at your option) a later version.
This program has absolutely no warranty.

# /usr/bin/as --version
GNU assembler (GNU Binutils for Debian) 2.19
Copyright 2007 Free Software Foundation, Inc.
This program is free software; you may redistribute it under the terms of
the GNU General Public License version 3 or later.
This program has absolutely no warranty.
This assembler was configured for a target of `i486-linux-gnu'.

# dpkg -l | grep wpa
ii  wpagui
0.6.6-1+c0.sidux.2                               graphical user
interface for wpa_supplicant
ii  wpasupplicant
0.6.6-1+c0.sidux.2                               client support for
WPA and WPA2 (IEEE 802.11i)

# iwconfig wlan0
wlan0     IEEE 802.11abg  Mode:Managed  Frequency:2.432 GHz
          Access Point: 00:04:0E:E4:00:3D   Bit Rate=1 Mb/s   Tx-Power=15 dBm
          Retry min limit:7   RTS thr:off   Fragment thr=2352 B
          Encryption key:mySecretEncKey [3]   Security mode:open
          Power Management:off
          Link Quality=80/100  Signal level:-54 dBm  Noise level=-127 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

----- END Additional Informations -----
