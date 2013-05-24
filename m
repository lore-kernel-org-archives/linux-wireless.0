Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40964 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048Ab3EXV7C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 May 2013 17:59:02 -0400
Message-ID: <1369432740.13623.12.camel@johannes> (sfid-20130524_235906_998997_F13D757F)
Subject: Re: [PATCH 3/3] {nl,mac,cfg}80211: Allow user to configure basic
 rates for mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Ashok Nagarajan <ashok@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org
Date: Fri, 24 May 2013 23:59:00 +0200
In-Reply-To: <1368233453-10581-3-git-send-email-ashok@cozybit.com> (sfid-20130511_025109_843981_AF868450)
References: <1368233453-10581-1-git-send-email-ashok@cozybit.com>
	 <1368233453-10581-3-git-send-email-ashok@cozybit.com>
	 (sfid-20130511_025109_843981_AF868450)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry for leaving this open for so long. I think it didn't hurt since
the merge window was open anyway.

> + * @basic_rates: per-band bitmap of basic rates to use when creating the mesh

Does per-band really make sense? The mesh channel is also determined at
join time.

>  static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
>  {
>  	struct cfg80211_registered_device *rdev = info->user_ptr[0];
> @@ -7460,6 +7487,22 @@ static int nl80211_join_mesh(struct sk_buff *skb, struct genl_info *info)
>  			    nla_get_u32(info->attrs[NL80211_ATTR_MCAST_RATE])))
>  			return -EINVAL;
>  
> +	if (info->attrs[NL80211_ATTR_BSS_BASIC_RATES]) {

I think you should consider allowing this attribute only if the channel
is also specified (NL80211_ATTR_WIPHY_FREQ, parsed below), and not make
it nested with rates for both bands but just the selected band.

johannes

