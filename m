Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:43922 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751605AbeEDTU7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 May 2018 15:20:59 -0400
Date: Fri, 4 May 2018 21:20:57 +0200
From: =?UTF-8?B?TXlsw6huZQ==?= Josserand <mylene.josserand@bootlin.com>
To: linux-wireless@vger.kernel.org
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        =?UTF-8?B?TXlsw6hu?= =?UTF-8?B?ZQ==?= Josserand
        <mylene.josserand@bootlin.com>
Subject: rtl8188eu: link is not ready error on lm816
Message-ID: <20180504212057.2edaa658@dell-desktop.home> (sfid-20180504_212103_624087_DEDE1081)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello everyone,

I am currently testing a USB Wifi dongle LM816 [1] on a custom platform
based on an IMX6.

My configuration:
	kernel from mainline: v4.14
	driver: staging R8188EU
	firmware: rtl8188eu from linux-firmware, last commit
	a3a26af24e29c818ef9b5661856018e21a5c49fb

When I tried to set the wlan interface up, it says that "link is not
ready" and that's all. Because of that, it fails to scan available
networks.

Here are commands used and their output:

# dmesg
[...]
[   14.690152] r8188eu: module is from the staging directory, the
quality is unknown, you have been warned. 
[   14.703105] Chip Version
Info: CHIP_8188E_Normal_Chip_TSMC_D_CUT_1T1R_RomVer(0)
[...]

# lsusb
Bus 002 Device 004: ID 0bda:8179  <-- LM816
Bus 002 Device 003: ID 0424:9e00  
Bus 002 Device 002: ID 0424:2517  
Bus 002 Device 001: ID 1d6b:0002  
Bus 001 Device 001: ID 1d6b:0002  

# lsmod
Module                  Size  Used by    Tainted: G  
dw_hdmi_ahb_audio      16384  0 
r8188eu               401408  0 
coda                   61440  0 
imx_vdoa               16384  1 coda
v4l2_mem2mem           24576  1 coda
videobuf2_vmalloc      16384  1 coda
evbug                  16384  0 

# ifconfig wlan0 up
[  447.639524] MAC Address = 5c:f3:70:3d:5c:71
[  447.653636] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
# 
# 
# iw wlan0 scan
command failed: No such device (-19)


Does anyone already have this issue with this dongle? 
If it is not the case, what is your setup? Which firmware? Which driver?
Any help will be very appreciated.

Thanks in advance,
Best regards,

[1]:
https://www.lm-technologies.com/product/wifi-usb-nano-adapter-150mbps-lm816/

-- 
Mylène Josserand, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
http://bootlin.com
