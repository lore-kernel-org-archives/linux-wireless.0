Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:47583 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab1BZBgL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Feb 2011 20:36:11 -0500
Date: Fri, 25 Feb 2011 22:36:39 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: David Miller <davem@davemloft.net>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2011-02-22
Message-ID: <20110226013639.GA2166@joana>
References: <20110222215229.GJ12153@tuxdriver.com>
 <20110224.224344.104068328.davem@davemloft.net>
 <20110225.111500.59674472.davem@davemloft.net>
 <20110225193618.GB2107@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110225193618.GB2107@joana>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Gustavo F. Padovan <padovan@profusion.mobi> [2011-02-25 16:36:18 -0300]:

> Hi David,
> 
> * David Miller <davem@davemloft.net> [2011-02-25 11:15:00 -0800]:
> 
> > From: David Miller <davem@davemloft.net>
> > Date: Thu, 24 Feb 2011 22:43:44 -0800 (PST)
> > 
> > > From: "John W. Linville" <linville@tuxdriver.com>
> > > Date: Tue, 22 Feb 2011 16:52:30 -0500
> > > 
> > >> Here is the latest batch of wireless bits intended for 2.6.39.  It seems
> > >> I neglected to send a pull request last week, so this one is a bit big
> > >> -- I apologize!
> > >> 
> > >> This includes a rather large batch of bluetooth bits by way of Gustavo.
> > >> It looks like a variety of bits, including some code refactoring, some
> > >> protocol support enhancements, some bugfixes, etc. -- nothing too
> > >> unusual.
> > >> 
> > >> Other items of interest include a new driver from Realtek, some ssb
> > >> support enhancements, and the usual sort of updates for mac80211 and a
> > >> variety of drivers.  Also included is a wireless-2.6 pull to resolve
> > >> some build breakage.
> > >> 
> > >> Please let me know if there are problems!
> > > 
> > > Pulled, thanks a lot John.
> > 
> > John a few things:
> > 
> > 1) I had to add some vmalloc.h includes to fix the build on sparc64,
> >    see commit b08cd667c4b6641c4d16a3f87f4550f81a6d69ac in net-next-2.6
> > 
> > 2) Something is screwey with the bluetooth config options now.
> > 
> >    I have an allmodconfig tree, and when I run "make oldconfig" after
> >    this pull, BT_L2CAP and BT_SCO both prompt me, claiming that they
> >    can only be built statically.
> > 
> >    I give it 'y' just to make it happen, for both, and afterways no
> >    matter how many times I rerun "make oldconfig" I keep seeing things
> >    like this in my build:
> > 
> > scripts/kconfig/conf --silentoldconfig Kconfig
> > include/config/auto.conf:986:warning: symbol value 'm' invalid for BT_SCO
> > include/config/auto.conf:3156:warning: symbol value 'm' invalid for BT_L2CAP
> > 
> >    First, what the heck is going on here?  Second, why the heck can't these
> >    non-trivial pieces of code be built modular any more?
> 
> We now have L2CAP and SCO built-in in the main bluetooth.ko module.
> 
> > 
> >    You can't make something "bool", have it depend on something that
> >    might be modular, and then build it into what could in fact be a
> >    module.  That's exactly what the bluetooth stuff seems to be doing
> >    now.
> 
> Seems I did the Kconfig change wrong, I'll fix it ASAP and send it to you
> guys.

I Figured the problem. When I first wrote this I based the work in other
Kconfig in net/ (as it was my very first time doing such kind of changes in a
Kconfig). For example, net/decnet/ and net/ax25/ do exactly the same as the
Bluetooth Kconfig. "bool" depending on "tristate" and build both together.

But doing another look after your report there is some places where this is
done a bit different, net/ipv6 and net/mac80211 are examples. Then I changed
to this new approach to remove the direct dependency from BT_L2CAP and BT_SCO.
Patch follows this e-mail.

That point me out that we may have other subsystems doing it wrong and we have
to fix this.

-- 
Gustavo F. Padovan
http://profusion.mobi
