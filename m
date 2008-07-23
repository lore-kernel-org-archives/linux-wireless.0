Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48439
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751496AbYGWH7V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 03:59:21 -0400
Date: Wed, 23 Jul 2008 00:59:21 -0700 (PDT)
Message-Id: <20080723.005921.113868915.davem@davemloft.net> (sfid-20080723_095927_406115_FF3B1CD4)
To: jarkao2@gmail.com
Cc: Larry.Finger@lwfinger.net, kaber@trash.net,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: Kernel WARNING: at net/core/dev.c:1330
 __netif_schedule+0x2c/0x98()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080723062036.GA4561@ff.dom.local>
References: <20080722.160409.216536011.davem@davemloft.net>
	<20080723062036.GA4561@ff.dom.local>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jarek Poplawski <jarkao2@gmail.com>
Date: Wed, 23 Jul 2008 06:20:36 +0000

> PS: if there is nothing new in lockdep the classical method would
> be to change this static array:
> 
> static struct lock_class_key
> netdev_xmit_lock_key[ARRAY_SIZE(netdev_lock_type)];
> 
> to
> 
> static struct lock_class_key
> netdev_xmit_lock_key[ARRAY_SIZE(netdev_lock_type)][MAX_NUM_TX_QUEUES];
> 
> and set lockdep classes per queue as well. (If we are sure we don't
> need lockdep subclasses anywhere this could be optimized by using
> one lock_class_key per 8 queues and spin_lock_nested()).

Unfortunately MAX_NUM_TX_QUEUES is USHORT_MAX, so this isn't really
a feasible approach.

spin_lock_nested() isn't all that viable either, as the subclass
limit is something like 8.

