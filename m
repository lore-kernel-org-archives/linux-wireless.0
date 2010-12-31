Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51842 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab0LaKSY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Dec 2010 05:18:24 -0500
Subject: RE: [PATCH net-2.6] bridge: fix br_multicast_ipv6_rcv for paged
 skbs
From: Johannes Berg <johannes@sipsolutions.net>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: Stephen Hemminger <stephen.hemminger@vyatta.com>,
	Stephen Hemminger <shemminger@vyatta.com>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <6F5C1D715B2DA5498A628E6B9C124F04019BF36ABD@hasmsx504.ger.corp.intel.com>
References: <9mk4bme8o97ir27xi8a9fbsd.1293750376929@email.android.com>
	 <6F5C1D715B2DA5498A628E6B9C124F04019BF36ABD@hasmsx504.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 31 Dec 2010 11:18:15 +0100
Message-ID: <1293790695.4507.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-12-31 at 01:29 +0200, Winkler, Tomas wrote:
> 
> > -----Original Message-----
> > From: Stephen Hemminger [mailto:stephen.hemminger@vyatta.com]
> > Sent: Friday, December 31, 2010 1:06 AM
> > To: Winkler, Tomas; Stephen Hemminger; Johannes Berg
> > Cc: davem@davemloft.net; netdev@vger.kernel.org ; linux-
> > wireless@vger.kernel.org
> > Subject: RE: [PATCH net-2.6] bridge: fix br_multicast_ipv6_rcv for paged
> > skbs
> > 
> > Although copy is slower for large packets, this is a non performance path.
> > The code in question is for bridged multicast Ipv6 ICMP packets. This case
> > is so uncritical it could be done in BASIC and no one could possibly care!
> > 
> 
> 
> Fair enough, although you got few of those when you connect to win7 client. 
> Anyhow my fix would work if the second pull would be 
>   if (!pskb_may_pull(skb2, sizeof(struct mld_msg)))  instead of  (!pskb_may_pull(skb2, sizeof(*icmp6h)))

I don't think that works either since that may be longer than the entire
skb's length since the payload still is variable at this point.

johannes

