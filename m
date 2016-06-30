Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:34983 "EHLO
	mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbcF3LLR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2016 07:11:17 -0400
Received: by mail-qk0-f195.google.com with SMTP id b136so15736434qkg.2
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jun 2016 04:11:16 -0700 (PDT)
Date: Thu, 30 Jun 2016 07:11:10 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Masashi Honma <masashi.honma@gmail.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org, j@w1.fi
Subject: Re: [PATCH] cfg80211: Add mesh peer AID setting API
Message-ID: <20160630111110.GF9984@localhost> (sfid-20160630_131120_444337_2BF9962F)
References: <1467277258-2331-1-git-send-email-masashi.honma@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1467277258-2331-1-git-send-email-masashi.honma@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 30, 2016 at 06:00:58PM +0900, Masashi Honma wrote:
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 7bbb00d..2fa5896 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -805,6 +805,7 @@ struct station_parameters {
>  	u32 sta_modify_mask;
>  	int listen_interval;
>  	u16 aid;
> +	u16 mesh_aid;

Let's call it peer_aid or mesh_peer_aid or something like that, per my
email on hostapd list.  Also you probably saw kbuild robot pointed out
missing documentation for the field.

> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index c503e96..f41fb61 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -4410,6 +4410,9 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
>  			nla_get_u8(info->attrs[NL80211_ATTR_STA_PLINK_STATE]);
>  		if (params.plink_state >= NUM_NL80211_PLINK_STATES)
>  			return -EINVAL;
> +		if (info->attrs[NL80211_ATTR_MESH_PEER_AID])
> +			params.mesh_aid = nla_get_u16(
> +				info->attrs[NL80211_ATTR_MESH_PEER_AID]);

We need a check against IEEE80211_MAX_AID somewhere.

-- 
Bob Copeland %% http://bobcopeland.com/
