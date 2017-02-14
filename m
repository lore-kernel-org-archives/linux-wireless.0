Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f176.google.com ([209.85.128.176]:35777 "EHLO
        mail-wr0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751452AbdBNMfo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Feb 2017 07:35:44 -0500
Received: by mail-wr0-f176.google.com with SMTP id c4so11151064wrd.2
        for <linux-wireless@vger.kernel.org>; Tue, 14 Feb 2017 04:35:44 -0800 (PST)
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [RFC V2 1/5] nl80211: allow multiple active scheduled scan
 requests
To: Johannes Berg <johannes@sipsolutions.net>
References: <1484566941-27000-1-git-send-email-arend.vanspriel@broadcom.com>
 <1484566941-27000-2-git-send-email-arend.vanspriel@broadcom.com>
 <1485250815.7244.8.camel@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Message-ID: <fd4c2573-caea-1cdc-ee33-f010bb0aad58@broadcom.com> (sfid-20170214_133813_474674_976844E6)
Date: Tue, 14 Feb 2017 13:35:40 +0100
MIME-Version: 1.0
In-Reply-To: <1485250815.7244.8.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24-1-2017 10:40, Johannes Berg wrote:
> 
>> + * @max_sched_scan_reqs: maximum number of scheduled scan requests
>> that
>> + *	the device can run concurrently.
> 
> Perhaps we should get rid of WIPHY_FLAG_SUPPORTS_SCHED_SCAN and just
> set this to 1 for such devices? Otherwise we have two different
> requirements, and we need to track that 0 is an invalid value here if
> WIPHY_FLAG_SUPPORTS_SCHED_SCAN is set, or something like that?

Ok. Doesn't that cause issues in user-space. Or do you only want to get
rid of it in cfg80211 api and report the flag to user-space when
max_sched_scan_reqs equals 1?

>> + * @NL80211_ATTR_SCHED_SCAN_MAX_REQS: indicates maximum number of
>> scheduled
>> + *	scan request that may be active for the device (u8).
> 
> I'd make that a u32 - not that I believe we'll ever want to change this
> in the future, but there's simply no value in making it a u8 since it
> uses the same amount of space in a netlink message.

Ok.

>> +	list_for_each_entry_safe(pos, tmp, &rdev-
>>> sched_scan_req_list, list) {
>> +		cfg80211_stop_sched_scan_req(rdev, pos, false);
>> +	}
> 
> nit: don't really need braces here.

True.

>> +	if ((wiphy->flags & WIPHY_FLAG_SUPPORTS_SCHED_SCAN) &&
>> +	    !wiphy->max_sched_scan_reqs)
>> +		wiphy->max_sched_scan_reqs = 1;
> 
> Yeah, this. Why bother?
> 
> (should even be simple to come up with an spatch to change all the
> drivers, but there are only five anyway)

Done.

>> +		    nla_put_u8(msg,
>> NL80211_ATTR_SCHED_SCAN_MAX_REQS,
>> +			       rdev->wiphy.max_sched_scan_reqs) ||
>>  		    nla_put_u8(msg,
>> NL80211_ATTR_MAX_NUM_SCHED_SCAN_SSIDS,
>>  			       rdev->wiphy.max_sched_scan_ssids) ||
> 
> This might break older userspace - you'll have to put it in a later
> portion of the code.
> 
> I'm also a bit surprised the attributes aren't actually optional for
> when sched scan isn't supported, I'd make the new one optional and I
> guess we can fix the others later too, if desired.

Why would it break user-space. Is the order in which attributes are
added into the stream something user-space relies on.

>> +	bool want_multi;
> 
> That's bool
> 
>> +	want_multi = !!info->attrs[NL80211_ATTR_SCHED_SCAN_MULTI];
> 
> so you don't really need the !! as it's implied by the rules for bool
> :)

I see.

>> +	/* leave request id zero for legacy request
>> +	 * or if driver does not support multi-scheduled scan
>> +	 */
>> +	if (want_multi && rdev->wiphy.max_sched_scan_reqs > 1) {
> 
> Why do the >1 check here? It probably doesn't really make a difference
> since only one can be running at a time, but it might be nicer - at
> least for debug in userspace - to have a real value for all multi
> scans?
> 
>> +		while (!sched_scan_req->reqid)
> 
> Pretty sure we won't run over the u64 ... but I guess it doesn't matter
> much :)
> 
> 
> I don't see you sending the reqid/cookie back to userspace here though,
> that's missing?

Indeed that is in the second patch. Maybe I should put that commit first
in the series.

>>  static int nl80211_stop_sched_scan(struct sk_buff *skb,
>>  				   struct genl_info *info)
>>  {
>> +	struct cfg80211_sched_scan_request *req;
>>  	struct cfg80211_registered_device *rdev = info->user_ptr[0];
>> +	u64 cookie;
>>  
>>  	if (!(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_SCHED_SCAN) ||
>>  	    !rdev->ops->sched_scan_stop)
>>  		return -EOPNOTSUPP;
>>  
>> -	return __cfg80211_stop_sched_scan(rdev, false);
>> +	if (info->attrs[NL80211_ATTR_COOKIE]) {
>> +		cookie = nla_get_u64(info-
>>> attrs[NL80211_ATTR_COOKIE]);
>> +		return __cfg80211_stop_sched_scan(rdev, cookie,
>> false);
>> +	} else {
>> +		req = list_first_or_null_rcu(&rdev-
>>> sched_scan_req_list,
>> +					     struct
>> cfg80211_sched_scan_request,
>> +					     list);
>> +		if (!req || req->reqid ||
>> +		    (req->owner_nlportid &&
>> +		     req->owner_nlportid != info->snd_portid))
>> +			return -ENOENT;
> 
> Shouldn't this also check that it's non-multi?

non-multi == (req->reqid == 0). non-multi/legacy and multi can not be
active at the same time so we can use list_first_or_null_rcu here. If
req->reqid of first entry is non-zero there is no non-multi to stop here.

>> +void cfg80211_add_sched_scan_req(struct cfg80211_registered_device
>> *rdev,
>> +				 struct cfg80211_sched_scan_request
>> *req)
>> +{
>> +	list_add_rcu(&req->list, &rdev->sched_scan_req_list);
>> +}
>> +
>> +static void cfg80211_del_sched_scan_req(struct
>> cfg80211_registered_device *rdev,
>> +					struct
>> cfg80211_sched_scan_request *req)
>> +{
>> +	list_del_rcu(&req->list);
>> +	kfree_rcu(req, rcu_head);
>> +}
> 
> Some locking assertions in these would be good, I think.

Will do.

>> +static struct cfg80211_sched_scan_request *
>> +cfg80211_find_sched_scan_req(struct cfg80211_registered_device
>> *rdev, u64 reqid)
>> +{
>> +	struct cfg80211_sched_scan_request *pos;
>> +
>> +	list_for_each_entry(pos, &rdev->sched_scan_req_list, list) {
>> +		if (pos->reqid == reqid)
>> +			return pos;
>> +	}
>> +	return ERR_PTR(-ENOENT);
>> +}
> 
> Here too, I guess, since you don't actually use RCU.

So should I use RCU here? Not sure what is the better choice here.

Regards,
Arend
