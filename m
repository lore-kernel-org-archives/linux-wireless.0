Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:40251 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbYLHNaG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 08:30:06 -0500
Date: Mon, 8 Dec 2008 14:26:03 +0100
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [p54]: oops in p54_rx
Message-ID: <20081208132603.GA4221@roarinelk.homelinux.net> (sfid-20081208_143011_161673_F647E2D1)
References: <20081208074904.GA28269@roarinelk.homelinux.net> <200812081408.36621.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200812081408.36621.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hallo Christian,

On Mon, Dec 08, 2008 at 02:08:36PM +0100, Christian Lamparter wrote:
> On Monday 08 December 2008 08:49:04 Manuel Lauss wrote:
> > Hello,
> 
> Hello!
> 
> > The following oops occurs when udev loads p54pci driver (device is an early
> > SM2802W V2 PCI with the isl3886 "softmac" chip;  2.6.28-rc7, firmware
> > 2.13.1.0.arm).  This is transcribed from a rather bad photo (please see
> >  http://mlau.at/pix/p54oops.jpg ):
> > 
> > BUG: Unable to handle kernel NULL pointer dereference at 0000000000000000
> > IP: [<ffffffffa0016b66>] p54_rx+0xc6/0x490 [p54common]
> > PGD 12e433067 PUD 12e46f067 PMD 0
> > Oops: 0000 [#1] PREEMPT SMP
> > last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0:0/....
> > CPU 0
> > Modules linked in: usb_storage ohci1394(+) ieee1394 p54pci(+) p54common ahci...
> > Pid: 0, comm: swapper Not tainted 2.6.28-rc7-00091-gf6f7b52 #1
> > RIP: 0010:[<ffffffffa0016b66>]  [<ffffffffa0016b66>] p54_rx+0xc6/0x490 [p54common]
> > RSP: 0018:ffffffff80ab3df0  EFLAGS: 00010207
> > RAX: 0000000074e9fed0 RBX: ffff08012e4f1940 RCX: 0000000000002e10
> > RDX: 0000000000000000 RSI: 00000000000000f1 RDI: ffff80012e4f0000
> > RBP: ffff80012e077010 R08: ffff80012e077000 R09: ffff80012e04?000
> > R10: 0000000000000001 R11: ffffffff00221320 R12: ffff80012e4f1900
> > R13: ffff80012e4f0300 R14: 000000000000732e R15: ffff80012e4f19??
> > 
> > (gdb) list *p54_rx+0xc6                                                                                                                                                                                                                      
> > 0x1b66 is in p54_rx (/usr/src/linux-2.6.git/drivers/net/wireless/p54/p54common.c:502).                                                                                                                                                       
> > 497                                                                                                                                                                                                                                          
> > 498             rx_status.signal = p54_rssi_to_dbm(dev, hdr->rssi);                                                                                                                                                                          
> > 499             rx_status.noise = priv->noise;                                                                                                                                                                                               
> > 500             /* XX correct? */                                                                                                                                                                                                            
> > 501             rx_status.qual = (100 * hdr->rssi) / 127;                                                                                                                                                                                    
> > 502             rx_status.rate_idx = (dev->conf.channel->band == IEEE80211_BAND_2GHZ ?                                                                                                                                                       
> > 503                             hdr->rate : (hdr->rate - 4)) & 0xf;                                                                                                                                                                          
> That's right, dev->conf.channel isn't set at the time we're reading the eeprom.
> But, then we didn't initialize the radio, dcf and mac/bb yet, so where did the data frames came
> from?

Booted firmware in need of attention? ;-)  The other device on irq 17 is
a jmicron pata controller with no disks attached.

One more datapoint: this oops only seems to occur if udev loads p54 _and_
firmware is present.  Without firmware the driver (obviously) does nothing
an later I can happily modprobe/rmmod it when firmware is in place without
incident (with the timeout error below).

  
> > Loading the module manually gets a bit further:
> > 
> > p54pci 0000:05:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> > p54pci 0000:05:01.0: firmware: requesting isl3886
> > p54: LM86 firmware
> > p54: FW rev 2.13.1.0 - Softmac protocol 5.5
> > phy2: device does not respond!
> --- no, this time it just doesn't respond at all => crashed
> > p54pci 0000:05:01.0: PCI INT A disabled
> > p54pci: probe of 0000:05:01.0 failed with error -16
> 
> Did it work with an older firmware? (and then which one?)
> Or do you have >= 4GB Ram/iommu etc.?

Only tried the suggested 2.13.1.0 firmware from the p54 wiki.  Reloading
p54pci with the lmac_2.7.0.0 firmware hard-hangs the machine (no net, no
sysrq-b).  Machine is Intel P35-based with 4GB ram.

Thank you,
	Manuel Lauss
