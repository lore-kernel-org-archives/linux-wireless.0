Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.klingt.org ([86.59.21.178]:42194 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682Ab1BQLxP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Feb 2011 06:53:15 -0500
From: Tim Blechmann <tim@klingt.org>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: rt61pci issue
Date: Thu, 17 Feb 2011 11:07:06 +0100
Cc: linux-wireless@vger.kernel.org
References: <ibgpgg$a5m$1@dough.gmane.org> <201011251819.12913.tim@klingt.org> <201011282014.12465.helmut.schaa@googlemail.com>
In-Reply-To: <201011282014.12465.helmut.schaa@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201102171107.07299.tim@klingt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > > > > >> Mind to put a (maybe rate limited) printk into the interrupt
> > > > > >> thread that prints out "reg"
> > > > > >> and "reg_mcu" so that we can see which interrupts get triggered?
> > > > > > 
> > > > > > log attached, generated with:
> > > > > Thanks. Unfortunately nothing special in there. Mostly RX and TX
> > > > > interrupts. So there must be something else ...
> > > > 
> > > > Tim, is this on x86 hw? Or something else?
> > > 
> > > I don't know if this will do any good or harm but it could be worth a
> > > try as the spec for rt61pci says something like: "Don't enable
> > > interrupt mitigation in the same write as releasing the other masks.".
> > > Since we always write a mitigation period of 0xff == "No mitigation
> > > period" we can simply leave interrupt mitigation disabled.
> > > 
> > > I really don't have any clue if this will fix anything but it might be
> > > worth a try.
> > 
> > i have been running this patch for a few days and i haven't experienced
> > the problem again.
> 
> Ok, I'll officially submit the patch soon ...

i've been running a simple patch like for some time:
@ -1743,8 +1743,8 @@ static void rt61pci_toggle_irq(struct rt2x00_dev *rt2x00dev,
    rt2x00_set_field32(&reg, INT_MASK_CSR_TXDONE, mask);
    rt2x00_set_field32(&reg, INT_MASK_CSR_RXDONE, mask);
    rt2x00_set_field32(&reg, INT_MASK_CSR_BEACON_DONE, mask);
-   rt2x00_set_field32(&reg, INT_MASK_CSR_ENABLE_MITIGATION, mask);
-   rt2x00_set_field32(&reg, INT_MASK_CSR_MITIGATION_PERIOD, 0xff);
+   /* rt2x00_set_field32(&reg, INT_MASK_CSR_ENABLE_MITIGATION, mask); */
+   /* rt2x00_set_field32(&reg, INT_MASK_CSR_MITIGATION_PERIOD, 0xff); */
    rt2x00pci_register_write(rt2x00dev, INT_MASK_CSR, reg);
 
    rt2x00pci_register_read(rt2x00dev, MCU_INT_MASK_CSR, &reg);
 
trying out the unpatched 2.6.38-rc5, i hit the original issue again. but with
the patch, i sometimes have connection troubles using skype. i would really
appreciate a proper solution for this issue ...

thanks, tim

-- 
tim@klingt.org
http://tim.klingt.org

You can play a shoestring if you're sincere
  John Coltrane
