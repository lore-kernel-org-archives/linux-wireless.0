Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:49948 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755651AbeFOLnl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Jun 2018 07:43:41 -0400
Message-ID: <1529063019.10037.12.camel@sipsolutions.net> (sfid-20180615_134344_948459_3F5C74B3)
Subject: Re: [PATCH v2 2/2] mac80211: last ack signal support in station dump
From: Johannes Berg <johannes@sipsolutions.net>
To: Balaji Pothunoori <bpothuno@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 15 Jun 2018 13:43:39 +0200
In-Reply-To: <1528121469-16450-3-git-send-email-bpothuno@codeaurora.org>
References: <1528121469-16450-1-git-send-email-bpothuno@codeaurora.org>
         <1528121469-16450-3-git-send-email-bpothuno@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-06-04 at 19:41 +0530, Balaji Pothunoori wrote:
> 
> +	if (ieee80211_hw_check(&sta->local->hw, REPORTS_TX_ACK_STATUS)) {
> +		if (sta->status_stats.ack_signal_filled && ((!(sinfo->filled &
> +		    BIT_ULL(NL80211_STA_INFO_ACK_SIGNAL))) ||
> +		    (!(sinfo->filled &
> +		    BIT_ULL(NL80211_STA_INFO_ACK_SIGNAL_AVG))))) {

Uh, wow, the indentation here is awful - please break with && and || on
the end of line and indent properly according to the nesting level.

If a line ends up being longer than 80, I think that's better than this
monster expression :)

> +			sinfo->ack_signal =
> +				sta->status_stats.last_ack_signal;
> +			sinfo->filled |=
> +				BIT_ULL(NL80211_STA_INFO_ACK_SIGNAL);
> +			sinfo->avg_ack_signal =
> +				-(s8)ewma_avg_signal_read(
>  				&sta->status_stats.avg_ack_signal);
> -		sinfo->filled |=
> -			BIT_ULL(NL80211_STA_INFO_DATA_ACK_SIGNAL_AVG);
> +			sinfo->filled |=
> +				BIT_ULL(NL80211_STA_INFO_ACK_SIGNAL_AVG);
> +		}

Clearly your previous patch would even break the kernel compile since
the DATA_ACK_SIGNAL_AVG is still used here.



Finally, please also explain why you're adding this feature, at least in
the cover letter ("PATCH 0/2"), I can reuse that as a merge commit
message if necessary.

johannes
