Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:37509 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519AbZG2LaG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 07:30:06 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1MW7MB-0004nb-F6
	for linux-wireless@vger.kernel.org; Wed, 29 Jul 2009 11:30:03 +0000
Received: from dslb-084-058-206-191.pools.arcor-ip.net ([84.58.206.191])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2009 11:30:03 +0000
Received: from acid-burn by dslb-084-058-206-191.pools.arcor-ip.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2009 11:30:03 +0000
To: linux-wireless@vger.kernel.org
From: Mladen Horvat <acid-burn@opendreambox.org>
Subject: zd1211rw couldn't load firmware. Error number -145 with Kernel 2.6.30
Date: Wed, 29 Jul 2009 11:28:30 +0000 (UTC)
Message-ID: <loom.20090729T111851-320@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,

i am running Kernel 2.6.30 on a embedded linux stb and trying with two
different zd1211b usb wlan sticks to get the zd1211rw driver running.

just as a remark:  an rt73usb stick works without problems.

Dont know what you need. so here is some informations:

uname -a
Linux dm7025 2.6.30-dm7025 #1 Tue Jul 28 20:25:28 CEST 2009 mips unknown

lsmod
    Tainted: P
arc4 1536 2 - Live 0xc05c5000
ecb 2880 2 - Live 0xc05bc000
cryptomgr 87872 0 - Live 0xc059d000
crypto_hash 11840 1 cryptomgr, Live 0xc057a000
crypto_blkcipher 13232 2 ecb,cryptomgr, Live 0xc056c000
aead 7168 1 cryptomgr, Live 0xc0560000
pcompress 1952 1 cryptomgr, Live 0xc0558000
crypto_algapi 18176 7
arc4,ecb,cryptomgr,crypto_hash,crypto_blkcipher,aead,pcompress, Live 0xc054a000
zd1211rw 78736 0 - Live 0xc0527000
mac80211 174976 1 zd1211rw, Live 0xc04d6000
crypto 13360 8
ecb,cryptomgr,crypto_hash,crypto_blkcipher,aead,pcompress,crypto_algapi,
mac80211, Live
0xc048c000
cfg80211 79216 2 zd1211rw,mac80211, Live 0xc046e000
rfmod 3808 1 - Live 0xc0448000 (P)
dreambox_keyboard 5248 0 - Live 0xc043d000 (P)
dreambox_rc2 5248 1 dreambox_keyboard, Live 0xc0431000 (P)
xilleon 222592 6 - Live 0xc0185000 (P)
alps_bsbe1_c01a 19568 1 xilleon, Live 0xc0132000 (P)
alps_bsbe1 5264 1 xilleon, Live 0xc0124000 (P)
avs 11168 1 xilleon, Live 0xc0117000 (P)
alps_bsbe2 44480 1 xilleon, Live 0xc0103000 (P)
lnb_ctrl 5664 3 alps_bsbe1_c01a,alps_bsbe1,alps_bsbe2, Live 0xc00f0000 (P)
tu1216 44912 1 xilleon, Live 0xc00de000
cu1216mk3 9504 1 xilleon, Live 0xc00c9000 (P)
stb_core 52704 10
dreambox_keyboard,dreambox_rc2,xilleon,alps_bsbe1_c01a,avs,alps_bsbe2,
lnb_ctrl,cu1216mk3,
Live 0xc00b1000 (P)
pata_xilleon 3888 1 - Live 0xc0095000
lcd 30800 1 - Live 0xc0084000 (P)
fp 21840 4 xilleon,avs,lcd, Live 0xc0072000 (P)


Output from DMESG:
[  279.131000] cfg80211: Calling CRDA to update world regulatory domain
[  279.509000] zd1211rw usb_init()
[  279.520000] usbcore: registered new interface driver zd1211rw
[  279.526000] zd1211rw initialized
[  292.405000] usb 1-1: new full speed USB device using ohci_hcd
 and address 2
[  292.557000] usb 1-1: configuration #1 chosen from 1 choice
[  292.573000] usb 1-1: print_id() 050d:705c v4810 full
[  292.686000] usb 1-1: reset full speed USB device using ohci_hcd 
and address 2
[  292.829000] zd1211rw 1-1:1.0: zd_chip_read_mac_addr_fw()
[  293.308000] phy0: Selected rate control algorithm 'pid'
[  293.309000] zd1211rw 1-1:1.0: probe() successful
[  293.309000] zd1211rw 1-1:1.0: phy0
[  359.661000] warning: `vsftpd' uses 32-bit capabilities (legacy support in use)
[  408.957000] zd1211rw 1-1:1.0: zd_usb_init_hw()
[  408.957000] usb 1-1: request_fw_file() fw name zd1211/zd1211b_ub
[  408.957000] usb 1-1: firmware: requesting zd1211/zd1211b_ub
[  409.022000] usb 1-1: upload_firmware() firmware device id 0x4810 is equal 
to
the actual device id
[  409.022000] usb 1-1: request_fw_file() fw name zd1211/zd1211b_uphr
[  409.022000] usb 1-1: firmware: requesting zd1211/zd1211b_uphr
[  409.079000] usb 1-1: upload_code() transfer size 4018
[  409.094000] usb 1-1: upload_code() firmware confirm return value 0x01
[  414.094000] zd1211rw 1-1:1.0: zd_usb_init_hw() 
couldn't reset configuration. Error number -145
[  415.226000] zd1211rw 1-1:1.0: zd_usb_init_hw()
[  415.226000] usb 1-1: request_fw_file() fw name zd1211/zd1211b_ub
[  415.226000] usb 1-1: firmware: requesting zd1211/zd1211b_ub
[  415.271000] usb 1-1: upload_firmware() 
firmware device id 0x4810 is equal to the actual device id
[  415.271000] usb 1-1: request_fw_file() fw name zd1211/zd1211b_uphr
[  415.271000] usb 1-1: firmware: requesting zd1211/zd1211b_uphr
[  415.350000] usb 1-1: upload_code() transfer size 4018
[  416.350000] usb 1-1: USB control request for firmware upload failed.
Error number -145
[  416.358000] usb 1-1: Could not upload firmware code uph. Error number -145
[  416.365000] zd1211rw 1-1:1.0: couldn't load firmware. Error number -145
[  432.484000] zd1211rw 1-1:1.0: zd_usb_init_hw()
[  432.484000] usb 1-1: request_fw_file() fw name zd1211/zd1211b_ub
[  432.484000] usb 1-1: firmware: requesting zd1211/zd1211b_ub
[  432.529000] usb 1-1: upload_firmware() 
firmware device id 0x4810 is equal to the actual device id
[  432.529000] usb 1-1: request_fw_file() fw name zd1211/zd1211b_uphr
[  432.529000] usb 1-1: firmware: requesting zd1211/zd1211b_uphr
[  432.608000] usb 1-1: upload_code() transfer size 4018
[  433.608000] usb 1-1: USB control request for firmware upload failed. 
Error number -145
[  433.616000] usb 1-1: Could not upload firmware code uph. Error number -145
[  433.623000] zd1211rw 1-1:1.0: couldn't load firmware. Error number -145
[  434.827000] eth0: link up, 100Mbps, full-duplex, lpa 0xC5E1

output from lsusb
Bus 001 Device 002: ID 050d:705c Belkin Components

the Firmware Files are located with correct right under /lib/firmware/zd1211
any idea on this ?

Regards

Mladen

