Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62544 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498Ab1ECTWY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 15:22:24 -0400
Received: by eyx24 with SMTP id 24so130203eyx.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 May 2011 12:22:22 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "Andrew V. Stepanov" <stanv@altlinux.org>
Subject: Re: carl9170.ko RX - DMA, TX - COPY.
Date: Tue, 3 May 2011 20:58:39 +0000
Cc: linux-wireless@vger.kernel.org
References: <BANLkTiniamP_zXeGkW2TgatdkSv1+rdfeg@mail.gmail.com> <201105031918.28451.chunkeey@googlemail.com> <BANLkTikzpgP_swCfV28h7y0yNzGa7Df+vw@mail.gmail.com>
In-Reply-To: <BANLkTikzpgP_swCfV28h7y0yNzGa7Df+vw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201105032058.39635.chunkeey@googlemail.com> (sfid-20110503_212227_695196_B951CAE2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 03 May 2011 17:41:49 Andrew V. Stepanov wrote:
> On Tue, May 3, 2011 at 11:18 PM, Christian Lamparter
> <chunkeey@googlemail.com> wrote:
> > (readded ML -  KEEP IT in your replies/use reply all)
> >> >> carl9170.ko shows only 16 MBit/sec emit speed from kernel space,
> >> >> without touching user space.
> >> >> 
> >> >> Other driver rt3070sta.ko (another USB wifi device) shows 166Mb/sec.
> >> > 
> >> > The staging rt3070sta driver is no more, for a comparison you would
> >> > have to use rt2800usb.
> >> > 
> >> >> At this time 'top' command shows 100 % CPU load by  "kpktgend_0"
> >> >> thread: 2477 root      20   0     0    0    0 R 94.8  0.0   6:10.23
> >> >> kpktgend_0
> >> >> 
> >> >> I concluded that carl9170.ko doesn't uses DMA.
> >> >> Also, in source code drivers/net/wireless/ath/carl9170, i didn't find
> >> >> DMA functions.
> >> > 
> >> > That's because the USB subsystem takes care of that entirely, so
> >> > unless your musb ehci highspeed host does PIO because of
> >> > incompatibility, there's no "manual copy" in the TX path [except in
> >> > cases where there's not enough headroom/tailroom, or a second virtual
> >> > interface, etc...].
> >> 
> >> I believe my musb host support HIGH SPEED protocol.
> > 
> > True, but the USB-core in the device[AR9170] is a little bit picky, Also
> > users have told me that they had problems in "low-power" conditions.
> > Which is not that unlikely and maybe one of the reasons AR9170 was
> > replaced so quickly. [Note: some vendors [Unex?] can sell you other
> > solutions which have some nifty protocol offload capabilities, so why
> > not get one of those for the setup instead?]
> 
> I'm looking for any solutions that capable to emit with 8MBytes/sec
> speed from DDR2 from my board.
Wait, wait wait... haven't you said in your previous mail that a USB 2.0
flash stick "maxed" at just 6MB/s? I don't think you will come anywhere
close to 8MB/s with this setup then, unless you can swap the USB WIFI
for a AHB/PCI(e) device and even it might struggle.

> Can you give me more information about this solutions ?
Well, dnua-93f for example, however I doubt it will do better than 6MB/s
in the same setup [also note: this is a 1x1 dongle]. So, you'll have to
do some "research" first this time...

> >> rt3070sta.ko - also shows up to 6Mbytes/sec output throughput on this
> >> board.
> > 
> > Again: rt3070sta is gone/obsolete, test with rt2800usb instead!
> 
> I have tested all tree drivers:
> 
> [...]
> rt2800usb - from compat-wireless
> 
> All drivers shows poor performance even on Intel platform
> (6 Mbytes/sec).
Uh, last time I checked I had no problems getting 80Mbit TCP tp out of
a WUSB600 (rt3070, I think?) with an old Pentium M laptop. Maybe you
should contact Ivo/Helmut about the "poor" performance.

> >> carl9170.ko - shows only 2 Mbytes/sec output throughput with 100%
> >> CPU utilization (kpktgend_0 thread).
> > 
> > Well, looks like you will have to enable profiling to find the
> > bottleneck. Is oprofile available for your target, or are there any
> > other profiling tools you can use [there should be some, given that you
> > have a DEV board]?
> 
> I can compile kernel with any configuration.
> I have board http://support.spectrumdigital.com/boards/evmdm365/reve/
Ok? So what are you waiting for? Get your profiling tool working and 
look for the bottleneck, you certainly can't miss it! Good Luck!

Oh, just a sec, before you start: there's a possibility that the attached 
patch [below the cut line] from a different user helps a bit as well.

Regards,
     Chr
---
diff --git a/drivers/net/wireless/ath/carl9170/usb.c 
b/drivers/net/wireless/ath/carl9170/usb.c
index 2fb53d0..b5e73ae 100644
--- a/drivers/net/wireless/ath/carl9170/usb.c
+++ b/drivers/net/wireless/ath/carl9170/usb.c
@@ -485,7 +485,7 @@ static int carl9170_usb_send_rx_irq_urb(struct ar9170 *ar)
 
 	usb_fill_int_urb(urb, ar->udev, usb_rcvintpipe(ar->udev,
 			 AR9170_USB_EP_IRQ), ibuf, AR9170_USB_EP_CTRL_MAX,
-			 carl9170_usb_rx_irq_complete, ar, 1);
+			 carl9170_usb_rx_irq_complete, ar, 10);
 
 	urb->transfer_flags |= URB_FREE_BUFFER;
 
@@ -614,7 +614,7 @@ int __carl9170_exec_cmd(struct ar9170 *ar, struct 
carl9170_cmd *cmd,
 
 	usb_fill_int_urb(urb, ar->udev, usb_sndintpipe(ar->udev,
 		AR9170_USB_EP_CMD), cmd, cmd->hdr.len + 4,
-		carl9170_usb_cmd_complete, ar, 1);
+		carl9170_usb_cmd_complete, ar, 10);
 
 	if (free_buf)
 		urb->transfer_flags |= URB_FREE_BUFFER;
