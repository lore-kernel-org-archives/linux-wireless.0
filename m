Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38860 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933118AbeFRKZj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Jun 2018 06:25:39 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 18 Jun 2018 15:55:39 +0530
From: Balaji Pothunoori <bpothuno@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mac80211: last ack signal support in station dump
In-Reply-To: <1529063019.10037.12.camel@sipsolutions.net>
References: <1528121469-16450-1-git-send-email-bpothuno@codeaurora.org>
 <1528121469-16450-3-git-send-email-bpothuno@codeaurora.org>
 <1529063019.10037.12.camel@sipsolutions.net>
Message-ID: <658776f067af9968adcc51bf8baad687@codeaurora.org> (sfid-20180618_122545_446383_C4AB1116)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-06-15 17:13, Johannes Berg wrote:
> On Mon, 2018-06-04 at 19:41 +0530, Balaji Pothunoori wrote:
>> 
>> +	if (ieee80211_hw_check(&sta->local->hw, REPORTS_TX_ACK_STATUS)) {
>> +		if (sta->status_stats.ack_signal_filled && ((!(sinfo->filled &
>> +		    BIT_ULL(NL80211_STA_INFO_ACK_SIGNAL))) ||
>> +		    (!(sinfo->filled &
>> +		    BIT_ULL(NL80211_STA_INFO_ACK_SIGNAL_AVG))))) {
> 
> Uh, wow, the indentation here is awful - please break with && and || on
> the end of line and indent properly according to the nesting level.
> 
> If a line ends up being longer than 80, I think that's better than this
> monster expression :)

Sure , i will modify in v3.

> 
>> +			sinfo->ack_signal =
>> +				sta->status_stats.last_ack_signal;
>> +			sinfo->filled |=
>> +				BIT_ULL(NL80211_STA_INFO_ACK_SIGNAL);
>> +			sinfo->avg_ack_signal =
>> +				-(s8)ewma_avg_signal_read(
>>  				&sta->status_stats.avg_ack_signal);
>> -		sinfo->filled |=
>> -			BIT_ULL(NL80211_STA_INFO_DATA_ACK_SIGNAL_AVG);
>> +			sinfo->filled |=
>> +				BIT_ULL(NL80211_STA_INFO_ACK_SIGNAL_AVG);
>> +		}
> 
> Clearly your previous patch would even break the kernel compile since
> the DATA_ACK_SIGNAL_AVG is still used here.

Here i have used "NL80211_STA_INFO_ACK_SIGNAL_AVG" not as 
"NL80211_STA_INFO_DATA_ACK_SIGNAL_AVG".

> 
> 
> 
> Finally, please also explain why you're adding this feature, at least 
> in
> the cover letter ("PATCH 0/2"), I can reuse that as a merge commit
> message if necessary.

Sure, i will update in v3.

> 
> johannes

Regards,
Balaji.
