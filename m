Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:34833 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345AbZKQQhl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 11:37:41 -0500
Date: Tue, 17 Nov 2009 08:37:41 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Buesch <mb@bu3sch.de>, netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: [RFC] mac80211: disallow bridging managed/adhoc interfaces
Message-ID: <20091117083741.1b165274@nehalam>
In-Reply-To: <1258466868.3682.13.camel@johannes.local>
References: <1258465585.3682.7.camel@johannes.local>
	<200911171504.54170.mb@bu3sch.de>
	<1258466868.3682.13.camel@johannes.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 17 Nov 2009 15:07:48 +0100
Johannes Berg <johannes@sipsolutions.net> wrote:

> On Tue, 2009-11-17 at 15:04 +0100, Michael Buesch wrote:
> > On Tuesday 17 November 2009 14:46:25 Johannes Berg wrote:
> > > --- wireless-testing.orig/net/bridge/br_if.c	2009-11-17 14:19:17.000000000 +0100
> > > +++ wireless-testing/net/bridge/br_if.c	2009-11-17 14:20:03.000000000 +0100
> > > @@ -390,6 +390,10 @@ int br_add_if(struct net_bridge *br, str
> > >  	if (dev->br_port != NULL)
> > >  		return -EBUSY;
> > >  
> > > +	/* No bridging devices that dislike that (e.g. wireless) */
> > > +	if (dev->priv_flags & IFF_DONT_BRIDGE)
> > > +		return -EINVAL;
> > 
> > -EOPNOTSUPP?
> > That would probably produce a better error message in userspace.

But there are people bridging wireless, and hostap even has a mode for
that. Especially people are bridging to wireless when the other interfaces
are VMs.

