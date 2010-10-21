Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46048 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757741Ab0JUMDa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Oct 2010 08:03:30 -0400
Received: by bwz18 with SMTP id 18so217433bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 21 Oct 2010 05:03:28 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Paul Stewart <pstew@google.com>
Subject: Re: [PATCH 2/2] mac80211: Add support for CQM tx bitrate monitoring
Date: Thu, 21 Oct 2010 14:02:43 +0200
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
References: <20101021035501.77DBF20423@glenhelen.mtv.corp.google.com>
In-Reply-To: <20101021035501.77DBF20423@glenhelen.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201010211402.43857.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag 21 Oktober 2010 schrieb Paul Stewart:
> Add state, work proc and debugging parameters for monitoring
> transmit-rate changes.
> 
> Signed-off-by: Paul Stewart <pstew@google.com>
> ---

[...]

> diff --git a/net/mac80211/status.c b/net/mac80211/status.c
> index 3153c19..564aa2e 100644
> --- a/net/mac80211/status.c
> +++ b/net/mac80211/status.c
> @@ -154,6 +154,24 @@ static void ieee80211_frame_acked(struct sta_info *sta, struct sk_buff *skb)
>  		}
>  
>  		ieee80211_queue_work(&local->hw, &local->recalc_smps);
> +	} else if (ieee80211_is_data(mgmt->frame_control) &&
> +		   sdata->vif.type == NL80211_IFTYPE_STATION) {
> +		struct ieee80211_if_managed *ifmgd;
> +		ifmgd = &sta->sdata->u.mgd;
> +		if (ifmgd->cqm_bitrate_thold != 0 &&
> +		    (ifmgd->last_cqm_tx_rate.idx != sta->last_tx_rate.idx ||
> +		     (ifmgd->last_cqm_tx_rate.flags &
> +		      (IEEE80211_TX_RC_MCS | IEEE80211_TX_RC_40_MHZ_WIDTH |
> +		       IEEE80211_TX_RC_SHORT_GI)) !=
> +		     (sta->last_tx_rate.flags &
> +		      (IEEE80211_TX_RC_MCS | IEEE80211_TX_RC_40_MHZ_WIDTH |
> +		       IEEE80211_TX_RC_SHORT_GI)) ||
> +		     sdata->u.mgd.last_cqm_bitrate == 0)) {
> +			ifmgd->last_cqm_tx_rate = sta->last_tx_rate;
> +			ifmgd->tx_bitrate_changed = true;
> +			ieee80211_queue_work(&local->hw,
> +					     &ifmgd->bitrate_notify_work);
> +		}
>  	}
>  }

Not sure but wouldn't that trigger a lot of unnecessary processing when a rate
gets probed by the rc algortihm? You might want to filter out probe frames
based on IEEE80211_TX_CTL_RATE_CTRL_PROBE as otherwise you could end up with
sending a huge number of events to userspace ...

Helmut
