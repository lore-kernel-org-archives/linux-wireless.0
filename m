Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.clemson.edu ([130.127.28.87]:50242 "EHLO CLEMSON.EDU"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758562AbYCEMzU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 07:55:20 -0500
Message-ID: <47CE9787.2050609@clemson.edu> (sfid-20080305_125544_553200_13237E40)
Date: Wed, 05 Mar 2008 07:52:23 -0500
From: Bill Moss <bmoss@CLEMSON.EDU>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH (RFT 2)] mac80211: fix hardware scan completion
References: <1204711120.25502.56.camel@johannes.berg>
In-Reply-To: <1204711120.25502.56.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes, this patch passed all tests. As you say below, John please merge.

Bill Moss

Johannes Berg wrote:
> The mac80211 MLME requires restarting timers after a scan
> completes but this wasn't done when hardware scan offload
> was added, so add it now.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> Cc: Bill Moss <bmoss@clemson.edu>
> Cc: Reinette Chatre <reinette.chatre@intel.com>
> ---
> This is version of the patch with correct locking. Bill, please test
> this. John, please merge if Bill says it's ok.
>
> Sorry, forgot to CC the mailing list.
>
>  net/mac80211/ieee80211_sta.c |   25 ++++++++++++++++++-------
>  1 file changed, 18 insertions(+), 7 deletions(-)
>
> --- everything.orig/net/mac80211/ieee80211_sta.c	2008-03-01 19:28:56.000000000 +0100
> +++ everything/net/mac80211/ieee80211_sta.c	2008-03-05 10:56:31.000000000 +0100
> @@ -3576,6 +3576,13 @@ static void ieee80211_send_nullfunc(stru
>  }
>  
>
> +static void ieee80211_restart_sta_timer(struct ieee80211_sub_if_data *sdata)
> +{
> +	if (sdata->vif.type == IEEE80211_IF_TYPE_STA ||
> +	    ieee80211_vif_is_mesh(&sdata->vif))
> +		ieee80211_sta_timer((unsigned long)sdata);
> +}
> +
>  void ieee80211_scan_completed(struct ieee80211_hw *hw)
>  {
>  	struct ieee80211_local *local = hw_to_local(hw);
> @@ -3589,6 +3596,12 @@ void ieee80211_scan_completed(struct iee
>  
>  	if (local->sta_hw_scanning) {
>  		local->sta_hw_scanning = 0;
> +		/* Restart STA timer for HW scan case */
> +		rcu_read_lock();
> +		list_for_each_entry_rcu(sdata, &local->interfaces, list)
> +			ieee80211_restart_sta_timer(sdata);
> +		rcu_read_unlock();
> +
>  		goto done;
>  	}
>  
> @@ -3615,14 +3628,12 @@ void ieee80211_scan_completed(struct iee
>  		if (sdata->dev == local->mdev)
>  			continue;
>  
> -		if (sdata->vif.type == IEEE80211_IF_TYPE_STA) {
> -			if (sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED)
> -				ieee80211_send_nullfunc(local, sdata, 0);
> -			ieee80211_sta_timer((unsigned long)sdata);
> -		}
> +		/* Tell AP we're back */
> +		if (sdata->vif.type == IEEE80211_IF_TYPE_STA &&
> +		    sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED)
> +			ieee80211_send_nullfunc(local, sdata, 0);
>  
> -		if (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT)
> -			ieee80211_sta_timer((unsigned long)sdata);
> +		ieee80211_restart_sta_timer(sdata);
>  
>  		netif_wake_queue(sdata->dev);
>  	}
>
>
>
>   

-- 
Bill Moss
Alumni Distinguished Professor
Mathematical Sciences
Clemson University

