Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43752 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753288AbeGDJgs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jul 2018 05:36:48 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 04 Jul 2018 15:06:47 +0530
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/7] mac80211: Implement functionality to monitor
 station's rssi cross event
In-Reply-To: <1530265012.3481.42.camel@sipsolutions.net>
References: <1528886747-26342-1-git-send-email-tamizhr@codeaurora.org>
 <1528886747-26342-6-git-send-email-tamizhr@codeaurora.org>
 <1530265012.3481.42.camel@sipsolutions.net>
Message-ID: <12ed2c19a3a03b8e05dcf4886cb42ad0@codeaurora.org> (sfid-20180704_113653_884941_504B747A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-06-29 15:06, Johannes Berg wrote:
> On Wed, 2018-06-13 at 16:15 +0530, Tamizh chelvam wrote:
>> 
>> +	if (sta->rssi_thold && bss_conf->enable_beacon) {
>> +		int last_event = sta->last_sta_mon_event_signal;
>> +		int thold = sta->rssi_thold;
>> +		int hyst = sta->rssi_hyst;
>> +		int sig = -ewma_signal_read(&sta->rx_stats_avg.signal);
>> +
>> +		if (sig < thold &&
>> +		    (last_event == 0 || sig < last_event - hyst)) {
>> +			sta->last_sta_mon_event_signal = sig;
>> +			cfg80211_sta_mon_rssi_notify(
>> +				rx->sdata->dev, sta->addr,
>> +				NL80211_STA_MON_RSSI_THRESHOLD_EVENT_LOW,
>> +				sig, GFP_ATOMIC);
>> +		} else if (sig > thold &&
>> +			   (last_event == 0 || sig > last_event + hyst)) {
>> +			sta->last_sta_mon_event_signal = sig;
>> +			cfg80211_sta_mon_rssi_notify(
>> +				rx->sdata->dev, sta->addr,
>> +				NL80211_STA_MON_RSSI_THRESHOLD_EVENT_HIGH,
>> +				sig, GFP_ATOMIC);
>> +		}
>> +	}
> 
> This seems really familiar - perhaps if you unify the cfg80211 API for
> sta_mon and "normal" CQM (distinguish based on the peer address?) you
> can unify this block of code too?
> 
Sure I'll check and update it in the next version of the patch.
