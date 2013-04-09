Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2794 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936080Ab3DITyn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Apr 2013 15:54:43 -0400
Message-ID: <516471FC.6000209@broadcom.com> (sfid-20130409_215451_127665_5E60B5C3)
Date: Tue, 9 Apr 2013 21:54:36 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: introduce critical protocol indication
 from user-space
References: <1365412173-7428-1-git-send-email-arend@broadcom.com>
 <1365501997.8465.23.camel@jlt4.sipsolutions.net>
In-Reply-To: <1365501997.8465.23.camel@jlt4.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/09/2013 12:06 PM, Johannes Berg wrote:
> On Mon, 2013-04-08 at 11:09 +0200, Arend van Spriel wrote:
>
>> + * @crit_proto_start: Indicates a critical protocol needs more link reliability.
>
> Can you elaborate here on what the protocol means? Why is it there, and
> how is it supposed to be used? Why and how would a device/driver do
> something different for different protocols?

Thanks, Johannes

I should at least try :-) The given protocol can help the driver decide 
what actions should be taken. As an example, for a streaming protocol 
like Miracast [1] other wireless parameters/features may be changed as 
for DHCP.

> Also please document that the duration units is milliseconds. (both here
> and in the missing kernel-doc for the nl80211 attributes)
>

Will do.

>> +/**
>> + * cfg80211_crit_proto_stopped() - indicate critical protocol stopped by driver.
>> + *
>> + * @wdev: the wireless device for which critical protocol is stopped.
>> + *
>> + * This function can be called by the driver to indicate it has reverted
>> + * operation back to normal. One reason could be that the duration given
>> + * by .crit_proto_start() has expired.
>> + */
>> +void cfg80211_crit_proto_stopped(struct wireless_dev *wdev);
>
> May need gfp_t argument to send a netlink message?
>

So far, the is not netlink message being sent, but I guess we should.

>> @@ -1709,6 +1719,9 @@ enum nl80211_attrs {
>>   	NL80211_ATTR_MDID,
>>   	NL80211_ATTR_IE_RIC,
>>
>> +	NL80211_ATTR_CRIT_PROT_ID,
>> +	NL80211_ATTR_MAX_CRIT_PROT_DURATION,
>
> missing kernel-doc.

Will add that.

>> +/**
>> + * enum nl80211_crit_proto_id - nl80211 critical protocol identifiers
>> + *
>> + * @NL80211_CRIT_PROTO_UNSPEC: protocol unspecified.
>> + * @NL80211_CRIT_PROTO_BOOTP: BOOTP protocol.
>> + * @NL80211_CRIT_PROTO_EAPOL: EAPOL protocol.
>> + * @NL80211_CRIT_PROTO_ARP: ARP protocol for APIPA.
>
> Don't like IPv6? :-)

I am a dark-ages guy :-p I think I will rename the BOOTP one and 
indicate it should be used for BOOTP and DHCPv6.

>> + * @NL80211_CRIT_PROTO_LAST: must be kept last.
>
> shouldn't that be NUM_NL80211_CRIT_PROTO to be more like the (most)
> other enums?

Will do.

>> --- a/net/wireless/mlme.c
>> +++ b/net/wireless/mlme.c
>> @@ -648,6 +648,9 @@ void cfg80211_mlme_unregister_socket(struct wireless_dev *wdev, u32 nlportid)
>>
>>   	spin_unlock_bh(&wdev->mgmt_registrations_lock);
>>
>> +	if (rdev->ops->crit_proto_stop)
>> +		rdev_crit_proto_stop(rdev, wdev);
>
> This is broken, you're not checking that it's the correct socket.
> Therefore, if you run, for example, "iw wlan0 link" while the critical
> operation is ongoing it will be aborted.

I was wondering about that. Will change it checking nlportid, right?

>> +	duration = min_t(u16, duration, NL80211_MAX_CRIT_PROT_DURATION);
>
> Why not reject it if too large (although then the max should be defined
> in the header file)? Is there a reason, like maybe wanting to be able to
> increase the kernel value later? If so, might want to have a comment?

There were people in earlier discussions that considered a timeguard 
appropriate, ie. not trusting user-space. I do not have a strong opinion 
on this so....

>> +static int nl80211_crit_protocol_stop(struct sk_buff *skb,
>> +				      struct genl_info *info)
>> +{
>> +	struct cfg80211_registered_device *rdev = info->user_ptr[0];
>> +	struct wireless_dev *wdev = info->user_ptr[1];
>> +
>> +	if (!rdev->ops->crit_proto_stop)
>> +		return -EOPNOTSUPP;
>> +
>> +	rdev_crit_proto_stop(rdev, wdev);
>
> What if it's not even started?

That is handled in rdev_crit_proto_stop() itself.

>
>> +void cfg80211_crit_proto_stopped(struct wireless_dev *wdev)
>> +{
>> +	struct cfg80211_registered_device *rdev;
>> +
>> +	rdev = wiphy_to_dev(wdev->wiphy);
>> +	WARN_ON(!rdev->crit_proto_started);
>> +	rdev->crit_proto_started = false;
>> +}
>
> Oh, so you don't want to tell userspace?

Better we do, I guess.

> Do you expect drivers to call this function even when explicitly asked
> to stop? That should be documented then, I think.

No, I don't and I will add that in documentation.


