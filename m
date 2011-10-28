Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37927 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073Ab1J1IIr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Oct 2011 04:08:47 -0400
Subject: Re: [wireless-next PATCH 1/5] mac80211: Support forcing station to
 disable 11n.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1319778680-11405-1-git-send-email-greearb@candelatech.com> (sfid-20111028_071135_777672_88A08497)
References: <1319778680-11405-1-git-send-email-greearb@candelatech.com>
	 (sfid-20111028_071135_777672_88A08497)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Oct 2011 10:08:38 +0200
Message-ID: <1319789318.3914.10.camel@jlt3.sipsolutions.net> (sfid-20111028_100851_693151_4602C870)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-10-27 at 22:11 -0700, greearb@candelatech.com wrote:

> The additional netlink bits is to allow this patch to work on 3.0
> and should not be included in the final patch.

What additional bit?


> + * @NL80211_ATTR_DISABLE_80211N:  Force /n capable stations to instead
> + *      function as /a/b/g stations.

IMHO this should be called DISABLE_HT -- "11n" will not exist for much
longer.

> +++ b/net/mac80211/cfg.c
> @@ -57,6 +57,9 @@ static int ieee80211_change_iface(struct wiphy *wiphy,
>  	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
>  	int ret;
>  
> +	if (params->disable_11n != -1)
> +		sdata->cfg_disable_11n = params->disable_11n;

This doesn't seem right -- why change the iface for it? It's a per
connection parameter.

> +++ b/net/mac80211/ieee80211_i.h
> @@ -595,6 +595,8 @@ struct ieee80211_sub_if_data {
>  	/* to detect idle changes */
>  	bool old_idle;
>  
> +	bool cfg_disable_11n; /* configured to disable 11n? */

That should be in the u.mgd part of the struct.

> +++ b/net/wireless/nl80211.c
> @@ -1641,6 +1641,13 @@ static int nl80211_set_interface(struct sk_buff *skb, struct genl_info *info)
>  		change = true;
>  	}
>  
> +	if (info->attrs[NL80211_ATTR_DISABLE_11N]) {
> +		params.disable_11n = !!nla_get_u8(info->attrs[NL80211_ATTR_DISABLE_11N]);
> +		change = true;
> +	} else {
> +		params.disable_11n = -1;
> +	}

This should be a parameter to connect() and assoc(), not a generic
netdev parameter, since it applies to the connection.

Also, it would be good to have a capability check for it etc. since a
lot of fullmac drivers will likely never implement this.

johannes

