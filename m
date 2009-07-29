Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:41684 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbZG2KZT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 06:25:19 -0400
Received: by vs166246.vserver.de with esmtpa (Exim 4.69)
	id 1MW6LV-0004Eh-P2
	for linux-wireless@vger.kernel.org; Wed, 29 Jul 2009 10:25:18 +0000
From: Michael Buesch <mb@bu3sch.de>
To: linux-wireless@vger.kernel.org
Subject: Pulling rt73 USB stick oopses the kernel
Date: Wed, 29 Jul 2009 12:24:37 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200907291224.37562.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pulling a rt73 USB stick in operation (packets were injected into the monitor)
does oops the kernel as follows:

[  630.304883] rt73usb 2-6:1.0: firmware: requesting rt73.bin
[  630.417740] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  700.489876] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  743.571488] device wlan1 entered promiscuous mode
[  829.207708] usb 2-6: USB disconnect, address 4
[  829.208272] phy1 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x3040 with error -19.
[  829.208355] phy1 -> rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed for offset 0x3040 with error -19.
[  829.208436] phy1 -> rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed for offset 0x3028 with error -19.
[  829.208516] phy1 -> rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed for offset 0x3064 with error -19.
[  829.208595] phy1 -> rt2x00usb_vendor_request: Error - Vendor Request 0x0c failed for offset 0x0000 with error -19.
[  829.208687] phy1 -> rt2x00usb_vendor_request: Error - Vendor Request 0x0a failed for offset 0x0000 with error -19.
[  829.209622] phy1 -> rt2x00usb_vendor_request: Error - Vendor Request 0x0a failed for offset 0x0000 with error -19.
[  829.209832] phy1 -> rt2x00usb_vendor_request: Error - Vendor Request 0x0a failed for offset 0x0000 with error -19.
[  829.210187] phy1 -> rt2x00usb_vendor_request: Error - Vendor Request 0x0a failed for offset 0x0000 with error -19.
[  829.223337] phy1 -> rt2x00usb_vendor_request: Error - Vendor Request 0x07 failed for offset 0x3040 with error -19.
[  829.223424] phy1 -> rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed for offset 0x3040 with error -19.
[  829.269467] =============================================================================
[  829.269554] BUG kmalloc-16: Redzone overwritten
[  829.269615] -----------------------------------------------------------------------------
[  829.269618] 
[  829.269746] INFO: 0xf56c4b50-0xf56c4b53. First byte 0xb instead of 0xcc
[  829.269821] INFO: Allocated in rt2x00usb_probe+0xb5/0x1c1 [rt2x00usb] age=104615 cpu=0 pid=3965
[  829.269902] INFO: Slab 0xc20bc880 objects=64 used=53 fp=0xf56c4b80 flags=0x40000083
[  829.269940] INFO: Object 0xf56c4b40 @offset=2880 fp=0xf56c4b80
[  829.269940] 
[  829.269940] Bytes b4 0xf56c4b30:  00 00 00 00 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a ........ZZZZZZZZ
[  829.269940]   Object 0xf56c4b40:  00 00 00 00 0c 2c 00 00 86 07 00 00 51 a2 06 00 .....,......Q¢..
[  829.269940]  Redzone 0xf56c4b50:  0b 2a 0d 00                                     .*..            
[  829.269940]  Padding 0xf56c4b78:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
[  829.269940] Pid: 810, comm: khubd Not tainted 2.6.31-rc4-wl #2
[  829.269940] Call Trace:
[  829.269940]  [<c10bff6b>] print_trailer+0xd3/0x108
[  829.269940]  [<c10c0066>] check_bytes_and_report+0xc6/0xe3
[  829.269940]  [<c10c010f>] check_object+0x53/0x1ea
[  829.269940]  [<c10c1d28>] __slab_free+0x1e7/0x2c8
[  829.269940]  [<c10c2120>] kfree+0xc9/0x137
[  829.269940]  [<f86fb05f>] ? rt2x00usb_free_reg+0x11/0x48 [rt2x00usb]
[  829.269940]  [<f86fb05f>] ? rt2x00usb_free_reg+0x11/0x48 [rt2x00usb]
[  829.269940]  [<f86fb05f>] rt2x00usb_free_reg+0x11/0x48 [rt2x00usb]
[  829.269940]  [<f86fb0b5>] rt2x00usb_disconnect+0x1f/0x40 [rt2x00usb]
[  829.269940]  [<f8063357>] usb_unbind_interface+0xdf/0x116 [usbcore]
[  829.269940]  [<c11f7247>] __device_release_driver+0x53/0x96
[  829.269940]  [<c11f732a>] device_release_driver+0x18/0x23
[  829.269940]  [<c11f6992>] bus_remove_device+0x70/0x94
[  829.269940]  [<c11f4fff>] device_del+0x103/0x186
[  829.269940]  [<f8060462>] usb_disable_device+0x79/0xe4 [usbcore]
[  829.269940]  [<f805b69f>] usb_disconnect+0x8a/0xee [usbcore]
[  829.269940]  [<f805c804>] hub_thread+0x691/0x125d [usbcore]
[  829.269940]  [<c1020100>] ? chk_conflict+0x13e/0x16c
[  829.269940]  [<c12dbdab>] ? _spin_unlock_irqrestore+0x39/0x68
[  829.269940]  [<c1057cdb>] ? trace_hardirqs_on_caller+0x102/0x146
[  829.269940]  [<c1047699>] ? autoremove_wake_function+0x0/0x3a
[  829.269940]  [<f805c173>] ? hub_thread+0x0/0x125d [usbcore]
[  829.269940]  [<c104738c>] kthread+0x6f/0x75
[  829.269940]  [<c104731d>] ? kthread+0x0/0x75
[  829.269940]  [<c1003977>] kernel_thread_helper+0x7/0x1a
[  829.269940] FIX kmalloc-16: Restoring 0xf56c4b50-0xf56c4b53=0xcc

-- 
Greetings, Michael.
