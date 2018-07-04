Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44442 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752565AbeGDSQF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jul 2018 14:16:05 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 04 Jul 2018 23:46:04 +0530
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/7] wireless: Change single cqm_config to rssi config
 list
In-Reply-To: <1530264405.3481.31.camel@sipsolutions.net>
References: <1528886747-26342-1-git-send-email-tamizhr@codeaurora.org>
 <1528886747-26342-2-git-send-email-tamizhr@codeaurora.org>
 <1530264405.3481.31.camel@sipsolutions.net>
Message-ID: <32a52d2ea57526cfe8c6311e6e34aaac@codeaurora.org> (sfid-20180704_201609_793634_FB8D525B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-06-29 14:56, Johannes Berg wrote:
> On Wed, 2018-06-13 at 16:15 +0530, Tamizh chelvam wrote:
>> 
>> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
>> index 5fbfe61..3e123a3 100644
>> --- a/include/net/cfg80211.h
>> +++ b/include/net/cfg80211.h
>> @@ -4139,7 +4139,7 @@ static inline struct wiphy *wiphy_new(const 
>> struct cfg80211_ops *ops,
>>  struct cfg80211_conn;
>>  struct cfg80211_internal_bss;
>>  struct cfg80211_cached_keys;
>> -struct cfg80211_cqm_config;
>> +struct cfg80211_rssi_config;
> 
> I think something like rssi_mon_config would be better? Just _rssi_
> could be interpreted in many ways.
> 
Okay sure
>> -	struct cfg80211_cqm_config *cqm_config;
>> +	struct cfg80211_rssi_config *rssi_config;
>> +	struct list_head rssi_config_list;
> 
> Why do you need both now? Perhaps instead you should allow a NULL/all-
> ones MAC address for where you have the direct pointer now, and remove
> that? You anyway need to pass something to the peer argument in
> 
In the current cqm/sta_mon implementation the range_config will be 
updated before notify event posted to userspace.
To update the range config for a specific station we need to have this 
peer addr based configuration list which holds the thresholds info
to choose the next rssi range.
Or do you want me to handle and store the rssi_config structure in 
mac80211 and update it in mac80211 itself ? And simply pass the 
notification event to userspace application ?

>> -void cfg80211_cqm_config_free(struct wireless_dev *wdev)
>> +void cfg80211_rssi_config_free(struct wireless_dev *wdev, const u8 
>> *peer)
> 
> even when the pointer is used.
> 
>> -	kfree(wdev->cqm_config);
>> -	wdev->cqm_config = NULL;
>> +	struct cfg80211_rssi_config *rssi_config, *tmp;
>> +
>> +	if (list_empty(&wdev->rssi_config_list))
>> +		goto free;
>> +
>> +	list_for_each_entry_safe(rssi_config, tmp, &wdev->rssi_config_list,
>> +				 list) {
>> +		if (peer && memcmp(rssi_config->addr, peer, ETH_ALEN))
>> +			continue;
>> +
>> +		list_del(&rssi_config->list);
>> +		kfree(rssi_config);
>> +		if (list_empty(&wdev->rssi_config_list) || peer)
>> +			goto out;
>> +	}
> 
> That logic could use some comments if we even decide to keep it this
> way.
> 
> NULL means "free all"?
> 
Yes.
> What's the locking scheme for this? It's way more complex now so 
> perhaps
> stick ASSERT_RTNL() in there or so?
> 
Isn't wdev_lock enough ?
>> @@ -10140,7 +10141,7 @@ static int cfg80211_cqm_rssi_update(struct 
>> cfg80211_registered_device *rdev,
>>  	int err;
>> 
>>  	/* RSSI reporting disabled? */
>> -	if (!wdev->cqm_config)
>> +	if (!wdev->rssi_config)
>>  		return rdev_set_cqm_rssi_range_config(rdev, dev, 0, 0);
> 
> 
> So I guess the wdev->rssi_config is used for the case of "always use
> this config for any AP you're connected to" or so - but maybe it'd be
> better to track the AP as a station? Then again, I guess we can't force
> userspace to change that.
> 
Sorry I didn't get your point:( I didn't change anything in the station 
mode. Functionality remains
same for the station mode.

>> +static struct cfg80211_rssi_config *
>> +cfg80211_get_rssi_config(struct wireless_dev *wdev, const s32 
>> *thresholds,
>> +			 int n_thresholds, u32 hysteresis, const u8 *peer)
>> +{
>> +	struct cfg80211_rssi_config *rssi_config;
>> +
>> +	if (!peer)
>> +		return NULL;
>> +
>> +	if (list_empty(&wdev->rssi_config_list))
>> +		goto new;
>> +
>> +	list_for_each_entry(rssi_config, &wdev->rssi_config_list, list) {
>> +		if (!memcmp(rssi_config->addr, peer, ETH_ALEN))
>> +			goto found;
>> +	}
>> +
>> +new:
>> +	rssi_config = kzalloc(sizeof(struct cfg80211_rssi_config) +
>> +			      n_thresholds * sizeof(s32), GFP_KERNEL);
>> +	list_add(&rssi_config->list, &wdev->rssi_config_list);
> 
> Why does "get" always imply "create"?
> 
I'll rename the function.

>>  	wdev_lock(wdev);
>>  	if (n_thresholds) {
>> -		struct cfg80211_cqm_config *cqm_config;
>> -
>> -		cqm_config = kzalloc(sizeof(struct cfg80211_cqm_config) +
>> -				     n_thresholds * sizeof(s32), GFP_KERNEL);
>> -		if (!cqm_config) {
>> +		wdev->rssi_config = cfg80211_get_rssi_config(
>> +						wdev, thresholds,
>> +						n_thresholds, hysteresis,
>> +						wdev->current_bss->pub.bssid);
> 
> Here you link it to the BSSID anyway, but do we always have a
> current_bss at this point?
> 
Oops! I didn't think about that condition. I'll fix that in the next 
version.
