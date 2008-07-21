Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58335
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752219AbYGUPJB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2008 11:09:01 -0400
Date: Mon, 21 Jul 2008 08:09:01 -0700 (PDT)
Message-Id: <20080721.080901.214889979.davem@davemloft.net> (sfid-20080721_170907_232358_377E8BCB)
To: herbert@gondor.apana.org.au
Cc: hadi@cyberus.ca, kaber@trash.net, netdev@vger.kernel.org,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 20/31]: pkt_sched: Perform bulk of qdisc destruction in
 RCU.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080721135846.GA11543@gondor.apana.org.au>
References: <20080721131918.GA11114@gondor.apana.org.au>
	<1216648585.4847.303.camel@localhost>
	<20080721135846.GA11543@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Mon, 21 Jul 2008 21:58:46 +0800

> On Mon, Jul 21, 2008 at 09:56:25AM -0400, jamal wrote:
> > 
> > Ok - You may be able to pull it if you have the exact same hashing on
> > hardware rx as it is on transmit stateless filtering.
> > I can see a traffic pattern that could be cooked to give some good
> > numbers in such a scenario;->
> 
> Actually you've hit it on the head, as an alternative to TX hashing
> on the packet content, we need to allow TX queue selection based on
> the current CPU ID.

This we should avoid, it would allow reordering within a flow.
