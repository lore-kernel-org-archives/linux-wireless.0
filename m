Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57766 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbZKQOP3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 09:15:29 -0500
Date: Tue, 17 Nov 2009 09:06:27 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stephen Hemminger <shemminger@vyatta.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: [RFC] mac80211: disallow bridging managed/adhoc interfaces
Message-ID: <20091117140626.GE27743@tuxdriver.com>
References: <1258465585.3682.7.camel@johannes.local> <200911171504.54170.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200911171504.54170.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 17, 2009 at 03:04:52PM +0100, Michael Buesch wrote:
> On Tuesday 17 November 2009 14:46:25 Johannes Berg wrote:
> > --- wireless-testing.orig/net/bridge/br_if.c	2009-11-17 14:19:17.000000000 +0100
> > +++ wireless-testing/net/bridge/br_if.c	2009-11-17 14:20:03.000000000 +0100
> > @@ -390,6 +390,10 @@ int br_add_if(struct net_bridge *br, str
> >  	if (dev->br_port != NULL)
> >  		return -EBUSY;
> >  
> > +	/* No bridging devices that dislike that (e.g. wireless) */
> > +	if (dev->priv_flags & IFF_DONT_BRIDGE)
> > +		return -EINVAL;
> 
> -EOPNOTSUPP?
> That would probably produce a better error message in userspace.

Yes, good point.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
