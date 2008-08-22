Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.236]:40508 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbYHVNwJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2008 09:52:09 -0400
Received: by rv-out-0506.google.com with SMTP id k40so443507rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 22 Aug 2008 06:52:08 -0700 (PDT)
Subject: Re: [PATCH 20/31]: pkt_sched: Perform bulk of qdisc destruction in
	RCU.
From: jamal <hadi@cyberus.ca>
Reply-To: hadi@cyberus.ca
To: David Miller <davem@davemloft.net>
Cc: herbert@gondor.apana.org.au, kaber@trash.net,
	netdev@vger.kernel.org, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080822.034217.135152551.davem@davemloft.net>
References: <20080822065655.GA18471@gondor.apana.org.au>
	 <20080822.001620.141235108.davem@davemloft.net>
	 <20080822074115.GB25615@gondor.apana.org.au>
	 <20080822.034217.135152551.davem@davemloft.net>
Content-Type: text/plain
Date: Fri, 22 Aug 2008 09:52:05 -0400
Message-Id: <1219413125.4672.39.camel@localhost> (sfid-20080822_155214_562659_6EAB93E9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-22-08 at 03:42 -0700, David Miller wrote:

> I had another idea in the back of my head that I wanted to mention.
> 
> The SKB has a hash, and sources set the hash.  It doesn't matter
> where in the stack it comes from.
> 
> At transmit time, the select queue logic in dev_queue_xmit() will use
> the SKB hash if one has been set already.  Otherwise it will do the
> hashing it does currently.
> 
> So in the simplest case for forwarding, the RX side puts the RSS
> hash or whatever into this SKB hash location.
> 

Makes sense. 
In the case Herbert described, I am assuming that the RSS side could be
configured to select a processor statically (MSI or otherwise). And that
the hash value will be that of the processorid ego the tx queue
selected.

> Then, taking things to the next level, protocols set hashes for
> locally created packets.  And this leads to being able to delete
> the simple_tx_hash() code entirely and also we won't have to add
> support for every protocol on the planet to that function. :)
> 

Well, conntrack could be useful (as long as you dont make it mandatory)
since it already keeps track of flows.
When unresolved, one could add it to some default queue.

cheers,
jamal

