Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:6213 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaLRPVn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 10:21:43 -0500
Message-ID: <5492F104.9020600@broadcom.com> (sfid-20141218_162146_350502_EFB4850D)
Date: Thu, 18 Dec 2014 16:21:40 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Eliad Peller <eliad@wizery.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Gautam Kumar Shukla <gautams@broadcom.com>
Subject: Re: [RFC] cfg80211: Add feature flag for 4-way handshake offload
References: <1418907095-10224-1-git-send-email-arend@broadcom.com> <CAB3XZEcF0r2fMD1GSw+ojWrsO7bxdxBfvQwLkZpTu4RP-iQtTg@mail.gmail.com>
In-Reply-To: <CAB3XZEcF0r2fMD1GSw+ojWrsO7bxdxBfvQwLkZpTu4RP-iQtTg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/18/14 14:44, Eliad Peller wrote:
> hi,
>
> On Thu, Dec 18, 2014 at 2:51 PM, Arend van Spriel<arend@broadcom.com>  wrote:
>> From: Gautam Kumar Shukla<gautams@broadcom.com>
>>
>> The new feature flag allows the driver to indicate that it can
>> offload the 4-way handshake for WPA/RSN-PSK. With the
>> wiphy::features flag being used up this patch adds a new
>> field wiphy::ext_features. Considering extensibility this
>> new field is declared as a byte array.
>>
>> Signed-off-by: Gautam (Gautam Kumar) Shukla<gautams@broadcom.com>
>> Signed-off-by: Arend van Spriel<arend@broadcom.com>
>> ---
>> Hi Johannes,
>>
>> Here the proposed way to deal with new feature flags. Let
>> me know if this is suitable.
>>
>> Regards,
>> Arend
>> ---
>
>> @@ -3122,6 +3124,7 @@ struct wiphy {
>>          u16 max_acl_mac_addrs;
>>
>>          u32 flags, regulatory_flags, features;
>> +       u8 ext_features[1];
>>
> i think it would be nicer to use unsigned long (instead of u8) along
> with BITS_TO_LONGS

Thanks, Eliad

I considered that, but decided against it. The main reason for me was 
the fact that this is passed in nl80211 attribute and using u8 seemed 
more straightforward to me. That said I think I will need to describe in 
nl80211 how the bits are ordered in the byte-array.

>>
>>   /**
>> + * enum nl80211_ext_feature_index - bit index of extended features.
>> + *
>> + * @NL80211_EXT_FEATURE_4WAY_HANDSHAKE: the device supports 4way handshake
>> + */
>> +enum nl80211_ext_feature_index {
>> +       NL80211_EXT_FEATURE_4WAY_HANDSHAKE,
>> +};
>
> just add the standard LAST/MAX defines here, and the bitmap size will
> be allocated automatically.

I thought that was only for attribute enumerations. This is a bit index 
within a attribute.

>>
>> +void cfg80211_ext_feature_set(struct wiphy *wiphy,
>> +                             enum nl80211_ext_feature_index ftidx)
>> +{
>> +       u8 *ft_byte;
>> +
>> +       ft_byte =&wiphy->ext_features[ftidx / 8];
>> +       *ft_byte |= BIT(ftidx % 8);
>> +}
>> +EXPORT_SYMBOL(cfg80211_ext_feature_set);
>> +
>> +bool cfg80211_ext_feature_isset(struct wiphy *wiphy,
>> +                               enum nl80211_ext_feature_index ftidx)
>> +{
>> +       u8 ft_byte;
>> +
>> +       ft_byte = wiphy->ext_features[ftidx / 8];
>> +       return (ft_byte&  BIT(ftidx % 8)) != 0;
>> +}
>> +EXPORT_SYMBOL(cfg80211_ext_feature_isset);
>
> and these (or only the implementations) could be replaced by set_bit/test_bit.

See above.

Regards,
Arend

> Eliad.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

