Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:45904 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751041AbeAVNB4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 08:01:56 -0500
Message-ID: <1516626114.2508.27.camel@sipsolutions.net> (sfid-20180122_140220_373429_5774F2F5)
Subject: Re: [PATCH 4/4] mac80211: implement cqm using rx data signal
From: Johannes Berg <johannes@sipsolutions.net>
To: tamizhr@codeaurora.org
Cc: linux-wireless@vger.kernel.org, tamizhr@qti.qualcomm.com
Date: Mon, 22 Jan 2018 14:01:54 +0100
In-Reply-To: <1516174276-16789-5-git-send-email-tamizhr@codeaurora.org>
References: <1516174276-16789-1-git-send-email-tamizhr@codeaurora.org>
         <1516174276-16789-5-git-send-email-tamizhr@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-01-17 at 13:01 +0530, tamizhr@codeaurora.org wrote:
> 
> +		if (!fast_rx->uses_rss) {
>  			ewma_signal_add(&sta->rx_stats_avg.signal,
>  					-status->signal);
> +			sta->count_rx_signal++;
> +			if (sta->count_rx_signal >=
> +			    IEEE80211_STA_SIGNAL_AVE_MIN_COUNT)
> +				ieee80211_sta_rx_signal_thold_check(rx);
> +		}
> 
Obviously this also means that not all mac80211 drivers will get the
feature, which also means we really do need a feature bit for it, and
one that mac80211 can only set if the driver promised not to use RSS.

johannes
