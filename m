Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52688 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab0EZLTR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 07:19:17 -0400
Subject: Re: [RFC PATCH] mac80211: Add support for hardware ARP query
 filtering
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1274872467.5277.1783.camel@wimaxnb.nmp.nokia.com>
References: <1274773685-11168-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1274778802.3635.30.camel@jlt3.sipsolutions.net>
	 <1274872467.5277.1783.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 May 2010 13:19:14 +0200
Message-ID: <1274872754.3658.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-05-26 at 14:14 +0300, Juuso Oikarinen wrote:

> > > +static inline int drv_configure_ip_filter(struct ieee80211_hw *hw,
> > > +					  struct in_ifaddr *ifa_list)
> > > +{
> > > +	struct ieee80211_local *local = hw_to_local(hw);
> > > +	int ret = 0;
> > > +
> > > +	if (local->ops->configure_ip_filter)
> > > +		ret = local->ops->configure_ip_filter(hw, ifa_list);
> > > +	return ret;
> > > +}
> > 
> > Tracing would be nice, you should even able able to trace all addresses
> > in a variable-length array.
> > 
> 
> I looked into the tracing. I still prefer using the ifa_list directly as
> argument to the driver, and not copy the addresses in it to another
> array.
> 
> The ifa_list is a linked list, and does AFAIK does not directly fit into
> the tracing infrasturcture.
> 
> Hence I added a trace for this op, but omitted tracing the IP addresses.

Yeah, that's fine ... it later occurred to me that I also left that out
for the multicast list for exactly this reason.

johannes

