Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43120 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753608AbeGDGJi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jul 2018 02:09:38 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 04 Jul 2018 11:39:37 +0530
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/7] cfg80211: Add new NL command to configure peer
 specific rssi threshold
In-Reply-To: <1530264578.3481.34.camel@sipsolutions.net>
References: <1528886747-26342-1-git-send-email-tamizhr@codeaurora.org>
 <1528886747-26342-3-git-send-email-tamizhr@codeaurora.org>
 <1530264578.3481.34.camel@sipsolutions.net>
Message-ID: <5d7f6ec9ffe0272b41102828f37706db@codeaurora.org> (sfid-20180704_080947_703446_F0138B90)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-06-29 14:59, Johannes Berg wrote:
> On Wed, 2018-06-13 at 16:15 +0530, Tamizh chelvam wrote:
>> 
>> + * @NL80211_ATTR_STA_MON: Station's connection monitor configuration 
>> in a
>> + *	nested attribute with %NL80211_ATTR_STA_MON_* sub-attributes.
> 
> Can't we reuse the existing attributes in this nesting?
This new attributes introduced as per the previous discussion.
https://patchwork.kernel.org/patch/10240697/
Is my understanding correct ?
> 
>> +/**
>> + * enum nl80211_sta_mon_rssi_threshold_event - RSSI threshold event
>> + * @NL80211_STA_MON_RSSI_THRESHOLD_EVENT_LOW: The RSSI level is lower 
>> than the
>> + *	configured threshold
>> + * @NL80211_STA_MON_RSSI_THRESHOLD_EVENT_HIGH: The RSSI is higher 
>> than the
>> + *	configured threshold
>> + */
>> +enum nl80211_sta_mon_rssi_threshold_event {
>> +	NL80211_STA_MON_RSSI_THRESHOLD_EVENT_LOW,
>> +	NL80211_STA_MON_RSSI_THRESHOLD_EVENT_HIGH,
>> +};
> 
> It seems like this should already exist also for the CQM? Can we not
> reuse it?
> 
>> +static int nl80211_set_sta_mon_rssi(struct genl_info *info,
>> +				    const u8 *peer, s32 threshold,
>> +				    u32 hysteresis)
>> +{
>> +	struct cfg80211_registered_device *rdev = info->user_ptr[0];
>> +	struct net_device *dev = info->user_ptr[1];
>> +	struct wireless_dev *wdev = dev->ieee80211_ptr;
>> +
>> +	if (threshold > 0)
>> +		return -EINVAL;
>> +
>> +	if (threshold == 0)
>> +		hysteresis = 0;
>> +
>> +	if (!rdev->ops->set_sta_mon_rssi_config)
>> +		return -EOPNOTSUPP;
>> +
>> +	if ((wdev->iftype != NL80211_IFTYPE_AP &&
>> +	     wdev->iftype != NL80211_IFTYPE_P2P_GO &&
>> +	     wdev->iftype != NL80211_IFTYPE_AP_VLAN) ||
>> +	    !wiphy_ext_feature_isset(&rdev->wiphy,
>> +				NL80211_EXT_FEATURE_STA_MON_RSSI_CONFIG))
>> +		return -EOPNOTSUPP;
>> +
>> +	return rdev_set_sta_mon_rssi_config(rdev, dev, peer,
>> +					    threshold, hysteresis);
>> +}
> 
> Wait, you went to all this effort in the first patch and now you don't
> add this to the list?
> 
No, the list and the rssi_config structure is for multi threshold value 
and not for single threshold.

Thanks,
Tamizh.
