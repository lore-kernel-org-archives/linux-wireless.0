Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44579 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab1KXPPX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 10:15:23 -0500
Subject: Re: [PATCH 1/7] {nl,cfg,mac}80211: Allow Setting Multicast Rate in
 Mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>, linville@tuxdriver.com
In-Reply-To: <1322080347-7644-2-git-send-email-thomas@cozybit.com> (sfid-20111123_213313_268163_2293C7FE)
References: <1322080347-7644-1-git-send-email-thomas@cozybit.com>
	 <1322080347-7644-2-git-send-email-thomas@cozybit.com>
	 (sfid-20111123_213313_268163_2293C7FE)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Nov 2011 16:15:16 +0100
Message-ID: <1322147716.5366.22.camel@jlt3.sipsolutions.net> (sfid-20111124_161528_611097_5CD6D131)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-11-23 at 12:32 -0800, Thomas Pedersen wrote:

> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -5648,6 +5648,11 @@ static int nl80211_join_mesh(struct sk_buff *skb, struct genl_info *info)
>  	setup.mesh_id = nla_data(info->attrs[NL80211_ATTR_MESH_ID]);
>  	setup.mesh_id_len = nla_len(info->attrs[NL80211_ATTR_MESH_ID]);
>  
> +	if (info->attrs[NL80211_ATTR_MCAST_RATE] &&
> +		!nl80211_parse_mcast_rate(rdev, setup.mcast_rate,
> +		nla_get_u32(info->attrs[NL80211_ATTR_MCAST_RATE])))
> +			return -EINVAL;

That could use some better indentation ...

johannes

