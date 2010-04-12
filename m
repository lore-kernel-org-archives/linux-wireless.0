Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:56205 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab0DLJA1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Apr 2010 05:00:27 -0400
Subject: Re: [RFC PATCH] nl80211: Add support for dynamic ps timeout
 configuration
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	=?ISO-8859-1?Q?Yl=E4lehto?= Janne Jouko
	<janne.ylalehto@nokia.com>
In-Reply-To: <1271061120.3877.6.camel@jlt3.sipsolutions.net>
References: <1271059902-27788-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1271061120.3877.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Apr 2010 11:56:29 +0300
Message-ID: <1271062589.10120.1169.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-04-12 at 10:32 +0200, ext Johannes Berg wrote:
> On Mon, 2010-04-12 at 11:11 +0300, Juuso Oikarinen wrote:
> > This adds support to configure the dynamic ps timeout via nl80211. The
> > relevant attribute is added to NL80211_CMD_SET_POWER_SAVE.
> 
> I'm not sure we even want this. Can't we calculate an appropriate value
> based on the beacon interval etc. instead?

We could obviously do that. This patch does not prevent adding
functionality ;)

The problem in relying solely on that kind of algorithm just is that
reaching a value suiting all types of device in all situations would be
hard.

For desktops, obviously reduced latency is desirable, while increased
power consumption is not so much of an issue. For hand-held devices the
situation is often the opposite: in many situations we might want to
sacrifice some latency just to stretch the battery life that last inch
longer, possibly depending on the type of traffic we know we have going
on.

Therefore I feel we need to give user-space the opportunity to configure
this timeout, one way or other.

-Juuso



> johannes
> 
> > Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> > ---
> >  include/linux/nl80211.h |    2 ++
> >  net/wireless/nl80211.c  |   16 +++++++++++++++-
> >  2 files changed, 17 insertions(+), 1 deletions(-)
> > 
> > diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
> > index 2ea3ede..c5f12e7 100644
> > --- a/include/linux/nl80211.h
> > +++ b/include/linux/nl80211.h
> > @@ -864,6 +864,8 @@ enum nl80211_attrs {
> >  
> >  	NL80211_ATTR_LOCAL_STATE_CHANGE,
> >  
> > +	NL80211_ATTR_PS_TIMEOUT,
> > +
> >  	/* add attributes here, update the policy in nl80211.c */
> >  
> >  	__NL80211_ATTR_AFTER_LAST,
> > diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> > index df5505b..709bda3 100644
> > --- a/net/wireless/nl80211.c
> > +++ b/net/wireless/nl80211.c
> > @@ -151,6 +151,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
> >  	[NL80211_ATTR_PS_STATE] = { .type = NLA_U32 },
> >  	[NL80211_ATTR_CQM] = { .type = NLA_NESTED, },
> >  	[NL80211_ATTR_LOCAL_STATE_CHANGE] = { .type = NLA_FLAG },
> > +	[NL80211_ATTR_PS_TIMEOUT] = { .type = NLA_U32 },
> >  };
> >  
> >  /* policy for the attributes */
> > @@ -4682,6 +4683,7 @@ static int nl80211_set_power_save(struct sk_buff *skb, struct genl_info *info)
> >  	struct net_device *dev;
> >  	u8 ps_state;
> >  	bool state;
> > +	int timeout = -1;
> >  	int err;
> >  
> >  	if (!info->attrs[NL80211_ATTR_PS_STATE]) {
> > @@ -4696,6 +4698,14 @@ static int nl80211_set_power_save(struct sk_buff *skb, struct genl_info *info)
> >  		goto out;
> >  	}
> >  
> > +	if (info->attrs[NL80211_ATTR_PS_TIMEOUT]) {
> > +		timeout = nla_get_u32(info->attrs[NL80211_ATTR_PS_TIMEOUT]);
> > +		if (timeout < 0) {
> > +			err = -EINVAL;
> > +			goto out;
> > +		}
> > +	}
> > +
> >  	rtnl_lock();
> >  
> >  	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
> > @@ -4710,11 +4720,14 @@ static int nl80211_set_power_save(struct sk_buff *skb, struct genl_info *info)
> >  	}
> >  
> >  	state = (ps_state == NL80211_PS_ENABLED) ? true : false;
> > +	if (timeout < 0)
> > +		timeout = wdev->ps_timeout;
> >  
> > -	if (state == wdev->ps)
> > +	if (state == wdev->ps && timeout == wdev->ps_timeout)
> >  		goto unlock_rdev;
> >  
> >  	wdev->ps = state;
> > +	wdev->ps_timeout = timeout;
> >  
> >  	if (rdev->ops->set_power_mgmt(wdev->wiphy, dev, wdev->ps,
> >  				      wdev->ps_timeout))
> > @@ -4772,6 +4785,7 @@ static int nl80211_get_power_save(struct sk_buff *skb, struct genl_info *info)
> >  		ps_state = NL80211_PS_DISABLED;
> >  
> >  	NLA_PUT_U32(msg, NL80211_ATTR_PS_STATE, ps_state);
> > +	NLA_PUT_U32(msg, NL80211_ATTR_PS_TIMEOUT, wdev->ps_timeout);
> >  
> >  	genlmsg_end(msg, hdr);
> >  	err = genlmsg_reply(msg, info);
> 
> 


