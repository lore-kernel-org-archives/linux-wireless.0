Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39529 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756505Ab2JXRir (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 13:38:47 -0400
Message-ID: <5088279E.70404@candelatech.com> (sfid-20121024_193857_980776_295B27BC)
Date: Wed, 24 Oct 2012 10:38:38 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/4] cfg80211: make TX power setting per interface
References: <1351073603-11616-1-git-send-email-johannes@sipsolutions.net>  <1351073603-11616-3-git-send-email-johannes@sipsolutions.net>  <50881709.4050405@candelatech.com> <1351099903.10709.8.camel@jlt4.sipsolutions.net>
In-Reply-To: <1351099903.10709.8.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/24/2012 10:31 AM, Johannes Berg wrote:
> On Wed, 2012-10-24 at 09:27 -0700, Ben Greear wrote:
>
>>> -static int ieee80211_get_tx_power(struct wiphy *wiphy, int *dbm)
>>> +static int ieee80211_get_tx_power(struct wiphy *wiphy,
>>> +				  struct wireless_dev *wdev,
>>> +				  int *dbm)
>>>    {
>>>    	struct ieee80211_local *local = wiphy_priv(wiphy);
>>
>> Do we really set mbm and read back dbm?
>
> Yeah, we did nl80211 APIs in mBm and reading back is only for wext
> compatibility so was dBm ... hindsight being 20/20 we should probably
> never have used mBm, nothing supports it anyway.

ath9k *could* support 1/2 dBm settings from what I remember, but
I am not sure there is any way to currently configure it for that.

>>> @@ -1588,6 +1588,11 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
>>>    		enum nl80211_tx_power_setting type;
>>>    		int idx, mbm = 0;
>>>
>>> +		if (!wdev) {
>>> +			result = -EOPNOTSUPP;
>>> +			goto bad_res;
>>> +		}
>>
>> I guess this is the part that breaks backwards compat when trying to set wiphy?
>> If it does stay like this, maybe add a WARN_ON_ONCE that tells users to fix their
>> user-space?
>
> Right. Add a user triggerable warning in code like that seems like a
> really bad idea to me though. Maybe a message, that seems to have some
> precedent, but I suppose nobody will really see it anyway?

WARN_ON_ONCE would be once per boot, and it shows stack (and calling user-space application).
It will show up in distribution bug reports automatically in some cases so calling
code might actually get fixed fairly quickly.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

