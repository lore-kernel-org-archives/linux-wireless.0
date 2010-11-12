Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49915 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab0KLHEa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 02:04:30 -0500
Received: by fxm16 with SMTP id 16so2026816fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Nov 2010 23:04:29 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Tim Blechmann <tim@klingt.org>
Subject: Re: rt61pci issue
Date: Fri, 12 Nov 2010 08:03:32 +0100
Cc: linux-wireless@vger.kernel.org
References: <ibgpgg$a5m$1@dough.gmane.org> <AANLkTikqx43LwfyB4979Mazhch41cGaa7txP6zjCa99F@mail.gmail.com> <201011120747.28837.helmut.schaa@googlemail.com>
In-Reply-To: <201011120747.28837.helmut.schaa@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201011120803.32721.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Freitag 12 November 2010 schrieb Helmut Schaa:
> Am Donnerstag 11 November 2010 schrieb Helmut Schaa:
> > On Thu, Nov 11, 2010 at 3:56 PM, Tim Blechmann <tim@klingt.org> wrote:
> > >> Mind to put a (maybe rate limited) printk into the interrupt thread
> > >> that prints out "reg"
> > >> and "reg_mcu" so that we can see which interrupts get triggered?
> > >
> > > log attached, generated with:
> > 
> > Thanks. Unfortunately nothing special in there. Mostly RX and TX interrupts. So
> > there must be something else ...
> 
> Tim, is this on x86 hw? Or something else?

I don't know if this will do any good or harm but it could be worth a try as
the spec for rt61pci says something like: "Don't enable interrupt mitigation
in the same write as releasing the other masks.". Since we always write a
mitigation period of 0xff == "No mitigation period" we can simply leave
interrupt mitigation disabled.

I really don't have any clue if this will fix anything but it might be worth
a try.

Thanks,
Helmut

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index af548c8..fde8220 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1655,8 +1655,6 @@ static void rt61pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&reg, INT_MASK_CSR_TXDONE, mask);
 	rt2x00_set_field32(&reg, INT_MASK_CSR_RXDONE, mask);
 	rt2x00_set_field32(&reg, INT_MASK_CSR_BEACON_DONE, mask);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_ENABLE_MITIGATION, mask);
-	rt2x00_set_field32(&reg, INT_MASK_CSR_MITIGATION_PERIOD, 0xff);
 	rt2x00pci_register_write(rt2x00dev, INT_MASK_CSR, reg);
 
 	rt2x00pci_register_read(rt2x00dev, MCU_INT_MASK_CSR, &reg);

