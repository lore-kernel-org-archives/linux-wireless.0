Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39806
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755948AbYGOJ2y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2008 05:28:54 -0400
Date: Tue, 15 Jul 2008 02:28:54 -0700 (PDT)
Message-Id: <20080715.022854.55875400.davem@davemloft.net> (sfid-20080715_112916_295174_8436D786)
To: johannes@sipsolutions.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: TXQ real_num_tx_queues comments/questions
From: David Miller <davem@davemloft.net>
In-Reply-To: <1216113923.3535.14.camel@johannes.berg>
References: <1215769627.3483.107.camel@johannes.berg>
	<20080715.021637.103260952.davem@davemloft.net>
	<1216113923.3535.14.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 15 Jul 2008 11:25:23 +0200

> > It seems to me that a simple synchronize_net() call near the end of
> > agg queue removal would solve your problem as-is, wouldn't it?
> 
> Well, as far as I can tell we can't do that there because it's in
> tasklet context/called under spinlocks so it has to be atomic. I think.

Right, my bad.

It seems that there can end up being holes in the queue
space on mac80211, which slightly complicates matters.
