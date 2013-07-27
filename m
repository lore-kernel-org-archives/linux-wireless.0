Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from brisi.sourcepole.ch ([5.9.57.43]:33656 "EHLO
	brisi.sourcepole.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab3G0Obx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Jul 2013 10:31:53 -0400
Received: from cable-dynamic-87-245-83-117.shinternet.ch ([87.245.83.117] helo=[192.168.2.35])
	by vilan-mail with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <tpo2@sourcepole.ch>)
	id 1V34ol-0005Pe-I3
	for linux-wireless@vger.kernel.org; Sat, 27 Jul 2013 15:45:55 +0200
Message-ID: <51F3CEF7.4030200@sourcepole.ch> (sfid-20130727_163157_239174_6DBD158E)
Date: Sat, 27 Jul 2013 15:45:27 +0200
From: Tomas Pospisek <tpo2@sourcepole.ch>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: unable to unblock Bluetooth
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello

I am not able to unblock Bluetooth:

# rfkill unblock all
# rfkill list 4
4: hp-bluetooth: Bluetooth
         Soft blocked: yes
         Hard blocked: no

The Bluetooth layer remains "Soft blocked".

My system looks like this:

- Linux: 3.11-rc1
- Userspace: Debian wheezy
- rfkill: 0.5
- HW: HP dv7 6130ez
- Bluetooth probably provided by:
  # lspci
  ...
  0d:00.0 Network controller: Ralink corp. RT5390
 [802.11 b/g/n 1T1R G-band PCI Express Single Chip]

Kernel logs show no trace of a problem:

  Bluetooth: Core ver 2.16
  Bluetooth: HCI device and connection manager initialized
  Bluetooth: HCI socket layer initialized
  Bluetooth: L2CAP socket layer initialized
  Bluetooth: SCO socket layer initialized
  Bluetooth: RFCOMM TTY layer initialized
  Bluetooth: RFCOMM socket layer initialized
  Bluetooth: RFCOMM ver 1.11
  Bluetooth: BNEP (Ethernet Emulation) ver 1.3
  Bluetooth: BNEP filters: protocol multicast
  Bluetooth: BNEP socket layer initialized

I had to provide some firware in order for the Bluetooth device to show
up in rfkill. I copied those firmware blobs over from Debian's
"firmware-ralink" package. It must be one of these:

rt2661.bin
rtl_nic
rtl_nic/rtl8168f-1.fw
rtl_nic/rtl8168e-1.fw
rtl_nic/rtl8168f-2.fw
rtl_nic/rtl8168e-3.fw
rtl_nic/rtl8168d-2.fw
rtl_nic/rtl8168e-2.fw
rtl_nic/rtl8105e-1.fw
rtl_nic/rtl8168d-1.fw
RTL8192SU
RTL8192SU/rtl8192sfw.bin
rt2561.bin
rt2870.bin
rt2860.bin
rt73.bin
rt3070.bin
rtlwifi
rtlwifi/rtl8192cufw.bin
rtlwifi/rtl8192cfwU.bin
rtlwifi/rtl8192cfw.bin
rtlwifi/rtl8192cfwU_B.bin
rtlwifi/rtl8192sefw.bin
rtlwifi/rtl8192defw.bin
rtlwifi/rtl8712u.bin
rt3071.bin
rt3090.bin
rt2561s.bin
RTL8192E
RTL8192E/main.img
RTL8192E/boot.img
RTL8192E/data.img

Additional possibly useful info:

  # lsmod |grep blue
  bluetooth             169854  10 bnep,rfcomm
  rfkill                 19242  6 cfg80211,hp_wmi,bluetooth
  crc16                  12343  2 ext4,bluetooth

What can I do to unblock the Bluetooth?

Thank you,
*t
