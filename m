Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40572 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161757Ab3DEODu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 10:03:50 -0400
Message-ID: <515ED9BF.20203@candelatech.com> (sfid-20130405_160354_798124_062EF219)
Date: Fri, 05 Apr 2013 07:03:43 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC V4] cfg80211: introduce critical protocol indication from
 user-space
References: <1365168312-14780-1-git-send-email-arend@broadcom.com>
In-Reply-To: <1365168312-14780-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/05/2013 06:25 AM, Arend van Spriel wrote:
> Some protocols need a more reliable connection to complete
> successful in reasonable time. This patch adds a user-space
> API to indicate the wireless driver that a critical protocol
> is about to commence and when it is done, using nl80211 primitives
> NL80211_CMD_CRIT_PROTOCOL_START and NL80211_CRIT_PROTOCOL_STOP.
>
> There can be only on critical protocol session started per
> registered cfg80211 device. The driver can support this by
> implementing the cfg80211 callbacks .crit_proto_start() and
> .crit_proto_stop(). Examples of protocols that can benefit from
> this are DHCP, EAPOL, APIPA. Exactly how the link can/should be
> made more reliable is up to the driver. Things to consider are
> avoid scanning, no multi-channel operations, and alter coexistence
> schemes.
>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---

> +static int nl80211_crit_protocol_start(struct sk_buff *skb,
> +				       struct genl_info *info)
> +{
> +	struct cfg80211_registered_device *rdev = info->user_ptr[0];
> +	struct wireless_dev *wdev = info->user_ptr[1];
> +	enum nl80211_crit_proto_id proto = NL80211_CRIT_PROTO_UNSPEC;
> +	u16 duration;
> +
> +	if (!rdev->ops->crit_proto_start)
> +		return -EOPNOTSUPP;
> +
> +	if (WARN_ON(!rdev->ops->crit_proto_stop))
> +		return -EINVAL;
> +
> +	if (rdev->crit_proto_started)
> +		return -EBUSY;
> +
> +	/* determine protocol if provided */
> +	if (info->attrs[NL80211_ATTR_CRIT_PROT_ID])
> +		proto = nla_get_u16(info->attrs[NL80211_ATTR_CRIT_PROT_ID]);
> +
> +	if (proto >= NL80211_CRIT_PROTO_LAST)
> +		return -EINVAL;
> +
> +	/* timeout must be provided */
> +	if (!info->attrs[NL80211_ATTR_MAX_CRIT_PROT_DURATION])
> +		return -EINVAL;
> +
> +	duration =
> +		nla_get_u16(info->attrs[NL80211_ATTR_MAX_CRIT_PROT_DURATION]);
> +
> +	duration = max_t(u16, duration, NL80211_MAX_CRIT_PROT_DURATION);

Maybe that should be min_t(....) ?


> +
> +	return rdev_crit_proto_start(rdev, wdev, proto, duration);
> +}
> +
> +static int nl80211_crit_protocol_stop(struct sk_buff *skb,
> +				      struct genl_info *info)
> +{
> +	struct cfg80211_registered_device *rdev = info->user_ptr[0];
> +	struct wireless_dev *wdev = info->user_ptr[1];
> +
> +	if (!rdev->ops->crit_proto_stop)
> +		return -EOPNOTSUPP;
> +
> +	return rdev_crit_proto_stop(rdev, wdev);
> +}
> +
>   #define NL80211_FLAG_NEED_WIPHY		0x01
>   #define NL80211_FLAG_NEED_NETDEV	0x02
>   #define NL80211_FLAG_NEED_RTNL		0x04
> @@ -8885,6 +8939,22 @@ static struct genl_ops nl80211_ops[] = {
>   		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
>   				  NL80211_FLAG_NEED_RTNL,
>   	},
> +	{
> +		.cmd = NL80211_CMD_CRIT_PROTOCOL_START,
> +		.doit = nl80211_crit_protocol_start,
> +		.policy = nl80211_policy,
> +		.flags = GENL_ADMIN_PERM,
> +		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
> +				  NL80211_FLAG_NEED_RTNL,
> +	},
> +	{
> +		.cmd = NL80211_CMD_CRIT_PROTOCOL_STOP,
> +		.doit = nl80211_crit_protocol_stop,
> +		.policy = nl80211_policy,
> +		.flags = GENL_ADMIN_PERM,
> +		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
> +				  NL80211_FLAG_NEED_RTNL,
> +	}
>   };
>
>   static struct genl_multicast_group nl80211_mlme_mcgrp = {
> @@ -10630,6 +10700,16 @@ void cfg80211_ft_event(struct net_device *netdev,
>   }
>   EXPORT_SYMBOL(cfg80211_ft_event);
>
> +void cfg80211_crit_proto_stopped(struct wireless_dev *wdev)
> +{
> +	struct cfg80211_registered_device *rdev;
> +
> +	rdev = wiphy_to_dev(wdev->wiphy);
> +	WARN_ON(!rdev->crit_proto_started);
> +	rdev->crit_proto_started = false;
> +}
> +EXPORT_SYMBOL(cfg80211_crit_proto_stopped);
> +
>   /* initialisation/exit functions */
>
>   int nl80211_init(void)
> diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
> index d77e1c1..a80a7c9 100644
> --- a/net/wireless/rdev-ops.h
> +++ b/net/wireless/rdev-ops.h
> @@ -875,7 +875,7 @@ static inline void rdev_stop_p2p_device(struct cfg80211_registered_device *rdev,
>   	trace_rdev_stop_p2p_device(&rdev->wiphy, wdev);
>   	rdev->ops->stop_p2p_device(&rdev->wiphy, wdev);
>   	trace_rdev_return_void(&rdev->wiphy);
> -}					
> +}
>
>   static inline int rdev_set_mac_acl(struct cfg80211_registered_device *rdev,
>   				   struct net_device *dev,
> @@ -901,4 +901,33 @@ static inline int rdev_update_ft_ies(struct cfg80211_registered_device *rdev,
>   	return ret;
>   }
>
> +static inline int rdev_crit_proto_start(struct cfg80211_registered_device *rdev,
> +					struct wireless_dev *wdev,
> +					enum nl80211_crit_proto_id protocol,
> +					u16 duration)
> +{
> +	int ret;
> +
> +	trace_rdev_crit_proto_start(&rdev->wiphy, wdev, protocol, duration);
> +	ret = rdev->ops->crit_proto_start(&rdev->wiphy, wdev,
> +					  protocol, duration);
> +	rdev->crit_proto_started = !ret;
> +	trace_rdev_return_int(&rdev->wiphy, ret);
> +	return ret;
> +}
> +
> +static inline int rdev_crit_proto_stop(struct cfg80211_registered_device *rdev,
> +				       struct wireless_dev *wdev)
> +{
> +	int ret = 0;
> +
> +	trace_rdev_crit_proto_stop(&rdev->wiphy, wdev);
> +	if (rdev->crit_proto_started) {
> +		ret = rdev->ops->crit_proto_stop(&rdev->wiphy, wdev);
> +		rdev->crit_proto_started = ret != 0;

Maybe:  rdev->crit_proto_started = !ret;


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

