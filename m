Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51405 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab0IUGr6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 02:47:58 -0400
Subject: Re: [mac80211] mac80211:  Support multiple VIFS per AP in debugfs.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@gmail.com
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
In-Reply-To: <1285042903-19189-1-git-send-email-greearb@candelatech.com>
References: <1285042903-19189-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Sep 2010 08:48:21 +0200
Message-ID: <1285051701.3710.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-09-20 at 21:21 -0700, greearb@gmail.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> MAC address of AP isn't unique..need to add the device
> name as well.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> :100644 100644 76839d4... 4cf451c... M	net/mac80211/debugfs_sta.c
>  net/mac80211/debugfs_sta.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
> index 76839d4..4cf451c 100644
> --- a/net/mac80211/debugfs_sta.c
> +++ b/net/mac80211/debugfs_sta.c
> @@ -301,14 +301,18 @@ STA_OPS(ht_capa);
>  void ieee80211_sta_debugfs_add(struct sta_info *sta)
>  {
>  	struct dentry *stations_dir = sta->local->debugfs.stations;
> -	u8 mac[3*ETH_ALEN];
> +	u8 mac[3*ETH_ALEN + IFNAMSIZ + 2];
>  
>  	sta->debugfs.add_has_run = true;
>  
>  	if (!stations_dir)
>  		return;
>  
> -	snprintf(mac, sizeof(mac), "%pM", sta->sta.addr);
> +	if (sta->sdata)
> +		snprintf(mac, sizeof(mac), "%pM-%s",
> +			 sta->sta.addr, sta->sdata->name);
> +	else
> +		snprintf(mac, sizeof(mac), "%pM-NULL", sta->sta.addr);

Does that NULL case really happen? I don't think it can, because we
shouldn't be adding this to debugfs before we assign it to an interface?

johannes

