Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47937
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752824AbYG2KNU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 06:13:20 -0400
Date: Tue, 29 Jul 2008 03:13:17 -0700 (PDT)
Message-Id: <20080729.031317.237762949.davem@davemloft.net> (sfid-20080729_121323_308902_E88E00AA)
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: partially fix skb->cb use
From: David Miller <davem@davemloft.net>
In-Reply-To: <1217323927.10489.9.camel@johannes.berg>
References: <1217323927.10489.9.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 29 Jul 2008 11:32:07 +0200

> This patch fixes mac80211 to not use the skb->cb over the queue step
> from virtual interfaces to the master. The patch also, for now,
> disables aggregation because that would still require requeuing,
> will fix that in a separate patch. There are two other places (software
> requeue and powersaving stations) where requeue can happen, but that is
> not currently used by any drivers/not possible to use respectively.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> This fixes wireless. At least it works on my WPA network, I haven't
> actually tested a broken kernel.

This looks mostly fine to me.

I'd like to see some success reports from folks having trouble
currently.
