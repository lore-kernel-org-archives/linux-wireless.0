Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60678
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750695AbYEPE6c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 00:58:32 -0400
Date: Thu, 15 May 2008 21:58:23 -0700 (PDT)
Message-Id: <20080515.215823.28841530.davem@davemloft.net> (sfid-20080516_065859_735853_4D100A07)
To: rusty@rustcorp.com.au
Cc: herbert@gondor.apana.org.au, mb@bu3sch.de,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, ron.rindjunsky@intel.com, tomasw@gmail.com,
	ivdoorn@gmail.com, peter.p.waskiewicz.jr@intel.com
Subject: Re: [PATCH] mac80211: rewrite fragmentation code
From: David Miller <davem@davemloft.net>
In-Reply-To: <200805161201.48835.rusty@rustcorp.com.au>
References: <20080508032208.GA401@gondor.apana.org.au>
	<20080507.202606.242037993.davem@davemloft.net>
	<200805161201.48835.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 16 May 2008 12:01:48 +1000

> Dave, please allow me to ask a heretical question.  Returning
> TX_BUSY has some appeal for virtio_net: is it fundamentally a flawed
> idea, or simply a matter of coding?

Allowing TX_BUSY adds a special case to the caller which we'd
like to remove at some point.

> Currently we have no virtio interface to ask how many descriptors are left; 
> it's not clear that it's a fair question to ask, since for Xen it's depends 
> on the actual buffers we're trying to put in the descirptors.

Two things:

1) You can always make sure that you have enough space for a
   TSO frame, with arbitrary page boundaries and thus buffer
   chopping.

   It can even be estimated, and if violated by some corner case
   you can punt and drop.

2) You can queue inside of the driver one packet when you hit
   the limits unexpectedly, netif_stop_queue(), and return
   success.  Spit this packet out right before waking the
   queue again.

Really, there are no hard reasons to ever return TX_BUSY,
it's always a bug.

In fact, I want to move things more and more towards the driver
queueing TX packets internally instead of the networking mid-layer.

That will ahve benefits for things like TX multiqueue, we won't
need any locking at all, nor have any knowledge about multiple
queues at all, if the driver takes care of providing the buffer
between what the kernel gives it and what the device can handle
at the moment.
