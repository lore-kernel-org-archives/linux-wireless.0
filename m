Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37099
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757864AbYGTRfq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2008 13:35:46 -0400
Date: Sun, 20 Jul 2008 10:35:46 -0700 (PDT)
Message-Id: <20080720.103546.238638632.davem@davemloft.net> (sfid-20080720_193550_041348_6313D2BC)
To: tomasw@gmail.com
Cc: hadi@cyberus.ca, kaber@trash.net, netdev@vger.kernel.org,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 20/31]: pkt_sched: Perform bulk of qdisc destruction in
 RCU.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1ba2fa240807201034u1fbe3343tdcc858f7772d2b39@mail.gmail.com>
References: <1216566963.4847.81.camel@localhost>
	<20080720.102534.246150854.davem@davemloft.net>
	<1ba2fa240807201034u1fbe3343tdcc858f7772d2b39@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Tomas Winkler" <tomasw@gmail.com>
Date: Sun, 20 Jul 2008 20:34:18 +0300

> On Sun, Jul 20, 2008 at 8:25 PM, David Miller <davem@davemloft.net> wrote:
> > From: jamal <hadi@cyberus.ca>
> > Date: Sun, 20 Jul 2008 11:16:03 -0400
> >
> >> IMO, in the case of multiple hardware queues per physical wire,
> >> and such a netdevice already has a built-in hardware scheduler (they all
> >> seem to have this feature) then if we can feed the hardware queues
> >> directly, theres no need for any intermediate buffer(s).
> >> In such a case, to compare with qdisc arch, its like the root qdisc is
> >> in hardware.
> >
> > They tend to implement round-robin or some similar fairness algorithm
> > amongst the queues, with zero concern about packet priorities.
> >
> > It really is just like a bunch of queues to the phsyical layer,
> > fairly shared.
> >
> > These things are built for parallelization, not prioritization.
> 
> Except wireless where HW has prioritizing scheduler per physical non-wire.
> Tomas

I know that.  We're talking about multiqueue ethernet NICs.
