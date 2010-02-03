Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:50394 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab0BCBJr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2010 20:09:47 -0500
Received: by bwz19 with SMTP id 19so664350bwz.28
        for <linux-wireless@vger.kernel.org>; Tue, 02 Feb 2010 17:09:45 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: wey-yi.w.guy@intel.com
Subject: Re: [PATCH 1/1] mac80211: tear down all agg queues when restart/reconfig hw
Date: Wed, 3 Feb 2010 02:09:38 +0100
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
References: <1265158370-14797-1-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1265158370-14797-1-git-send-email-wey-yi.w.guy@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201002030209.38862.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 03 February 2010 01:52:50 wey-yi.w.guy@intel.com wrote:
> From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> 
> When there is a need to restart/reconfig hw, tear down all the
> aggregation queues and let the mac80211 and driver get in-sync and have
> the opportunity to re-establish the aggregation queues.
> 
> Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---
>  net/mac80211/util.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index ca170b4..6116ad0 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -1188,6 +1188,11 @@ int ieee80211_reconfig(struct ieee80211_local *local)
>  	ieee80211_wake_queues_by_reason(hw,
>  			IEEE80211_QUEUE_STOP_REASON_SUSPEND);
>  
> +	if (hw->flags & IEEE80211_HW_AMPDU_AGGREGATION) {
> +		list_for_each_entry_rcu(sta, &local->sta_list, list) {
> +			ieee80211_sta_tear_down_BA_sessions(sta);
> +		}
> +	}
hmm, I somehow miss the rcu_read_lock(); and rcu_read_unlock(); around
list_for_each_entry_rcu... Are you really sure that you don't need
them?

Regards,
	Chr
