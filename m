Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:53938 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754044Ab0ESTFy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 May 2010 15:05:54 -0400
Subject: Re: [PATCH] cfg80211: make action channel type optional
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>, Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1274294939.19404.4.camel@jlt3.sipsolutions.net>
References: <1274264232.3874.7.camel@jlt3.sipsolutions.net>
	 <1274293152.8463.2.camel@mj>
	 <1274294939.19404.4.camel@jlt3.sipsolutions.net>
Content-Type: text/plain
Date: Wed, 19 May 2010 15:05:52 -0400
Message-Id: <1274295952.9409.3.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-05-19 at 20:48 +0200, Johannes Berg wrote:
> On Wed, 2010-05-19 at 14:19 -0400, Pavel Roskin wrote:
> > On Wed, 2010-05-19 at 12:17 +0200, Johannes Berg wrote:
> > 
> > > @@ -1168,6 +1168,7 @@ struct cfg80211_ops {
> > >  	int	(*action)(struct wiphy *wiphy, struct net_device *dev,
> > >  			  struct ieee80211_channel *chan,
> > >  			  enum nl80211_channel_type channel_type,
> > > +			  bool channel_type_valid,
> > >  			  const u8 *buf, size_t len, u64 *cookie);
> > 
> > Would not it be easier to introduce NL80211_CHAN_UNSPECIFIED in enum
> > nl80211_channel_type?
> 
> Yes, but it would change the userspace API so we can't do that.

I believe the new API would be a superset of the old API.  No userspace
caller would need to be changed.

Anyway, I just wanted to be sure that a simpler solution was considered.

-- 
Regards,
Pavel Roskin
