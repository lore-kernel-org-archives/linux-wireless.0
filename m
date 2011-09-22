Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from spamblock-2.iit.edu ([216.47.143.128]:38137 "EHLO
	spamblock-2.iit.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab1IVAw2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 20:52:28 -0400
Received: from atlas-v-iv.iit.edu (atlas-p.iit.edu [216.47.143.155]) by spamblock-2.iit.edu with ESMTP id z5dQrZODvElWvAYd for <linux-wireless@vger.kernel.org>; Wed, 21 Sep 2011 19:34:16 -0500 (CDT)
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Received: from iit.edu (localhost [127.0.0.1])
 by atlas-v.iit.edu (Sun Java(tm) System Messaging Server 6.3-4.01 (built Aug
 3 2007; 32bit)) with ESMTP id <0LRW0023VF0M0G00@atlas-v.iit.edu> for
 linux-wireless@vger.kernel.org; Wed, 21 Sep 2011 19:36:22 -0500 (CDT)
From: Kalyan Chakravarthy <chakkal@iit.edu>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org
Message-id: <fac0da2d1631a.4e7a4ac6@iit.edu> (sfid-20110922_025236_246445_176688D3)
Date: Wed, 21 Sep 2011 20:36:22 -0400
Subject: Re: [RFC 1/5] nl80211: support sending TDLS commands/frames
In-reply-to: <1316606076.3940.19.camel@jlt3.sipsolutions.net>
References: <1316082334-7664-1-git-send-email-arik@wizery.com>
 <1316082334-7664-2-git-send-email-arik@wizery.com>
 <1316606076.3940.19.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I thought ATTR_FRAME would be more appropriate since it carries multiple IE's, such as RSN, FTIE etc.

----- Original Message -----
From: Johannes Berg <johannes@sipsolutions.net>
Date: Wednesday, September 21, 2011 7:54 am
Subject: Re: [RFC 1/5] nl80211: support sending TDLS commands/frames

> On Thu, 2011-09-15 at 13:25 +0300, Arik Nemtsov wrote:
> 
> > +static int nl80211_tdls_mgmt(struct sk_buff *skb, struct 
> genl_info *info)
> > +{
> > +	struct cfg80211_registered_device *rdev = info->user_ptr[0];
> > +	struct net_device *dev = info->user_ptr[1];
> > +	u8 action_code, dialog_token;
> > +	u16 status_code;
> > +	u8 *peer;
> > +
> > +	if (!rdev->ops->tdls_mgmt)
> > +        	return -EOPNOTSUPP;
> > +
> > +	if (!info->attrs[NL80211_ATTR_TDLS_ACTION] ||
> > +            !info->attrs[NL80211_ATTR_STATUS_CODE] ||
> > +            !info->attrs[NL80211_ATTR_TDLS_DIALOG_TOKEN] ||
> > +            !info->attrs[NL80211_ATTR_FRAME] ||
> > +            !info->attrs[NL80211_ATTR_MAC])
> > +        	return -EINVAL;
> 
> Should that really use ATTR_FRAME as opposed to ATTR_IE?
> 
> johannes
> 
> 
