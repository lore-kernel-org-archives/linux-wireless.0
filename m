Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:35698 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933534AbeF2Jg4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 05:36:56 -0400
Message-ID: <1530265012.3481.42.camel@sipsolutions.net> (sfid-20180629_113711_021864_ABA9AA35)
Subject: Re: [PATCH 5/7] mac80211: Implement functionality to monitor
 station's rssi cross event
From: Johannes Berg <johannes@sipsolutions.net>
To: Tamizh chelvam <tamizhr@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 29 Jun 2018 11:36:52 +0200
In-Reply-To: <1528886747-26342-6-git-send-email-tamizhr@codeaurora.org>
References: <1528886747-26342-1-git-send-email-tamizhr@codeaurora.org>
         <1528886747-26342-6-git-send-email-tamizhr@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-06-13 at 16:15 +0530, Tamizh chelvam wrote:
> 
> +	if (sta->rssi_thold && bss_conf->enable_beacon) {
> +		int last_event = sta->last_sta_mon_event_signal;
> +		int thold = sta->rssi_thold;
> +		int hyst = sta->rssi_hyst;
> +		int sig = -ewma_signal_read(&sta->rx_stats_avg.signal);
> +
> +		if (sig < thold &&
> +		    (last_event == 0 || sig < last_event - hyst)) {
> +			sta->last_sta_mon_event_signal = sig;
> +			cfg80211_sta_mon_rssi_notify(
> +				rx->sdata->dev, sta->addr,
> +				NL80211_STA_MON_RSSI_THRESHOLD_EVENT_LOW,
> +				sig, GFP_ATOMIC);
> +		} else if (sig > thold &&
> +			   (last_event == 0 || sig > last_event + hyst)) {
> +			sta->last_sta_mon_event_signal = sig;
> +			cfg80211_sta_mon_rssi_notify(
> +				rx->sdata->dev, sta->addr,
> +				NL80211_STA_MON_RSSI_THRESHOLD_EVENT_HIGH,
> +				sig, GFP_ATOMIC);
> +		}
> +	}

This seems really familiar - perhaps if you unify the cfg80211 API for
sta_mon and "normal" CQM (distinguish based on the peer address?) you
can unify this block of code too?

johannes
