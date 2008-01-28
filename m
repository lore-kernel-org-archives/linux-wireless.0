Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57609
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750715AbYA1DOo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jan 2008 22:14:44 -0500
Date: Sun, 27 Jan 2008 19:15:00 -0800 (PST)
Message-Id: <20080127.191500.193705395.davem@davemloft.net> (sfid-20080128_031456_656525_A3E43AB3)
To: torvalds@linux-foundation.org
Cc: jeff@garzik.org, linville@tuxdriver.com, mb@bu3sch.de,
	dcbw@redhat.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Subject: Re: Linux 2.6.24-rc7
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.1.00.0801262345030.3222@www.l.google.com>
References: <479C2FB0.7080700@garzik.org>
	<20080126.232431.193736209.davem@davemloft.net>
	<alpine.LFD.1.00.0801262345030.3222@www.l.google.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 26 Jan 2008 23:54:18 -0800 (PST)

> Wouldn't it be nice to just handle the MTU memory accounting issue at the 
> network level too?

If the driver does it, it can immediately recycle the packet back into
the RX ring without all the overhead of freeing it and then allocating
it all over again.

It can also avoid all of the DMA map/unmap operations as well.
(you can copy and entire packet in the time a PIO operation
 to some of these IOMMU chips can take)

Moving all of this into netif_receive_skb() would be great for
centralization of logic, but I would not advocate it specifically
because it makes the drivers etc. do a lot of wasteful work.

