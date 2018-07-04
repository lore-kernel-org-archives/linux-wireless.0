Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44158 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932643AbeGDGNr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jul 2018 02:13:47 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 04 Jul 2018 11:43:46 +0530
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/7] cfg80211: Add support to notify station's rssi level
 crossing
In-Reply-To: <1530264922.3481.40.camel@sipsolutions.net>
References: <1528886747-26342-1-git-send-email-tamizhr@codeaurora.org>
 <1528886747-26342-5-git-send-email-tamizhr@codeaurora.org>
 <1530264922.3481.40.camel@sipsolutions.net>
Message-ID: <b87dc6cea56faee0a3570d90b4e6d42a@codeaurora.org> (sfid-20180704_081352_890888_4B72BB85)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-06-29 15:05, Johannes Berg wrote:
> On Wed, 2018-06-13 at 16:15 +0530, Tamizh chelvam wrote:
>> Add cfg80211_sta_mon_rssi_notify api to update user space upon
>> crossing the configured rssi threshold of a station.
>> NL80211_CMD_NOTIFY_STA_MON introduced to send this event to
>> userspace along with NL80211_ATTR_STA_MON_RSSI_THRESHOLD_EVENT,
>> NL80211_ATTR_MAC and NL80211_ATTR_STA_MON_RSSI_LEVEL info.
>> Userspace application can make a decision depends on this
>> notification.
> 
> I guess you should also combine this with patch 2, it's a bit weird to
> only have one side and not be able to use it in one patch, and both
> aren't all that big.
Sure
> 
> 
>> --- a/include/uapi/linux/nl80211.h
>> +++ b/include/uapi/linux/nl80211.h
>> @@ -1249,6 +1249,7 @@ enum nl80211_commands {
>>  	NL80211_CMD_CONTROL_PORT_FRAME,
>> 
>>  	NL80211_CMD_SET_STA_MON,
>> +	NL80211_CMD_NOTIFY_STA_MON,
> 
> Missing documentation - but again, why not unify it with the existing
> event? Or can't we because that might confuse older applications?
> Perhaps anyway we should unicast these notifications? Not sure though,
> perhaps one app could set them up and the other might care?
> 
This new command introduced as per the previous discussion
https://patchwork.kernel.org/patch/10168685/
https://patchwork.kernel.org/patch/10240697/

Is my understanding correct ?

>> +static struct sk_buff *cfg80211_prepare_sta_mon(struct net_device 
>> *dev,
>> +						const char *mac, gfp_t gfp)
>> +{
>> +	struct wireless_dev *wdev = dev->ieee80211_ptr;
>> +	struct cfg80211_registered_device *rdev = 
>> wiphy_to_rdev(wdev->wiphy);
>> +	struct sk_buff *msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
>> +	void **cb;
>> +
>> +	if (!msg)
>> +		return NULL;
>> +
>> +	cb = (void **)msg->cb;
> 
> Uh, what's that? Please use a structure.

I just referred this code from cfg80211_prepare_cqm. Do you want me to 
change this to struct based?
> 
>> +	cb[0] = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_NOTIFY_STA_MON);
>> 
> [...]
>> +
>> +	cb[1] = nla_nest_start(msg, NL80211_ATTR_STA_MON);
>> +	if (!cb[1])
>> +		goto nla_put_failure;
>> +
>> +	cb[2] = rdev;
> 
> Yeah, definitely use a struct instead of three magic array indices.
> 
>> +
>> +	msg = cfg80211_prepare_sta_mon(dev, peer, gfp);
>> +	if (!msg)
>> +		return;
>> +
>> +	if (nla_put_u32(msg, NL80211_ATTR_STA_MON_RSSI_THRESHOLD_EVENT,
>> +			rssi_event))
>> +		goto nla_put_failure;
>> +
>> +	if (rssi_level && nla_put_s32(msg, NL80211_ATTR_STA_MON_RSSI_LEVEL,
>> +				      rssi_level))
>> +		goto nla_put_failure;
>> +
>> +	cfg80211_send_sta_mon(msg, gfp);
> 
> In fact, perhaps better to have something like
> 
> struct nl80211_sta_mon_prep {
> 	struct sk_buff *skb;
> 	....
> };
> 
> struct nl80211_sta_mon_prep prep;
> 
> if (cfg80211_prepare_sta_mon(&prep))
> 	return;
> ...
> cfg80211_send_sta_mon(&prep, gfp);
> 
> or so?

Tamizh.
