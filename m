Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:38601 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaLRQBH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 11:01:07 -0500
Received: by mail-ig0-f174.google.com with SMTP id hn15so1118281igb.7
        for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2014 08:01:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5492F104.9020600@broadcom.com>
References: <1418907095-10224-1-git-send-email-arend@broadcom.com>
	<CAB3XZEcF0r2fMD1GSw+ojWrsO7bxdxBfvQwLkZpTu4RP-iQtTg@mail.gmail.com>
	<5492F104.9020600@broadcom.com>
Date: Thu, 18 Dec 2014 18:01:04 +0200
Message-ID: <CAB3XZEdB7NWrgqqAR5jtEBkXbj6fxv1zdOX0M=r0TPE43b96tw@mail.gmail.com> (sfid-20141218_170111_551470_81672F13)
Subject: Re: [RFC] cfg80211: Add feature flag for 4-way handshake offload
From: Eliad Peller <eliad@wizery.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Gautam Kumar Shukla <gautams@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi Arend,

On Thu, Dec 18, 2014 at 5:21 PM, Arend van Spriel <arend@broadcom.com> wrote:
> On 12/18/14 14:44, Eliad Peller wrote:
>> On Thu, Dec 18, 2014 at 2:51 PM, Arend van Spriel<arend@broadcom.com>
>> wrote:
>>>
>>> From: Gautam Kumar Shukla<gautams@broadcom.com>
>>>
>>> The new feature flag allows the driver to indicate that it can
>>> offload the 4-way handshake for WPA/RSN-PSK. With the
>>> wiphy::features flag being used up this patch adds a new
>>> field wiphy::ext_features. Considering extensibility this
>>> new field is declared as a byte array.
>>>
>>> Signed-off-by: Gautam (Gautam Kumar) Shukla<gautams@broadcom.com>
>>> Signed-off-by: Arend van Spriel<arend@broadcom.com>
>>> ---
>>> Hi Johannes,
>>>
>>> Here the proposed way to deal with new feature flags. Let
>>> me know if this is suitable.
>>>
>>> Regards,
>>> Arend
>>> ---
>>
>>
>>> @@ -3122,6 +3124,7 @@ struct wiphy {
>>>          u16 max_acl_mac_addrs;
>>>
>>>          u32 flags, regulatory_flags, features;
>>> +       u8 ext_features[1];
>>>
>> i think it would be nicer to use unsigned long (instead of u8) along
>> with BITS_TO_LONGS
>
>
> Thanks, Eliad
>
> I considered that, but decided against it. The main reason for me was the
> fact that this is passed in nl80211 attribute and using u8 seemed more
> straightforward to me. That said I think I will need to describe in nl80211
> how the bits are ordered in the byte-array.
>
usually bitmaps are implemented by unsigned long array, but i didn't
consider that in this case the array is passed to userspace as well
(as you and Johannes pointed out).
adding a conversion function to nl80211 can do the trick, but i guess
simply using u8 instead in this case makes sense :)

>>>
>>>   /**
>>> + * enum nl80211_ext_feature_index - bit index of extended features.
>>> + *
>>> + * @NL80211_EXT_FEATURE_4WAY_HANDSHAKE: the device supports 4way
>>> handshake
>>> + */
>>> +enum nl80211_ext_feature_index {
>>> +       NL80211_EXT_FEATURE_4WAY_HANDSHAKE,
>>> +};
>>
>>
>> just add the standard LAST/MAX defines here, and the bitmap size will
>> be allocated automatically.
>
>
> I thought that was only for attribute enumerations. This is a bit index
> within a attribute.
>
it's usually not needed, but in this case it will allow defining
ext_features with proper length automatically.

Eliad.
