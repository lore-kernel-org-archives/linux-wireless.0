Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45341 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab0IWIhA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 04:37:00 -0400
Subject: Re: [mac80211] mac80211:  Support multiple VIFS per AP in debugfs.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@gmail.com
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
In-Reply-To: <1285212541-6834-1-git-send-email-greearb@candelatech.com>
References: <1285212541-6834-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Sep 2010 10:36:58 +0200
Message-ID: <1285231018.3691.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-09-22 at 20:29 -0700, greearb@gmail.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Create 'stations' sub-directory under each netdev:[vif-name]
> directory to hold all stations for that network device.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
> :100644 100644 e81ef4e... ebd5b69... M	net/mac80211/debugfs.c
> :100644 100644 20b2998... 3e12430... M	net/mac80211/debugfs_netdev.c
> :100644 100644 76839d4... 6b7ff9f... M	net/mac80211/debugfs_sta.c
> :100644 100644 9346a6b... 3c7c230... M	net/mac80211/ieee80211_i.h
>  net/mac80211/debugfs.c        |    1 -
>  net/mac80211/debugfs_netdev.c |    3 +++
>  net/mac80211/debugfs_sta.c    |    2 +-
>  net/mac80211/ieee80211_i.h    |    2 +-
>  4 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
> index e81ef4e..ebd5b69 100644
> --- a/net/mac80211/debugfs.c
> +++ b/net/mac80211/debugfs.c
> @@ -368,7 +368,6 @@ void debugfs_hw_add(struct ieee80211_local *local)
>  	if (!phyd)
>  		return;
>  
> -	local->debugfs.stations = debugfs_create_dir("stations", phyd);
>  	local->debugfs.keys = debugfs_create_dir("keys", phyd);
>  
>  	DEBUGFS_ADD(frequency);
> diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
> index 20b2998..3e12430 100644
> --- a/net/mac80211/debugfs_netdev.c
> +++ b/net/mac80211/debugfs_netdev.c
> @@ -409,6 +409,9 @@ void ieee80211_debugfs_add_netdev(struct ieee80211_sub_if_data *sdata)
>  	sprintf(buf, "netdev:%s", sdata->name);
>  	sdata->debugfs.dir = debugfs_create_dir(buf,
>  		sdata->local->hw.wiphy->debugfsdir);
> +	if (sdata->debugfs.dir)
> +		sdata->debugfs.subdir_stations = debugfs_create_dir("stations",
> +			sdata->debugfs.dir);
>  	add_files(sdata);
>  }
>  
> diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
> index 76839d4..6b7ff9f 100644
> --- a/net/mac80211/debugfs_sta.c
> +++ b/net/mac80211/debugfs_sta.c
> @@ -300,7 +300,7 @@ STA_OPS(ht_capa);
>  
>  void ieee80211_sta_debugfs_add(struct sta_info *sta)
>  {
> -	struct dentry *stations_dir = sta->local->debugfs.stations;
> +	struct dentry *stations_dir = sta->sdata->debugfs.subdir_stations;
>  	u8 mac[3*ETH_ALEN];
>  
>  	sta->debugfs.add_has_run = true;
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index 9346a6b..3c7c230 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -564,6 +564,7 @@ struct ieee80211_sub_if_data {
>  #ifdef CONFIG_MAC80211_DEBUGFS
>  	struct {
>  		struct dentry *dir;
> +		struct dentry *subdir_stations;
>  		struct dentry *default_key;
>  		struct dentry *default_mgmt_key;
>  	} debugfs;
> @@ -899,7 +900,6 @@ struct ieee80211_local {
>  #ifdef CONFIG_MAC80211_DEBUGFS
>  	struct local_debugfsdentries {
>  		struct dentry *rcdir;
> -		struct dentry *stations;
>  		struct dentry *keys;
>  	} debugfs;
>  #endif


