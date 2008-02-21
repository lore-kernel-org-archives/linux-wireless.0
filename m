Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59106
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753022AbYBUGfq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2008 01:35:46 -0500
Date: Wed, 20 Feb 2008 22:36:22 -0800 (PST)
Message-Id: <20080220.223622.148453409.davem@davemloft.net> (sfid-20080221_063549_867023_D568E25B)
To: johannes@sipsolutions.net
Cc: reinette.chatre@intel.com, linux-wireless@vger.kernel.org
Subject: Re: sending ARP triggers BUG
From: David Miller <davem@davemloft.net>
In-Reply-To: <1203468968.10983.13.camel@johannes.berg>
References: <D936D925018D154694D8A362EEB0892003ABCBD2@orsmsx416.amr.corp.intel.com>
	<1203468968.10983.13.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Wed, 20 Feb 2008 01:56:08 +0100

> [ 4340.665679] SKB BUG: Invalid truesize (240) len=73, sizeof(sk_buff)=176
> 
> Anybody have an idea how to debug that? It looks like 'len' is one too
> large, but I've also seen messages where it was two too large or one to
> small.

The BUG occurs when you use paged SKBs, it's different from
the other problem the person you are replying to is seeing.

The easiest thing to do to look for potentially problematic areas
is to find code that modifies skb->data_len but doesn't make
similar adjustments to skb->truesize.
