Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59620 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758788AbbCDIOq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2015 03:14:46 -0500
Message-ID: <1425456879.1810.1.camel@sipsolutions.net> (sfid-20150304_091458_205968_DC709BEC)
Subject: Re: [RFC 1/2] nl80211: Add support to configure low ack threshold
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Wed, 04 Mar 2015 09:14:39 +0100
In-Reply-To: <1425385383-25482-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1425385383-25482-1-git-send-email-rmanohar@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-03-03 at 17:53 +0530, Rajkumar Manoharan wrote:

> @@ -696,6 +698,7 @@ struct cfg80211_ap_settings {
>  	u8 p2p_ctwindow;
>  	bool p2p_opp_ps;
>  	const struct cfg80211_acl_data *acl;
> +	int low_ack_threshold;

should probably be unsigned?

>  };
>  
>  /**
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index 68b294e..40df4b1 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -219,7 +219,8 @@
>   *	%NL80211_ATTR_CIPHER_GROUP, %NL80211_ATTR_WPA_VERSIONS,
>   *	%NL80211_ATTR_AKM_SUITES, %NL80211_ATTR_PRIVACY,
>   *	%NL80211_ATTR_AUTH_TYPE, %NL80211_ATTR_INACTIVITY_TIMEOUT,
> - *	%NL80211_ATTR_ACL_POLICY and %NL80211_ATTR_MAC_ADDRS.
> + *	%NL80211_ATTR_ACL_POLICY and %NL80211_ATTR_MAC_ADDRS
> + *	%NL80211_ATTR_LOW_ACK_THRESH.
>   *	The channel to use can be set on the interface or be given using the
>   *	%NL80211_ATTR_WIPHY_FREQ and the attributes determining channel width.
>   * @NL80211_CMD_NEW_BEACON: old alias for %NL80211_CMD_START_AP
> @@ -1740,6 +1741,9 @@ enum nl80211_commands {
>   * @NL80211_ATTR_SCHED_SCAN_DELAY: delay before a scheduled scan (or a
>   *	WoWLAN net-detect scan) is started, u32 in seconds.
>   *
> + * @NL80211_ATTR_LOW_ACK_THRESH: number of consecutive frames that are not ACKed
> + *	by station. This threshold is used to generate low ack event by driver.
> + *
>   * @NUM_NL80211_ATTR: total number of nl80211_attrs available
>   * @NL80211_ATTR_MAX: highest attribute number currently defined
>   * @__NL80211_ATTR_AFTER_LAST: internal use
> @@ -2107,6 +2111,8 @@ enum nl80211_attrs {
>  
>  	NL80211_ATTR_SCHED_SCAN_DELAY,
>  
> +	NL80211_ATTR_LOW_ACK_THRESH,
> +
>  	/* add attributes here, update the policy in nl80211.c */
>  
>  	__NL80211_ATTR_AFTER_LAST,
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index e9ad9d9..80a90c7 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -399,6 +399,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
>  	[NL80211_ATTR_WIPHY_SELF_MANAGED_REG] = { .type = NLA_FLAG },
>  	[NL80211_ATTR_NETNS_FD] = { .type = NLA_U32 },
>  	[NL80211_ATTR_SCHED_SCAN_DELAY] = { .type = NLA_U32 },
> +	[NL80211_ATTR_LOW_ACK_THRESH] = { .type = NLA_U16 },
>  };
>  
>  /* policy for the key attributes */
> @@ -3434,6 +3435,11 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
>  		params.smps_mode = NL80211_SMPS_OFF;
>  	}
>  
> +	if (info->attrs[NL80211_ATTR_LOW_ACK_THRESH]) {
> +		params.low_ack_threshold = nla_get_u16(
> +			info->attrs[NL80211_ATTR_LOW_ACK_THRESH]);
> +	}

I think you should provide a sane default value if userspace doesn't
request anything. Also - braces aren't needed here.

johannes

