Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60697 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999Ab1BNKV7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 05:21:59 -0500
Subject: Re: [PATCH 3/7] mac80211:  Properly set work-item channel-type.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1297115078-27773-3-git-send-email-greearb@candelatech.com>
References: <1297115078-27773-1-git-send-email-greearb@candelatech.com>
	 <1297115078-27773-3-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 11:21:57 +0100
Message-ID: <1297678917.3785.22.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-02-07 at 13:44 -0800, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Some were indirectly set to NO_HT (zero), but I think
> it's better to explicitly set it in case the enum ever
> changes.  In cfg.c, it seems the channel-type was just
> ignored (and thus always set to NO_HT).

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> :100644 100644 a7cd6a1... 9938f7f... M	net/mac80211/cfg.c
> :100644 100644 340bef6... cd68f2a... M	net/mac80211/mlme.c
>  net/mac80211/cfg.c  |    1 +
>  net/mac80211/mlme.c |    2 ++
>  2 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index a7cd6a1..9938f7f 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -1871,6 +1871,7 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
>  
>  	wk->type = IEEE80211_WORK_OFFCHANNEL_TX;
>  	wk->chan = chan;
> +	wk->chan_type = channel_type;
>  	wk->sdata = sdata;
>  	wk->done = ieee80211_offchan_tx_done;
>  	wk->offchan_tx.frame = skb;
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 340bef6..cd68f2a 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -2294,6 +2294,7 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
>  	else
>  		wk->type = IEEE80211_WORK_DIRECT_PROBE;
>  	wk->chan = req->bss->channel;
> +	wk->chan_type = NL80211_CHAN_NO_HT;
>  	wk->sdata = sdata;
>  	wk->done = ieee80211_probe_auth_done;
>  
> @@ -2443,6 +2444,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
>  		memcpy(wk->assoc.prev_bssid, req->prev_bssid, ETH_ALEN);
>  
>  	wk->chan = req->bss->channel;
> +	wk->chan_type = NL80211_CHAN_NO_HT;
>  	wk->sdata = sdata;
>  	wk->done = ieee80211_assoc_done;
>  	if (!bss->dtim_period &&


