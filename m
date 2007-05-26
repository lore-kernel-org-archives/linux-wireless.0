Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41468 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753055AbXEZQba (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 May 2007 12:31:30 -0400
From: Uwe Bugla <uwe.bugla@gmx.de>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: BUG in 2.6.22-rc2-mm1: NIC module b44.c broken (Broadcom 4400)
Date: Sat, 26 May 2007 18:26:06 +0200
References: <20070524195616.234280@gmx.net> <20070526091309.0af20971.akpm@linux-foundation.org> <200705261821.16355.mb@bu3sch.de>
In-Reply-To: <200705261821.16355.mb@bu3sch.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Maximilian Engelhardt <maxi@daemonizer.de>,
	linux-wireless@vger.kernel.org,
	"linux-kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200705261826.06796.uwe.bugla@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Samstag, 26. Mai 2007 18:21 schrieben Sie:
> On Saturday 26 May 2007 18:13:09 Andrew Morton wrote:
> > > I already tried your -mm kernel, but it crashes on my machine
> > > for other reasons. (Yeah, I should look into them, too :P )
> >
> > err, please do.  Just the oops trace would be a start.
>
> Yes, I will look into it. I think it was related to my
> onboard RTL networking chip. When trying to bring it down,
> it oopses the machine. But I'm not sure what happens exactly, yet.
> I'll take a look at it.
>
> > > Andrew, is it possible that the breakage was introduced in the
> > > merge process somehow? Didn't the patch apply cleanly? Are there
> > > other changes to b44 I should know about in your tree?
> >
> > Only git-wireless.net modifies b44.c but if we're having IRQ assignment
> > problems then we'd need to look elsewhere.
>
> I think we don't have IRQ assignment problems. Uwe simply disabled
> b44-PCI support in his first bugreport (I guess).

Yes!

> So there was 
> no b44-PCI driver loaded.

Well, not exactly: b44 plus ssb were in fact produced, but did not function, 
at least in that case, due to the misleading / superficial information in the 
Kconfig menu......

> Later on he said that it does magically work now...

NO!

Later on I said I did chose that b44-PCI driver, got the right dependencies,
and there was no interrupt problem at all. So the driver got loaded as 
expected but simply did not work at all......

Cheers

Uwe
