Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34988 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488Ab2B0QPK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 11:15:10 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1S23E7-0007V9-J1
	for linux-wireless@vger.kernel.org; Mon, 27 Feb 2012 17:15:03 +0100
Received: from c-98-211-27-13.hsd1.tn.comcast.net ([98.211.27.13])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 27 Feb 2012 17:15:03 +0100
Received: from bradhex by c-98-211-27-13.hsd1.tn.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 27 Feb 2012 17:15:03 +0100
To: linux-wireless@vger.kernel.org
From: Chris Thompson <bradhex@gmail.com>
Subject: Problems with Realtek USB rtl8192cu
Date: Mon, 27 Feb 2012 16:09:24 +0000 (UTC)
Message-ID: <loom.20120227T170610-925@post.gmane.org> (sfid-20120227_171516_437241_FE9F8BD7)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I'm attempting to get my belkin n300 to work with the kernel driver rtl8192cu. I 
was previously using the realtek drivers but this only resulted in slow speeds.

I am running kernel 3.2.7 with the following information:

Bus 001 Device 004: ID 050d:2103 Belkin Components  
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x050d Belkin Components
  idProduct          0x2103
  bcdDevice            2.00
  iManufacturer           1 Realtek
  iProduct                2 Belkin Wireless Adapter 
  iSerial                 3 00e04c000001

modinfo rtl8192cu returns this:
filename:       
/lib/modules/3.2.7/kernel/drivers/net/wireless/rtlwifi/rtl8192cu/rtl8192cu.ko
firmware:       rtlwifi/rtl8192cufw.bin
description:    Realtek 8192C/8188C 802.11n USB wireless
license:        GPL
author:         Larry Finger    <Larry.Finger@lwfinger.net>
author:         Ziv Huang       <ziv_huang@realtek.com>
author:         Georgia         <georgia@realtek.com>

alias:          usb:v7392p7822d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v2019pAB2Bd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v2001p330Ad*dc*dsc*dp*ic*isc*ip*
alias:          usb:v2001p3309d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v2001p3307d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v07B8p8178d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v07AAp0056d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0586p341Fd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v9846p9041d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v4855p0091d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v4855p0090d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v13D3p3359d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v13D3p3358d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v7392p7811d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v20F4p648Bd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v2019pED17d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v2019pAB2Ad*dc*dsc*dp*ic*isc*ip*
alias:          usb:v2001p3308d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v13D3p3357d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v103Cp1629d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0EB0p9071d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0DF6p0052d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0846p9041d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v07B8p8189d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v07B8p8188d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v06F8pE033d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v050Dp1102d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp817Cd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp817Bd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp8177d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp8754d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp817Fd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp817Ed*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp817Dd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp817Bd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp817Ad*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp8177d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp8176d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp8170d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp8191d*dc*dsc*dp*ic*isc*ip*
depends:        rtlwifi,mac80211,rtl8192c-common
intree:         Y
vermagic:       3.2.7 SMP preempt mod_unload 586
parm:           swenc:Set to 1 for software crypto (default 0)
 (bool)
parm:           debug:Set debug level (0-5) (default 0) (int)


ls -l /lib/firmware/rtlwifi:
total 16
-rwxr-xr-x 1 root root 16014 Feb 22 15:54 rtl8192cufw.bin

I have also ran md5checksum on the firmware file, it came back fine.

When I run modprobe rtl8192cu, this is what dmesg reports:

[ 1378.073848] usbcore: registered new interface driver rtl8192cu

Nothing else. This is what lsmod returns:

Module                  Size  Used by
rtl8192cu              86266  0
rtl8192c_common        53218  1 rtl8192cu
rtlwifi                81918  1 rtl8192cu
mac80211              165677  3 rtl8192cu,rtl8192c_common,rtlwifi
cfg80211              141272  2 rtlwifi,mac80211



What should I try next to get this module working? I hope I have given enough 
information on trying to troubleshoot this.


Thank you.


