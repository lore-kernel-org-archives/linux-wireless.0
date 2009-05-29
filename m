Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56912
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757280AbZE2Ij7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 May 2009 04:39:59 -0400
Date: Fri, 29 May 2009 01:39:58 -0700 (PDT)
Message-Id: <20090529.013958.241541251.davem@davemloft.net>
To: netdev@vger.kernel.org
CC: linux-wireless@vger.kernel.org
Subject: [PATCH 0/10]: Kill more direct references to SKB list
 implementation.
From: David Miller <davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This is some more work towards eliminating exlicit references to the
SKB list implementation, with the eventual goal that converting the
tree over to use "struct list_head" for skb's can be a single commit
to just one file, linux/skbuff.h

In order for that to happen, sufficient abstract interfaces need to
exist in linux/skbuff.h (that's already mostly the case) and code
needs to use those interfaces instead of directly hitting skb->next,
skb->prev, comparing such pointers to the list head with a cast, etc.

There's still a bit more to do, but we're closer than ever to being
able to put the last nail in the coffin on this one.

I'll be pushing these out to net-next-2.6 after some sanity build
checks.
