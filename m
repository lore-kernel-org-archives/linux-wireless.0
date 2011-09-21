Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60374 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab1IULyl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 07:54:41 -0400
Subject: Re: [RFC 1/5] nl80211: support sending TDLS commands/frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Kalyan C Gaddam <chakkal@iit.edu>
In-Reply-To: <1316082334-7664-2-git-send-email-arik@wizery.com> (sfid-20110915_123212_984058_7E58D247)
References: <1316082334-7664-1-git-send-email-arik@wizery.com>
	 <1316082334-7664-2-git-send-email-arik@wizery.com>
	 (sfid-20110915_123212_984058_7E58D247)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Sep 2011 13:54:36 +0200
Message-ID: <1316606076.3940.19.camel@jlt3.sipsolutions.net> (sfid-20110921_135444_730694_3EA60747)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-09-15 at 13:25 +0300, Arik Nemtsov wrote:

> +static int nl80211_tdls_mgmt(struct sk_buff *skb, struct genl_info *info)
> +{
> +	struct cfg80211_registered_device *rdev = info->user_ptr[0];
> +	struct net_device *dev = info->user_ptr[1];
> +	u8 action_code, dialog_token;
> +	u16 status_code;
> +	u8 *peer;
> +
> +	if (!rdev->ops->tdls_mgmt)
> +		return -EOPNOTSUPP;
> +
> +	if (!info->attrs[NL80211_ATTR_TDLS_ACTION] ||
> +	    !info->attrs[NL80211_ATTR_STATUS_CODE] ||
> +	    !info->attrs[NL80211_ATTR_TDLS_DIALOG_TOKEN] ||
> +	    !info->attrs[NL80211_ATTR_FRAME] ||
> +	    !info->attrs[NL80211_ATTR_MAC])
> +		return -EINVAL;

Should that really use ATTR_FRAME as opposed to ATTR_IE?

johannes

