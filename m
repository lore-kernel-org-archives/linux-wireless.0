Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40808 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538Ab1I0Lnu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 07:43:50 -0400
Subject: Re: [PATCH 1/5] nl80211: support sending TDLS commands/frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Kalyan C Gaddam <chakkal@iit.edu>
In-Reply-To: <1317034493-5300-2-git-send-email-arik@wizery.com> (sfid-20110926_125509_597206_8931C85C)
References: <1317034493-5300-1-git-send-email-arik@wizery.com>
	 <1317034493-5300-2-git-send-email-arik@wizery.com>
	 (sfid-20110926_125509_597206_8931C85C)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Sep 2011 13:43:45 +0200
Message-ID: <1317123825.4082.15.camel@jlt3.sipsolutions.net> (sfid-20110927_134357_978573_E4CE0F3E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-09-26 at 13:54 +0300, Arik Nemtsov wrote:

> @@ -876,6 +884,8 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
>  	}
>  	CMD(set_channel, SET_CHANNEL);
>  	CMD(set_wds_peer, SET_WDS_PEER);
> +	CMD(tdls_mgmt, TDLS_MGMT);

Should that maybe depend on the TLDS_EXTERNAL_SETUP flag to avoid
inconsistencies? Especially with mac80211 drivers?

> +	CMD(tdls_oper, TDLS_OPER);

and maybe not advertise that if TDLS isn't support -- in particular so
that mac80211 drivers don't advertise it even though mac80211 might have
the hook.

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
> +	    !info->attrs[NL80211_ATTR_IE] ||
> +	    !info->attrs[NL80211_ATTR_MAC])
> +		return -EINVAL;
> +
> +	peer = nla_data(info->attrs[NL80211_ATTR_MAC]);
> +	action_code = nla_get_u8(info->attrs[NL80211_ATTR_TDLS_ACTION]);
> +	status_code = nla_get_u16(info->attrs[NL80211_ATTR_STATUS_CODE]);
> +	dialog_token = nla_get_u8(info->attrs[NL80211_ATTR_TDLS_DIALOG_TOKEN]);
> +
> +	return rdev->ops->tdls_mgmt(&rdev->wiphy, dev, peer, action_code,
> +				    dialog_token, status_code,
> +				    nla_data(info->attrs[NL80211_ATTR_IE]),
> +				    nla_len(info->attrs[NL80211_ATTR_IE]));
> +}

Shouldn't that return an error if TDLS_EXTERNAL_SETUP isn't set? At
least for some operations?


> +static int nl80211_tdls_oper(struct sk_buff *skb, struct genl_info *info)
> +{
> +	struct cfg80211_registered_device *rdev = info->user_ptr[0];
> +	struct net_device *dev = info->user_ptr[1];
> +	enum nl80211_tdls_operation operation;
> +	u8 *peer;
> +
> +	if (!rdev->ops->tdls_oper)
> +		return -EOPNOTSUPP;
> +
> +	if (!info->attrs[NL80211_ATTR_TDLS_OPERATION] ||
> +	    !info->attrs[NL80211_ATTR_MAC])
> +		return -EINVAL;
> +
> +	operation = nla_get_u8(info->attrs[NL80211_ATTR_TDLS_OPERATION]);
> +	peer = nla_data(info->attrs[NL80211_ATTR_MAC]);
> +
> +	return rdev->ops->tdls_oper(&rdev->wiphy, dev, peer, operation);
> +}

Ditto here, if TDLS isn't supported it needs to return an error I think,
and if TLDS needs external setup it needs to return errors for the setup
operations I think?

johannes

