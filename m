Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47504 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751194AbeC1FnM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 01:43:12 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 28 Mar 2018 11:13:11 +0530
From: vthiagar@codeaurora.org
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [RFC 3/4] mac80211: Apply per-peer NoAck tid bitmap configuration
In-Reply-To: <1522155253.3050.8.camel@sipsolutions.net>
References: <1522140171-10926-1-git-send-email-vthiagar@codeaurora.org>
 <1522140171-10926-4-git-send-email-vthiagar@codeaurora.org>
 <1522155253.3050.8.camel@sipsolutions.net>
Message-ID: <55759171b924fb2075fe189d3d149e28@codeaurora.org> (sfid-20180328_074319_542639_C8058DB0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-03-27 18:24, Johannes Berg wrote:
> On Tue, 2018-03-27 at 14:12 +0530, Vasanthakumar Thiagarajan wrote:
>> 
>> +u16 ieee80211_get_noack_map(struct ieee80211_sub_if_data *sdata, 
>> const u8 *mac)
>> +{
>> +	struct sta_info *sta;
>> +	u16 noack_map = 0;
>> +
>> +	/* Retrieve per-station noack_map config for the receiver, if any */
>> +
>> +	rcu_read_lock();
>> +
>> +	sta = sta_info_get(sdata, mac);
>> +	if (!sta) {
>> +		rcu_read_unlock();
>> +		return noack_map;
>> +	}
>> +
>> +	noack_map = sta->noack_map;
>> +
>> +	rcu_read_unlock();
>> +
>> +	if (!noack_map)
>> +		noack_map = sdata->noack_map;
> 
> So this has an interesting corner case - should it be possible to have 
> a
> default noack_map that's non-zero, but override it with 0 for a 
> specific
> peer? It seems that it should be, which makes this code wrong.

I think 0 as the Noack configuration from user can also be a valid one 
in the case
where user does not want any NoAck policy to be used for a particular 
station even
when a non-zero NoAck configuration is set for ndev level. In this case, 
the logic
may need to be modified so that the default non-zero configuration 
(something like -1)
could be used to determine that the station has been never configured 
with any NoAck
policy and use ndev level configuration. Does this sound reasonable?

Vasanth
