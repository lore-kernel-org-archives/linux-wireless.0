Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:33373 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754368AbcIPLJB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Sep 2016 07:09:01 -0400
Received: by mail-pf0-f172.google.com with SMTP id 21so15846582pfy.0
        for <linux-wireless@vger.kernel.org>; Fri, 16 Sep 2016 04:09:01 -0700 (PDT)
Subject: Re: [PATCH v2 2/9] mac80211: add boilerplate code for start / stop
 NAN
To: Luca Coelho <luca@coelho.fi>, johannes@sipsolutions.net
References: <20160916083321.5840-1-luca@coelho.fi>
 <20160916083321.5840-3-luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Ayala Beker <ayala.beker@intel.com>,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <fae482d0-4bcd-6b06-9846-298a3218ab26@broadcom.com> (sfid-20160916_130905_684529_2E358A51)
Date: Fri, 16 Sep 2016 13:08:50 +0200
MIME-Version: 1.0
In-Reply-To: <20160916083321.5840-3-luca@coelho.fi>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16-9-2016 10:33, Luca Coelho wrote:
> From: Ayala Beker <ayala.beker@intel.com>
> 
> This code doesn't do much besides allowing to start and
> stop the vif.
> 
> Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Signed-off-by: Ayala Beker <ayala.beker@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> ---
>  include/net/mac80211.h    |  9 +++++++++
>  net/mac80211/cfg.c        | 36 ++++++++++++++++++++++++++++++++++
>  net/mac80211/chan.c       |  3 +++
>  net/mac80211/driver-ops.h | 29 ++++++++++++++++++++++++++-
>  net/mac80211/iface.c      |  8 ++++++--
>  net/mac80211/main.c       |  5 +++++
>  net/mac80211/offchannel.c |  3 ++-
>  net/mac80211/trace.h      | 50 +++++++++++++++++++++++++++++++++++++++++++++++
>  net/mac80211/util.c       |  3 ++-
>  9 files changed, 141 insertions(+), 5 deletions(-)

[...]

> diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
> index fe35a1c..67b42c8 100644
> --- a/net/mac80211/driver-ops.h
> +++ b/net/mac80211/driver-ops.h
> @@ -163,7 +163,8 @@ static inline void drv_bss_info_changed(struct ieee80211_local *local,
>  
>  	if (WARN_ON_ONCE(sdata->vif.type == NL80211_IFTYPE_P2P_DEVICE ||
>  			 (sdata->vif.type == NL80211_IFTYPE_MONITOR &&
> -			  !sdata->vif.mu_mimo_owner)))
> +			  !sdata->vif.mu_mimo_owner) ||
> +			 sdata->vif.type == NL80211_IFTYPE_NAN))

Might be more clear to move this up right after P2P_DEVICE check.

>  		return;
>  
>  	if (!check_sdata_in_driver(sdata))
> @@ -1165,4 +1166,30 @@ static inline void drv_wake_tx_queue(struct ieee80211_local *local,
>  	local->ops->wake_tx_queue(&local->hw, &txq->txq);
>  }
>  
> +static inline int drv_start_nan(struct ieee80211_local *local,
> +				struct ieee80211_sub_if_data *sdata,
> +				struct cfg80211_nan_conf *conf)
> +{
> +	int ret;
> +
> +	might_sleep();
> +	check_sdata_in_driver(sdata);
> +
> +	trace_drv_start_nan(local, sdata, conf);
> +	ret = local->ops->start_nan(&local->hw, &sdata->vif, conf);
> +	trace_drv_return_int(local, ret);
> +	return ret;
> +}
> +
> +static inline void drv_stop_nan(struct ieee80211_local *local,
> +				struct ieee80211_sub_if_data *sdata)
> +{
> +	might_sleep();
> +	check_sdata_in_driver(sdata);
> +
> +	trace_drv_stop_nan(local, sdata);
> +	local->ops->stop_nan(&local->hw, &sdata->vif);
> +	trace_drv_return_void(local);
> +}
> +
>  #endif /* __MAC80211_DRIVER_OPS */
> diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
> index e694ca2..507f46a 100644
> --- a/net/mac80211/iface.c
> +++ b/net/mac80211/iface.c
> @@ -327,6 +327,9 @@ static int ieee80211_check_queues(struct ieee80211_sub_if_data *sdata,
>  	int n_queues = sdata->local->hw.queues;
>  	int i;
>  
> +	if (iftype == NL80211_IFTYPE_NAN)
> +		return 0;
> +
>  	if (iftype != NL80211_IFTYPE_P2P_DEVICE) {
>  		for (i = 0; i < IEEE80211_NUM_ACS; i++) {
>  			if (WARN_ON_ONCE(sdata->vif.hw_queue[i] ==
> @@ -647,7 +650,8 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
>  			local->fif_probe_req++;
>  		}
>  
> -		if (sdata->vif.type != NL80211_IFTYPE_P2P_DEVICE)
> +		if (sdata->vif.type != NL80211_IFTYPE_P2P_DEVICE &&
> +		    sdata->vif.type != NL80211_IFTYPE_NAN)

similar check keeps reoccuring in various places so maybe we can create
a helper function for it.

>  			changed |= ieee80211_reset_erp_info(sdata);
>  		ieee80211_bss_info_change_notify(sdata, changed);
>  

Regards,
Arend
