Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:49923 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbYLHOsb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 09:48:31 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Manuel Lauss <mano@roarinelk.homelinux.net>
Subject: Re: [p54]: oops in p54_rx
Date: Mon, 8 Dec 2008 15:48:32 +0100
Cc: linux-wireless@vger.kernel.org
References: <20081208074904.GA28269@roarinelk.homelinux.net> <20081208132603.GA4221@roarinelk.homelinux.net> <200812081509.43402.chunkeey@web.de>
In-Reply-To: <200812081509.43402.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_APTPJ3fpWdAki0D"
Message-Id: <200812081548.32362.chunkeey@web.de> (sfid-20081208_154835_702267_FAE8A0C0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_APTPJ3fpWdAki0D
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 08 December 2008 15:09:43 Christian Lamparter wrote:
> On Monday 08 December 2008 14:26:03 Manuel Lauss wrote:
> > Hallo Christian,
> > 
> > On Mon, Dec 08, 2008 at 02:08:36PM +0100, Christian Lamparter wrote:
> > > On Monday 08 December 2008 08:49:04 Manuel Lauss wrote:
> > > > Hello,
> > > 
> > > Hello!
> > > 
> > > > The following oops occurs when udev loads p54pci driver (device is an early
> > > > SM2802W V2 PCI with the isl3886 "softmac" chip;  2.6.28-rc7, firmware
> > > > 2.13.1.0.arm).  This is transcribed from a rather bad photo (please see
> > > >  http://mlau.at/pix/p54oops.jpg ):
> > > > 
> > > > BUG: Unable to handle kernel NULL pointer dereference at 0000000000000000
> > > > IP: [<ffffffffa0016b66>] p54_rx+0xc6/0x490 [p54common]
> > > > PGD 12e433067 PUD 12e46f067 PMD 0
> > > > Oops: 0000 [#1] PREEMPT SMP
> > > > last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0:0/....
> > > > CPU 0
> > > > Modules linked in: usb_storage ohci1394(+) ieee1394 p54pci(+) p54common ahci...
> > > > Pid: 0, comm: swapper Not tainted 2.6.28-rc7-00091-gf6f7b52 #1
> > > > RIP: 0010:[<ffffffffa0016b66>]  [<ffffffffa0016b66>] p54_rx+0xc6/0x490 [p54common]
> > > > RSP: 0018:ffffffff80ab3df0  EFLAGS: 00010207
> > > > RAX: 0000000074e9fed0 RBX: ffff08012e4f1940 RCX: 0000000000002e10
> > > > RDX: 0000000000000000 RSI: 00000000000000f1 RDI: ffff80012e4f0000
> > > > RBP: ffff80012e077010 R08: ffff80012e077000 R09: ffff80012e04?000
> > > > R10: 0000000000000001 R11: ffffffff00221320 R12: ffff80012e4f1900
> > > > R13: ffff80012e4f0300 R14: 000000000000732e R15: ffff80012e4f19??
> > > > 
> > > > (gdb) list *p54_rx+0xc6                                                                                                                                                                                                                      
> > > > 0x1b66 is in p54_rx (/usr/src/linux-2.6.git/drivers/net/wireless/p54/p54common.c:502).                                                                                                                                                       
> > > > 497                                                                                                                                                                                                                                          
> > > > 498             rx_status.signal = p54_rssi_to_dbm(dev, hdr->rssi);                                                                                                                                                                          
> > > > 499             rx_status.noise = priv->noise;                                                                                                                                                                                               
> > > > 500             /* XX correct? */                                                                                                                                                                                                            
> > > > 501             rx_status.qual = (100 * hdr->rssi) / 127;                                                                                                                                                                                    
> > > > 502             rx_status.rate_idx = (dev->conf.channel->band == IEEE80211_BAND_2GHZ ?                                                                                                                                                       
> > > > 503                             hdr->rate : (hdr->rate - 4)) & 0xf;                                                                                                                                                                          
> > > That's right, dev->conf.channel isn't set at the time we're reading the eeprom.
> > > But, then we didn't initialize the radio, dcf and mac/bb yet, so where did the data frames came
> > > from?
> > 
> > Booted firmware in need of attention? ;-)  The other device on irq 17 is
> > a jmicron pata controller with no disks attached.
> the device has a ring-buffer with a counting index => so the firmware must have
> incremented/corrupted the index.
> 
> > One more datapoint: this oops only seems to occur if udev loads p54 _and_
> > firmware is present.  Without firmware the driver (obviously) does nothing
> > an later I can happily modprobe/rmmod it when firmware is in place without
> > incident (with the timeout error below).
> > 
> Well, that's tricky... I've no idea why it's sending "data" frames in the first place. 
> 
> But what I can do is to stop the driver from oopsing...
>  
> I guess a check to see if the device mode is set to something else than 
> "NL80211_IFTYPE_UNSPECIFIED" and in p54_rx(_data) should prevent the oops.
> maybe we I should add a hex_dump as well.

patch attached... tell me what it does on your dev.

Regards,
	Chr



--Boundary-00=_APTPJ3fpWdAki0D
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="p54common-free.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="p54common-free.diff"

diff -Nurp linux-2.6.28-rc7/drivers/net/wireless/p54/p54common.c linux-2.6.28-rc8/drivers/net/wireless/p54/p54common.c
--- linux-2.6.28-rc7/drivers/net/wireless/p54/p54common.c	2008-12-08 15:35:51.655503446 +0100
+++ linux-2.6.28-rc8/drivers/net/wireless/p54/p54common.c	2008-12-08 15:30:58.583619238 +0100
@@ -488,6 +488,13 @@ static int p54_rx_data(struct ieee80211_
 	size_t header_len = sizeof(*hdr);
 	u32 tsf32;
 
+	if (priv->mode == NL80211_IFTYPE_UNSPECIFIED) {
+		printk(KERN_ERR "%s: received bogus data\n", wiphy_name(dev->wiphy));
+		print_hex_dump(KERN_ERR, "raw data: ", DUMP_PREFIX_ADDRESS,
+				16, 1, skb->data, skb->len, 1);
+		return 0;
+	}
+
 	if (!(hdr->magic & cpu_to_le16(0x0001))) {
 		if (priv->filter_flags & FIF_FCSFAIL)
 			rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;

--Boundary-00=_APTPJ3fpWdAki0D--
