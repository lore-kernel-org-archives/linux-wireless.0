Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:65111 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbaLSJoJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2014 04:44:09 -0500
Message-ID: <5493F34A.4040500@broadcom.com> (sfid-20141219_104414_598659_BEB68890)
Date: Fri, 19 Dec 2014 10:43:38 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Gautam Kumar Shukla <gautams@broadcom.com>
Subject: Re: [RFC V2] cfg80211: Add feature flag for 4-way handshake offload
References: <1418935344-22159-1-git-send-email-arend@broadcom.com> <1418980707.1889.1.camel@sipsolutions.net>
In-Reply-To: <1418980707.1889.1.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/19/14 10:18, Johannes Berg wrote:
> On Thu, 2014-12-18 at 21:42 +0100, Arend van Spriel wrote:
>
>> +	u8 ext_features[(NUM_NL80211_EXT_FEATURES / 8) + 1];
>
> Should probably use DIV_ROUND_UP() here.

Will do.

>> +static inline bool
>> +wiphy_ext_feature_isset(struct wiphy *wiphy,
>> +			enum nl80211_ext_feature_index ftidx)
>> +{
>> +	u8 ft_byte;
>> +
>> +	ft_byte = wiphy->ext_features[ftidx / 8];
>> +	return (ft_byte&  BIT(ftidx % 8)) != 0;
>> +}
>
> Don't really need != 0 (but doesn't hurt either) since the type
> promotion is to bool in the return value.

It is a personal preference to use logical expression for a bool return.

>>   /**
>> + * enum nl80211_ext_feature_index - bit index of extended features.
>> + *
>> + * @NL80211_EXT_FEATURE_4WAY_HANDSHAKE: the device supports 4way handshake
>> + */
>> +enum nl80211_ext_feature_index {
>> +	NL80211_EXT_FEATURE_4WAY_HANDSHAKE,
>> +
>> +	/* add new features before the definition below */
>> +	NUM_NL80211_EXT_FEATURES,
>> +	MAX_NL80211_EXT_FEATURES = NUM_NL80211_EXT_FEATURES - 1
>> +};
>
> Don't think you need MAX_? Also you should add NUM_ to the documentation
> (and MAX_ also if you want to keep it)

True. Just added it for consistency with other enumerations. Maybe the 
API users can find good use for it ;-) I will add the kerneldoc.

>> +++ b/net/wireless/nl80211.c
>> @@ -1603,6 +1603,11 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
>>   		if (nla_put_u32(msg, NL80211_ATTR_FEATURE_FLAGS, features))
>>   			goto nla_put_failure;
>>
>> +		if (nla_put(msg, NL80211_ATTR_EXT_FEATURES,
>> +			    sizeof(rdev->wiphy.ext_features),
>> +			    rdev->wiphy.ext_features))
>> +			goto nla_put_failure;
>
> I don't think this should go here - I can see how it's tempting to put
> it with the feature flags but there's a size limit issue with the wiphy
> data on old userspace, so this should go towards the end to deal with
> the split data.

I suspected that. Will change it.

Regards,
Arend
