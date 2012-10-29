Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:50447 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755998Ab2J2QR5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2012 12:17:57 -0400
Message-ID: <508EAC30.8020600@candelatech.com> (sfid-20121029_171800_817844_B87D7987)
Date: Mon, 29 Oct 2012 09:17:52 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] wireless: Allow registering more than one beacon listener.
References: <1351288165-24219-1-git-send-email-greearb@candelatech.com>  (sfid-20121026_234937_894351_D69F960C) <1351501451.10925.6.camel@jlt4.sipsolutions.net>
In-Reply-To: <1351501451.10925.6.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/29/2012 02:04 AM, Johannes Berg wrote:
> Thanks Ben,
>
> I was going to apply this but it looks like I missed something on the
> previous review:
>
>>   void cfg80211_report_obss_beacon(struct wiphy *wiphy,
>>   				 const u8 *frame, size_t len,
>> -				 int freq, int sig_dbm, gfp_t gfp)
>> +				 int freq, int sig_dbm)
>>   {
>
> ...
>
>> +	spin_lock_bh(&rdev->beacon_registrations_lock);
> ...
>> +	spin_unlock_bh(&rdev->beacon_registrations_lock);
>
> I have a feeling this is incorrect, this is called with BHs disabled, so
> if we disable/enable BHs here we end up with BHs enabled even if the
> caller wanted them disabled, no?
>
> So I suppose unless we need to be able to call this from hard interrupt
> in some driver (unlikely) we should add a change like this:

I get confused with the various types of spin-locks,
and I just copied this code from the mgt frames logic.

I did run some tests and my code seems stable, but I could
just be getting lucky.

Do you want me to roll in your changes below and re-submit, or
do you want to just make the updates?

Thanks,
Ben

>
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 10a7f45..3b6a11a 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -3544,6 +3544,7 @@ void cfg80211_probe_status(struct net_device *dev, const u8 *addr,
>    * Use this function to report to userspace when a beacon was
>    * received. It is not useful to call this when there is no
>    * netdev that is in AP/GO mode.
> + * The function must be called with BHs disabled.
>    */
>   void cfg80211_report_obss_beacon(struct wiphy *wiphy,
>   				 const u8 *frame, size_t len,
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 15ddbb8..5ff24ef 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -8942,11 +8942,11 @@ void cfg80211_report_obss_beacon(struct wiphy *wiphy,
>
>   	trace_cfg80211_report_obss_beacon(wiphy, frame, len, freq, sig_dbm);
>
> -	spin_lock_bh(&rdev->beacon_registrations_lock);
> +	spin_lock(&rdev->beacon_registrations_lock);
>   	list_for_each_entry(reg, &rdev->beacon_registrations, list) {
>   		msg = nlmsg_new(len + 100, GFP_ATOMIC);
>   		if (!msg) {
> -			spin_unlock_bh(&rdev->beacon_registrations_lock);
> +			spin_unlock(&rdev->beacon_registrations_lock);
>   			return;
>   		}
>
> @@ -8966,11 +8966,11 @@ void cfg80211_report_obss_beacon(struct wiphy *wiphy,
>
>   		genlmsg_unicast(wiphy_net(&rdev->wiphy), msg, reg->nlportid);
>   	}
> -	spin_unlock_bh(&rdev->beacon_registrations_lock);
> +	spin_unlock(&rdev->beacon_registrations_lock);
>   	return;
>
>    nla_put_failure:
> -	spin_unlock_bh(&rdev->beacon_registrations_lock);
> +	spin_unlock(&rdev->beacon_registrations_lock);
>   	if (hdr)
>   		genlmsg_cancel(msg, hdr);
>   	nlmsg_free(msg);
>
>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

