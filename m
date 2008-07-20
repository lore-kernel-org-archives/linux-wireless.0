Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48589
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758024AbYGTRZf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2008 13:25:35 -0400
Date: Sun, 20 Jul 2008 10:25:34 -0700 (PDT)
Message-Id: <20080720.102534.246150854.davem@davemloft.net> (sfid-20080720_192547_330234_93AF55CF)
To: hadi@cyberus.ca
Cc: kaber@trash.net, netdev@vger.kernel.org, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 20/31]: pkt_sched: Perform bulk of qdisc destruction in
 RCU.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1216566963.4847.81.camel@localhost>
References: <1216387641.4833.96.camel@localhost>
	<20080718.140539.122169028.davem@davemloft.net>
	<1216566963.4847.81.camel@localhost>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: jamal <hadi@cyberus.ca>
Date: Sun, 20 Jul 2008 11:16:03 -0400

> IMO, in the case of multiple hardware queues per physical wire,
> and such a netdevice already has a built-in hardware scheduler (they all
> seem to have this feature) then if we can feed the hardware queues
> directly, theres no need for any intermediate buffer(s).
> In such a case, to compare with qdisc arch, its like the root qdisc is
> in hardware.

They tend to implement round-robin or some similar fairness algorithm
amongst the queues, with zero concern about packet priorities.

It really is just like a bunch of queues to the phsyical layer,
fairly shared.

These things are built for parallelization, not prioritization.
