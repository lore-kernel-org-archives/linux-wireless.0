Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33600
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757816AbZFYXSM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Jun 2009 19:18:12 -0400
Date: Thu, 25 Jun 2009 16:18:17 -0700 (PDT)
Message-Id: <20090625.161817.112930127.davem@davemloft.net>
To: johannes@sipsolutions.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/3] wireless extensions improvements
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090624113447.441667549@sipsolutions.net>
References: <20090624113447.441667549@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Wed, 24 Jun 2009 13:34:47 +0200

> This series contains three improvements to wireless
> extensions:
>  1) make them network namespace aware, as discussed
>     previously
>  2) optimise the event sending code and fix a small
>     heap information leak
>  3) do some generic work and make it possible to send
>     compat netlink events, and make wext do this
> 
> Because the third patch depends on the first two (it
> could be made not to, if you wish) but touches generic
> networking stuff, I'd like to have all of these included
> in net-next instead of John's wireless tree, all the
> other wireless work can be done independently of these.

These changes look fine to me, so I'll likely put them into
net-next-2.6 as soon as I open that up.

FWIW, I bet we could make read() easily work properly to for the
compat stuff, and it would be nice to shore up that one minor hole.
