Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34463 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932219Ab0CLLKR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Mar 2010 06:10:17 -0500
Subject: Re: [RFC PATCH 1/1] mac80211: Add ieee80211_probereq_failed
 function
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1268135572-30722-2-git-send-email-juuso.oikarinen@nokia.com>
References: <1268135572-30722-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1268135572-30722-2-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Mar 2010 03:10:06 -0800
Message-ID: <1268392206.4828.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-03-09 at 13:52 +0200, Juuso Oikarinen wrote:
> Some hardware (i.e. the wl1271) are able to monitor beacons, and send
> probe-requests to AP in case of beacon loss independently to try to recover
> the connection. In these cases, it is useless for the mac80211 to send
> further probe-requests.
> 
> Add a new function for the hardware to indicate that the AP has been lost.
> This function immediately tears down the connection.
> 
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> ---
>  include/net/mac80211.h |   12 ++++++++++++
>  net/mac80211/mlme.c    |   32 ++++++++++++++++++++++++++++++++
>  2 files changed, 44 insertions(+), 0 deletions(-)
> 
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 45d7d44..d9792e4 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -2370,6 +2370,18 @@ void ieee80211_sta_block_awake(struct ieee80211_hw *hw,
>   */
>  void ieee80211_beacon_loss(struct ieee80211_vif *vif);
>  
> +/**
> + * ieee80211_probereq_failed - inform hardware has lost connection with the AP
> + *
> + * @vif: &struct ieee80211_vif pointer from the add_interface callback.
> + *
> + * When beacon filtering is enabled with IEEE80211_HW_BEACON_FILTERING and
> + * IEEE80211_CONF_PS is set, the driver needs to inform with this function
> + * whenever the hardware is not receiving beacons and the AP is not responding
> + * to probe requests with this function.
> + */
> +void ieee80211_probereq_failed(struct ieee80211_vif *vif);
> +
>  /* Rate control API */
>  
>  /**
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 0ab284c..8f591a4 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -945,6 +945,38 @@ void ieee80211_beacon_loss(struct ieee80211_vif *vif)
>  }
>  EXPORT_SYMBOL(ieee80211_beacon_loss);
>  
> +void ieee80211_probereq_failed(struct ieee80211_vif *vif)
> +{
> +	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
> +	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
> +	struct ieee80211_local *local = sdata->local;
> +	u8 bssid[ETH_ALEN];
> +
> +	mutex_lock(&ifmgd->mtx);
> +	if (!ifmgd->associated) {
> +		mutex_unlock(&ifmgd->mtx);
> +		return;
> +	}
> +
> +	memcpy(bssid, ifmgd->associated->bssid, ETH_ALEN);

I think the actual work should be deferred to a workqueue struct item so
that you don't get into locking trouble with drivers here.

johannes

