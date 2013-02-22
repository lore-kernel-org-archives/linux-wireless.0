Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60389 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756329Ab3BVUgj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 15:36:39 -0500
Message-ID: <1361565394.3420.17.camel@jlt4.sipsolutions.net> (sfid-20130222_213643_023037_9CD1475B)
Subject: Re: [PATCH] cfg80211: Extend support for IEEE 802.11r Fast BSS
 Transition
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 22 Feb 2013 21:36:34 +0100
In-Reply-To: <20130221060843.GA24491@w1.fi>
References: <20130221060843.GA24491@w1.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-20 at 22:08 -0800, Jouni Malinen wrote:


> +int cfg80211_ft_event(struct net_device *dev,
> +                     struct cfg80211_ft_event_params *ft_event);

Is the return value really very useful?


> +static int nl80211_update_ft_ies(struct sk_buff *skb, struct genl_info *info)
> +{
> +	struct cfg80211_registered_device *rdev = info->user_ptr[0];
> +	struct cfg80211_update_ft_ies_params ft_params;
> +	struct net_device *dev = info->user_ptr[1];
> +
> +	if (!rdev->ops->update_ft_ies)
> +		return -EOPNOTSUPP;
> +
> +	if (!info->attrs[NL80211_ATTR_MDID] || !info->attrs[NL80211_ATTR_IE])
> +		return -EINVAL;
> +
> +	memset(&ft_params, 0, sizeof(ft_params));
> +	ft_params.md = nla_get_u16(info->attrs[NL80211_ATTR_MDID]);
> +	ft_params.ie = nla_data(info->attrs[NL80211_ATTR_IE]);
> +	ft_params.ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);

Should this use is_valid_ie_attr()?

> +int cfg80211_ft_event(struct net_device *dev,
> +                     struct cfg80211_ft_event_params *ft_event)
> +{
> +       struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
> +       struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
> +
> +       return nl80211_ft_event(rdev, dev, ft_event);
> +}
> +EXPORT_SYMBOL(cfg80211_ft_event);

FWIW, I don't really see the need to have separate functions. I know we
have a whole bunch like that, but I think I'm just going to remove them
now. There's really no point, nl80211 and cfg80211 are two sides of the
same thing, I'd just put the cfg80211_ function into nl80211.c


> +	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_FT_EVENT);
> +	if (!hdr) {
> +		nlmsg_free(msg);
> +		return -ENOMEM;
> +	}
> +
> +	nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx);
> +	nla_put_u32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex);
> +	if (ft_event->target_ap)
> +		nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, ft_event->target_ap);

Would that really be valid without a new BSSID? That seems a bit odd.

johannes

