Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:45219
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539AbXEZQkx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 May 2007 12:40:53 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Uwe Bugla <uwe.bugla@gmx.de>
Subject: Re: BUG in 2.6.22-rc2-mm1: NIC module b44.c broken (Broadcom 4400)
Date: Sat, 26 May 2007 18:40:45 +0200
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Maximilian Engelhardt <maxi@daemonizer.de>,
	linux-wireless@vger.kernel.org,
	"linux-kernel" <linux-kernel@vger.kernel.org>
References: <20070524195616.234280@gmx.net> <200705261821.16355.mb@bu3sch.de> <200705261826.06796.uwe.bugla@gmx.de>
In-Reply-To: <200705261826.06796.uwe.bugla@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200705261840.45896.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 26 May 2007 18:26:06 Uwe Bugla wrote:
> > I think we don't have IRQ assignment problems. Uwe simply disabled
> > b44-PCI support in his first bugreport (I guess).
> 
> Yes!
> 
> > So there was 
> > no b44-PCI driver loaded.
> 
> Well, not exactly: b44 plus ssb were in fact produced, but did not function, 
> at least in that case, due to the misleading / superficial information in the 
> Kconfig menu......
> 
> > Later on he said that it does magically work now...
> 
> NO!
> 
> Later on I said I did chose that b44-PCI driver, got the right dependencies,
> and there was no interrupt problem at all. So the driver got loaded as 
> expected but simply did not work at all......

One small sidenote:
If you did _not_ play around with the b44/ssb kconfig options at all,
it would have selected the right options _automatically_ for you.
That means:

cp ../old_kernel_without_ssb/.config .
make oldconfig
make
be done.

You intentionaly disabled PCI device support for b44 and you
still wonder why it doesn't work on your PCI device?
I'm not sure how to make the helptext any clearer on the b44-PCI
option. We have _lots_ of other drivers in the tree that work
EXACTLY the same way, regarding to kconfig. There are _lots_
of drivers where there are seperate options for a "bus-glue".
b44-ssb is no different. And additionally it automatically
selects the right options for 99.9% of the users (you included).

So I'm not sure why you keep bashing the kconfig implementation
here. It's common practice to have seperate config options for
bus-glues and it _automatically_ selects the right options for
you.

-- 
Greetings Michael.
