Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39252
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754658AbYGOJjx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2008 05:39:53 -0400
Date: Tue, 15 Jul 2008 02:39:54 -0700 (PDT)
Message-Id: <20080715.023954.234208581.davem@davemloft.net> (sfid-20080715_113958_580646_EC79363F)
To: johannes@sipsolutions.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: TXQ real_num_tx_queues comments/questions
From: David Miller <davem@davemloft.net>
In-Reply-To: <1216114621.3535.18.camel@johannes.berg>
References: <1216113923.3535.14.camel@johannes.berg>
	<20080715.022854.55875400.davem@davemloft.net>
	<1216114621.3535.18.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 15 Jul 2008 11:37:01 +0200

> From mac80211's POV it's just that select_queue must have known
> about the removed queue when the requeue is done. And we can defer
> the requeue to a workqueue.

Ok.

So you're proposing the requeue be deferred to a workqueue
and what else?  RCU protection around real_num_tx_queues
access?

