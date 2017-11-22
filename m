Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:40016 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751480AbdKVJv3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Nov 2017 04:51:29 -0500
Date: Wed, 22 Nov 2017 10:51:16 +0100
From: Mylene JOSSERAND <mylene.josserand@free-electrons.com>
To: Jes.Sorensen@gmail.com
Cc: kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Wifi RTL8723bu driver test: failed to scan
Message-ID: <20171122105116.57c3c000@dell-desktop.home> (sfid-20171122_105133_895290_D38C90EC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Jes Sorensen,

I am currently testing a LM811 Wifi/BT USB dongle [1] on a Sinlinx
SinA33 Allwinner SoC board [2]. I saw that I should use the realtek
driver RTL8723BU for this USB dongle.

Currently, I am only testing the Wifi and the mainline driver (kernel
4.14-rc7) does not seem to work. At least, the scanning does not output
anything.

I tested the driver recommended by LM Technologies [3] and it works
fine (scan, connect and ping are ok). Before investigating on the
differences between these two drivers, do you have any idea about this
issue?

Here are the commands and output I got with mainline's driver:

# lsusb
Bus 001 Device 001: ID 1d6b:0002
Bus 001 Device 003: ID 0bda:b720
Bus 001 Device 002: ID 05e3:0608
Bus 002 Device 001: ID 1d6b:0001
Bus 001 Device 004: ID 0bda:8152
#
# modprobe rtl8xxxu
[   46.785896] usb 1-1.1: This Realtek USB WiFi dongle (0x0bda:0xb720)
is untested! 
[   46.802122] usb 1-1.1: Please report results to
Jes.Sorensen@gmail.com 
[   46.980269] usb 1-1.1: Vendor: Realtek
[   46.988641] usb 1-1.1: Product: 802.11n WLAN Adapter
[   46.998182] usb 1-1.1: rtl8723bu_parse_efuse: dumping efuse (0x200
bytes): 
[   47.014106] usb 1-1.1: 00: 29 81 03 7c 01 08 21 00
[   47.023527] usb 1-1.1: 08: 40 07 05 35 10 00 00 00
[   47.032888] usb 1-1.1: 10: 2c 2c 2c 2c 2c 2c 2b 2b
[   47.042197] usb 1-1.1: 18: 2b 2b 2b f4 ff ff ff ff
[   47.051442] usb 1-1.1: 20: ff ff ff ff ff ff ff ff
[   47.060608] usb 1-1.1: 28: ff ff ff ff ff ff ff ff
[   47.069672] usb 1-1.1: 30: ff ff ff ff ff ff ff ff
[   47.078679] usb 1-1.1: 38: ff ff 2d 2d 2d 2d 2d 2d
[   47.087599] usb 1-1.1: 40: 2d 2d 2d 2d 2d 03 ff ff
[   47.096539] usb 1-1.1: 48: ff ff ff ff ff ff ff ff
[   47.105489] usb 1-1.1: 50: ff ff ff ff ff ff ff ff
[   47.114418] usb 1-1.1: 58: ff ff ff ff ff ff ff ff
[   47.123322] usb 1-1.1: 60: ff ff ff ff ff ff ff ff
[   47.132238] usb 1-1.1: 68: ff ff ff ff ff ff ff ff
[   47.141059] usb 1-1.1: 70: ff ff ff ff ff ff ff ff
[   47.149810] usb 1-1.1: 78: ff ff ff ff ff ff ff ff
[   47.158479] usb 1-1.1: 80: ff ff ff ff ff ff ff ff
[   47.167107] usb 1-1.1: 88: ff ff ff ff ff ff ff ff
[   47.175651] usb 1-1.1: 90: ff ff ff ff ff ff ff ff
[   47.184102] usb 1-1.1: 98: ff ff ff ff ff ff ff ff
[   47.192463] usb 1-1.1: a0: ff ff ff ff ff ff ff ff
[   47.200728] usb 1-1.1: a8: ff ff ff ff ff ff ff ff
[   47.208943] usb 1-1.1: b0: ff ff ff ff ff ff ff ff
[   47.217053] usb 1-1.1: b8: 20 1e 20 00 00 00 ff ff
[   47.225146] usb 1-1.1: c0: ff 28 20 11 00 00 00 ff
[   47.233169] usb 1-1.1: c8: 00 ff ff ff ff ff ff ff
[   47.241140] usb 1-1.1: d0: ff ff ff ff ff ff ff ff
[   47.249009] usb 1-1.1: d8: ff ff ff ff ff ff ff ff
[   47.256776] usb 1-1.1: e0: ff ff ff ff ff ff ff ff
[   47.264481] usb 1-1.1: e8: ff ff ff ff ff ff ff ff
[   47.272098] usb 1-1.1: f0: ff ff ff ff ff ff ff ff
[   47.279619] usb 1-1.1: f8: ff ff ff ff ff ff ff ff
[   47.287029] usb 1-1.1: 100: da 0b 20 b7 e7 47 03 5c
[   47.294503] usb 1-1.1: 108: f3 70 32 1d c2 09 03 52
[   47.301934] usb 1-1.1: 110: 65 61 6c 74 65 6b 16 03
[   47.309294] usb 1-1.1: 118: 38 30 32 2e 31 31 6e 20
[   47.316579] usb 1-1.1: 120: 57 4c 41 4e 20 41 64 61
[   47.323811] usb 1-1.1: 128: 70 74 65 72 00 ff ff ff
[   47.331045] usb 1-1.1: 130: ff ff ff ff ff ff ff ff
[   47.338222] usb 1-1.1: 138: ff ff ff ff ff ff ff ff
[   47.345335] usb 1-1.1: 140: ff ff ff ff ff ff ff 0f
[   47.352364] usb 1-1.1: 148: ff ff ff ff ff ff ff ff
[   47.359299] usb 1-1.1: 150: ff ff ff ff ff ff ff ff
[   47.366135] usb 1-1.1: 158: ff ff ff ff ff ff ff ff
[   47.372882] usb 1-1.1: 160: ff ff ff ff ff ff ff ff
[   47.379541] usb 1-1.1: 168: ff ff ff ff ff ff ff ff
[   47.386117] usb 1-1.1: 170: ff ff ff ff ff ff ff ff
[   47.392664] usb 1-1.1: 178: ff ff ff ff ff ff ff ff
[   47.399154] usb 1-1.1: 180: ff ff ff ff ff ff ff ff
[   47.405530] usb 1-1.1: 188: ff ff ff ff ff ff ff ff
[   47.411846] usb 1-1.1: 190: ff ff ff ff ff ff ff ff
[   47.418125] usb 1-1.1: 198: ff ff ff ff ff ff ff ff
[   47.424365] usb 1-1.1: 1a0: ff ff ff ff ff ff ff ff
[   47.430587] usb 1-1.1: 1a8: ff ff ff ff ff ff ff ff
[   47.436769] usb 1-1.1: 1b0: ff ff ff ff ff ff ff ff
[   47.442967] usb 1-1.1: 1b8: ff ff ff ff ff ff ff ff
[   47.449168] usb 1-1.1: 1c0: ff ff ff ff ff ff ff ff
[   47.455323] usb 1-1.1: 1c8: ff ff ff ff ff ff ff ff
[   47.461471] usb 1-1.1: 1d0: ff ff ff ff ff ff ff ff
[   47.467592] usb 1-1.1: 1d8: ff ff ff ff ff ff ff ff
[   47.473713] usb 1-1.1: 1e0: ff ff ff ff ff ff ff ff
[   47.479841] usb 1-1.1: 1e8: ff ff ff ff ff ff ff ff
[   47.485942] usb 1-1.1: 1f0: ff ff ff ff ff ff ff ff
[   47.492062] usb 1-1.1: 1f8: ff ff ff ff ff ff ff ff
[   47.498173] usb 1-1.1: RTL8723BU rev E (SMIC) 1T1R, TX queues 3,
WiFi=1, BT=1, GPS=0, HI PA=0 
[   47.509357] usb 1-1.1: RTL8723BU MAC:5c:f3:70:32:1d:c2 
[   47.516057] usb 1-1.1: rtl8xxxu: Loading firmware
rtlwifi/rtl8723bu_nic.bin
[   47.532111] usb 1-1.1: Firmware revision 35.0 (signature 0x5301)
[   48.531644] usbcore: registered new interface driver rtl8xxxu 
# 
# 
# ifconfig wlan0 up
[   53.922338] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
#
# iw wlan0 scan
#
# iw wlan0 info
Interface wlan0
	ifindex 4
	wdev 0x1
	addr 5c:f3:70:32:1d:c2
	type managed
	wiphy 0
	txpower 20.00 dBm

If you need more tests/information, do not hesitate to ask me.

Thank you in advance for any help/hints!

[1]:
https://www.lm-technologies.com/product/wifi-and-bluetooth-usb-module-4-0-dual-mode-class-1-lm811/
[2]: http://www.sinlinx.com/sina33.html
[3]: https://wiki.lm-technologies.com/lm811-linux-driver-installation/

Best regards,

-- 
Mylène Josserand, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
