Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51661 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030405Ab2K3MGz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2012 07:06:55 -0500
Message-ID: <1354277238.10035.18.camel@jlt4.sipsolutions.net> (sfid-20121130_130659_276297_BB3DB2A3)
Subject: Re: [RFCv2 06/13] {cfg,nl}80211: allow userspace to set the local
 link-specific power mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Cc: javier@cozybit.com, thomas@cozybit.com,
	linux-wireless@vger.kernel.org,
	Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>,
	Mike Krinkin <krinkin.m.u@gmail.com>
Date: Fri, 30 Nov 2012 13:07:18 +0100
In-Reply-To: <1353701934-12752-7-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353701934-12752-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
	 <1353701934-12752-7-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-23 at 12:18 -0800, Marco Porsch wrote:
> The local link-specific power mode defines the mesh power mode in which the
> local STA operates towards the peer STA of the corresponding mesh peering.
> 
> The idea behind link-specific power modes it that a node in low power mode may
> set a single link to active mode to transport data, without having to notify
> the surrounding peers (+ following routing updates, ...). This commit allows
> userspace to set these local per-link power modes.
> 
> Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
> Signed-off-by: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
> Signed-off-by: Mike Krinkin <krinkin.m.u@gmail.com>
> ---
>  include/net/cfg80211.h       |    2 ++
>  include/uapi/linux/nl80211.h |    5 +++++
>  net/mac80211/cfg.c           |    4 ++++
>  net/wireless/nl80211.c       |   16 ++++++++++++++++
>  4 files changed, 27 insertions(+)
> 
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index cc61b4b..6eb0a6b 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -506,6 +506,7 @@ enum station_parameters_apply_mask {
>   * @sta_modify_mask: bitmap indicating which parameters changed
>   *	(for those that don't have a natural "no change" value),
>   *	see &enum station_parameters_apply_mask
> + * @local_ps_mode: local link-specific mesh power save mode

"no change when set to unknown" ...

> +		if (params->local_ps_mode)

I'd prefer explicitly != UNKNOWN

> @@ -3100,6 +3100,18 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
>  		params.plink_state =
>  		    nla_get_u8(info->attrs[NL80211_ATTR_STA_PLINK_STATE]);
>  
> +	if (info->attrs[NL80211_ATTR_LOCAL_MESH_POWER_MODE]) {
> +		enum nl80211_mesh_power_mode pm = nla_get_u8(
> +			info->attrs[NL80211_ATTR_LOCAL_MESH_POWER_MODE]);
> +
> +		if (pm <= NL80211_MESH_POWER_UNKNOWN ||
> +		    pm >= __NL80211_MESH_POWER_AFTER_LAST)
> +			return -EINVAL;

> NL80211_MESH_POWER_MAX seems much easier to understand

> +		params.local_ps_mode =
> +			nla_get_u8(info->attrs[NL80211_ATTR_LOCAL_MESH_POWER_MODE]);

= pm?

Also isn't it allowed to add stations to a mesh interface (SAE daemon)?
Shouldn't it be allowed to be set there as well?

johannes

