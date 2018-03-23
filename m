Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:50104 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752043AbeCWNYY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Mar 2018 09:24:24 -0400
Message-ID: <1521811462.11491.5.camel@sipsolutions.net> (sfid-20180323_142428_098244_7863DF79)
Subject: Re: [PATCHv4 3/3] mac80211: implement cqm rssi check using rx data
 signal
From: Johannes Berg <johannes@sipsolutions.net>
To: Tamizh chelvam <tamizhr@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 23 Mar 2018 14:24:22 +0100
In-Reply-To: <1519544998-2621-4-git-send-email-tamizhr@codeaurora.org> (sfid-20180225_085019_022021_682626EC)
References: <1519544998-2621-1-git-send-email-tamizhr@codeaurora.org>
         <1519544998-2621-4-git-send-email-tamizhr@codeaurora.org>
         (sfid-20180225_085019_022021_682626EC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +/*
> + * How many frames need to have been used in average station's
> + * signal strength before checking against the threshold
> + */
> +#define IEEE80211_STA_SIGNAL_AVE_MIN_COUNT	4

This seems OK - you want something to start up from?

However, I don't think we do that in "normal" CQM, and building
different behaviour here seems a bit odd.

> +	if (sig < thold && last_event == 0) {
> +		sta->last_cqm_event_signal = sig;
> +		cfg80211_ap_sta_cqm_rssi_notify(
> +				rx->sdata->dev, sta->addr,
> +				NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW
> ,
> +				sig, GFP_ATOMIC);
> +		sta->count_rx_signal = 0;

In particular, resetting it all the time seems even stranger, since
then you can only react at a granularity of these 4 frames. EWMA
catches fluctuations already, so I don't think you should do it this
way.

johannes
