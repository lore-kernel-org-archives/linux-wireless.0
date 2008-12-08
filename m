Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:58594 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbYLHHxR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 02:53:17 -0500
Date: Mon, 8 Dec 2008 08:49:04 +0100
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: linux-wireless@vger.kernel.org
Subject: [p54]: oops in p54_rx
Message-ID: <20081208074904.GA28269@roarinelk.homelinux.net> (sfid-20081208_085324_113019_8F07393F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

The following oops occurs when udev loads p54pci driver (device is an early
SM2802W V2 PCI with the isl3886 "softmac" chip;  2.6.28-rc7, firmware
2.13.1.0.arm).  This is transcribed from a rather bad photo (please see
 http://mlau.at/pix/p54oops.jpg ):


BUG: Unable to handle kernel NULL pointer dereference at 0000000000000000
IP: [<ffffffffa0016b66>] p54_rx+0xc6/0x490 [p54common]
PGD 12e433067 PUD 12e46f067 PMD 0
Oops: 0000 [#1] PREEMPT SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0:0/....
CPU 0
Modules linked in: usb_storage ohci1394(+) ieee1394 p54pci(+) p54common ahci...
Pid: 0, comm: swapper Not tainted 2.6.28-rc7-00091-gf6f7b52 #1
RIP: 0010:[<ffffffffa0016b66>]  [<ffffffffa0016b66>] p54_rx+0xc6/0x490 [p54common]
RSP: 0018:ffffffff80ab3df0  EFLAGS: 00010207
RAX: 0000000074e9fed0 RBX: ffff08012e4f1940 RCX: 0000000000002e10
RDX: 0000000000000000 RSI: 00000000000000f1 RDI: ffff80012e4f0000
RBP: ffff80012e077010 R08: ffff80012e077000 R09: ffff80012e04?000
R10: 0000000000000001 R11: ffffffff00221320 R12: ffff80012e4f1900
R13: ffff80012e4f0300 R14: 000000000000732e R15: ffff80012e4f19??

...


(gdb) list *p54_rx+0xc6                                                                                                                                                                                                                      
0x1b66 is in p54_rx (/usr/src/linux-2.6.git/drivers/net/wireless/p54/p54common.c:502).                                                                                                                                                       
497                                                                                                                                                                                                                                          
498             rx_status.signal = p54_rssi_to_dbm(dev, hdr->rssi);                                                                                                                                                                          
499             rx_status.noise = priv->noise;                                                                                                                                                                                               
500             /* XX correct? */                                                                                                                                                                                                            
501             rx_status.qual = (100 * hdr->rssi) / 127;                                                                                                                                                                                    
502             rx_status.rate_idx = (dev->conf.channel->band == IEEE80211_BAND_2GHZ ?                                                                                                                                                       
503                             hdr->rate : (hdr->rate - 4)) & 0xf;                                                                                                                                                                          
504             rx_status.freq = freq;                                                                                                                                                                                                       
505             rx_status.band =  dev->conf.channel->band;                                                                                                                                                                                   
506             rx_status.antenna = hdr->antenna;


...
0x0000000000001b59 <p54_rx+185>:        add    %ecx,%edx
0x0000000000001b5b <p54_rx+187>:        sar    $0x6,%edx
0x0000000000001b5e <p54_rx+190>:        mov    %edx,0x38(%rsp)
0x0000000000001b62 <p54_rx+194>:        mov    0x20(%r13),%rdx
0x0000000000001b66 <p54_rx+198>:        mov    (%rdx),%eax
0x0000000000001b68 <p54_rx+200>:        test   %eax,%eax
0x0000000000001b6a <p54_rx+202>:        je     0x1c70 <p54_rx+464>
0x0000000000001b70 <p54_rx+208>:        movzbl 0x7(%rbp),%eax
0x0000000000001b74 <p54_rx+212>:        sub    $0x4,%eax
0x0000000000001b77 <p54_rx+215>:        and    $0xf,%eax
0x0000000000001b7a <p54_rx+218>:        mov    %eax,0x40(%rsp)
...


Loading the module manually gets a bit further:

p54pci 0000:05:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
p54pci 0000:05:01.0: firmware: requesting isl3886
p54: LM86 firmware
p54: FW rev 2.13.1.0 - Softmac protocol 5.5
phy2: device does not respond!
p54pci 0000:05:01.0: PCI INT A disabled
p54pci: probe of 0000:05:01.0 failed with error -16


Thanks,
	Manuel Lauss
