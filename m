Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:6880 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbYGWItq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 04:49:46 -0400
Received: by ug-out-1314.google.com with SMTP id h2so469316ugf.16
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2008 01:49:44 -0700 (PDT)
Date: Wed, 23 Jul 2008 08:54:52 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: Larry.Finger@lwfinger.net, kaber@trash.net,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, peterz@infradead.org,
	mingo@redhat.com
Subject: Re: Kernel WARNING: at net/core/dev.c:1330
	__netif_schedule+0x2c/0x98()
Message-ID: <20080723085452.GB4561@ff.dom.local> (sfid-20080723_104951_177551_4E21B83D)
References: <20080722.160409.216536011.davem@davemloft.net> <20080723062036.GA4561@ff.dom.local> <20080723.005921.113868915.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080723.005921.113868915.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 23, 2008 at 12:59:21AM -0700, David Miller wrote:
> From: Jarek Poplawski <jarkao2@gmail.com>
> Date: Wed, 23 Jul 2008 06:20:36 +0000
> 
> > PS: if there is nothing new in lockdep the classical method would
> > be to change this static array:
> > 
> > static struct lock_class_key
> > netdev_xmit_lock_key[ARRAY_SIZE(netdev_lock_type)];
> > 
> > to
> > 
> > static struct lock_class_key
> > netdev_xmit_lock_key[ARRAY_SIZE(netdev_lock_type)][MAX_NUM_TX_QUEUES];
> > 
> > and set lockdep classes per queue as well. (If we are sure we don't
> > need lockdep subclasses anywhere this could be optimized by using
> > one lock_class_key per 8 queues and spin_lock_nested()).
> 
> Unfortunately MAX_NUM_TX_QUEUES is USHORT_MAX, so this isn't really
> a feasible approach.

Is it used by real devices already? Maybe for the beginning we could
start with something less?

> spin_lock_nested() isn't all that viable either, as the subclass
> limit is something like 8.

This method would need to do some additional counting: depending of
a queue number each 8 subsequent queues share (are set to) the same
class and their number mod 8 gives the subqueue number for
spin_lock_nested().

I'll try to find if there is something new around this in lockdep.
(lockdep people added to CC.)

Jarek P.
