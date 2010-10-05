Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44317
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756923Ab0JEHI3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 03:08:29 -0400
Date: Tue, 05 Oct 2010 00:08:50 -0700 (PDT)
Message-Id: <20101005.000850.241436160.davem@davemloft.net>
To: johannes@sipsolutions.net
Cc: linville@tuxdriver.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/4] genetlink: introduce pre_doit/post_doit hooks
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101004191838.763690480@sipsolutions.net>
References: <20101004191402.183055479@sipsolutions.net>
	<20101004191838.763690480@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Mon, 04 Oct 2010 21:14:03 +0200

> From: Johannes Berg <johannes.berg@intel.com>
> 
> Each family may have some amount of boilerplate
> locking code that applies to most, or even all,
> commands.
> 
> This allows a family to handle such things in
> a more generic way, by allowing it to
>  a) include private flags in each operation
>  b) specify a pre_doit hook that is called,
>     before an operation's doit() callback and
>     may return an error directly,
>  c) specify a post_doit hook that can undo
>     locking or similar things done by pre_doit,
>     and finally
>  d) include two private pointers in each info
>     struct passed between all these operations
>     including doit(). (It's two because I'll
>     need two in nl80211 -- can be extended.)
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Acked-by: David S. Miller <davem@davemloft.net>
