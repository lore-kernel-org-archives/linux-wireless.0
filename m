Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46398 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab0ESStH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 May 2010 14:49:07 -0400
Subject: Re: [PATCH] cfg80211: make action channel type optional
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: John Linville <linville@tuxdriver.com>, Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1274293152.8463.2.camel@mj>
References: <1274264232.3874.7.camel@jlt3.sipsolutions.net>
	 <1274293152.8463.2.camel@mj>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 May 2010 20:48:59 +0200
Message-ID: <1274294939.19404.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-05-19 at 14:19 -0400, Pavel Roskin wrote:
> On Wed, 2010-05-19 at 12:17 +0200, Johannes Berg wrote:
> 
> > @@ -1168,6 +1168,7 @@ struct cfg80211_ops {
> >  	int	(*action)(struct wiphy *wiphy, struct net_device *dev,
> >  			  struct ieee80211_channel *chan,
> >  			  enum nl80211_channel_type channel_type,
> > +			  bool channel_type_valid,
> >  			  const u8 *buf, size_t len, u64 *cookie);
> 
> Would not it be easier to introduce NL80211_CHAN_UNSPECIFIED in enum
> nl80211_channel_type?

Yes, but it would change the userspace API so we can't do that.

johannes

