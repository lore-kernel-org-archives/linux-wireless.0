Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52247 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab0K1TPV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Nov 2010 14:15:21 -0500
Received: by bwz15 with SMTP id 15so3283629bwz.19
        for <linux-wireless@vger.kernel.org>; Sun, 28 Nov 2010 11:15:19 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Tim Blechmann <tim@klingt.org>
Subject: Re: rt61pci issue
Date: Sun, 28 Nov 2010 20:14:12 +0100
Cc: linux-wireless@vger.kernel.org
References: <ibgpgg$a5m$1@dough.gmane.org> <201011120803.32721.helmut.schaa@googlemail.com> <201011251819.12913.tim@klingt.org>
In-Reply-To: <201011251819.12913.tim@klingt.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201011282014.12465.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag 25 November 2010 schrieb Tim Blechmann:
> > > > >> Mind to put a (maybe rate limited) printk into the interrupt thread
> > > > >> that prints out "reg"
> > > > >> and "reg_mcu" so that we can see which interrupts get triggered?
> > > > > 
> > > > > log attached, generated with:
> > > > Thanks. Unfortunately nothing special in there. Mostly RX and TX
> > > > interrupts. So there must be something else ...
> > > 
> > > Tim, is this on x86 hw? Or something else?
> > 
> > I don't know if this will do any good or harm but it could be worth a try
> > as the spec for rt61pci says something like: "Don't enable interrupt
> > mitigation in the same write as releasing the other masks.". Since we
> > always write a mitigation period of 0xff == "No mitigation period" we can
> > simply leave interrupt mitigation disabled.
> > 
> > I really don't have any clue if this will fix anything but it might be
> > worth a try.
> 
> i have been running this patch for a few days and i haven't experienced the 
> problem again.

Ok, I'll officially submit the patch soon ...

> according to `top', the kernel thread `irq/16-0000:08:' still is the kernel 
> thread, that is using the most cpu time (after an uptime of 8 hours) it is about 
> 50 seconds, while the second most expensive kernel thread (`kworker/2:1') takes 
> below 5 seconds of cpu time.

No idea :(

Helmut
